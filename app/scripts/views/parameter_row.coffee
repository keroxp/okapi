'use strict';

class app.Views.ParameterRowView extends Backbone.View
  initialize : (d) ->
    # バインドされたモデルの削除を監視
    this.listenTo this.model, "remove", this.onDeleteModel
    this.listenTo this.model, "change:value", this.onChangeValue
    # ahth_tokenなら
    if this.model.get("key") is "auth_token"
      this.listenTo app, "get:auth_token", this.onGetAuthToken
      this.model.set "value" , app.getCookie "auth_token"
    console.log this
  className : "parameter-row"
  events :
    "click button" : "onClickButton"
    "keyup input" : "onKeyUp"
    "blur input" : "onBlur"
  template: JST["app/scripts/templates/parameter_row.ejs"]
  $input : () ->
    $(this.$el.find("input"))
  onGetAuthToken: (d) ->
    this.model.set("value",d,{"by":this})
    this.$input().val d
  onClickButton : (e) ->
    if this.model.get("key") isnt "auth_token"
      this.model.destroy()
  onChangeValue : (model,val,opts) ->
    if opts.by isnt this
      this.$el.find("input").val val
  onKeyUp : (e) ->
    # modelのval更新
    value = $(e.target).val()
    this.model.set("value", value, {"by" : this})
  onDeleteModel: (m) ->
    this.$el.remove()
  render : () ->
    this.$el.html this.template this.model.attributes
    this.$input().val this.model.get("value")
    return this