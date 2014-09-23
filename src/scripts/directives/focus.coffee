cmFocus = () ->
  return {
    scope:
      trigger: '=cmFocus'
    link: (scope, element, attrs) ->
      scope.$watch 'trigger', (val) ->
        if element.attr 'ui-ace'
          inner = element.find 'textarea'
          inner[0].focus()
        else
          element[0].focus() if val
  }

angular.module 'CMKeeper'
  .directive 'cmFocus', [
    cmFocus]
