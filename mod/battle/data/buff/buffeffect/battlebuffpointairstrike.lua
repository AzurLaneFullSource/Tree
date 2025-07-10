ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffPointAirStrike = class("BattleBuffPointAirStrike", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffPointAirStrike.__name = "BattleBuffPointAirStrike"

local var1_0 = var0_0.Battle.BattleBuffPointAirStrike

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._hiveIDList = arg0_2._tempData.arg_list.aircraft_id_list
	arg0_2._initCD = arg0_2._tempData.arg_list.initial_over_heat
	arg0_2._stackCount = arg0_2._tempData.arg_list.stack_count
	arg0_2._strikeWeapon = arg0_2._tempData.arg_list.weapon_id
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:addManualWeapon(arg1_3)
end

function var1_0.addManualWeapon(arg0_4, arg1_4)
	for iter0_4 = 1, arg0_4._stackCount do
		arg1_4:AddPointAirStrike(arg0_4._strikeWeapon, arg0_4._coolDownDuration, arg0_4._initCD):SetAirUnit(arg0_4._hiveIDList)
	end
end
