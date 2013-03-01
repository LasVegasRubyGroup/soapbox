class InfoController < ApplicationController
  def home
  end

  def leaderboard
    @users = User.with_points.by_points
  end
end
