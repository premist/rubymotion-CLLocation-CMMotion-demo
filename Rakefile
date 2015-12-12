# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/ios"

begin
  require "bundler"
  Bundler.require
rescue LoadError
  puts "Error: failed to load Bundler gems."
end

env_vars = Dotenv.load

Motion::Project::App.setup do |app|
  app.name = "rubymotion-clvisit-demo"
  app.frameworks += %w(CoreLocation CoreMotion)

  app.identifier = ENV["APP_IDENTIFIER"]

  app.pods do
    pod "Firebase"
    pod "Raven"
  end

  app.provisioning_profile = ENV["PROVISIONING_PROFILE"]
  app.codesign_certificate = ENV["CODESIGN_CERTIFICATE"]

  app.info_plist["NSLocationAlwaysUsageDescription"] = "We would like to sell your location data to Google."
  app.info_plist["NSLocationWhenInUseUsageDescription"] = "We would like to sell your location data to Google."
  app.info_plist["NSMotionUsageDescription"] = "We would like to sell your motion data to Xiaomi."
  app.info_plist["UIBackgroundModes"] = ["location"]

  # Load environment variables
  env_vars.each { |key, value| app.info_plist["ENV_#{key}"] = value }
end
