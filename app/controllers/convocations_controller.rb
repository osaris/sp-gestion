# -*- encoding : utf-8 -*-
class ConvocationsController < BackController

  authorize_resource
  skip_authorize_resource :only => :email

  before_action :require_not_demo, :only => [:email]
  before_action :load_convocation, :except => [:index, :new, :create]
  before_action :load_firemen, :only => [:new, :create, :edit, :update]
  skip_before_action :require_html_request, :only => [:show]

  def index
    @convocations = @station.convocations
                            .page(params[:page])
                            .order('date DESC')
  end

  def show
    @presence = @convocation.presence
    respond_to do |format|
      format.html
      format.pdf do
        prawnto :prawn => { :page_layout => :landscape, :page_size => "A5"},
                :inline => false, :filename => "convocation_#{l(@convocation.date, :format => :filename)}.pdf"
      end
    end
  end

  def new
    @convocation = @station.convocations.new
    set_attendees
  end

  def create
    @convocation = @station.convocations.new(convocation_params)
    if(@convocation.save)
      flash[:success] = "La convocation a été créée."
      redirect_to(@convocation)
    else
      set_attendees
      render(:action => :new)
    end
  end

  def edit
    if not @convocation.editable?
      flash[:error] = "Vous ne pouvez pas éditer une convocation passée."
      redirect_to(@convocation)
    else
      set_attendees
    end
  end

  def update
    if not @convocation.editable?
      flash[:error] = "Vous ne pouvez pas éditer une convocation passée."
      redirect_to(@convocation)
    else
      # overwrite params because browser doesn't send array if no checkbox are selected
      # and rails omit them in this case !
      params[:convocation][:fireman_ids] ||= []
      if @convocation.update_attributes(convocation_params)
        flash[:success] = "La convocation a été mise à jour."
        redirect_to(@convocation)
      else
        set_attendees
        render(:action => :edit)
      end
    end
  end

  def destroy
    @convocation.destroy
    flash[:success] = "La convocation a été supprimée."
    redirect_to(convocations_path)
  end

  def email
    authorize!(:create, Convocation)
    if @convocation.editable?
      if @station.can_send_email?(@convocation.firemen.size)
        SendConvocationsJob.perform_later(@convocation, @current_user)
        flash[:success] = "Les convocations sont en cours d'envoi. Un email vous sera adressé à la fin de l'envoi."
      else
        flash[:error] = render_to_string("email_error")
      end
    else
      flash[:error] = "Vous ne pouvez pas envoyer par email une convocation passée."
    end
    redirect_to(@convocation)
  end

  private

  def load_convocation
    @convocation = @station.convocations.includes({:convocation_firemen => :fireman}) \
                                        .order('convocation_firemen.grade DESC, firemen.lastname ASC') \
                                        .find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La convocation n'existe pas."
    redirect_to(convocations_path)
  end

  def load_firemen
    @firemen = @station.firemen.not_resigned.order_by_grade_and_lastname
  end

  def set_attendees
    @attendees = Hash.new
    @convocation.firemen.each do |f|
      @attendees[f.id] = true
    end
  end

  def convocation_params
    params.require(:convocation).permit(:title, :date, :uniform_id, :place,
                                        :rem, :hide_grade, :confirmable,
                                        fireman_ids: [])
  end
end
