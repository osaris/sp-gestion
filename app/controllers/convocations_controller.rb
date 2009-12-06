class ConvocationsController < BackController
  
  navigation(:convocations)
  
  before_filter :load_convocation, :except => [:index, :new, :create]
  before_filter :load_firemen, :only => [:new, :create, :edit, :update]
  before_filter :set_convocations_firemen, :only => [:create, :update]
  
  def index
    @convocations = @station.convocations.paginate(:page => params[:page], :order => 'date DESC')    
  end
  
  def show
    respond_to do |format|
      format.html
      format.pdf do
        filename = "convocation_"+l(@convocation.date, :format => :filename)+".pdf"
        send_data(@convocation.pdf.render, 
                  :filename => filename, 
                  :type => "application/pdf")
      end
    end
  end
  
  def new
    @convocation = @station.convocations.new
  end
  
  def create
    @convocation = @station.convocations.new(params[:convocation])
    if(@convocation.save)
      redirect_to(@convocation)
    else
      render(:action => :new)
    end
  end
  
  def edit
    if not @convocation.editable?
      flash[:error] = "Vous ne pouvez pas éditer une convocation passée."
      redirect_to(@convocation)
    end
  end
  
  def update
    if not @convocation.editable?
      flash[:error] = "Vous ne pouvez pas éditer une convocation passée."
      redirect_to(@convocation)
    else    
      if @convocation.update_attributes(params[:convocation])
        redirect_to(@convocation)
      else
        render(:action => :edit)
      end
    end   
  end
  
  def destroy
    @convocation.destroy
    redirect_to(convocations_path)    
  end
  
  private
  
  def load_convocation
    @convocation = @station.convocations.find(params[:id], :include => {:convocation_firemen => :fireman}, :order => 'convocation_firemen.grade DESC, firemen.lastname ASC')
   rescue ActiveRecord::RecordNotFound
    redirect_to(convocations_path)
  end
  
  def load_firemen
    @firemen = @station.firemen(:order => 'firemen.grade DESC, firemen.lastname ASC')
  end
  
  def set_convocations_firemen
    params[:convocation][:fireman_ids] ||= []
  end
  
end
