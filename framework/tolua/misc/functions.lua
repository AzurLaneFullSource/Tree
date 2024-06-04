local var0 = require
local var1 = string
local var2 = table

int64.zero = int64.new(0, 0)
uint64.zero = uint64.new(0, 0)

function var1.split(arg0, arg1)
	arg0 = tostring(arg0)
	arg1 = tostring(arg1)

	if arg1 == "" then
		return false
	end

	local var0 = 0
	local var1 = {}

	for iter0, iter1 in function()
		return var1.find(arg0, arg1, var0, true)
	end do
		var2.insert(var1, var1.sub(arg0, var0, iter0 - 1))

		var0 = iter1 + 1
	end

	var2.insert(var1, var1.sub(arg0, var0))

	return var1
end

function import(arg0, arg1)
	local var0
	local var1 = arg0
	local var2 = 1

	while true do
		if var1.byte(arg0, var2) ~= 46 then
			var1 = var1.sub(arg0, var2)

			if var0 and #var0 > 0 then
				var1 = var2.concat(var0, ".") .. "." .. var1
			end

			break
		end

		var2 = var2 + 1

		if not var0 then
			if not arg1 then
				local var3, var4 = debug.getlocal(3, 1)

				arg1 = var4
			end

			var0 = var1.split(arg1, ".")
		end

		var2.remove(var0, #var0)
	end

	return var0(var1)
end

function reimport(arg0)
	local var0 = package

	var0.loaded[arg0] = nil
	var0.preload[arg0] = nil

	return var0(arg0)
end
