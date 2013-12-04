module DraftGrantsControllerHelper
  def parse_embed(grant)
    video = grant.video
    video.split('=').last if video
  end
end
