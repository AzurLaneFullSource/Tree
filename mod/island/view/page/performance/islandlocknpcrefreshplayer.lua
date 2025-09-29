local var0_0 = class("IslandLockNpcRefreshPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	local var0_1 = IslandConst.UNIT_LIST_OBJ

	for iter0_1, iter1_1 in ipairs(arg1_1.unitIdList or {}) do
		arg0_1:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.LOCK_NPC_REFRESH, iter1_1, var0_1)
	end

	arg2_1()
end

return var0_0
