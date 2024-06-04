ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleTargetChoise
local var2 = var0.Battle.BattleFormulas
local var3 = class("BattleSpaceLaserUnit", var0.Battle.BattleColumnAreaBulletUnit)

var3.__name = "BattleSpaceLaserUnit"
var0.Battle.BattleSpaceLaserUnit = var3
var3.STATE_READY = "Ready"
var3.STATE_PRECAST = "Precast"
var3.STATE_ATTACK = "Attack"
var3.STATE_DESTROY = "Destroy"

function var3.Ctor(arg0, ...)
	var3.super.Ctor(arg0, ...)

	arg0._collidedTimes = {}
end

function var3.Dispose(arg0)
	arg0._lifeEndCb = nil
	arg0._collidedTimes = nil

	var3.super.Dispose(arg0)
end

function var3.ExecuteLifeEndCallback(arg0)
	if arg0._lifeEndCb then
		arg0._lifeEndCb()
	end
end

function var3.AssertFields(arg0, arg1)
	assert(arg0[arg1], "Lack Field " .. arg1)
end

function var3.SetTemplateData(arg0, arg1)
	arg0.AssertFields(arg1.extra_param, "attack_time")
	arg0.AssertFields(arg1.hit_type, "interval")
	var3.super.SetTemplateData(arg0, arg1)

	arg0._hitInterval = arg1.hit_type.interval
end

function var3.GetHitInterval(arg0)
	return arg0._hitInterval
end

function var3.DoTrack(arg0)
	local var0 = arg0
	local var1 = var0:getTrackingTarget()

	if not var1 or var1 == -1 then
		return
	elseif not var1:IsAlive() then
		var0:setTrackingTarget(-1)
		var0._speed:SetNormalize():Mul(arg0._convertedVelocity)

		return
	elseif var0:GetDistance(var1) > var0._trackRange then
		var0:setTrackingTarget(-1)
		var0._speed:SetNormalize():Mul(arg0._convertedVelocity)

		return
	end

	local var2 = var1:GetPosition() - var0:GetPosition()
	local var3 = var2:Magnitude()

	if var3 <= 1e-05 then
		arg0._speed:Set(0, 0, 0)

		return
	end

	local var4 = arg0._speedNormal

	var2:SetNormalize()

	local var5 = var2.x * var4.x + var2.z * var4.z
	local var6 = var2.z * var4.x - var2.x * var4.z
	local var7 = var0:GetSpeedRatio()
	local var8 = math.cos(var0._cosAngularSpeed * var7)
	local var9 = math.sin(var0._sinAngularSpeed * var7)
	local var10 = var5
	local var11 = var6

	if var5 < var8 then
		var10 = var8
		var11 = var9 * (var11 > 0 and 1 or -1)
	end

	local var12 = var4.x * var10 - var4.z * var11
	local var13 = var4.z * var10 + var4.x * var11
	local var14 = math.min(arg0._convertedVelocity, var3)

	var0._speed:Set(var12, 0, var13)
	var0._speed:Mul(var14)
	arg0._speedNormal:Set(var12, 0, var13)
	arg0._speedNormal:SetNormalize()

	arg0._yAngle = math.rad2Deg * math.atan2(var12, var13)
end

function var3.InitSpeed(arg0, ...)
	var3.super.InitSpeed(arg0, ...)

	if arg0:IsTracker() then
		local var0 = math.deg2Rad * arg0._yAngle

		arg0._speedNormal = Vector3(math.cos(var0), 0, math.sin(var0))
		arg0.updateSpeed = arg0.DoTrack
	elseif arg0:IsCircle() and arg0:IsAlert() then
		arg0._centripetalSpeed = arg0._centripetalSpeed * arg0.alertSpeedRatio
	end
end

function var3.SetLifeTime(arg0, arg1)
	arg0._lifeTime = arg1
end

function var3.SetAlert(arg0, arg1)
	arg0._alertFlag = arg1

	local var0 = arg0:GetTemplate().extra_param

	if not var0.alertSpeed then
		return
	end

	arg0:ResetVelocity(arg0._velocity * var0.alertSpeed)

	arg0.alertSpeedRatio = var0.alertSpeed
end

function var3.IsAlert(arg0)
	return arg0._alertFlag
end

function var3.Update(arg0, arg1)
	var3.super.Update(arg0, arg1)

	arg0._reachDestFlag = arg1 > arg0._timeStamp + arg0._lifeTime

	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	for iter0, iter1 in pairs(arg0._collidedTimes) do
		if var0 > iter1 + arg0._hitInterval then
			arg0._collidedTimes[iter0] = nil
			arg0._collidedList[iter0] = nil
		end
	end
end

function var3.GetCollidedList(arg0)
	return arg0._collidedList, arg0._collidedTimes
end

function var3.RegisterLifeEndCB(arg0, arg1)
	arg0._lifeEndCb = arg1
end

function var3.UnRegisterLifeEndCB(arg0)
	arg0._lifeEndCb = nil
end
