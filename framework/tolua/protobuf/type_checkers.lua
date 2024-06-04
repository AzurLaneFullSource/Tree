local var0 = type
local var1 = error
local var2 = string

module("protobuf.type_checkers")

function TypeChecker(arg0)
	local var0 = arg0

	return function(arg0)
		local var0 = var0(arg0)

		if var0[var0(arg0)] == nil then
			var1(var2.format("%s has type %s, but expected one of: %s", arg0, var0(arg0), var0))
		end
	end
end

function Int32ValueChecker()
	local var0 = -2147483648
	local var1 = 2147483647

	return function(arg0)
		if var0(arg0) ~= "number" then
			var1(var2.format("%s has type %s, but expected one of: number", arg0, var0(arg0)))
		end

		if arg0 < var0 or arg0 > var1 then
			var1("Value out of range: " .. arg0)
		end
	end
end

function Uint32ValueChecker(arg0)
	local var0 = 0
	local var1 = 4294967295

	return function(arg0)
		if var0(arg0) ~= "number" then
			var1(var2.format("%s has type %s, but expected one of: number", arg0, var0(arg0)))
		end

		if arg0 < var0 or arg0 > var1 then
			var1("Value out of range: " .. arg0)
		end
	end
end

function UnicodeValueChecker()
	return function(arg0)
		if var0(arg0) ~= "string" then
			var1(var2.format("%s has type %s, but expected one of: string", arg0, var0(arg0)))
		end
	end
end
