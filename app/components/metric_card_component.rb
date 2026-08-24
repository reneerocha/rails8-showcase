class MetricCardComponent < ViewComponent::Base
  def initialize(title:, value:, icon:, color_class:)
    @title = title
    @value = value
    @icon = icon
    @color_class = color_class
  end
end
