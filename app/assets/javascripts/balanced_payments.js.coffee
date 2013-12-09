#          __  __                    _      _   
#  __ ___ / _|/ _|___ ___ ___ __ _ _(_)_ __| |_ 
# / _/ _ \  _|  _/ -_) -_|_-</ _| '_| | '_ \  _|
# \__\___/_| |_| \___\___/__/\__|_| |_| .__/\__|
#     _          _                    |_|        
#    | |__  __ _| |__ _ _ _  __ ___ __| |     by   
#    | '_ \/ _` | / _` | ' \/ _/ -_) _` | stephan.com         
#    |_.__/\__,_|_\__,_|_||_\__\___\__,_|  (c) 2013           

# a coffeescript library for balanced payments

class @zBalanced

  constructor: (form, @options) ->
    # balanced.init @options.marketplaceUri
    balanced.init '/v1/marketplaces/TEST-MP5X26XD6x8T3RUJxZ5HryvC'

    @form = $(form)
    @form.on 'submit', @submitForm
    console.log "Constructing with xxx #{@form}"

    # hmm, needed?  maybe
    $('[data-dismiss="alert"]').on "click", (e) ->
      $(this).closest(".alert").fadeOut "fast"
      resetForm()
      e.preventDefault()

  #  todo - what if we have a 409?
  showProcessing: (message, progress) ->
    progress = progress or 50
    $loader = $(".loading")
    unless $loader.length
      $loader = $("<div class=\"loading\">" + "<div class=\"progress progress-striped active\">" + "<div class=\"bar\"></div>" + "</div>" + "<p>&nbsp;</p>" + "</div>")
      $loader.appendTo "body"
    $loader.find(".bar").css width: progress + "%"
    $loader.find("p").text message
    $loader.css(
      left: $("body").width() / 2 - $loader.width() / 4
      top: "400px"
    ).show()

  hideProcessing: ->
    $(".loading").hide()

  showError: (message) ->
    $alert = $(".alert:visible")
    $alert.remove()  if $alert.length
    $alert = $("<div class=\"alert alert-absolute alert-block alert-error\">" + "<button class=\"close\" data-dismiss=\"alert\">&times;</button>" + "<h4 class=\"alert-heading\">Error!</h4>" + message + "</div>")
    $alert.appendTo("body").css(
      left: $("body").width() / 2 - $alert.width() / 4
      top: "400px"
    ).show()

  hideError: ->
    $(".alert").hide()

  resetForm: ->
    @form.find(".control-group").removeClass "error"
    @form.find("input,button,select").removeAttr "disabled"

  disableForm: ->
    @form.find("input, button, select").attr "disabled", "disabled"

  addErrorToField: (fieldName) ->
    @form.find("[name$=\"" + fieldName + "\"]").closest(".control-group").addClass "error"

  removeSensitiveFields: -> #($form, sensitiveFields) ->
    @form.find("[name$='#{field}']").closest('.control-group').remove() for field in @sensitiveFields


## TODO - this is untested and incomplete
class @zBalancedPurchase extends @zBalanced
  sensitiveFields: ["card_number", "expiration_month", "expiration_year"]

  submitForm: (e) ->
    $form = $("form#purchase")
    
    #  this is the repeat flow, let it happen naturally
    return  if $form.find("input:visible").length is 0
    e.preventDefault()
    resetForm $form
    
    #  build data to submit
    cardData = $form.serializeObject()
    for key of cardData
      trimmedKey = key.replace("guest-", "").replace("purchase-", "")
      cardData[trimmedKey] = cardData[key]
      delete cardData[key]
    name = $("[name$=\"name\"]", $form).val()
    emailAddress = $("[name$=\"email_address\"]", $form).val()
    
    #  validate form
    addErrorToField "name"  unless name
    addErrorToField "email_address"  unless balanced.emailAddress.validate(emailAddress)
    addErrorToField "card_number"  unless balanced.card.isCardNumberValid(cardData.card_number)
    addErrorToField "expiration_month"  unless balanced.card.isExpiryValid(cardData.expiration_month, cardData.expiration_year)
    return  if $form.find(".control-group.error").length
    
    #  submit
    disableForm $form
    showProcessing "Processing payment...", 33
    balanced.card.create cardData, completePurchase


  completePurchase: (response) ->
    $form = $("form#purchase")
    sensitiveFields = ["card_number", "expiration_month", "expiration_year"]
    hideProcessing()
    switch response.status
      when 201
        showProcessing "Renting bike...", 66
        
        #  IMPORTANT - remove sensitive data to remain PCI compliant
        removeSensitiveFields $form, sensitiveFields
        $form.find("input").removeAttr "disabled"
        $("<input type=\"hidden\" name=\"card_uri\" value=\"" + response.data.uri + "\">").appendTo $form
        $form.unbind("submit", submitPurchase).submit()
      when 400
        fields = ["card_number", "expiration_month", "expiration_year", "security_code"]
        found = false
        i = 0

        while i < fields.length
          isIn = response.error.description.indexOf(fields[i]) >= 0
          console.log isIn, fields[i], response.error.description
          if isIn
            resetForm $form
            addErrorToField $form, fields[i]
          i++
        unless found
          console.warn "missing field - check response.error for details"
          console.warn response.error
      when 402
        console.warn "we couldn't authorize the buyer's credit card - check response.error for details"
        console.warn response.error
        showError "We couldn't authorize this card, please check your card details and try again"
      when 404
        console.warn "your marketplace URI is incorrect"
      when 500
        console.error "Balanced did something bad, this will never happen, but if it does please retry the request"
        console.error response.error
        showError "Balanced did something bad, please retry the request"


class @zBalancedBankAccount extends @zBalanced
  sensitiveFields: ['bank_code', 'account_number']

  submitForm: (e) =>
    @form.find(".control-group").removeClass "error"
    merchantData = @form.serializeObject()
    @addErrorToField @form, "bank_account[name]" unless merchantData["bank_account[name]"]

    hasBankAccount = false
    if merchantData.account_number or merchantData.bank_code
      hasBankAccount = true
      @addErrorToField @form, "bank_code"  unless balanced.bankAccount.validateRoutingNumber(merchantData.bank_code)
      @addErrorToField @form, "account_number"  unless merchantData.account_number
    if @form.find(".control-group.error").length
      e.preventDefault()
      return
    if hasBankAccount
      e.preventDefault()
      @disableForm @form
      @showProcessing "Adding bank account...", 33
      @removeSensitiveFields()
      bankAccountData = 
        name: merchantData["bank_account[name]"]
        routing_number: merchantData.bank_code
        account_number: merchantData.account_number
      balanced.bankAccount.create bankAccountData, @onCardTokenized

  onCardTokenized: (response) =>
    @hideProcessing()
    switch response.status
      when 201
        @form.find("input,select").removeAttr "disabled"
        @showProcessing "Performing identity check...", 66
        @form.find('[name$="bank_account[bank_account_uri]"]').val(response.data.uri)
        @form.unbind("submit", @submitForm).submit()


# KYC == "Know Your Customer"
class @Balanced
  constructor: (@options) ->
    balanced.init @options.marketplaceUri
    $("form.balanced-purchase").submit submitPurchase
    $("form.edit_bank_account").submit submitKYC

    # hmm, needed?  maybe
    $('[data-dismiss="alert"]').on "click", (e) ->
      $(this).closest(".alert").fadeOut "fast"
      resetForm()
      e.preventDefault()

  submitPurchase = (e) ->
    $form = $("form#purchase")
    
    #  this is the repeat flow, let it happen naturally
    return  if $form.find("input:visible").length is 0
    e.preventDefault()
    resetForm $form
    
    #  build data to submit
    cardData = $form.serializeObject()
    for key of cardData
      trimmedKey = key.replace("guest-", "").replace("purchase-", "")
      cardData[trimmedKey] = cardData[key]
      delete cardData[key]
    name = $("[name$=\"name\"]", $form).val()
    emailAddress = $("[name$=\"email_address\"]", $form).val()
    
    #  validate form
    addErrorToField $form, "name"  unless name
    addErrorToField $form, "email_address"  unless balanced.emailAddress.validate(emailAddress)
    addErrorToField $form, "card_number"  unless balanced.card.isCardNumberValid(cardData.card_number)
    addErrorToField $form, "expiration_month"  unless balanced.card.isExpiryValid(cardData.expiration_month, cardData.expiration_year)
    return  if $form.find(".control-group.error").length
    
    #  submit
    disableForm $form
    showProcessing "Processing payment...", 33
    balanced.card.create cardData, completePurchase

  completePurchase = (response) ->
    $form = $("form#purchase")
    sensitiveFields = ["card_number", "expiration_month", "expiration_year"]
    hideProcessing()
    switch response.status
      when 201
        showProcessing "Renting bike...", 66
        
        #  IMPORTANT - remove sensitive data to remain PCI compliant
        removeSensitiveFields $form, sensitiveFields
        $form.find("input").removeAttr "disabled"
        $("<input type=\"hidden\" name=\"card_uri\" value=\"" + response.data.uri + "\">").appendTo $form
        $form.unbind("submit", submitPurchase).submit()
      when 400
        fields = ["card_number", "expiration_month", "expiration_year", "security_code"]
        found = false
        i = 0

        while i < fields.length
          isIn = response.error.description.indexOf(fields[i]) >= 0
          console.log isIn, fields[i], response.error.description
          if isIn
            resetForm $form
            addErrorToField $form, fields[i]
          i++
        unless found
          console.warn "missing field - check response.error for details"
          console.warn response.error
      when 402
        console.warn "we couldn't authorize the buyer's credit card - check response.error for details"
        console.warn response.error
        showError "We couldn't authorize this card, please check your card details and try again"
      when 404
        console.warn "your marketplace URI is incorrect"
      when 500
        console.error "Balanced did something bad, this will never happen, but if it does please retry the request"
        console.error response.error
        showError "Balanced did something bad, please retry the request"

  submitKYC = (e) ->
    $form = $("form#kyc")
    $form.find(".control-group").removeClass "error"
    
    #  validate form
    merchantData = $form.serializeObject()
    for key of merchantData
      trimmedKey = key.replace("guest-", "").replace("listing-", "")
      merchantData[trimmedKey] = merchantData[key]
      delete merchantData[key]  unless key is trimmedKey
    merchantData.dob = merchantData.date_of_birth_year + "-" + merchantData.date_of_birth_month
    delete merchantData.date_of_birth_year

    delete merchantData.date_of_birth_month

    addErrorToField $form, "name"  unless merchantData.name
    addErrorToField $form, "email_address"  unless balanced.emailAddress.validate(merchantData.email_address)
    addErrorToField $form, "street_address"  unless merchantData.street_address
    addErrorToField $form, "postal_code"  unless merchantData.postal_code
    addErrorToField $form, "phone_number"  unless merchantData.phone_number
    hasBankAccount = false
    if merchantData.account_number or merchantData.bank_code
      hasBankAccount = true
      addErrorToField $form, "bank_code"  unless balanced.bankAccount.validateRoutingNumber(merchantData.bank_code)
      addErrorToField $form, "account_number"  unless merchantData.account_number
    if $form.find(".control-group.error").length
      e.preventDefault()
      return
    if hasBankAccount
      e.preventDefault()
      disableForm $form
      showProcessing "Adding bank account...", 33
      balanced.bankAccount.create merchantData, onCardTokenized

  onCardTokenized = (response) ->
    $form = $("#kyc")
    hideProcessing()
    switch response.status
      when 201
        $form.find("input,select").removeAttr "disabled"
        showProcessing "Performing identity check...", 66
        $("<input type=\"hidden\" name=\"bank_account_uri\" value=\"" + response.data.uri + "\">").appendTo $form
        $form.unbind("submit", submitKYC).submit()

  
  #  todo - what if we have a 409?
  showProcessing = (message, progress) ->
    progress = progress or 50
    $loader = $(".loading")
    unless $loader.length
      $loader = $("<div class=\"loading\">" + "<div class=\"progress progress-striped active\">" + "<div class=\"bar\"></div>" + "</div>" + "<p>&nbsp;</p>" + "</div>")
      $loader.appendTo "body"
    $loader.find(".bar").css width: progress + "%"
    $loader.find("p").text message
    $loader.css(
      left: $("body").width() / 2 - $loader.width() / 4
      top: "400px"
    ).show()

  hideProcessing = ->
    $(".loading").hide()

  showError = (message) ->
    $alert = $(".alert:visible")
    $alert.remove()  if $alert.length
    $alert = $("<div class=\"alert alert-absolute alert-block alert-error\">" + "<button class=\"close\" data-dismiss=\"alert\">&times;</button>" + "<h4 class=\"alert-heading\">Error!</h4>" + message + "</div>")
    $alert.appendTo("body").css(
      left: $("body").width() / 2 - $alert.width() / 4
      top: "400px"
    ).show()

  hideError = ->
    $(".alert").hide()

  resetForm = ($form) ->
    $form = $("form")  unless $form
    $form.find(".control-group").removeClass "error"
    $form.find("input,button,select").removeAttr "disabled"

  disableForm = ($form) ->
    $form.find("input, button, select").attr "disabled", "disabled"

  addErrorToField = ($form, fieldName) ->
    $form.find("[name$=\"" + fieldName + "\"]").closest(".control-group").addClass "error"

  removeSensitiveFields = ($form, sensitiveFields) ->
    i = 0

    while i < sensitiveFields.length
      sensitiveFields[i] = "[name$=\"" + sensitiveFields[i] + "\"]"
      i++
    sensitiveFields = sensitiveFields.join(",")
    $form.find(sensitiveFields).remove()

  # ctx.rentmybike = init: (options) ->
  #   _options = options
  #   balanced.init options.marketplaceUri
  #   $("form#purchase").submit submitPurchase
  #   $("form#kyc").submit submitKYC
  #   $("[data-dismiss=\"alert\"]").on "click", (e) ->
  #     $(this).closest(".alert").fadeOut "fast"
  #     resetForm()
  #     e.preventDefault()



(($) ->

  # $.fn.serializeObject = ->
  #   console.log('foo')
  #   console.log @
  #   o = {}
  #   a = @serializeArray()
  #   console.log a
  #   $.each a, ->
  #     if o[@name] isnt `undefined`
  #       o[@name] = [o[@name]]  unless o[@name].push
  #       o[@name].push @value or ""
  #     else
  #       o[@name] = @value or ""
  #     console.log o
  #   o



  # http://jsfiddle.net/davidhong/gP9bh/
  $.fn.serializeObject = ->
    o = Object.create(null)
    elementMapper = (element) ->
      element.name = $.camelCase(element.name)
      element

    appendToResult = (i, element) ->
      node = o[element.name]
      if "undefined" isnt typeof node and node isnt null
        o[element.name] = (if node.push then node.push(element.value) else [node, element.value])
      else
        o[element.name] = element.value

    $.each $.map(@serializeArray(), elementMapper), appendToResult
    o

) jQuery

window.zerticaBalanced = new @Balanced
  marketplaceUri: '/v1/marketplaces/TEST-MP5X26XD6x8T3RUJxZ5HryvC'
console.log "ZB: #{zerticaBalanced}"
