angular.module('integrate').controller('CompetitionController', ($scope, $http) ->
  self = @

  @init = (competitions) ->
    self.competitions = competitions

  self
)
