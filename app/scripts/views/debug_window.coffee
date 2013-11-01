'use strict';

class app.Views.DebugWindowView extends Backbone.View
  el: $ "#debug-window"
  initialize: (d) ->
    this.listenTo app, "toggleDebug", this.toggle
    this.listenTo app.API.params, "all", this.onChagneCollecyion
    this.$text = this.$el.children("textarea")
  events:
    "click a.close" : "toggle"
  toggle: (e) ->
    this.$el.toggle()
  onChagneCollecyion: (e) ->
    this.$text.val JSON.stringify app.API.params.models,null,"  "
