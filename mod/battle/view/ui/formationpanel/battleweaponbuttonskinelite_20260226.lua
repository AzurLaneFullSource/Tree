ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20260226", var0_0.Battle.BattleWeaponButtonSkinElite_20250520)

var0_0.Battle.BattleWeaponButtonSkinElite_20260226 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20260226"

function var1_0.ConfigSkin(arg0_1, arg1_1)
	var1_0.super.ConfigSkin(arg0_1, arg1_1)

	arg0_1._books = arg0_1._selected:Find("usdfx/fx/up/book/book/book1")
	arg0_1._bookList = {}

	for iter0_1 = 1, 4 do
		table.insert(arg0_1._bookList, arg0_1._books:Find("text_" .. iter0_1))
	end
end

function var1_0.OnCountChange(arg0_2)
	var1_0.super.OnCountChange(arg0_2)
	SetActive(arg0_2._gizmos1, arg0_2._progressInfo:GetCount() > 0)
	SetActive(arg0_2._gizmosXue, arg0_2._progressInfo:GetCount() > 0)
end

function var1_0.SetToCombatUIPreview(arg0_3, arg1_3)
	if arg1_3 ~= CombatUIPreviewer.WeaponButtonPreviewMode.UNFILLED then
		SetActive(arg0_3._filled, true)
		SetActive(arg0_3._unfill, false)

		arg0_3._progressBar.fillAmount = 1
		arg0_3._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
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
		arg0_3._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
		arg0_3._countTxt.text = "0/0"

		SetActive(arg0_3._glowEff, false)

		if arg0_3._gizmos1 then
			SetActive(arg0_3._gizmos1, false)
			SetActive(arg0_3._gizmosXue, false)
		end
	end
end

function var1_0.OnOverLoadChange(arg0_4, arg1_4)
	if arg1_4 and arg1_4.Data and arg1_4.Data.postCast then
		local var0_4 = math.random(4)

		for iter0_4, iter1_4 in ipairs(arg0_4._bookList) do
			SetActive(iter1_4, iter0_4 == var0_4)
		end
	end

	var1_0.super.OnOverLoadChange(arg0_4, arg1_4)
end

function var1_0.updateProgressBar(arg0_5)
	local var0_5 = arg0_5._progressInfo:GetCurrent() / arg0_5._progressInfo:GetMax()

	arg0_5._progressBar.fillAmount = var0_5

	if arg0_5._bgEff then
		if arg0_5._progressInfo.GetCount and arg0_5._progressInfo:GetCount() > 0 then
			arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		else
			arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1 - var0_5
		end
	end
end
