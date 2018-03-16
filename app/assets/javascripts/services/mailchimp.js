angular.module('integrate').factory('mailchimp', ['$http', ($http) ->
  return {
    getLists: function(api_key) {
      alert('checking');
    }
  };
]);