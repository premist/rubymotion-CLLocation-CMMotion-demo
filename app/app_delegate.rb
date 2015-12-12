# App Delegate
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # Set up Raven for Objective-C
    client = RavenClient.clientWithDSN(App::Env["SENTRY_DSN"])
    client.setupExceptionHandler

    RavenClient.setSharedClient(client)
    RavenClient.sharedClient.captureMessage("Application launched")

    storyboard = UIStoryboard.storyboardWithName("Storyboard", bundle: nil)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = storyboard.instantiateInitialViewController
    @window.makeKeyAndVisible

    true
  end
end
