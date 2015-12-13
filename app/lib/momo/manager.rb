module Momo
  class Manager
    attr_accessor :on_motion

    def initialize
      params.each { |key, value| send("#{key}=", value) }
      self
    end

    def on_motion=(on_motion)
      fail(ArgumentError, "Must provide proc") unless on_motion.is_a?(Proc)
      @on_motion = on_motion
    end

    def update!
      manager.startActivityUpdatesToQueue(queue, withHandler: handle_activity)
    end

    private

    def handle_activity(activity)
      motion = create_from_cm_motion_activity(activity)
      @on_motion.call(motion) unless @on_motion.nil?
    end

    def manager
      @manager ||= begin
        manager = CMMotionActivityManager.new
        manager
      end
    end

    def queue
      @queue ||= begin
        queue = NSOperationQueue.new
        queue.name = "Motion activity queue"
        queue.maxConcurrentOperationCount = 1

        queue
      end
    end
  end
end
