# == Schema Information
#
# Table name: mx_apps
#
#  id                           :bigint(8)        not null, primary key
#  owner_id                     :bigint(8)
#  type                         :string
#  number(编号)                 :string
#  deleted_at(软删)             :datetime
#  client_id                    :string
#  client_secret                :string
#  session_id                   :string
#  pin_token                    :string
#  private_key                  :text
#  raw(mixin 返回的 profile)    :json
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  binded_at(mixin账号审核时间) :datetime
#  identity_number(mixin 号)    :string
#
# Indexes
#
#  index_mx_apps_on_identity_number  (identity_number) UNIQUE
#  index_mx_apps_on_number           (number) UNIQUE
#  index_mx_apps_on_owner_id         (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

class StoreApp < MxApp
  has_many :store_app_users, foreign_key: 'mx_app_id'
  has_many :mx_app_image_attachments, foreign_key: 'mx_app_id'

  has_many :products, class_name: 'StoreAppProduct'
  has_many :orders, class_name: 'StoreAppOrder'

  def name
    raw&.fetch('full_name') || 'iXin 商城'
  end
end
