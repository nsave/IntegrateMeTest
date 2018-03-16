angular.module('integrate').controller('CompetitionController', ($scope, $http) ->
  self = @

  @init = (competitions) ->
    self.competitions   = competitions
    self.newCompetition = { name: '' }

    self.formStep   = 0
    self.formErrors = {}

  @openForm = ->
    self.formStep = 1

  @closeForm = ->
    self.formStep = 0

  @submitForm = ->
    $http.post("/competitions", self.newCompetition).
      success((data, status, headers, config) ->
        if data.success
          alert("Your competition submited!")
          self.competitions.unshift(data.competition)
          self.closeForm()
        else
          self.errors = data.errors
      ).
      error((data, status, headers, config) ->
        alert("ERROR!")
      )

  self
)
