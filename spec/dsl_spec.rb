require 'spec_helper'

class RobotsTemplate
  def template_a
    <<-CONTENT
    environment :production do
      allow do
         link "/posts"
      end
      disallow do
         link "/comments"
      end
    end

    environment :staging do
      disallow do
        all
      end
    end
    CONTENT
  end

  def expectation_template_a_production
    <<-CONTENT
User-agent: *
Allow : /posts
Disallow : /comments
    CONTENT
  end

  def expectation_template_a_staging
    <<-CONTENT
User-agent: *
Disallow : /
    CONTENT
  end

end

describe "Robots DSL" do

  it "compiles Robots template and shows production mode" do
    template = RobotsTemplate.new
    expectation = template.expectation_template_a_production
    robots = Robots::DSL.new(template.template_a)
    robots.env("production").should == expectation
  end

  it "compiles Robots template and shows staging mode" do
    template = RobotsTemplate.new
    expectation = template.expectation_template_a_staging
    robots = Robots::DSL.new(template.template_a)
    robots.env("staging").should == expectation
  end
end
