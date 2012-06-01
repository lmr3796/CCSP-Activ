require 'json'
class LightController < ApplicationController
  def find_music_rec(p)
	return Activity.find(p[:act_id])
  end
  def param_valid(p)
      return !p[:act_id].blank?
  end
  def show
    @script =[] 
    if param_valid(params)
      @script = JSON(find_music_rec(params).light_json)
      if @script.blank?
          @script = []
      end
      @mp3 = find_music_rec(params).music_url
      @oga = ""        #find_music_rec(params).music_oga
      @m4a = ""        #find_music_rec(params).music_m4a
    else
    end
    render :layout => false
  end

  def new 
    #redirect_to :show
    @script = LightScript.new
  end
end
