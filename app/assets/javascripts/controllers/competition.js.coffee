angular.module('integrate').controller('CompetitionController', ($scope, $http) ->
  self = @

  @init = (competitions) ->
    self.competitions = competitions
    self.toInitialState()

  @toInitialState = ->
    self.newCompetition = {
      name: '',
      requires_entry_name: true,
      mailchimp_api_key: ''
    }

    self.mailchimpLists = []

    self.formStep = 0
    self.errors   = null

  @openForm = ->
    self.formStep = 1

  @closeForm = ->
    self.toInitialState()

  @fetchLists = ->
    $http.post("/mailchimp_lists", { api_key: self.newCompetition.mailchimp_api_key }).
      success((data, status, headers, config) ->
        if data.lists.length > 0
          self.formStep = 2
          self.errors   = null
          self.mailchimpLists = data.lists
        else
          self.errors = { api_key: ['is invalid or has no lists available'] }
      ).
      error((data, status, headers, config) ->
        alert("ERROR!")
      )

  @submitForm = ->
    $http.post("/competitions", self.newCompetition).
      success((data, status, headers, config) ->
        if data.success
          alert("Your competition submited!")
          self.competitions.unshift(data.competition)

          self.toInitialState()
        else
          self.errors = data.errors
      ).
      error((data, status, headers, config) ->
        alert("ERROR!")
      )

  self
)
