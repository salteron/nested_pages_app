module ApplicationHelper
	def form_url uri
		"#{request.protocol}#{request.host_with_port}/#{uri}"
	end
end
