function printf(arg0_1, ...)
	print(string.format(tostring(arg0_1), ...))
end

function AssureTable(arg0_2)
	if type(arg0_2) ~= "table" then
		arg0_2 = {}
	end

	return arg0_2
end

function checknumber(arg0_3, arg1_3)
	return tonumber(arg0_3, arg1_3) or 0
end

function math.round(arg0_4)
	arg0_4 = checknumber(arg0_4)

	return math.floor(arg0_4 + 0.5)
end

function checkint(arg0_5)
	return math.round(checknumber(arg0_5))
end

function handler(arg0_6, arg1_6)
	return function(...)
		return arg1_6(arg0_6, ...)
	end
end

function handlerArg1(arg0_8, arg1_8, arg2_8)
	return function(...)
		return arg1_8(arg0_8, arg2_8, ...)
	end
end

local var0_0 = print
local var1_0 = table.concat
local var2_0 = table.insert
local var3_0 = string.rep
local var4_0 = type
local var5_0 = pairs
local var6_0 = tostring
local var7_0 = next

function print_r(arg0_10)
	local var0_10 = {
		[arg0_10] = "."
	}

	local function var1_10(arg0_11, arg1_11, arg2_11)
		local var0_11 = {}

		for iter0_11, iter1_11 in var5_0(arg0_11) do
			local var1_11 = var6_0(iter0_11)

			if var0_10[iter1_11] then
				var2_0(var0_11, "+" .. var1_11 .. " {" .. var0_10[iter1_11] .. "}")
			elseif var4_0(iter1_11) == "table" then
				local var2_11 = arg2_11 .. "." .. var1_11

				var0_10[iter1_11] = var2_11

				var2_0(var0_11, "+" .. var1_11 .. var1_10(iter1_11, arg1_11 .. (var7_0(arg0_11, iter0_11) and "|" or " ") .. var3_0(" ", #var1_11), var2_11))
			else
				var2_0(var0_11, "+" .. var1_11 .. " [" .. var6_0(iter1_11) .. "]")
			end
		end

		return var1_0(var0_11, "\n" .. arg1_11)
	end

	var0_0(var1_10(arg0_10, "", ""))
end
