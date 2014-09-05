cmFocus = () ->
  return {
    scope:
      trigger: '=cmFocus'
    link: (scope, element, attrs) ->
      scope.$watch 'trigger', (val) ->
        element[0].focus() if val
  }

angular.module 'CMKeeper'
  .directive 'cmFocus', [
    cmFocus]
