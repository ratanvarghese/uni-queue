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
	if self.idx_by_elem[new_elem] ~= nil then
		return false
	end

	if on_top then
		if self._len > 0 then
			self.top = self.top + 1
		end
		self.elem_by_idx[self.top] = new_elem
	else
		if self._len > 0 then
			self.bot = self.bot - 1
		end
		self.elem_by_idx[self.bot] = new_elem
	end
	self._len = self._len + 1
	return true
end

function uq:push(new_elem)
	return push_common(self, new_elem, self.top_is_right)
end

function uq:push_left(new_elem)
	return push_common(self, new_elem, not self.top_is_right)
end

function uq:clear()
	local ft, rt = otom.new()
	self.top = 0
	self.bot = 0
	self._len = 0
	self.elem_by_idx = ft
	self.idx_by_elem = rt
	self.top_is_right = true
end

local function pop_common(self, on_top)
	if self._len == 0 then
		return nil
	end

	local idx = 0
	if on_top then
		idx = self.top
		self.top = self.top - 1
	else
		idx = self.bot
		self.bot = self.bot + 1
	end
	local res = self.elem_by_idx[idx]
	self.elem_by_idx[idx] = nil
	self._len = self._len - 1
	return res
end

function uq:pop()
	return pop_common(self, self.top_is_right)
end

function uq:pop_left()
	return pop_common(self, not self.top_is_right)
end

function uq:remove(targ_item)
	local targ_idx = self.idx_by_elem[targ_item]
	if not targ_idx then
		return
	end
	for i = targ_idx,self.top do
		self.elem_by_idx[i] = self.elem_by_idx[i+1]
	end
	self._len = self._len - 1
	self.top = self.top - 1
end

function uq:reverse()
	self.top_is_right = not self.top_is_right
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
		start = self.top
		inc = -1
	else
		start = self.bot
		inc = 1
	end

	return function(self, prev)
		local idx = start
		if prev ~= nil then
			idx = self.idx_by_elem[prev] + inc
		end
		return self.elem_by_idx[idx]
	end
end

function uq:right_to_left()
	return traverser(self, self.top_is_right), self, nil
end

function uq:left_to_right()
	return traverser(self, not self.top_is_right), self, nil
end

function uq:len()
	return self._len
end

function uq:contains(elem)
	return self.idx_by_elem[elem] ~= nil
end

uq.pop_right = uq.pop
uq.push_right = uq.push

return uq
