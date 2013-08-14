module PagesHelper

  def nested_pages(pages, prefix)  
    pages.map do |page, sub_pages|  
      render(
      	partial: 'page',
      	object: page,
      	locals: { url: form_url_from_parts(prefix, page.name) }
      ) + 
      content_tag(
      	:div,
      	 nested_pages(sub_pages,join(prefix, page.name)),
      	:class => "nested_pages"
      )  
    end.join.html_safe  
  end 

  def form_url_from_parts(*parts)
		join "#{request.protocol}#{request.host_with_port}", *parts
	end

	def join(*args)
		args.reject!(&:empty?)
	  args.map { |arg| arg.gsub(%r{^/*(.*?)/*$}, '\1')}.join("/")
	end

	def parent_path_of(path)
		path.split('/')[0..-2].join('/')
	end

  def page_ancestry_path page
    page.path.select(:name).map(&:name).join('/')
  end 

end
