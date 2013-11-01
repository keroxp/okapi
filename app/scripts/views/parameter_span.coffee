'use strict';

class app.Views.ParameterSpanView extends Backbone.View
  tagName: "span"
  className: "parameter-span"
  template : JST["app/scripts/templates/parameter_span.ejs"]
  events:
    "keyup .parameter-value" : "onKeyUp"
  onKeyUp : (e)->
    e.preventDefault()
    e.stopPropagation()
    # モデルを変更
    newval = $(e.target).text()
    console.log newval
    this.model.set "value",newval, {"by" : this}
  initialize: (d) ->
    this.listenTo this.model, "change:value", this.onChange
    this.listenTo this.model, "remove", this.onRemove
    console.log this
  onRemove: (e,m) ->
    this.$el.remove();
  onChange: (model,change,opts) ->
    # 自身による変更でなければviewを更新
    if opts.by isnt this
      this.render()
  render: () ->
    this.$el.html this.template this.model.attributes
    return this