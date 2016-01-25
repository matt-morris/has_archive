module HasArchive
  class MigrationExistsException < StandardError
    def initialize(table_name)
      super("Archive already exists for `#{table_name}`!")
    end
  end
end
