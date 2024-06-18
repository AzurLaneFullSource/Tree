ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = class("BattleSkillFire", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillFire = var3_0
var3_0.__name = "BattleSkillFire"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._weaponID = arg0_1._tempData.arg_list.weapon_id
	arg0_1._emitter = arg0_1._tempData.arg_list.emitter
	arg0_1._useSkin = arg0_1._tempData.arg_list.useSkin
	arg0_1._equipIndex = arg0_1._tempData.arg_list.equip_index or -1
	arg0_1._atkAttrConvert = arg0_1._tempData.arg_list.attack_attribute_convert
end

function var3_0.SetWeaponSkin(arg0_2, arg1_2)
	arg0_2._modelID = arg1_2
end

function var3_0.IsFinaleEffect(arg0_3)
	return true
end

function var3_0.DoDataEffect(arg0_4, arg1_4, arg2_4)
	if arg0_4._weapon == nil then
		arg0_4._weapon = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(arg0_4._weaponID, arg1_4, nil, arg0_4._equipIndex)

		if BATTLE_DEBUG and (arg0_4._weapon:GetType() == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or arg0_4._weapon:GetType() == var2_0.EquipmentType.STRIKE_AIRCRAFT) then
			arg0_4._weapon:GetATKAircraftList()
			arg0_4._weapon:GetDEFAircraftList()
		end

		if arg0_4._modelID then
			arg0_4._weapon:SetModelID(arg0_4._modelID)
		elseif arg0_4._useSkin then
			local var0_4 = arg1_4:GetPriorityWeaponSkin()

			if var0_4 then
				arg0_4._weapon:SetModelID(var1_0.GetEquipSkin(var0_4))
			end
		end

		local var1_4 = {
			weapon = arg0_4._weapon
		}
		local var2_4 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var1_4)

		arg1_4:DispatchEvent(var2_4)
	end

	local function var3_4()
		arg0_4._weapon:Clear()

		if arg0_4._finaleCallback then
			arg0_4._finaleCallback()
		end
	end

	if arg0_4._atkAttrConvert then
		arg0_4._weapon:SetAtkAttrTrasnform(arg0_4._atkAttrConvert.attr_type, arg0_4._atkAttrConvert.A, arg0_4._atkAttrConvert.B)
	end

	arg0_4._weapon:updateMovementInfo()
	arg0_4._weapon:SingleFire(arg2_4, arg0_4._emitter, var3_4)
end

function var3_0.DoDataEffectWithoutTarget(arg0_6, arg1_6)
	arg0_6:DoDataEffect(arg1_6)
end

function var3_0.Clear(arg0_7)
	var3_0.super.Clear(arg0_7)

	if arg0_7._weapon and not arg0_7._weapon:GetHost():IsAlive() then
		arg0_7._weapon:Clear()
	end
end

function var3_0.Interrupt(arg0_8)
	var3_0.super.Interrupt(arg0_8)

	if arg0_8._weapon then
		arg0_8._weapon:Cease()
		arg0_8._weapon:Clear()
	end
end

function var3_0.GetDamageSum(arg0_9)
	local var0_9 = 0

	if not arg0_9._weapon then
		var0_9 = 0
	elseif arg0_9._weapon:GetType() == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or arg0_9._weapon:GetType() == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		for iter0_9, iter1_9 in ipairs(arg0_9._weapon:GetATKAircraftList()) do
			local var1_9 = iter1_9:GetWeapon()

			for iter2_9, iter3_9 in ipairs(var1_9) do
				var0_9 = var0_9 + iter3_9:GetDamageSUM()
			end
		end
	else
		var0_9 = arg0_9._weapon:GetDamageSUM()
	end

	return var0_9
end
