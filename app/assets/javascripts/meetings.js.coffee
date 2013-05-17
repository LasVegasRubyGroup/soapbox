# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class window.MeetingShow
  constructor: ->
    @wireKudoButtons()

  wireKudoButtons: ->
    $('.btn-kudo').on 'click', (e) ->
      e.preventDefault()
      url = $(e.target).data('url') + '.json'
      $.ajax url,
        type: 'put'
        statusCode:
          200: ->
            $('.btn-kudo').remove()


class window.MeetingForm
  constructor: ->
    @wireTopics()
    @wireTimeSlots()
    @wirePresenters()
    @fillExistingData()

  wireTopics: ->
    $('li.simple_topic').draggable({ revert: true })
    $('li.simple_topic').popover
      placement: 'left'
      trigger: 'hover'

  wireTimeSlots: =>
    $('fieldset.time_slot').droppable(
      drop: @topic_dropper
    )

  wirePresenters: =>
    $('select').on 'change', (e) ->
      # console.log  $($(@).parent().find('.presenter_id'))
      $(@).parent().find('.presenter_id').val($(@).val())

  fillExistingData: =>
    topics = $('.topic_id')
    for topic in topics
      topic_id = $(topic).val()
      if topic_id.length > 0
        t = $(".simple_topic[data-id=#{topic_id}]")
        name = $(t).find('.topic_title').text()
        volunteers = $(t).data('volunteers')
        $(topic).parent().find('.topic_title').text(name)
        options_string = for volunteer in volunteers
          "<option value='#{volunteer.id}'>#{volunteer.name}</option>"
        $(topic).parents('.time_slot').find('select').html(options_string.join("\n"))
    presenters = $('.presenter_id')
    for presenter in presenters
      presenter_id = $(presenter).val()
      if presenter_id.length > 0
        $(presenter).parents('.time_slot').find('select').val(presenter_id)

  topic_dropper: (e,ui) ->
    id = $(ui.draggable).data('id')
    name = $(ui.draggable).find('.topic_title').text()
    volunteers = $(ui.draggable).data('volunteers')
    unless volunteers.length > 0
      volunteers = window.all_users 
    $(@).find('.topic_id').val(id)
    $(@).find('.topic_title').text(name)
    options_string = for volunteer in volunteers
      "<option value='#{volunteer.id}'>#{volunteer.name}</option>"
    $(@).find('select').html(options_string.join("\n"))
    $(@).find('.presenter_id').val(volunteers[0].id)

$ ->
  if $('.meeting_form').length > 0
    new window.MeetingForm()
  if $('.btn-kudo').length > 0
    new window.MeetingShow()



if ($("#kudos_graph").length > 0)
  Morris.Bar
    element: 'kudos_graph'
    data: $('#kudos_graph').data('subjects')
    xkey: 'presenter'
    ykeys: ['kudos']
    labels: ['Kudos']
    gridTextSize: 25
    barColors: ['#ae1833']
    gridTextColor: ['#ae1833']






















