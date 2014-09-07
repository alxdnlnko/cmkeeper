configureRoutes = ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.rule ($injector, $location) ->
    path = $location.url()
    return '/' if path is ''
    return path.replace(/\/$/, '') if path[path.length - 1] is '/'
    return path.replace('/?', '?') if path.indexOf('/?') > 0
    return false

  $stateProvider
    .state 'login',
      url: '/login'
      templateUrl: 'login.html'
      controller: 'LoginCtrl'
      resolve:
        auth: [
          '$q',
          'Backend',
          'Errors',
          ($q, Backend, Errors) ->
            deferred = $q.defer()
            if Backend.isAuthorized()
              err = new Error 'Already authorized'
              err.code = Errors.ALREADY_AUTHORIZED
              deferred.reject err
            else
              deferred.resolve()
            return deferred.promise
          ]
        title: [
          '$rootScope',
          ($rootScope) ->
            $rootScope.title = 'CMKeeper - Login'
          ]

    .state 'signup',
      url: '/signup'
      templateUrl: 'signup.html'
      controller: 'SignupCtrl'
      resolve:
        title: [
          '$rootScope',
          ($rootScope) ->
            $rootScope.title = 'CMKeeper - Signup'
          ]

    .state 'notes',
      url: '/'
      templateUrl: 'notes.html'
      controller: 'NotesCtrl'
      resolve:
        resolveAuth: [
          '$q',
          'Backend',
          'Errors',
          '$timeout',
          ($q, Backend, Errors, $timeout) ->
            deferred = $q.defer()
            if Backend.isAuthorized()
              deferred.resolve()
            else
              err = new Error 'Not authorized'
              err.code = Errors.NOT_AUTHORIZED
              deferred.reject err
            return deferred.promise
          ]
        resolveCategories: [
          'Storage',
          'resolveAuth',
          (Storage) ->
            Storage.loadCategories()
          ]
        title: [
          '$rootScope',
          ($rootScope) ->
            $rootScope.title = 'CMKeeper'
          ]

    .state 'notes.category',
      url: '^/{categoryId:[^/]+}'
      resolve:
        resolveCategory: [
          'Storage',
          'Errors',
          '$q',
          '$stateParams',
          'resolveCategories',
          (Storage, Errors, $q, $stateParams) ->
            deferred = $q.defer()
            if Storage.selectCategory $stateParams.categoryId
              deferred.resolve()
            else
              err = new Error 'No such category'
              err.code = Errors.NO_SUCH_CATEGORY
              deferred.reject err
            return deferred.promise
          ]
        resolveNotes: [
          'Storage',
          '$stateParams',
          'resolveCategory',
          (Storage, $stateParams) ->
            Storage.loadNotes $stateParams.categoryId
        ]

    .state 'notes.category.note',
      url: '^/{categoryId:[^/]+}/{noteId:[^/]+}'
      resolve:
        resolveNote: [
          'Storage',
          '$q',
          '$stateParams',
          'Errors',
          '$timeout',
          'resolveNotes',
          (Storage, $q, $stateParams, Errors, $timeout) ->
            deferred = $q.defer()
            if Storage.selectNote $stateParams.noteId
              deferred.resolve()
            else
              err = new Error 'No such note'
              err.code = Errors.NO_SUCH_NOTE
              deferred.reject err
            return deferred.promise
        ]

RedirectsCtrl = ($rootScope, $state, $stateParams, Errors, Backend) ->
  $rootScope.$on '$stateChangeError',
    (event, toState, toParams, fromState, fromParams, error) ->
      event.preventDefault()
      switch error.code
        when Errors.NOT_AUTHORIZED
          return $state.go 'login'
        when Errors.ALREADY_AUTHORIZED
          return $state.go 'notes'
        when Errors.NO_SUCH_CATEGORY
          return $state.go 'notes'
        when Errors.NO_SUCH_NOTE
          if $stateParams.categoryId
            # TODO: this redirect doesn't force the 'resolveCategory',
            # because categoryId is the same
            return $state.go 'notes.category', categoryId: $stateParams.categoryId
          else
            return $state.go 'notes'
        when Errors.NOT_EXISTING_USER_TOKEN
          Backend.clearUserToken()
          return $state.go 'login'
        else
          console.log arguments

angular.module 'CMKeeper'
  .config [
    '$stateProvider',
    '$urlRouterProvider',
    configureRoutes]
  .run [
    '$rootScope',
    '$state',
    '$stateParams',
    'Errors',
    'Backend',
    RedirectsCtrl]
