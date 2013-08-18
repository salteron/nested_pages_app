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
		args.reject!{ |arg| arg.empty? || arg == "/" }
	  args.map { |arg| arg.gsub(%r{^/*(.*?)/*$}, '\1')}.join("/")
	end

	def parent_uri
		parent_uri = current_uri.split('/')[0..-2].join('/')
		parent_uri + '/'
	end

	def current_uri
		request.fullpath.split("?")[0] # with no ?-params
	end

  def page_ancestry_path page
    page.path.select(:name).map(&:name).join('/')
  end

  def format_content content
    content = replace_with_href(replace_with_italic(replace_with_bold(content)))
    sanitize(raw content)
  end

  # Replacing from inside out
  def replace_with_bold content
    bold_reg = /\*{2}(?<content>((?!\*{2}).)*)\*{2}/
    bold_rep = '<b>\k<content></b>'

    while content.gsub!(bold_reg, bold_rep); end
    content
  end 
  
  # Replacing from inside out
  def replace_with_italic content
    italic_reg = /\\{2}(?<content>((?!\\{2}).)*)\\{2}/
    italic_rep = '<i>\k<content></i>'

    while content.gsub!(italic_reg, italic_rep); end
    content
  end

  def replace_with_href content, url_prefix = form_url_from_parts
    href_reg = /\({2}\/{0,1}(?<page_path>(\w+\/)*\w+)\/{0,1}\s+(?<text>.+)\){2}/
    href_rep = "<a href='#{url_prefix}\/\\k<page_path>'>\\k<text></a>"

    while content.gsub!(href_reg, href_rep); end
    content
  end

end
