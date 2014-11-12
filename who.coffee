
# this file expects a variable called peepsData that looks like this:
# var peepsData = [
#   ['img url', 'NAME', 'DEPARTMENT'],
#   ['img url', 'NAME', 'DEPARTMENT'],
#  ];

# you can't guess again!

# Utility functions
###
choose a random element from an array
###
choose = (arr, opt_not, opt_hasFemaleName) ->
  ans = arr[Math.floor(Math.random() * arr.length)]
  if ((opt_not && (opt_not is ans || opt_not.indexOf(ans) != -1)) ||
      (opt_hasFemaleName? && ans.hasFemaleName != opt_hasFemaleName))
    # Try again... don't judge me!
    console.log(ans.name, ans.hasFemaleName, opt_hasFemaleName, opt_not)
    return choose(arr, opt_not, opt_hasFemaleName)
  ans

#+ Jonas Raoni Soares Silva
#@ http://jsfromhell.com/array/shuffle [v1.0]
shuffle = (o) ->
  j = undefined
  x = undefined
  i = o.length

  while i
    j = Math.floor(Math.random() * i)
    x = o[--i]
    o[i] = o[j]
    o[j] = x
  o

WhoCtrl = ($sce, $timeout, hotkeys) ->
  @timeout = $timeout
  @pageTitle = pageTitle
  @pageHeader = $sce.trustAsHtml(pageHeader)
  @reset()
  hotkeys.add "1", "Select the first person", @getGuessCallback(0)
  hotkeys.add "2", "Select the second person", @getGuessCallback(1)
  hotkeys.add "3", "Select the third person", @getGuessCallback(2)

  @

WhoCtrl::getGuessCallback = (idx) ->
  angular.bind this, ->
    @guess @peep.choices[idx]
    return


WhoCtrl::turnIntoObjects = (peeps) ->
  peeps.map(((x) ->
    img: x[0]
    name: x[1]
    dept: x[2]
    hasFemaleName: @isFemaleName(x[1])
    choices: @choices(x, peeps)
  ), this)

WhoCtrl::isFemaleName = (name) ->
  name = name.toLowerCase()
  for f in femaleNames
    return true if name.indexOf(f) == 0
  return false

WhoCtrl::addChoices = (peeps) ->
  peeps.map ((x) ->
    console.log(x)
    x.choices = @choices(x, peeps)
    x
  ), this

WhoCtrl::choices = (peep, peeps) ->
  ans = [peep]
  ans.push choose(peeps, ans, peep.hasFemaleName)
  ans.push choose(peeps, ans, peep.hasFemaleName)
  shuffle(ans)

WhoCtrl::guess = (guess) ->
  return  if @guessed
  @guessed = guess
  if guess is @peep
    @correct = true
    @score += 1
    @timeout angular.bind(this, @nextPeep), 500
  else
    @correct = false
    @timeout angular.bind(this, @nextPeep), 3000
  return

WhoCtrl::nextPeep = ->
  @index += 1
  @correct = undefined
  @guessed = undefined
  if @index < @peeps.length
    @peep = @peeps[@index]
  else
    @gameOver()
  return

WhoCtrl::gameOver = ->
  @done = true
  return

WhoCtrl::reset = ->
  @peeps = shuffle(@addChoices(@turnIntoObjects(peepsData)))
  @index = 0
  @peep = @peeps[0]
  @score = 0
  @done = false
  @guessed = undefined
  return

angular.module("who", ["cfp.hotkeys"]).config((hotkeysProvider) ->
  hotkeysProvider.includeCheatSheet = false
  return
).controller("WhoCtrl", WhoCtrl)
