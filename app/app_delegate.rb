class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = PtTimerController.alloc.init
    # @window.rootViewController.wantsFullScreenLayout = true
    # @window.makeKeyAndVisible
    # true
    nav = UINavigationController.alloc.initWithRootViewController(PtTimerController.alloc.init)
    nav.wantsFullScreenLayout = true
    nav.toolbarHidden = true
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end
end
