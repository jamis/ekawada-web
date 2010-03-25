load 'deploy'
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

capfile = File.expand_path("~/.ekawada/Capfile")
if File.exists?(capfile)
  load(capfile)
else
  puts "----------------------------------------------------"
  puts "To customize deployment of Ekawada, create a Capfile"
  puts "at ~/.ekawada and put your deployment instructions"
  puts "there."
  puts "----------------------------------------------------"
end
