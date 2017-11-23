otom = require("otom")

local uq = {}

function uq.new()
	local res = {}
	local mt = {
		__index = uq
	}
	setmetatable(res, mt)
	res:clear()
	return res
end

local function push_common(self, new_elem, on_top)
	if new_elem == nil then
		return false
	end
	if self._idx_by_elem[new_elem] ~= nil then
		return false
	end

	if on_top then
		if self._len > 0 then
			self._top = self._top + 1
		end
		self._elem_by_idx[self._top] = new_elem
	else
		if self._len > 0 then
			self._bot = self._bot - 1
		end
		self._elem_by_idx[self._bot] = new_elem
	end
	self._len = self._len + 1
	return true
end

function uq:push(new_elem)
	return push_common(self, new_elem, self._top_is_right)
end

function uq:push_left(new_elem)
	return push_common(self, new_elem, not self._top_is_right)
end

local function peek_common(self, on_top)
	if on_top then
		return self._elem_by_idx[self._top]
	else
		return self._elem_by_idx[self._bot]
	end
end

function uq:peek()
	return peek_common(self, self._top_is_right)
end

function uq:peek_left()
	return peek_common(self, not self._top_is_right)
end

function uq:clear()
	local ft, rt = otom.new()
	self._top = 0
	self._bot = 0
	self._len = 0
	self._elem_by_idx = ft
	self._idx_by_elem = rt
	self._top_is_right = true
end

local function pop_common(self, on_top)
	local res = peek_common(self, on_top)
	self:remove(res)
	return res
end

function uq:pop()
	return pop_common(self, self._top_is_right)
end

function uq:pop_left()
	return pop_common(self, not self._top_is_right)
end

function uq:remove(targ_item)
	local targ_idx = self._idx_by_elem[targ_item]
	if not targ_idx then
		return
	end
	local top_diff = self._top - targ_idx
	local bot_diff = targ_idx - self._bot
	local t = self._elem_by_idx
	if top_diff < bot_diff then
		for i = targ_idx,self._top do
			t[i] = t[i+1]
		end
		self._top = self._top - 1
	else
		for i = targ_idx,self._bot,-1 do
			t[i] = t[i-1]
		end
		self._bot = self._bot + 1
	end
	self._len = self._len - 1
end

function uq:reverse()
	self._top_is_right = not self._top_is_right
end

function uq:rotate(count)
	local count = count or 1
	if count > 0 then
		for i = 0,count-1 do
			self:push_left(self:pop())
		end
	elseif count < 0 then
		for i = 0,count+1,-1 do
			self:push(self:pop_left())
		end
	end
end

local function traverser(self, top_to_bottom)
	local start, inc = 0, 0
	if top_to_bottom then
		start = self._top
		inc = -1
	else
		start = self._bot
		inc = 1
	end

	return function(self, prev)
		if prev == nil then
			return self._elem_by_idx[start]
		end

		local v = self._idx_by_elem[prev]
		assert(v, "Illegal alteration during traversal")
		local i = v + inc
		return self._elem_by_idx[i]
	end
end

function uq:right_to_left()
	return traverser(self, self._top_is_right), self, nil
end

function uq:left_to_right()
	return traverser(self, not self._top_is_right), self, nil
end

function uq:len()
	return self._len
end

function uq:contains(elem)
	return self._idx_by_elem[elem] ~= nil
end

uq.pop_right = uq.pop
uq.push_right = uq.push
uq.peek_right = uq.peek

return uq
