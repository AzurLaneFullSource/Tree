local var0 = {
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

local function var1(arg0)
	for iter0, iter1 in pairs(var0) do
		if iter1 == arg0 then
			return iter0
		end
	end

	return 0
end

local function var2(arg0, arg1)
	local function var0(arg0, arg1)
		if arg0 < arg1 then
			table.insert(arg1, arg0)
		else
			var0(math.floor(arg0 / arg1), arg1)
			table.insert(arg1, arg0 % arg1)
		end
	end

	local var1 = {}

	var0(arg0, var1)

	return var1
end

function ConvertDec2X(arg0, arg1)
	local var0 = var2(arg0, arg1)
	local var1 = ""

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 .. var0[iter1]
	end

	return var1
end

function ConvertStr2Dec(arg0, arg1)
	local var0 = {}
	local var1 = string.len(arg0)

	while var1 > 0 do
		local var2 = string.sub(arg0, var1, var1)

		var0[#var0 + 1] = var1(var2)
		var1 = var1 - 1
	end

	local var3 = 0

	for iter0, iter1 in ipairs(var0) do
		var3 = var3 + iter1 * math.pow(arg1, iter0 - 1)
	end

	return var3
end
