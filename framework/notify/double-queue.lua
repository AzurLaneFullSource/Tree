local var0_0 = setmetatable
local var1_0 = {}
local var2_0 = {}
local var3_0 = {
	__index = var2_0
}

function var1_0.New()
	return var0_0({
		first = 1,
		last = 0,
		data = {},
		data_position = {}
	}, var3_0)
end

local function var4_0(arg0_2)
	while arg0_2.first <= arg0_2.last do
		if arg0_2.data[arg0_2.first] then
			return true
		end

		arg0_2.first = arg0_2.first + 1
	end
end

function var2_0.is_empty(arg0_3)
	return arg0_3.first > arg0_3.last
end

function var2_0.push_front(arg0_4, arg1_4)
	if arg0_4.data_position[arg1_4] then
		return
	end

	arg0_4.first = arg0_4.first - 1
	arg0_4.data[arg0_4.first] = arg1_4
	arg0_4.data_position[arg1_4] = arg0_4.first
end

function var2_0.push_back(arg0_5, arg1_5)
	if arg0_5.data_position[arg1_5] then
		return
	end

	arg0_5.last = arg0_5.last + 1
	arg0_5.data[arg0_5.last] = arg1_5
	arg0_5.data_position[arg1_5] = arg0_5.last
end

function var2_0.get_iterator(arg0_6)
	local var0_6 = arg0_6.first

	return function()
		while var0_6 <= arg0_6.last do
			local var0_7 = arg0_6.data[var0_6]

			var0_6 = var0_6 + 1

			if var0_7 then
				return var0_7
			end
		end
	end
end

function var2_0.remove(arg0_8, arg1_8)
	if not arg0_8.data_position[arg1_8] then
		return
	end

	arg0_8.data[arg0_8.data_position[arg1_8]] = nil
	arg0_8.data_position[arg1_8] = nil

	var4_0(arg0_8)
end

return var1_0
