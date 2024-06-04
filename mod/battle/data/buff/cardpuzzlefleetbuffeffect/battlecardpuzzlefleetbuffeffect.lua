ys = ys or {}

local var0 = ys

var0.Battle.BattleCardPuzzleFleetBuffEffect = class("BattleCardPuzzleFleetBuffEffect")
var0.Battle.BattleCardPuzzleFleetBuffEffect.__name = "BattleCardPuzzleFleetBuffEffect"

local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleFleetBuffEffect

var2.FX_TYPE_NOR = 0
var2.FX_TYPE_MOD_ATTR = 1

function var2.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)
	arg0._type = arg0._tempData.type

	arg0:SetActive()
end

function var2.GetEffectType(arg0)
	return var2.FX_TYPE_NOR
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._cardPuzzleComponent = arg1
	arg0._fleetBuff = arg2
end

function var2.Trigger(arg0, arg1, arg2)
	arg0[arg1](arg0, arg2)
end

function var2.onAttach(arg0)
	arg0:onTrigger()
end

function var2.onRemove(arg0)
	arg0:onTrigger()
end

function var2.onUpdate(arg0, arg1)
	if arg0._tempData.arg_list.INR then
		local var0 = arg0._tempData.arg_list.INR

		if not arg0._lastTimeStamp or var0 < arg1 - arg0._lastTimeStamp then
			arg0:onTrigger()

			arg0._lastTimeStamp = arg1
		end
	else
		arg0:onTrigger()
	end
end

function var2.onPlus(arg0)
	arg0:onTrigger()
end

function var2.onDeduct(arg0)
	arg0:onTrigger()
end

function var2.onStartGame(arg0)
	arg0:onTrigger()
end

function var2.IsActive(arg0)
	return arg0._isActive
end

function var2.SetActive(arg0)
	arg0._isActive = true
end

function var2.NotActive(arg0)
	arg0._isActive = false
end

function var2.Clear(arg0)
	return
end

function var2.Dispose(arg0)
	return
end
