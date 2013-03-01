require 'spec_helper'

describe Voter do
  it { should belong_to(:user) }
  it { should belong_to(:topic) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:topic_id) }
end
