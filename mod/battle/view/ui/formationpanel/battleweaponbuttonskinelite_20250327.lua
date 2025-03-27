ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20250327", var0_0.Battle.BattleWeaponButton)

var0_0.Battle.BattleWeaponButtonSkinElite_20250327 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20250327"

function var1_0.OnTotalChange(arg0_1, arg1_1)
	if arg0_1._progressInfo:GetTotal() <= 0 then
		arg0_1._block:SetActive(true)

		arg0_1._progressBar.fillAmount = 0
		arg0_1._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
		arg0_1._text:GetComponent(typeof(Text)).text = "0/0"

		arg0_1:SetControllerActive(false)
		SetActive(arg0_1._glowEff, false)
		arg0_1:OnUnfill()
		arg0_1:OnUnSelect()
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

function var1_0.ConfigSkin(arg0_2, arg1_2)
	var1_0.super.ConfigSkin(arg0_2, arg1_2)

	arg0_2._glowEff = arg0_2._btn:Find("gizmos_1")
end

function var1_0.OnCountChange(arg0_3)
	var1_0.super.OnCountChange(arg0_3)
	SetActive(arg0_3._glowEff, arg0_3._progressInfo:GetCount() > 0)
end

function var1_0.SetToCombatUIPreview(arg0_4, arg1_4)
	if arg1_4 then
		SetActive(arg0_4._filled, true)
		SetActive(arg0_4._unfill, false)

		arg0_4._progressBar.fillAmount = 1
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		arg0_4._countTxt.text = "1/1"

		if arg0_4._chargeEff then
			SetActive(arg0_4._chargeEff, true)
			SetActive(arg0_4._fullChargeEff, true)
		end

		SetActive(arg0_4._glowEff, true)
		quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_progress_filled")
	else
		SetActive(arg0_4._unfill, true)
		SetActive(arg0_4._filled, false)

		arg0_4._progressBar.fillAmount = 0
		arg0_4._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
		arg0_4._countTxt.text = "0/0"

		SetActive(arg0_4._glowEff, false)

		if arg0_4._chargeEff then
			SetActive(arg0_4._chargeEff, false)
			SetActive(arg0_4._fullChargeEff, false)
		end
	end
end

function var1_0.updateProgressBar(arg0_5)
	local var0_5 = arg0_5._progressInfo:GetCurrent() / arg0_5._progressInfo:GetMax()

	arg0_5._progressBar.fillAmount = var0_5

	if arg0_5._progressInfo.GetCount and arg0_5._progressInfo:GetCount() > 0 then
		arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
	else
		arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1 - var0_5
	end
end

function var1_0.OnOverLoadChange(arg0_6, arg1_6)
	if arg0_6._progressInfo:GetCount() < 1 then
		arg0_6._block:SetActive(true)
		arg0_6:OnUnfill()
	else
		arg0_6._block:SetActive(false)
		arg0_6:OnFilled()

		if arg1_6 and arg1_6.Data then
			local var0_6 = arg1_6.Data.preCast

			if var0_6 then
				if var0_6 == 0 then
					quickCheckAndPlayAnimator(arg0_6._skin, "weapon_button_progress_filled")
				elseif var0_6 > 0 then
					quickCheckAndPlayAnimator(arg0_6._skin, "weapon_button_progress_charge")
				end
			end
		end
	end

	if arg1_6 and arg1_6.Data and arg1_6.Data.postCast then
		quickCheckAndPlayAnimator(arg0_6._skin, "weapon_button_progress_use")
	end

	if arg0_6._progressInfo:GetTotal() > 0 then
		arg0_6:updateProgressBar()
	end
end
