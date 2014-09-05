cmMenu = ($document, $timeout) ->
  return {
    restrict: 'A'
    transclude: true
    template: '<div ng-transclude></div>'
    scope:
      close: '&onClose'
    link: (scope, elem, attrs) ->
      onDocumentClick = (ev) ->
        ev.preventDefault()
        ev.stopPropagation()
        scope.$apply () ->
          scope.close()
        $document.off 'click', onDocumentClick

      scope.$parent.$watch attrs.ngShow, (val) ->
        if val
          $timeout () ->
            $document.on 'click', onDocumentClick
          , 0

      elem.on '$destroy', () -> $document.off 'click', onDocumentClick
  }

angular.module 'CMKeeper'
  .directive 'cmMenu', [
    '$document',
    '$timeout',
    cmMenu]
