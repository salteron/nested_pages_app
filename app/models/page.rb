class Page < ActiveRecord::Base
	VALID_PAGE_NAME_REGEXP = /^\w+$/
	FORBIDDEN_NAMES = %w(edit add)

	has_ancestry

	before_save do
		self.title = ActionController::Base.helpers.strip_tags(title)
		self.content = ActionController::Base.helpers.sanitize(content)
	end

	validates :name,
	  presence: true,
	  exclusion: { in: FORBIDDEN_NAMES, message: "Name %{value} is reserved." },
	  format: { with: VALID_PAGE_NAME_REGEXP }

	validates :title,  presence: true

	validate :path_is_unique, :content_cant_be_nil

	private

		def content_cant_be_nil
			errors.add(:content, "can't be nil") if content.nil?
		end

		def path_is_unique
			return if not self.new_record? # because name updates are restricted!
	  	if (parent && parent.children.where(name: name).any?) || 
	  		 (parent.nil? && Page.roots.where(name: name).any?)
	  				errors[:name] << "has been already taken"
	  	end
		end
end
