'use strict';

class okapi.Views.FormParametersView extends Backbone.View
  el: $ "#form-parameters"
  events:
    "click button#add-parameter-button" : "onClickAddParameterButton"
    "keyup input#form-new-parameter" : "onKeyUpNewParameter"
  initialize: (d) ->
    # cache
    this.$parametersTable = this.$el.find("#form-parameters-custom")
    this.$newParameterInput = this.$el.find("#form-new-parameter")
    this.$newParameterButton = this.$el.find("#add-parameter-button")
    # observer addition of params
    this.listenTo app.API.params, "add", this.onAddParameter
  onClickAddParameterButton: (e) ->
    key = this.$newParameterInput.val()
    if app.API.params.where({key : key}).length is 0
      # add new param if it has been already added
      newParam = new app.Models.ParameterModel {
        key : key
      }
      # add
      app.API.params.add newParam
    # clear
    this.$newParameterInput.val("")
    this.onKeyUpNewParameter e
  onKeyUpNewParameter: (e) ->
    # disable add button if no input
    if this.$newParameterInput.val()
      this.$newParameterButton.removeAttr("disabled")
    else
      this.$newParameterButton.attr("disabled", "disabled")
      return
    # on enter
    if e.keyCode is 13
      console.log e
      this.onClickAddParameterButton e
  onAddParameter: (model) ->
    # パラメータrow追加
    newRow = new app.Views.ParameterRowView {
      model : model
    }
    this.$parametersTable.append(newRow.render().el)
    # フォーカスを当てる
    newRow.$input().focus()