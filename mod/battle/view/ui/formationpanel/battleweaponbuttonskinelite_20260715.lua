ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20260715", var0_0.Battle.BattleWeaponButtonSkinElite_20250327)

var0_0.Battle.BattleWeaponButtonSkinElite_20260715 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20260715"

function var1_0.OnTotalChange(arg0_1, arg1_1)
	var1_0.super.OnTotalChange(arg0_1, arg1_1)
	SetActive(arg0_1._glowEff, arg0_1._progressInfo:GetTotal() > 0)
	SetActive(arg0_1._gizmosXue, arg0_1._progressInfo:GetTotal() > 0)
end

function var1_0.ConfigSkin(arg0_2, arg1_2)
	var1_0.super.ConfigSkin(arg0_2, arg1_2)

	arg0_2._glowEff = arg0_2._btn:Find("gizmos_1")
end

function var1_0.OnCountChange(arg0_3)
	var1_0.super.OnCountChange(arg0_3)
	SetActive(arg0_3._glowEff, arg0_3._progressInfo:GetCount() > 0)
	SetActive(arg0_3._gizmosXue, arg0_3._progressInfo:GetCount() > 0)
end

function var1_0.SetToCombatUIPreview(arg0_4, arg1_4)
	if arg1_4 ~= CombatUIPreviewer.WeaponButtonPreviewMode.UNFILLED then
		SetActive(arg0_4._filled, true)
		SetActive(arg0_4._unfill, false)

		arg0_4._progressBar.fillAmount = 1
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
		arg0_4._countTxt.text = "1/1"

		SetActive(arg0_4._glowEff, true)
		SetActive(arg0_4._gizmosXue, true)
		quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_progress_filled")
	else
		SetActive(arg0_4._unfill, true)
		SetActive(arg0_4._filled, false)

		arg0_4._progressBar.fillAmount = 0
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		arg0_4._countTxt.text = "0/0"

		SetActive(arg0_4._gizmos1, false)
		SetActive(arg0_4._gizmosXue, false)
	end
end

function var1_0.updateProgressBar(arg0_5)
	local var0_5 = arg0_5._progressInfo:GetCurrent() / arg0_5._progressInfo:GetMax()

	arg0_5._progressBar.fillAmount = var0_5

	if arg0_5._progressInfo.GetCount and arg0_5._progressInfo:GetCount() > 0 then
		arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
	else
		arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = var0_5
	end
end
