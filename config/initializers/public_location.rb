Ekawada::Application::PUBLIC = case Rails.env
  when "test" then File.join(Rails.root, "test/trash/public")
  else File.join(Rails.root, "public")
  end 
