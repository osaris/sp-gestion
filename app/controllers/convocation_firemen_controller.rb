class ConvocationFiremenController < BackController
  
  navigation(:convocations)
  
  before_filter :load_convocation
  
  def edit
  end
  
  def update
    @convocation.convocation_firemen.each do |convocation_fireman|
      convocation_fireman.update_attribute(:presence, params[:convocation_firemen][convocation_fireman.id.to_s][:presence])
    end
    redirect_to(convocation_path(@convocation))
  end
  
  private
  
  def load_convocation
    @convocation = Convocation.find(params[:id])
    @convocation_firemen = @convocation.convocation_firemen
   rescue ActiveRecord::RecordNotFound
    redirect_to(convocations_path)
  end
  
end