class MeetingsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :require_organizer, except: [:index, :show]
  before_filter :load_topics, except: [:index, :show]
  before_filter :load_meeting, except: [:index, :create, :new]

  def index
    @meetings = Meeting.by_date
  end

  def new
    @meeting = Meeting.prototype
  end

  def create
    time_slots = params[:meeting].delete(:time_slots_attributes)
    @meeting = Meeting.new(params[:meeting])

    if @meeting.save
      time_slots.values.each do |time_slot|
        @meeting.time_slots.create(time_slot)
      end
      redirect_to(@meeting, notice: 'All set!')
    else
      render(:new, flash: { error: 'No luck!' })
    end
  end

  def show
  end

  def edit
  end

  def update
    if @meeting.update_attributes(params[:meeting])
      redirect_to(@meeting, notice: 'All set!')
    else
      render(:edit, flash: { error: 'No luck!' })
    end
  end

  def open_kudos
    @meeting.open_kudos!
    redirect_to(@meeting, notice: "Let's get ready to RUUUUUUMBLE!")
  end

  def finalize
    result = @meeting.finalize_and_reward!
    redirect_to(@meeting, notice: point_allocation(result))
  end

private

  def load_topics
    @topics = Topic.open_by_votes.decorate
  end

  def load_meeting
    @meeting = MeetingDecorator.decorate(Meeting.find(params[:id]))
  end

  def point_allocation(topics)
    topics.flat_map do |topic|
      topic.map do |participant|
        "#{participant[:name]} awarded #{participant[:points]} points!"
      end
    end.join('<br>').html_safe
  end
end
