ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleEnemyCharacter = class("BattleEnemyCharacter", var0_0.Battle.BattleCharacter)
var0_0.Battle.BattleEnemyCharacter.__name = "BattleEnemyCharacter"

local var2_0 = var0_0.Battle.BattleEnemyCharacter

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)

	arg0_1._preCastBound = false
	arg0_1._prefabPos = Vector3(0, 0, 0)
end

function var2_0.RegisterWeaponListener(arg0_2, arg1_2)
	var2_0.super.RegisterWeaponListener(arg0_2, arg1_2)
	arg1_2:RegisterEventListener(arg0_2, var1_0.WEAPON_PRE_CAST, arg0_2.onWeaponPreCast)
	arg1_2:RegisterEventListener(arg0_2, var1_0.WEAPON_PRE_CAST_FINISH, arg0_2.onWeaponPrecastFinish)
	arg1_2:RegisterEventListener(arg0_2, var1_0.WEAPON_INTERRUPT, arg0_2.onWeaponInterrupted)
end

function var2_0.UnregisterWeaponListener(arg0_3, arg1_3)
	var2_0.super.UnregisterWeaponListener(arg0_3, arg1_3)
	arg1_3:UnregisterEventListener(arg0_3, var1_0.WEAPON_PRE_CAST)
	arg1_3:UnregisterEventListener(arg0_3, var1_0.WEAPON_PRE_CAST_FINISH)
	arg1_3:UnregisterEventListener(arg0_3, var1_0.WEAPON_INTERRUPT)
end

function var2_0.Update(arg0_4)
	var2_0.super.Update(arg0_4)
	arg0_4:UpdatePosition()
	arg0_4:UpdateMatrix()
	arg0_4:UpdateArrowBarPostition()
	arg0_4:UpdateArrowBarRotation()

	if arg0_4._vigilantBar then
		arg0_4:UpdateVigilantBarPosition()
		arg0_4._vigilantBar:UpdateVigilantProgress()
	end
end

function var2_0.Dispose(arg0_5)
	if arg0_5._vigilantBar then
		arg0_5._vigilantBar:Dispose()

		arg0_5._vigilantBar = nil
	end

	arg0_5:AddShaderColor()
	arg0_5._factory:GetArrowPool():DestroyObj(arg0_5._arrowBar)
	var2_0.super.Dispose(arg0_5)
end

function var2_0.GetModleID(arg0_6)
	return arg0_6._unitData:GetTemplate().prefab
end

function var2_0.onWeaponPreCast(arg0_7, arg1_7)
	local var0_7 = arg1_7.Data
	local var1_7 = var0_7.fx

	arg0_7:AddFX(var1_7, true)

	arg0_7._preCastBound = var0_7.isBound
end

function var2_0.onWeaponPrecastFinish(arg0_8, arg1_8)
	local var0_8 = arg1_8.Data.fx

	arg0_8:RemoveCacheFX(var0_8)

	arg0_8._preCastBound = false
end

function var2_0.OnUpdateHP(arg0_9, arg1_9)
	var2_0.super.OnUpdateHP(arg0_9, arg1_9)

	if arg1_9.Data.dHP <= 0 then
		arg0_9:AddBlink(1, 1, 1, 0.1, 0.1, true)
	end
end

function var2_0.AddModel(arg0_10, arg1_10)
	var2_0.super.AddModel(arg0_10, arg1_10)

	local var0_10 = arg0_10._unitData:GetTemplate().hp_bar[2]

	arg0_10._hpBarOffset = Vector3(0, var0_10, 0)
end

function var2_0.GetSpecificFXScale(arg0_11)
	return arg0_11._unitData:GetTemplate().specific_fx_scale
end

function var2_0.OnAnimatorTrigger(arg0_12)
	arg0_12._unitData:CharacterActionTriggerCallback()
end

function var2_0.OnAnimatorEnd(arg0_13)
	arg0_13._unitData:CharacterActionEndCallback()
end

function var2_0.OnAnimatorStart(arg0_14)
	arg0_14._unitData:CharacterActionStartCallback()
end

function var2_0.UpdateAimBiasBar(arg0_15)
	var2_0.super.UpdateAimBiasBar(arg0_15)

	if arg0_15._fogFx then
		local var0_15 = arg0_15:GetUnitData():GetAimBias():GetCurrentRate()

		arg0_15._fogFx.transform.localScale = Vector3(var0_15, var0_15, 1)
	end
end

function var2_0.getCharacterPos(arg0_16)
	local var0_16 = arg0_16:GetUnitData():GetTemplate().prefab_offset

	arg0_16._prefabPos:Set(arg0_16._characterPos.x + var0_16[1], arg0_16._characterPos.y + var0_16[2], arg0_16._characterPos.z + var0_16[3])

	return arg0_16._prefabPos
end
