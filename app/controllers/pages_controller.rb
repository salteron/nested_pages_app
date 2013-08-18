class PagesController < ApplicationController
  include ActiveModel::ForbiddenAttributesProtection

  before_filter :valid_parent, only: [:create]
  before_filter :current_page, only: [:show, :new, :edit]

  def index
    @pages = Page.scoped
  end

  def show
    @page = @current_page
  end

  def new
    @page = @current_page ? Page.new(parent_id: @current_page.id) : Page.new 
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      flash[:notice] = "Successfully created page!"
      redirect_to form_url_from_parts(page_ancestry_path(@page))
    else
      render :new
    end
  end

  def edit
    @page = @current_page
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_update_params)
      flash[:notice] = "Page updated!"
      redirect_to form_url_from_parts(page_ancestry_path(@page))
    else
      render :edit
    end
  end

  private

    def page_params
      params.require(:page).permit(:name, :title, :content, :parent_id)
    end

    def page_update_params
      params.require(:page).permit(:title, :content)
    end

    def valid_parent
      parent_id = params[:page][:parent_id]
      unless parent_id.blank? || Page.where(id: parent_id).any?
          # when parent_id was specified but there's no page with such one
        redirect_to root_path, notice: "Parent doesn't exist"
      end
    end
    
    #! Присваивает переменной @current_page значение, соответствующее странице
    #  с родословной, совпадающей с указанной в URI. Если такой страницы нет
    #  - редирект.
    def current_page
      return if params[:page_path].nil? # when '/add' path

      cur_page_name = params[:page_path].split('/').last 
      Page.where(name: cur_page_name).each do |page|
        return if path_exists?(params[:page_path], @current_page = page)
      end
      
      redirect_to(root_path,
                    notice: "Not existing path - \'#{params[:page_path]}\'")
    end

    def path_exists? path, page
      # Checking requested page existence, then
      # comparing path specified in url with requested page's ancestry
      page && (page_ancestry_path(page) == path)
    end
end
