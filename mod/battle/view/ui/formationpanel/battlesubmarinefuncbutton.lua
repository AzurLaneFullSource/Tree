ys = ys or {}

local var0 = ys
local var1 = class("BattleSubmarineFuncButton", var0.Battle.BattleWeaponButton)

var0.Battle.BattleSubmarineFuncButton = var1
var1.__name = "BattleSubmarineFuncButton"

function var1.Ctor(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0.eventTriggers = {}
end

function var1.OnfilledEffect(arg0)
	SetActive(arg0._filledEffect, true)
end

function var1.SetProgressInfo(arg0, arg1)
	arg0._progressInfo = arg1

	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_COUNT_PLUS, arg0.OnfilledEffect)
	arg0._progressInfo:RegisterEventListener(arg0, var0.Battle.BattleEvent.OVER_LOAD_CHANGE, arg0.OnOverLoadChange)
	arg0:OnOverLoadChange()
	arg0:SetControllerActive(true)
end

function var1.Update(arg0)
	if arg0._progressInfo:GetCurrent() < arg0._progressInfo:GetMax() then
		arg0:updateProgressBar()
	end
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
	arg0._progressInfo:UnregisterEventListener(arg0, var0.Battle.BattleEvent.WEAPON_COUNT_PLUS)
	var0.EventListener.DetachEventListener(arg0)
end
