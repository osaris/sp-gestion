Rails.register_init ['check_lists\\new'
                     'confirmations\\edit'
                     'confirmations\\update'
                     'convocations\\new'
                     'fireman_trainings\\new'
                     'firemen\\new'
                     'items\\new'
                     'intervention_roles\\new'
                     'password_resets\\new'
                     'password_resets\\create'
                     'trainings\\new'
                     'uniforms\\new'
                     'user_sessions\\new'
                     'user_sessions\\create'
                     'users\\new'
                     'vehicles\\new'], () -> focus_first_visible_field()

# Account
#######################################################
window.account = () ->
  $('#account_update_owner').submit ->
      return confirm('Etes-vous sur ?')

Rails.register_init ['accounts\\edit'], () -> account()

# Confirmation
#######################################################
window.user_password_strength = () ->
  $('#user_password').pstrength()

Rails.register_init ['confirmations\\edit'], () -> user_password_strength()

# Convocations
#######################################################
window.convocations = () ->
  $('.change_status').click ->
    parts = $(this).attr('id').split('_')
    $('.status_'+parts[2]).attr('checked',!$('.status_'+parts[2]).attr('checked'))

  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $.timepicker.setDefaults($.timepicker.regional['fr'])
  $('.date').datetimepicker(
                              showMonthAfterYear: false
                              changeYear:         true
                              changeMonth:        true
                              dateFormat:         'dd/mm/yy'
                              constrainInput:     true
                              minDate:            '+0'
                              maxDate:            '+1y'
                              duration:           ''
                              showTime:           true
                              stepMinute:         5 )

Rails.register_init ['convocations\\new'
                     'convocations\\create'
                     'convocations\\edit'
                     'convocations\\update'], () -> convocations()

# Convocation_firemen
#######################################################

window.convocation_firemen = () ->
  $('.clickable').click ->
    checkbox = $(this).parent().find(':checkbox')
    checkbox.attr('checked', !checkbox.attr('checked'))

Rails.register_init ['convocation_firemen\\edit_all'], () -> convocation_firemen()

# Firemen
#######################################################
window.jsp = () ->
  $('#fireman_status').change ->
    if parseInt($(this).val()) == 1
      $('#accordion').accordion({ active: 5 });
    else
      $('#accordion').accordion({ active: 4 });

Rails.register_init ['firemen\\new'], () -> jsp()

window.firemen = () ->
  $('#fireman_tag_list').tagsInput(
    autocomplete_url: tags
    defaultText: 'Ajouter un tag'
    width: '100%'
    height: '75px'
  )

  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $('.date').datepicker(
                        showMonthAfterYear: false
                        showButtonPanel:    true
                        changeYear:         true
                        changeMonth:        true
                        dateFormat:         'dd/mm/yy'
                        constrainInput:     true
                        maxDate:            '+0' )
  $('.date-no-limit').datepicker(
                        showMonthAfterYear: false
                        showButtonPanel:    true
                        changeYear:         true
                        changeMonth:        true
                        dateFormat:         'dd/mm/yy'
                        constrainInput:     true )

  $("#accordion").accordion(
                        heightStyle: "content"
                        active: active_accordion )

Rails.register_init ['firemen\\new'
                     'firemen\\create'
                     'firemen\\edit'
                     'firemen\\update'], () -> firemen()

window.fireman_availabilities = () ->
  $('#calendar').fullCalendar({
    header: {
      left: ''
      right: 'prev, next today'
      center: 'title'
    }
    defaultView: 'agendaWeek'
    allowCalEventOverlap: false
    allDaySlot: false
    slotDuration: '00:60:00'
    timeFormat: ''
    contentHeight: 475
    eventStartEditable: false
    eventDurationEditable: false
    firstDay: 1
    editable: true
    timezone: "Europe/Paris"
    events: {
      url: '/firemen/' + fireman_id + '/fireman_availabilities',
    }
    dayClick : (date, jsEvent, view) ->
      date = moment.tz(date, "Europe/Paris").format()
      return if(new Date(date) <= new Date())
      $.ajax({
        type: 'POST'
        url: '/firemen/' + fireman_id + '/fireman_availabilities'
        dataType: 'json'
        data:
          fireman_availability:
            "fireman_id"   : fireman_id
            "availability" : date
        success : (data) ->
          new_event =
            title: " "
            start: data["availability"]
            end: moment(data["availability"]).add(1, 'h')
            allDay: false
            id: data["id"]
          $('#calendar').fullCalendar('renderEvent', new_event)
      })

    eventClick : (calEvent, jsEvent, view) ->
      return if(new Date(calEvent.start) <= new Date())
      $.ajax({
        type: 'DELETE'
        url: '/firemen/' + fireman_id + '/fireman_availabilities/' + calEvent.id
        success : (data) ->
          $('#calendar').fullCalendar('removeEvents', calEvent._id)
      })
  })

Rails.register_init ['fireman_availabilities\\index'], () -> fireman_availabilities()

window.firemen_stats = () ->
  $("#new_year").change ->
    $('#form_stats_firemen').submit()

Rails.register_init ['firemen\\stats'], () -> firemen_stats()

window.firemen_trainings = () ->
  oTable = $('#firemen_trainings').dataTable(
    'sScrollX':        '100%'
    'sScrollY':        '500px'
    'bFilter':         false
    'bInfo':           false
    'bPaginate':       false )
  new FixedColumns( oTable )

Rails.register_init ['firemen\\trainings'], () -> firemen_trainings()

window.fireman_trainings = () ->
  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $('.date').datepicker(
                        showMonthAfterYear: false
                        showButtonPanel:    true
                        changeYear:         true
                        changeMonth:        true
                        dateFormat:         'dd/mm/yy'
                        constrainInput:     true )

Rails.register_init ['fireman_trainings\\new'
                     'fireman_trainings\\create'
                     'fireman_trainings\\edit'
                     'fireman_trainings\\update'], () -> fireman_trainings()

window.firemen_periods = () ->
  oTable = $('#firemen_periods').dataTable(
    'sScrollX':        '100%'
    'sScrollY':        '500px'
    'bFilter':         false
    'bInfo':           false
    'bPaginate':       false
  )
  new FixedColumns( oTable )

Rails.register_init ['firemen\\periods'], () -> firemen_periods()

window.planning = () ->
  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $('.date').datepicker(
                        showMonthAfterYear: false
                        showButtonPanel:    true
                        changeYear:         true
                        changeMonth:        true
                        dateFormat:         'yy/mm/dd'
                        constrainInput:     true
                        onSelect: (dateText, inst)->
                          d = new Date(dateText)
                          $('#calendar').fullCalendar('gotoDate', d)
  )

  currentView = ""
  $('#calendar').fullCalendar({
    header: {
      left: '',
      center: 'title',
      right: 'today prev, next '
    },
    defaultView: 'agendaWeek' ,
    allDaySlot: false,
    timeFormat: '',
    slotMinutes: 60,
    disableDragging: true,
    aspectRatio: 1.35,
    firstDay: 1,
    editable: true,
    eventDataTransform : (calEvent) ->
      new_event = {}
      new_event.start = calEvent.start
      new_event.end = calEvent.end
      new_event.allDay = false
      new_event.id = calEvent.id

      #I think it's better to calculate the percentage here, in case we wanted to change the color
      #or percentage, we do not need to change the controller (I pass as title: "1,5" (1 firemen over
      # 5 in total)), for the percentage
      aux = calEvent.title.split(",")
      percentage = parseInt(aux[0]) / parseInt(aux[1])

      pomp = " pompiers"
      if(aux[0] == "1")
        pomp = " pompier"
      #new_event.title = aux[0] + pomp
      new_event.title = aux[0]

      if(percentage <= 0.25)
        new_event.className = "event_red"
      else if (percentage > 0.25 && percentage < 0.5)
        new_event.className = "event_orange"
      else if (percentage >= 0.5 && percentage < 0.75)
        new_event.className = "event_dark_green"
      else if (percentage >= 0.75)
        new_event.className = "event_green"
      else
        new_event.className = "normal_event"
      return new_event

    viewDisplay : (view) ->
      if($('#general').hasClass('active'))
        refresh_stats("general", 0)
        currentView = "general"
        refresh_firemen("general")
      else if($('#by_grade').hasClass('active'))
        refresh_stats("by_grade",$('.grade').val())
        currentView = "by_grade"
        refresh_firemen("grade")
      else if($('#by_formation').hasClass('active'))
        refresh_stats("by_formation",$('.formation').val())
        currentView = "by_formation"
        refresh_firemen("formation")

    eventClick : (calEvent, jsEvent, view) ->
      currentDate = new Date(calEvent.start)

      aux = $('.fc-event-time', this)  #The clicked div
      aux.addClass("current")

      #Just in the case that it takes time to the AJAX request
      $('.current').qtip({
        content: 'Loading firemen'
        #content: {
        #   text: '<img src="loading.gif" alt="" />',
        #}
        show : 'click'
        style: {
          classes: 'qtip-bootstrap'
        }
      })

      id = 0
      if(currentView == "by_grade")
        id = $('.grade').val()
      else if(currentView == "by_formation")
        id = $('.formation').val()

      $.ajax({
        url: '/plannings/firemen_of_period',
        data: {
          date : currentDate,
          type : currentView,
          id : id
        },
        success: (data) ->
          $('.current').qtip({
            content: data,
            position: {
              my: 'top right',
              at: 'bottom center'
            },
            show: { event: 'click', solo: true }
            #show: 'click',
            hide: { when: { event: 'unfocus' }, delay: 300, fixed: true },

            style: {
              classes: 'qtip-bootstrap'
            }

          })
          $('.current').qtip('show')
          aux.removeClass("current")
          $('.current').qtip("destroy")
      })
    })
  $('.fc-last').prevAll('td').css('backgroundColor','#ED4035')

  if($('#general').hasClass('active'))
    $('#calendar').fullCalendar('addEventSource', '/plannings/type/general')
    refresh_general()
  else if($('#by_grade').hasClass('active'))
    refresh_grades()
  else if($('#by_formation').hasClass('active'))
    refresh_formations()


  $('.formation').change( () ->
    refresh_formations()
   )

  $('.grade').change( () ->
    refresh_grades()
  )

  #Functions to refresh the calendar depending the grade/formation selected
  refresh_stats = (type, id) ->
    date = $('#calendar').fullCalendar('getDate')
    date_timestamp = (date.getTime() / 1000)
    $.ajax({
      url: '/plannings/stats',
      data: {
        start : date_timestamp
        type : type
        id : id
      },
      success: (data) ->
        $('#stats').html(data)
    })

  refresh_general = () ->
    refresh_stats("general",0)
    date = $('#calendar').fullCalendar('getDate')
    date_timestamp = (date.getTime() / 1000)
    $.ajax({
      url: '/plannings/firemen',
      data: {
        date : date_timestamp
      }
      success: (data) ->
        $('#firemen').html(data)
    })

  refresh_grades = () ->
    events = {
      url: '/plannings/type/by_grade',
      type: 'GET',
      data: {
        grade : $('.grade').val()
      },
      success: (data) ->
        #alert(data)
        console.log(data)
    }
    $('#calendar').fullCalendar( 'removeEventSource', events )
    $('#calendar').fullCalendar('addEventSource', events)

    date = $('#calendar').fullCalendar('getDate')
    date_timestamp = (date.getTime() / 1000)


    refresh_stats("by_grade",$('.grade').val())
    refresh_firemen("grade")

  refresh_formations = () ->
    events = {
      url: '/plannings/type/by_formation',
      type: 'GET',
      data: {
        formation : $('.formation').val()
      }
    }
    $('#calendar').fullCalendar( 'removeEventSource', events )
    $('#calendar').fullCalendar('addEventSource', events)


    refresh_stats("by_formation", $('.formation').val())
    refresh_firemen("formation")

  refresh_firemen = (type) ->
    date = $('#calendar').fullCalendar('getDate')
    date_timestamp = (date.getTime() / 1000)

    if(type == "grade")
      grade_val = $('.grade').val()
    else if (type == "formation")
      formation_val = $('.formation').val()

    $.ajax({
      url: '/plannings/firemen',
      data: {
        grade : grade_val
        formation : formation_val
        date : date_timestamp
      },
      success: (data) ->
        $('#firemen').html(data)
    })

Rails.register_init [ 'plannings\\type'], () -> planning()

# Interventions
#######################################################
window.interventions = () ->
  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $.timepicker.setDefaults($.timepicker.regional['fr'])
  $('.date').datetimepicker(
                            showMonthAfterYear: false
                            changeYear:         true
                            changeMonth:        true
                            dateFormat:         'dd/mm/yy'
                            minDate:            minDate
                            maxDate:            +0
                            constrainInput:     true
                            duration:           ''
                            stepMinute:         1 )

  $('input#intervention_subkind').autocomplete(subkinds,
                                               minChars:     0
                                               selectFirst:  false )

  $('input#intervention_subkind').focus ->
    $('input#intervention_subkind').click().click()

  $('input#intervention_city').autocomplete(cities,
                                            minChars:     0
                                            selectFirst:  false )

  $('input#intervention_city').focus ->
    $('input#intervention_city').click().click()

Rails.register_init ['interventions\\new'
                     'interventions\\create'
                     'interventions\\edit'
                     'interventions\\update'], () -> interventions()

window.interventions_focus = () ->
  $('#intervention_kind').focus()

Rails.register_init ['interventions\\new'], () -> interventions_focus()

window.interventions_stats = () ->
  $("#new_year").change ->
    $('#form_stats_interventions').submit()

Rails.register_init ['interventions\\stats'], () -> interventions_stats()

# Items
#######################################################
window.items = () ->
  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $('.date').datepicker(
                        showMonthAfterYear: false
                        showButtonPanel:    true
                        changeYear:         true
                        changeMonth:        true
                        dateFormat:         'dd/mm/yy' )
  $('input#item_place').autocomplete(places,
                                     minChars: 0
                                     selectFirst: false )
  $('input#item_place').focus ->
    $('input#item_place').click().click()

Rails.register_init ['items\\new'], () -> items()

# Password reset
#######################################################
Rails.register_init ['password_resets\\edit'], () -> user_password_strength()

# Vehicles
#######################################################
window.vehicles = () ->
  $.datepicker.setDefaults($.datepicker.regional['fr'])
  $('.date').datepicker(
                         showMonthAfterYear: false
                         showButtonPanel:    true
                         changeYear:         true
                         changeMonth:        true
                         dateFormat:         'dd/mm/yy' )

Rails.register_init ['vehicles\\new'
                     'vehicles\\create'
                     'vehicles\\edit'
                     'vehicles\\update'], () -> vehicles()
