describe "Util", () ->

    describe "indexOf()", () ->
        util = new Util()
        array = [0,1,2,3,4,5,6,7,8,9]
        obj = {
            red: 'cherry'
            orange: 'orange'
            yellow: 'banana'
            green: 'lime'
            blue: 'blueberry'
            violet: 'grape'
        }

        it "should return the index of an existing array item", () ->
            i = util.indexOf(array, 5)
            expect(i).toBe(5)

        it "should return -1 for item not in array", () ->
            i = util.indexOf(array, 10)
            expect(i).toBe(-1)

        it "should return the key of an existing object item", () ->
            k = util.indexOf(obj, 'banana')
            expect(k).toBe('yellow')

        it "should return -1 for item not in object", () ->
            k = util.indexOf(obj, 'indigo')
            expect(k).toBe(-1)

    describe "is()", () ->
        util = new Util()

        it "should return true for truthy values", () ->
            b = () -> return this
            vals = [{key: 'value'}, [1], 'string', true, b, parseInt('3'), {}, []]
            for val in vals
                i = util.is(val)
                expect(i).toBe(true)

        it "should return false for falsy values", () ->
            vals = [null, false, undefined, '']
            for val in vals
                i = util.is(val)
                expect(i).toBe(false)

    describe "is_function()", () ->
        i_f = new Util().is_function

        it "should return true for functions", () ->
            f = i_f(() -> return)
            expect(f).toBe(true)

        it "should return false for non-functions", () ->
            o = i_f({})
            a = i_f([])
            expect(o).toBe(false)
            expect(a).toBe(false)

    describe "is_empty_object()", () ->
        i_e = new Util().is_empty_object

        it "should return true for an empty object", () ->
            o = i_e({})
            expect(o).toBe(true)

        it "should return false for an object with keys", () ->
            o = i_e({key: 'value'})
            expect(o).toBe(false)

    describe "filter()", () ->
        f = new Util().filter
        array = [0,1,2,3,4,5,6,7,8,9]
        obj = {
            red: 'cherry'
            orange: 'orange'
            yellow: 'banana'
            green: 'lime'
            blue: 'blueberry'
            violet: 'grape'
        }

        it "should filter out odd numbers from an array", () ->
            e = f(array, (item) -> return item % 2 is 0)
            expect(e.length).toBe(5)
            expect(e[3]).toBe(6)

        it "should filter out object properties matching a substring", () ->
            s = f(obj, (v, k) -> return not /re/.test(k))
            expect(s.blue).toBeDefined()
            expect(s.orange).toBe('orange')
            expect(s.green).toBeUndefined()
            expect(s.red).not.toBeDefined()

    describe "reject()", () ->
        r = new Util().reject
        array = [0,1,2,3,4,5,6,7,8,9]
        obj = {
            red: 'cherry'
            orange: 'orange'
            yellow: 'banana'
            green: 'lime'
            blue: 'blueberry'
            violet: 'grape'
        }

        it "should filter out non-odd numbers from an array", () ->
            o = r(array, (item) -> return item % 2 is 0)
            expect(o.length).toEqual(5)
            expect(o[3]).toBe(7)

        it "should filter out object properties not matching a substring", () ->
            n = r(obj, (v, k) -> return not /re/.test(k))
            expect(n.blue).toBeUndefined()
            expect(n.orange).not.toBeDefined()
            expect(n.green).toBeDefined()
            expect(n.red).toBe('cherry')

    describe "reduce()", () ->
        r = new Util().reduce
        array = [0,1,2,3,4,5,6,7,8,9]

        it "should sum the numbers in an array", () ->
            s = r(array, (r, i) -> return r += i)
            expect(s).toBeDefined()
            expect(s).toBe(45)

        it "should collect items in an array into a string", () ->
            s = r(array, (r, i) ->
                return r += i
            , '')
            expect(s.length).toEqual(10)
            expect(s.constructor.name).toBe('String')
            expect(s.charAt).toBeDefined()
            expect(s.charAt(4)).toBe('4')
