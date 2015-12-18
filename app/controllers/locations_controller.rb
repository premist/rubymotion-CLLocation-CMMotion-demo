# Locations Controller
class LocationsController < UIViewController
  extend IB

  def viewDidLoad
    manager.after_authorize = lambda do |authorized|
      start! if authorized
    end

    manager.on_update = lambda do |locations|
      RavenClient.sharedClient.captureMessage("Received locations event")
      update_locations(locations)
    end

    manager.on_visit = lambda do |visit|
      RavenClient.sharedClient.captureMessage("Received on_visit event")
      update_visit(visit)
    end

    unless manager.authorized?
      manager.authorize!
    end

    start!

    motion_manager.on_motion = lambda do |motion|
      RavenClient.sharedClient.captureMessage("Received on_motion event")
      update_motion(motion)
    end

    motion_manager.update!
  end

  def start!
    # manager.start!
    manager.update!
    manager.update_significant!
    manager.update_visits!
  end

  def update_locations(locations)
    locations.each do |location|
      firebase.childByAppendingPath(UIDevice.currentDevice.name)
              .childByAppendingPath("locations_always")
              .childByAutoId.setValue(
                latitude: location.latitude,
                longitude: location.longitude,
                altitude: location.altitude,
                floor: location.floor,
                accuracy: location.accuracy,
                altitude_accuracy: location.altitude_accuracy,
                determined_at: location.determined_at.to_i,
                created_at: Time.now.to_i
              )
    end
  end

  def update_motion(motion)
    firebase.childByAppendingPath(UIDevice.currentDevice.name)
            .childByAppendingPath("motions")
            .childByAutoId
            .setValue(
              types: motion.types,
              confidence: motion.confidence,
              at: motion.at.to_i,
              created_at: Time.now.to_i
            )
  end

  def update_visit(visit)
    firebase.childByAppendingPath(UIDevice.currentDevice.name)
            .childByAppendingPath("visits")
            .childByAutoId
            .setValue(
              latitude: visit.latitude,
              longitude: visit.longitude,
              departed_at: visit.departed_at.to_i,
              arrived_at: visit.arrived_at.to_i,
              created_at: Time.now.to_i
            )
  end

  private

  def firebase
    @firebase ||= Firebase.alloc.initWithUrl(App::Env["FIREBASE_URL"])
  end

  def manager
    @manager ||= Locman::Manager.new(
      background: true,
      distance_filter: 20
    )
  end

  def motion_manager
    @motion_manager ||= Momo::Manager.new
  end
end
