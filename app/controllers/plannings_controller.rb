# -*- encoding : utf-8 -*-
class PlanningsController < BackController

  before_filter :load_params, :unless => lambda{ |controller| controller.request.format.html? }

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
        case params[:id]
        when "general"
          @availabilities = @station.fireman_availabilities
                                    .where(:availability => @date_range)
                                    .group(:availability)
                                    .count
          @number_of_firemen = @station.firemen.active.not_resigned.count
        when "by_grade"
          @availabilities = @station.fireman_availabilities
                                    .joins(:fireman)
                                    .where(:availability => @date_range)
                                    .where('firemen.grade_category = ?', params[:grade])
                                    .group(:availability)
                                    .count
          @number_of_firemen = @station.firemen.by_grade(params[:grade]).active.not_resigned.count
        when "by_training"
          @availabilities = @station.fireman_availabilities
                                    .joins(:fireman => :fireman_trainings)
                                    .where(:availability => @date_range)
                                    .where('fireman_trainings.training_id = ?', params[:training])
                                    .group(:availability)
                                    .count
          @number_of_firemen = @station.firemen.by_training(params[:training]).active.not_resigned.count
        end
      end
    end
  end

  # return all firemen for current planning
  def firemen
    case params[:type]
    when "general"
      @firemen = @station.fireman_availabilities
                         .firemen_for_range(@date_range)
    when "by_grade"
      @firemen = @station.fireman_availabilities
                         .firemen_for_range_and_grade(@date_range, params[:id])
    when "by_training"
      @firemen = @station.fireman_availabilities
                         .firemen_for_range_and_training(@date_range, params[:id])
    end

    respond_to do |format|
      format.html { render :partial => 'firemen' }
    end
  end

  def stats
    if params[:type] == "general"
      periods_availability = @station.fireman_availabilities
                                     .count_by_availability(@date_range)
      @number_of_firemen = @station.firemen.active.not_resigned.count
    elsif params[:type] == "by_grade"
      periods_availability = @station.fireman_availabilities
                                     .count_by_availability_for_grade(@date_range, params[:id])
      @number_of_firemen = @station.firemen.by_grade(params[:id]).active.not_resigned.count
    elsif params[:type] == "by_training"
      periods_availability = @station.fireman_availabilities
                                     .count_by_availability_for_training(@date_range, params[:id])
      @number_of_firemen = @station.firemen.by_training(params[:id]).active.not_resigned.count
    end

    ps = PlanningStatsService.new(periods_availability, @number_of_firemen)
    @periods_more_firemen     = ps.periods_more_firemen
    @periods_less_firemen     = ps.periods_less_firemen
    @periods_without_firemen  = ps.periods_without_firemen
    @occupation               = ps.occupation
    @firemen_period_average   = ps.firemen_periods_average

    respond_to do |format|
      format.html { render :partial => 'stats' }
    end
  end

  private

  def load_params
    if !params[:period].blank?
      start_date = DateTime.parse(params[:period])
      end_date = start_date + 59.minutes
    else
      start_date = DateTime.parse(params[:start]).in_time_zone.beginning_of_week
      end_date = start_date.end_of_week
    end

    @date_range = [start_date..end_date]
  end
end
