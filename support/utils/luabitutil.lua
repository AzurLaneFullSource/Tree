local var0_0 = {
	[0] = "0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G"
}

local function var1_0(arg0_1)
	for iter0_1, iter1_1 in pairs(var0_0) do
		if iter1_1 == arg0_1 then
			return iter0_1
		end
	end

	return 0
end

local function var2_0(arg0_2, arg1_2)
	local function var0_2(arg0_3, arg1_3)
		if arg0_3 < arg1_2 then
			table.insert(arg1_3, arg0_3)
		else
			var0_2(math.floor(arg0_3 / arg1_2), arg1_3)
			table.insert(arg1_3, arg0_3 % arg1_2)
		end
	end

	local var1_2 = {}

	var0_2(arg0_2, var1_2)

	return var1_2
end

function ConvertDec2X(arg0_4, arg1_4)
	local var0_4 = var2_0(arg0_4, arg1_4)
	local var1_4 = ""

	for iter0_4, iter1_4 in ipairs(var0_4) do
		var1_4 = var1_4 .. var0_0[iter1_4]
	end

	return var1_4
end

function ConvertStr2Dec(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = string.len(arg0_5)

	while var1_5 > 0 do
		local var2_5 = string.sub(arg0_5, var1_5, var1_5)

		var0_5[#var0_5 + 1] = var1_0(var2_5)
		var1_5 = var1_5 - 1
	end

	local var3_5 = 0

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var3_5 = var3_5 + iter1_5 * math.pow(arg1_5, iter0_5 - 1)
	end

	return var3_5
end
