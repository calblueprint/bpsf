# Class that loads and writes to em.yml
class ContentEditor
  YAML_PATH = './config/locales/en.yml'

  def initialize
    @content = YAML.load(
      File.read(File.expand_path(YAML_PATH))
    ).with_indifferent_access[:en]
  end

  def content
    @content
  end
end
