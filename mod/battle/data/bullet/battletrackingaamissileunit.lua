ys = ys or {}

local var0 = ys
local var1 = Vector3.up
local var2 = var0.Battle.BattleTargetChoise
local var3 = class("BattleTrackingAAMissileUnit", var0.Battle.BattleBulletUnit)

var3.__name = "BattleTrackingAAMissileUnit"
var0.Battle.BattleTrackingAAMissileUnit = var3

function var3.doAccelerate(arg0, arg1)
	local var0, var1 = arg0:GetAcceleration(arg1)

	if var0 == 0 and var1 == 0 then
		return
	end

	if var0 < 0 and arg0._speedLength + var0 < 0 then
		arg0:reverseAcceleration()
	end

	arg0._speed:Set(arg0._speed.x + arg0._speedNormal.x * var0 + arg0._speedCross.x * var1, arg0._speed.y + arg0._speedNormal.y * var0 + arg0._speedCross.y * var1, arg0._speed.z + arg0._speedNormal.z * var0 + arg0._speedCross.z * var1)

	arg0._speedLength = arg0._speed:Magnitude()

	if arg0._speedLength ~= 0 then
		arg0._speedNormal:Copy(arg0._speed)
		arg0._speedNormal:Div(arg0._speedLength)
	end

	arg0._speedCross:Copy(arg0._speedNormal)
	arg0._speedCross:Cross2(var1)
end

function var3.doTrack(arg0)
	if arg0:getTrackingTarget() == nil then
		local var0 = arg0:GetFilteredList()
		local var1 = var2.TargetWeightiest(arg0, nil, var0)[1]

		if var1 ~= nil then
			arg0:setTrackingTarget(var1)
		end
	end

	local var2 = arg0:getTrackingTarget()

	if var2 == nil or var2 == -1 then
		return
	elseif not var2:IsAlive() then
		arg0:CleanAimMark()
		arg0:setTrackingTarget(-1)

		return
	end

	local var3 = var2:GetBeenAimedPosition()

	if not var3 then
		return
	end

	local var4 = var3 - arg0:GetPosition()

	var4:SetNormalize()

	local var5 = Vector3.Normalize(arg0._speed)
	local var6 = Vector3.Dot(var5, var4)
	local var7 = var5.z * var4.x - var5.x * var4.z
	local var8 = arg0:GetSpeedRatio()
	local var9 = var6
	local var10 = var7
	local var11 = arg0._speed.x * var9 + arg0._speed.z * var10
	local var12 = arg0._speed.z * var9 - arg0._speed.x * var10

	arg0._speed:Set(var11, 0, var12)
end

function var3.doNothing(arg0)
	if arg0._gravity ~= 0 then
		arg0._verticalSpeed = arg0._verticalSpeed + arg0._gravity * arg0:GetSpeedRatio()
	end
end

function var3.GetFilteredList(arg0)
	local var0 = var2.TargetAllHarm(arg0)
	local var1 = arg0:FilterRange(var0)

	return (arg0:FilterAngle(var1))
end

function var3.FilterRange(arg0, arg1)
	if not arg0._trackDist then
		return arg1
	end

	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfRange(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var3.IsOutOfRange(arg0, arg1)
	if not arg0._trackDist then
		return true
	end

	return arg0:GetDistance(arg1) > arg0._trackDist
end

function var3.FilterAngle(arg0, arg1)
	if not arg0._trackAngle or arg0._trackAngle >= 360 then
		return arg1
	end

	for iter0 = #arg1, 1, -1 do
		if arg0:IsOutOfAngle(arg1[iter0]) then
			table.remove(arg1, iter0)
		end
	end

	return arg1
end

function var3.IsOutOfAngle(arg0, arg1)
	if not arg0._trackAngle or arg0._trackAngle >= 360 then
		return false
	end

	local var0 = arg0:GetPosition()
	local var1 = arg1:GetPosition() - var0
	local var2 = arg0._speedNormal
	local var3 = Vector3.Dot(var1, var2) / var1:Magnitude()
	local var4 = math.acos(var3)

	return var4 > arg0._trackRadian or var4 < -arg0._trackRadian
end

function var3.SetTrackingFXData(arg0, arg1)
	arg0._trackingFXData = arg1
end

function var3.InitSpeed(arg0, arg1)
	if arg0._yAngle == nil then
		if arg0._targetPos ~= nil then
			arg0._yAngle = arg1 + arg0._barrageAngle
		else
			arg0._yAngle = arg0._baseAngle + arg0._barrageAngle
		end
	end

	arg0:calcSpeed()

	local var0 = {}

	local function var1(arg0, arg1)
		for iter0, iter1 in ipairs(var0) do
			iter1(arg0, arg1)
		end

		local var0 = arg0:getTrackingTarget()

		if var0 and var0 ~= -1 and not arg0._trackingFXData.aimingFX and arg0._trackingFXData.fxName and arg0._trackingFXData.fxName ~= "" then
			local var1 = var0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(var0:GetUniqueID())

			arg0._trackingFXData.aimingFX = var1:AddFX(arg0._trackingFXData.fxName)
		end
	end

	if arg0:IsTracker() then
		local var2 = arg0._accTable.tracker

		arg0._trackAngle = var2.angular
		arg0._trackDist = var2.range

		if var2.angular then
			arg0._trackRadian = math.deg2Rad * arg0._trackAngle * 0.5
		end

		table.insert(var0, arg0.doTrack)
	end

	if arg0:HasAcceleration() then
		arg0._speedLength = arg0._speed:Magnitude()
		arg0._speedNormal = arg0._speed / arg0._speedLength
		arg0._speedCross = Vector3.Cross(arg0._speedNormal, var1)

		table.insert(var0, function(arg0, ...)
			arg0._speedLength = arg0._speed:Magnitude()
			arg0._speedNormal = arg0._speed / arg0._speedLength
			arg0._speedCross = Vector3.Cross(arg0._speedNormal, var1)

			arg0.doAccelerate(arg0, ...)
		end)
	end

	if #var0 == 0 then
		table.insert(var0, arg0.doNothing)
	end

	arg0.updateSpeed = var1
end

function var3.CleanAimMark(arg0)
	local var0 = arg0:getTrackingTarget()

	if var0 and var0 ~= -1 and arg0._trackingFXData.aimingFX then
		local var1 = var0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(var0:GetUniqueID())

		if var1 then
			var1:RemoveFX(arg0._trackingFXData.aimingFX)
		end

		arg0._trackingFXData.aimingFX = nil
	end
end

function var3.OutRange(arg0, ...)
	arg0:CleanAimMark()
	var3.super.OutRange(arg0, ...)
end
