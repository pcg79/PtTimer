class ExerciseController < UIViewController
  def loadView
    self.view = UIWebView.alloc.init
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Exercise'
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'createExercise')

    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def showTimer(exercise)
    navigationItem.title = exercise.name
  end

  def cancel
    # controller = UIApplication.sharedApplication.delegate.exercise_controller
    puts "*** [ExerciseController.cancel] - 2"
    navigationController.popViewControllerAnimated(true)
  end

  def createExercise
    puts "*** [ExerciseController.createExercise] - Got here"
  end
end