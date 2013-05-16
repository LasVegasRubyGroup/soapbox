require 'spec_helper'

describe TopicsController do
  describe "put :give_kudo" do
    let(:presenter) { create(:user, :name => "Presenter") }
    let(:on_date) { Date.today }
    let(:meeting) { Meeting.prototype(on_date) }
    let(:topic1) { create(:topic, :title => "Topic 1", :description => "This is a topic") }
    let(:topic2) { create(:topic, :title => "Topic 2", :description => "This is a topic") }
    let(:topic3) { create(:topic, :title => "Topic 3", :description => "This is a topic") }
    let(:user) { create(:user, :name => "Joe User", :provider => "meetup", :uid => "1234") }

    before do
      meeting.time_slots.each_with_index do |ts, idx|
        ts.presenter = presenter
        ts.topic = send("topic#{idx+1}")
      end
      meeting.save
      meeting.time_slots.each_with_index do |ts, idx|
        send("topic#{idx+1}").update_attribute(:meeting_id, meeting.id)
      end
      meeting.reload
    end

    context "when the user has a Kudo to give" do
      before { sign_in(user) }

      it "successfully returns when the user has a Kudo to give" do
        put :give_kudo, {id: topic1.id}
        expect(response).to be_ok
      end

      it "adds a Kudo record, when the user has a Kudo to give" do
        expect { put :give_kudo, {id: topic1.id} }.to change(Kudo, :count).by(1)
      end
    end

    context "when the user is not signed in" do
      it "redirects to the root path" do
        put :give_kudo, {id: topic1.id}
        expect(response).to redirect_to root_path
      end
    end

    context "when the user has no Kudo to give" do
      let!(:kudo) { Kudo.create!(topic: topic1, user: user) }

      before { sign_in(user) }

      it "does not create a Kudo record" do
        expect { put :give_kudo, {id: topic1.id} }.to_not change(Kudo, :count)
      end

      it "returns a 412 error code" do
        put :give_kudo, {id: topic1.id}
        expect(response.status).to eq(412)
      end
    end
  end
end
