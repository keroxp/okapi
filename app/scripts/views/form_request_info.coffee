'use strict';

class okapi.Views.FormRequestInfoView extends Backbone.View
  el: $ "#form-request-info"
  events:
    "input #form-request-url" : "onChangeURL"
    "input #form-request-data" : "onChangeData"
  initialize: (d) ->
    this.$URL = this.$el.find "#form-request-url"
    this.$data = this.$el.find "#form-request-data"
    this.$route = this.$el.find "#form-request-url-route"
    this.listenTo app.API.params, "add", this.onAddParameter
    this.listenTo app.API.params, "remove", this.onRemoveParameter
    this.listenTo app.API, "change:route", this.onChangeRoute
  onChangeAPI : (e) ->
  onChangeRoute: (model,newval) ->
    # reset route html
    this.$route.html ""
    # split url compnents by :xxx
    # fuga/:id/hoge/:name => fuga,:id,hoge,:name
    comps = newval.replace(/:[^\/]+/g, (m) -> ",#{m},").split(",")
    # build new route
    that = this
    _.each comps, (v,i)->
      # fetch url compnent params from collection
      model = app.API.params.where({url_component : true, key : v})[0]
      if model
        span = new app.Views.ParameterSpanView {
          model : model
        }
        that.$route.append span.render().el
      else
        that.$route.append $("<span></span>").html(v)
  onAddParameter: (model) ->
    # add parameter data span
    newSpan = new app.Views.ParameterSpanView {
      model : model
    }
    # id系でなければ
    if model.get("key").indexOf(":id") < 0
      # データ欄に追加
      this.$data.append newSpan.render().el
  onRemoveParameter: (model) ->
