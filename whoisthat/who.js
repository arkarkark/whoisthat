
/** this file expects a variable called peepsData that looks like this:
 * var peepsData = [
 *   ['img url', 'NAME', 'DEPARTMENT'],
 *   ['img url', 'NAME', 'DEPARTMENT'],
 *  ];
 */

WhoCtrl = function($sce, $timeout, hotkeys) {
  this.timeout = $timeout;
  this.pageTitle = pageTitle;
  this.pageHeader = $sce.trustAsHtml(pageHeader);
  this.reset();
  hotkeys.add('1', 'Select the first person', this.getGuessCallback(0));
  hotkeys.add('2', 'Select the second person', this.getGuessCallback(1));
  hotkeys.add('3', 'Select the third person', this.getGuessCallback(2));
};

WhoCtrl.prototype.getGuessCallback = function(idx) {
  return angular.bind(this, function() {
    this.guess(this.peep.choices[idx]);
  });
};

WhoCtrl.prototype.turnIntoObjects = function(peeps) {
  return peeps.map(function(x) {
    return {img: x[0], name: x[1], dept: x[2], choices: this.choices(x, peeps)};
  }, this);
};

WhoCtrl.prototype.addChoices = function(peeps) {
  return peeps.map(function(x) {
    x.choices = this.choices(x, peeps);
    return x;
  }, this);
};

WhoCtrl.prototype.choices = function(peep, peeps) {

  var ans = [peep];
  ans.push(choose(peeps, ans));
  ans.push(choose(peeps, ans));
  shuffle(ans);
  return ans;
};

WhoCtrl.prototype.guess = function(guess) {
  if (this.guessed) {
    return;  // you can't guess again!
  }
  this.guessed = guess;
  if (guess == this.peep) {
    this.correct = true;
    this.score += 1;
    this.timeout(angular.bind(this, this.nextPeep), 500);
  } else {
    this.correct = false;
    this.timeout(angular.bind(this, this.nextPeep), 3000);
  }
};

WhoCtrl.prototype.nextPeep = function() {
  this.index += 1;
  this.correct = undefined;
  this.guessed = undefined;
  if (this.index < this.peeps.length) {
    this.peep = this.peeps[this.index];
  } else {
    this.gameOver();
  }
};

WhoCtrl.prototype.gameOver = function() {
  this.done = true;
};

WhoCtrl.prototype.reset = function() {
  this.peeps = shuffle(this.addChoices(this.turnIntoObjects(peepsData)));
  this.index = 0;
  this.peep = this.peeps[0];
  this.score = 0;
  this.done = false;
  this.guessed = undefined;
};

angular.module('who', ['cfp.hotkeys']).config(function(hotkeysProvider) {
  hotkeysProvider.includeCheatSheet = false;
}).controller('WhoCtrl', WhoCtrl);

// Utility functions
/** choose a random element from an array */
function choose(arr, opt_not) {
  var ans = arr[Math.floor(Math.random() * arr.length)];
  if (opt_not && (opt_not == ans || opt_not.indexOf(ans) != -1)) {
    return choose(arr, opt_not);  // don't judge me!
  }
  return ans;
}

//+ Jonas Raoni Soares Silva
//@ http://jsfromhell.com/array/shuffle [v1.0]
function shuffle(o){ //v1.0
    for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
};
