ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleTargetChoise
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = class("BattleSpaceLaserUnit", var0_0.Battle.BattleColumnAreaBulletUnit)

var3_0.__name = "BattleSpaceLaserUnit"
var0_0.Battle.BattleSpaceLaserUnit = var3_0
var3_0.STATE_READY = "Ready"
var3_0.STATE_PRECAST = "Precast"
var3_0.STATE_ATTACK = "Attack"
var3_0.STATE_DESTROY = "Destroy"

function var3_0.Ctor(arg0_1, ...)
	var3_0.super.Ctor(arg0_1, ...)

	arg0_1._collidedTimes = {}
end

function var3_0.Dispose(arg0_2)
	arg0_2._lifeEndCb = nil
	arg0_2._collidedTimes = nil

	var3_0.super.Dispose(arg0_2)
end

function var3_0.ExecuteLifeEndCallback(arg0_3)
	if arg0_3._lifeEndCb then
		arg0_3._lifeEndCb()
	end
end

function var3_0.AssertFields(arg0_4, arg1_4)
	assert(arg0_4[arg1_4], "Lack Field " .. arg1_4)
end

function var3_0.SetTemplateData(arg0_5, arg1_5)
	arg0_5.AssertFields(arg1_5.extra_param, "attack_time")
	arg0_5.AssertFields(arg1_5.hit_type, "interval")
	var3_0.super.SetTemplateData(arg0_5, arg1_5)

	arg0_5._hitInterval = arg1_5.hit_type.interval
end

function var3_0.GetHitInterval(arg0_6)
	return arg0_6._hitInterval
end

function var3_0.DoTrack(arg0_7)
	local var0_7 = arg0_7
	local var1_7 = var0_7:getTrackingTarget()

	if not var1_7 or var1_7 == -1 then
		return
	elseif not var1_7:IsAlive() then
		var0_7:setTrackingTarget(-1)
		var0_7._speed:SetNormalize():Mul(arg0_7._convertedVelocity)

		return
	elseif var0_7:GetDistance(var1_7) > var0_7._trackRange then
		var0_7:setTrackingTarget(-1)
		var0_7._speed:SetNormalize():Mul(arg0_7._convertedVelocity)

		return
	end

	local var2_7 = var1_7:GetPosition() - var0_7:GetPosition()
	local var3_7 = var2_7:Magnitude()

	if var3_7 <= 1e-05 then
		arg0_7._speed:Set(0, 0, 0)

		return
	end

	local var4_7 = arg0_7._speedNormal

	var2_7:SetNormalize()

	local var5_7 = var2_7.x * var4_7.x + var2_7.z * var4_7.z
	local var6_7 = var2_7.z * var4_7.x - var2_7.x * var4_7.z
	local var7_7 = var0_7:GetSpeedRatio()
	local var8_7 = math.cos(var0_7._cosAngularSpeed * var7_7)
	local var9_7 = math.sin(var0_7._sinAngularSpeed * var7_7)
	local var10_7 = var5_7
	local var11_7 = var6_7

	if var5_7 < var8_7 then
		var10_7 = var8_7
		var11_7 = var9_7 * (var11_7 > 0 and 1 or -1)
	end

	local var12_7 = var4_7.x * var10_7 - var4_7.z * var11_7
	local var13_7 = var4_7.z * var10_7 + var4_7.x * var11_7
	local var14_7 = math.min(arg0_7._convertedVelocity, var3_7)

	var0_7._speed:Set(var12_7, 0, var13_7)
	var0_7._speed:Mul(var14_7)
	arg0_7._speedNormal:Set(var12_7, 0, var13_7)
	arg0_7._speedNormal:SetNormalize()

	arg0_7._yAngle = math.rad2Deg * math.atan2(var12_7, var13_7)
end

function var3_0.InitSpeed(arg0_8, ...)
	var3_0.super.InitSpeed(arg0_8, ...)

	if arg0_8:IsTracker() then
		local var0_8 = math.deg2Rad * arg0_8._yAngle

		arg0_8._speedNormal = Vector3(math.cos(var0_8), 0, math.sin(var0_8))
		arg0_8.updateSpeed = arg0_8.DoTrack
	elseif arg0_8:IsCircle() and arg0_8:IsAlert() then
		arg0_8._centripetalSpeed = arg0_8._centripetalSpeed * arg0_8.alertSpeedRatio
	end
end

function var3_0.SetLifeTime(arg0_9, arg1_9)
	arg0_9._lifeTime = arg1_9
end

function var3_0.SetAlert(arg0_10, arg1_10)
	arg0_10._alertFlag = arg1_10

	local var0_10 = arg0_10:GetTemplate().extra_param

	if not var0_10.alertSpeed then
		return
	end

	arg0_10:ResetVelocity(arg0_10._velocity * var0_10.alertSpeed)

	arg0_10.alertSpeedRatio = var0_10.alertSpeed
end

function var3_0.IsAlert(arg0_11)
	return arg0_11._alertFlag
end

function var3_0.Update(arg0_12, arg1_12)
	var3_0.super.Update(arg0_12, arg1_12)

	arg0_12._reachDestFlag = arg1_12 > arg0_12._timeStamp + arg0_12._lifeTime

	local var0_12 = pg.TimeMgr.GetInstance():GetCombatTime()

	for iter0_12, iter1_12 in pairs(arg0_12._collidedTimes) do
		if var0_12 > iter1_12 + arg0_12._hitInterval then
			arg0_12._collidedTimes[iter0_12] = nil
			arg0_12._collidedList[iter0_12] = nil
		end
	end
end

function var3_0.GetCollidedList(arg0_13)
	return arg0_13._collidedList, arg0_13._collidedTimes
end

function var3_0.RegisterLifeEndCB(arg0_14, arg1_14)
	arg0_14._lifeEndCb = arg1_14
end

function var3_0.UnRegisterLifeEndCB(arg0_15)
	arg0_15._lifeEndCb = nil
end
