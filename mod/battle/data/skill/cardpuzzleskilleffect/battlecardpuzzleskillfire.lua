ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleCardPuzzleFormulas
local var3 = var0.Battle.BattleConst
local var4 = class("BattleCardPuzzleSkillFire", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillFire = var4
var4.__name = "BattleCardPuzzleSkillFire"

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)

	arg0._weaponID = arg0._tempData.arg_list.weapon_id
	arg0._emitter = arg0._tempData.arg_list.emitter
	arg0._useSkin = arg0._tempData.arg_list.useSkin
	arg0._enhance = arg0._tempData.arg_list.enhance_formula
end

function var4.SetWeaponSkin(arg0, arg1)
	arg0._modelID = arg1
end

function var4.SkillEffectHandler(arg0)
	if arg0._weapon == nil then
		arg0._weapon = var0.Battle.BattleDataFunction.CreateWeaponUnit(arg0._weaponID, arg0._caster)

		if arg0._modelID then
			arg0._weapon:SetModelID(arg0._modelID)
		elseif arg0._useSkin then
			local var0 = arg0._caster:GetPriorityWeaponSkin()

			if var0 then
				arg0._weapon:SetModelID(var1.GetEquipSkin(var0))
			end
		end

		local var1 = {
			weapon = arg0._weapon
		}
		local var2 = var0.Event.New(var0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var1)

		arg0._caster:DispatchEvent(var2)
	end

	local function var3()
		arg0._weapon:Clear()
		arg0:Finale()
	end

	if arg0._enhance then
		local var4 = var2.parseFormula(arg0._enhance, arg0:GetCardPuzzleComponent():GetAttrManager())

		arg0._weapon:SetCardPuzzleDamageEnhance(var4)
	end

	arg0._weapon:updateMovementInfo()

	local var5 = arg0:GetTarget()

	if #var5 > 0 then
		for iter0, iter1 in ipairs(var5) do
			arg0._weapon:SingleFire(iter1, arg0._emitter, var3)
		end
	else
		arg0._weapon:SingleFire(nil, arg0._emitter, var3)
	end
end

function var4.Clear(arg0)
	var4.super.Clear(arg0)

	if arg0._weapon and not arg0._weapon:GetHost():IsAlive() then
		arg0._weapon:Clear()
	end
end

function var4.Interrupt(arg0)
	var4.super.Interrupt(arg0)

	if arg0._weapon then
		arg0._weapon:Cease()
		arg0._weapon:Clear()
	end
end
