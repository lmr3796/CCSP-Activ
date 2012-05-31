require 'json'
class LightController < ApplicationController
  def find_music_rec(p)
	return Activity.find(p[:act_id])
  end
  def param_valid(p)
      return !p[:act_id].blank?
  end
  def show
    if param_valid(params)
      id=params[:act_id]
      @script = JSON(find_music_rec(params).light_json)
      @mp3 = find_music_rec(params).music_url
      @oga = nil        #find_music_rec(params).music_oga
      @m4a = nil        #find_music_rec(params).music_m4a
    end
    render :layout => false
  end

  def update
    redirect_to :show
  end
end
