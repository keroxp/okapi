'use strict';

class okapi.Views.FormUrlView extends Backbone.View
  el: $ "#form-url"
  events:
    "change select" : "onChangeSelect"
    "click #form-send-button" : "onClickSendButton"
  initialize: (d) ->
    unless app.API
      app.trigger "error", "app doesn't have API"
    # Caching UI
    this.$method = this.$el.find("#form-http-method")
    this.$scheme = this.$el.find("#form-http-scheme")
    this.$host = this.$el.find("#form-host")
    this.$port = this.$el.find("#form-port")
    this.$path = this.$el.find("#form-api-path")
    this.$sendButton = this.$el.find("#form-send-button")
    # Build Forms
    this.addOptions this.$method, app.API.methods
    this.addOptions this.$scheme, _.map app.API.schemes, (v) -> v+="://"
    this.addOptions this.$host, app.API.hosts
    this.addOptions this.$port, _.map app.API.ports, (v) -> ":#{v}"
    that = this
    _.each app.API.routes, (v,k,l) ->
      that.addOptions that.$path, [k], true
      names = _.pluck v, "path"
      that.addOptions that.$path, names, false
    this.listenTo app.API, "change:routes", this.onChangeRoute
  addOptions: ($to,opts,disabled) ->
    _.each opts, (v,i,l) ->
      $opt = $ "<option></option>"
      $opt.attr "value", v
      $opt.attr "disabled", "disabled" if disabled
      $opt.html v
      $to.append $opt
  disableSendButton : (disabled) ->
    if disabled
      this.$sendButton.attr "disabled"
    else
      this.$sendButton.removeAttr "disabled"
  onClickSendButton : (e) ->
    # disable send button
    this.disableSendButton true
    # send
    app.API.send()
    that = this
    this.listenToOnce app, "send:complete", () ->
      that.disableSendButton false
  onChangeSelect : (e) ->
    console.log e
    $sender = $ e.target
    val = $sender.val()
    switch $sender.attr("id")
      when "form-http-method" then app.API.set "method", val
      when "form-http-scheme" then app.API.set "scheme", val
      when "form-host"        then app.API.set "host"  , val
      when "form-api-path"    then app.API.set "route" , val
      when "form-port"        then app.API.set "port"  , val