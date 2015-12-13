module Momo
  class Motion
    attr_accessor :types, :confidence, :at

    ACTIVITY_TYPES = [
      :stationary,
      :walking,
      :running,
      :automotive,
      :cycling,
      :unknown
    ]

    CONFIDENCE_MAP = {
      low: CMMotionActivityConfidenceLow,
      medium: CMMotionActivityConfidenceMedium,
      high: CMMotionActivityConfidenceHigh
    }

    def self.create_from_cm_motion_activity(cm_motion)
      types = ACTIVITY_TYPES.select { |type| cm_motion.send(type) }

      Momo::Motion.new(
        types: types,
        confidence: CONFIDENCE_MAP.key(cm_motion.confidence),
        at: cm_motion.startDate
      )
    end

    def initialize(options = {})
      options.each { |key, value| send("#{key}=", value) }
      self
    end
  end
end
