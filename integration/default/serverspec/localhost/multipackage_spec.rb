require "spec_helper"

describe "multipackage" do
  %{zsh tcsh bash}.each do |pkg|
    it "should have installed #{pkg}" do
      expect(package(pkg)).to be_installed
    end
  end
end
