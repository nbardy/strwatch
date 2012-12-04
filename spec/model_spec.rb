require 'spec_helper'

describe "Setup" do
  it "Test model works" do
    expect { Tree.create }.to_not raise_error
  end

end
