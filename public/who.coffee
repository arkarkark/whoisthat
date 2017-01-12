
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
choose = (arr, opt_not) ->
  ans = arr[Math.floor(Math.random() * arr.length)]
  console.log(arr, opt_not, ans)
  if (opt_not && (opt_not is ans || opt_not.indexOf(ans) != -1))
    # Try again... don't judge me!
    return choose(arr, opt_not)
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
  @allPeeps = @turnIntoObjects(peepsData)
  @typeyMode = ""
  @fullNames = ""
  @timeout = $timeout
  @pageTitle = pageTitle
  @pageHeader = $sce.trustAsHtml(pageHeader)
  @pageFooter = $sce.trustAsHtml(pageFooter)
  @done = true
  for x in [1..9]
    hotkeys.add "#{x}", "Select person #{x}", @getGuessCallback(x - 1)

  @ranges = [10000, 100, 50, 10]
  @identify = 10000
  @choose = 10000
  @optionsRange = [2, 3, 5, 9]
  @numOfOptions = 3

  return @

WhoCtrl::getGuessCallback = (idx) ->
  => @guess(@peep.choices[idx])


WhoCtrl::turnIntoObjects = (peeps) ->
  peeps.map (x) =>
    img: x[0]
    name: x[1]
    dept: x[2]
    hasFemaleName: @isFemaleName(x[1])
    choices: [x]

WhoCtrl::isFemaleName = (name) ->
  name = name.toLowerCase()
  for f in femaleNames
    return true if name.indexOf(f) == 0
  return false

WhoCtrl::addChoices = (peeps, possibles) ->
  malePossibles   = _.where(possibles, hasFemaleName: false)
  femalePossibles = _.where(possibles, hasFemaleName: true)

  peeps.map (x) =>
    x.choices = @choices(x, if x.hasFemaleName then femalePossibles else malePossibles)
    x

WhoCtrl::choices = (peep, peeps) ->
  shuffle(peeps)
  shuffle([peep].concat(peeps[0..@numOfOptions - 2]))

WhoCtrl::countPercent = ->
  return "" unless @total
  "(#{Math.floor((@count * 100) / @total)}%)"

WhoCtrl::scorePercent = ->
  return "" unless @count
  "(#{Math.floor((@score * 100) / @count)}%)"

WhoCtrl::guess = (guess) ->
  return if @guessed
  @guessed = guess
  if guess is @peep
    @right()
  else
    @wrong()

WhoCtrl::right = ->
  @count += 1
  @correct = true
  @score += 1
  @timeout(
    => @nextPeep()
    500
  )

WhoCtrl::wrong = ->
  @count += 1
  @correct = false
  @timeout(
    => @nextPeep()
    3000
  )

WhoCtrl::nextPeep = ->
  @index += 1
  @typed = ""
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
  @peeps = shuffle @addChoices @allPeeps[-@identify...], @allPeeps[-@choose...]
  @index = -1
  @nextPeep()
  @score = 0
  @count = 0
  @total = @peeps.length
  @done = false
  @guessed = undefined

  @fuzzy = FuzzySet()
  for peep in @allPeeps
    @fuzzy.add(@getName(peep.name))

WhoCtrl::getName = (name) ->
  if @fullNames then name else name.split(" ")[0]

WhoCtrl::key = (event) ->
  if event.which == 13

    @guessed ?= """It was "#{@peep.name}" """
    ans = @fuzzy.get(@typed)
    console.log("fuzzy", JSON.stringify(ans))
    for match in ans || []
      if match[0] >= 0.8 && match[1] == @getName(@peep.name)
        return @right()
    @wrong()

WhoCtrl::quit = -> @gameOver()

m = angular.module("who", ["cfp.hotkeys"])
m.config (hotkeysProvider) -> hotkeysProvider.includeCheatSheet = false
m.controller("WhoCtrl", WhoCtrl)
