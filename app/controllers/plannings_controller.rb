class PlanningsController < BackController

  def type
    respond_to do |format|
      format.html do
        case params[:type]
          when "by_grade"
            @grades = @station.firemen
                              .active
                              .group(:grade_category)
                              .pluck(:grade_category)
                              .collect { |gc| [ Grade::GRADE_CATEGORY_PLURAL.key(gc), gc ] }
          when "by_formation"
            @trainings = @station.trainings
                                 .collect { |t| [ t.short_name, t.id ] }
        end
      end
      format.json do
        start_date = DateTime.parse(params[:start]).in_time_zone.beginning_of_week
        end_date = start_date.end_of_week

        if params[:type] == "general"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date).group(:availability).count
          @firemen_count = @station.firemen.count
        elsif params[:type] == "by_grade"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.firemen.where(:grade_category => params[:grade])).group(:availability).count
          @firemen_count = @station.firemen.where(:grade_category => params[:grade]).count
        elsif params[:type] == "by_formation"
          @availabilities = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.fireman_trainings.where(:training_id => params[:formation]).select(:fireman_id)).group(:availability).count
          @firemen_count = @station.firemen.where(:id => @station.fireman_trainings.where(:training_id => params[:formation]).select(:fireman_id)).count
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
    when "by_formation"
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

    #Calculing stats
    #date_numer : list of dates and his number of firemen
    date_number = []
    periods_with_more_firemen = []
    periods_with_less_firemen = []

    #Takinig period with more and less firemen
    if params[:type] == "general"
      date_number = @station.fireman_availabilities.where(:availability => start_date..end_date).group(:availability).count
      @number_of_firemen = @station.firemen.count

      # @periods_with_more_firemen = firemen_periods_stats('DESC', "general", 0, start_date, end_date)
      # @periods_with_less_firemen = firemen_periods_stats('ASC', "general", 0, start_date, end_date)
    elsif params[:type] == "by_grade"
      grade = params[:id]

      date_number = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.firemen.where(:grade_category => grade)).group(:availability).count
      @number_of_firemen = @station.firemen.where(:grade_category => grade).count

      # @periods_with_more_firemen = firemen_periods_stats('DESC', "by_grade", grade, start_date, end_date)
      # @periods_with_less_firemen = firemen_periods_stats('ASC', "by_grade", grade, start_date, end_date)
    elsif params[:type] == "by_formation"
      formation = params[:id]

      date_number = @station.fireman_availabilities.where(:availability => start_date..end_date, :fireman_id => @station.fireman_trainings.where(:training_id => formation).select(:fireman_id)).group(:availability).count
      @number_of_firemen = @station.firemen.where(:id => @station.fireman_trainings.where(:training_id => formation).select(:fireman_id)).count

      # @periods_with_more_firemen = firemen_periods_stats('DESC', "by_formation", formation, start_date, end_date)
      # @periods_with_less_firemen = firemen_periods_stats('ASC', "by_formation", formation, start_date, end_date)
    end

    number_of_periods = 0
    date_number.each do |dn|
      number_of_periods = number_of_periods + dn[1]
    end

    taken_periods = date_number.length

    @periods_without_firemen = 7 * 24 - taken_periods #total periods of a week - taken_periods

    #occupation general of the planning: it would be 100% when all the firemen works all the periods
    # Improve in production (if all the firemen works 8 hours all days, it would be aroun 33%)
    #occupation = (number_of_periods / (7*24.0 * number_of_firemen)).round(4) Without decimals:
    @occupation = ((number_of_periods / (7*24.0 * @number_of_firemen)) * 100).to_i

    #Average of the firemen in a period
    @firemen_period_average = number_of_periods / (24 * 7)

    respond_to do |format|
      format.html { render :partial => 'stats' }
    end
  end
end
