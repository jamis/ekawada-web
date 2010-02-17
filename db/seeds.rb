if Rails.env.development?
  user = User.create!(:name => "Test", :login => "test", :email => "test@example.com",
    :password => "test")

  # arctic = Source.create(:name => "Arctic String Figure Project",
  #   :info => "An ISFA project to standardize the instructions of all Arctic figures previously collected by ethnographers. Hosted at http://www.isfa.org/arctic.")

  # mizz = Source.create(:name => "String Figure Mizz Code Explained",
  #   :info => "The basics of Mizz code in picture form, including over a hundred tutorials. Hosted at http://home.p07.itscom.net/nenemei/v2/index.html.")

  # kwakiutl = Source.create(:name => "Kwakiutl String Figures",
  #   :info => "Julia Averkieva and Mark A. Sherman, 1992, American Museum of Natural History")

  figures = YAML.load_file(File.join(File.dirname(__FILE__), "seeds.yml"))
  figures.each do |data|
    constructions = data.delete(:constructions)
    Figure.create(data).tap do |figure|
      constructions.each do |data|
        figure.create_construction_from(data.merge(:submitter => user))
      end
    end
  end
end
