class Exercise < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Exercise'
      entity.managedObjectClassName = 'Exercise'
      entity.properties =
        { 'creation_date' => NSDateAttributeType,
          'name'          => NSStringAttributeType,
          'timer_one'     => NSInteger16AttributeType,
          'timer_two'     => NSInteger16AttributeType }.each.map do |name, type|
            property = NSAttributeDescription.alloc.init
            property.name = name
            property.attributeType = type
            property.optional = false
            property
          end
      entity
    end
  end
end
