class PtTimerController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Exercises'
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addExercise')

    # The Add button is disabled by default, and will be enabled once the location manager is ready to return the current location.
    navigationItem.rightBarButtonItem.enabled = true
    # @exercise_manager ||= CLLocationManager.alloc.init.tap do |lm|
    #   lm.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
    #   lm.startUpdatingLocation
    #   lm.delegate = self
    # end
  end

  def addExercise
    controller = UIApplication.sharedApplication.delegate.exercise_controller
    navigationController.pushViewController(controller, animated:true)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    ExercisesStore.shared.exercises.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    exercise = ExercisesStore.shared.exercises[indexPath.row]

    @date_formatter ||= NSDateFormatter.alloc.init.tap do |df|
      df.timeStyle = NSDateFormatterMediumStyle
      df.dateStyle = NSDateFormatterMediumStyle
    end
    cell.textLabel.text = @date_formatter.stringFromDate(exercise.creation_date)
    cell.detailTextLabel.text = exercise.name
    cell
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    exercise = ExercisesStore.shared.exercises[indexPath.row]
    ExercisesStore.shared.remove_exercise(exercise)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  # def exerciseManager(manager, didUpdateToExercise:newExercise, fromExercise:oldExercise)
  #   navigationItem.rightBarButtonItem.enabled = true
  # end
  #
  # def exerciseManager(manager, didFailWithError:error)
  #   navigationItem.rightBarButtonItem.enabled = false
  # end

  def timerFired
    @state.text = "%.1f" % (@duration += 0.1)
  end

  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    entered_text = alertView.textFieldAtIndex(0).text
    puts "Entered: #{entered_text}"

    return if entered_text.length < 1

    ExercisesStore.shared.add_exercise do |exercise|
      # We set up our new Exercise object here.
      exercise.creation_date = NSDate.date
      exercise.name = entered_text
    end
    view.reloadData
  end
end