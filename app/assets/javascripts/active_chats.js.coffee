# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.setupMessagePanel = (index, panel) ->
	$(panel).find('.messages').scrollTop($(panel).find('.messages').prop("scrollHeight"))
	clicker = $(panel).find('input[type="submit"]')
	$(panel).find('textarea[name="message[body]"]').focus().on 'keypress', (e) ->
		if e.keyCode is 13 and not e.shiftKey
			e.preventDefault()
			if not not $(@).val() # don't send if field is empty
				clicker.trigger('click')

$(document).on 'ready page:load', ->
	$('#active-chats-tabs a').on 'shown', ->
		$(".messaging_panel").each window.setupMessagePanel
	.first().tab('show')
