module DraftGrantsControllerHelper

  def youtube_video(url)
    render :partial => 'shared/video', :locals => { :url => url }
  end

end
