class InterventionsController < BackController
  
  navigation(:interventions_list)
  
  before_filter :load_intervention, :except => [:index, :new, :create, :stats]
  before_filter :load_vehicles, :except => [:index, :show, :destroy, :stats]
  before_filter :load_firemen, :except => [:index, :show, :destroy, :stats]
  before_filter :set_fireman_interventions, :only => [:create, :update]
  
  def index
    @interventions = @station.interventions.paginate(:page => params[:page], :include => [:vehicles, {:fireman_interventions => [:fireman]}], 
                                                     :order => 'interventions.start_date DESC')
  end
  
  def show
  end
  
  def new
    @intervention = @station.interventions.new
    set_participants
  end
  
  def create
    @intervention = @station.interventions.new(params[:intervention])
    if(@intervention.save)
      flash[:success] = "L'intervention a été créée."
      redirect_to(@intervention)
    else
      set_participants
      render(:action => :new)
    end
  end
  
  def edit
    if not @intervention.editable?
      flash[:error] = "Vous ne pouvez pas éditer cette intervention car les grades ont évolué."
      redirect_to(@intervention)
    else
      set_participants
    end    
  end
  
  def update
    if not @intervention.editable?
      flash[:error] = "Vous ne pouvez pas éditer cette intervention car les grades ont évolué."
      redirect_to(@intervention)
    else
      if @intervention.update_attributes(params[:intervention])
        flash[:success] = "L'intervention a été mise à jour."
        redirect_to(@intervention)
      else
        set_participants
        render(:action => :edit)
      end
    end
  end
  
  def destroy
    @intervention.destroy
    flash[:success] = "L'intervention a été supprimée."
    redirect_to(interventions_path)
  end
  
  def stats
    @by_type = Intervention::stats_by_type(@station)
    current_navigation(:interventions_stats)
  end
  
  private
  
  def load_intervention
    @intervention = @station.interventions.find(params[:id], :include => [:vehicles, {:fireman_interventions => [:fireman]}])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "L'intervention n'existe pas."
    redirect_to(interventions_path)
  end
  
  def load_vehicles
    @vehicles = @station.vehicles
  end
  
  def load_firemen
    @firemen = @station.firemen.find(:all, :conditions => {:status => 3},
                                           :order => 'firemen.grade DESC, firemen.lastname ASC')
  end  
  
  def set_fireman_interventions
    params[:intervention][:fireman_ids] ||= []
  end
  
  def set_participants
    @participants = Hash.new
    @intervention.firemen.each do |f|
      @participants[f.id] = true
    end
  end
  
end
