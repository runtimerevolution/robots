module Robots
  class Railtie < Rails::Railtie
    initializer 'robots.initialize_template_handler' do
      require 'robots/template_handler'
      ActionView::Template.register_template_handler(:robots,
        Robots::TemplateHandler)
    end
  end
end
