CookiesFactory = ($document) ->
  document = $document[0]
  return {
    set: (name, val, expireDays) ->
      name = encodeURIComponent name
      val = encodeURIComponent val
      d = new Date()
      d.setTime d.getTime() + (expireDays * 24 * 60 * 60 * 1000)
      expires = "expires=#{d.toUTCString()}"
      document.cookie = "#{name}=#{val}; #{expires}"
    get: (name) ->
      name = encodeURIComponent name
      for cookie in document.cookie.split ';'
        [cn, cv] = cookie.split '='
        return decodeURIComponent cv if cn.trim() is name
      null
  }

angular.module 'CMKeeper'
  .factory 'Cookies', [
    '$document',
    CookiesFactory]
