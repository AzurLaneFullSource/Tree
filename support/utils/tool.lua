pg = pg or {}

local var0 = pg

var0.Tool = class("Tool")

function var0.Tool.Seq(arg0)
	local var0 = {}

	for iter0 = 1, arg0 do
		var0[iter0] = iter0
	end

	return var0
end

function var0.Tool.Swap(arg0, arg1, arg2)
	arg0[arg2], arg0[arg1] = arg0[arg1], arg0[arg2]
end

function var0.Tool.RandomMN(arg0, arg1)
	local var0 = {}
	local var1 = var0.Tool.Seq(arg0)
	local var2 = #var1

	for iter0 = 1, arg1 do
		local var3 = math.random(var2)

		var0[iter0] = var1[var3]

		var0.Tool.Swap(var1, var3, var2)

		var2 = var2 - 1
	end

	return var0
end

function var0.Tool.FilterY(arg0)
	return Vector3(arg0.x, 0, arg0.z)
end

function var0.Tool.FilterZ(arg0)
	return Vector3(arg0.x, arg0.y, 0)
end

function var0.Tool.GetShortName(arg0, arg1, arg2)
	if arg0 == nil or arg1 == nil then
		return
	end

	local var0 = arg0
	local var1 = {}
	local var2 = {}
	local var3 = #var0
	local var4 = 0

	if arg2 == nil then
		arg2 = arg1 - 3
	end

	for iter0 = 1, var3 do
		local var5 = string.byte(var0, iter0)
		local var6 = 0

		if var5 > 0 and var5 <= 127 then
			var6 = 1
		elseif var5 >= 192 and var5 < 223 then
			var6 = 2
		elseif var5 >= 224 and var5 < 239 then
			var6 = 3
		elseif var5 >= 240 and var5 <= 247 then
			var6 = 4
		end

		local var7

		if var6 > 0 then
			var7 = string.sub(var0, iter0, iter0 + var6 - 1)
			iter0 = iter0 + var6 - 1
		end

		if var6 == 1 then
			var4 = var4 + 1

			table.insert(var2, var7)
			table.insert(var1, 1)
		elseif var6 > 1 then
			var4 = var4 + 2

			table.insert(var2, var7)
			table.insert(var1, 2)
		end
	end

	if arg1 < var4 then
		local var8 = ""
		local var9 = 0

		for iter1 = 1, #var2 do
			var8 = var8 .. var2[iter1]
			var9 = var9 + var1[iter1]

			if arg2 <= var9 then
				break
			end
		end

		arg0 = var8 .. "..."
	end

	return arg0
end

function var0.Tool.Distances(arg0, arg1, arg2, arg3)
	local var0 = arg0 / 180 * math.pi
	local var1 = arg2 / 180 * math.pi
	local var2 = arg1 / 180 * math.pi
	local var3 = arg3 / 180 * math.pi
	local var4 = var0 - var1
	local var5 = var2 - var3

	return 2 * math.asin(math.sqrt(math.pow(math.sin(var4 / 2), 2) + math.cos(var0) * math.cos(var1) * math.pow(math.sin(var5 / 2), 2))) * 6378.137
end
