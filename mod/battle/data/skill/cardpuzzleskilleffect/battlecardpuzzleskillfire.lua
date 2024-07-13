ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleCardPuzzleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = class("BattleCardPuzzleSkillFire", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillFire = var4_0
var4_0.__name = "BattleCardPuzzleSkillFire"

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._weaponID = arg0_1._tempData.arg_list.weapon_id
	arg0_1._emitter = arg0_1._tempData.arg_list.emitter
	arg0_1._useSkin = arg0_1._tempData.arg_list.useSkin
	arg0_1._enhance = arg0_1._tempData.arg_list.enhance_formula
end

function var4_0.SetWeaponSkin(arg0_2, arg1_2)
	arg0_2._modelID = arg1_2
end

function var4_0.SkillEffectHandler(arg0_3)
	if arg0_3._weapon == nil then
		arg0_3._weapon = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(arg0_3._weaponID, arg0_3._caster)

		if arg0_3._modelID then
			arg0_3._weapon:SetModelID(arg0_3._modelID)
		elseif arg0_3._useSkin then
			local var0_3 = arg0_3._caster:GetPriorityWeaponSkin()

			if var0_3 then
				arg0_3._weapon:SetModelID(var1_0.GetEquipSkin(var0_3))
			end
		end

		local var1_3 = {
			weapon = arg0_3._weapon
		}
		local var2_3 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var1_3)

		arg0_3._caster:DispatchEvent(var2_3)
	end

	local function var3_3()
		arg0_3._weapon:Clear()
		arg0_3:Finale()
	end

	if arg0_3._enhance then
		local var4_3 = var2_0.parseFormula(arg0_3._enhance, arg0_3:GetCardPuzzleComponent():GetAttrManager())

		arg0_3._weapon:SetCardPuzzleDamageEnhance(var4_3)
	end

	arg0_3._weapon:updateMovementInfo()

	local var5_3 = arg0_3:GetTarget()

	if #var5_3 > 0 then
		for iter0_3, iter1_3 in ipairs(var5_3) do
			arg0_3._weapon:SingleFire(iter1_3, arg0_3._emitter, var3_3)
		end
	else
		arg0_3._weapon:SingleFire(nil, arg0_3._emitter, var3_3)
	end
end

function var4_0.Clear(arg0_5)
	var4_0.super.Clear(arg0_5)

	if arg0_5._weapon and not arg0_5._weapon:GetHost():IsAlive() then
		arg0_5._weapon:Clear()
	end
end

function var4_0.Interrupt(arg0_6)
	var4_0.super.Interrupt(arg0_6)

	if arg0_6._weapon then
		arg0_6._weapon:Cease()
		arg0_6._weapon:Clear()
	end
end
