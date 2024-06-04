local var0 = debug.getinfo
local var1 = error
local var2 = rawset
local var3 = rawget
local var4 = getmetatable(_G)

if var4 == nil then
	var4 = {}

	setmetatable(_G, var4)
end

var4.__declared = {}

function var4.__newindex(arg0, arg1, arg2)
	if not var4.__declared[arg1] then
		local var0 = var0(2, "S")

		if var0 and var0.linedefined > 0 then
			var1("assign to undeclared variable '" .. arg1 .. "'", 2)
		end

		var4.__declared[arg1] = true
	end

	var2(arg0, arg1, arg2)
end

function var4.__index(arg0, arg1)
	if not var4.__declared[arg1] then
		local var0 = var0(2, "S")

		if var0 and var0.linedefined > 0 then
			var1("variable '" .. arg1 .. "' is not declared", 2)
		end
	end

	return var3(arg0, arg1)
end
