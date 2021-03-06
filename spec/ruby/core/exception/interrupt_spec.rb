require_relative '../../spec_helper'

describe "Interrupt.new" do
  it "returns an instance of interrupt with no message given" do
    e = Interrupt.new
    e.signo.should == Signal.list["INT"]
    e.signm.should == "Interrupt"
  end

  it "takes an optional message argument" do
    e = Interrupt.new("message")
    e.signo.should == Signal.list["INT"]
    e.signm.should == "message"
  end
end

describe "rescuing Interrupt" do
  before do
    @original_sigint_proc = Signal.trap(:INT, :SIG_DFL)
  end

  after do
    Signal.trap(:INT, @original_sigint_proc)
  end

  it "raises an Interrupt when sent a signal SIGINT" do
    begin
      Process.kill :INT, Process.pid
      sleep
    rescue Interrupt => e
      e.signo.should == Signal.list["INT"]
      e.signm.should == ""
    end
  end
end
