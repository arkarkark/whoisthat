
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
  @pageFooter = $sce.trustAsHtml(pageFooter)
  @done = true
  hotkeys.add "1", "Select the first person", @getGuessCallback(0)
  hotkeys.add "2", "Select the second person", @getGuessCallback(1)
  hotkeys.add "3", "Select the third person", @getGuessCallback(2)
  @ranges = [10000,100,50,10]
  @identify = 10000
  @choose = 10000

  console.log("done", @done)
  @

WhoCtrl::getGuessCallback = (idx) ->
  => @guess(@peep.choices[idx])


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

WhoCtrl::addChoices = (peeps, possibles) ->
  peeps.map ((x) ->
    x.choices = @choices(x, possibles)
    x
  ), this

WhoCtrl::choices = (peep, peeps) ->
  ans = [peep]
  ans.push(choose(peeps, ans, peep.hasFemaleName))
  ans.push(choose(peeps, ans, peep.hasFemaleName))
  shuffle(ans)

WhoCtrl::countPercent = ->
  return "" unless @total
  "(#{Math.floor((@count * 100) / @total)}%)"

WhoCtrl::scorePercent = ->
  return "" unless @count
  "(#{Math.floor((@score * 100) / @count)}%)"

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
  @count += 1

WhoCtrl::nextPeep = ->
  @index += 1
  @correct = undefined
  @guessed = undefined
  if @index < @peeps.length
    @peep = @peeps[@index]
    # pre-fecth the next image
    if @index + 1 < @peeps.length
      nextnext = new Image()
      nextnext.src = @peeps[@index + 1].img
  else
    @gameOver()
  @peep

WhoCtrl::gameOver = ->
  @done = true

WhoCtrl::reset = ->
  @peeps = shuffle(@addChoices(
    @turnIntoObjects(peepsData[-@identify...]),
    @turnIntoObjects(peepsData[-@choose...])
  ))
  @index = -1
  @nextPeep()
  @score = 0
  @count = 0
  @total = @peeps.length
  @done = false
  @guessed = undefined
  return

WhoCtrl::quit = -> @gameOver()

angular.module("who", ["cfp.hotkeys"]).config((hotkeysProvider) ->
  hotkeysProvider.includeCheatSheet = false
  return
).controller("WhoCtrl", WhoCtrl)
