ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20251218", var0_0.Battle.BattleWeaponButtonSkinElite_20250520)

var0_0.Battle.BattleWeaponButtonSkinElite_20251218 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20251218"

function var1_0.OnTotalChange(arg0_1, arg1_1)
	if arg0_1._progressInfo:GetTotal() <= 0 then
		arg0_1._block:SetActive(true)

		arg0_1._progressBar.fillAmount = 0
		arg0_1._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		arg0_1._text:GetComponent(typeof(Text)).text = "0/0"

		arg0_1:SetControllerActive(false)
		SetActive(arg0_1._glowEff, false)
		arg0_1:OnUnfill()
		arg0_1:OnUnSelect()
		SetActive(arg0_1._gizmos1, false)
		SetActive(arg0_1._gizmosXue, false)
	else
		if arg0_1._progressInfo:GetTotal() == arg0_1._progressInfo:GetCount() then
			SetActive(arg0_1._glowEff, true)
		end

		arg0_1:OnCountChange()
		arg0_1:SetControllerActive(true)

		if arg1_1 then
			local var0_1 = arg1_1.Data.index

			if var0_1 and var0_1 == 1 then
				arg0_1:OnUnSelect()
			end
		end
	end
end

function var1_0.OnCountChange(arg0_2)
	var1_0.super.OnCountChange(arg0_2)
	SetActive(arg0_2._gizmosXue, arg0_2._progressInfo:GetCount() > 0)
end

function var1_0.SetToCombatUIPreview(arg0_3, arg1_3)
	if arg1_3 ~= CombatUIPreviewer.WeaponButtonPreviewMode.UNFILLED then
		SetActive(arg0_3._filled, true)
		SetActive(arg0_3._unfill, false)

		arg0_3._progressBar.fillAmount = 1
		arg0_3._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
		arg0_3._countTxt.text = "1/1"

		if arg0_3._gizmos1 then
			SetActive(arg0_3._gizmos1, true)
			SetActive(arg0_3._gizmosXue, true)
		end

		SetActive(arg0_3._glowEff, true)
		quickCheckAndPlayAnimator(arg0_3._skin, "weapon_button_progress_filled")
	else
		SetActive(arg0_3._unfill, true)
		SetActive(arg0_3._filled, false)

		arg0_3._progressBar.fillAmount = 0
		arg0_3._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		arg0_3._countTxt.text = "0/0"

		SetActive(arg0_3._glowEff, false)

		if arg0_3._gizmos1 then
			SetActive(arg0_3._gizmos1, false)
			SetActive(arg0_3._gizmosXue, false)
		end
	end
end

function var1_0.updateProgressBar(arg0_4)
	local var0_4 = arg0_4._progressInfo:GetCurrent() / arg0_4._progressInfo:GetMax()

	arg0_4._progressBar.fillAmount = var0_4

	if arg0_4._progressInfo.GetCount and arg0_4._progressInfo:GetCount() > 0 then
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
	else
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = var0_4
	end
end
