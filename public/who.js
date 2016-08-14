
/*
choose a random element from an array
 */

(function() {
  var WhoCtrl, choose, m, shuffle;

  choose = function(arr, opt_not) {
    var ans;
    ans = arr[Math.floor(Math.random() * arr.length)];
    console.log(arr, opt_not, ans);
    if (opt_not && (opt_not === ans || opt_not.indexOf(ans) !== -1)) {
      return choose(arr, opt_not);
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
    var k, x;
    this.allPeeps = this.turnIntoObjects(peepsData);
    this.timeout = $timeout;
    this.pageTitle = pageTitle;
    this.pageHeader = $sce.trustAsHtml(pageHeader);
    this.pageFooter = $sce.trustAsHtml(pageFooter);
    this.done = true;
    for (x = k = 1; k <= 9; x = ++k) {
      hotkeys.add("" + x, "Select person " + x, this.getGuessCallback(x - 1));
    }
    this.ranges = [10000, 100, 50, 10];
    this.identify = 10000;
    this.choose = 10000;
    this.optionsRange = [2, 3, 5, 9];
    this.numOfOptions = 3;
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
    return peeps.map((function(_this) {
      return function(x) {
        return {
          img: x[0],
          name: x[1],
          dept: x[2],
          hasFemaleName: _this.isFemaleName(x[1]),
          choices: [x]
        };
      };
    })(this));
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

  WhoCtrl.prototype.addChoices = function(peeps, possibles) {
    var femalePossibles, malePossibles;
    malePossibles = _.where(possibles, {
      hasFemaleName: false
    });
    femalePossibles = _.where(possibles, {
      hasFemaleName: true
    });
    return peeps.map((function(_this) {
      return function(x) {
        x.choices = _this.choices(x, x.hasFemaleName ? femalePossibles : malePossibles);
        return x;
      };
    })(this));
  };

  WhoCtrl.prototype.choices = function(peep, peeps) {
    shuffle(peeps);
    return shuffle([peep].concat(peeps.slice(0, +(this.numOfOptions - 2) + 1 || 9e9)));
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
      this.timeout((function(_this) {
        return function() {
          return _this.nextPeep();
        };
      })(this), 500);
    } else {
      this.correct = false;
      this.timeout((function(_this) {
        return function() {
          return _this.nextPeep();
        };
      })(this), 3000);
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
    return this.done = true;
  };

  WhoCtrl.prototype.reset = function() {
    this.peeps = shuffle(this.addChoices(this.allPeeps.slice(-this.identify), this.allPeeps.slice(-this.choose)));
    this.index = -1;
    this.nextPeep();
    this.score = 0;
    this.count = 0;
    this.total = this.peeps.length;
    this.done = false;
    this.guessed = void 0;
  };

  WhoCtrl.prototype.quit = function() {
    return this.gameOver();
  };

  m = angular.module("who", ["cfp.hotkeys"]);

  m.config(function(hotkeysProvider) {
    return hotkeysProvider.includeCheatSheet = false;
  });

  m.controller("WhoCtrl", WhoCtrl);

}).call(this);
