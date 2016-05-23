require "spec_helper"

describe "fake::lwrp" do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      step_into: "fake",
      platform: "ubuntu",
      version: "14.04"
    ).converge(described_recipe)
  end

  it "converges successfully" do
    expect { :chef_run }.to_not raise_error
  end

  it "foo" do
    expect(chef_run).to install_multipackage_internal("collected packages install").with(package_name: %w{git strace tcpdump})
  end
end
