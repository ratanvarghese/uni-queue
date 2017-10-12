local uq = {}

function uq.new()
	local res = {}
	local mt = {
		__index = uq
	}
	setmetatable(res, mt)
	return res
end

function uq:push()
end

function uq:push_left()
end

function uq:extend()
end

function uq:extend_right()
end

function uq:clear()
end

function uq:pop()
end

function uq:pop_left()
end

function uq:remove()
end

function uq:reverse()
end

function uq:rotate()
end

function uq:right_to_left()
end

function uq:left_to_right()
end

function uq:len()
end

function uq:contains()
end

uq.pop_right = uq.pop
uq.push_right = uq.push

return uq
