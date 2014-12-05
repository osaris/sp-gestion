class PlanningStatsService

  def initialize(periods_availability, number_of_firemen)
    @periods_availability = periods_availability
    @number_of_firemen = number_of_firemen

    @number_of_periods = periods_availability.inject(0) { |sum, x| sum + x[1] }
  end

  def periods_more_firemen
    @periods_availability.sort_by { |x| [-x[1], x[0]] }[0..4]
  end

  def periods_less_firemen
    @periods_availability.sort_by { |x| [x[1], x[0]] }[0..4]
  end

  def periods_without_firemen
    7 * 24 - @periods_availability.length
  end

  def occupation
    if @number_of_firemen > 0
      return ((@number_of_periods / (7*24.0 * @number_of_firemen)) * 100).to_i
    else
      return 0
    end
  end

  def firemen_periods_average
    @number_of_periods / (24 * 7)
  end
end
