local var0 = type
local var1 = {}
local var2 = tolua.typeof
local var3 = tolua.findtype

function typeof(arg0)
	local var0 = var0(arg0)
	local var1

	if var0 == "table" then
		var1 = var1[arg0]

		if var1 == nil then
			var1 = var2(arg0)
			var1[arg0] = var1
		end
	elseif var0 == "string" then
		var1 = var1[arg0]

		if var1 == nil then
			var1 = var3(arg0)
			var1[arg0] = var1
		end
	else
		error(debug.traceback("attemp to call typeof on type " .. var0))
	end

	return var1
end
