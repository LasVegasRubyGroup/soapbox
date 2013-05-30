require 'spec_helper'

describe TopicsController do
  describe "put :give_kudo" do
    include_context "full meeting setup"

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
