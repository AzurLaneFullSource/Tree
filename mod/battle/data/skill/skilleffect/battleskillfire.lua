ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = class("BattleSkillFire", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillFire = var3
var3.__name = "BattleSkillFire"

function var3.Ctor(arg0, arg1, arg2)
	var3.super.Ctor(arg0, arg1, arg2)

	arg0._weaponID = arg0._tempData.arg_list.weapon_id
	arg0._emitter = arg0._tempData.arg_list.emitter
	arg0._useSkin = arg0._tempData.arg_list.useSkin
	arg0._equipIndex = arg0._tempData.arg_list.equip_index or -1
	arg0._atkAttrConvert = arg0._tempData.arg_list.attack_attribute_convert
end

function var3.SetWeaponSkin(arg0, arg1)
	arg0._modelID = arg1
end

function var3.IsFinaleEffect(arg0)
	return true
end

function var3.DoDataEffect(arg0, arg1, arg2)
	if arg0._weapon == nil then
		arg0._weapon = var0.Battle.BattleDataFunction.CreateWeaponUnit(arg0._weaponID, arg1, nil, arg0._equipIndex)

		if BATTLE_DEBUG and (arg0._weapon:GetType() == var2.EquipmentType.INTERCEPT_AIRCRAFT or arg0._weapon:GetType() == var2.EquipmentType.STRIKE_AIRCRAFT) then
			arg0._weapon:GetATKAircraftList()
			arg0._weapon:GetDEFAircraftList()
		end

		if arg0._modelID then
			arg0._weapon:SetModelID(arg0._modelID)
		elseif arg0._useSkin then
			local var0 = arg1:GetPriorityWeaponSkin()

			if var0 then
				arg0._weapon:SetModelID(var1.GetEquipSkin(var0))
			end
		end

		local var1 = {
			weapon = arg0._weapon
		}
		local var2 = var0.Event.New(var0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var1)

		arg1:DispatchEvent(var2)
	end

	local function var3()
		arg0._weapon:Clear()

		if arg0._finaleCallback then
			arg0._finaleCallback()
		end
	end

	if arg0._atkAttrConvert then
		arg0._weapon:SetAtkAttrTrasnform(arg0._atkAttrConvert.attr_type, arg0._atkAttrConvert.A, arg0._atkAttrConvert.B)
	end

	arg0._weapon:updateMovementInfo()
	arg0._weapon:SingleFire(arg2, arg0._emitter, var3)
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
