local var0 = setmetatable
local var1 = {}
local var2 = {}
local var3 = {
	__index = var2
}

function var1.New()
	return var0({
		first = 1,
		last = 0,
		data = {},
		data_position = {}
	}, var3)
end

local function var4(arg0)
	while arg0.first <= arg0.last do
		if arg0.data[arg0.first] then
			return true
		end

		arg0.first = arg0.first + 1
	end
end

function var2.is_empty(arg0)
	return arg0.first > arg0.last
end

function var2.push_front(arg0, arg1)
	if arg0.data_position[arg1] then
		return
	end

	arg0.first = arg0.first - 1
	arg0.data[arg0.first] = arg1
	arg0.data_position[arg1] = arg0.first
end

function var2.push_back(arg0, arg1)
	if arg0.data_position[arg1] then
		return
	end

	arg0.last = arg0.last + 1
	arg0.data[arg0.last] = arg1
	arg0.data_position[arg1] = arg0.last
end

function var2.get_iterator(arg0)
	local var0 = arg0.first

	return function()
		while var0 <= arg0.last do
			local var0 = arg0.data[var0]

			var0 = var0 + 1

			if var0 then
				return var0
			end
		end
	end
end

function var2.remove(arg0, arg1)
	if not arg0.data_position[arg1] then
		return
	end

	arg0.data[arg0.data_position[arg1]] = nil
	arg0.data_position[arg1] = nil

	var4(arg0)
end

return var1
