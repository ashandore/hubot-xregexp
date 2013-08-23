{Robot, TextListener} = require (process.env.HUBOT_HALL_REQUIRE_PATH || 'hubot')
XRegExp = require('xregexp').XRegExp;


Robot.respond = (regex, callback) ->
  re = regex.toString().split('/')
  re.shift()
  modifiers = re.pop()

  if re[0] and re[0][0] is '^'
    @logger.warning \
      "Anchors don't work well with respond, perhaps you want to use 'hear'"
    @logger.warning "The regex in question was #{regex.toString()}"

  pattern = re.join('/')
  name = @name.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')

  if @alias
    alias = @alias.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')
    newRegex = new XRegExp(
      "^[@]?(?:#{alias}[:,]?|#{name}[:,]?)\\s*(?:#{pattern})"
      modifiers
    )
  else
    newRegex = new XRegExp(
      "^[@]?#{name}[:,]?\\s*(?:#{pattern})",
      modifiers
    )

  console.log "Regex is #{newRegex}"

  @listeners.push new TextListener(@, newRegex, callback)