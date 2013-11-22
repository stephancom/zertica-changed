# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setupMessagePanels = ->
	$(".messaging_panel").each ->
		$(this).find('.messages').scrollTop($(this).find('.messages').prop("scrollHeight"))
		clicker = $(this).find('input[type="submit"]')
		$(this).find('textarea[name="message[body]"]').focus().on 'keypress', (e) ->
			if e.keyCode is 13 and not e.shiftKey
				e.preventDefault()
				if not not $(@).val() # don't send if field is empty
					clicker.trigger('click')

$(document).on 'ready page:load', ->
	setupMessagePanels()
	$('#active-chats-tabs a').on 'shown', ->
		setupMessagePanels()
	$('#active-chats-tabs a:first').tab('show')