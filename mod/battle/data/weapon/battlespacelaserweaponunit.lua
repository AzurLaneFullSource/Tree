ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleDataFunction
local var5 = class("BattleSpaceLaserWeaponUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleSpaceLaserWeaponUnit = var5
var5.__name = "BattleSpaceLaserWeaponUnit"

function var5.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0:CreateEmitter(arg3, arg1, arg2)

	arg0._majorEmitterList[#arg0._majorEmitterList + 1] = var0

	return var0
end

function var5.CreateEmitter(arg0, arg1, arg2, arg3)
	arg1 = arg1 or var5.EMITTER_NORMAL

	local var0
	local var1
	local var2
	local var3 = 0

	local function var4(arg0, arg1, arg2, arg3, arg4)
		if arg0._currentState == arg0.STATE_DISABLE then
			return
		end

		local var0 = arg0._emitBulletIDList[arg3]
		local var1 = arg0:Spawn(var0, arg4, var5.INTERNAL)

		var3 = var3 + 1
		arg4 = arg0._tmpData.aim_type == var1.WeaponAimType.AIM and arg4 or nil

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)
		var1:setTrackingTarget(arg4)
		var1:SetYAngle(var1)
		var1:SetLifeTime(var1:GetTemplate().extra_param.attack_time)
		var1:RegisterLifeEndCB(function()
			var3 = var3 - 1

			if var3 > 0 then
				return
			end

			if arg0._currentState == arg0.STATE_DISABLE then
				return
			end

			for iter0, iter1 in ipairs(arg0._majorEmitterList) do
				if iter1:GetState() ~= iter1.STATE_STOP then
					return
				end
			end

			arg0:EnterCoolDown()
		end)

		local var2 = var2 or arg4 and pg.Tool.FilterY(arg4:GetCLDZCenterPosition())

		var1:SetRotateInfo(var2, arg0:GetBaseAngle(), arg2)
		arg0:DispatchBulletEvent(var1, var0 or var2)

		return var1
	end

	local var5 = function(arg0, arg1, arg2, arg3, arg4)
		if arg0._currentState == arg0.STATE_DISABLE then
			return
		end

		local var0 = arg0._emitBulletIDList[arg3]
		local var1 = var4.GetBulletTmpDataFromID(var0).extra_param.aim_time

		if not var1 or not (var1 > 0) then
			var4(arg0, arg1, arg2, arg3, arg4)

			return
		end

		local var2 = arg0:Spawn(var0, arg4, var5.INTERNAL)

		var3 = var3 + 1
		arg4 = arg0._tmpData.aim_type == var1.WeaponAimType.AIM and arg4 or nil

		var2:setTrackingTarget(arg4)
		var2:SetOffsetPriority(arg3)
		var2:SetShiftInfo(arg0, arg1)
		var2:SetLifeTime(var2:GetTemplate().extra_param.aim_time)
		var2:SetAlert(true)
		var2:RegisterLifeEndCB(function()
			var3 = var3 - 1
			var0 = pg.Tool.FilterY(var2:GetPosition() - Vector3(arg0, 0, arg1))
			var1 = var2:GetYAngle()
			var2 = var2:GetRotateInfo()

			var4(arg0, arg1, arg2, arg3, arg4)
		end)

		local var3 = var2:GetTemplate().alert_fx

		if var3 and #var3 > 0 then
			var2:SetModleID(var3)
		end

		local var4 = arg4 and pg.Tool.FilterY(arg4:GetCLDZCenterPosition())

		var2:SetRotateInfo(var4, arg0:GetBaseAngle(), arg2)
		arg0:DispatchBulletEvent(var2, var4)

		return var2
	end

	local function var6()
		return
	end

	return (var0.Battle[arg1].New(var5, var6, arg2))
end

function var5.SingleFire(arg0, arg1, arg2, arg3, arg4)
	assert(false, "Not Support only fire for BattleSpaceLaserWeapon")
end
