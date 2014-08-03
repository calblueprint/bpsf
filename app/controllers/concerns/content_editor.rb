# Class that loads and writes to em.yml
class ContentEditor
  # To make form_for work
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActionView::Helpers
  def persisted? ; false ; end
  attr_accessor :output_buffer, :content

  # Path to en.yml
  YAML_PATH = File.expand_path './config/locales/en.yml'

  validates :content, presence: true

  def initialize(content=nil)
    # TODO: Use something better than just plaintext
    # @content ||= YAML.load(
    #   File.read(File.expand_path(YAML_PATH))
    # ).with_indifferent_access[:en]
    @content = content || File.read(YAML_PATH)
  end

  def render(c = @content)
    # TODO: Renders content recursively - need to make this work with a form though
    return c if c.is_a? String
    content_tag :ul do
      c.keys.reduce('') do |html, key|
        "#{html}#{key}#{content_tag(:li, render(c[key]))}"
      end.html_safe
    end.html_safe
  end

  def save
    return false unless valid?
    File.open(YAML_PATH, 'w') { |file| file.write @content.gsub "\r", '' }
  end
end
