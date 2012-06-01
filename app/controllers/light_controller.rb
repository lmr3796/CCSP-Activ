require 'json'
class LightController < ApplicationController
  def find_music_rec(p)
	return Activity.find(p[:act_id])
  end
  def param_valid(p)
    # Test if the passed parameters like activity id is valid
    return !(p[:act_id].blank? or Activity.find_by_id(p[:act_id]).blank?)
  end
  def show
    @script = [] 
    @act_id = params[:act_id]
    if param_valid(params)
      LightScript.select("time, move").where("activity_id = ?", @act_id).order(:time).each { |m|
        @script.append([m.time, m.move])
      }
      #@script = JSON(find_music_rec(params).light_json)
      @script = JSON(@script.to_json)
      if @script.blank?
          @script = []
      end
      @mp3 = find_music_rec(params).music_url
      @oga = ""        #find_music_rec(params).music_oga
      @m4a = ""        #find_music_rec(params).music_m4a
    else
    end
    @move = LightScript.new
    @move.activity_id = params[:act_id]
    render :layout => false
  end

  def create 
    if not param_valid(params)
      render :nothing => true, :status => 400
    end
    move = LightScript.new params[:light_script]
    move.activity_id = params[:act_id]
    if move.save 
      render :nothing => true
    else
      render :nothing => true, :status => 400
    end
  end
end
