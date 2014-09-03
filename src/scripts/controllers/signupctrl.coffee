SignupCtrl = ($scope, Backend, $state) ->
  $scope.isLoading = false

  $scope.submit = () ->
    return if not $scope.email or not $scope.password

    $scope.isLoading = true
    Backend.register $scope.email, $scope.password
      .then(
        (data) ->
          $state.go 'login'
        (err) ->
          $scope.isLoading = false
          $scope.errorMessage = err.message
      )

  $scope.submitText = () ->
    if $scope.isLoading then 'Loading...'

angular.module 'CMKeeper'
  .controller 'SignupCtrl', [
    '$scope',
    'Backend',
    '$state',
    SignupCtrl]
