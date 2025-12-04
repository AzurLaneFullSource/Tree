local var0_0 = class("IslandFish", import("model.vo.BaseVO"))

var0_0.CUP_STATE_NONE = 0
var0_0.CUP_STATE_MIN = 1
var0_0.CUP_STATE_MAX = 2
var0_0.CUP_STATE_NIN_AND_MAX = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.fish_id
	arg0_1.configId = arg0_1.id
	arg0_1.minWeight = arg1_1.min_weight
	arg0_1.maxWeight = arg1_1.max_weight
	arg0_1.cupState = arg1_1.gold_state or var0_0.CUP_STATE_NONE
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_fish
end

function var0_0.GetMinWeight(arg0_3)
	return arg0_3.minWeight
end

function var0_0.GetMaxWeight(arg0_4)
	return arg0_4.maxWeight
end

function var0_0.SetWeight(arg0_5, arg1_5)
	if arg1_5 > arg0_5.maxWeight then
		arg0_5.maxWeight = arg1_5
	elseif arg1_5 < arg0_5.minWeight then
		arg0_5.minWeight = arg1_5
	end
end

function var0_0.ReachMinCup(arg0_6)
	return arg0_6.cupState == var0_0.CUP_STATE_NIN_AND_MAX or arg0_6.cupState == var0_0.CUP_STATE_MIN
end

function var0_0.ReachMaxCup(arg0_7)
	return arg0_7.cupState == var0_0.CUP_STATE_NIN_AND_MAX or arg0_7.cupState == var0_0.CUP_STATE_MAX
end

function var0_0.SetCupState(arg0_8, arg1_8)
	if arg0_8.cupState == var0_0.CUP_STATE_NIN_AND_MAX then
		return
	end

	if arg1_8 == 1 then
		arg0_8.cupState = arg0_8.cupState == var0_0.CUP_STATE_MAX and var0_0.CUP_STATE_NIN_AND_MAX or var0_0.CUP_STATE_MIN
	elseif arg1_8 == 2 then
		arg0_8.cupState = arg0_8.cupState == var0_0.CUP_STATE_MIN and var0_0.CUP_STATE_NIN_AND_MAX or var0_0.CUP_STATE_MAX
	end
end

return var0_0
