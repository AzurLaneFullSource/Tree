ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffHOT = class("BattleBuffHOT", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffHOT.__name = "BattleBuffHOT"

function var0.Battle.BattleBuffHOT.Ctor(arg0, arg1)
	var0.Battle.BattleBuffHOT.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffHOT.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number or 0
	arg0._numberBase = arg0._number
	arg0._time = arg0._tempData.arg_list.time or 0
	arg0._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._time
	arg0._maxHPRatio = arg0._tempData.arg_list.maxHPRatio or 0
	arg0._currentHPRatio = arg0._tempData.arg_list.currentHPRatio or 0
	arg0._incorruptible = arg0._tempData.arg_list.incorrupt
end

function var0.Battle.BattleBuffHOT.onStack(arg0, arg1, arg2)
	return
end

function var0.Battle.BattleBuffHOT.onUpdate(arg0, arg1, arg2, arg3)
	if arg3.timeStamp >= arg0._nextEffectTime then
		local var0 = arg0:CalcNumber(arg1, arg2)
		local var1 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			incorrupt = arg0._incorruptible
		}

		arg1:UpdateHP(var0, var1)

		if arg1:IsAlive() then
			arg0._nextEffectTime = arg0._nextEffectTime + arg0._time
		end
	end
end

function var0.Battle.BattleBuffHOT.onRemove(arg0, arg1, arg2)
	local var0 = arg0:CalcNumber(arg1, arg2)
	local var1 = {
		isMiss = false,
		isCri = false,
		isHeal = true,
		incorrupt = arg0._incorruptible
	}

	arg1:UpdateHP(var0, var1)
end

function var0.Battle.BattleBuffHOT.CalcNumber(arg0, arg1, arg2)
	local var0, var1 = arg1:GetHP()
	local var2 = arg1:GetAttrByName("healingRate")
	local var3 = math.max(0, var0 * arg0._currentHPRatio + var1 * arg0._maxHPRatio + arg0._number)

	return (math.floor(var3 * arg2._stack * var2))
end
