'use strict';

class app.Models.ParameterModel extends Backbone.Model
  initialize : (data) ->
    console.log this
    if this.get "url_component"
      this.set "value", 0 , {silent : true}
  defaults:
    key: ""
    value: ""
    description: ""
    required : false
    common : false
    url_component : false