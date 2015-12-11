# Locations Controller
class LocationsController < UIViewController
  extend IB

  def viewDidLoad
    @firebase = Firebase.alloc.initWithUrl(App::Env["FIREBASE_URL"])

    @manager = Locman::Manager.new(
      background: true,
      distance_filter: 50
    )

    @manager.after_authorize = lambda do |authorized|
      @manager.start! if authorized
    end

    @manager.on_update = lambda { |locations| update_locations(locations) }
    @manager.on_visit = lambda { |locations| update_visit(visit) }

    if @manager.authorized?
      @manager.start_monitor!
      @manager.start_monitor_visits!
    else
      @manager.authorize!
    end

    # if CMMotionActivityManager.isActivityAvailable
    #   @motion_manager = CMMotionActivityManager.new
    #   @motion_manager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue, withHandler: lambda do |activity|
    #     if activity.stationary
    #       motion = "stationary"
    #     elsif activity.walking
    #       motion = "walking"
    #     elsif activity.running
    #       motion = "running"
    #     elsif activity.automotive
    #       motion = "automotive"
    #     elsif activity.cycling
    #       motion = "cycling"
    #     else
    #       motion = "unknown"
    #     end

    #     if activity.confidence == CMMotionActivityConfidenceLow
    #       confidence = "low"
    #     elsif activity.confidence == CMMotionActivityConfidenceMedium
    #       confidence = "medium"
    #     elsif activity.confidence == CMMotionActivityConfidenceHigh
    #       confidence = "high"
    #     else
    #       confidence = "unknown"
    #     end

    #     @firebase.childByAppendingPath("gotMotionActivity").childByAutoId.setValue(
    #       motion: motion,
    #       confidence: confidence,
    #       start_date: activity.startDate.to_i
    #     )
    #   end)
    # end
  end

  # def locationManager(manager, didChangeAuthorizationStatus: status)
  #   if status == KCLAuthorizationStatusAuthorized
  #     manager.distanceFilter = 30
  #     manager.allowsBackgroundLocationUpdates = true
  #     manager.startUpdatingLocation
  #     manager.startMonitoringSignificantLocationChanges
  #     manager.startMonitoringVisits
  #   end
  # end

  def update_locations(locations)
    puts "---- LOCATIONKEY ----"
    p UIApplicationLaunchOptionsLocationKey
    puts "---- LOCATIONKEY END ----"

    locations.each do |location|
      @firebase.childByAppendingPath("locations").childByAutoId.setValue(
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
    @firebase.childByAppendingPath("visits").childByAutoId.setValue(
      latitude: visit.latitude,
      longitude: visit.longitude,
      departed_at: location.departed_at.to_i,
      arrived_at: location.arrived_at.to_i,
      created_at: Time.now.to_i
    )
  end

  # def locationManager(manager, didVisit: visit)
  #   @firebase.childByAppendingPath("didVisit").childByAutoId.setValue(
  #     event_type: "didVisit",
  #     latitude: visit.coordinate.latitude,
  #     longitude: visit.coordinate.longitude,
  #     departure_date: visit.departureDate.to_i,
  #     arrival_date: visit.arrivalDate.to_i,
  #     created_at: Time.now.to_i
  #   )
  # end
end
