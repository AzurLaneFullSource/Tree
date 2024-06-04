ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent

var0.Battle.BattleEnemyCharacter = class("BattleEnemyCharacter", var0.Battle.BattleCharacter)
var0.Battle.BattleEnemyCharacter.__name = "BattleEnemyCharacter"

local var2 = var0.Battle.BattleEnemyCharacter

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)

	arg0._preCastBound = false
	arg0._prefabPos = Vector3(0, 0, 0)
end

function var2.RegisterWeaponListener(arg0, arg1)
	var2.super.RegisterWeaponListener(arg0, arg1)
	arg1:RegisterEventListener(arg0, var1.WEAPON_PRE_CAST, arg0.onWeaponPreCast)
	arg1:RegisterEventListener(arg0, var1.WEAPON_PRE_CAST_FINISH, arg0.onWeaponPrecastFinish)
	arg1:RegisterEventListener(arg0, var1.WEAPON_INTERRUPT, arg0.onWeaponInterrupted)
end

function var2.UnregisterWeaponListener(arg0, arg1)
	var2.super.UnregisterWeaponListener(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.WEAPON_PRE_CAST)
	arg1:UnregisterEventListener(arg0, var1.WEAPON_PRE_CAST_FINISH)
	arg1:UnregisterEventListener(arg0, var1.WEAPON_INTERRUPT)
end

function var2.Update(arg0)
	var2.super.Update(arg0)
	arg0:UpdatePosition()
	arg0:UpdateMatrix()
	arg0:UpdateArrowBarPostition()
	arg0:UpdateArrowBarRotation()

	if arg0._vigilantBar then
		arg0:UpdateVigilantBarPosition()
		arg0._vigilantBar:UpdateVigilantProgress()
	end
end

function var2.Dispose(arg0)
	if arg0._vigilantBar then
		arg0._vigilantBar:Dispose()

		arg0._vigilantBar = nil
	end

	arg0:AddShaderColor()
	arg0._factory:GetArrowPool():DestroyObj(arg0._arrowBar)
	var2.super.Dispose(arg0)
end

function var2.GetModleID(arg0)
	return arg0._unitData:GetTemplate().prefab
end

function var2.onWeaponPreCast(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.fx

	arg0:AddFX(var1, true)

	arg0._preCastBound = var0.isBound
end

function var2.onWeaponPrecastFinish(arg0, arg1)
	local var0 = arg1.Data.fx

	arg0:RemoveCacheFX(var0)

	arg0._preCastBound = false
end

function var2.OnUpdateHP(arg0, arg1)
	var2.super.OnUpdateHP(arg0, arg1)

	if arg1.Data.dHP <= 0 then
		arg0:AddBlink(1, 1, 1, 0.1, 0.1, true)
	end
end

function var2.AddModel(arg0, arg1)
	var2.super.AddModel(arg0, arg1)

	local var0 = arg0._unitData:GetTemplate().hp_bar[2]

	arg0._hpBarOffset = Vector3(0, var0, 0)
end

function var2.GetSpecificFXScale(arg0)
	return arg0._unitData:GetTemplate().specific_fx_scale
end

function var2.OnAnimatorTrigger(arg0)
	arg0._unitData:CharacterActionTriggerCallback()
end

function var2.OnAnimatorEnd(arg0)
	arg0._unitData:CharacterActionEndCallback()
end

function var2.OnAnimatorStart(arg0)
	arg0._unitData:CharacterActionStartCallback()
end

function var2.UpdateAimBiasBar(arg0)
	var2.super.UpdateAimBiasBar(arg0)

	if arg0._fogFx then
		local var0 = arg0:GetUnitData():GetAimBias():GetCurrentRate()

		arg0._fogFx.transform.localScale = Vector3(var0, var0, 1)
	end
end

function var2.getCharacterPos(arg0)
	local var0 = arg0:GetUnitData():GetTemplate().prefab_offset

	arg0._prefabPos:Set(arg0._characterPos.x + var0[1], arg0._characterPos.y + var0[2], arg0._characterPos.z + var0[3])

	return arg0._prefabPos
end
