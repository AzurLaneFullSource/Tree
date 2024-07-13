local var0_0 = require
local var1_0 = string
local var2_0 = table

int64.zero = int64.new(0, 0)
uint64.zero = uint64.new(0, 0)

function var1_0.split(arg0_1, arg1_1)
	arg0_1 = tostring(arg0_1)
	arg1_1 = tostring(arg1_1)

	if arg1_1 == "" then
		return false
	end

	local var0_1 = 0
	local var1_1 = {}

	for iter0_1, iter1_1 in function()
		return var1_0.find(arg0_1, arg1_1, var0_1, true)
	end do
		var2_0.insert(var1_1, var1_0.sub(arg0_1, var0_1, iter0_1 - 1))

		var0_1 = iter1_1 + 1
	end

	var2_0.insert(var1_1, var1_0.sub(arg0_1, var0_1))

	return var1_1
end

function import(arg0_3, arg1_3)
	local var0_3
	local var1_3 = arg0_3
	local var2_3 = 1

	while true do
		if var1_0.byte(arg0_3, var2_3) ~= 46 then
			var1_3 = var1_0.sub(arg0_3, var2_3)

			if var0_3 and #var0_3 > 0 then
				var1_3 = var2_0.concat(var0_3, ".") .. "." .. var1_3
			end

			break
		end

		var2_3 = var2_3 + 1

		if not var0_3 then
			if not arg1_3 then
				local var3_3, var4_3 = debug.getlocal(3, 1)

				arg1_3 = var4_3
			end

			var0_3 = var1_0.split(arg1_3, ".")
		end

		var2_0.remove(var0_3, #var0_3)
	end

	return var0_0(var1_3)
end

function reimport(arg0_4)
	local var0_4 = package

	var0_4.loaded[arg0_4] = nil
	var0_4.preload[arg0_4] = nil

	return var0_0(arg0_4)
end
