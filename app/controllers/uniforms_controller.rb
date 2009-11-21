class UniformsController < BackController
  
  navigation(:uniforms)
  
  before_filter :load_uniform, :except => [:index, :new, :create]
  
  def index
    @uniforms = @station.uniforms.paginate(:page => params[:page], :order => 'code, title')
  end
  
  def show
  end
  
  def new
    @uniform = @station.uniforms.new
  end
  
  def create
    @uniform = @station.uniforms.new(params[:uniform])
    if(@uniform.save)
      render(:action => :show)
    else
      render(:action => :new)
    end
  end
  
  def edit
  end
  
  def update
    if @uniform.update_attributes(params[:uniform])
      render(:action => :show)
    else
      render(:action => :edit)
    end    
  end
  
  def destroy
    @uniform.destroy
    redirect_to(uniforms_path)
  end
  
  private
  
  def load_uniform
    @uniform = @station.uniforms.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    redirect_to(uniforms_path)
  end
  
end
