require 'spec_helper'

describe TimeSlot do
  it { should belong_to(:meeting) }
  it { should belong_to(:topic) }
  it { should belong_to(:presenter) }

  it { should validate_presence_of(:starts_at) }
  it { should validate_presence_of(:ends_at) }
  # it { should validate_presence_of(:topic_id) }
  # it { should validate_presence_of(:presenter_id) }
end
