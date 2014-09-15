cmMarkedProvider = () ->
  @setOptions = (opts) ->
    @defaults = opts

  this.$get = [
    '$window',
    ($window) =>
      m = $window.marked
      @setOptions = m.setOptions

      # live checkboxes
      renderer = new m.Renderer()
      renderer.listitem = (text) ->
        nestedInd = text.indexOf '<ul>'
        nested = if nestedInd > -1 then text.slice nestedInd else ''
        text = text.replace nested, ''

        if /^\s*\[[x ]\]\s*/.test text
          text = text
            .replace /^\s*\[x\]\s*/, "<input type=\"checkbox\" checked>"
            .replace /^\s*\[ \]\s*/, "<input type=\"checkbox\">"
          return "<li class=\"checkbox-item\"><label>#{text}</label>#{nested}</li>"
        return "<li>#{text}#{nested}</li>"

      m.setOptions
        gfm: true
        tables: true
        breaks: true
        pedantic: true
        sanitize: true
        smartLists: true
        smartypants: true
        highlight: (code) ->
          hljs.highlightAuto(code).value
        renderer: renderer

      m.setOptions @defaults

      return m
    ]
  @

angular.module 'CMKeeper'
  .provider 'cmMarked', [
    cmMarkedProvider]
