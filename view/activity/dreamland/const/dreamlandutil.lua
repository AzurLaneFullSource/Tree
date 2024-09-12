local var0_0 = class("DreamlandUtil")

function var0_0.TrPosition2LocalPos(arg0_1, arg1_1, arg2_1)
	if arg0_1 == arg1_1 then
		return arg2_1
	else
		local var0_1 = arg0_1:TransformPoint(arg2_1)
		local var1_1 = arg1_1:InverseTransformPoint(var0_1)

		return Vector3(var1_1.x, var1_1.y, 0)
	end
end

function var0_0.GetRect(arg0_2, arg1_2, arg2_2)
	local var0_2 = Vector2(arg0_2.x - arg1_2 * 0.5, arg0_2.y + arg2_2 * 0.5)
	local var1_2 = Vector2(arg0_2.x + arg1_2 * 0.5, arg0_2.y + arg2_2 * 0.5)
	local var2_2 = Vector2(arg0_2.x - arg1_2 * 0.5, arg0_2.y - arg2_2 * 0.5)
	local var3_2 = Vector2(arg0_2.x + arg1_2 * 0.5, arg0_2.y - arg2_2 * 0.5)

	return {
		xMin = var0_2.x,
		xMax = var1_2.x,
		yMin = var0_2.y,
		yMax = var2_2.y
	}
end

function var0_0.CalcFocusPosition(arg0_3, arg1_3, arg2_3)
	local var0_3 = var0_0.TrPosition2LocalPos(arg0_3, arg1_3, arg2_3)
	local var1_3 = var0_0.GetRect(var0_3, arg1_3.rect.width, arg1_3.rect.height)
	local var2_3 = var0_0.GetRect(arg0_3.localPosition, arg0_3.rect.width, arg0_3.rect.height)
	local var3_3 = 0
	local var4_3 = 0

	if var1_3.xMin < var2_3.xMin then
		var3_3 = var1_3.xMin - var2_3.xMin
	elseif var1_3.xMax > var2_3.xMax then
		var3_3 = var1_3.xMax - var2_3.xMax
	end

	if var1_3.yMin > var2_3.yMin then
		var4_3 = var1_3.yMin - var2_3.yMin
	elseif var1_3.yMax < var2_3.yMax then
		var4_3 = var1_3.yMax - var2_3.yMax
	end

	return (var0_3 - arg0_3.localPosition - Vector3(var3_3, var4_3, 0)) * -1
end

function var0_0.GetSpineNormalAction(arg0_4)
	if arg0_4 == DreamlandData.EXPLORE_SUBTYPE_4RAN_NORMAL then
		local var0_4 = {
			"normal1",
			"normal2",
			"normal3",
			"normal4"
		}

		return var0_4[math.random(1, #var0_4)]
	else
		return "normal"
	end
end

function var0_0.GetSpineInterAction(arg0_5)
	local var0_5 = {
		"action1",
		"action2",
		"action3"
	}

	if arg0_5 == DreamlandData.EXPLORE_SUBTYPE_3RAN_ACTION then
		return var0_5[math.random(1, 3)]
	elseif arg0_5 == DreamlandData.EXPLORE_SUBTYPE_2RAN_ACTION then
		return var0_5[math.random(1, 2)]
	else
		return "action"
	end
end

function var0_0.List2Map(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6) do
		var0_6[iter1_6[arg1_6]] = iter1_6
	end

	return var0_6
end

return var0_0
