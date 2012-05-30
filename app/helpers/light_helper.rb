module LightHelper
  def music_mp3(activity_id=nil)
	@a = Activity.find(activity_id)
    #return "https://dl.dropbox.com/u/31496039/OLD0307.mp3"
	return @a.music_url
  end
  def music_oga(activity_id=nil)
    return "https://dl.dropbox.com/u/31496039/OLD0307.ogg"
  end
  def music_m4a(activity_id=nil)
    return "https://dl.dropbox.com/u/31496039/OLD0307.m4a"
  end
  def light_script(activity_id=nil)
	@a = Activity.find(activity_id)
	return @a.light_json
    #return "/old.json"
  end
end
