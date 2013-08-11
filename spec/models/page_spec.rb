require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }
	subject { page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:content)}

  it { should be_valid}

  describe "when name is not present" do
    before { page.name = " " }
    it { should_not be_valid }
  end

  describe "when name is reserved" do
  	it do
  		Page::FORBIDDEN_NAMES.each do |f_name|
  			page.name = f_name
  			should_not be_valid
  		end
  	end
  end

  describe "when title is not present" do
    before { page.title = " " }
    it { should_not be_valid }
  end

  describe "when content is not present" do
    before { page.content = "" }
    it { should be_valid }
  end

  describe "when content is nil" do
  	before { page.content = nil }
  	it { should_not be_valid}
  end

  describe "tree associations" do
  	let(:child_page) { FactoryGirl.create(:page, parent: page) }
  	let(:grand_child_page) { FactoryGirl.create(:page, parent: child_page) }
  	before { page.save }
		
  	it "should be root page" do
  		expect(page.parent).to be_nil
  		expect(Page.roots).to include(page)
  	end

  	its(:children) { should include(child_page) }
  	its(:children) { should_not include(grand_child_page) }
  	its(:descendants) { should include(child_page)}
  	its(:descendants) { should include(grand_child_page)}

  	describe "child_page" do
  		subject { child_page }

			its(:root) { should eq page}
  		its(:parent) { should  eq page }
  		its(:children) { should include(grand_child_page) }
  	end

  end
end
