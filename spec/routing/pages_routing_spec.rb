require 'spec_helper'

describe "routing to pages" do
	it "routes valid page paths to page#show" do
		valid_show_paths = %w[/name1 /name1/name1 /name1/name2/name3]
		valid_show_paths.each do |valid_show_path|
			expect(get: valid_show_path).to route_to(
				controller: 'pages',
				action:     'show',
				page_path:   valid_show_path[1..-1] # without preceding '/'
			)
		end
	end

	it "routes '/' to page#index" do
		expect(get: root_path).to route_to(
			controller: 'pages',
			action: 'index'
		)
	end

	it "routes '/../add'-like paths to page#new" do
		valid_paths = %w[/name1 /name1/name1 /name1/name2/na_me3]
		valid_paths.each do |valid_path|
			expect(get: valid_path + '/add').to route_to(
				controller: 'pages',
				action:     'new' ,
				page_path:   valid_path[1..-1] # without preceding '/'
			)
		end
	end

	it "routes '/add' to page#new" do
		expect(get: '/add').to route_to(
			controller: 'pages',
			action:     'new'
		)
	end

	it "routes '/../edit'-like paths to page#edit" do
		valid_paths = %w[/name1 /name1/name1 /name1/name2/name3]
		valid_paths.each do |valid_path|
			expect(get: valid_path + '/edit').to route_to(
				controller: 'pages',
				action:     'edit',
				page_path:   valid_path[1..-1] # without preceding '/'
			)
		end
	end

	it "doesn't route '/edit'" do
		expect(get: '/edit').not_to be_routable
	end

	it "doesn't route invalid page paths" do
		invalid_paths = %w[/na(me) /na*me /na-me /name1/name|]
		invalid_paths.each do |invalid_path|
			expect(get: invalid_path).to_not be_routable
		end
	end
end