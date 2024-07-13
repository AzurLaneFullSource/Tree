ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleMinionCharacter = class("BattleMinionCharacter", var0_0.Battle.BattleCharacter)
var0_0.Battle.BattleMinionCharacter.__name = "BattleMinionCharacter"

local var4_0 = var0_0.Battle.BattleMinionCharacter

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)

	arg0_1._preCastBound = false
end

function var4_0.RegisterWeaponListener(arg0_2, arg1_2)
	var4_0.super.RegisterWeaponListener(arg0_2, arg1_2)
	arg1_2:RegisterEventListener(arg0_2, var3_0.WEAPON_PRE_CAST, arg0_2.onWeaponPreCast)
	arg1_2:RegisterEventListener(arg0_2, var3_0.WEAPON_PRE_CAST_FINISH, arg0_2.onWeaponPrecastFinish)
end

function var4_0.UnregisterWeaponListener(arg0_3, arg1_3)
	var4_0.super.UnregisterWeaponListener(arg0_3, arg1_3)
	arg1_3:UnregisterEventListener(arg0_3, var3_0.WEAPON_PRE_CAST)
	arg1_3:UnregisterEventListener(arg0_3, var3_0.WEAPON_PRE_CAST_FINISH)
end

function var4_0.Update(arg0_4)
	var4_0.super.Update(arg0_4)
	arg0_4:UpdatePosition()
	arg0_4:UpdateMatrix()
end

function var4_0.updateComponentVisible(arg0_5)
	if arg0_5._unitData:GetIFF() ~= var2_0.FOE_CODE then
		return
	end

	local var0_5 = arg0_5._unitData:GetExposed()
	local var1_5 = arg0_5._unitData:GetDiveDetected()
	local var2_5 = arg0_5._unitData:GetDiveInvisible()
	local var3_5 = var0_5 and (not var2_5 or not not var1_5)

	SetActive(arg0_5._HPBarTf, var3_5)
	SetActive(arg0_5._FXAttachPoint, var3_5)
end

function var4_0.updateComponentDiveInvisible(arg0_6)
	local var0_6 = arg0_6._unitData:GetDiveDetected() and arg0_6._unitData:GetIFF() == var2_0.FOE_CODE
	local var1_6 = arg0_6._unitData:GetDiveInvisible()
	local var2_6
	local var3_6 = (var0_6 or not var1_6) and true or false

	SetActive(arg0_6._HPBarTf, var3_6)
	SetActive(arg0_6._FXAttachPoint, var3_6)
end

function var4_0.Dispose(arg0_7)
	arg0_7:AddShaderColor()
	var4_0.super.Dispose(arg0_7)
end

function var4_0.GetModleID(arg0_8)
	return arg0_8._unitData:GetTemplate().prefab
end

function var4_0.onWeaponPreCast(arg0_9, arg1_9)
	local var0_9 = arg1_9.Data
	local var1_9 = var0_9.fx

	arg0_9:AddFX(var1_9, true)

	arg0_9._preCastBound = var0_9.isBound
end

function var4_0.onWeaponPrecastFinish(arg0_10, arg1_10)
	local var0_10 = arg1_10.Data.fx

	arg0_10:RemoveCacheFX(var0_10)

	arg0_10._preCastBound = false
end

function var4_0.OnUpdateHP(arg0_11, arg1_11)
	var4_0.super.OnUpdateHP(arg0_11, arg1_11)

	if arg1_11.Data.dHP <= 0 then
		arg0_11:AddBlink(1, 1, 1, 0.1, 0.1, true)
	end
end

function var4_0.AddModel(arg0_12, arg1_12)
	var4_0.super.AddModel(arg0_12, arg1_12)

	local var0_12 = arg0_12._unitData:GetTemplate().hp_bar[2]

	arg0_12._hpBarOffset = Vector3(0, var0_12, 0)
end

function var4_0.GetSpecificFXScale(arg0_13)
	return arg0_13._unitData:GetTemplate().specific_fx_scale
end

function var4_0.OnAnimatorTrigger(arg0_14)
	arg0_14._unitData:CharacterActionTriggerCallback()
end

function var4_0.OnAnimatorEnd(arg0_15)
	arg0_15._unitData:CharacterActionEndCallback()
end

function var4_0.OnAnimatorStart(arg0_16)
	arg0_16._unitData:CharacterActionStartCallback()
end

function var4_0.UpdateAimBiasBar(arg0_17)
	var4_0.super.UpdateAimBiasBar(arg0_17)

	if arg0_17._fogFx then
		local var0_17 = arg0_17:GetUnitData():GetAimBias():GetCurrentRate()

		arg0_17._fogFx.transform.localScale = Vector3(var0_17, var0_17, 1)
	end
end
