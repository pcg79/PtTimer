class TimerController < UIViewController
  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
  end

  def viewDidLoad
    margin = 10

    @timer1_label = UILabel.new
    @timer1_label.font = UIFont.systemFontOfSize(30)
    @timer1_label.text = 'Timer 1'
    @timer1_label.textAlignment = UITextAlignmentCenter
    @timer1_label.textColor = UIColor.blackColor
    @timer1_label.backgroundColor = UIColor.clearColor
    @timer1_label.frame = [[margin, 20], [300, 30]]
    view.addSubview(@timer1_label)

    @timer1_display = UILabel.new
    @timer1_display.font = UIFont.systemFontOfSize(30)
    @timer1_display.textAlignment = UITextAlignmentCenter
    @timer1_display.textColor = UIColor.blackColor
    @timer1_display.backgroundColor = UIColor.clearColor
    @timer1_display.frame = [[margin, 60], [300, 30]]
    view.addSubview(@timer1_display)

    @timer2_label = UILabel.new
    @timer2_label.font = UIFont.systemFontOfSize(30)
    @timer2_label.text = 'Timer 2'
    @timer2_label.textAlignment = UITextAlignmentCenter
    @timer2_label.textColor = UIColor.blackColor
    @timer2_label.backgroundColor = UIColor.clearColor
    @timer2_label.frame = [[margin, 100], [300, 30]]
    view.addSubview(@timer2_label)

    @timer2_display = UILabel.new
    @timer2_display.font = UIFont.systemFontOfSize(30)
    @timer2_display.textAlignment = UITextAlignmentCenter
    @timer2_display.textColor = UIColor.blackColor
    @timer2_display.backgroundColor = UIColor.clearColor
    @timer2_display.frame = [[margin, 140], [300, 30]]
    view.addSubview(@timer2_display)

    @start_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @start_button.setTitle('Start', forState:UIControlStateNormal)
    @start_button.setTitle('Stop', forState:UIControlStateSelected)
    @start_button.addTarget(self, action:'timers_started', forControlEvents:UIControlEventTouchUpInside)
    @start_button.frame = [[margin, 360], [300, 40]]
    view.addSubview(@start_button)
  end

  def timers_started
    if @timer1 || @timer2
      resetTimers
    else
      @duration1 = @exercise.timer_one
      @duration2 = @exercise.timer_two
      startTimerOne
    end
    @start_button.selected = !@start_button.selected?
  end

  def timerFired
    if @duration1 <= 0.1
      resetTimerOne
      startTimerTwo
      # @start_button.selected = false
    elsif @duration2 <= 0.1
      resetTimerTwo
      startTimerOne
    end

    if @timer1
      timer_display = @timer1_display
      duration = @duration1 -= 0.1
    else
      timer_display = @timer2_display
      duration = @duration2 -= 0.1
    end

    setTimerDisplay(timer_display, duration)
  end

  def startTimerOne
    @timer1 = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
  end

  def resetTimerOne
    @timer1.invalidate
    @timer1 = nil
    setTimerDisplay(@timer1_display, @exercise.timer_one)
    @duration1 = @exercise.timer_one
  end

  def startTimerTwo
    @timer2 = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
  end

  def resetTimerTwo
    @timer2.invalidate
    @timer2 = nil
    setTimerDisplay(@timer2_display, @exercise.timer_two)
    @duration2 = @exercise.timer_two
  end

  def resetTimers
    @timer1.invalidate if @timer1
    @timer2.invalidate if @timer2
    @timer1 = @timer2 = nil
  end

  # def viewWillAppear(animated)
  #   navigationController.setNavigationBarHidden(false, animated:true)
  # end

  def showExercise(exercise)
    @exercise = exercise
    navigationItem.title = @exercise.name
    setTimerDisplay(@timer1_display, @exercise.timer_one)
    setTimerDisplay(@timer2_display, @exercise.timer_two)
  end

  def setTimerDisplay(timer_display, time)
    timer_display.text = "%.1f" % time
  end
end