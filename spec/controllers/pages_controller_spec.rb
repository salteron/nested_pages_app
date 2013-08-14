require 'spec_helper'

describe PagesController do

  describe "GET #new" do
    describe "when '/add' path" do
      it "assigns the right parent (nil)" do
        get :new
        assigns[:page].parent_id.should be_nil
      end
    end

    describe "with existsing path" do
      let!(:root) { FactoryGirl.create(:page, name: 'root') }

      it "assigns the right parent" do
        get :new, page_path: 'root'
        assigns[:page].parent_id.should eq root.id
      end

      it "renders 'new' template" do
        get :new, page_path: 'root'
        response.should render_template :new
      end
    end

    describe "with not existing path" do
      it "redirects to '/'" do
        get :new, page_path: 'root'
        response.should redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new page" do
        expect{ 
          post :create, page: FactoryGirl.attributes_for(:page)
        }.to change(Page,:count).by(1)
      end

      it "redirects to the new page" do
        root = FactoryGirl.create(:page, name: 'root')
        post :create,
              page: FactoryGirl.attributes_for(:page).merge(
            { parent_id: root.id })

        assigns[:page].parent.should eq root
        response.should redirect_to form_url( 
          "root/#{FactoryGirl.attributes_for(:page)[:name]}"
        )
      end
    end

    context "with invalid attributes" do
      describe "with invalid page name" do
        it "doesn't save the new page" do
          expect{ 
            post :create, page: FactoryGirl.attributes_for(:invalid_page)
          }.to_not change(Page,:count)
        end

        it "re-renders the new method" do
          post :create, page: FactoryGirl.attributes_for(:invalid_page)
          response.should render_template :new
        end
      end

      describe "with invalid parent_id" do
        it "redirects to the main page" do
          post :create, page: FactoryGirl.attributes_for(
                            :page_with_invalid_parent_id)
          response.should redirect_to root_path
        end
      end
    end
  end

  describe "GET #show" do
    let(:root) { FactoryGirl.create(:page, name: 'root') }
    let(:sub_page) { FactoryGirl.create(:page, name: 'sub_page',
                                               parent_id: root.id ) }
    let!(:sub_sub_page) { FactoryGirl.create(:page, name: 'sub_sub_page',
                                               parent_id: sub_page.id ) }
    describe "with existsing path" do

      it "renders 'show' for each existing path" do
        %w[root root/sub_page root/sub_page/sub_sub_page].each do |path|
          get :show, page_path: path
          response.should render_template :show
        end
      end
    end

    describe "with unexisting path" do
      it "redirects to '/'" do
        get :show, page_path: 'root/sub_sub_page/sub_page'
        response.should redirect_to root_path
      end
    end
  end

  describe "POST #update" do
    let(:root) { FactoryGirl.create :page, name: 'root' }
    let!(:sub_page) { FactoryGirl.create :page, name: 'sub_page', parent: root }

    it "assigns the right page" do
      put :update, id: root
      assigns[:page].should eq root
    end

    describe "forbidden attributes" do
      it "should not change name" do
        put :update, id: sub_page, page: { name: 'sub_sub_page' }
        expect(sub_page.reload.name).to eq 'sub_page'
      end

      it "should not change parent" do
        put :update, id: sub_page, page: { parent_id: nil }
        expect(sub_page.reload.parent_id).to eq root.id
      end
    end

    describe "with valid information" do
      before { put :update, id: root, page: { title: 'new title' } }

      it "should update page" do
        expect(root.reload.title).to eq 'new title'
      end

      it "should redirect to updated page" do
        response.should redirect_to(form_url 'root')
      end
    end

    describe "with invalid information" do
      it "re-renders  the edit method" do
        put :update, id: root, page: { title: nil }
        response.should render_template(:edit)
      end
    end
  end

  describe "GET #index" do
    it "lists all pages" do
      page1 = FactoryGirl.create(:page)
      page2 = FactoryGirl.create(:page, name: 'page2', parent_id: page1.id)
      get :index
      assigns(:pages).should include(page1, page2)
    end
  end
end
