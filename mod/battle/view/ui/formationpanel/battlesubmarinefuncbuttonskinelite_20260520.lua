ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSubmarineFuncButtonSkinElite_20260520", var0_0.Battle.BattleSubmarineFuncButton)

var0_0.Battle.BattleSubmarineFuncButtonSkinElite_20260520 = var1_0
var1_0.__name = "BattleSubmarineFuncButtonSkinElite_20260520"

local var2_0 = 1

function var1_0.ConfigSkin(arg0_1, arg1_1)
	var1_0.super.ConfigSkin(arg0_1, arg1_1)

	arg0_1._bgEffAni = arg0_1._bgEff:GetComponent(typeof(Animator))

	local var0_1 = arg0_1._bgEffAni.runtimeAnimatorController.animationClips[0]

	arg0_1._bgEffAniClipTotalFrames = math.max(1, math.floor(var0_1.length * var0_1.frameRate + 0.5))
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

function var1_0.updateProgressBar(arg0_5)
	local var0_5 = arg0_5._progressInfo:GetCurrent() / arg0_5._progressInfo:GetMax()

	arg0_5._progressBar.fillAmount = var0_5

	if arg0_5._progressInfo.GetCount and arg0_5._progressInfo:GetCount() > 0 then
		arg0_5:updateProgressBG(1, arg0_5._progressInfo:GetMax())
	else
		arg0_5._bgEffAni.enabled = true

		arg0_5:updateProgressBG(var0_5, arg0_5._progressInfo:GetMax())
	end
end

function var1_0.updateProgressBG(arg0_6, arg1_6, arg2_6)
	arg1_6 = Mathf.Clamp01(arg1_6)

	local var0_6 = arg0_6._bgEffAniClipTotalFrames - 1
	local var1_6 = arg1_6 * var0_6
	local var2_6

	if arg2_6 and arg2_6 > var2_0 then
		local var3_6 = math.floor(var1_6)
		local var4_6 = math.min(var0_6, var3_6 + 1)
		local var5_6 = var1_6 - var3_6

		var2_6 = (var3_6 + (var4_6 - var3_6) * var5_6) / var0_6
	else
		var2_6 = math.floor(var1_6 + 0.5) / var0_6
	end

	arg0_6._bgEffAni.speed = 1

	arg0_6._bgEffAni:Play("skinui_button_bg", 0, var2_6)
	arg0_6._bgEffAni:Update(0)

	arg0_6._bgEffAni.speed = 0
end
