local var0_0 = class("PacGameMovingController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
end

function var0_0.Prepare(arg0_2)
	arg0_2._roles = {}
	arg0_2._gridDic = {}
	arg0_2._gridWidth, arg0_2._gridHeight = arg0_2._runningData:GetGridRect()
	arg0_2._halfGridWidth, arg0_2._halfGridHeight = arg0_2._gridWidth / 2, arg0_2._gridHeight / 2
	arg0_2._vertical, arg0_2._horizontal = arg0_2._runningData:GetGridWH()
end

function var0_0.Start(arg0_3)
	arg0_3._roles = arg0_3._runningData:GetRoles()
	arg0_3._gridDic = arg0_3._runningData:GetGridDic()
end

function var0_0.Step(arg0_4, arg1_4)
	arg0_4._deltaTime = arg1_4

	for iter0_4, iter1_4 in ipairs(arg0_4._roles) do
		arg0_4:MovingRole(iter1_4)
	end
end

function var0_0.MovingRole(arg0_5, arg1_5)
	if arg1_5:HasTarget() then
		local var0_5 = arg1_5:GetMove()
		local var1_5 = arg1_5:GetSpeed()
		local var2_5 = arg1_5:GetGridIndex()
		local var3_5 = arg1_5:GetTargetIndex()
		local var4_5 = Vector2(var1_5 * var0_5.x * arg0_5._deltaTime, var1_5 * var0_5.y * arg0_5._deltaTime)
		local var5_5 = arg1_5:GetTarget()
		local var6_5 = arg1_5:GetPosition()
		local var7_5 = Vector2(var6_5.x + var4_5.x, var6_5.y + var4_5.y)

		if arg0_5:checkMoveToTarget(var6_5, var7_5, var5_5) then
			arg1_5:SetPosition(var5_5)
			arg1_5:SetGridIndex(var3_5)
			arg1_5:SetTarget(nil)
			arg0_5:MovingRole(arg1_5)
		else
			local var8_5 = true

			if var8_5 then
				arg1_5:MoveTo(var7_5)
			end
		end
	elseif arg1_5:GetRoads() and #arg1_5:GetRoads() > 0 and not arg1_5:HasTarget() then
		local var9_5 = arg1_5:PopRoad()
		local var10_5 = arg1_5:GetGridIndex()
		local var11_5 = arg0_5._gridDic[var9_5]

		if not arg0_5:checkNear(var9_5, var10_5) then
			print("位置不相邻，结束 " .. tostring(var9_5) .. ":" .. tostring(var10_5))

			return
		end

		local var12_5 = arg0_5:getDirectByIndex(var10_5, var9_5)
		local var13_5 = arg1_5:GetPosition()
		local var14_5 = var11_5:GetPosition()
		local var15_5 = arg0_5:getMoving(var13_5, var14_5)

		arg1_5:SetTarget(var14_5, var9_5, var15_5, var12_5)
	else
		local var16_5 = arg1_5:GetDirect()

		if var16_5[1] == 0 and var16_5[2] == 0 then
			return
		end

		local var17_5 = arg1_5:GetGridIndex()
		local var18_5 = arg0_5._runningData:getDirectGrid(var17_5, Vector2(var16_5[1], var16_5[2]))

		if var18_5 then
			local var19_5 = arg0_5:getMoving(arg1_5:GetPosition(), var18_5:GetPosition())

			arg1_5:SetTarget(var18_5:GetPosition(), var18_5:GetIndex(), var19_5, var16_5)
		end
	end
end

function var0_0.Clear(arg0_6)
	return
end

function var0_0.Stop(arg0_7)
	return
end

function var0_0.Resume(arg0_8)
	return
end

function var0_0.Dispose(arg0_9)
	return
end

function var0_0.getDirectByIndex(arg0_10, arg1_10, arg2_10)
	if arg1_10 + 1 == arg2_10 then
		return {
			1,
			0
		}
	elseif arg1_10 - 1 == arg2_10 then
		return {
			-1,
			0
		}
	elseif arg1_10 + arg0_10._horizontal == arg2_10 then
		return {
			0,
			-1
		}
	elseif arg1_10 - arg0_10._horizontal == arg2_10 then
		return {
			0,
			1
		}
	end
end

function var0_0.checkNear(arg0_11, arg1_11, arg2_11)
	if arg1_11 + 1 == arg2_11 or arg1_11 - 1 == arg2_11 then
		return true
	elseif arg1_11 + arg0_11._horizontal == arg2_11 or arg1_11 - arg0_11._horizontal == arg2_11 then
		return true
	end

	return false
end

function var0_0.checkMoveToTarget(arg0_12, arg1_12, arg2_12, arg3_12)
	if math.abs(arg3_12.x - arg1_12.x) >= 300 or math.abs(arg3_12.y - arg1_12.y) >= 300 then
		warning("超出正常坐标值")

		return true
	end

	if arg1_12.x < arg3_12.x and arg2_12.x >= arg3_12.x then
		return true
	elseif arg1_12.x > arg3_12.x and arg2_12.x <= arg3_12.x then
		return true
	elseif arg1_12.y < arg3_12.y and arg2_12.y >= arg3_12.y then
		return true
	elseif arg1_12.y > arg3_12.y and arg2_12.y <= arg3_12.y then
		return true
	end

	if math.abs(arg3_12.x - arg1_12.x) <= 5 and math.abs(arg3_12.y - arg1_12.y) <= 5 then
		return true
	end

	return false
end

function var0_0.getMoving(arg0_13, arg1_13, arg2_13)
	local var0_13 = math.atan(math.abs(arg2_13.y - arg1_13.y) / math.abs(arg2_13.x - arg1_13.x))
	local var1_13 = arg2_13.x >= arg1_13.x and 1 or -1
	local var2_13 = arg2_13.y >= arg1_13.y and 1 or -1
	local var3_13 = math.cos(var0_13) * var1_13
	local var4_13 = math.sin(var0_13) * var2_13

	if math.abs(var3_13) <= 0.01 then
		var3_13 = 0
	end

	if math.abs(var4_13) <= 0.01 then
		var4_13 = 0
	end

	return Vector2(var3_13, var4_13)
end

return var0_0
