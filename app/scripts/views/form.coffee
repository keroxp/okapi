'use strict';

class app.Views.FormView extends Backbone.View
  el : $("#form")
  initialize : (data) ->
    this.$selects = this.$el.find("#form-url").find("select")
    this.$sendButton = $("#form-send-button")
    this.$langInput = $("#form-lang")
    this.$authTokenInput = $("#form-auth-token")
    this.$parametersTable = $("#form-parameters-custom")
    this.$newParameterInput = $("#form-new-parameter")
    this.$newParameterButton = $("#add-parameter-button")
    this.$requestInfoURL = $("#form-request-url")
    this.$requestInfoData = $("#form-request-data")
    this.$response = $("#form-response")

    # パラメタの追加を監視
    this.listenTo app.ParametersCollection, "all", this.onChangeParameter


  # 監視する子のイベント
  events :
    "click button#get-auth-token" : "onClickGetAuthToken"
    "click button#add-parameter-button" : "onClickAddParameter"
    "keyup input#form-new-parameter" : "onKeyUpNewParameter"
    "change select" : "onSelectChange"
    "keyup #auth_token_modal input" : "onAuthTokenModalInputChange"
    "click #form-send-button" : "onClickSendButton"

  # 送信の処理
  onClickSendButton : (e) ->
    # urlを構築
    url = this.getURL()
    collection = app.ParametersCollection
    # idをインジェクション
    ids = collection.filter (obj) ->
      (obj.get("key").indexOf(":id") >= 0)
    $.each ids, (i,v) ->
      url = url.replace(":id",v.get("value"))
    params = {}
    _.each collection.models, (m) ->
      params[m.get("key")] = encodeURI m.get("value")

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
        console.log arguments
        that.$sendButton.removeAttr "disabled"
        that.$el.find("#form-response").val(JSON.stringify(data,null,"  "))
    .fail (xhr,status) ->
        console.log arguments
        that.$sendButton.removeAttr "disabled"
        that.$response.val(status)

  # セレクタが変わったら
  onSelectChange : (e) ->
    console.log e
    sender = e.target
    switch sender.id
      # apiのパスが変化したら
      when "form-api-path"
        # 共通でないパラメータをリセット
        pc = app.ParametersCollection
        pc.remove(pc.where({common : false}))
        # パスに:idが含まれていたらその数だけパラメータを追加 なければフォーム自体を消す
        path = $(sender).val()
        console.log path
        # パラメタを追加
        ids = path.match(/:id/g)
        if ids
          console.log ids
          $.each ids, (i,v) ->
            newp = new app.Models.ParameterModel {
              key : ":id-"+i
              required : true
            }
            app.ParametersCollection.add newp
    # URLを更新
    this.refreshURL()

  getURL : () ->
    scheme = $(this.$selects[1]).val()
    host = $(this.$selects[2]).val()
    path = $(this.$selects[3]).val()
    ids = app.ParametersCollection.filter (obj)->
      obj.get("key").indexOf(":id") >= 0
    $.each ids, (i, v) ->
      val = v.get("value")
      val = "0" unless val
      path = path.replace ":id", val
    url = "#{scheme}#{host}/#{path}"

  refreshURL: () ->
    this.$("#form-request-url").html this.getURL()

  # パラメータ追加ボタンが押されたら
  onClickAddParameter : (e) ->
    key = this.$newParameterInput.val()
    # すでに追加済みでなければ
    if app.ParametersCollection.where({key : key}).length is 0
      newParam = new app.Models.ParameterModel {
        key : key
      }
      # 追加
      app.ParametersCollection.add newParam
    # clear
    this.$newParameterInput.val("")
    this.onKeyUpNewParameter e

  # パラメータinputが変化したら
  onKeyUpNewParameter: (e) ->
    # 追加ボタンのdisabled
    if this.$newParameterInput.val().length > 0
      this.$newParameterButton.removeAttr("disabled")
    else
      this.$newParameterButton.attr("disabled", "disabled")
      return
    # エンターボタン
    if e.keyCode is 13
      console.log e
      this.onClickAddParameter e

  # コレクションにパラメータが追加されたら
  onChangeParameter: (e) ->
    switch e
      when "add"
        model = arguments[1]
        # パラメータrow追加
        newRow = new app.Views.ParameterRowView {
          model : model
        }
        this.$parametersTable.append(newRow.render().el)
        # フォーカスを当てる
        newRow.$input().focus()
        # データインフォを追加
        newSpan = new app.Views.ParameterSpanView {
          model : model
        }
        # id系でなければ
        if model.get("key").indexOf(":id") < 0
          # データ欄に追加
          this.$requestInfoData.append newSpan.render().el
        else
          # id系ならばURL欄を修正に追加
          that = this
          this.listenTo model, "change:value", (e) ->
            that.refreshURL()
