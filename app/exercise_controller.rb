class ExerciseController < UIViewController
  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
  end

  # TODO: Replace w/ nib, I guess.  Or just make it prettier in general.
  def viewDidLoad
    @name = UITextField.new
    @name.font = UIFont.systemFontOfSize(20)
    @name.placeholder = 'Enter exercise name'
    @name.textAlignment = UITextAlignmentCenter
    @name.textColor = UIColor.blackColor
    @name.backgroundColor = UIColor.grayColor
    @name.borderStyle = UITextBorderStyleRoundedRect
    @name.frame = [[10, 20], [300, 30]]
    view.addSubview(@name)

    @timer1 = UITextField.new
    @timer1.font = UIFont.systemFontOfSize(20)
    @timer1.placeholder = 'Enter hold time'
    @timer1.textAlignment = UITextAlignmentCenter
    @timer1.textColor = UIColor.blackColor
    @timer1.backgroundColor = UIColor.grayColor
    @timer1.borderStyle = UITextBorderStyleRoundedRect
    @timer1.keyboardType = UIKeyboardTypeNumberPad
    @timer1.frame = [[10, 60], [300, 30]]
    view.addSubview(@timer1)

    @timer2 = UITextField.new
    @timer2.font = UIFont.systemFontOfSize(20)
    @timer2.placeholder = 'Enter reset time'
    @timer2.textAlignment = UITextAlignmentCenter
    @timer2.textColor = UIColor.blackColor
    @timer2.backgroundColor = UIColor.grayColor
    @timer2.borderStyle = UITextBorderStyleRoundedRect
    @timer2.keyboardType = UIKeyboardTypeNumberPad
    @timer2.frame = [[10, 100], [300, 30]]
    view.addSubview(@timer2)
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Exercise'
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')

    navigationController.setNavigationBarHidden(false, animated:true)

    # TODO: Is this the best way to clear the text fields?
    @name.text = @timer1.text = @timer2.text = nil
  end

  def cancel
    navigationController.popViewControllerAnimated(true)
  end

  def save
    # TODO: Is this the best way to hide the keyboard?
    @name.resignFirstResponder
    @timer1.resignFirstResponder
    @timer2.resignFirstResponder

    # TODO: Prompt user with a small error msg if they don't put in a name (or timer_one, timer_two?)
    return if !@name.text || @name.text.length < 1

    ExercisesStore.shared.add_exercise do |exercise|
      exercise.creation_date = NSDate.date
      exercise.name = @name.text
      exercise.timer_one = @timer1.text.to_i
      exercise.timer_two = @timer2.text.to_i
    end
    navigationController.popViewControllerAnimated(true)
  end
end
