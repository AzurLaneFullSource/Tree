local var0_0 = class("CrossRoadGameHelper")

function var0_0.IsRectCross(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1, arg7_1, arg8_1)
	return math.max(arg1_1, arg5_1) <= math.min(arg3_1, arg7_1) and math.max(arg2_1, arg6_1) <= math.min(arg4_1, arg8_1)
end

function var0_0.GetPosDis(arg0_2, arg1_2, arg2_2)
	return math.sqrt((arg1_2.x - arg2_2.x) * (arg1_2.x - arg2_2.x) + (arg1_2.y - arg2_2.y) * (arg1_2.y - arg2_2.y))
end

function var0_0.cross(arg0_3, arg1_3, arg2_3, arg3_3)
	return (arg2_3.x - arg1_3.x) * (arg3_3.y - arg1_3.y) - (arg3_3.x - arg1_3.x) * (arg2_3.y - arg1_3.y)
end

function var0_0.crossOp(arg0_4, arg1_4, arg2_4, arg3_4)
	return arg0_4:sign(arg0_4:cross(arg1_4, arg2_4, arg3_4))
end

function var0_0.OnSeg(arg0_5, arg1_5, arg2_5, arg3_5)
	return arg0_5:crossOp(arg1_5, arg3_5, arg2_5) == 0 and arg0_5:IsPointMiddle(arg1_5, arg2_5, arg3_5)
end

function var0_0.IsPointMiddle(arg0_6, arg1_6, arg2_6, arg3_6)
	return arg0_6:isMiddle(arg1_6.x, arg2_6.x, arg3_6.x) and arg0_6:isMiddle(arg1_6.y, arg2_6.y, arg3_6.y)
end

function var0_0.isMiddle(arg0_7, arg1_7, arg2_7, arg3_7)
	return arg0_7:sign(arg1_7 - arg2_7) == 0 or arg0_7:sign(arg3_7 - arg2_7) == 0 or arg1_7 < arg2_7 ~= (arg3_7 < arg2_7)
end

function var0_0.IsInPoint(arg0_8, arg1_8, arg2_8)
	return arg0_8:sign(arg1_8.x - arg2_8.x) == 0 and arg0_8:sign(arg1_8.y - arg2_8.y) == 0
end

function var0_0.sign(arg0_9, arg1_9)
	local var0_9 = CrossRoadGameConst.EPS

	return arg1_9 < -var0_9 and -1 or var0_9 < arg1_9 and 1 or 0
end

function var0_0.GetRandomList(arg0_10, arg1_10)
	local var0_10 = #arg1_10
	local var1_10 = {}

	for iter0_10 = 1, var0_10 do
		var1_10[iter0_10] = arg1_10[iter0_10]
	end

	for iter1_10 = var0_10, 2, -1 do
		local var2_10 = math.random(1, iter1_10)

		var1_10[iter1_10], var1_10[var2_10] = var1_10[var2_10], var1_10[iter1_10]
	end

	return var1_10
end

function var0_0.GetHalfPos(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11.x / 2 + arg2_11.x / 2
	local var1_11 = arg1_11.y / 2 + arg2_11.y / 2

	return Vector2.New(var0_11, var1_11)
end

function var0_0.GetThirdPos(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12.x + (arg2_12.x - arg1_12.x) / 3
	local var1_12 = arg1_12.y + (arg2_12.y - arg1_12.y) / 3

	return Vector2.New(var0_12, var1_12)
end

function var0_0.WeightCarRandom(arg0_13)
	local var0_13 = 0

	for iter0_13, iter1_13 in ipairs(pg.crossroad_ship.all) do
		var0_13 = var0_13 + pg.crossroad_ship[iter1_13].weight
	end

	local var1_13 = math.random(0, var0_13)

	if var1_13 == 0 then
		local var2_13 = pg.crossroad_ship.all[1]

		return pg.crossroad_ship[var2_13]
	end

	local var3_13 = 0

	for iter2_13, iter3_13 in ipairs(pg.crossroad_ship.all) do
		local var4_13 = pg.crossroad_ship[iter3_13]

		if var3_13 < var1_13 and var1_13 <= var3_13 + var4_13.weight then
			return pg.crossroad_ship[iter3_13]
		end

		var3_13 = var3_13 + var4_13.weight
	end

	warning("竟然有权重没有覆盖到的地方")
end

function var0_0.CheckTwoRoleIsCrash(arg0_14, arg1_14, arg2_14)
	local var0_14, var1_14, var2_14, var3_14 = arg1_14:GetRoleRectPoint()
	local var4_14, var5_14, var6_14, var7_14 = arg2_14:GetRoleRectPoint()

	return arg0_14:IsRectCross(var0_14, var1_14, var2_14, var3_14, var4_14, var5_14, var6_14, var7_14)
end

function var0_0.CheckRoleInItem(arg0_15, arg1_15, arg2_15)
	local var0_15, var1_15, var2_15, var3_15 = arg1_15:GetRoleRectPoint()
	local var4_15, var5_15 = arg0_15:GetPosByTf(arg2_15.go)

	return math.max(var0_15, var4_15) <= math.min(var2_15, var5_15)
end

function var0_0.CheckPlayerInItem(arg0_16, arg1_16, arg2_16)
	local var0_16, var1_16 = arg0_16:GetPosByTf(arg1_16)
	local var2_16, var3_16 = arg0_16:GetPosByTf(arg2_16)

	return math.max(var0_16, var2_16) <= math.min(var1_16, var3_16)
end

function var0_0.GetPosByTf(arg0_17, arg1_17)
	local var0_17 = arg1_17.anchoredPosition
	local var1_17 = arg1_17.rect
	local var2_17 = var0_17.x - var1_17.width / 2
	local var3_17 = var0_17.x + var1_17.width / 2

	return var2_17, var3_17
end

function var0_0.GetAddNum(arg0_18)
	if arg0_18 <= 0 then
		return ""
	end

	return CrossRoadGameHelper.GetAddNum(math.floor(arg0_18 / 10)) .. tostring(arg0_18 % 10) .. " "
end

function var0_0.CheckIsSPCar(arg0_19, arg1_19)
	return CrossRoadGameConst.SP_CAR_ID[arg1_19]
end

return var0_0
