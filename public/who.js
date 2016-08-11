
/*
choose a random element from an array
 */

(function() {
  var WhoCtrl, choose, shuffle;

  choose = function(arr, opt_not, opt_hasFemaleName) {
    var ans;
    ans = arr[Math.floor(Math.random() * arr.length)];
    if ((opt_not && (opt_not === ans || opt_not.indexOf(ans) !== -1)) || ((opt_hasFemaleName != null) && ans.hasFemaleName !== opt_hasFemaleName)) {
      return choose(arr, opt_not, opt_hasFemaleName);
    }
    return ans;
  };

  shuffle = function(o) {
    var i, j, x;
    j = void 0;
    x = void 0;
    i = o.length;
    while (i) {
      j = Math.floor(Math.random() * i);
      x = o[--i];
      o[i] = o[j];
      o[j] = x;
    }
    return o;
  };

  WhoCtrl = function($sce, $timeout, hotkeys) {
    this.timeout = $timeout;
    this.pageTitle = pageTitle;
    this.pageHeader = $sce.trustAsHtml(pageHeader);
    this.pageFooter = $sce.trustAsHtml(pageFooter);
    this.reset();
    hotkeys.add("1", "Select the first person", this.getGuessCallback(0));
    hotkeys.add("2", "Select the second person", this.getGuessCallback(1));
    hotkeys.add("3", "Select the third person", this.getGuessCallback(2));
    return this;
  };

  WhoCtrl.prototype.getGuessCallback = function(idx) {
    return (function(_this) {
      return function() {
        return _this.guess(_this.peep.choices[idx]);
      };
    })(this);
  };

  WhoCtrl.prototype.turnIntoObjects = function(peeps) {
    return peeps.map((function(x) {
      return {
        img: x[0],
        name: x[1],
        dept: x[2],
        hasFemaleName: this.isFemaleName(x[1]),
        choices: this.choices(x, peeps)
      };
    }), this);
  };

  WhoCtrl.prototype.isFemaleName = function(name) {
    var f, k, len;
    name = name.toLowerCase();
    for (k = 0, len = femaleNames.length; k < len; k++) {
      f = femaleNames[k];
      if (name.indexOf(f) === 0) {
        return true;
      }
    }
    return false;
  };

  WhoCtrl.prototype.addChoices = function(peeps) {
    return peeps.map((function(x) {
      x.choices = this.choices(x, peeps);
      return x;
    }), this);
  };

  WhoCtrl.prototype.choices = function(peep, peeps) {
    var ans;
    ans = [peep];
    ans.push(choose(peeps, ans, peep.hasFemaleName));
    ans.push(choose(peeps, ans, peep.hasFemaleName));
    return shuffle(ans);
  };

  WhoCtrl.prototype.countPercent = function() {
    if (!this.total) {
      return "";
    }
    return "(" + (Math.floor((this.count * 100) / this.total)) + "%)";
  };

  WhoCtrl.prototype.scorePercent = function() {
    if (!this.count) {
      return "";
    }
    return "(" + (Math.floor((this.score * 100) / this.count)) + "%)";
  };

  WhoCtrl.prototype.guess = function(guess) {
    if (this.guessed) {
      return;
    }
    this.guessed = guess;
    if (guess === this.peep) {
      this.correct = true;
      this.score += 1;
      this.timeout(angular.bind(this, this.nextPeep), 500);
    } else {
      this.correct = false;
      this.timeout(angular.bind(this, this.nextPeep), 3000);
    }
    return this.count += 1;
  };

  WhoCtrl.prototype.nextPeep = function() {
    var nextnext;
    this.index += 1;
    this.correct = void 0;
    this.guessed = void 0;
    if (this.index < this.peeps.length) {
      this.peep = this.peeps[this.index];
      if (this.index + 1 < this.peeps.length) {
        nextnext = new Image();
        nextnext.src = this.peeps[this.index + 1].img;
      }
    } else {
      this.gameOver();
    }
    return this.peep;
  };

  WhoCtrl.prototype.gameOver = function() {
    this.done = true;
  };

  WhoCtrl.prototype.reset = function() {
    this.peeps = shuffle(this.addChoices(this.turnIntoObjects(peepsData)));
    this.index = -1;
    this.nextPeep();
    this.score = 0;
    this.count = 0;
    this.total = this.peeps.length;
    this.done = false;
    this.guessed = void 0;
  };

  angular.module("who", ["cfp.hotkeys"]).config(function(hotkeysProvider) {
    hotkeysProvider.includeCheatSheet = false;
  }).controller("WhoCtrl", WhoCtrl);

}).call(this);