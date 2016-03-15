require "spec_helper"

describe "fake::functional" do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: "14.04",
    ).converge(described_recipe)
  end

  it "converges successfully" do
    expect { chef_run }.to_not raise_error
  end
end

describe "fake::lwrp" do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: "14.04",
      step_into: ['test_resource'],
    ).converge(described_recipe)
  end

  it "converges successfully" do
    expect { chef_run }.to_not raise_error
  end
end
