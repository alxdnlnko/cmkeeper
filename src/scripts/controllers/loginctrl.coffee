LoginCtrl = ($scope, Backend, $state) ->
  $scope.isLoading = false

  $scope.submit = () ->
    return if not $scope.email or not $scope.password

    $scope.isLoading = true
    Backend.login $scope.email, $scope.password
      .then(
        (data) ->
          $state.go 'notes'
        (err) ->
          $scope.isLoading = false
          $scope.errorMessage = err.message
      )

  $scope.submitText = () ->
    if $scope.isLoading then 'Loading...'

angular.module 'CMKeeper'
  .controller 'LoginCtrl', [
    '$scope',
    'Backend',
    '$state',
    LoginCtrl]
