local var0_0 = class("IslandCoupleAction4FollowerPlayer", import(".IslandCoupleActionPlayer"))

function var0_0.EnableOrDisableUnitSyn(arg0_1, arg1_1, arg2_1, arg3_1)
	local function var0_1(arg0_2, arg1_2)
		if arg1_2 then
			arg0_2:RestartBt()
		else
			arg0_2:StopBt()
		end
	end

	if isa(arg1_1, IslandFollowNpcUnit) then
		var0_1(arg1_1, arg3_1)
	end

	if isa(arg2_1, IslandFollowNpcUnit) then
		var0_1(arg2_1, arg3_1)
	end
end

function var0_0.EnableOrDisableNavMeshObstacle(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_3 = arg0_3:GetView().player

	if arg2_3 then
		IslandHelper.DisableNavMeshObstacle(var1_3._go)

		for iter0_3, iter1_3 in ipairs(var0_3) do
			if arg1_3 ~= iter1_3 then
				IslandHelper.DisableNavMeshObstacle(iter1_3._go)
			end
		end
	else
		IslandHelper.EnableNavMeshObstacle(var1_3._go)

		for iter2_3, iter3_3 in ipairs(var0_3) do
			if arg1_3 ~= iter3_3 then
				IslandHelper.EnableNavMeshObstacle(iter3_3._go)
			end
		end
	end
end

function var0_0.OnNavigateToPointFailed(arg0_4)
	return
end

return var0_0
