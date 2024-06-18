pg = pg or {}

local var0_0 = pg

var0_0.Tool = class("Tool")

function var0_0.Tool.Seq(arg0_1)
	local var0_1 = {}

	for iter0_1 = 1, arg0_1 do
		var0_1[iter0_1] = iter0_1
	end

	return var0_1
end

function var0_0.Tool.Swap(arg0_2, arg1_2, arg2_2)
	arg0_2[arg2_2], arg0_2[arg1_2] = arg0_2[arg1_2], arg0_2[arg2_2]
end

function var0_0.Tool.RandomMN(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = var0_0.Tool.Seq(arg0_3)
	local var2_3 = #var1_3

	for iter0_3 = 1, arg1_3 do
		local var3_3 = math.random(var2_3)

		var0_3[iter0_3] = var1_3[var3_3]

		var0_0.Tool.Swap(var1_3, var3_3, var2_3)

		var2_3 = var2_3 - 1
	end

	return var0_3
end

function var0_0.Tool.FilterY(arg0_4)
	return Vector3(arg0_4.x, 0, arg0_4.z)
end

function var0_0.Tool.FilterZ(arg0_5)
	return Vector3(arg0_5.x, arg0_5.y, 0)
end

function var0_0.Tool.GetShortName(arg0_6, arg1_6, arg2_6)
	if arg0_6 == nil or arg1_6 == nil then
		return
	end

	local var0_6 = arg0_6
	local var1_6 = {}
	local var2_6 = {}
	local var3_6 = #var0_6
	local var4_6 = 0

	if arg2_6 == nil then
		arg2_6 = arg1_6 - 3
	end

	for iter0_6 = 1, var3_6 do
		local var5_6 = string.byte(var0_6, iter0_6)
		local var6_6 = 0

		if var5_6 > 0 and var5_6 <= 127 then
			var6_6 = 1
		elseif var5_6 >= 192 and var5_6 < 223 then
			var6_6 = 2
		elseif var5_6 >= 224 and var5_6 < 239 then
			var6_6 = 3
		elseif var5_6 >= 240 and var5_6 <= 247 then
			var6_6 = 4
		end

		local var7_6

		if var6_6 > 0 then
			var7_6 = string.sub(var0_6, iter0_6, iter0_6 + var6_6 - 1)
			iter0_6 = iter0_6 + var6_6 - 1
		end

		if var6_6 == 1 then
			var4_6 = var4_6 + 1

			table.insert(var2_6, var7_6)
			table.insert(var1_6, 1)
		elseif var6_6 > 1 then
			var4_6 = var4_6 + 2

			table.insert(var2_6, var7_6)
			table.insert(var1_6, 2)
		end
	end

	if arg1_6 < var4_6 then
		local var8_6 = ""
		local var9_6 = 0

		for iter1_6 = 1, #var2_6 do
			var8_6 = var8_6 .. var2_6[iter1_6]
			var9_6 = var9_6 + var1_6[iter1_6]

			if arg2_6 <= var9_6 then
				break
			end
		end

		arg0_6 = var8_6 .. "..."
	end

	return arg0_6
end

function var0_0.Tool.Distances(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7 / 180 * math.pi
	local var1_7 = arg2_7 / 180 * math.pi
	local var2_7 = arg1_7 / 180 * math.pi
	local var3_7 = arg3_7 / 180 * math.pi
	local var4_7 = var0_7 - var1_7
	local var5_7 = var2_7 - var3_7

	return 2 * math.asin(math.sqrt(math.pow(math.sin(var4_7 / 2), 2) + math.cos(var0_7) * math.cos(var1_7) * math.pow(math.sin(var5_7 / 2), 2))) * 6378.137
end
