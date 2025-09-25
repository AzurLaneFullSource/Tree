local var0_0 = class("IslandActionAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.actionList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.action_list) do
		table.insert(arg0_1.actionList, iter1_1)
	end

	local var0_1 = pg.island_set.default_action

	if var0_1 then
		for iter2_1, iter3_1 in ipairs(var0_1.key_value_varchar) do
			if not arg0_1:ExistAction(iter3_1) then
				table.insert(arg0_1.actionList, iter3_1)
			end
		end
	end
end

function var0_0.GetActionList(arg0_2)
	return arg0_2.actionList
end

function var0_0.ExistAction(arg0_3, arg1_3)
	return table.contains(arg0_3.actionList, arg1_3)
end

function var0_0.AddAction(arg0_4, arg1_4)
	table.insert(arg0_4.actionList, arg1_4)
end

return var0_0
