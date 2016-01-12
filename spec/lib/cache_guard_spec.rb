require "spec_helper"
require "cache_guard"

describe CacheGuard do
  describe "#guard" do
    let(:cache_store){ double("Cache", :delete => true) }
    subject{ described_class.new("guard", :cache_store => cache_store) }

    context "when able to acquire guard" do
      before do
        allow(cache_store).to receive(:increment).and_return(1)
      end

      it "executes the given block" do
        expect{ |probe| subject.guard(&probe) }.to yield_control
      end

      it "releases on success" do
        subject.guard{ true }
        expect(cache_store).to have_received(:delete)
      end

      it "releases on exception" do
        subject.guard{ raise } rescue nil
        expect(cache_store).to have_received(:delete)
      end
    end

    context "when unable to acquire guard" do
      before do
        allow(cache_store).to receive(:increment).and_return(2)
      end

      it "raises an CacheGuard::AcquireError" do
        expect{ subject.guard{ true } }.to raise_error(CacheGuard::AcquireError)
      end

      it "doesn't release" do
        subject.guard{ true } rescue nil
        expect(cache_store).to_not have_received(:delete)
      end
    end
  end

  describe ".guard" do
    subject{ double("guard") }

    before do
      allow(subject).to receive(:guard).and_yield
      allow(described_class).to receive(:new).with("static", :expires_in => 100).and_return(subject)
    end

    it "creates a new instance and calls guard with the given block" do
      expect{ |probe| described_class.guard("static", { :expires_in => 100 }, &probe) }.to yield_control
    end
  end
end
