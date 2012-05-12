class PtTimerController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Exercises'
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addExercise')
    # TODO: Only reloadData when coming back from a save call, not cancel.
    view.reloadData
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
    @date_formatter ||= NSDateFormatter.alloc.init.tap do |df|
      df.timeStyle = NSDateFormatterMediumStyle
      df.dateStyle = NSDateFormatterMediumStyle
    end

    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
     end
    exercise = ExercisesStore.shared.exercises[indexPath.row]

    cell.textLabel.text = exercise.name
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

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    exercise = ExercisesStore.shared.exercises[indexPath.row]
    controller = UIApplication.sharedApplication.delegate.timer_controller
    navigationController.pushViewController(controller, animated:true)
    controller.showExercise(exercise)
  end
end
