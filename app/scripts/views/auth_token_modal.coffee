'use strict';

class app.Views.AuthTokenModalView extends Backbone.View
  el : $ "#auth-token-modal"
  initialize: (d) ->
    this.$inputs = this.$el.find("input")
    this.$sendButton = this.$el.find(".send-button")
    this.$fbButton = this.$el.find(".facebook-button")
  events:
    "keyup input" : "onInputChange"
    "click .send-button" : "onClickSendButton"
    "click .facebook-button" : "onClickFBButton"
  onInputChange: (e) ->
    notEmpty = _.reduce this.$inputs, (flag, obj) ->
      flag = ($(obj).val().length > 0)
    , false
    if notEmpty
      this.$sendButton.removeAttr("disabled")
    else
      this.$sendButton.attr("disabled","disabled")
  onClickSendButton: (e) ->
    # sign_in apiに送信
    host = this.$el.find("#at_server").val()
    email = this.$el.find("#email").val()
    password = this.$el.find("#password").val()

    that = $(e.target).attr("disabled","disabled")
    $.ajax
      url : "http://#{host}/sign_in.json"
      dataType : "json"
      crossDomain : true
      type: "POST"
      data:
        "email" : email
        "password" : password
    .done (data,status,xhr) ->
      that.removeAttr "disabled"
      at = data.auth_token
      console.log arguments
      app.trigger "get:auth_token", at if at
      $(".modal").modal("hide")
    .fail (e) ->
      that.removeAttr "disabled"
      console.log arguments
      console.log e.statusCode()
      alert "取得に失敗しました"
  onClickFBButton: (e) ->
    host = this.$el.find("#at_server").val()
    auth = FB.getAuthResponse()
    unless auth
      alert "認証に失敗しました。\nFacebook上でログインしていない場合はログインしてください。\nappのアプリ連携をしていない人は認証してください。 "
      return;
    that = $(e.target).attr("disabled","disabled")
    $.ajax
      url : "http://#{host}/sign_in.json"
      dataType : "json"
      crossDomain : true
      type: "POST"
      data:
        "fb_id" : auth.userID
        "fb_token" : auth.accessToken
    .done (data,status,xhr) ->
      that.removeAttr "disabled"
      at = data.auth_token
      console.log data
      app.trigger "get:auth_token", at
      $(".modal").modal("hide")
    .fail (e) ->
      that.removeAttr "disabled"
      console.log arguments
      console.log e.statusCode()
      alert "取得に失敗しました"