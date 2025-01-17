class Restaurant < ActiveRecord::Base
    has_many :visits
    has_many :users, through: :visits

    validates :name, presence: true
end