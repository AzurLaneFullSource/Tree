local var0_0 = {
	p = pg.gameset.air_dominance_p.key_value,
	q = pg.gameset.air_dominance_q.key_value,
	s = pg.gameset.air_dominance_s.key_value,
	t = pg.gameset.air_dominance_t.key_value,
	r = pg.gameset.air_dominance_r.key_value,
	a = pg.gameset.air_dominance_a.key_value,
	x = pg.gameset.air_dominance_x.key_value,
	y = pg.gameset.air_dominance_y.key_value
}

function calcAirDominanceValue(arg0_1, arg1_1)
	local var0_1 = arg0_1:getAircraftCount()
	local var1_1 = arg0_1:getEquipmentProperties()

	return defaultValue(arg0_1:getProperties(arg1_1)[AttributeType.Air], 0) * (defaultValue(var0_1[EquipType.FighterAircraft], 0) * var0_0.p + defaultValue(var0_1[EquipType.TorpedoAircraft], 0) * var0_0.q + defaultValue(var0_1[EquipType.BomberAircraft], 0) * var0_0.s + defaultValue(var0_1[EquipType.SeaPlane], 0) * var0_0.t) * (0.8 + arg0_1.level * var0_0.r / 100) / 100 + defaultValue(var1_1[AttributeType.AirDominate], 0)
end

function calcAirDominanceStatus(arg0_2, arg1_2, arg2_2)
	arg1_2 = arg1_2 * (var0_0.a / (arg2_2 + var0_0.a))

	if arg0_2 == 0 then
		if arg1_2 <= var0_0.x then
			return 0
		elseif arg1_2 <= var0_0.y then
			return 2
		else
			return 1
		end
	elseif arg0_2 <= var0_0.x then
		if arg1_2 == 0 then
			return 0
		elseif arg1_2 <= var0_0.x then
			return 0
		elseif arg1_2 <= var0_0.y then
			if arg0_2 <= arg1_2 * 0.75 then
				return 2
			elseif arg0_2 <= arg1_2 * 1.3 then
				return 3
			else
				return 4
			end
		elseif arg0_2 <= arg1_2 * 0.5 then
			return 1
		elseif arg0_2 <= arg1_2 * 0.75 then
			return 2
		elseif arg0_2 <= arg1_2 * 1.3 then
			return 3
		else
			return 4
		end
	elseif arg0_2 <= var0_0.y then
		if arg1_2 == 0 then
			return 4
		elseif arg1_2 <= var0_0.y then
			if arg0_2 <= arg1_2 * 0.75 then
				return 2
			elseif arg0_2 <= arg1_2 * 1.3 then
				return 3
			else
				return 4
			end
		elseif arg0_2 <= arg1_2 * 0.5 then
			return 1
		elseif arg0_2 <= arg1_2 * 0.75 then
			return 2
		elseif arg0_2 <= arg1_2 * 1.3 then
			return 3
		else
			return 4
		end
	elseif arg1_2 == 0 then
		return 5
	elseif arg0_2 <= arg1_2 * 0.5 then
		return 1
	elseif arg0_2 <= arg1_2 * 0.75 then
		return 2
	elseif arg0_2 <= arg1_2 * 1.3 then
		return 3
	elseif arg0_2 <= arg1_2 * 2 then
		return 4
	else
		return 5
	end
end

function calcPositionAngle(arg0_3, arg1_3)
	local var0_3 = Vector3(arg0_3, arg1_3, 0)
	local var1_3 = Vector3.up
	local var2_3 = Vector2.Angle(var0_3, var1_3)

	return Vector3.Cross(var0_3, var1_3).z > 0 and var2_3 or -var2_3
end

function DOAParabolaCalc(arg0_4, arg1_4, arg2_4)
	assert(arg2_4 < arg1_4 * arg1_4 * arg0_4 / 2, "x is unreal")

	local var0_4 = arg0_4 * math.sqrt(arg1_4 / 2)
	local var1_4 = 0
	local var2_4 = var0_4 * var0_4
	local var3_4

	while var2_4 - var1_4 > 0.01 do
		local var4_4 = (var1_4 + var2_4) / 2

		if var0_4 > math.sqrt(var4_4) + math.sqrt(var4_4 + arg2_4) then
			var1_4 = var4_4
		else
			var2_4 = var4_4
		end
	end

	return var1_4
end

function mergeSort(arg0_5, arg1_5)
	arg1_5 = arg1_5 or function(arg0_6, arg1_6)
		return arg0_6 <= arg1_6
	end

	local var0_5 = {}

	local function var1_5(arg0_7, arg1_7)
		if arg1_7 <= arg0_7 then
			return
		end

		local var0_7 = math.floor((arg0_7 + arg1_7) / 2)

		var1_5(arg0_7, var0_7)
		var1_5(var0_7 + 1, arg1_7)

		local var1_7 = arg0_7
		local var2_7 = var0_7 + 1

		while var1_7 <= var0_7 and var2_7 <= arg1_7 do
			if arg1_5(arg0_5[var1_7], arg0_5[var2_7]) then
				var0_5[var1_7 + var2_7 - var0_7 - 1] = arg0_5[var1_7]
				var1_7 = var1_7 + 1
			else
				var0_5[var1_7 + var2_7 - var0_7 - 1] = arg0_5[var2_7]
				var2_7 = var2_7 + 1
			end
		end

		while var1_7 <= var0_7 do
			var0_5[var1_7 + var2_7 - var0_7 - 1] = arg0_5[var1_7]
			var1_7 = var1_7 + 1
		end

		while var2_7 <= arg1_7 do
			var0_5[var1_7 + var2_7 - var0_7 - 1] = arg0_5[var2_7]
			var2_7 = var2_7 + 1
		end

		for iter0_7 = arg0_7, arg1_7 do
			arg0_5[iter0_7] = var0_5[iter0_7]
		end
	end

	var1_5(1, #arg0_5)
end

function LineLine(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = false
	local var1_8
	local var2_8
	local var3_8 = (arg3_8.y - arg2_8.y) * (arg1_8.x - arg0_8.x) - (arg3_8.x - arg2_8.x) * (arg1_8.y - arg0_8.y)

	if var3_8 ~= 0 then
		var1_8 = ((arg3_8.x - arg2_8.x) * (arg0_8.y - arg2_8.y) - (arg3_8.y - arg2_8.y) * (arg0_8.x - arg2_8.x)) / var3_8
		var2_8 = ((arg1_8.x - arg0_8.x) * (arg0_8.y - arg2_8.y) - (arg1_8.y - arg0_8.y) * (arg0_8.x - arg2_8.x)) / var3_8

		if var1_8 >= 0 and var1_8 <= 1 and var2_8 >= 0 and var2_8 <= 1 then
			var0_8 = true
		end
	end

	return var0_8, var1_8, var2_8
end

function ConversionBase(arg0_9, arg1_9)
	local var0_9 = {
		0
	}
	local var1_9 = 0

	while arg1_9 > 0 do
		var1_9 = var1_9 + 1
		var0_9[var1_9] = arg1_9 % arg0_9

		if var0_9[var1_9] < 10 then
			var0_9[var1_9] = string.format("%c", var0_9[var1_9] + 48)
		else
			var0_9[var1_9] = string.format("%c", var0_9[var1_9] + 55)
		end

		arg1_9 = math.floor(arg1_9 / arg0_9)
	end

	for iter0_9 = 1, math.floor(#var0_9 / 2) do
		var0_9[iter0_9], var0_9[#var0_9 - iter0_9 + 1] = var0_9[#var0_9 - iter0_9 + 1], var0_9[iter0_9]
	end

	return table.concat(var0_9)
end

base64 = {}

local var1_0 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64.enc(arg0_10)
	return (arg0_10:gsub(".", function(arg0_11)
		local var0_11 = ""
		local var1_11 = arg0_11:byte()

		for iter0_11 = 8, 1, -1 do
			var0_11 = var0_11 .. (var1_11 % 2^iter0_11 - var1_11 % 2^(iter0_11 - 1) > 0 and "1" or "0")
		end

		return var0_11
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(arg0_12)
		if #arg0_12 < 6 then
			return ""
		end

		local var0_12 = 0

		for iter0_12 = 1, 6 do
			var0_12 = var0_12 + (arg0_12:sub(iter0_12, iter0_12) == "1" and 2^(6 - iter0_12) or 0)
		end

		return var1_0:sub(var0_12 + 1, var0_12 + 1)
	end) .. ({
		"",
		"==",
		"="
	})[#arg0_10 % 3 + 1]
end

function base64.dec(arg0_13)
	arg0_13 = string.gsub(arg0_13, "[^" .. var1_0 .. "=]", "")

	return (arg0_13:gsub(".", function(arg0_14)
		if arg0_14 == "=" then
			return ""
		end

		local var0_14 = ""
		local var1_14 = var1_0:find(arg0_14) - 1

		for iter0_14 = 6, 1, -1 do
			var0_14 = var0_14 .. (var1_14 % 2^iter0_14 - var1_14 % 2^(iter0_14 - 1) > 0 and "1" or "0")
		end

		return var0_14
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(arg0_15)
		if #arg0_15 ~= 8 then
			return ""
		end

		local var0_15 = 0

		for iter0_15 = 1, 8 do
			var0_15 = var0_15 + (arg0_15:sub(iter0_15, iter0_15) == "1" and 2^(8 - iter0_15) or 0)
		end

		return string.char(var0_15)
	end))
end
