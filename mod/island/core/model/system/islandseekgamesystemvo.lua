local var0_0 = class("IslandSeekGameSystemVO", import(".IslandSystemVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.miniGameID = arg1_1
	arg0_1.miniGameConfig = pg.island_minigame_template[arg0_1.miniGameID]
end

function var0_0.GetBehaviourTree(arg0_2)
	return arg0_2.miniGameConfig.bt
end

function var0_0.GetResultUIName(arg0_3)
	return arg0_3.miniGameConfig.result_ui
end

function var0_0.GetInteractiveObjects(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.miniGameConfig.interactive_objects) do
		table.insert(var0_4, iter1_4)
	end

	return var0_4
end

function var0_0.GetType(arg0_5)
	return IslandConst.SYSTEM_TYPE_SEEKGAME
end

return var0_0
