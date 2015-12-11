# Locations Controller
class LocationsController < UIViewController
  extend IB

  def viewDidLoad
    manager.after_authorize = lambda do |authorized|
      start! if authorized
    end

    manager.on_update = lambda { |locations| update_locations(locations) }
    manager.on_visit = lambda { |locations| update_visit(visit) }

    if manager.authorized?
      start!
    else
      manager.authorize!
    end
  end

  def start!
    # manager.start!
    manager.update_significant!
    manager.update_visits!
  end

  def update_locations(locations)
    locations.each do |location|
      firebase.childByAppendingPath(UIDevice.currentDevice.name)
              .childByAppendingPath("locations")
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

  def update_visit(visit)
    firebase.childByAppendingPath(UIDevice.currentDevice.name)
            .childByAppendingPath("visits")
            .childByAutoId
            .setValue(
              latitude: visit.latitude,
              longitude: visit.longitude,
              departed_at: location.departed_at.to_i,
              arrived_at: location.arrived_at.to_i,
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
      distance_filter: 50
    )
  end
end
