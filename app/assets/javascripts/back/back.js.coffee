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
    timezone: "UTC"
    events: {
      url: '/firemen/' + fireman_id + '/fireman_availabilities',
    }
    dayClick : (date, jsEvent, view) ->
      $.ajax({
        type: 'POST'
        url: '/firemen/' + fireman_id + '/fireman_availabilities'
        dataType: 'json'
        data:
          fireman_availability:
            "fireman_id"   : fireman_id
            "availability" : new Date(date)
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
