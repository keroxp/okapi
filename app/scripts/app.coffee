# アプリオブジェクト
window.okapi = window.app =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  cookie : {}
  API : {}
  getCookie : (key) ->
    cookies = document.cookie.trim().split(";")
    $.each cookies, (i,v) ->
      kv = v.split "="
      app.cookie[kv[0]] = unescape kv[1]
    return this.cookie[key]
  setCookie: (key,val,expiresday = 1) ->
      now = new Date
      expires = new Date now.getTime()+60*60*24*1000*expiresday
      document.cookie = "#{key}=#{escape val};expires=#{expires.toUTCString()};"
      console.log "cookie saved : #{key}:#{val}"
  init: (json) ->
    'use strict'
    console.log 'Hello from Backbone!'
    # jsonからAPIをイニシャライズ
    this.API = new this.Models.API json
    this.RequestInfoView = new this.Views.FormRequestInfoView
    this.UrlView = new this.Views.FormUrlView
    this.ParametersView = new this.Views.FormParametersView
    this.DebugWindowView = new this.Views.DebugWindowView
# グローバルなイベントを処理するためにapp自体をメディエータにする
_.extend app, Backbone.Events