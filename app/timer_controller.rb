class TimerController < UIViewController
  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
  end

  def viewDidLoad
    margin = 10

    create_label text: 'Hold for:', frame: [[margin, 20], [300, 30]]
    create_label text: 'Start again in:', frame: [[margin, 100], [300, 30]]
    create_label text: 'Number of Reps:', frame: [[margin, 200], [300, 30]]

    @timer1_display   = create_label frame: [[margin, 60], [300, 30]]
    @timer2_display   = create_label frame: [[margin, 140], [300, 30]]
    @num_reps_display = create_label frame: [[margin, 240], [300, 30]]

    @start_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @start_button.setTitle('Start', forState:UIControlStateNormal)
    @start_button.setTitle('Stop', forState:UIControlStateSelected)
    @start_button.addTarget(self, action:'timers_started', forControlEvents:UIControlEventTouchUpInside)
    @start_button.frame = [[margin, 360], [300, 40]]
    view.addSubview(@start_button)
  end

  def timers_started
    if @timer
      reset_timer
    else
      @duration = @durations[@current_timer]
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
    @start_button.selected = !@start_button.selected?
  end

  def timerFired
    if @duration <= 0.1
      reset_display(@current_timer)
      increment_reps if @current_timer == 0
      play_sound(*@sounds[@current_timer].split('.'))
      @current_timer = (@current_timer + 1) % @durations.size
      @duration = @durations[@current_timer]
    end

    if @timer
      timer_display = @displays[@current_timer]
      duration = @duration -= 0.1
    end

    set_timer_display(timer_display, duration)
  end

  def show_exercise(exercise)
    @exercise = exercise
    @current_timer = 0
    @durations = [@exercise.timer_one, @exercise.timer_two]
    @displays  = [@timer1_display, @timer2_display]
    @sounds    = ['tng-doorbell.wav', 'tos-computer-02.mp3']
    @num_reps = 0
    @num_reps_display.text = @num_reps.to_s
    navigationItem.title = @exercise.name
    set_timer_display(@displays[0], @durations[0])
    set_timer_display(@displays[1], @durations[1])
  end

private

  def set_timer_display(timer_display, time)
    timer_display.text = "%.1f" % time
  end

  def create_label(params)
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(25)
    label.text = params[:text]
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.blackColor
    label.backgroundColor = UIColor.clearColor
    label.frame = params[:frame]
    view.addSubview(label)
    label
  end

  def reset_display(index)
    set_timer_display(@displays[index], @durations[index])
  end

  def reset_timer
    @timer.invalidate
    @timer = nil
  end

  def increment_reps
    @num_reps += 1
    @num_reps_display.text = @num_reps.to_s
  end

  def play_sound(name, ext)
    soundPath = NSBundle.mainBundle.pathForResource name, ofType: ext
    sound_ptr = Pointer.new(:uint)
    AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(soundPath), sound_ptr)
    sound_id = sound_ptr[0]
    AudioServicesPlaySystemSound(sound_id)
  end
end
