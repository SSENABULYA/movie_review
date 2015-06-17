class Movie < ActiveRecord::Base
	searchkick
	belongs_to :user
	has_many :reviews

	has_attached_file :image, styles: { large: "600x600>" , medium: "400x600>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/


end
