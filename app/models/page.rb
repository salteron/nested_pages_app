class AncestryUniquenessValidator < ActiveModel::Validator

	# Validates the whole ancestry (path) uniqueness
  def validate(record)
  	return if not record.new_record? # because name updates are restricted!
  	if (record.parent && record.parent.children.where(name: record.name).any?) || 
  		 (record.parent.nil? && Page.roots.where(name: record.name).any?)
  				record.errors[:name] << "has been already taken"
  	end
  end

end


class Page < ActiveRecord::Base
	include ActiveModel::Validations
  validates_with AncestryUniquenessValidator

	has_ancestry

	FORBIDDEN_NAMES = %w(edit add)

	validates :name,  presence: true
	validates :name, exclusion: { in: FORBIDDEN_NAMES,
    message: "Name %{value} is reserved." }

	validates :title,  presence: true

	validate :content_cant_be_nil

	def content_cant_be_nil
		errors.add(:content, "can't be nil") if content.nil?
	end
end
