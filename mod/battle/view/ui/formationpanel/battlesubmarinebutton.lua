ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSubmarineButton", var0_0.Battle.BattleWeaponButton)

var0_0.Battle.BattleSubmarineButton = var1_0
var1_0.__name = "BattleSubmarineButton"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.OnCountChange(arg0_2)
	local var0_2 = arg0_2._progressInfo:GetCount()
	local var1_2 = arg0_2._progressInfo:GetTotal()

	arg0_2._countTxt.text = string.format("%d", var0_2)
end

function var1_0.ConfigSkin(arg0_3, arg1_3)
	var1_0.super.ConfigSkin(arg0_3, arg1_3)
	arg0_3._progress.gameObject:SetActive(false)
	arg0_3._filledEffect.gameObject:SetActive(false)
end

function var1_0.ConfigCallback(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local function var0_4()
		arg2_4()
		quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_use")
	end

	var1_0.super.ConfigCallback(arg0_4, arg1_4, var0_4, arg3_4, arg4_4)
end

function var1_0.Update(arg0_6)
	return
end

function var1_0.updateProgressBar(arg0_7)
	return
end

function var1_0.OnfilledEffect(arg0_8)
	return
end
