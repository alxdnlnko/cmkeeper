configureRoutes = ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.rule ($injector, $location) ->
    path = $location.url()
    return path.replace(/\/$/, '') if path[path.length - 1] == '/'
    return path.replace('/?', '?') if path.indexOf('/?') > 0
    return false

  $stateProvider
    .state 'login',
      url: '/login'
      templateUrl: 'login.html'
      controller: 'LoginCtrl'
    .state 'signup',
      url: '/signup'
      templateUrl: 'signup.html'
      controller: 'SignupCtrl'
    .state 'notes',
      url: '/'
      templateUrl: 'notes.html'
      controller: 'NotesCtrl'
      resolve:
        categories: (Storage) ->
          console.log Storage
          console.log 'Loading categories...'
          return Storage.loadCategories()
    .state 'notes.category',
      url: '^/{categoryId:[^/]+}'
      templateUrl: 'notes.html'
      controller: 'NotesCtrl'
    .state 'notes.note',
      url: '^/{categoryId:[^/]+}/{noteId:[^/]+}'

angular.module 'CMKeeper'
  .config [
    '$stateProvider',
    '$urlRouterProvider',
    configureRoutes
  ]
