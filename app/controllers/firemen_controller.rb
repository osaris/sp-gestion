# -*- encoding : utf-8 -*-
class FiremenController < BackController

  helper(:interventions)

  before_filter :load_fireman, :except => [:index, :new, :create, :tag]
  before_filter :load_tags, :only => [:new, :create, :edit, :update]

  def index
    @firemen = @station.firemen.paginate(:page => params[:page], :order => 'firemen.grade DESC, firemen.lastname ASC')
  end

  def show
  end

  def new
    @fireman = @station.firemen.new
  end

  def create
    @fireman = @station.firemen.new(params[:fireman])
    if(@fireman.save)
      flash[:success] = "La personne a été créée."
      redirect_to(@fireman)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @fireman.update_attributes(params[:fireman])
      flash[:success] = "La personne a été mise à jour."
      redirect_to(@fireman)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @fireman.destroy
      flash[:success] = "La personne a été supprimée."
      redirect_to(firemen_path)
    else
      flash[:error] = @fireman.errors.full_messages.join("")
      redirect_to(@fireman)
    end
  end

  private

  def load_fireman
    @fireman = Fireman.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La personne n'existe pas."
    redirect_to(firemen_path)
  end

  def load_tags
    @tags = Fireman.distinct_tags(@station).to_json
  end

end
