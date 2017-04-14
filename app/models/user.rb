class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :words, -> { order 'created_at DESC' }

  DEFAULT_USER_EMAIL = "goggin13@gmail.com"

  def self.default_user
    User.find_by_email(DEFAULT_USER_EMAIL).tap do |default_user|
      if default_user.nil?
        raise NoDefaultUserDefined.new("Default user called and none defined")
      end
    end
  end

  class NoDefaultUserDefined < Exception; end
end
