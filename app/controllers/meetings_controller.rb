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
    @meeting = Meeting.new(params[:meeting])
    @meeting.mark_topics_selected

    if @meeting.save
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

  def finalize
    result = @meeting.finalize
    redirect_to(leaderboard_path, notice: point_allocation(result))
  end

private

  def load_topics
    @topics = TopicDecorator.decorate(Topic.open_by_votes)
  end

  def load_meeting
    @meeting = MeetingDecorator.find(params[:id])
  end

  def point_allocation(topics)
    topics.flat_map do |topic|
      topic.map do |participant|
        "#{participant[:name]} awarded #{participant[:points]} points!"
      end
    end.join('<br>').html_safe
  end
end
