class ConvocationFiremenController < BackController
  
  navigation(:convocations)
  
  before_filter :load_convocation

  def show
    @convocation_fireman = @convocation.convocation_firemen.find(params[:id])
    respond_to do |format|
      format.pdf do
        prawnto :prawn => { :page_layout => :landscape, :page_size => "A5"},
                :inline => false, :filename => "convocation_#{@convocation.id}.pdf"
      end
    end
  end

  def edit_all
  end
  
  def update_all
    @convocation.convocation_firemen.each do |convocation_fireman|
      convocation_fireman.update_attribute(:presence, params[:convocation_firemen][convocation_fireman.id.to_s][:presence])
    end
    flash[:success] = "Les présences ont été mises à jour."
    redirect_to(convocation_path(@convocation))
  end
  
  def show_all
    respond_to do |format|
      format.pdf do
        prawnto :prawn => { :page_size => "A4"},
                :inline => false, :filename => "presence_convocation_#{@convocation.id}.pdf"
      end
    end    
  end
  
  private
  
  def load_convocation
    @convocation = @station.convocations.find(params[:convocation_id])
    @convocation_firemen = @convocation.convocation_firemen
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La convocation n'existe pas."
    redirect_to(convocations_path)
  end
  
end