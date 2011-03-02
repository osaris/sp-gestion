# -*- encoding : utf-8 -*-
class UniformsController < BackController
  
  navigation(:uniforms)
  
  before_filter :load_uniform, :except => [:index, :new, :create, :reset]
  
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
      flash[:success] = "La tenue a été créée."
      redirect_to(@uniform)
    else
      render(:action => :new)
    end
  end
  
  def edit
  end
  
  def update
    if @uniform.update_attributes(params[:uniform])
      flash[:success] = "La tenue a été mise à jour."
      redirect_to(@uniform)
    else
      render(:action => :edit)
    end    
  end
  
  def destroy
    if @uniform.destroy
      flash[:success] = "La tenue a été supprimée."
      redirect_to(uniforms_path)
    else
      flash[:error] = @uniform.errors.full_messages.join("")
      redirect_to(@uniform)
    end
  end
  
  def reset
    Uniform.create_defaults(@station)
    flash[:success] = "Les tenues par défaut ont été ajoutées."
    redirect_to(uniforms_path)
  end
  
  private
  
  def load_uniform
    @uniform = @station.uniforms.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La tenue n'existe pas."
    redirect_to(uniforms_path)
  end
  
end
