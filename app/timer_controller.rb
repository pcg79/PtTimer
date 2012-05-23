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

    corner_radius = 8.0

    @start_button = create_button normal_state_title: 'Start',
                                  selected_state_title: 'Stop',
                                  action: 'timers_started',
                                  frame: [[margin, 360], [145, 40]],
                                  backgroundColor: UIColor.greenColor,
                                  cornerRadius: corner_radius

    @reset_button = create_button normal_state_title: 'Reset',
                                  action: 'reset_timers',
                                  frame: [[margin + 155, 360], [145, 40]],
                                  backgroundColor: UIColor.redColor,
                                  cornerRadius: corner_radius
  end

  def timers_started
    if @timer
      timer_reset
    else
      @duration ||= @durations[@current_timer]
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
    @start_button.selected = !@start_button.selected?
    @start_button.backgroundColor = @start_button.selected? ? UIColor.redColor : UIColor.greenColor
  end

  def reset_timers
    timer_reset
    @current_timer = 0
    @duration = nil
    reset_timer_displays
    @start_button.selected = false
    @start_button.backgroundColor = UIColor.greenColor
    set_reps 0
  end

  def timer_reset
    @timer.invalidate if @timer
    @timer = nil
  end

  def timerFired
    if @duration <= 0.1
      reset_display(@current_timer)
      increment_reps if @current_timer == 0
      play_sound(@sound_ids[@current_timer])
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
    @duration  = @durations[0]
    @displays  = [@timer1_display, @timer2_display]
    @sounds    = ['tng-doorbell.wav', 'tos-computer-02.mp3']

    @sound_ids = @sounds.each.map do |file|
      name, ext = file.split('.')
      soundPath = NSBundle.mainBundle.pathForResource name, ofType: ext
      sound_ptr = Pointer.new(:uint)
      AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(soundPath), sound_ptr)
      sound_ptr[0]
    end

    set_reps 0
    navigationItem.title = @exercise.name
    reset_timer_displays
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

  def create_button(params)
    button = UIButton.new
    button.setTitle(params[:normal_state_title], forState:UIControlStateNormal)
    button.setTitle(params[:selected_state_title], forState:UIControlStateSelected) if params[:selected_state_title]
    button.addTarget(self, action: params[:action], forControlEvents:UIControlEventTouchUpInside)
    button.backgroundColor = params[:backgroundColor] if params[:backgroundColor]
    button.layer.cornerRadius = params[:cornerRadius] if params[:cornerRadius]
    button.frame = params[:frame]
    view.addSubview(button)
    button
  end

  def reset_display(index)
    set_timer_display(@displays[index], @durations[index])
  end

  def reset_timer_displays
    set_timer_display(@displays[0], @durations[0])
    set_timer_display(@displays[1], @durations[1])
  end

  def increment_reps
    @num_reps += 1
    @num_reps_display.text = @num_reps.to_s
  end

  def play_sound(sound_id)
    AudioServicesPlaySystemSound(sound_id)
  end

  def set_reps(number)
    @num_reps = number
    @num_reps_display.text = @num_reps.to_s
  end
end
