ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20260520", var0_0.Battle.BattleWeaponButtonSkinElite_20250520)

var0_0.Battle.BattleWeaponButtonSkinElite_20260520 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20260520"

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

function var1_0.OnTotalChange(arg0_5, arg1_5)
	if arg0_5._progressInfo:GetTotal() <= 0 then
		arg0_5._block:SetActive(true)

		arg0_5._progressBar.fillAmount = 0
		arg0_5._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 0
		arg0_5._text:GetComponent(typeof(Text)).text = "0/0"

		arg0_5:SetControllerActive(false)
		SetActive(arg0_5._glowEff, false)
		arg0_5:OnUnfill()
		arg0_5:OnUnSelect()
		SetActive(arg0_5._gizmos1, false)
		SetActive(arg0_5._gizmosXue, false)
	else
		arg0_5:OnCountChange()
		arg0_5:SetControllerActive(true)

		if arg1_5 then
			local var0_5 = arg1_5.Data.index

			if var0_5 and var0_5 == 1 then
				arg0_5:OnUnSelect()
			end
		end
	end
end

function var1_0.OnCountChange(arg0_6)
	var1_0.super.OnCountChange(arg0_6)
	SetActive(arg0_6._gizmosXue, arg0_6._progressInfo:GetCount() > 0)
	SetActive(arg0_6._glowEff, arg0_6._progressInfo:GetCount() > 0)
end

function var1_0.StopCombatUIPreviewLoop(arg0_7)
	if arg0_7._skin then
		LeanTween.cancel(go(arg0_7._skin))
	end
end

function var1_0.ApplyCombatUIPreviewState(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = 2

	SetActive(arg0_8._filled, not arg3_8 and arg1_8 > 0)
	SetActive(arg0_8._unfill, arg3_8 or arg1_8 <= 0)
	SetActive(arg0_8._unfillShade, arg3_8 or arg1_8 <= 0)

	arg0_8._progressBar.fillAmount = arg2_8
	arg0_8._bgEff:GetComponent(typeof(CanvasGroup)).alpha = (arg3_8 or arg1_8 > 0) and 1 or 0
	arg0_8._countTxt.text = arg1_8 .. "/" .. var0_8

	if arg0_8._gizmos1 then
		SetActive(arg0_8._gizmos1, arg1_8 > 0)
		SetActive(arg0_8._gizmosXue, arg1_8 > 0)
	end

	SetActive(arg0_8._glowEff, arg1_8 > 0)

	arg0_8._bgEffAni.enabled = true

	arg0_8:updateProgressBG(arg2_8, 5)
end

function var1_0.StartCombatUIPreviewLoop(arg0_9)
	local var0_9 = go(arg0_9._skin)

	local function var1_9()
		arg0_9:ApplyCombatUIPreviewState(0, 0, true)
		LeanTween.value(var0_9, 0, 1, 5):setOnUpdate(System.Action_float(function(arg0_11)
			arg0_9:ApplyCombatUIPreviewState(0, arg0_11, true)
		end)):setOnComplete(System.Action(function()
			arg0_9:ApplyCombatUIPreviewState(2, 1, false)
			quickCheckAndPlayAnimator(arg0_9._skin, "weapon_button_progress_filled")
			LeanTween.delayedCall(var0_9, 3, System.Action(function()
				arg0_9:ApplyCombatUIPreviewState(1, 1, false)
				quickCheckAndPlayAnimator(arg0_9._skin, "weapon_button_progress_use")
				LeanTween.delayedCall(var0_9, 3, System.Action(function()
					arg0_9:ApplyCombatUIPreviewState(0, 0, false)
					quickCheckAndPlayAnimator(arg0_9._skin, "weapon_button_progress_use")
					LeanTween.delayedCall(var0_9, 3, System.Action(function()
						var1_9()
					end))
				end))
			end))
		end))
	end

	var1_9()
end

function var1_0.SetToCombatUIPreview(arg0_16, arg1_16)
	arg0_16:StopCombatUIPreviewLoop()

	local var0_16 = CombatUIPreviewer.WeaponButtonPreviewMode

	if arg1_16 == var0_16.LOOP then
		arg0_16:StartCombatUIPreviewLoop()

		return
	end

	if arg1_16 ~= var0_16.UNFILLED then
		arg0_16:ApplyCombatUIPreviewState(2, 1, false)
		quickCheckAndPlayAnimator(arg0_16._skin, "weapon_button_progress_filled")
	else
		arg0_16:ApplyCombatUIPreviewState(0, 0, false)
	end
end

function var1_0.updateProgressBar(arg0_17)
	local var0_17 = arg0_17._progressInfo:GetCurrent() / arg0_17._progressInfo:GetMax()

	arg0_17._progressBar.fillAmount = var0_17

	if arg0_17._progressInfo.GetCount and arg0_17._progressInfo:GetCount() > 0 then
		arg0_17:updateProgressBG(1, arg0_17._progressInfo:GetMax())
	else
		arg0_17._bgEffAni.enabled = true

		arg0_17:updateProgressBG(var0_17, arg0_17._progressInfo:GetMax())
	end
end

function var1_0.updateProgressBG(arg0_18, arg1_18, arg2_18)
	arg1_18 = Mathf.Clamp01(arg1_18)

	local var0_18 = arg0_18._bgEffAniClipTotalFrames - 1
	local var1_18 = arg1_18 * var0_18
	local var2_18

	if arg2_18 and arg2_18 > var2_0 then
		local var3_18 = math.floor(var1_18)
		local var4_18 = math.min(var0_18, var3_18 + 1)
		local var5_18 = var1_18 - var3_18

		var2_18 = (var3_18 + (var4_18 - var3_18) * var5_18) / var0_18
	else
		var2_18 = math.floor(var1_18 + 0.5) / var0_18
	end

	arg0_18._bgEffAni.speed = 1

	arg0_18._bgEffAni:Play("skinui_button_bg", 0, var2_18)
	arg0_18._bgEffAni:Update(0)

	arg0_18._bgEffAni.speed = 0
end

function var1_0.Dispose(arg0_19)
	arg0_19:StopCombatUIPreviewLoop()
	var1_0.super.Dispose(arg0_19)
end
