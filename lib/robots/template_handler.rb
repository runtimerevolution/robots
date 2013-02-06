require 'robots'

class Robots::TemplateHandler
  def self.call(template)
    "Robots::DSL.new('#{template.source}').env(Rails.env)"
  end
end
