ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleCardPuzzleFleetBuffEffect = class("BattleCardPuzzleFleetBuffEffect")
var0_0.Battle.BattleCardPuzzleFleetBuffEffect.__name = "BattleCardPuzzleFleetBuffEffect"

local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleFleetBuffEffect

var2_0.FX_TYPE_NOR = 0
var2_0.FX_TYPE_MOD_ATTR = 1

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)
	arg0_1._type = arg0_1._tempData.type

	arg0_1:SetActive()
end

function var2_0.GetEffectType(arg0_2)
	return var2_0.FX_TYPE_NOR
end

function var2_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._cardPuzzleComponent = arg1_3
	arg0_3._fleetBuff = arg2_3
end

function var2_0.Trigger(arg0_4, arg1_4, arg2_4)
	arg0_4[arg1_4](arg0_4, arg2_4)
end

function var2_0.onAttach(arg0_5)
	arg0_5:onTrigger()
end

function var2_0.onRemove(arg0_6)
	arg0_6:onTrigger()
end

function var2_0.onUpdate(arg0_7, arg1_7)
	if arg0_7._tempData.arg_list.INR then
		local var0_7 = arg0_7._tempData.arg_list.INR

		if not arg0_7._lastTimeStamp or var0_7 < arg1_7 - arg0_7._lastTimeStamp then
			arg0_7:onTrigger()

			arg0_7._lastTimeStamp = arg1_7
		end
	else
		arg0_7:onTrigger()
	end
end

function var2_0.onPlus(arg0_8)
	arg0_8:onTrigger()
end

function var2_0.onDeduct(arg0_9)
	arg0_9:onTrigger()
end

function var2_0.onStartGame(arg0_10)
	arg0_10:onTrigger()
end

function var2_0.IsActive(arg0_11)
	return arg0_11._isActive
end

function var2_0.SetActive(arg0_12)
	arg0_12._isActive = true
end

function var2_0.NotActive(arg0_13)
	arg0_13._isActive = false
end

function var2_0.Clear(arg0_14)
	return
end

function var2_0.Dispose(arg0_15)
	return
end
