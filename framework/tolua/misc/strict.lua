local var0_0 = debug.getinfo
local var1_0 = error
local var2_0 = rawset
local var3_0 = rawget
local var4_0 = getmetatable(_G)

if var4_0 == nil then
	var4_0 = {}

	setmetatable(_G, var4_0)
end

var4_0.__declared = {}

function var4_0.__newindex(arg0_1, arg1_1, arg2_1)
	if not var4_0.__declared[arg1_1] then
		local var0_1 = var0_0(2, "S")

		if var0_1 and var0_1.linedefined > 0 then
			var1_0("assign to undeclared variable '" .. arg1_1 .. "'", 2)
		end

		var4_0.__declared[arg1_1] = true
	end

	var2_0(arg0_1, arg1_1, arg2_1)
end

function var4_0.__index(arg0_2, arg1_2)
	if not var4_0.__declared[arg1_2] then
		local var0_2 = var0_0(2, "S")

		if var0_2 and var0_2.linedefined > 0 then
			var1_0("variable '" .. arg1_2 .. "' is not declared", 2)
		end
	end

	return var3_0(arg0_2, arg1_2)
end
