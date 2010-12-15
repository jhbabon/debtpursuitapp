class User < ActiveRecord::Base
  include Person
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  LOCALES = %w(es en)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me, :locale,
                  :email, :first_name, :last_name

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :locale, :in => self::LOCALES

  has_many :contacts, :dependent => :destroy
  has_many :sent_invitations,
           :foreign_key => "sender_id",
           :class_name => "Invitation",
           :dependent => :destroy
  has_many :received_invitations,
           :foreign_key => "receiver_id",
           :class_name => "Invitation",
           :dependent => :destroy
  has_many :comments, :dependent => :destroy

  scope :search, proc { |q|
    where("first_name LIKE :q OR last_name LIKE :q OR first_name||' '||last_name LIKE :q", { :q => "%#{q}%" })
  }

  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end
end
