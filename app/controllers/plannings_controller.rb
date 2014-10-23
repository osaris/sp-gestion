class PlanningsController < BackController

  def show
    respond_to do |format|
      format.html do
        case params[:id]
          when "by_grade"
            @grades = @station.firemen
                              .active
                              .group(:grade_category)
                              .pluck(:grade_category)
                              .collect { |gc| [ Grade::GRADE_CATEGORY_PLURAL.key(gc), gc ] }
          when "by_training"
            @trainings = @station.trainings
                                 .collect { |t| [ t.short_name, t.id ] }
        end
      end
      format.json do
        start_date = DateTime.parse(params[:start]).in_time_zone.beginning_of_week
        end_date = start_date.end_of_week

        case params[:id]
        when "general"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date).group(:availability).count
          @firemen_count = @station.firemen.count
        when "by_grade"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.firemen.where(:grade_category => params[:grade])).group(:availability).count
          @firemen_count = @station.firemen.where(:grade_category => params[:grade]).count
        when "by_training"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.fireman_trainings.where(:training_id => params[:training]).select(:fireman_id)).group(:availability).count
          @firemen_count = @station.firemen.where(:id => @station.fireman_trainings.where(:training_id => params[:training]).select(:fireman_id)).count
        end
      end
    end
  end

  # return all firemen for current planning
  def firemen
    start_date = DateTime.parse(params[:date]).in_time_zone.beginning_of_week
    end_date = start_date.end_of_week

    case params[:type]
    when "general"
      @firemen = @station.firemen.where(:id => @station.fireman_availabilities.where(
                                        :availability => start_date..end_date).select(:fireman_id))
    when "by_grade"
      @firemen = @station.firemen.where(:grade_category => params[:id],
                                        :id => @station.fireman_availabilities.where(
                                        :availability => start_date..end_date).select(:fireman_id))
    when "by_training"
      @firemen = @station.firemen.where(:id => @station.fireman_trainings.where(:training_id => params[:id]).select(:fireman_id))
                                 .where(:id => @station.fireman_availabilities.where(:availability => start_date..end_date).select(:fireman_id))
    end

    respond_to do |format|
      format.html { render :partial => 'firemen' }
    end
  end

  def stats
    start_date = DateTime.parse(params[:start]).in_time_zone.beginning_of_week
    end_date = start_date.end_of_week

    if params[:type] == "general"
      periods_availability = @station.fireman_availabilities.where(:availability => start_date..end_date).group(:availability).count
      @number_of_firemen = @station.firemen.count
    elsif params[:type] == "by_grade"
      periods_availability = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.firemen.where(:grade_category => params[:id])).group(:availability).count
      @number_of_firemen = @station.firemen.where(:grade_category => params[:id]).count
    elsif params[:type] == "by_training"
      periods_availability = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.fireman_trainings.where(:training_id => params[:id]).select(:fireman_id)).group(:availability).count
      @number_of_firemen = @station.firemen.where(:id => @station.fireman_trainings.where(:training_id => params[:id]).select(:fireman_id)).count
    end

    number_of_periods = periods_availability.inject(0) { |sum, x| sum + x[1] }

    @periods_more_firemen = periods_availability.sort_by { |x| [-x[1], x[0]] }[0..4]
    @periods_less_firemen = periods_availability.sort_by { |x| [x[1], x[0]] }[0..4]

    # total number of periods of a week - periods occupied
    @periods_without_firemen = 7 * 24 - periods_availability.length

    # occupation general of the planning
    @occupation = ((number_of_periods / (7*24.0 * @number_of_firemen)) * 100).to_i

    # Average of the firemen in a period
    @firemen_period_average = number_of_periods / (24 * 7)

    respond_to do |format|
      format.html { render :partial => 'stats' }
    end
  end
end
