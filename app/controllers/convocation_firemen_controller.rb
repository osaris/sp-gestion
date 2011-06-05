# -*- encoding : utf-8 -*-
class ConvocationFiremenController < BackController

  before_filter :load_convocation, :except => [:accept]
  skip_before_filter :require_user, :only => [:accept]

  def show
    @convocation_fireman = @convocation.convocation_firemen.find(params[:id])
    respond_to do |format|
      format.pdf do
        prawnto :prawn => { :page_layout => :landscape, :page_size => "A5"},
                :inline => false, :filename => "convocation_#{l(@convocation.date, :format => :filename)}.pdf"
      end
    end
  end

  def accept
    @convocation = @station.convocations.find_by_sha1(params[:convocation_id]).first
    @convocation_fireman = @convocation.convocation_firemen.find_by_sha1(params[:id]).first unless @convocation.blank?
    if !@convocation_fireman.nil? and @convocation.editable?
      @convocation_fireman.update_attribute(:presence, true)
      flash.now[:success] = "Votre confirmation a bien été prise en compte !"
    else
      flash.now[:error] = "Convocation échue ou non trouvée !"
    end
    render(:layout => 'login')
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
                :inline => false, :filename => "presence_convocation_#{l(@convocation.date, :format => :filename)}.pdf"
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
