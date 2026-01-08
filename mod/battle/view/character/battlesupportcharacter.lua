ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleSupportCharacter = class("BattleSupportCharacter", var0_0.Battle.BattleCharacter)
var0_0.Battle.BattleSupportCharacter.__name = "BattleSupportCharacter"

local var4_0 = var0_0.Battle.BattleSupportCharacter

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
	return
end

function var4_0.UpdateHPBarPosition(arg0_5)
	return
end

function var4_0.SpawnBullet(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = arg0_6._bulletFactoryList[arg1_6:GetTemplate().type]
	local var1_6 = arg0_6._unitData:GetPosition()

	var0_6:CreateBullet(arg0_6._tf, arg1_6, var1_6, arg3_6, arg0_6._unitData:GetDirection())
end

function var4_0.AddFX(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg4_7 then
		arg4_7()
	end
end

function var4_0.updateComponentVisible(arg0_8)
	if arg0_8._unitData:GetIFF() ~= var2_0.FOE_CODE then
		return
	end

	local var0_8 = arg0_8._unitData:GetExposed()
	local var1_8 = arg0_8._unitData:GetDiveDetected()
	local var2_8 = arg0_8._unitData:GetDiveInvisible()
	local var3_8 = var0_8 and (not var2_8 or not not var1_8)

	SetActive(arg0_8._HPBarTf, var3_8)
	SetActive(arg0_8._FXAttachPoint, var3_8)
end

function var4_0.updateComponentDiveInvisible(arg0_9)
	local var0_9 = arg0_9._unitData:GetDiveDetected() and arg0_9._unitData:GetIFF() == var2_0.FOE_CODE
	local var1_9 = arg0_9._unitData:GetDiveInvisible()
	local var2_9
	local var3_9 = (var0_9 or not var1_9) and true or false

	SetActive(arg0_9._HPBarTf, var3_9)
	SetActive(arg0_9._FXAttachPoint, var3_9)
end

function var4_0.Dispose(arg0_10)
	arg0_10:AddShaderColor()
	var4_0.super.Dispose(arg0_10)
end

function var4_0.GetModleID(arg0_11)
	return arg0_11._unitData:GetTemplate().prefab
end

function var4_0.OnAnimatorTrigger(arg0_12)
	arg0_12._unitData:CharacterActionTriggerCallback()
end

function var4_0.OnAnimatorEnd(arg0_13)
	arg0_13._unitData:CharacterActionEndCallback()
end

function var4_0.OnAnimatorStart(arg0_14)
	arg0_14._unitData:CharacterActionStartCallback()
end

function var4_0.UpdateAimBiasBar(arg0_15)
	var4_0.super.UpdateAimBiasBar(arg0_15)

	if arg0_15._fogFx then
		local var0_15 = arg0_15:GetUnitData():GetAimBias():GetCurrentRate()

		arg0_15._fogFx.transform.localScale = Vector3(var0_15, var0_15, 1)
	end
end
