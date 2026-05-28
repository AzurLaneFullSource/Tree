ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSubmarineButtonSkinElite_20260520", var0_0.Battle.BattleSubmarineButton)

var0_0.Battle.BattleSubmarineButtonSkinElite_20260520 = var1_0
var1_0.__name = "BattleSubmarineButtonSkinElite_20260520"

function var1_0.ConfigSkin(arg0_1, arg1_1)
	var1_0.super.ConfigSkin(arg0_1, arg1_1)

	arg0_1._unfill = arg0_1._icon:Find("unfill/unfill")
	arg0_1._unfillShade = arg0_1._icon:Find("unfill/unfill_1")
end

function var1_0.OnFilled(arg0_2)
	var1_0.super.OnFilled(arg0_2)
	SetActive(arg0_2._unfillShade, false)
end

function var1_0.OnUnfill(arg0_3)
	var1_0.super.OnUnfill(arg0_3)
	SetActive(arg0_3._unfillShade, true)
end

function var1_0.SwitchIcon(arg0_4, arg1_4, arg2_4)
	local var0_4, var1_4 = var1_0.super.SwitchIcon(arg0_4, arg1_4, arg2_4)

	setImageSprite(arg0_4._unfillShade, LoadSprite("ui/CombatUI" .. var0_4 .. "_atlas", "weapon_unfill_" .. var1_4))
end
