ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSubmarineFuncButton", var0_0.Battle.BattleWeaponButton)

var0_0.Battle.BattleSubmarineFuncButton = var1_0
var1_0.__name = "BattleSubmarineFuncButton"

function var1_0.Ctor(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1.eventTriggers = {}
end

function var1_0.OnfilledEffect(arg0_2)
	SetActive(arg0_2._filledEffect, true)
end

function var1_0.SetProgressInfo(arg0_3, arg1_3)
	arg0_3._progressInfo = arg1_3

	arg0_3._progressInfo:RegisterEventListener(arg0_3, var0_0.Battle.BattleEvent.WEAPON_COUNT_PLUS, arg0_3.OnfilledEffect)
	arg0_3._progressInfo:RegisterEventListener(arg0_3, var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE, arg0_3.OnOverLoadChange)
	arg0_3:OnOverLoadChange()
	arg0_3:SetControllerActive(true)
end

function var1_0.Update(arg0_4)
	if arg0_4._progressInfo:GetCurrent() < arg0_4._progressInfo:GetMax() then
		arg0_4:updateProgressBar()
	end
end

function var1_0.Dispose(arg0_5)
	if arg0_5.eventTriggers then
		for iter0_5, iter1_5 in pairs(arg0_5.eventTriggers) do
			ClearEventTrigger(iter0_5)
		end

		arg0_5.eventTriggers = nil
	end

	arg0_5._progress = nil
	arg0_5._progressBar = nil

	arg0_5._progressInfo:UnregisterEventListener(arg0_5, var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE)
	arg0_5._progressInfo:UnregisterEventListener(arg0_5, var0_0.Battle.BattleEvent.WEAPON_COUNT_PLUS)
	var0_0.EventListener.DetachEventListener(arg0_5)
end
