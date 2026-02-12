local var0_0 = class("PacGameEnemyController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
end

function var0_0.Prepare(arg0_2)
	return
end

function var0_0.Start(arg0_3)
	arg0_3._player = arg0_3._runningData:GetPlayer()
	arg0_3._enemys = arg0_3._runningData:GetEnemys()
	arg0_3._gridDic = arg0_3._runningData:GetGridDic()
	arg0_3._rateTime = PacGameConst.difficult_time
end

function var0_0.Step(arg0_4, arg1_4)
	arg0_4._deltaTime = arg1_4

	local var0_4 = false

	if arg0_4._rateTime and arg0_4._rateTime > 0 then
		arg0_4._rateTime = arg0_4._rateTime - arg1_4

		if arg0_4._rateTime <= 0 then
			arg0_4._rateTime = PacGameConst.difficult_time
			var0_4 = true
		end
	end

	for iter0_4 = 1, #arg0_4._enemys do
		local var1_4 = arg0_4._enemys[iter0_4]

		arg0_4:setEnemyAutoData(var1_4, arg0_4._player)
		arg0_4:checkEnemyHit(var1_4, arg0_4._player)

		if var0_4 then
			var1_4:SetRateAdd()
		end
	end
end

function var0_0.Clear(arg0_5)
	return
end

function var0_0.Stop(arg0_6)
	return
end

function var0_0.Resume(arg0_7)
	return
end

function var0_0.Dispose(arg0_8)
	return
end

function var0_0.setEnemyAutoData(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:GetAutoState()

	if not var0_9 then
		return
	end

	if not arg0_9:getEnemySetRoadAble(arg1_9, arg2_9:GetGridIndex()) then
		return
	end

	local var1_9 = arg1_9:GetGridIndex()

	if arg2_9:GetRush() then
		local var2_9 = arg2_9:GetGridIndex()
		local var3_9 = {
			[var2_9] = {
				var2_9
			}
		}
		local var4_9 = arg0_9:getTargetRoadByCount({
			var2_9
		}, var3_9, 1, 5)
		local var5_9 = arg0_9:getTargetMatchCountRandom(var3_9, 6)
		local var6_9 = arg0_9:getEnemyTargetRoad(arg1_9, var5_9)

		if var6_9 and var6_9[var1_9] then
			local var7_9 = var6_9[var1_9]

			arg0_9:setEnemyRoad(arg1_9, var7_9, 3)
		end
	elseif var0_9 == 1 then
		local var8_9 = arg0_9:getEnemyTargetRoad(arg1_9, arg0_9._player:GetGridIndex())

		if var8_9 and var8_9[var1_9] then
			local var9_9 = var8_9[var1_9]

			arg0_9:setEnemyRoad(arg1_9, var9_9, 4)
		end
	elseif var0_9 == 2 then
		local var10_9 = arg2_9:GetGridIndex()
		local var11_9 = {
			[var10_9] = {
				var10_9
			}
		}
		local var12_9 = arg0_9:getTargetRoadByCount({
			var10_9
		}, var11_9, 1, 3)
		local var13_9 = arg0_9:getTargetMatchCountRandom(var11_9, 4)
		local var14_9 = arg0_9:getEnemyTargetRoad(arg1_9, var13_9)

		if var14_9 and var14_9[var1_9] then
			local var15_9 = var14_9[var1_9]

			arg0_9:setEnemyRoad(arg1_9, var15_9, 4)
		end
	elseif var0_9 == 3 then
		local var16_9 = arg2_9:GetGridIndex()
		local var17_9 = {
			[var16_9] = {
				var16_9
			}
		}
		local var18_9 = arg0_9:getTargetRoadByCount({
			var16_9
		}, var17_9, 1, 4)
		local var19_9 = arg0_9:getTargetMatchCountRandom(var17_9, 5)
		local var20_9 = arg0_9:getEnemyTargetRoad(arg1_9, var19_9)

		if var20_9 and var20_9[var1_9] then
			local var21_9 = var20_9[var1_9]

			arg0_9:setEnemyRoad(arg1_9, var21_9, 4)
		end
	elseif var0_9 == 4 then
		if arg1_9:GetRoadBack() then
			local var22_9 = arg2_9:GetGridIndex()
			local var23_9 = {
				[var22_9] = {
					var22_9
				}
			}
			local var24_9 = arg0_9:getTargetRoadByCount({
				var22_9
			}, var23_9, 1, 5)
			local var25_9 = arg0_9:getTargetMatchCountRandom(var23_9, 6)
			local var26_9 = arg0_9:getEnemyTargetRoad(arg1_9, var25_9)

			if var26_9 and var26_9[var1_9] then
				local var27_9 = var26_9[var1_9]

				arg0_9:setEnemyRoad(arg1_9, var27_9, 0)
			end

			arg1_9:SetRoadBack(false)
		else
			local var28_9 = arg0_9:getEnemyTargetRoad(arg1_9, arg1_9:GetStartIndex())

			if var28_9 and var28_9[var1_9] then
				local var29_9 = var28_9[var1_9]

				arg0_9:setEnemyRoad(arg1_9, var29_9, 4)
			end

			arg1_9:SetRoadBack(true)
		end
	end
end

function var0_0.checkEnemyHit(arg0_10, arg1_10, arg2_10)
	if arg1_10:GetBackStart() then
		return
	end

	local var0_10 = arg1_10:GetPosition()
	local var1_10 = arg2_10:GetPosition()

	if math.abs(var0_10.x - var1_10.x) <= 30 and math.abs(var0_10.y - var1_10.y) <= 30 then
		if not arg2_10:GetRush() then
			arg0_10._event(PacGameScene.HIT_PLAYER, nil, nil)
		else
			if arg1_10:GetTarget() then
				arg1_10:SetGridIndex(arg1_10:GetTargetIndex())
				arg1_10:SetTarget(nil)
			end

			arg1_10:SetRoads({})

			local var2_10 = arg1_10:GetStartIndex()
			local var3_10 = arg0_10:getEnemyTargetRoad(arg1_10, arg1_10:GetStartIndex())

			if var3_10 and var3_10[arg1_10:GetGridIndex()] then
				local var4_10 = var3_10[arg1_10:GetGridIndex()]

				arg0_10:setEnemyRoad(arg1_10, var4_10, 0)
				arg1_10:SetBackStart(true)
			else
				arg1_10:SetPosition(arg0_10._gridDic[arg1_10:GetStartIndex()]:GetPosition())
				arg1_10:SetBackStart(true)
				arg1_10:SetHangAction()
				arg1_10:SetGridIndex(arg1_10:GetStartIndex())
			end
		end
	end
end

function var0_0.getTargetMatchCountRandom(arg0_11, arg1_11, arg2_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg1_11) do
		if #iter1_11 == arg2_11 then
			table.insert(var0_11, iter1_11[#iter1_11])
		end
	end

	return var0_11[math.random(1, #var0_11)]
end

function var0_0.getEnemyTargetRoad(arg0_12, arg1_12, arg2_12)
	if arg2_12 and arg0_12:getEnemySetRoadAble(arg1_12, arg2_12) then
		local var0_12 = {
			[arg2_12] = {
				arg2_12
			}
		}

		arg0_12:calcRoad({
			arg2_12
		}, arg2_12, var0_12, 1)

		return var0_12
	end

	return {}
end

function var0_0.getEnemySetRoadAble(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13:GetRoads()
	local var1_13 = arg1_13:HasTarget()
	local var2_13 = arg1_13:GetBackStart()
	local var3_13 = arg1_13:GetGridIndex()

	if var0_13 and #var0_13 == 0 and not var1_13 and not var2_13 and arg2_13 ~= var3_13 then
		return true
	end

	return false
end

function var0_0.getTargetRoadByCount(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	if arg4_14 < arg3_14 then
		return arg2_14
	end

	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		local var1_14 = arg0_14._runningData:GetNearGridIndex(iter1_14)
		local var2_14 = arg0_14:getLastIndexWithFrom(iter1_14, arg2_14)

		for iter2_14 = 1, #var1_14 do
			local var3_14 = var1_14[iter2_14]
			local var4_14 = true
			local var5_14 = arg0_14:getLastIndexWithFrom(var1_14[iter2_14], arg2_14)

			if var5_14 and #var5_14 > 0 then
				var4_14 = false
			end

			if var4_14 then
				local var6_14 = Clone(var2_14)

				table.insert(var6_14, var3_14)

				arg2_14[var3_14] = var6_14

				table.insert(var0_14, var3_14)
			end
		end
	end

	if #var0_14 > 0 then
		arg0_14:getTargetRoadByCount(var0_14, arg2_14, arg3_14 + 1, arg4_14)
	end

	return arg2_14
end

function var0_0.calcRoad(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		local var1_15 = arg0_15._runningData:GetNearGridIndex(iter1_15)
		local var2_15 = arg0_15:getLastIndexWithFrom(iter1_15, arg3_15)

		for iter2_15 = 1, #var1_15 do
			local var3_15 = var1_15[iter2_15]
			local var4_15 = true
			local var5_15 = arg0_15:getLastIndexWithFrom(var1_15[iter2_15], arg3_15)

			if var5_15 and #var5_15 > 0 then
				var4_15 = false
			end

			if var4_15 then
				local var6_15 = Clone(var2_15)

				table.insert(var6_15, var3_15)

				arg3_15[var3_15] = var6_15

				table.insert(var0_15, var3_15)

				if var3_15 == arg2_15 then
					return
				end
			end
		end
	end

	if #var0_15 > 0 then
		arg0_15:calcRoad(var0_15, arg2_15, arg3_15, arg4_15 + 1)
	end
end

function var0_0.getLastIndexWithFrom(arg0_16, arg1_16, arg2_16)
	if arg2_16[arg1_16] then
		return arg2_16[arg1_16]
	end

	return nil
end

function var0_0.setEnemyRoad(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg1_17:GetGridIndex()
	local var1_17 = {}

	for iter0_17 = #arg2_17, 1, -1 do
		local var2_17 = arg2_17[iter0_17]

		if var2_17 ~= var0_17 then
			table.insert(var1_17, var2_17)

			local var3_17 = arg0_17._runningData:GetNearGridIndex(var2_17)

			if arg3_17 and arg3_17 > 0 and var3_17 and arg3_17 <= #var3_17 then
				break
			end
		end
	end

	arg1_17:SetRoads(var1_17)
end

return var0_0
