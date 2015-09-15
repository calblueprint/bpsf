class GrantReport
  include Datagrid

  #
  # Scope
  #

  scope do
    Grant
  end

  #
  # Filters
  #

  filter(:condition, :dynamic, :header => "Customizeable Conditions")

  #
  # Columns
  #

  column(:id, :mandatory => true)
  column(:title, :mandatory => true)
  column(:status, :mandatory => true)
  column(:updated_at, :mandatory => true)

end
