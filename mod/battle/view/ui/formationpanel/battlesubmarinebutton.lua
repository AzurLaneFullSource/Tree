ys = ys or {}

local var0 = ys
local var1 = class("BattleSubmarineButton", var0.Battle.BattleWeaponButton)

var0.Battle.BattleSubmarineButton = var1
var1.__name = "BattleSubmarineButton"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.OnCountChange(arg0)
	local var0 = arg0._progressInfo:GetCount()
	local var1 = arg0._progressInfo:GetTotal()

	arg0._countTxt.text = string.format("%d", var0)
end

function var1.ConfigSkin(arg0, arg1)
	var1.super.ConfigSkin(arg0, arg1)
	arg0._progress.gameObject:SetActive(false)
	arg0._filledEffect.gameObject:SetActive(false)
end

function var1.Update(arg0)
	return
end

function var1.updateProgressBar(arg0)
	return
end

function var1.OnfilledEffect(arg0)
	return
end
