local var0_0 = class("IslandRoleDelegationReward")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:UpdateData(arg1_1)
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.formula_id = arg1_2.formula_id
	arg0_2.formula_drop_list = arg1_2.formula_drop_list
	arg0_2.ship_id = arg1_2.ship_id
	arg0_2.exp = arg1_2.exp
	arg0_2.main_num = arg1_2.main_num
	arg0_2.other_num = arg1_2.other_num
end

function var0_0.GetState(arg0_3)
	return
end

return var0_0
