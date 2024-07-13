local var0_0 = class("OreGameHelper")

local function var1_0(arg0_1)
	local var0_1 = arg0_1.x * 90 + 90
	local var1_1 = arg0_1.y * 90 + 90
	local var2_1 = var0_1

	if var1_1 < 90 then
		if var0_1 <= 90 then
			var2_1 = 270 + var1_1
		elseif var0_1 > 90 then
			var2_1 = 180 + (90 - var1_1)
		end
	end

	return var2_1
end

local var2_0 = {
	"W",
	"NW",
	"N",
	"NE",
	"E",
	"SE",
	"S",
	"SW",
	"STAND"
}
local var3_0 = {
	W = Vector2(-1, 0),
	NW = Vector2(-1, 1).normalized,
	N = Vector2(0, 1),
	NE = Vector2(1, 1).normalized,
	E = Vector2(1, 0),
	SE = Vector2(1, -1).normalized,
	S = Vector2(0, -1),
	SW = Vector2(-1, -1).normalized,
	STAND = Vector2(0, 0)
}

local function var4_0(arg0_2)
	if arg0_2.x == 0 and arg0_2.y == 0 then
		return "STAND"
	end

	local var0_2 = var1_0(arg0_2)

	for iter0_2 = 1, 8 do
		if iter0_2 == 1 then
			if var0_2 >= 0 and var0_2 <= 22.5 or var0_2 >= 337.5 and var0_2 <= 360 then
				return var2_0[iter0_2]
			end
		else
			local var1_2 = 22.5 + (iter0_2 - 2) * 45

			if var1_2 < var0_2 and var0_2 <= var1_2 + 45 then
				return var2_0[iter0_2]
			end
		end
	end

	return "STAND"
end

function var0_0.GetEightDirVector(arg0_3)
	local var0_3 = var4_0(arg0_3)

	return var3_0[var0_3]
end

local var5_0 = {
	"W",
	"N",
	"E",
	"S"
}

function var0_0.GetFourDirLabel(arg0_4)
	if arg0_4.x == 0 and arg0_4.y == 0 then
		return "STAND"
	end

	local var0_4 = var1_0(arg0_4)

	for iter0_4 = 1, 4 do
		if iter0_4 == 1 then
			if var0_4 >= 0 and var0_4 <= 45 or var0_4 >= 315 and var0_4 <= 360 then
				return var5_0[iter0_4]
			end
		else
			local var1_4 = 45 + (iter0_4 - 2) * 90

			if var1_4 < var0_4 and var0_4 <= var1_4 + 90 then
				return var5_0[iter0_4]
			end
		end
	end

	return "STAND"
end

function var0_0.CheckRemovable(arg0_5)
	if arg0_5.x >= OreGameConfig.RANGE_X[1] and arg0_5.x <= OreGameConfig.RANGE_X[2] and arg0_5.y >= OreGameConfig.RANGE_Y[1] and arg0_5.y <= OreGameConfig.RANGE_Y[2] then
		if arg0_5.y >= OreGameConfig.BAN_Y[1] then
			return true
		elseif arg0_5.x >= OreGameConfig.BAN_Y[2][1] and arg0_5.x <= OreGameConfig.BAN_Y[2][2] then
			return true
		end
	end

	return false
end

function var0_0.GetBeziersPoints(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg0_6:Clone():Mul((1 - arg3_6) * (1 - arg3_6))
	local var1_6 = arg2_6:Clone():Mul(2 * arg3_6 * (1 - arg3_6))
	local var2_6 = arg1_6:Clone():Mul(arg3_6 * arg3_6)

	return var0_6:Add(var1_6):Add(var2_6)
end

function var0_0.GetOreIDWithWeight(arg0_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7) do
		var0_7 = var0_7 + iter1_7[2]
	end

	local var1_7 = math.random() * var0_7
	local var2_7 = 0

	for iter2_7, iter3_7 in ipairs(arg0_7) do
		var2_7 = var2_7 + iter3_7[2]

		if var1_7 <= var2_7 then
			return iter3_7[1]
		end
	end
end

function var0_0.GetAABBWithTF(arg0_8, arg1_8)
	local var0_8 = arg0_8.rect.width
	local var1_8 = arg0_8.rect.height
	local var2_8 = arg0_8.anchoredPosition
	local var3_8 = {
		var2_8.x - var0_8 / 2,
		var2_8.y + var1_8 / 2
	}
	local var4_8 = {
		var2_8.x + var0_8 / 2,
		var2_8.y - var1_8 / 2
	}

	if arg1_8 then
		var3_8 = {
			var2_8.x + var0_8 / 2,
			var2_8.y + var1_8 / 2
		}
		var4_8 = {
			var2_8.x - var0_8 / 2,
			var2_8.y - var1_8 / 2
		}
	end

	return {
		var3_8,
		var4_8
	}
end

return var0_0
