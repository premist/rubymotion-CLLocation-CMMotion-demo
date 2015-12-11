# App Delegate
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    storyboard = UIStoryboard.storyboardWithName("Storyboard", bundle: nil)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = storyboard.instantiateInitialViewController
    @window.makeKeyAndVisible

    true
  end
end
