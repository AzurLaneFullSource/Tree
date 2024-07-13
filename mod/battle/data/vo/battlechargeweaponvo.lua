ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleConst.EquipmentType

var0_0.Battle.BattleChargeWeaponVO = class("BattleChargeWeaponVO", var0_0.Battle.BattlePlayerWeaponVO)
var0_0.Battle.BattleChargeWeaponVO.__name = "BattleChargeWeaponVO"

local var3_0 = var0_0.Battle.BattleChargeWeaponVO

var3_0.GCD = var1_0.ChargeWeaponConfig.GCD

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1, var3_0.GCD)
end

function var3_0.AppendWeapon(arg0_2, arg1_2)
	var3_0.super.AppendWeapon(arg0_2, arg1_2)
	arg1_2:SetPlayerChargeWeaponVO(arg0_2)
end

function var3_0.GetCurrentWeaponIconIndex(arg0_3)
	local var0_3 = arg0_3:GetHeadWeapon()

	if var0_3 == nil then
		return 1
	else
		local var1_3 = var0_3:GetType()

		if var1_3 == var2_0.POINT_HIT_AND_LOCK then
			return 1
		elseif var1_3 == var2_0.MANUAL_MISSILE then
			return 10
		elseif var1_3 == var2_0.MANUAL_METEOR then
			return 11
		end
	end
end

function var3_0.Deduct(arg0_4, arg1_4)
	var3_0.super.Deduct(arg0_4, arg1_4)
	arg0_4:ResetFocus()
end

function var3_0.ResetFocus(arg0_5)
	if arg0_5._focus then
		local var0_5 = var0_0.Battle.BattleCameraUtil.GetInstance()

		var0_5:FocusCharacter(nil, var1_0.CAST_CAM_ZOOM_OUT_DURATION_CANNON, var1_0.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_CANNON)
		var0_5:ZoomCamara(var1_0.CAST_CAM_ZOOM_SIZE, var1_0.CAST_CAM_OVERLOOK_SIZE, var1_0.CAST_CAM_ZOOM_OUT_DURATION_CANNON)

		local var1_5 = var1_0.CAST_CAM_ZOOM_OUT_DURATION_CANNON + var1_0.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_CANNON

		LeanTween.delayedCall(go(var0_5:GetCamera()), var1_5, System.Action(function()
			arg0_5._focus = false

			var0_5:BulletTime(var1_0.SPEED_FACTOR_FOCUS_CHARACTER, nil)
			var0_5:ZoomCamara(nil, nil, var1_0.CAST_CAM_OVERLOOK_REVERT_DURATION)
		end))
	end
end
