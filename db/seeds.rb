if Rails.env.development?
  user = User.create!(:name => "Test", :login => "test", :email => "test@example.com",
    :password => "test")

  arctic = Source.create(:name => "Arctic String Figure Project",
    :info => "An ISFA project to standardize the instructions of all Arctic figures previously collected by ethnographers. Hosted at http://www.isfa.org/arctic.")

  mizz = Source.create(:name => "String Figure Mizz Code Explained",
    :info => "The basics of Mizz code in picture form, including over a hundred tutorials. Hosted at http://home.p07.itscom.net/nenemei/v2/index.html.")

  kwakiutl = Source.create(:name => "Kwakiutl String Figures",
    :info => "Julia Averkieva and Mark A. Sherman, 1992, American Museum of Natural History")

  data = YAML.load_file(File.join(File.dirname(__FILE__), "seeds.yml"))

  oa = Figure.create(:common_name => "Opening A", :opening => true).tap do |oa|
    oa.create_construction_from("isfa", data["Opening A"]["isfa"], :submitter => user).tap do |c|
      c.references.create :source => arctic, :info => "http://www.isfa.org/arctic/n.htm"
    end

    oa.create_construction_from("mizz", data["Opening A"]["mizz"], :name => "base", :submitter => user).tap do |c|
      c.references.create :source => mizz, :info => "#88, http://home.p07.itscom.net/nenemei/v2/sf_lookalike_base.png"
    end
  end

  Figure.create(:common_name => "Opening B", :opening => true).tap do |ob|
    ob.create_construction_from("isfa", data["Opening B"]["isfa"], :submitter => user).tap do |c|
      c.references.create :source => arctic, :info => "Extrapolated from http://www.isfa.org/arctic/n.htm"
    end

    ob.create_construction_from("mizz", data["Opening B"]["mizz"], :name => "L base", :submitter => user).tap do |c|
      c.references.create :source => mizz, :info => "#14, http://home.p07.itscom.net/nenemei/v2/sf_string_base.png"
    end
  end

  Figure.create(:common_name => "Opening B (Kwakiutl)", :opening => true).tap do |ob|
    ob.create_construction_from("rivers-haddon", data["OB Kwakiutl"]["rivers-haddon"], :submitter => user).tap do |c|
      c.references.create :source => kwakiutl, :info => "page xxxi, Commonly Used Openings, \"Opening B\""
    end

    ob.create_construction_from("isfa", data["OB Kwakiutl"]["isfa"], :submitter => user)
    ob.create_construction_from("mizz", data["OB Kwakiutl"]["mizz"], :submitter => user)
  end

  Figure.create(:common_name => "Osage Diamonds", :aliases => "Jacob's Ladder").tap do |jl|
    jl.create_construction_from("isfa", data["Osage Diamonds"]["isfa"], :submitter => user)
    jl.create_construction_from("mizz", data["Osage Diamonds"]["mizz"], :submitter => user)
  end
end
