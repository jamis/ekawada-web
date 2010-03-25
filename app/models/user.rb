require 'digest/sha1'

class User < ActiveRecord::Base
  class Unauthenticated
    def authenticated?
      false
    end
  end

  attr_accessible :name, :login, :email, :password

  has_many :constructions, :inverse_of => :submitter, :foreign_key => :submitter_id

  validate :password_exists, :on => :create
  validates_presence_of :name, :login, :email, :password_digest

  def self.authenticate(login, password)
    user = User.find_by_login(login)
    user && user.password_matches?(password) ? user : nil
  end

  def password=(password)
    return if password.blank?
    generate_salt!
    self.password_digest = Digest::SHA1.hexdigest(salt + password)
  end

  def password_matches?(password)
    Digest::SHA1.hexdigest(salt + password) == password_digest
  end

  def deleted?
    login.nil?
  end

  def authenticated?
    true
  end

  def destroy
    if constructions.empty?
      super
    else
      self.login = nil
      self.email = nil
      self.password_digest = nil
      self.salt = nil
      save(:validate => false)
    end
  end

  protected

    def password_exists
      if password_digest.blank?
        errors.add :password, "can't be blank"
      end
    end

  private

    SALT_CORPUS = ('0'..'9').to_a + 
                  ('A'..'Z').to_a +
                  ('a'..'z').to_a +
                  %w(! @ # $ % ^ & * [ ] { } | < > , . ' " ; : - _ = + ` ~)

    def generate_salt!
      length = rand(48) + 16
      self.salt = Array.new(length) { SALT_CORPUS.rand }.join
    end
end
