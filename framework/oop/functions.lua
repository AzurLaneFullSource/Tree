function printf(arg0, ...)
	print(string.format(tostring(arg0), ...))
end

function AssureTable(arg0)
	if type(arg0) ~= "table" then
		arg0 = {}
	end

	return arg0
end

function checknumber(arg0, arg1)
	return tonumber(arg0, arg1) or 0
end

function math.round(arg0)
	arg0 = checknumber(arg0)

	return math.floor(arg0 + 0.5)
end

function checkint(arg0)
	return math.round(checknumber(arg0))
end

function handler(arg0, arg1)
	return function(...)
		return arg1(arg0, ...)
	end
end

function handlerArg1(arg0, arg1, arg2)
	return function(...)
		return arg1(arg0, arg2, ...)
	end
end

local var0 = print
local var1 = table.concat
local var2 = table.insert
local var3 = string.rep
local var4 = type
local var5 = pairs
local var6 = tostring
local var7 = next

function print_r(arg0)
	local var0 = {
		[arg0] = "."
	}

	local function var1(arg0, arg1, arg2)
		local var0 = {}

		for iter0, iter1 in var5(arg0) do
			local var1 = var6(iter0)

			if var0[iter1] then
				var2(var0, "+" .. var1 .. " {" .. var0[iter1] .. "}")
			elseif var4(iter1) == "table" then
				local var2 = arg2 .. "." .. var1

				var0[iter1] = var2

				var2(var0, "+" .. var1 .. var1(iter1, arg1 .. (var7(arg0, iter0) and "|" or " ") .. var3(" ", #var1), var2))
			else
				var2(var0, "+" .. var1 .. " [" .. var6(iter1) .. "]")
			end
		end

		return var1(var0, "\n" .. arg1)
	end

	var0(var1(arg0, "", ""))
end
