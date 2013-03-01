class InfoController < ApplicationController
  def home
  end

  def leaderboard
    @users = User.by_points
  end
end
