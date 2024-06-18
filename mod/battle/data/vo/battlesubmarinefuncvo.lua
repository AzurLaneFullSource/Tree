ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleSubmarineFuncVO = class("BattleSubmarineFuncVO")
var0_0.Battle.BattleSubmarineFuncVO.__name = "BattleSubmarineFuncVO"

local var3_0 = var0_0.Battle.BattleSubmarineFuncVO

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._current = arg1_1
	arg0_1._defaultMax = arg1_1
	arg0_1._active = true

	arg0_1:ResetMax()
end

function var3_0.Update(arg0_2, arg1_2)
	if arg0_2._active and arg0_2._current < arg0_2._max then
		local var0_2 = arg1_2 - arg0_2._reloadStartTime

		if var0_2 >= arg0_2._max then
			arg0_2:ResetMax()

			arg0_2._current = arg0_2._max
			arg0_2._reloadStartTime = nil

			arg0_2:DispatchOverLoadChange()
		else
			arg0_2._current = var0_2
		end
	end
end

function var3_0.SetActive(arg0_3, arg1_3)
	arg0_3._active = arg1_3
end

function var3_0.ResetCurrent(arg0_4)
	arg0_4._current = 0
	arg0_4._reloadStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_4:DispatchOverLoadChange()
end

function var3_0.ResetMax(arg0_5)
	arg0_5._max = arg0_5._defaultMax
end

function var3_0.SetMax(arg0_6, arg1_6)
	arg0_6._max = arg1_6
end

function var3_0.GetMax(arg0_7)
	return arg0_7._max
end

function var3_0.GetTotal(arg0_8)
	return 0
end

function var3_0.GetCurrent(arg0_9)
	return arg0_9._current
end

function var3_0.IsOverLoad(arg0_10)
	return arg0_10._current < arg0_10._max
end

function var3_0.DispatchOverLoadChange(arg0_11)
	local var0_11 = var0_0.Event.New(var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE)

	arg0_11:DispatchEvent(var0_11)
end

function var3_0.Dispose(arg0_12)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_12._focusTimer)

	arg0_12._focusTimer = nil

	var0_0.EventDispatcher.DetachEventDispatcher(arg0_12)
end
