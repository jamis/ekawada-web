require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "new record should not be valid without password" do
    user = User.new(:name => "Bob", :login => "bob", :email => "bob@example.com")
    assert !user.valid?
    assert user.errors[:password].any?
  end

  test "creation should populate salt and password digest" do
    user = User.create(:name => "Bob", :login => "bob", :email => "bob@example.com",
      :password => "b0br0x!")
    assert user.valid?
    assert user.salt.present?
    assert user.password_digest.present?
  end

  test "authentication should succeed when login and password matches" do
    assert_equal users(:jamis), User.authenticate("jb", "password")
  end

  test "authentication should fail when login does not match" do
    assert_nil User.authenticate("jamis", "password")
  end

  test "authentication should fail when password does not match" do
    assert_nil User.authenticate("jb", "secret")
  end

  test "destroying a user with submissions should keep neutered record" do
    assert_no_difference("User.count") { users(:jamis).destroy }
    assert users(:jamis, :reload).deleted?
    assert_nil users(:jamis).login
    assert_nil users(:jamis).password_digest
    assert_nil users(:jamis).email
  end

  test "destroying a user with no submissions should delete record" do
    assert_difference("User.count", -1) { users(:cfj).destroy }
  end

  test "updating with a new password should change salt and digest" do
    old_salt, old_digest = users(:cfj).salt, users(:cfj).password_digest
    users(:cfj).update_attribute :password, "secret"
    assert_not_equal old_salt, users(:cfj).salt
    assert_not_equal old_digest, users(:cfj).password_digest
  end

  test "updating with a blank password should not modify existing salt and digest" do
    old_salt, old_digest = users(:cfj).salt, users(:cfj).password_digest
    users(:cfj).update_attributes :name => "Caroline Jayne", :password => ""
    assert_equal old_salt, users(:cfj).salt
    assert_equal old_digest, users(:cfj).password_digest
  end
end
