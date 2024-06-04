local var0 = class("OreGameHelper")

local function var1(arg0)
	local var0 = arg0.x * 90 + 90
	local var1 = arg0.y * 90 + 90
	local var2 = var0

	if var1 < 90 then
		if var0 <= 90 then
			var2 = 270 + var1
		elseif var0 > 90 then
			var2 = 180 + (90 - var1)
		end
	end

	return var2
end

local var2 = {
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
local var3 = {
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

local function var4(arg0)
	if arg0.x == 0 and arg0.y == 0 then
		return "STAND"
	end

	local var0 = var1(arg0)

	for iter0 = 1, 8 do
		if iter0 == 1 then
			if var0 >= 0 and var0 <= 22.5 or var0 >= 337.5 and var0 <= 360 then
				return var2[iter0]
			end
		else
			local var1 = 22.5 + (iter0 - 2) * 45

			if var1 < var0 and var0 <= var1 + 45 then
				return var2[iter0]
			end
		end
	end

	return "STAND"
end

function var0.GetEightDirVector(arg0)
	local var0 = var4(arg0)

	return var3[var0]
end

local var5 = {
	"W",
	"N",
	"E",
	"S"
}

function var0.GetFourDirLabel(arg0)
	if arg0.x == 0 and arg0.y == 0 then
		return "STAND"
	end

	local var0 = var1(arg0)

	for iter0 = 1, 4 do
		if iter0 == 1 then
			if var0 >= 0 and var0 <= 45 or var0 >= 315 and var0 <= 360 then
				return var5[iter0]
			end
		else
			local var1 = 45 + (iter0 - 2) * 90

			if var1 < var0 and var0 <= var1 + 90 then
				return var5[iter0]
			end
		end
	end

	return "STAND"
end

function var0.CheckRemovable(arg0)
	if arg0.x >= OreGameConfig.RANGE_X[1] and arg0.x <= OreGameConfig.RANGE_X[2] and arg0.y >= OreGameConfig.RANGE_Y[1] and arg0.y <= OreGameConfig.RANGE_Y[2] then
		if arg0.y >= OreGameConfig.BAN_Y[1] then
			return true
		elseif arg0.x >= OreGameConfig.BAN_Y[2][1] and arg0.x <= OreGameConfig.BAN_Y[2][2] then
			return true
		end
	end

	return false
end

function var0.GetBeziersPoints(arg0, arg1, arg2, arg3)
	local var0 = arg0:Clone():Mul((1 - arg3) * (1 - arg3))
	local var1 = arg2:Clone():Mul(2 * arg3 * (1 - arg3))
	local var2 = arg1:Clone():Mul(arg3 * arg3)

	return var0:Add(var1):Add(var2)
end

function var0.GetOreIDWithWeight(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0) do
		var0 = var0 + iter1[2]
	end

	local var1 = math.random() * var0
	local var2 = 0

	for iter2, iter3 in ipairs(arg0) do
		var2 = var2 + iter3[2]

		if var1 <= var2 then
			return iter3[1]
		end
	end
end

function var0.GetAABBWithTF(arg0, arg1)
	local var0 = arg0.rect.width
	local var1 = arg0.rect.height
	local var2 = arg0.anchoredPosition
	local var3 = {
		var2.x - var0 / 2,
		var2.y + var1 / 2
	}
	local var4 = {
		var2.x + var0 / 2,
		var2.y - var1 / 2
	}

	if arg1 then
		var3 = {
			var2.x + var0 / 2,
			var2.y + var1 / 2
		}
		var4 = {
			var2.x - var0 / 2,
			var2.y - var1 / 2
		}
	end

	return {
		var3,
		var4
	}
end

return var0
