# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
	$('input[type^="filepicker"]').on 'change', (event)->
		if event.originalEvent.fpfile?
			$(this.form).find('input[data-filepicker-meta="filename"]').val(event.originalEvent.fpfile.filename)
			$(this.form).find('input[data-filepicker-meta="size"]').val(event.originalEvent.fpfile.size)
			$(this.form).find('input[data-filepicker-meta="mimetype"]').val(event.originalEvent.fpfile.mimetype)
			if $(this.form).data('submit-on-pick')
				this.form.submit()
		else
			$(this.form).find('input[data-filepicker-meta="filename"]').val('')
			$(this.form).find('input[data-filepicker-meta="size"]').val('')
			$(this.form).find('input[data-filepicker-meta="mimetype"]').val('')
