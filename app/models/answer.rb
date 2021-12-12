class Answer < ApplicationRecord
    belongs_to :content
    has_many :good_users,dependent: :destroy
end
