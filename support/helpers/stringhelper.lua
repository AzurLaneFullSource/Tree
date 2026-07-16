local var0_0 = {}

function var0_0.ForamtNumberK(arg0_1)
	arg0_1 = tonumber(arg0_1) or 0

	local var0_1 = arg0_1 < 0 and "-" or ""
	local var1_1 = math.abs(arg0_1)

	if var1_1 < 10000 then
		return var0_0.ForamtNumber(arg0_1)
	end

	local var2_1 = math.floor(var1_1 / 1000)
	local var3_1 = tostring(var2_1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

	return var0_1 .. var3_1 .. "K"
end

function var0_0.ForamtNumber(arg0_2)
	arg0_2 = tonumber(arg0_2) or 0

	local var0_2 = arg0_2 < 0 and "-" or ""
	local var1_2 = math.abs(arg0_2)

	if var1_2 < 1000 then
		return arg0_2
	end

	local var2_2 = tostring(var1_2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

	return var0_2 .. var2_2
end

return var0_0
