--Using "busted" framework

expose("require uni-queue", function()
	setup(function()
		uq = require("uni-queue")
	end)
	it("package.loaded", function()
		assert.truthy(package.loaded["uni-queue"])
	end)
	it("package is a table", function()
		assert.are.equals(type(uq), "table")
	end)
	it("new is a function", function()
		assert.are.equals(type(uq.new), "function")
	end)
end)

describe("function existence", function()
	local aliases
	setup(function()
		aliases = {
			push = "push_right",
			extend = "extend_right",
			pop = "pop_right"
		}
	end)
	it("aliases", function()
		for k,v in pairs(aliases) do
			assert.are.equals(uq[k], uq[v])
		end
	end)
end)

describe("empty", function()
	local q1
	setup(function()
		q1 = uq.new()
	end)
	it("pop", function()
		assert.is_nil(q1:pop())
		assert.is_nil(q1:pop_left())
	end)
	it("remove", function()
		assert.has_no.errors(function() q1:remove(1) end)
	end)
	it("rotate", function()
		assert.has_no.errors(function() q1:rotate() end)
		assert.has_no.errors(function() q1:rotate(10) end)
	end)
	it("right_to_left", function()
		local count = 0
		for elem in q1:right_to_left() do
			count = count + 1
		end
		assert.are.equals(count, 0)
	end)
	it("left_to_right", function()
		local count = 0
		for elem in q1:left_to_right() do
			count = count + 1
		end
		assert.are.equals(count, 0)
	end)
	it("len", function()
		assert.are.equals(q1:len(), 0)
	end)
	it("contains", function()
		assert.is_false(q1:contains(1))
	end)
end)

describe("stack right", function()
	local values, q1
	local push, pop, len = {}, {}, {}
	setup(function()
		values = {10, 4, 3}
		q1 = uq.new()
		push[1] = q1:push(values[1])
		len[1] = q1:len()
		push[2] = q1:push(values[2])
		len[2] = q1:len()
		push[3] = q1:push(values[3])
		len[3] = q1:len()
		push[4] = q1:push(values[2])
		len[4] = q1:len()

		pop[1] = q1:pop()
		len[5] = q1:len()
		pop[2] = q1:pop()
		len[6] = q1:len()
		pop[3] = q1:pop()
		len[7] = q1:len()
		pop[4] = q1:pop()
		len[8] = q1:len()
	end)
	it("lengths", function()
		local expected = {1, 2, 3, 3, 2, 1, 0, 0}
		for i,v in ipairs(expected) do
			assert.are.equals(len[i], v)
		end
	end)
	it("pushes", function()
		local expected = {true, true, true, false}
		for i,v in ipairs(expected) do
			assert.are.equals(push[i], v)
		end
	end)
	it("actual pops", function()
		local expected = {values[3], values[2], values[1]}
		for i,v in ipairs(expected) do
			assert.are.equals(pop[i], v)
		end
	end)
	it("empty pop", function()
		assert.is_nil(pop[4])
	end)
end)

describe("stack left", function()
	local values, q1
	local push, pop, len = {}, {}, {}
	setup(function()
		values = {10, 4, 3}
		q1 = uq.new()
		push[1] = q1:push_left(values[1])
		len[1] = q1:len()
		push[2] = q1:push_left(values[2])
		len[2] = q1:len()
		push[3] = q1:push_left(values[3])
		len[3] = q1:len()
		push[4] = q1:push_left(values[2])
		len[4] = q1:len()
		pop[1] = q1:pop_left()
		len[5] = q1:len()
		pop[2] = q1:pop_left()
		len[6] = q1:len()
		pop[3] = q1:pop_left()
		len[7] = q1:len()
		pop[4] = q1:pop_left()
		len[8] = q1:len()
	end)
	it("lengths", function()
		local expected = {1, 2, 3, 3, 2, 1, 0, 0}
		for i,v in ipairs(expected) do
			assert.are.equals(len[i], v)
		end
	end)
	it("pushes", function()
		local expected = {true, true, true, false}
		for i,v in ipairs(expected) do
			assert.are.equals(push[i], v)
		end
	end)
	it("actual pops", function()
		local expected = {values[3], values[2], values[1]}
		for i,v in ipairs(expected) do
			assert.are.equals(pop[i], v)
		end
	end)
	it("empty pop", function()
		assert.is_nil(pop[4])
	end)
end)

describe("queue left to right", function()
	local values, q1
	local pop, len = {}, {}
	setup(function()
		values = {10, 4, 3}
		q1 = uq.new()
		q1:push_left(values[1])
		q1:push_left(values[2])
		q1:push_left(values[3])
		q1:push_left(values[2])

		pop[1] = q1:pop()
		len[1] = q1:len()
		pop[2] = q1:pop()
		len[2] = q1:len()
		pop[3] = q1:pop()
		len[3] = q1:len()
		pop[4] = q1:pop()
		len[4] = q1:len()
	end)
	it("lengths", function()
		local expected = {2, 1, 0, 0}
		for i,v in ipairs(expected) do
			assert.are.equals(len[i], v)
		end
	end)
	it("actual pops", function()
		local expected = {values[1], values[2], values[3]}
		for i,v in ipairs(expected) do
			assert.are.equals(pop[i], v)
		end
	end)
	it("empty pop", function()
		assert.is_nil(pop[4])
	end)
end)

describe("queue right to left", function()
	local values, q1
	local pop, len = {}, {}
	setup(function()
		values = {10, 4, 3}
		q1 = uq.new()
		q1:push(values[1])
		q1:push(values[2])
		q1:push(values[3])
		q1:push(values[2])

		pop[1] = q1:pop_left()
		len[1] = q1:len()
		pop[2] = q1:pop_left()
		len[2] = q1:len()
		pop[3] = q1:pop_left()
		len[3] = q1:len()
		pop[4] = q1:pop_left()
		len[4] = q1:len()
	end)
	it("lengths", function()
		local expected = {2, 1, 0, 0}
		for i,v in ipairs(expected) do
			assert.are.equals(len[i], v)
		end
	end)
	it("actual pops", function()
		local expected = {values[1], values[2], values[3]}
		for i,v in ipairs(expected) do
			assert.are.equals(pop[i], v)
		end
	end)
	it("empty pop", function()
		assert.is_nil(pop[4])
	end)
end)

describe("push nil right", function()
	local val, q1, res, len_0, pop_0
	setup(function()
		val = 100
		q1 = uq.new()
		q1:push(val)
		res = q1:push(nil)
		len_0 = q1:len()
		pop_0 = q1:pop()
	end)
	it("return value", function()
		assert.is_false(res)
	end)
	it("length", function()
		assert.are.equals(len_0, 1)
	end)
	it("final pop", function()
		assert.are.equals(pop_0, val)
	end)
end)

describe("push nil left", function()
	local val, q1, res, len_0, pop_0
	setup(function()
		val = 100
		q1 = uq.new()
		q1:push_left(val)
		res = q1:push_left(nil)
		len_0 = q1:len()
		pop_0 = q1:pop_left()
	end)
	it("return value", function()
		assert.is_false(res)
	end)
	it("length", function()
		assert.are.equals(len_0, 1)
	end)
	it("final pop", function()
		assert.are.equals(pop_0, val)
	end)
end)

describe("remove", function()
	local values, q1, pop_1, pop_2, pop_3
	local len = {}
	setup(function()
		values = {10, 4, 3}
		q1 = uq.new()
		q1:push(values[1])
		q1:push(values[2])
		q1:push(values[3])
		q1:remove(values[2])

		len[1] = q1:len()
		pop_1 = q1:pop()
		len[2] = q1:len()
		pop_2 = q1:pop()
		len[3] = q1:len()
		pop_3 = q1:pop()
		len[4] = q1:len()
	end)
	it("lengths", function()
		local expected = {2, 1, 0, 0}
		for i,v in ipairs(expected) do
			assert.are.equals(len[i], v)
		end
	end)
	it("actual pops", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(pop_2, values[1])
	end)
	it("final pop", function()
		assert.is_nil(pop_3)
	end)
end)

describe("reverse", function()
	local values, q1
	setup(function()
		values = {10, 4, 3}
	end)
	before_each(function()
		q1 = uq.new()
	end)
	it("stack right", function()
		for i,v in ipairs(values) do q1:push(v) end
		q1:reverse()
		for i,v in ipairs(values) do
			assert.are.equals(q1:pop(), v)
		end
	end)
	it("stack left", function()
		for i,v in ipairs(values) do q1:push_left(v) end
		q1:reverse()
		for i,v in ipairs(values) do
			assert.are.equals(q1:pop_left(), v)
		end
	end)
	it("right_to_left", function()
		for i,v in ipairs(values) do q1:push(v) end
		q1:reverse()
		local i = 1
		for elem in q1:right_to_left() do
			assert.are.equals(elem, values[i])
			i = i + 1	
		end
	end)
	it("left_to_right", function()
		for i,v in ipairs(values) do q1:push_left(v) end
		q1:reverse()
		local i = 1
		for elem in q1:left_to_right() do
			assert.are.equals(elem, values[i])
			i = i + 1	
		end
	end)
end)

describe("rotate", function()
	local values, cases
	setup(function()
		values = {10, 4, 3, 2, 0, 8}
		cases = {
			{output={2, 0, 8, 10, 4, 3}, input=3},
			{output={0, 8, 10, 4, 3, 2}, input=2},
			{output={8, 10, 4, 3, 2, 0}, input=1},
			{output={8, 10, 4, 3, 2, 0}, input=nil},
			{output={4, 3, 2, 0, 8, 10}, input=-1},
			{output={3, 2, 0, 8, 10, 4}, input=-2},
			{output={2, 0, 8, 10, 4, 3}, input=-3},
		}
	end)
	it("all", function()
		for i,c in ipairs(cases) do
			local q1 = uq.new()
			for _,v in ipairs(values) do
				q1:push_right(v)
			end
			q1:rotate(c.input)
			for i,v in ipairs(c.output) do
				assert.are.equals(q1:pop_left(),v)
			end
		end
	end)
end)

describe("right_to_left", function()
	local values, i, q1
	setup(function()
		values = {10, 4, 3, 2, 0, 8}
	end)
	before_each(function()
		q1 = uq.new()
		for _,v in ipairs(values) do q1:push_left(v) end
		i = 1
	end)
	it("basic", function()
		for elem in q1:right_to_left() do
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
	it("push back while iterating", function()
		for elem in q1:right_to_left() do
			q1:push_right(1)
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
	it("push forward while iterating", function()
		local push_val = 20
		for elem in q1:right_to_left() do
			local expected = values[i]
			if expected then
				q1:push_left(push_val + i)
			else
				expected = push_val + i - #values
			end
			assert.are.equals(elem, expected)
			i = i + 1
		end
		assert.are.equals(i, #values*2 + 1)
	end)
	it("pop back while iterating", function()
		assert.has_error(function()
			for elem in q1:right_to_left() do
				q1:pop_right()
				assert.are.equals(elem, values[i])
				i = i + 1
			end
		end, "Illegal alteration during traversal")
	end)
	it("pop back carefully while iterating", function()
		for elem in q1:right_to_left() do
			if i > 1 then
				q1:pop_right()
			end
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
	it("pop forward while iterating", function()
		for elem in q1:right_to_left() do
			q1:pop_left()
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values/2 + 1)
	end)
	it("reverse while iterating", function()
		for elem in q1:right_to_left() do
			q1:reverse()
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
	it("clear while iterating", function()
		assert.has_error(function()
			for elem in q1:right_to_left() do
				q1:clear()
				assert.are.equals(elem, values[i])
				i = i + 1
			end
		end, "Illegal alteration during traversal")
		assert.are.equals(i, 2)
	end)
	it("remove while iterating", function()
		assert.has_error(function()
			for elem in q1:right_to_left() do
				q1:remove(elem)
				assert.are.equals(elem, values[i])
				i = i + 1
			end
		end, "Illegal alteration during traversal")
		assert.are.equals(i, 2)
	end)
	it("remove carefully while iterating", function()
		local prev
		for elem in q1:right_to_left() do
			if prev then q1:remove(prev) end
			assert.are.equals(elem, values[i])
			prev = elem
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
end)

describe("left_to_right", function()
	local values, q1, i
	setup(function()
		values = {10, 4, 3, 2, 0, 8}
	end)
	before_each(function()
		q1 = uq.new()
		for i,v in ipairs(values) do q1:push(v) end
		i = 1
	end)
	it("basic", function()
		for elem in q1:left_to_right() do
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1	
		end
	end)
	it("push back while iterating", function()
		for elem in q1:left_to_right() do
			q1:push_left(1)
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1
		end
	end)
	it("push forward while iterating", function()
		local push_val = 20
		for elem in q1:left_to_right() do
			local expected = values[i]
			if expected then
				q1:push(push_val + i)
			else
				expected = push_val + i - #values
			end
			assert.are.equals(elem, expected)
			i = i + 1
		end
		assert.are.equals(i, #values*2 + 1)
	end)
	it("pop back while iterating", function()
		assert.has_error(function()
			for elem in q1:left_to_right() do
				q1:pop_left()
				local expected = values[i]
				assert.are.equals(elem, expected)
				i = i + 1
			end
		end, "Illegal alteration during traversal")
	end)
	it("pop back carefully while iterating", function()
		for elem in q1:left_to_right() do
			if i > 1 then
				q1:pop_left()
			end
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1
		end
	end)
	it("pop forward while iterating", function()
		for elem in q1:left_to_right() do
			q1:pop()
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1
		end
		assert.are.equals(i, #values/2 + 1)
	end)
	it("reverse while iterating", function()
		for elem in q1:left_to_right() do
			q1:reverse()
			assert.are.equals(elem, values[i])
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
	it("clear while iterating", function()
		assert.has_error(function()
			for elem in q1:left_to_right() do
				q1:clear()
				local expected = values[i]
				assert.are.equals(elem, expected)
				i = i + 1
			end
		end, "Illegal alteration during traversal")
		assert.are.equals(i, 2)
	end)
	it("remove while iterating", function()
		assert.has_error(function()
			for elem in q1:left_to_right() do
				q1:remove(elem)
				assert.are.equals(elem, values[i])
				i = i + 1
			end
		end, "Illegal alteration during traversal")
		assert.are.equals(i, 2)
	end)
	it("remove carefully while iterating", function()
		local prev
		for elem in q1:left_to_right() do
			if prev then q1:remove(prev) end
			assert.are.equals(elem, values[i])
			prev = elem
			i = i + 1
		end
		assert.are.equals(i, #values + 1)
	end)
end)

describe("contains", function()
	local values, q1
	setup(function()
		values = {10, 4, 3, 2, 0, 8}
		q1 = uq.new()
		for i,v in ipairs(values) do q1:push_left(v) end
	end)
	it("inclusive", function()
		for i,v in ipairs(values) do
			assert.is_true(q1:contains(v))
		end
	end)
	it("exclusive", function()
		assert.is_false(q1:contains(1000))
	end)
end)
