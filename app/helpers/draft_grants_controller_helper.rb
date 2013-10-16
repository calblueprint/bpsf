module DraftGrantsControllerHelper
  def parse_embed(grant)
    grant.video.split('=').last if grant.video
  end
end
