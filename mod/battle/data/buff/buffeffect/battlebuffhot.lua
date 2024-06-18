ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffHOT = class("BattleBuffHOT", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffHOT.__name = "BattleBuffHOT"

function var0_0.Battle.BattleBuffHOT.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffHOT.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffHOT.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._number = arg0_2._tempData.arg_list.number or 0
	arg0_2._numberBase = arg0_2._number
	arg0_2._time = arg0_2._tempData.arg_list.time or 0
	arg0_2._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_2._time
	arg0_2._maxHPRatio = arg0_2._tempData.arg_list.maxHPRatio or 0
	arg0_2._currentHPRatio = arg0_2._tempData.arg_list.currentHPRatio or 0
	arg0_2._incorruptible = arg0_2._tempData.arg_list.incorrupt
end

function var0_0.Battle.BattleBuffHOT.onStack(arg0_3, arg1_3, arg2_3)
	return
end

function var0_0.Battle.BattleBuffHOT.onUpdate(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg3_4.timeStamp >= arg0_4._nextEffectTime then
		local var0_4 = arg0_4:CalcNumber(arg1_4, arg2_4)
		local var1_4 = {
			isMiss = false,
			isCri = false,
			isHeal = true,
			incorrupt = arg0_4._incorruptible
		}

		arg1_4:UpdateHP(var0_4, var1_4)

		if arg1_4:IsAlive() then
			arg0_4._nextEffectTime = arg0_4._nextEffectTime + arg0_4._time
		end
	end
end

function var0_0.Battle.BattleBuffHOT.onRemove(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:CalcNumber(arg1_5, arg2_5)
	local var1_5 = {
		isMiss = false,
		isCri = false,
		isHeal = true,
		incorrupt = arg0_5._incorruptible
	}

	arg1_5:UpdateHP(var0_5, var1_5)
end

function var0_0.Battle.BattleBuffHOT.CalcNumber(arg0_6, arg1_6, arg2_6)
	local var0_6, var1_6 = arg1_6:GetHP()
	local var2_6 = arg1_6:GetAttrByName("healingRate")
	local var3_6 = math.max(0, var0_6 * arg0_6._currentHPRatio + var1_6 * arg0_6._maxHPRatio + arg0_6._number)

	return (math.floor(var3_6 * arg2_6._stack * var2_6))
end
