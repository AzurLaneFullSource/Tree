ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffRecoilShield = class("BattleBuffRecoilShield", var0_0.Battle.BattleBuffShield)
var0_0.Battle.BattleBuffRecoilShield.__name = "BattleBuffRecoilShield"

local var1_0 = var0_0.Battle.BattleBuffRecoilShield

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetArgs(arg0_2, arg1_2, arg2_2)

	arg0_2._recoilRate = arg0_2._tempData.arg_list.recoilRate or 1
	arg0_2._proxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var1_0.onFinishGame(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3._totalShield - arg0_3._shield

	if var0_3 >= 1 then
		local var1_3 = math.floor(var0_3 * arg0_3._recoilRate)

		arg0_3._proxy:HandleDirectDamage(arg1_3, var1_3, nil, nil, false, false, true)
	end
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	var1_0.super.onAttach(arg0_4, arg1_4, arg2_4)
	arg1_4:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_RECOIL_SHIELD))
end

function var1_0.CalcNumber(arg0_5, arg1_5)
	arg0_5._totalShield = var1_0.super.CalcNumber(arg0_5, arg1_5)

	return arg0_5._totalShield
end

function var1_0.GetCurrentRate(arg0_6)
	return arg0_6._shield / arg0_6._totalShield
end
