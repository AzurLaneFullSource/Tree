ys = ys or {}

local var0_0 = ys
local var1_0 = Vector3.up
local var2_0 = var0_0.Battle.BattleTargetChoise
local var3_0 = class("BattleTrackingAAMissileUnit", var0_0.Battle.BattleBulletUnit)

var3_0.__name = "BattleTrackingAAMissileUnit"
var0_0.Battle.BattleTrackingAAMissileUnit = var3_0

function var3_0.doAccelerate(arg0_1, arg1_1)
	local var0_1, var1_1 = arg0_1:GetAcceleration(arg1_1)

	if var0_1 == 0 and var1_1 == 0 then
		return
	end

	if var0_1 < 0 and arg0_1._speedLength + var0_1 < 0 then
		arg0_1:reverseAcceleration()
	end

	arg0_1._speed:Set(arg0_1._speed.x + arg0_1._speedNormal.x * var0_1 + arg0_1._speedCross.x * var1_1, arg0_1._speed.y + arg0_1._speedNormal.y * var0_1 + arg0_1._speedCross.y * var1_1, arg0_1._speed.z + arg0_1._speedNormal.z * var0_1 + arg0_1._speedCross.z * var1_1)

	arg0_1._speedLength = arg0_1._speed:Magnitude()

	if arg0_1._speedLength ~= 0 then
		arg0_1._speedNormal:Copy(arg0_1._speed)
		arg0_1._speedNormal:Div(arg0_1._speedLength)
	end

	arg0_1._speedCross:Copy(arg0_1._speedNormal)
	arg0_1._speedCross:Cross2(var1_0)
end

function var3_0.doTrack(arg0_2)
	if arg0_2:getTrackingTarget() == nil then
		local var0_2 = arg0_2:GetFilteredList()
		local var1_2 = var2_0.TargetWeightiest(arg0_2, nil, var0_2)[1]

		if var1_2 ~= nil then
			arg0_2:setTrackingTarget(var1_2)
		end
	end

	local var2_2 = arg0_2:getTrackingTarget()

	if var2_2 == nil or var2_2 == -1 then
		return
	elseif not var2_2:IsAlive() then
		arg0_2:CleanAimMark()
		arg0_2:setTrackingTarget(-1)

		return
	end

	local var3_2 = var2_2:GetBeenAimedPosition()

	if not var3_2 then
		return
	end

	local var4_2 = var3_2 - arg0_2:GetPosition()

	var4_2:SetNormalize()

	local var5_2 = Vector3.Normalize(arg0_2._speed)
	local var6_2 = Vector3.Dot(var5_2, var4_2)
	local var7_2 = var5_2.z * var4_2.x - var5_2.x * var4_2.z
	local var8_2 = arg0_2:GetSpeedRatio()
	local var9_2 = var6_2
	local var10_2 = var7_2
	local var11_2 = arg0_2._speed.x * var9_2 + arg0_2._speed.z * var10_2
	local var12_2 = arg0_2._speed.z * var9_2 - arg0_2._speed.x * var10_2

	arg0_2._speed:Set(var11_2, 0, var12_2)
end

function var3_0.doNothing(arg0_3)
	if arg0_3._gravity ~= 0 then
		arg0_3._verticalSpeed = arg0_3._verticalSpeed + arg0_3._gravity * arg0_3:GetSpeedRatio()
	end
end

function var3_0.GetFilteredList(arg0_4)
	local var0_4 = var2_0.TargetAllHarm(arg0_4)
	local var1_4 = arg0_4:FilterRange(var0_4)

	return (arg0_4:FilterAngle(var1_4))
end

function var3_0.FilterRange(arg0_5, arg1_5)
	if not arg0_5._trackDist then
		return arg1_5
	end

	for iter0_5 = #arg1_5, 1, -1 do
		if arg0_5:IsOutOfRange(arg1_5[iter0_5]) then
			table.remove(arg1_5, iter0_5)
		end
	end

	return arg1_5
end

function var3_0.IsOutOfRange(arg0_6, arg1_6)
	if not arg0_6._trackDist then
		return true
	end

	return arg0_6:GetDistance(arg1_6) > arg0_6._trackDist
end

function var3_0.FilterAngle(arg0_7, arg1_7)
	if not arg0_7._trackAngle or arg0_7._trackAngle >= 360 then
		return arg1_7
	end

	for iter0_7 = #arg1_7, 1, -1 do
		if arg0_7:IsOutOfAngle(arg1_7[iter0_7]) then
			table.remove(arg1_7, iter0_7)
		end
	end

	return arg1_7
end

function var3_0.IsOutOfAngle(arg0_8, arg1_8)
	if not arg0_8._trackAngle or arg0_8._trackAngle >= 360 then
		return false
	end

	local var0_8 = arg0_8:GetPosition()
	local var1_8 = arg1_8:GetPosition() - var0_8
	local var2_8 = arg0_8._speedNormal
	local var3_8 = Vector3.Dot(var1_8, var2_8) / var1_8:Magnitude()
	local var4_8 = math.acos(var3_8)

	return var4_8 > arg0_8._trackRadian or var4_8 < -arg0_8._trackRadian
end

function var3_0.SetTrackingFXData(arg0_9, arg1_9)
	arg0_9._trackingFXData = arg1_9
end

function var3_0.InitSpeed(arg0_10, arg1_10)
	if arg0_10._yAngle == nil then
		if arg0_10._targetPos ~= nil then
			arg0_10._yAngle = arg1_10 + arg0_10._barrageAngle
		else
			arg0_10._yAngle = arg0_10._baseAngle + arg0_10._barrageAngle
		end
	end

	arg0_10:calcSpeed()

	local var0_10 = {}

	local function var1_10(arg0_11, arg1_11)
		for iter0_11, iter1_11 in ipairs(var0_10) do
			iter1_11(arg0_11, arg1_11)
		end

		local var0_11 = arg0_10:getTrackingTarget()

		if var0_11 and var0_11 ~= -1 and not arg0_10._trackingFXData.aimingFX and arg0_10._trackingFXData.fxName and arg0_10._trackingFXData.fxName ~= "" then
			local var1_11 = var0_0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(var0_11:GetUniqueID())

			arg0_10._trackingFXData.aimingFX = var1_11:AddFX(arg0_10._trackingFXData.fxName)
		end
	end

	if arg0_10:IsTracker() then
		local var2_10 = arg0_10._accTable.tracker

		arg0_10._trackAngle = 360
		arg0_10._trackDist = var2_10.range

		if var2_10.angular then
			arg0_10._trackRadian = math.deg2Rad * arg0_10._trackAngle * 0.5
		end

		table.insert(var0_10, arg0_10.doTrack)
	end

	if arg0_10:HasAcceleration() then
		arg0_10._speedLength = arg0_10._speed:Magnitude()
		arg0_10._speedNormal = arg0_10._speed / arg0_10._speedLength
		arg0_10._speedCross = Vector3.Cross(arg0_10._speedNormal, var1_0)

		table.insert(var0_10, function(arg0_12, ...)
			arg0_10._speedLength = arg0_10._speed:Magnitude()
			arg0_10._speedNormal = arg0_10._speed / arg0_10._speedLength
			arg0_10._speedCross = Vector3.Cross(arg0_10._speedNormal, var1_0)

			arg0_10.doAccelerate(arg0_12, ...)
		end)
	end

	if #var0_10 == 0 then
		table.insert(var0_10, arg0_10.doNothing)
	end

	arg0_10.updateSpeed = var1_10
end

function var3_0.CleanAimMark(arg0_13)
	local var0_13 = arg0_13:getTrackingTarget()

	if var0_13 and var0_13 ~= -1 and arg0_13._trackingFXData.aimingFX then
		local var1_13 = var0_0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(var0_13:GetUniqueID())

		if var1_13 then
			var1_13:RemoveFX(arg0_13._trackingFXData.aimingFX)
		end

		arg0_13._trackingFXData.aimingFX = nil
	end
end

function var3_0.OutRange(arg0_14, ...)
	arg0_14:CleanAimMark()
	var3_0.super.OutRange(arg0_14, ...)
end
