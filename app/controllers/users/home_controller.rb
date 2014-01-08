class Users::HomeController < ApplicationController
  def index
    @activity_session = ActivitySession.new
  end
end
