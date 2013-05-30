require 'spec_helper'

describe User do
  
  describe '.find_for_meetup_oauth' do

    context 'when the user does not exist' do
      let(:auth) { OpenStruct.new(provider: 'test', uid: '123456', info: OpenStruct.new(name: 'Joe Blow')) }

      before { Meetup::Profile.stub(:get).and_return({'role' => ''}) }

      it 'creates the user' do
        User.find_for_meetup_oauth(auth)
        User.find_by_name('Joe Blow').should_not be_nil
      end

      it 'sets the provider' do
        User.find_for_meetup_oauth(auth)
        User.find_by_name('Joe Blow').provider.should == 'test'
      end

      it 'sets the uid' do
        User.find_for_meetup_oauth(auth)
        User.find_by_name('Joe Blow').uid.should == '123456'
      end

      context 'when the user is not an organizer' do
        it 'does not set the user as an organizer' do
          User.find_for_meetup_oauth(auth)
          User.find_by_name('Joe Blow').organizer.should be_false
        end
      end

      context 'when the user is an organizer' do
        before { Meetup::Profile.stub(:get).and_return({'role' => 'Organizer'}) }

        it 'sets the user as an organizer' do
          User.find_for_meetup_oauth(auth)
          User.find_by_name('Joe Blow').organizer.should be_true
        end
      end

      context 'when the user is a co-organizer' do
        before { Meetup::Profile.stub(:get).and_return({'role' => 'Co-Organizer'}) }
        
        it 'sets the user as an organizer' do
          User.find_for_meetup_oauth(auth)
          User.find_by_name('Joe Blow').organizer.should be_true
        end
      end
    end

    context 'when the user does exist' do
      let(:auth) { OpenStruct.new(auth: 'test', uid: '123456', info: OpenStruct.new(name: 'Joe Blow')) }

      before do 
        Meetup::Profile.stub(:get).and_return({'role' => ''})
        User.find_for_meetup_oauth(auth) #This creates the user as verified by other tests.
      end

      it 'does not create the user' do
        expect {User.find_for_meetup_oauth(auth)}.to_not change(User,:count)
      end

    end

  end

end
