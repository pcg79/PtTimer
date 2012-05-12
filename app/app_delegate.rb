class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    nav = UINavigationController.alloc.initWithRootViewController(PtTimerController.alloc.init)
    nav.wantsFullScreenLayout = true
    nav.toolbarHidden = true
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end

  def exercise_controller
    @exercise_controller ||= ExerciseController.alloc.init
  end
end
