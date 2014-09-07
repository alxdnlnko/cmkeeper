angular.module 'CMKeeper'
  .factory 'Errors', () ->
    {
      NOT_AUTHORIZED: 1
      ALREADY_AUTHORIZED: 2

      NO_SUCH_CATEGORY: 4
      NO_SUCH_NOTE: 5

      NO_NOTE_ID: 6

      # BackendLess errors
      NOT_EXISTING_USER_TOKEN: 3064
    }
