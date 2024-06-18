local var0_0 = type
local var1_0 = {}
local var2_0 = tolua.typeof
local var3_0 = tolua.findtype

function typeof(arg0_1)
	local var0_1 = var0_0(arg0_1)
	local var1_1

	if var0_1 == "table" then
		var1_1 = var1_0[arg0_1]

		if var1_1 == nil then
			var1_1 = var2_0(arg0_1)
			var1_0[arg0_1] = var1_1
		end
	elseif var0_1 == "string" then
		var1_1 = var1_0[arg0_1]

		if var1_1 == nil then
			var1_1 = var3_0(arg0_1)
			var1_0[arg0_1] = var1_1
		end
	else
		error(debug.traceback("attemp to call typeof on type " .. var0_1))
	end

	return var1_1
end
