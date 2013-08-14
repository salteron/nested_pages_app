class Page < ActiveRecord::Base
	has_ancestry

	FORBIDDEN_NAMES = %w(edit add)

	validates :name,  presence: true, uniqueness: true
  validates :name, exclusion: { in: FORBIDDEN_NAMES,
    message: "Name %{value} is reserved." }

	validates :title,  presence: true

	validate :content_cant_be_nil

	def content_cant_be_nil
		errors.add(:content, "can't be nil") if content.nil?
	end
end
