local var0_0 = type
local var1_0 = error
local var2_0 = string

module("type_checkers")

function TypeChecker(arg0_1)
	local var0_1 = arg0_1

	return function(arg0_2)
		local var0_2 = var0_0(arg0_2)

		if var0_1[var0_0(arg0_2)] == nil then
			var1_0(var2_0.format("%s has type %s, but expected one of: %s", arg0_2, var0_0(arg0_2), var0_1))
		end
	end
end

function Int32ValueChecker()
	local var0_3 = -2147483648
	local var1_3 = 2147483647

	return function(arg0_4)
		if var0_0(arg0_4) ~= "number" then
			var1_0(var2_0.format("%s has type %s, but expected one of: number", arg0_4, var0_0(arg0_4)))
		end

		if arg0_4 < var0_3 or arg0_4 > var1_3 then
			var1_0("Value out of range: " .. arg0_4)
		end
	end
end

function Uint32ValueChecker(arg0_5)
	local var0_5 = 0
	local var1_5 = 4294967295

	return function(arg0_6)
		if var0_0(arg0_6) ~= "number" then
			var1_0(var2_0.format("%s has type %s, but expected one of: number", arg0_6, var0_0(arg0_6)))
		end

		if arg0_6 < var0_5 or arg0_6 > var1_5 then
			var1_0("Value out of range: " .. arg0_6)
		end
	end
end

function UnicodeValueChecker()
	return function(arg0_8)
		if var0_0(arg0_8) ~= "string" then
			var1_0(var2_0.format("%s has type %s, but expected one of: string", arg0_8, var0_0(arg0_8)))
		end
	end
end
