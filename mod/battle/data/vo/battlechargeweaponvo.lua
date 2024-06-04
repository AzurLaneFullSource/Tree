ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleConst.EquipmentType

var0.Battle.BattleChargeWeaponVO = class("BattleChargeWeaponVO", var0.Battle.BattlePlayerWeaponVO)
var0.Battle.BattleChargeWeaponVO.__name = "BattleChargeWeaponVO"

local var3 = var0.Battle.BattleChargeWeaponVO

var3.GCD = var1.ChargeWeaponConfig.GCD

function var3.Ctor(arg0)
	var3.super.Ctor(arg0, var3.GCD)
end

function var3.AppendWeapon(arg0, arg1)
	var3.super.AppendWeapon(arg0, arg1)
	arg1:SetPlayerChargeWeaponVO(arg0)
end

function var3.GetCurrentWeaponIconIndex(arg0)
	local var0 = arg0:GetHeadWeapon()

	if var0 == nil then
		return 1
	else
		local var1 = var0:GetType()

		if var1 == var2.POINT_HIT_AND_LOCK then
			return 1
		elseif var1 == var2.MANUAL_MISSILE then
			return 10
		elseif var1 == var2.MANUAL_METEOR then
			return 11
		end
	end
end

function var3.Deduct(arg0, arg1)
	var3.super.Deduct(arg0, arg1)
	arg0:ResetFocus()
end

function var3.ResetFocus(arg0)
	if arg0._focus then
		local var0 = var0.Battle.BattleCameraUtil.GetInstance()

		var0:FocusCharacter(nil, var1.CAST_CAM_ZOOM_OUT_DURATION_CANNON, var1.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_CANNON)
		var0:ZoomCamara(var1.CAST_CAM_ZOOM_SIZE, var1.CAST_CAM_OVERLOOK_SIZE, var1.CAST_CAM_ZOOM_OUT_DURATION_CANNON)

		local var1 = var1.CAST_CAM_ZOOM_OUT_DURATION_CANNON + var1.CAST_CAM_ZOOM_OUT_EXTRA_DELAY_CANNON

		LeanTween.delayedCall(go(var0:GetCamera()), var1, System.Action(function()
			arg0._focus = false

			var0:BulletTime(var1.SPEED_FACTOR_FOCUS_CHARACTER, nil)
			var0:ZoomCamara(nil, nil, var1.CAST_CAM_OVERLOOK_REVERT_DURATION)
		end))
	end
end
