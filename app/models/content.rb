class Content < ApplicationRecord
    has_many :answers,dependent: :destroy
end
