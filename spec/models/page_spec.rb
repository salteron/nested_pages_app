require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.build(:page) }
	subject { page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:content)}

  it { should be_valid}

  describe "when name is not present" do
    before { page.name = " " }
    it { should_not be_valid }
  end

  describe "when name is invalid" do
    invalid_names = ['has whitepsace', '/has_slash', '*&!@#']

    it "should not be valid" do
      invalid_names.each do |name|
        page.name = name
        expect(page).not_to be_valid
      end
    end
  end

  describe "when name is reserved" do
  	it do
  		Page::FORBIDDEN_NAMES.each do |f_name|
  			page.name = f_name
  			should_not be_valid
  		end
  	end
  end

  describe "when name already exists" do
    let(:page_with_the_same_name) { page.dup }

    before { page.save } 
    
    subject { page_with_the_same_name }

    it { should_not be_valid }
    
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

  describe "input safety" do
    describe "when title contains tags" do
      it "should strip them" do
        page.title = "<h1>title</h1>"
        page.save
        expect(page.title).to eq "title"
      end
    end

    describe "when content contrains javascrript" do
      it "should sanitize it" do
        page.content = "<javascript>alert('alarm!')</javascrript>" +
                       "<h1>content</h1>"
        page.save
        expect(page.content).to eq "alert('alarm!')<h1>content</h1>"
      end
    end
  end

  describe "tree associations" do
    before { page.save }

  	let(:child_page) { FactoryGirl.create(:page, name: 'child_page',
                                           parent_id: page) }
  	let(:grand_child_page) { FactoryGirl.create(:page, name: 'grand_child_page',
                                           parent_id: child_page) }
  	
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
