ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleTargetChoise
local var4 = class("BattleAutoMissileUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleAutoMissileUnit = var4
var4.__name = "BattleAutoMissileUnit"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.createMajorEmitter(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, arg4, var4.INTERNAL)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)

		if arg0._tmpData.aim_type == var1.WeaponAimType.AIM and arg4 ~= nil then
			var1:SetRotateInfo(arg4:GetBeenAimedPosition(), arg0:GetBaseAngle(), arg2)
		else
			var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
		end

		var1:setTrackingTarget(arg4)

		local var2 = {}

		var1:SetTrackingFXData(var2)
		arg0:DispatchBulletEvent(var1)

		return var1
	end

	local function var1()
		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			if iter1:GetState() ~= iter1.STATE_STOP then
				return
			end
		end

		arg0:EnterCoolDown()
	end

	arg3 = arg3 or var4.EMITTER_NORMAL

	local var2 = var0.Battle[arg3].New(var0, var1, arg1)

	arg0._majorEmitterList[#arg0._majorEmitterList + 1] = var2

	return var2
end

function var4.Tracking(arg0)
	return var3.TargetWeightiest(arg0, nil, arg0:GetFilteredList())[1]
end
