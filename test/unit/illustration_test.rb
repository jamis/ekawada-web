require 'test_helper'

class IllustrationTest < ActiveSupport::TestCase
  teardown do
    FileUtils.rm_rf(File.join(Rails.root, "test/trash"))
  end

  test "process_to_holding should create thumbnails in temporary location" do
    illustration = build_illustration
    assert illustration.new_record?
    assert_illustration_files(illustration)
  end

  test "saving processed illustration should move thumbnails to permanent location" do
    illustration = build_illustration
    tmp = File.join(Illustration.tmp_root, illustration.location)

    illustration.attributes = { :parent_type => "Figure", :parent_id => figures(:openinga).id }
    illustration.save!

    assert !File.exists?(tmp)
    assert_illustration_files(illustration)
  end

  private

  def build_illustration
    file = Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/illustrations/oa-01.png"), "image/png")
    Illustration.process_to_holding(:file => file)
  end

  def assert_illustration_files(illustration)
    root = illustration.new_record? ? Illustration.tmp_root : Illustration.final_root

    dir = File.join(root, illustration.location)
    assert File.directory?(dir)

    Dir.chdir(dir) do
      assert_equal(%w(large.png original.png small.png thumb.png), Dir.glob("*.png").sort)
    end
  end
end
