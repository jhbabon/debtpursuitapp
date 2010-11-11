# Update: Looks for the SQLite and SQLite3 adapters for
# compatibility with Rails 1.2.2 and also older versions.
def in_memory_database?
  dc = Rails.configuration.database_configuration[Rails.env]
  if dc['database'] == ':memory:' or dc['dbfile'] == ':memory:'
    begin
      return ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter
    rescue NameError => e
      return ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLiteAdapter
    end
  end
end

if in_memory_database?
  inform_using_in_memory = lambda {
    puts "Creating sqlite :memory: database"
  }

  load_schema = lambda {
    load "#{Rails.root}/db/schema.rb" # use db agnostic schema by default
    #  ActiveRecord::Migrator.up('db/migrate') # use migrations
  }
  case Rails.configuration.database_configuration[Rails.env]['verbosity']
  when "silent"
    silence_stream(STDOUT, &load_schema)
  when "quiet"
    inform_using_in_memory.call
    silence_stream(STDOUT, &load_schema)
  else
    inform_using_in_memory.call
    load_schema.call
  end
end
