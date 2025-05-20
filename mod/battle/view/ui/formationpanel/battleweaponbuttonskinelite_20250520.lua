ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20250520", var0_0.Battle.BattleWeaponButtonSkinNormal_20250227)

var0_0.Battle.BattleWeaponButtonSkinElite_20250520 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20250520"

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

function var1_0.OnOverLoadChange(arg0_4, arg1_4)
	if arg0_4._progressInfo:GetCount() < 1 then
		arg0_4._block:SetActive(true)
		arg0_4:OnUnfill()
	else
		arg0_4._block:SetActive(false)
		arg0_4:OnFilled()

		if arg1_4 and arg1_4.Data then
			local var0_4 = arg1_4.Data.preCast

			if var0_4 then
				if var0_4 == 0 then
					quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_progress_filled")
				elseif var0_4 > 0 then
					quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_progress_charge")
				end
			end
		end
	end

	if arg1_4 and arg1_4.Data and arg1_4.Data.postCast then
		quickCheckAndPlayAnimator(arg0_4._skin, "weapon_button_progress_use")
	end

	if arg0_4._progressInfo:GetTotal() > 0 then
		arg0_4:updateProgressBar()
	end
end
