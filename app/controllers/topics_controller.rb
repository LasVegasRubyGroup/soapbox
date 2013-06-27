class TopicsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :recent]
  before_filter :fetch_topic, except: [:index, :new, :create, :recent]
  before_filter :require_organizer, only: [:destroy]

  def index
    respond_to do |f|
      f.html do
        @topics = Topic.open_by_votes.decorate
      end
    end
  end

  def recent
    @topics = Topic.with_state(:open).by_most_recent.decorate
  end

  def vote
    respond_to do |format|
      if current_user.vote_on!(@topic)
        format.html { redirect_to(@topic, notice: 'You voted!')}
        format.js
      else
        flash[:error] = 'Only one vote greedy asshole.'
        format.html { redirect_to(@topic) }
        format.js
      end
    end
  end

  def volunteer
    respond_to do |format|
      if current_user.volunteer_for!(@topic)
        format.html { redirect_to(@topic, notice: 'Thanks for volunteering!') }
        format.js
      else
        flash[:error] = 'You should volunteer for another topic.'
        format.html { redirect_to(@topic) }
        format.js
      end
    end
  end

  def show
  end

  def new
    @topic = Topic.new
  end

  def edit
  end

  def create
    @topic = current_user.topics.build(params[:topic])

    if @topic.save
      current_user.vote_on!(@topic)
      redirect_to(@topic, notice: 'Topic was successfully created.')
    else
      render(:new)
    end
  end

  def update
    if @topic.update_attributes(params[:topic])
      redirect_to(@topic, notice: 'Topic was successfully updated.')
    else
      render(:edit)
    end
  end

  def destroy
    @topic.destroy
    redirect_to(topics_url)
  end

  def give_kudo
    if @topic.give_kudo_as(current_user)
      head :ok
    else
      render json: {error: @topic.errors[:kudos]}, status: 412
    end
  end

private

  def fetch_topic
    @topic ||= Topic.find(params[:id]).decorate
  end
end
