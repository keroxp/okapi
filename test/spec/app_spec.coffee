"use strict"
describe "app", ->
  describe "on load", ->
    it "should exists", ->
      should.exist(app)
    it "should have UrlViewn", ->
      should.exist app.UrlView
      should.exist app.UrlView.el
    it "should have RequestInfoView", ->
      should.exist app.RequestInfoView
      should.exist app.RequestInfoView.el
    it "should have ParametersView", ->
      should.exist app.ParametersView
      should.exist app.ParametersView.el
    it "should have API", ->
      should.exist app.API