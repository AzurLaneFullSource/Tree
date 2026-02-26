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

function var1_0.OnCountChange(arg0_2)
	var1_0.super.OnCountChange(arg0_2)
	SetActive(arg0_2._gizmos1, arg0_2._progressInfo:GetCount() > 0)
end

function var1_0.OnOverLoadChange(arg0_3, arg1_3)
	if arg0_3._progressInfo:IsOverLoad() then
		arg0_3._block:SetActive(true)
		arg0_3:OnUnfill()
	else
		arg0_3._block:SetActive(false)
		arg0_3:OnFilled()
	end

	if arg0_3._progressInfo:GetCount() >= 1 and arg1_3 and arg1_3.Data then
		local var0_3 = arg1_3.Data.preCast

		if var0_3 then
			if var0_3 == 0 then
				quickCheckAndPlayAnimator(arg0_3._skin, "weapon_button_progress_filled")
			elseif var0_3 > 0 then
				quickCheckAndPlayAnimator(arg0_3._skin, "weapon_button_progress_charge")
			end
		end
	end

	if arg1_3 and arg1_3.Data and arg1_3.Data.postCast then
		quickCheckAndPlayAnimator(arg0_3._skin, "weapon_button_progress_use")
	end

	if arg0_3._progressInfo:GetTotal() > 0 then
		arg0_3:updateProgressBar()
	end
end
