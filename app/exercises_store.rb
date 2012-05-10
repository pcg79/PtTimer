class ExercisesStore
  def self.shared
    # Our store is a singleton object.
    @shared ||= ExercisesStore.new
  end

  def exercises
    @exercises ||= begin
      # Fetch all Exercises from the model, sorting by the creation date.
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Exercise', inManagedObjectContext:@context)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('creation_date', ascending:false)]

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end

  def add_exercise
    # Yield a blank, newly created Exercise entity, then save the model.
    yield NSEntityDescription.insertNewObjectForEntityForName('Exercise', inManagedObjectContext:@context)
    save
  end

  def remove_exercise(exercise)
    # Delete the given entity, then save the model.
    @context.deleteObject(exercise)
    save
  end

  private

  def initialize
    # Create the model programmatically. Our model has only one entity, the Exercise class, and the data will be stored in a SQLite database, inside the application's Documents folder.
    model = NSManagedObjectModel.alloc.init
    model.entities = [Exercise.entity]

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'PtTimer.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @exercises = nil
  end
end
