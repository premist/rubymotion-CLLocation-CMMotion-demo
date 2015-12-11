describe AppDelegate do
  describe "#application:didFinishLaunchingWithOptions:" do
    before do
      @application = UIApplication.sharedApplication
    end

    it "makes the window key" do
      @application.windows.first.isKeyWindow.should.be.true
    end

    it "sets the root view controller" do
      @application.windows.first.rootViewController.should.be.instance_of LocationsController
    end
  end
end
