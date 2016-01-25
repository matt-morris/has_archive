require 'has_archive/migration_exists_exception'

module HasArchive
  class MigrationManager
    def self.create_archive_for(model)
      @table_name = model.table_name

      fail MigrationExistsException.new(@table_name) if Dir["db/migrate/*_create_archive_for_#{@table_name}.rb"].any?

      template = <<-MIGRATION
class CreateArchiveFor#{@table_name.camelize} < ActiveRecord::Migration
  def change
    create_table :#{@table_name.singularize}_archives do |t|
#{columns.map {|c| build_column(c) }.join("\n") }
      t.datetime    :archived_at,    null: false
    end

#{indexes.map {|i| build_index(i) }.join("\n") }
  end
end\n
MIGRATION

      File.write("db/migrate/#{file_name('create_archive_for')}", template)
    end

    def self.update_archive_for(model)
      @table_name = model.table_name
    end

    private

    def self.columns
      ActiveRecord::Base.connection.columns(@table_name).select {|c| c.name != 'id' }
    end

    def self.indexes
      ActiveRecord::Base.connection.indexes(@table_name)
    end

    def self.build_column(c)
      limit = c.limit ? ",        limit: #{c.limit}" : ''
      "      t.#{c.type}#{' ' * (12 - c.type.size)}:#{c.name}#{limit}"
    end

    def self.build_index(i)
      # unique  = i.unique ? ', unique: true' : ''
      columns = i.columns.one? ? i.columns.first : i.columns
      # "    add_index :#{@table_name}, :#{columns}#{unique}"
      "    add_index :#{@table_name.singularize}_archives, :#{columns}"
    end

    def self.file_name(action)
      action = action.underscore.gsub(/\s+/, '_')
      # TODO: figure out how number argument is actually supposed to be used
      "#{ActiveRecord::Migration.next_migration_number(1)}_#{action}_#{@table_name}.rb"
    end
  end
end
