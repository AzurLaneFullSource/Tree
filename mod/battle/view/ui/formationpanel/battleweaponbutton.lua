ys = ys or {}

local var0 = ys
local var1 = class("BattleWeaponButton")

var0.Battle.BattleWeaponButton = var1
var1.__name = "BattleWeaponButton"
var1.ICON_BY_INDEX = {
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

function var1.Ctor(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0.eventTriggers = {}
end

function var1.ConfigCallback(arg0, arg1, arg2, arg3, arg4)
	arg0._downFunc = arg1
	arg0._upFunc = arg2
	arg0._cancelFunc = arg3
	arg0._emptyFunc = arg4
end

function var1.SetActive(arg0, arg1)
	SetActive(arg0._skin, arg1)
end

function var1.SetJam(arg0, arg1)
	SetActive(arg0._jam, arg1)
	SetActive(arg0._icon, not arg1)
	SetActive(arg0._progress, not arg1)
end

function var1.SwitchIcon(arg0, arg1)
	arg0._iconIndex = arg1

	local var0 = var1.ICON_BY_INDEX[arg1]

	setImageSprite(arg0._unfill, LoadSprite("ui/CombatUI_atlas", "weapon_unfill_" .. var0))
	setImageSprite(arg0._filled, LoadSprite("ui/CombatUI_atlas", "filled_combined_" .. var0))
end

function var1.SwitchIconEffect(arg0, arg1)
	local var0 = var1.ICON_BY_INDEX[arg1]

	setImageSprite(arg0._filledEffect, LoadSprite("ui/CombatUI_atlas", "filled_effect_" .. var0), true)
	setImageSprite(arg0._jam, LoadSprite("ui/CombatUI_atlas", "skill_jam_" .. var0), true)
end

function var1.ConfigSkin(arg0, arg1)
	arg0._skin = arg1
	arg0._btn = arg1:Find("ActCtl")
	arg0._block = arg1:Find("ActCtl/block").gameObject
	arg0._progress = arg1:Find("ActCtl/skill_progress")
	arg0._progressBar = arg0._progress:GetComponent(typeof(Image))
	arg0._icon = arg1:Find("ActCtl/skill_icon")
	arg0._filled = arg0._icon:Find("filled")
	arg0._unfill = arg0._icon:Find("unfill")
	arg0._count = arg1:Find("ActCtl/Count")
	arg0._text = arg0._count:Find("CountText")
	arg0._selected = arg1:Find("ActCtl/selected")
	arg0._unSelect = arg1:Find("ActCtl/unselect")
	arg0._filledEffect = arg1:Find("ActCtl/filledEffect")
	arg0._jam = arg1:Find("ActCtl/jam")
	arg0._countTxt = arg0._text:GetComponent(typeof(Text))

	arg1.gameObject:SetActive(true)
	arg0._block:SetActive(false)
	arg0._progress.gameObject:SetActive(true)

	local var0 = arg0._filledEffect.gameObject

	var0:SetActive(false)
	var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		SetActive(arg0._filledEffect, false)
	end)
end

function var1.GetSkin(arg0)
	return arg0._skin
end

function var1.Enabled(arg0, arg1)
	local var0 = GetComponent(arg0._btn, "EventTriggerListener")
	local var1 = GetComponent(arg0._block, "EventTriggerListener")

	arg0.eventTriggers[var0] = true
	arg0.eventTriggers[var1] = true
	var0.enabled = arg1
	var1.enabled = arg1
end

function var1.Disable(arg0)
	if arg0._cancelFunc then
		arg0._cancelFunc()
	end

	arg0:OnUnSelect()

	local var0 = GetComponent(arg0._btn, "EventTriggerListener")
	local var1 = GetComponent(arg0._block, "EventTriggerListener")

	var0.enabled = false
	var1.enabled = false
end

function var1.OnSelected(arg0)
	SetActive(arg0._unSelect, false)
	SetActive(arg0._selected, true)
end

function var1.OnUnSelect(arg0)
	SetActive(arg0._selected, false)
	SetActive(arg0._unSelect, true)
end

function var1.OnFilled(arg0)
	SetActive(arg0._filled, true)
	SetActive(arg0._unfill, false)
end

function var1.OnfilledEffect(arg0)
	SetActive(arg0._filledEffect, true)
end

function var1.OnOverLoadChange(arg0)
	if arg0._progressInfo:IsOverLoad() then
		arg0._block:SetActive(true)
		arg0:OnUnfill()
	else
		arg0._block:SetActive(false)
		arg0:OnFilled()
	end

	if arg0._progressInfo:GetTotal() > 0 then
		arg0:updateProgressBar()
	end
end

function var1.OnUnfill(arg0)
	SetActive(arg0._filled, false)
	SetActive(arg0._unfill, true)
end

function var1.SetProgressActive(arg0, arg1)
	arg0._progress.gameObject:SetActive(arg1)
end

function var1.SetTextActive(arg0, arg1)
	SetActive(arg0._count, arg1)
end

function var1.SetProgressInfo(arg0, arg1)
	arg0._progressInfo = arg1

	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE, arg0.OnTotalChange)
	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_COUNT_PLUS, arg0.OnfilledEffect)
	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.OVER_LOAD_CHANGE, arg0.OnOverLoadChange)
	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.COUNT_CHANGE, arg0.OnCountChange)
	arg0:OnTotalChange()
	arg0:OnOverLoadChange()
end

function var1.OnCountChange(arg0)
	local var0 = arg0._progressInfo:GetCount()
	local var1 = arg0._progressInfo:GetTotal()

	arg0._countTxt.text = string.format("%d/%d", var0, var1)

	local var2 = arg0._progressInfo:GetCurrentWeaponIconIndex()

	if var2 ~= arg0._iconIndex then
		arg0:SwitchIcon(var2)
		arg0:SwitchIconEffect(var2)
	end
end

function var1.OnTotalChange(arg0, arg1)
	if arg0._progressInfo:GetTotal() <= 0 then
		arg0._block:SetActive(true)

		arg0._progressBar.fillAmount = 0
		arg0._text:GetComponent(typeof(Text)).text = "0/0"

		arg0:SetControllerActive(false)
		arg0:OnUnfill()
		arg0:OnUnSelect()
	else
		arg0:OnCountChange()
		arg0:SetControllerActive(true)

		if arg1 then
			local var0 = arg1.Data.index

			if var0 and var0 == 1 then
				arg0:OnUnSelect()
			end
		end
	end
end

function var1.SetControllerActive(arg0, arg1)
	if arg0._isActive == arg1 then
		return
	end

	arg0._isActive = arg1

	local var0 = GetComponent(arg0._btn, "EventTriggerListener")
	local var1 = GetComponent(arg0._block, "EventTriggerListener")

	if arg1 then
		local var2

		if arg0._downFunc ~= nil then
			var0:AddPointDownFunc(function()
				var2 = true

				arg0._downFunc()
				arg0:OnSelected()
			end)
		end

		if arg0._upFunc ~= nil then
			var0:AddPointUpFunc(function()
				if var2 then
					var2 = false

					arg0._upFunc()
					arg0:OnUnSelect()
				end
			end)
		end

		if arg0._cancelFunc ~= nil then
			var0:AddPointExitFunc(function()
				if var2 then
					var2 = false

					arg0._cancelFunc()
					arg0:OnUnSelect()
				end
			end)
		end

		var1:RemovePointDownFunc()
	else
		var1:AddPointDownFunc(arg0._emptyFunc)
		var0:RemovePointDownFunc()
		var0:RemovePointUpFunc()
		var0:RemovePointExitFunc()
	end
end

function var1.InitialAnima(arg0, arg1)
	SetActive(arg0._btn, false)

	arg0._leanID = LeanTween.delayedCall(arg1, System.Action(function()
		arg0._skin:GetComponent("Animator").enabled = true
		arg0._leanID = nil
	end))
end

function var1.Update(arg0)
	local var0 = arg0._progressInfo:GetCurrent()
	local var1 = arg0._progressInfo:GetMax()

	if arg0._progressInfo:GetTotal() > 0 and var0 < var1 then
		arg0:updateProgressBar()
	end
end

function var1.updateProgressBar(arg0)
	local var0 = arg0._progressInfo:GetCurrent() / arg0._progressInfo:GetMax()

	arg0._progressBar.fillAmount = var0
end

function var1.Dispose(arg0)
	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	arg0._progress = nil
	arg0._progressBar = nil

	arg0._progressInfo:UnregisterEventListener(arg0, var0.Battle.BattleEvent.OVER_LOAD_CHANGE)
	arg0._progressInfo:UnregisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE)
	arg0._progressInfo:UnregisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_COUNT_PLUS)
	arg0._progressInfo:UnregisterEventListener(arg0, var0.Battle.BattleEvent.COUNT_CHANGE)
	var0.EventListener.DetachEventListener(arg0)
end
