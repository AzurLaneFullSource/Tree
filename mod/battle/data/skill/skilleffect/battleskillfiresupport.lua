ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = class("BattleSkillFireSupport", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillFireSupport = var3
var3.__name = "BattleSkillFireSupport"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1, lv)

	arg0._weaponID = arg0._tempData.arg_list.weapon_id
	arg0._supportTargetFilter = arg0._tempData.arg_list.supportTarget.targetChoice
	arg0._supportTargetArgList = arg0._tempData.arg_list.supportTarget.arg_list
end

function var3.DoDataEffect(arg0, arg1, arg2)
	if arg0._weapon == nil then
		local var0

		for iter0, iter1 in ipairs(arg0._supportTargetFilter) do
			var0 = var0.Battle.BattleTargetChoise[iter1](arg1, arg0._supportTargetArgList, var0)
		end

		local var1 = var0[1]

		arg0._weapon = var0.Battle.BattleDataFunction.CreateWeaponUnit(arg0._weaponID, arg1)

		if BATTLE_DEBUG and (arg0._weapon:GetType() == var2.EquipmentType.INTERCEPT_AIRCRAFT or arg0._weapon:GetType() == var2.EquipmentType.STRIKE_AIRCRAFT) then
			arg0._weapon:GetATKAircraftList()
		end

		if var1 then
			arg0._weapon:SetStandHost(var1)
		end

		local var2 = {
			weapon = arg0._weapon
		}
		local var3 = var0.Event.New(var0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var2)

		arg1:DispatchEvent(var3)
	end

	local function var4()
		arg0._weapon:Clear()
	end

	arg0._weapon:updateMovementInfo()
	arg0._weapon:SingleFire(arg2, arg0._emitter, var4)
end

function var3.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1)
end

function var3.Clear(arg0)
	var3.super.Clear(arg0)

	if arg0._weapon and not arg0._weapon:GetHost():IsAlive() then
		arg0._weapon:Clear()
	end
end

function var3.Interrupt(arg0)
	var3.super.Interrupt(arg0)

	if arg0._weapon then
		arg0._weapon:Cease()
		arg0._weapon:Clear()
	end
end

function var3.GetDamageSum(arg0)
	local var0 = 0

	if not arg0._weapon then
		var0 = 0
	elseif arg0._weapon:GetType() == var2.EquipmentType.INTERCEPT_AIRCRAFT or arg0._weapon:GetType() == var2.EquipmentType.STRIKE_AIRCRAFT then
		for iter0, iter1 in ipairs(arg0._weapon:GetATKAircraftList()) do
			local var1 = iter1:GetWeapon()

			for iter2, iter3 in ipairs(var1) do
				var0 = var0 + iter3:GetDamageSUM()
			end
		end
	else
		var0 = arg0._weapon:GetDamageSUM()
	end

	return var0
end
