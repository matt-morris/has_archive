require "has_archive/version"
require "has_archive/hook"
require "has_archive/railtie" if defined?(Rails)

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
    def archived
      # i can haz archived records??
    end
  end

  module InstanceMethods
    def archive
      archived_at = Time.now
      save
    end
  end
end
