# -*- encoding : utf-8 -*-
class CheckListsController < BackController

  navigation(:check_lists)

  before_filter :load_check_list, :except => [:index, :new, :create]
  before_filter :reset_back_path # for expirings items back link

  def index
    @check_lists = @station.check_lists.paginate(:page => params[:page], :order => 'title')
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        prawnto :prawn => { :page_size => "A4" },
                :inline => false, :filename => "check_liste_#{@check_list.title.filenamize}.pdf"
      end
    end
  end

  def new
    @check_list = @station.check_lists.new
  end

  def create
    @check_list = @station.check_lists.new(params[:check_list])
    if(@check_list.save)
      flash[:success] = "La liste a été créée."
      redirect_to(@check_list)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @check_list.update_attributes(params[:check_list])
      flash[:success] = "La liste a été mise à jour."
      redirect_to(@check_list)
    else
      render(:action => :edit)
    end
  end

  def copy
    @check_list = @check_list.copy
    flash[:success] = "La liste a été copiée."
    redirect_to(check_lists_path)
  end

  def destroy
    @check_list.destroy
    flash[:success] = "La liste a été supprimée."
    redirect_to(check_lists_path)
  end

  private

  def reset_back_path
    session[:back_path] = nil
  end

  def load_check_list
    @check_list = @station.check_lists.includes(:items) \
                                      .order('items.place, items.title') \
                                      .find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La liste n'existe pas."
    redirect_to(check_lists_path)
  end

end
