class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]

  validates_inclusion_of :citizenship, in: COUNTRIES, allow_blank: true

  has_many :destinations, -> { order(:zone) }, dependent: :destroy
  has_many :periods, through: :destinations

  def self.find_for_twitter_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = "#{auth.info.nickname}@visacountdown.com"
      user.password = Devise.friendly_token[0, 20]  # Fake password for validation
      user.token = auth.credentials.token
    end
  end

  def to_s
    email
  end

  def flag
    citizenship.downcase.gsub(' ', '-') if citizenship
  end
end
