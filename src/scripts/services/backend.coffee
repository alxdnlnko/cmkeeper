Backend = (Cookies, $http, $q) ->
  APP_ID = 'E6F0499F-1DBA-2433-FF0B-5B5B86D38700'
  SECRET = '85FE93BF-B03A-9159-FFE0-180BD9BA5F00'
  VER = 'v1'
  APP_TYPE = 'REST'

  @userToken = Cookies.get 'user-token'

  @isAuthorized = () ->
    return @userToken?

  @clearUserToken = () ->
    @userToken = null
    Cookies.del 'user-token'

  @makeRequest = (url, data, method) ->
    headers =
      'application-id': APP_ID
      'secret-key': SECRET
      'application-type': APP_TYPE
      'Content-Type': 'application/json'
    if @userToken then headers['user-token'] = @userToken

    method = method ? 'POST'

    options =
      method: method
      url: "https://api.backendless.com/#{VER}/#{url}"
      headers: headers

    if method is 'GET'
      options.params = data
    else
      options.data = data

    $http options

  @register = (email, password) ->
    deferred = $q.defer()
    @makeRequest 'users/register', email: email, password: password
      .success (data, status) =>
        deferred.resolve data
      .error (data, status) =>
        deferred.reject data
    return deferred.promise

  @login = (email, password) ->
    deferred = $q.defer()
    @makeRequest 'users/login', login: email, password: password
      .success (data, status) =>
        @userToken = data['user-token']
        Cookies.set 'user-token', @userToken, 30
        deferred.resolve data
      .error (data, status) =>
        deferred.reject data
    return deferred.promise

  @

angular.module 'CMKeeper'
  .service 'Backend', [
    'Cookies',
    '$http',
    '$q',
    Backend]
