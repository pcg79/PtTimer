$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'PtTimer'
  app.frameworks += ['CoreData', 'AudioToolbox']
  app.device_family = [:iphone, :ipad]

  app.codesign_certificate = 'iPhone Developer: Pat George'
end
