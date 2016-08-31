require "has_archive/version"
require "has_archive/railtie" if defined?(Rails)
require "has_archive/hook"

module HasArchive
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods

    eval <<-RUBY
      class #{base}::Archive < #{base}
        self.table_name = "#{base.to_s.underscore}_archives"

        def restore
          attrs = self.attributes
          attrs.delete('archived_at')
          restored = self.class.parent.new(attrs)
          restored.save && self.destroy(for_real: true)
          self
        end
      end
    RUBY
  end

  module ClassMethods
    def archived
      union = self.unscoped.union(self::Archive.unscoped.select(self.attribute_names.map(&:to_sym)))
      self.from(self.arel_table.create_table_alias(union, self.table_name.to_sym).to_sql)
    end
  end

  module InstanceMethods
    def archive(force: false)
      archive = self.class::Archive.new(self.attributes)
      archive.archived_at = Time.now
      archive.save(validate: false)
      self.destroy(for_real: true)
    rescue ActiveRecord::RecordNotUnique => e
      if force
        self.class::Archive.find(archive.id).destroy(for_real: true)
        self.archive
      else
        Rails.logger.warn "Rescued attempt to archive record with existing key: #{archive.id}."
        false
      end
    end

    def destroy(for_real: false, force: false)
      if !for_real && Rails.configuration.has_archive.override_destroy
        archive
      else
        super()
      end
    end
  end
end
