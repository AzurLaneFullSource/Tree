ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleDataFunction
local var5_0 = class("BattleSpaceLaserWeaponUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleSpaceLaserWeaponUnit = var5_0
var5_0.__name = "BattleSpaceLaserWeaponUnit"

function var5_0.createMajorEmitter(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	local var0_1 = arg0_1:CreateEmitter(arg3_1, arg1_1, arg2_1)

	arg0_1._majorEmitterList[#arg0_1._majorEmitterList + 1] = var0_1

	return var0_1
end

function var5_0.CreateEmitter(arg0_2, arg1_2, arg2_2, arg3_2)
	arg1_2 = arg1_2 or var5_0.EMITTER_NORMAL

	local var0_2
	local var1_2
	local var2_2
	local var3_2 = 0

	local function var4_2(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		if arg0_2._currentState == arg0_2.STATE_DISABLE then
			return
		end

		local var0_3 = arg0_2._emitBulletIDList[arg3_2]
		local var1_3 = arg0_2:Spawn(var0_3, arg4_3, var5_0.INTERNAL)

		var3_2 = var3_2 + 1
		arg4_3 = arg0_2._tmpData.aim_type == var1_0.WeaponAimType.AIM and arg4_3 or nil

		var1_3:SetOffsetPriority(arg3_3)
		var1_3:SetShiftInfo(arg0_3, arg1_3)
		var1_3:setTrackingTarget(arg4_3)
		var1_3:SetYAngle(var1_2)
		var1_3:SetLifeTime(var1_3:GetTemplate().extra_param.attack_time)
		var1_3:RegisterLifeEndCB(function()
			var3_2 = var3_2 - 1

			if var3_2 > 0 then
				return
			end

			if arg0_2._currentState == arg0_2.STATE_DISABLE then
				return
			end

			for iter0_4, iter1_4 in ipairs(arg0_2._majorEmitterList) do
				if iter1_4:GetState() ~= iter1_4.STATE_STOP then
					return
				end
			end

			arg0_2:EnterCoolDown()
		end)

		local var2_3 = var2_2 or arg4_3 and pg.Tool.FilterY(arg4_3:GetCLDZCenterPosition())

		var1_3:SetRotateInfo(var2_3, arg0_2:GetBaseAngle(), arg2_3)
		arg0_2:DispatchBulletEvent(var1_3, var0_2 or var2_3)

		return var1_3
	end

	local function var5_2(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		if arg0_2._currentState == arg0_2.STATE_DISABLE then
			return
		end

		local var0_5 = arg0_2._emitBulletIDList[arg3_2]
		local var1_5 = var4_0.GetBulletTmpDataFromID(var0_5).extra_param.aim_time

		if not var1_5 or not (var1_5 > 0) then
			var4_2(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)

			return
		end

		local var2_5 = arg0_2:Spawn(var0_5, arg4_5, var5_0.INTERNAL)

		var3_2 = var3_2 + 1
		arg4_5 = arg0_2._tmpData.aim_type == var1_0.WeaponAimType.AIM and arg4_5 or nil

		var2_5:setTrackingTarget(arg4_5)
		var2_5:SetOffsetPriority(arg3_5)
		var2_5:SetShiftInfo(arg0_5, arg1_5)
		var2_5:SetLifeTime(var2_5:GetTemplate().extra_param.aim_time)
		var2_5:SetAlert(true)
		var2_5:RegisterLifeEndCB(function()
			var3_2 = var3_2 - 1
			var0_2 = pg.Tool.FilterY(var2_5:GetPosition() - Vector3(arg0_5, 0, arg1_5))
			var1_2 = var2_5:GetYAngle()
			var2_2 = var2_5:GetRotateInfo()

			var4_2(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		end)

		local var3_5 = var2_5:GetTemplate().alert_fx

		if var3_5 and #var3_5 > 0 then
			var2_5:SetModleID(var3_5)
		end

		local var4_5 = arg4_5 and pg.Tool.FilterY(arg4_5:GetCLDZCenterPosition())

		var2_5:SetRotateInfo(var4_5, arg0_2:GetBaseAngle(), arg2_5)
		arg0_2:DispatchBulletEvent(var2_5, var4_5)

		return var2_5
	end

	local function var6_2()
		return
	end

	return (var0_0.Battle[arg1_2].New(var5_2, var6_2, arg2_2))
end

function var5_0.SingleFire(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	assert(false, "Not Support only fire for BattleSpaceLaserWeapon")
end
