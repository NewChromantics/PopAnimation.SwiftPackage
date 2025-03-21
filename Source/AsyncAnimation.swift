import SwiftUI
import RiveRuntime
import PopCommon

open class AsyncAnimation : RiveViewModel 
{
	var finishedPromise = Promise<Bool>()
	var allowDismissWithClick = false
	
	public init(_ filename:String,bundle:Bundle=Bundle.main,artboardName:String="Artboard") throws
	{
		//	rive runtime brings down the app if the filename is missing from the bundle,
		//	so setup the model ourselves (and dont use try!)
		//super.init(fileName: filename,in:bundle,artboardName: artboardName)
		let model = try RiveModel(fileName: filename, extension:"riv", in: bundle)
		super.init(model,artboardName: artboardName)
	}
	
	@ViewBuilder func someView() -> some View
	{
		Rectangle()
			.foregroundColor(.clear)
			.contentShape(Rectangle())		//	make clickable
			.onTapGesture
		{
			if self.allowDismissWithClick
			{
				print("Animation clicked")
				self.finishedPromise.resolve(true)
			}
		}
		.background
		{
			super.view()
		}
		.frame(maxWidth: .infinity,maxHeight: .infinity)
	}
	
	open override func view() -> AnyView
	{
		return AnyView( someView() )
	}
	
	// When an animation is played
	open override func player(playedWithModel riveModel: RiveModel?)
	{
	}
	
	open override func player(stoppedWithModel riveModel: RiveModel?) 
	{
		//print("stopped")
		finishedPromise.resolve(true)
	}
	
	open override func player(loopedWithModel riveModel: RiveModel?, type: Int) 
	{
		print("looped type=\(type)")
		//finishedPromise.resolve(true)
	}
	
	//	gets called when an anim finishes
	open override func player(pausedWithModel riveModel: RiveModel?) 
	{
		//print("paused")
		finishedPromise.resolve(true)
	}
	
	public func finish()
	{
		finishedPromise.resolve(true)
	}
	
	//	play and wait for it to finish
	public func playAndWait(loopMode:RiveLoop=RiveLoop.oneShot,allowDismissWithClick:Bool) async
	{
		do
		{
			self.allowDismissWithClick = allowDismissWithClick
			self.play( loop: loopMode )
			_ = try await finishedPromise.Wait()
		}
		catch
		{
			print("Animation finished error; \(error.localizedDescription)")
		}
	}
	
}
