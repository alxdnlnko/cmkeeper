configureRoutes = ($routeProvider) ->
  $routeProvider
    .when '/', action: 'home'
    .when '/:categoryId', action: 'category'
    .when '/:categoryId/:noteId', action: 'note'
    .otherwise redirectTo: '/'

angular.module 'cmIndex'
  .config ['$routeProvider', configureRoutes]
