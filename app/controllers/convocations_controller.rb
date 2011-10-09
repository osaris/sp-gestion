# -*- encoding : utf-8 -*-
class ConvocationsController < BackController

  before_filter :load_convocation, :except => [:index, :new, :create]
  before_filter :load_firemen, :only => [:new, :create, :edit, :update]

  def index
    @convocations = @station.convocations.paginate(:page => params[:page], :order => 'date DESC')
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
    @convocation = @station.convocations.new(params[:convocation])
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
      if @convocation.update_attributes(params[:convocation])
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
    if @convocation.editable?
      if @station.can_send_email?(@convocation.firemen.size)
        @convocation.delay.send_emails(@current_user.email)
        flash[:success] = "Les convocations sont en cours d'envoi. Un email vous sera adressé à la fin de l'envoi."
      else
        flash[:error] = render_to_string(:partial => "email_error")
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

end
