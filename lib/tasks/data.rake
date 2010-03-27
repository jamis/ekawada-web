namespace :data do

  task :dump => :environment do
    c = ActiveRecord::Base.connection

    mkdir_p "db/dump"
    c.tables.each do |table|
      next if table == "schema_migrations"
      rows = c.select_all("select * from #{c.quote_table_name(table)}")
      File.open("db/dump/#{table}.yml", "w") { |out| out.write(rows.to_yaml) }
    end
  end

  task :load => "db:schema:load" do
    c = ActiveRecord::Base.connection

    c.tables.each do |table|
      next if table == "schema_migrations"
      if File.exists?("db/dump/#{table}.yml")
        puts "#{table}..."
        YAML.load_file("db/dump/#{table}.yml").each do |row|
          columns = row.keys
          sql = "INSERT INTO #{c.quote_table_name(table)} ("
          sql << columns.map { |col| c.quote_column_name(col) }.join(', ')
          sql << ") VALUES ("
          sql << columns.map { |col| c.quote(row[col]) }.join(', ')
          sql << ")"
          c.insert(sql)
        end
      else
        puts "no data file found for `#{table}', skipping..."
      end
    end
  end

  task :backup => "data:dump" do
    cp_r "public/illustrations/", "db/dump"
    run "tar cjvf data.tar.bz2 db/dump"
  end

end
