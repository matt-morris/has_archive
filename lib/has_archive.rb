require "has_archive/version"
require "has_archive/railtie" if defined?(Rails)
require "has_archive/hook"
require "has_archive/migration_manager"

module HasArchive
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods

    eval <<-EVAL
      class #{base}::Archive < #{base}
        self.table_name = "#{base.to_s.underscore}_archives"
      end
    EVAL
  end

  module ClassMethods
    def archive
      self::Archive
    end
  end

  module InstanceMethods
    def archive
      archive = self.class::Archive.new(self.attributes)
      archive.archived_at = Time.now
      archive.save
      self.destroy(for_real: true)
    end

    def destroy(for_real: false)
      if !for_real && Rails.configuration.has_archive.override_destroy
        # puts "destroy has been overridden..."
        archive
      else
        super()
      end
    end
  end
end
