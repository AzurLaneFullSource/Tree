ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleTargetChoise
local var4_0 = class("BattleAutoMissileUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleAutoMissileUnit = var4_0
var4_0.__name = "BattleAutoMissileUnit"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.createMajorEmitter(arg0_2, arg1_2, arg2_2, arg3_2)
	local function var0_2(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		local var0_3 = arg0_2._emitBulletIDList[arg2_2]
		local var1_3 = arg0_2:Spawn(var0_3, arg4_3, var4_0.INTERNAL)

		var1_3:SetOffsetPriority(arg3_3)
		var1_3:SetShiftInfo(arg0_3, arg1_3)

		if arg0_2._tmpData.aim_type == var1_0.WeaponAimType.AIM and arg4_3 ~= nil then
			var1_3:SetRotateInfo(arg4_3:GetBeenAimedPosition(), arg0_2:GetBaseAngle(), arg2_3)
		else
			var1_3:SetRotateInfo(nil, arg0_2:GetBaseAngle(), arg2_3)
		end

		var1_3:setTrackingTarget(arg4_3)

		local var2_3 = {}

		var1_3:SetTrackingFXData(var2_3)
		arg0_2:DispatchBulletEvent(var1_3)

		return var1_3
	end

	local function var1_2()
		for iter0_4, iter1_4 in ipairs(arg0_2._majorEmitterList) do
			if iter1_4:GetState() ~= iter1_4.STATE_STOP then
				return
			end
		end

		arg0_2:EnterCoolDown()
	end

	arg3_2 = arg3_2 or var4_0.EMITTER_NORMAL

	local var2_2 = var0_0.Battle[arg3_2].New(var0_2, var1_2, arg1_2)

	arg0_2._majorEmitterList[#arg0_2._majorEmitterList + 1] = var2_2

	return var2_2
end

function var4_0.Tracking(arg0_5)
	return var3_0.TargetWeightiest(arg0_5, nil, arg0_5:GetFilteredList())[1]
end
