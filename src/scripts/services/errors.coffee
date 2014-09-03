angular.module 'CMKeeper'
  .factory 'Errors', () ->
    {
      NOT_AUTHORIZED: 1
      ALREADY_AUTHORIZED: 2

      NO_SUCH_CATEGORY: 3
      NO_SUCH_NOTE: 4

      NO_NOTE_ID: 5
    }
