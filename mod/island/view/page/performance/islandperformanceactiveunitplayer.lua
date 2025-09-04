local var0_0 = class("IslandPerformanceActiveUnitPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1.unitType or IslandConst.UNIT_LIST_OBJ
	local var1_1 = defaultValue(arg1_1.show, true)

	for iter0_1, iter1_1 in ipairs(arg1_1.unitIdList or {}) do
		arg0_1:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.ACTIVE_OR_DISABLE_UNIT, iter1_1, var0_1, var1_1)
	end

	arg2_1()
end

function var0_0.Clear(arg0_2)
	return
end

return var0_0
