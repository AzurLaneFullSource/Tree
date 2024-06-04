local var0 = {
	p = pg.gameset.air_dominance_p.key_value,
	q = pg.gameset.air_dominance_q.key_value,
	s = pg.gameset.air_dominance_s.key_value,
	t = pg.gameset.air_dominance_t.key_value,
	r = pg.gameset.air_dominance_r.key_value,
	a = pg.gameset.air_dominance_a.key_value,
	x = pg.gameset.air_dominance_x.key_value,
	y = pg.gameset.air_dominance_y.key_value
}

function calcAirDominanceValue(arg0, arg1)
	local var0 = arg0:getAircraftCount()
	local var1 = arg0:getEquipmentProperties()

	return defaultValue(arg0:getProperties(arg1)[AttributeType.Air], 0) * (defaultValue(var0[EquipType.FighterAircraft], 0) * var0.p + defaultValue(var0[EquipType.TorpedoAircraft], 0) * var0.q + defaultValue(var0[EquipType.BomberAircraft], 0) * var0.s + defaultValue(var0[EquipType.SeaPlane], 0) * var0.t) * (0.8 + arg0.level * var0.r / 100) / 100 + defaultValue(var1[AttributeType.AirDominate], 0)
end

function calcAirDominanceStatus(arg0, arg1, arg2)
	arg1 = arg1 * (var0.a / (arg2 + var0.a))

	if arg0 == 0 then
		if arg1 <= var0.x then
			return 0
		elseif arg1 <= var0.y then
			return 2
		else
			return 1
		end
	elseif arg0 <= var0.x then
		if arg1 == 0 then
			return 0
		elseif arg1 <= var0.x then
			return 0
		elseif arg1 <= var0.y then
			if arg0 <= arg1 * 0.75 then
				return 2
			elseif arg0 <= arg1 * 1.3 then
				return 3
			else
				return 4
			end
		elseif arg0 <= arg1 * 0.5 then
			return 1
		elseif arg0 <= arg1 * 0.75 then
			return 2
		elseif arg0 <= arg1 * 1.3 then
			return 3
		else
			return 4
		end
	elseif arg0 <= var0.y then
		if arg1 == 0 then
			return 4
		elseif arg1 <= var0.y then
			if arg0 <= arg1 * 0.75 then
				return 2
			elseif arg0 <= arg1 * 1.3 then
				return 3
			else
				return 4
			end
		elseif arg0 <= arg1 * 0.5 then
			return 1
		elseif arg0 <= arg1 * 0.75 then
			return 2
		elseif arg0 <= arg1 * 1.3 then
			return 3
		else
			return 4
		end
	elseif arg1 == 0 then
		return 5
	elseif arg0 <= arg1 * 0.5 then
		return 1
	elseif arg0 <= arg1 * 0.75 then
		return 2
	elseif arg0 <= arg1 * 1.3 then
		return 3
	elseif arg0 <= arg1 * 2 then
		return 4
	else
		return 5
	end
end

function calcPositionAngle(arg0, arg1)
	local var0 = Vector3(arg0, arg1, 0)
	local var1 = Vector3.up
	local var2 = Vector2.Angle(var0, var1)

	return Vector3.Cross(var0, var1).z > 0 and var2 or -var2
end

function DOAParabolaCalc(arg0, arg1, arg2)
	assert(arg2 < arg1 * arg1 * arg0 / 2, "x is unreal")

	local var0 = arg0 * math.sqrt(arg1 / 2)
	local var1 = 0
	local var2 = var0 * var0
	local var3

	while var2 - var1 > 0.01 do
		local var4 = (var1 + var2) / 2

		if var0 > math.sqrt(var4) + math.sqrt(var4 + arg2) then
			var1 = var4
		else
			var2 = var4
		end
	end

	return var1
end

function mergeSort(arg0, arg1)
	arg1 = arg1 or function(arg0, arg1)
		return arg0 <= arg1
	end

	local var0 = {}

	local function var1(arg0, arg1)
		if arg1 <= arg0 then
			return
		end

		local var0 = math.floor((arg0 + arg1) / 2)

		var1(arg0, var0)
		var1(var0 + 1, arg1)

		local var1 = arg0
		local var2 = var0 + 1

		while var1 <= var0 and var2 <= arg1 do
			if arg1(arg0[var1], arg0[var2]) then
				var0[var1 + var2 - var0 - 1] = arg0[var1]
				var1 = var1 + 1
			else
				var0[var1 + var2 - var0 - 1] = arg0[var2]
				var2 = var2 + 1
			end
		end

		while var1 <= var0 do
			var0[var1 + var2 - var0 - 1] = arg0[var1]
			var1 = var1 + 1
		end

		while var2 <= arg1 do
			var0[var1 + var2 - var0 - 1] = arg0[var2]
			var2 = var2 + 1
		end

		for iter0 = arg0, arg1 do
			arg0[iter0] = var0[iter0]
		end
	end

	var1(1, #arg0)
end

function LineLine(arg0, arg1, arg2, arg3)
	local var0 = false
	local var1
	local var2
	local var3 = (arg3.y - arg2.y) * (arg1.x - arg0.x) - (arg3.x - arg2.x) * (arg1.y - arg0.y)

	if var3 ~= 0 then
		var1 = ((arg3.x - arg2.x) * (arg0.y - arg2.y) - (arg3.y - arg2.y) * (arg0.x - arg2.x)) / var3
		var2 = ((arg1.x - arg0.x) * (arg0.y - arg2.y) - (arg1.y - arg0.y) * (arg0.x - arg2.x)) / var3

		if var1 >= 0 and var1 <= 1 and var2 >= 0 and var2 <= 1 then
			var0 = true
		end
	end

	return var0, var1, var2
end

function ConversionBase(arg0, arg1)
	local var0 = {
		0
	}
	local var1 = 0

	while arg1 > 0 do
		var1 = var1 + 1
		var0[var1] = arg1 % arg0

		if var0[var1] < 10 then
			var0[var1] = string.format("%c", var0[var1] + 48)
		else
			var0[var1] = string.format("%c", var0[var1] + 55)
		end

		arg1 = math.floor(arg1 / arg0)
	end

	for iter0 = 1, math.floor(#var0 / 2) do
		var0[iter0], var0[#var0 - iter0 + 1] = var0[#var0 - iter0 + 1], var0[iter0]
	end

	return table.concat(var0)
end

base64 = {}

local var1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function base64.enc(arg0)
	return (arg0:gsub(".", function(arg0)
		local var0 = ""
		local var1 = arg0:byte()

		for iter0 = 8, 1, -1 do
			var0 = var0 .. (var1 % 2^iter0 - var1 % 2^(iter0 - 1) > 0 and "1" or "0")
		end

		return var0
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(arg0)
		if #arg0 < 6 then
			return ""
		end

		local var0 = 0

		for iter0 = 1, 6 do
			var0 = var0 + (arg0:sub(iter0, iter0) == "1" and 2^(6 - iter0) or 0)
		end

		return var1:sub(var0 + 1, var0 + 1)
	end) .. ({
		"",
		"==",
		"="
	})[#arg0 % 3 + 1]
end

function base64.dec(arg0)
	arg0 = string.gsub(arg0, "[^" .. var1 .. "=]", "")

	return (arg0:gsub(".", function(arg0)
		if arg0 == "=" then
			return ""
		end

		local var0 = ""
		local var1 = var1:find(arg0) - 1

		for iter0 = 6, 1, -1 do
			var0 = var0 .. (var1 % 2^iter0 - var1 % 2^(iter0 - 1) > 0 and "1" or "0")
		end

		return var0
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(arg0)
		if #arg0 ~= 8 then
			return ""
		end

		local var0 = 0

		for iter0 = 1, 8 do
			var0 = var0 + (arg0:sub(iter0, iter0) == "1" and 2^(8 - iter0) or 0)
		end

		return string.char(var0)
	end))
end
