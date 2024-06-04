ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleUnitEvent

var0.Battle.BattleMinionCharacter = class("BattleMinionCharacter", var0.Battle.BattleCharacter)
var0.Battle.BattleMinionCharacter.__name = "BattleMinionCharacter"

local var4 = var0.Battle.BattleMinionCharacter

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)

	arg0._preCastBound = false
end

function var4.RegisterWeaponListener(arg0, arg1)
	var4.super.RegisterWeaponListener(arg0, arg1)
	arg1:RegisterEventListener(arg0, var3.WEAPON_PRE_CAST, arg0.onWeaponPreCast)
	arg1:RegisterEventListener(arg0, var3.WEAPON_PRE_CAST_FINISH, arg0.onWeaponPrecastFinish)
end

function var4.UnregisterWeaponListener(arg0, arg1)
	var4.super.UnregisterWeaponListener(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var3.WEAPON_PRE_CAST)
	arg1:UnregisterEventListener(arg0, var3.WEAPON_PRE_CAST_FINISH)
end

function var4.Update(arg0)
	var4.super.Update(arg0)
	arg0:UpdatePosition()
	arg0:UpdateMatrix()
end

function var4.updateComponentVisible(arg0)
	if arg0._unitData:GetIFF() ~= var2.FOE_CODE then
		return
	end

	local var0 = arg0._unitData:GetExposed()
	local var1 = arg0._unitData:GetDiveDetected()
	local var2 = arg0._unitData:GetDiveInvisible()
	local var3 = var0 and (not var2 or not not var1)

	SetActive(arg0._HPBarTf, var3)
	SetActive(arg0._FXAttachPoint, var3)
end

function var4.updateComponentDiveInvisible(arg0)
	local var0 = arg0._unitData:GetDiveDetected() and arg0._unitData:GetIFF() == var2.FOE_CODE
	local var1 = arg0._unitData:GetDiveInvisible()
	local var2
	local var3 = (var0 or not var1) and true or false

	SetActive(arg0._HPBarTf, var3)
	SetActive(arg0._FXAttachPoint, var3)
end

function var4.Dispose(arg0)
	arg0:AddShaderColor()
	var4.super.Dispose(arg0)
end

function var4.GetModleID(arg0)
	return arg0._unitData:GetTemplate().prefab
end

function var4.onWeaponPreCast(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.fx

	arg0:AddFX(var1, true)

	arg0._preCastBound = var0.isBound
end

function var4.onWeaponPrecastFinish(arg0, arg1)
	local var0 = arg1.Data.fx

	arg0:RemoveCacheFX(var0)

	arg0._preCastBound = false
end

function var4.OnUpdateHP(arg0, arg1)
	var4.super.OnUpdateHP(arg0, arg1)

	if arg1.Data.dHP <= 0 then
		arg0:AddBlink(1, 1, 1, 0.1, 0.1, true)
	end
end

function var4.AddModel(arg0, arg1)
	var4.super.AddModel(arg0, arg1)

	local var0 = arg0._unitData:GetTemplate().hp_bar[2]

	arg0._hpBarOffset = Vector3(0, var0, 0)
end

function var4.GetSpecificFXScale(arg0)
	return arg0._unitData:GetTemplate().specific_fx_scale
end

function var4.OnAnimatorTrigger(arg0)
	arg0._unitData:CharacterActionTriggerCallback()
end

function var4.OnAnimatorEnd(arg0)
	arg0._unitData:CharacterActionEndCallback()
end

function var4.OnAnimatorStart(arg0)
	arg0._unitData:CharacterActionStartCallback()
end

function var4.UpdateAimBiasBar(arg0)
	var4.super.UpdateAimBiasBar(arg0)

	if arg0._fogFx then
		local var0 = arg0:GetUnitData():GetAimBias():GetCurrentRate()

		arg0._fogFx.transform.localScale = Vector3(var0, var0, 1)
	end
end
