require 'spec_helper'

describe Kudo do
  let!(:topic) { create(:topic) }
  let!(:user1) { create(:user, name: 'User One') }

  context "Creating a kudo for a user" do

    it "adds a Kudo for a user that hasn't already submitted" do
      expect { Kudo.create!(topic: topic, user: user1) }.to change(Kudo, :count)
    end

    it "does not add a Kudo for a user that's already submitted" do
      Kudo.create(topic: topic, user: user1)
      lambda { Kudo.create!(topic: topic, user: user1) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
