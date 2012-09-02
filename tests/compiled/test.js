// Generated by CoffeeScript 1.3.3

describe("Util", function() {
  describe("indexOf()", function() {
    var array, obj, util;
    util = new Util();
    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    obj = {
      red: 'cherry',
      orange: 'orange',
      yellow: 'banana',
      green: 'lime',
      blue: 'blueberry',
      violet: 'grape'
    };
    it("should return the index of an existing array item", function() {
      var i;
      i = util.indexOf(array, 5);
      return expect(i).toBe(5);
    });
    it("should return -1 for item not in array", function() {
      var i;
      i = util.indexOf(array, 10);
      return expect(i).toBe(-1);
    });
    it("should return the key of an existing object item", function() {
      var k;
      k = util.indexOf(obj, 'banana');
      return expect(k).toBe('yellow');
    });
    return it("should return -1 for item not in object", function() {
      var k;
      k = util.indexOf(obj, 'indigo');
      return expect(k).toBe(-1);
    });
  });
  describe("is()", function() {
    var util;
    util = new Util();
    it("should return true for truthy values", function() {
      var b, i, val, vals, _i, _len, _results;
      b = function() {
        return this;
      };
      vals = [
        {
          key: 'value'
        }, [1], 'string', true, b, parseInt('3'), {}, []
      ];
      _results = [];
      for (_i = 0, _len = vals.length; _i < _len; _i++) {
        val = vals[_i];
        i = util.is(val);
        _results.push(expect(i).toBe(true));
      }
      return _results;
    });
    return it("should return false for falsy values", function() {
      var i, val, vals, _i, _len, _results;
      vals = [null, false, void 0, ''];
      _results = [];
      for (_i = 0, _len = vals.length; _i < _len; _i++) {
        val = vals[_i];
        i = util.is(val);
        _results.push(expect(i).toBe(false));
      }
      return _results;
    });
  });
  describe("is_function()", function() {
    var i_f;
    i_f = new Util().is_function;
    it("should return true for functions", function() {
      var f;
      f = i_f(function() {});
      return expect(f).toBe(true);
    });
    return it("should return false for non-functions", function() {
      var a, o;
      o = i_f({});
      a = i_f([]);
      expect(o).toBe(false);
      return expect(a).toBe(false);
    });
  });
  describe("is_empty_object()", function() {
    var i_e;
    i_e = new Util().is_empty_object;
    it("should return true for an empty object", function() {
      var o;
      o = i_e({});
      return expect(o).toBe(true);
    });
    return it("should return false for an object with keys", function() {
      var o;
      o = i_e({
        key: 'value'
      });
      return expect(o).toBe(false);
    });
  });
  describe("filter()", function() {
    var array, f, obj;
    f = new Util().filter;
    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    obj = {
      red: 'cherry',
      orange: 'orange',
      yellow: 'banana',
      green: 'lime',
      blue: 'blueberry',
      violet: 'grape'
    };
    it("should filter out odd numbers from an array", function() {
      var e;
      e = f(array, function(item) {
        return item % 2 === 0;
      });
      expect(e.length).toBe(5);
      return expect(e[3]).toBe(6);
    });
    return it("should filter out object properties matching a substring", function() {
      var s;
      s = f(obj, function(v, k) {
        return !/re/.test(k);
      });
      expect(s.blue).toBeDefined();
      expect(s.orange).toBe('orange');
      expect(s.green).toBeUndefined();
      return expect(s.red).not.toBeDefined();
    });
  });
  describe("reject()", function() {
    var array, obj, r;
    r = new Util().reject;
    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    obj = {
      red: 'cherry',
      orange: 'orange',
      yellow: 'banana',
      green: 'lime',
      blue: 'blueberry',
      violet: 'grape'
    };
    it("should filter out non-odd numbers from an array", function() {
      var o;
      o = r(array, function(item) {
        return item % 2 === 0;
      });
      expect(o.length).toEqual(5);
      return expect(o[3]).toBe(7);
    });
    return it("should filter out object properties not matching a substring", function() {
      var n;
      n = r(obj, function(v, k) {
        return !/re/.test(k);
      });
      expect(n.blue).toBeUndefined();
      expect(n.orange).not.toBeDefined();
      expect(n.green).toBeDefined();
      return expect(n.red).toBe('cherry');
    });
  });
  return describe("reduce()", function() {
    var array, r;
    r = new Util().reduce;
    array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    it("should sum the numbers in an array", function() {
      var s;
      s = r(array, function(r, i) {
        return r += i;
      });
      expect(s).toBeDefined();
      return expect(s).toBe(45);
    });
    return it("should collect items in an array into a string", function() {
      var s;
      s = r(array, function(r, i) {
        return r += i;
      }, '');
      expect(s.length).toEqual(10);
      expect(s.constructor.name).toBe('String');
      expect(s.charAt).toBeDefined();
      return expect(s.charAt(4)).toBe('4');
    });
  });
});