class ExerciseController < UIViewController
  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
  end

  # TODO: Replace w/ nib, I guess.  Or just make it prettier in general.
  def viewDidLoad
    margin = 10
    @picker_data = (0..60).to_a
    @picker = UIPickerView.new
    @picker.delegate = self

    @name   = create_text_field(placeholder: 'Enter exercise name', frame: [[margin, 20], [300, 30]])
    @timer1 = create_text_field(placeholder: 'Enter hold time', keyboardType: UIKeyboardTypeNumberPad, frame: [[margin, 60], [300, 30]])
    @timer2 = create_text_field(placeholder: 'Enter reset time', keyboardType: UIKeyboardTypeNumberPad, frame: [[margin, 100], [300, 30]])

    @timer1.setInputView(@picker)
    @timer2.setInputView(@picker)
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Exercise'
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')

    navigationController.setNavigationBarHidden(false, animated:true)

    # TODO: Is this the best way to clear the text fields?
    @name.text = @timer1.text = @timer2.text = nil
    @picker.selectRow(0, inComponent:0, animated: false)
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

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent:component)
    @picker_data.size
  end

  def pickerView(pickerView, titleForRow:row, forComponent:component)
    @picker_data[row].to_s
  end

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    row = row.to_s
    if @timer1.isFirstResponder
      @timer1.text = row
    elsif @timer2.isFirstResponder
      @timer2.text = row
    end
  end

private

  def create_text_field(params)
    text_field = UITextField.new
    text_field.font = UIFont.systemFontOfSize(20)
    text_field.placeholder = params[:placeholder]
    text_field.textAlignment = UITextAlignmentCenter
    text_field.textColor = UIColor.blackColor
    text_field.backgroundColor = UIColor.grayColor
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.keyboardType = params[:keyboardType] if params[:keyboardType]
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end
end
