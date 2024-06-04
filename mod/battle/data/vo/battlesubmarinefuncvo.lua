ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleSubmarineFuncVO = class("BattleSubmarineFuncVO")
var0.Battle.BattleSubmarineFuncVO.__name = "BattleSubmarineFuncVO"

local var3 = var0.Battle.BattleSubmarineFuncVO

function var3.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._current = arg1
	arg0._defaultMax = arg1
	arg0._active = true

	arg0:ResetMax()
end

function var3.Update(arg0, arg1)
	if arg0._active and arg0._current < arg0._max then
		local var0 = arg1 - arg0._reloadStartTime

		if var0 >= arg0._max then
			arg0:ResetMax()

			arg0._current = arg0._max
			arg0._reloadStartTime = nil

			arg0:DispatchOverLoadChange()
		else
			arg0._current = var0
		end
	end
end

function var3.SetActive(arg0, arg1)
	arg0._active = arg1
end

function var3.ResetCurrent(arg0)
	arg0._current = 0
	arg0._reloadStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0:DispatchOverLoadChange()
end

function var3.ResetMax(arg0)
	arg0._max = arg0._defaultMax
end

function var3.SetMax(arg0, arg1)
	arg0._max = arg1
end

function var3.GetMax(arg0)
	return arg0._max
end

function var3.GetTotal(arg0)
	return 0
end

function var3.GetCurrent(arg0)
	return arg0._current
end

function var3.IsOverLoad(arg0)
	return arg0._current < arg0._max
end

function var3.DispatchOverLoadChange(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleEvent.OVER_LOAD_CHANGE)

	arg0:DispatchEvent(var0)
end

function var3.Dispose(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._focusTimer)

	arg0._focusTimer = nil

	var0.EventDispatcher.DetachEventDispatcher(arg0)
end
