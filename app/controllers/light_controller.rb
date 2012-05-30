require 'json'
class LightController < ApplicationController
  def show
    id=params[:act_id]
    @script = JSON(ApplicationController.helpers.light_script(id))
    @mp3 = ApplicationController.helpers.music_mp3(id)
    @oga = ApplicationController.helpers.music_oga(id)
    @m4a = ApplicationController.helpers.music_m4a(id)
    render :layout => false
  end

  def update
    redirect_to :show
  end
end
