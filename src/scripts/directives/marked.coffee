cmMarkedDirective = (cmMarked) ->
  nthIndexOfCheckbox = (str, n) ->
    i = null
    ind = null
    re = /- \[[x ]\]/
    while i is null or i < n and ind isnt -1
      ind = str.indexOf '- [', if ind? then ind + 1 else 0
      if ind? and re.test str.substring ind, ind + 5
        i = if i? then i + 1 else 0
    return ind

  return {
    restrict: 'E'
    replace: true
    scope:
      opts: '='
      note: '='
    link: (scope, elem, attrs) ->
      update = (val) ->
        elem.html cmMarked val || '', scope.opts || null
        for c, i in elem.find 'input'
          el = angular.element c
          do (i, el) ->
            el.on 'change', (ev) ->
              content = scope.note.content
              ind = nthIndexOfCheckbox content, i
              content = content.substring(0, ind) +
                (if @checked then '- [x]' else '- [ ]') +
                content.substring(ind + 5)
              scope.note.content = content
              scope.note.save()

            el.on '$destroy', () ->
              el.off()

      if scope.note
        update scope.note.content || elem.text() || ''

      if attrs.note
        scope.$watch 'note.content', update
  }

angular.module 'CMKeeper'
  .directive 'cmMarked', [
    'cmMarked',
    cmMarkedDirective]
