# Require core library
require 'middleman-core'
require 'json'

# Extension namespace
class MyExtension < ::Middleman::Extension
  option :my_option, 'default', 'An example option'

  def initialize(app, options_hash={}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'

    # set up your extension
    # puts options.my_option
    #
    app.before do
      if current_page && current_page.path && current_page.path  =~ /.*\.html$/
        ::MyExtension.add_page({current_page.path => current_page.data})
      end
      true
    end
    app.after_build do
      File.open("tmp/pages.json","w") do |f|
        f.write(JSON.pretty_generate(::MyExtension.pages))
      end
    end
  end

  def after_configuration
    # Do something
  end

  # A Sitemap Manipulator
  # def manipulate_resource_list(resources)
  #   binding.pry
  # end


  def self.add_page page
    @pages ||= {}
    @pages.merge! page
  end

  def self.pages
    @pages || {}
  end

  # module do
  #   def a_helper
  #   end
  # end
end

# Register extensions which can be activated
# Make sure we have the version of Middleman we expect
# Name param may be omited, it will default to underscored
# version of class name

MyExtension.register(:my_extension)
