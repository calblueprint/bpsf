class GrantDecorator < Draper::Decorator
  delegate :tag, :content_tag, :image_tag, :link_to, to: :h
  delegate_all

  def status
    model.status.titleize
  end

  def methods
    model.methods
  end

  def days_left
    if past_deadline?
      'Past Deadline'
    elsif crowdfunding?
      "#{model.days_left} Days Left!"
    else
      status
    end
  end

  def banner(options = {})
    if !image_url.blank?
      content_tag :div, image_tag(image_url :banner), class: options[:classes]
    else
      content_tag :div, class: 'imgreplacementlrg' do
        content_tag :div, title, class: 'repson'
      end
    end
  end

  def subject_areas
    model.subject_areas.values.to_a.join ', '
  end

  def progress_bar
    tag :span, class: 'progressbar', style: 'width: 0%',
        data: { bp_current: current_funds , bp_goal: funding_goal }
  end

  def current_funds
    has_crowdfunder? ? crowdfunder_pledged_total : 0
  end

  def funding_goal
    has_crowdfunder? ? crowdfunder_goal : requested_funds
  end

  def can_receive_donations?
    crowdfunding? || crowdfund_pending?
  end

  def has_crowdfunder?
    crowdfunder
  end

  def video_large
    content_tag :div, class: 'row' do
      content_tag :div, class: 'ten columns centered' do
        content_tag :article, class: 'youtube video' do
          %Q[<iframe src="#{"https://www.youtube.com/embed/#{h.parse_embed(model)}"}"></iframe>].html_safe
        end
      end
    end if video.present?
  end

  def video_small
    %Q[<iframe src="#{"https://www.youtube.com/embed/#{h.parse_embed(model)}"}"
               height="315" width="560"></iframe>].html_safe if video.present?
  end

  def collaborators_section
    if has_collaborators?
      content_tag(:h5, content_tag(:span, 'Collaborators')) + collaborators
    end
  end

  def use_of_funds
    funds_will_pay_for.join ', '
  end

  def comments_section
    tag(:br) + content_tag(:h3, 'Additional Comments') + comments
  end

  def edit_icon_for(url)
    content_tag :span, class: 'ttip', data: { tooltip: 'Edit' } do
      link_to '<i class="icon-pencil"></i>'.html_safe, url
    end
  end
end
