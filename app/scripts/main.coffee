$ ->
  'use strict'
  # api.jsonからイニシャライズ
  json = null
  $.ajax
    url : "./api.json"
    tpye: "GET"
    dataType: "json"
    async: false
    success: (data,status,xhr) ->
      json = data
    error: (xhr) ->
      app.trigger "error", "failed to load api.json"
  # start!
  app.init(json);
  # bind data to template
  $("[data-bind-target]").each () ->
    $this = $ this
    _.extend $this, Backbone.Events
    target = new Function("return " + $this.attr "data-bind-target")()
    attr = $this.attr "data-bind-attr"
    $that = $this
    $this.listenTo target, "change:#{attr}", (m,v,opts) ->
      $that.html v
  # set default value
  app.API.set "method", app.API.methods[0]
  app.API.set "scheme", app.API.schemes[0]+"://"
  app.API.set "host", app.API.hosts[0]
  app.API.set "port", ":"+app.API.ports[0]
  # add common parms
  app.API.params.add _.map app.API.common_params, (v) ->
    return new app.Models.ParameterModel _.extend v, {common : true}