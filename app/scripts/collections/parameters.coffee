'use strict';

class app.Collections.ParametersCollection extends Backbone.Collection
  initialize:  (data)->
    console.log this
  model: app.Models.ParameterModel
