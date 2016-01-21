module HasArchive
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do #|app|
      # TODO is there actually anything we need to do with an initializer?
      puts "///////////////////////////////////////////////////////////////////////////////////////////////"
      puts "////// initializing has_archive ///////////////////////////////////////////////////////////////"
      puts "///////////////////////////////////////////////////////////////////////////////////////////////"
    end

    # TODO is this where we want to pass in initialization options?
    # are there even any options we need, yet?
    config.has_archive = ActiveSupport::OrderedOptions.new

    config.to_prepare do
      class ActiveRecord::Base
        ActiveRecord::Base.send :extend, HasArchive::Hook
      end
    end
  end
end
