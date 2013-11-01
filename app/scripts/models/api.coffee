###
 * Top
  name    : String
  version : String
  scemes  : Array(String)
  methods : Array(String)
  hosts   : Array(String)
  common_params : Array(Parameter)
  routes  : Array(Route)

 * Route
  name    : String
  method  : String
  path    : String
  description : String

 * Parameter
  name    : String
  requried: Boolean
  description : String
  type : String
  selection : Array(Selection)

 * Selection
 title  : String
 value  : String
###
class app.Models.API extends Backbone.Model
  # static properties
  name : ""
  version : ""
  schemes : [
    "http"
  ]
  methods : [
    "GET"
    "POST"
  ]
  ports : [
    "80"
  ]
  hosts : []
  common_params : []
  routes: []
  # instance properties
  # i.e. currently selected api components
  defaults:
    scheme: ""
    method : ""
    host: ""
    port: ""
    route: ""
  initialize : (json) ->
    # overwrite static properties
    _.extend this, json
    # instantiate parameters collection
    this.params = new app.Collections.ParametersCollection
    # observe route change
    this.on "change:route", this.onChangeRoute
  onChangeRoute: (model,newval,opts) ->
    # remove rouete-specific params
    rms = this.params.where {common : false}
    this.params.remove rms
    # add params if route have :id components
    if ids = newval.match /:[^\/]+/g
      # create new params and add into collection
      this.params.add _.map ids, (v,i) ->
        newp = new app.Models.ParameterModel {
          key : v
          required : true
          url_component : true
        }
  getURL : () ->
    scheme = this.get "scheme"
    host = this.get "host"
    reoute = this.get "route"
    port = this.gte "port"
    "#{scheme}://#{host}:#{port}#{route}"
  send : () ->
    # urlを構築
    url = this.getURL()
    collection = app.API.params
    # idをインジェクション
    ids = collection.filter (obj) ->
      (obj.get("key").indexOf(":id") >= 0)
    $.each ids, (i,v) ->
      url = url.replace(":id",v.get("value"))
    params = _.reduce app.API.params.models, (memo,v) ->
      memo[v.get("key")] = encodeURI m.get("value")
    , {}
    method = $(this.$selects[0]).val();
    console.log method + "  " + url
    console.log params
    that = this
    this.$sendButton.attr("disabled","disabled")
    $.ajax
      url : url + ".json"
      data : params
      type : method
      dataType : "json"
      crossDomain : true
    .done (data,status,xhr) ->
        app.trigger "send:done", arguments
    .fail (xhr,status) ->
        app.trigger "send:error", arguments
    .always () ->
      app.trigger "send:complete"