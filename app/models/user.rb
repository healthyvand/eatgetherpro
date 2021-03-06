# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  nameChi                :string
#  nameNick               :string
#  image                  :string
#  gender                 :string
#  birthday               :date
#  income                 :integer
#  heightUser             :integer
#  description            :text
#  cellNum                :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_messageable #mailboxer
  has_many :photos, :as => :photoable
  accepts_nested_attributes_for :photos
  has_many :posts
	has_many :feedbacks
  has_many :asker_requests
  has_many :ask_posts, :through => :asker_requests, :source => :post
  has_many :user_interests
  has_many :interests, :through => :user_interests,source: :interest

  has_many :notifications

  mount_uploader :image, ImageUploader
  scope :all_except, -> (user) {where.not(id: user)}


  scope :recent, -> {order("created_at DESC")}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_confirmation_of :password

  ##限定收入和身高
  validates_numericality_of :income, greater_than_or_equal_to: 1,
                                     message: "收入不能小于1哦，请如实填写"
  validates_numericality_of :heightUser, greater_than_or_equal_to: 1,
                                          less_than_or_equal_to: 210,
                                         :message => "请如实填写身高"
  ##

  #mailboxer 没有这个会出现no method mailboxer_email
  def mailboxer_email(user)
    nil
  end
  ###

  ##模改mailboxer的发信功能
  def send_message(recipients, msg_body, subject, order, sanitize_text = true, attachment = nil, message_timestamp = Time.now)
    convo = Mailboxer::ConversationBuilder.new(subject: subject,
                                               created_at: message_timestamp,
                                               updated_at: message_timestamp).build
    message = Mailboxer::MessageBuilder.new(sender: self,
                                            conversation: convo,
                                            recipients: recipients,
                                            body: msg_body,
                                            subject: subject,
                                            attachment: attachment,
                                            created_at: message_timestamp,
                                            updated_at: message_timestamp).build
    convo.order_two_id = order.id
    convo.save
    message.deliver false, sanitize_text
  end
  ##

  ##性别选择
  def self.sex_select
    ["酷男","美女"]
  end
  ##


  def is_asker_of?(post)
    ask_posts.include?(post)
  end

  def application!(post)
    ask_posts << post
  end

  def cancel_application!(post)
    ask_posts.delete(post)
  end

  def admin?
     is_admin
  end

  def take_master!
    self.is_admin = true
    self.save
  end

  def customer!
    self.is_admin = false
    self.save
  end
end
