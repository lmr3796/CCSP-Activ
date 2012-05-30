class LightController < ApplicationController
  def show
    render :layout => false
  end

  def update
    redirect_to :show
  end
end
