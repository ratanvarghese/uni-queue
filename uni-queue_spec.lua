--Using "busted" framework

expose("require uni-queue", function()
	uq = require("uni-queue")
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
	local aliases = {
		push = "push_right",
		extend = "extend_right",
		pop = "pop_right"
	}
	it("aliases", function()
		for k,v in pairs(aliases) do
			assert.are.equals(uq[k], uq[v])
		end
	end)
end)

describe("empty", function()
	local q1 = uq.new()
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
	local values = {10, 4, 3}
	local q1 = uq.new()
	local push_1 = q1:push(values[1])
	local len_1 = q1:len()
	local push_2 = q1:push(values[2])
	local len_2 = q1:len()
	local push_3 = q1:push(values[3])
	local len_3 = q1:len()
	local push_4 = q1:push(values[2])
	local len_4 = q1:len()

	it("first push", function()
		assert.is_true(push_1)
		assert.are.equals(len_1, 1)
	end)
	it("second push", function()
		assert.is_true(push_2)
		assert.are.equals(len_2, 2)
	end)
	it("third push", function()
		assert.is_true(push_3)
		assert.are.equals(len_3, 3)
	end)
	it("redundant push", function()
		assert.is_false(push_4)
		assert.are.equals(len_4, 3)
	end)

	local pop_1 = q1:pop()
	local len_5 = q1:len()
	local pop_2 = q1:pop()
	local len_6 = q1:len()
	local pop_3 = q1:pop()
	local len_7 = q1:len()
	local pop_4 = q1:pop()
	local len_8 = q1:len()

	it("first pop", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(len_5, 2)
	end)
	it("second pop", function()
		assert.are.equals(pop_2, values[2])
		assert.are.equals(len_6, 1)
	end)
	it("third pop", function()
		assert.are.equals(pop_3, values[1])
		assert.are.equals(len_7, 0)
	end)
	it("empty pop", function()
		assert.is_nil(pop_4)
		assert.are.equals(len_8, 0)
	end)
end)

describe("stack left", function()
	local values = {10, 4, 3}
	local q1 = uq.new()
	local push_1 = q1:push_left(values[1])
	local len_1 = q1:len()
	local push_2 = q1:push_left(values[2])
	local len_2 = q1:len()
	local push_3 = q1:push_left(values[3])
	local len_3 = q1:len()
	local push_4 = q1:push_left(values[2])
	local len_4 = q1:len()

	it("first push", function()
		assert.is_true(push_1)
		assert.are.equals(len_1, 1)
	end)
	it("second push", function()
		assert.is_true(push_2)
		assert.are.equals(len_2, 2)
	end)
	it("third push", function()
		assert.is_true(push_3)
		assert.are.equals(len_3, 3)
	end)
	it("redundant push", function()
		assert.is_false(push_4)
		assert.are.equals(len_4, 3)
	end)

	local pop_1 = q1:pop_left()
	local len_5 = q1:len()
	local pop_2 = q1:pop_left()
	local len_6 = q1:len()
	local pop_3 = q1:pop_left()
	local len_7 = q1:len()
	local pop_4 = q1:pop_left()
	local len_8 = q1:len()

	it("first pop", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(len_5, 2)
	end)
	it("second pop", function()
		assert.are.equals(pop_2, values[2])
		assert.are.equals(len_6, 1)
	end)
	it("third pop", function()
		assert.are.equals(pop_3, values[1])
		assert.are.equals(len_7, 0)
	end)
	it("empty pop", function()
		assert.is_nil(pop_4)
		assert.are.equals(len_8, 0)
	end)
end)

describe("queue left to right", function()
	local values = {10, 4, 3}
	local q1 = uq.new()
	q1:push_left(values[1])
	q1:push_left(values[2])
	q1:push_left(values[3])
	q1:push_left(values[2])

	local pop_1 = q1:pop()
	local len_1 = q1:len()
	local pop_2 = q1:pop()
	local len_2 = q1:len()
	local pop_3 = q1:pop()
	local len_3 = q1:len()
	local pop_4 = q1:pop()
	local len_4 = q1:len()
	
	it("first pop", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(len_1, 2)
	end)
	it("second pop", function()
		assert.are.equals(pop_2, values[2])
		assert.are.equals(len_2, 1)
	end)
	it("third pop", function()
		assert.are.equals(pop_3, values[1])
		assert.are.equals(len_3, 0)
	end)
	it("empty pop", function()
		assert.is_nil(pop_4)
		assert.are.equals(len_4, 0)
	end)
end)

describe("queue right to left", function()
	local values = {10, 4, 3}
	local q1 = uq.new()
	q1:push(values[1])
	q1:push(values[2])
	q1:push(values[3])
	q1:push(values[2])

	local pop_1 = q1:pop_left()
	local len_1 = q1:len()
	local pop_2 = q1:pop_left()
	local len_2 = q1:len()
	local pop_3 = q1:pop_left()
	local len_3 = q1:len()
	local pop_4 = q1:pop_left()
	local len_4 = q1:len()
	
	it("first pop", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(len_1, 2)
	end)
	it("second pop", function()
		assert.are.equals(pop_2, values[2])
		assert.are.equals(len_2, 1)
	end)
	it("third pop", function()
		assert.are.equals(pop_3, values[1])
		assert.are.equals(len_3, 0)
	end)
	it("empty pop", function()
		assert.is_nil(pop_4)
		assert.are.equals(len_4, 0)
	end)
end)

describe("remove", function()
	local values = {10, 4, 3}
	local q1 = uq.new()
	q1:push(values[1])
	q1:push(values[2])
	q1:push(values[3])
	q1:remove(values[2])

	local len_0 = q1:len()
	local pop_1 = q1:pop()
	local len_1 = q1:len()
	local pop_2 = q1:pop()
	local len_2 = q1:len()
	local pop_3 = q1:pop()
	local len_3 = q1:len()

	it("length after remove", function()
		assert.are.equals(len_0, 2)
	end)
	it("first pop", function()
		assert.are.equals(pop_1, values[3])
		assert.are.equals(len_1, 1)
	end)
	it("second pop", function()
		assert.are.equals(pop_2, values[1])
		assert.are.equals(len_2, 0)
	end)
	it("third pop", function()
		assert.is_nil(pop_3)
		assert.are.equals(len_3, 0)
	end)
end)

describe("reverse", function()
	local values = {10, 4, 3}
	it("stack right", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push(v) end
		q1:reverse()
		for i,v in ipairs(values) do
			local actual = q1:pop()
			assert.are.equals(actual, v)
		end
	end)
	it("stack left", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_left(v) end
		q1:reverse()
		for i,v in ipairs(values) do
			local actual = q1:pop_left()
			assert.are.equals(actual, v)
		end
	end)
	it("right_to_left", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push(v) end
		q1:reverse()
		local i = 1
		for elem in q1:right_to_left() do
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1	
		end
	end)
	it("left_to_right", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_left(v) end
		q1:reverse()
		local i = 1
		for elem in q1:left_to_right() do
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1	
		end
	end)
end)

describe("rotate", function()
	local values = {10, 4, 3, 2, 0, 8}
	it("default", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_right(v) end
		q1:rotate()
		local expected = {8, 10, 4, 3, 2, 0}
		for i,v in ipairs(expected) do
			local actual = q1:pop_left()
			assert.are.equals(actual, v)
		end
	end)

	it("right 3", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_right(v) end
		q1:rotate(3)
		local expected = {2, 0, 8, 10, 4, 3}
		for i,v in ipairs(expected) do
			local actual = q1:pop_left()
			assert.are.equals(actual, v)
		end
	end)

	it("left 3", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_right(v) end
		q1:rotate(-3)
		local expected = {2, 0, 8, 10, 4, 3}
		for i,v in ipairs(expected) do
			local actual = q1:pop_left()
			assert.are.equals(actual, v)
		end

	end)
end)

describe("right_to_left", function()
	local values = {10, 4, 3, 2, 0, 8}
	it("basic", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push_left(v) end
		local i = 1
		for elem in q1:right_to_left() do
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1	
		end
	end)
end)

describe("left_to_right", function()
	local values = {10, 4, 3, 2, 0, 8}
	it("basic", function()
		local q1 = uq.new()
		for i,v in ipairs(values) do q1:push(v) end
		local i = 1
		for elem in q1:left_to_right() do
			local expected = values[i]
			assert.are.equals(elem, expected)
			i = i + 1	
		end
	end)
end)

describe("contains", function()
	local values = {10, 4, 3, 2, 0, 8}
	local q1 = uq.new()
	for i,v in ipairs(values) do q1:push_left(v) end
	it("inclusive", function()
		for i,v in ipairs(values) do
			assert.is_true(q1:contains(v))
		end
	end)
	it("exclusive", function()
		assert.is_false(q1:contains(1000))
	end)
end)
