﻿ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButton")

var0_0.Battle.BattleWeaponButton = var1_0
var1_0.__name = "BattleWeaponButton"
var1_0.ICON_BY_INDEX = {
	"cannon",
	"torpedo",
	"aircraft",
	"submarine",
	"dive",
	"rise",
	"boost",
	"switch",
	"special",
	"aamissile",
	"meteor"
}

function var1_0.Ctor(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1.eventTriggers = {}
end

function var1_0.ConfigCallback(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2._downFunc = arg1_2
	arg0_2._upFunc = arg2_2
	arg0_2._cancelFunc = arg3_2
	arg0_2._emptyFunc = arg4_2
end

function var1_0.SetActive(arg0_3, arg1_3)
	SetActive(arg0_3._skin, arg1_3)
end

function var1_0.SetJam(arg0_4, arg1_4)
	SetActive(arg0_4._jam, arg1_4)
	SetActive(arg0_4._icon, not arg1_4)
	SetActive(arg0_4._progress, not arg1_4)
end

function var1_0.SwitchIcon(arg0_5, arg1_5)
	arg0_5._iconIndex = arg1_5

	local var0_5 = var1_0.ICON_BY_INDEX[arg1_5]

	setImageSprite(arg0_5._unfill, LoadSprite("ui/CombatUI_atlas", "weapon_unfill_" .. var0_5))
	setImageSprite(arg0_5._filled, LoadSprite("ui/CombatUI_atlas", "filled_combined_" .. var0_5))
end

function var1_0.SwitchIconEffect(arg0_6, arg1_6)
	local var0_6 = var1_0.ICON_BY_INDEX[arg1_6]

	setImageSprite(arg0_6._filledEffect, LoadSprite("ui/CombatUI_atlas", "filled_effect_" .. var0_6), true)
	setImageSprite(arg0_6._jam, LoadSprite("ui/CombatUI_atlas", "skill_jam_" .. var0_6), true)
end

function var1_0.ConfigSkin(arg0_7, arg1_7)
	arg0_7._skin = arg1_7
	arg0_7._btn = arg1_7:Find("ActCtl")
	arg0_7._block = arg1_7:Find("ActCtl/block").gameObject
	arg0_7._progress = arg1_7:Find("ActCtl/skill_progress")
	arg0_7._progressBar = arg0_7._progress:GetComponent(typeof(Image))
	arg0_7._icon = arg1_7:Find("ActCtl/skill_icon")
	arg0_7._filled = arg0_7._icon:Find("filled")
	arg0_7._unfill = arg0_7._icon:Find("unfill")
	arg0_7._count = arg1_7:Find("ActCtl/Count")
	arg0_7._text = arg0_7._count:Find("CountText")
	arg0_7._selected = arg1_7:Find("ActCtl/selected")
	arg0_7._unSelect = arg1_7:Find("ActCtl/unselect")
	arg0_7._filledEffect = arg1_7:Find("ActCtl/filledEffect")
	arg0_7._jam = arg1_7:Find("ActCtl/jam")
	arg0_7._countTxt = arg0_7._text:GetComponent(typeof(Text))

	arg1_7.gameObject:SetActive(true)
	arg0_7._block:SetActive(false)
	arg0_7._progress.gameObject:SetActive(true)

	local var0_7 = arg0_7._filledEffect.gameObject

	var0_7:SetActive(false)
	var0_7:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_8)
		SetActive(arg0_7._filledEffect, false)
	end)
end

function var1_0.GetSkin(arg0_9)
	return arg0_9._skin
end

function var1_0.Enabled(arg0_10, arg1_10)
	local var0_10 = GetComponent(arg0_10._btn, "EventTriggerListener")
	local var1_10 = GetComponent(arg0_10._block, "EventTriggerListener")

	arg0_10.eventTriggers[var0_10] = true
	arg0_10.eventTriggers[var1_10] = true
	var0_10.enabled = arg1_10
	var1_10.enabled = arg1_10
end

function var1_0.Disable(arg0_11)
	if arg0_11._cancelFunc then
		arg0_11._cancelFunc()
	end

	arg0_11:OnUnSelect()

	local var0_11 = GetComponent(arg0_11._btn, "EventTriggerListener")
	local var1_11 = GetComponent(arg0_11._block, "EventTriggerListener")

	var0_11.enabled = false
	var1_11.enabled = false
end

function var1_0.OnSelected(arg0_12)
	SetActive(arg0_12._unSelect, false)
	SetActive(arg0_12._selected, true)
end

function var1_0.OnUnSelect(arg0_13)
	SetActive(arg0_13._selected, false)
	SetActive(arg0_13._unSelect, true)
end

function var1_0.OnFilled(arg0_14)
	SetActive(arg0_14._filled, true)
	SetActive(arg0_14._unfill, false)
end

function var1_0.OnfilledEffect(arg0_15)
	SetActive(arg0_15._filledEffect, true)
end

function var1_0.OnOverLoadChange(arg0_16)
	if arg0_16._progressInfo:IsOverLoad() then
		arg0_16._block:SetActive(true)
		arg0_16:OnUnfill()
	else
		arg0_16._block:SetActive(false)
		arg0_16:OnFilled()
	end

	if arg0_16._progressInfo:GetTotal() > 0 then
		arg0_16:updateProgressBar()
	end
end

function var1_0.OnUnfill(arg0_17)
	SetActive(arg0_17._filled, false)
	SetActive(arg0_17._unfill, true)
end

function var1_0.SetProgressActive(arg0_18, arg1_18)
	arg0_18._progress.gameObject:SetActive(arg1_18)
end

function var1_0.SetTextActive(arg0_19, arg1_19)
	SetActive(arg0_19._count, arg1_19)
end

function var1_0.SetProgressInfo(arg0_20, arg1_20)
	arg0_20._progressInfo = arg1_20

	arg0_20._progressInfo:RegisterEventListener(arg0_20, var0_0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE, arg0_20.OnTotalChange)
	arg0_20._progressInfo:RegisterEventListener(arg0_20, var0_0.Battle.BattleEvent.WEAPON_COUNT_PLUS, arg0_20.OnfilledEffect)
	arg0_20._progressInfo:RegisterEventListener(arg0_20, var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE, arg0_20.OnOverLoadChange)
	arg0_20._progressInfo:RegisterEventListener(arg0_20, var0_0.Battle.BattleEvent.COUNT_CHANGE, arg0_20.OnCountChange)
	arg0_20:OnTotalChange()
	arg0_20:OnOverLoadChange()
end

function var1_0.OnCountChange(arg0_21)
	local var0_21 = arg0_21._progressInfo:GetCount()
	local var1_21 = arg0_21._progressInfo:GetTotal()

	arg0_21._countTxt.text = string.format("%d/%d", var0_21, var1_21)

	local var2_21 = arg0_21._progressInfo:GetCurrentWeaponIconIndex()

	if var2_21 ~= arg0_21._iconIndex then
		arg0_21:SwitchIcon(var2_21)
		arg0_21:SwitchIconEffect(var2_21)
	end
end

function var1_0.OnTotalChange(arg0_22, arg1_22)
	if arg0_22._progressInfo:GetTotal() <= 0 then
		arg0_22._block:SetActive(true)

		arg0_22._progressBar.fillAmount = 0
		arg0_22._text:GetComponent(typeof(Text)).text = "0/0"

		arg0_22:SetControllerActive(false)
		arg0_22:OnUnfill()
		arg0_22:OnUnSelect()
	else
		arg0_22:OnCountChange()
		arg0_22:SetControllerActive(true)

		if arg1_22 then
			local var0_22 = arg1_22.Data.index

			if var0_22 and var0_22 == 1 then
				arg0_22:OnUnSelect()
			end
		end
	end
end

function var1_0.SetControllerActive(arg0_23, arg1_23)
	if arg0_23._isActive == arg1_23 then
		return
	end

	arg0_23._isActive = arg1_23

	local var0_23 = GetComponent(arg0_23._btn, "EventTriggerListener")
	local var1_23 = GetComponent(arg0_23._block, "EventTriggerListener")

	if arg1_23 then
		local var2_23

		if arg0_23._downFunc ~= nil then
			var0_23:AddPointDownFunc(function()
				var2_23 = true

				arg0_23._downFunc()
				arg0_23:OnSelected()
			end)
		end

		if arg0_23._upFunc ~= nil then
			var0_23:AddPointUpFunc(function()
				if var2_23 then
					var2_23 = false

					arg0_23._upFunc()
					arg0_23:OnUnSelect()
				end
			end)
		end

		if arg0_23._cancelFunc ~= nil then
			var0_23:AddPointExitFunc(function()
				if var2_23 then
					var2_23 = false

					arg0_23._cancelFunc()
					arg0_23:OnUnSelect()
				end
			end)
		end

		var1_23:RemovePointDownFunc()
	else
		var1_23:AddPointDownFunc(arg0_23._emptyFunc)
		var0_23:RemovePointDownFunc()
		var0_23:RemovePointUpFunc()
		var0_23:RemovePointExitFunc()
	end
end

function var1_0.InitialAnima(arg0_27, arg1_27)
	SetActive(arg0_27._btn, false)

	arg0_27._leanID = LeanTween.delayedCall(arg1_27, System.Action(function()
		arg0_27._skin:GetComponent("Animator").enabled = true
		arg0_27._leanID = nil
	end))
end

function var1_0.Update(arg0_29)
	local var0_29 = arg0_29._progressInfo:GetCurrent()
	local var1_29 = arg0_29._progressInfo:GetMax()

	if arg0_29._progressInfo:GetTotal() > 0 and var0_29 < var1_29 then
		arg0_29:updateProgressBar()
	end
end

function var1_0.updateProgressBar(arg0_30)
	local var0_30 = arg0_30._progressInfo:GetCurrent() / arg0_30._progressInfo:GetMax()

	arg0_30._progressBar.fillAmount = var0_30
end

function var1_0.Dispose(arg0_31)
	if arg0_31.eventTriggers then
		for iter0_31, iter1_31 in pairs(arg0_31.eventTriggers) do
			ClearEventTrigger(iter0_31)
		end

		arg0_31.eventTriggers = nil
	end

	arg0_31._progress = nil
	arg0_31._progressBar = nil

	arg0_31._progressInfo:UnregisterEventListener(arg0_31, var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE)
	arg0_31._progressInfo:UnregisterEventListener(arg0_31, var0_0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE)
	arg0_31._progressInfo:UnregisterEventListener(arg0_31, var0_0.Battle.BattleEvent.WEAPON_COUNT_PLUS)
	arg0_31._progressInfo:UnregisterEventListener(arg0_31, var0_0.Battle.BattleEvent.COUNT_CHANGE)
	var0_0.EventListener.DetachEventListener(arg0_31)
end