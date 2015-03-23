class ItemsController < BackController

  authorize_resource
  skip_authorize_resource :only => :expirings

  before_action :load_check_list, :except => [:expirings]
  before_action :load_item, :except => [:new, :create, :expirings]
  skip_before_action :require_html_request, :only => [:expirings]

  def expirings
    authorize!(:read, Item)
    @items = Item.expirings(30, @station.id)
    respond_to do |format|
      format.html do
        session[:back_path] = expirings_items_path
      end
      format.pdf do
        prawnto :prawn => { :page_size => "A4"},
                :inline => false, :filename => "liste_expiration_#{l(Time.now, :format => :filename)}.pdf"
      end
    end
  end

  def show
  end

  def new
    @item = @check_list.items.new
  end

  def create
    @item = @check_list.items.new(item_params)
    if @item.save
      flash[:success] = "Le matériel a été créé."
      redirect_to([@check_list, @item])
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:success] = "Le matériel a été mis à jour."
      redirect_to(session[:back_path] || [@check_list, @item])
    else
      render(:action => :edit)
    end
  end

  def destroy
    @item.destroy
    flash[:success] = "Le matériel a été supprimé."
    redirect_to(session[:back_path] || @check_list)
  end

  private

  def load_check_list
    @check_list = @station.check_lists.find(params[:check_list_id])
   rescue ActiveRecord::RecordNotFound
     flash[:error] = "La liste n'existe pas."
    redirect_to(check_lists_path)
  end

  def load_item
    @item = @check_list.items.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le matériel n'existe pas."
    redirect_to(check_list_path(@check_list))
  end

  def item_params
    params.require(:item).permit(:title, :description, :quantity, :expiry, :rem,
                                 :place, :item_photo, :remove_item_photo,
                                 :item_photo_cache)
  end
end
