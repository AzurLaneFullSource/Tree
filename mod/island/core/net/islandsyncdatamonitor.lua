local var0_0 = class("IslandSyncDataMonitor", import(".IslandBaseMonitor"))

function var0_0.register(arg0_1)
	arg0_1:on(21212, function(arg0_2)
		if not arg0_1:GetIsland() then
			return
		end

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.sync_ob_list) do
			local var1_2 = SyncUnitData.New(iter1_2)

			table.insert(var0_2, var1_2)
		end

		if IslandConst.SYNC_TEST_DELAY_ON then
			local var2_2 = math.random(IslandConst.SYNC_TEST_DELAY_L, IslandConst.SYNC_TEST_DELAY_R)

			LeanTween.delayedCall(var2_2 / 1000, System.Action(function()
				arg0_1:GetIsland():DispatchEvent(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, var0_2)
			end))
		else
			arg0_1:GetIsland():DispatchEvent(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, var0_2)
		end
	end)
	arg0_1:on(21207, function(arg0_4)
		if not arg0_1:GetIsland() then
			return
		end

		if IslandConst.SYNC_TEST_DELAY_ON then
			local var0_4 = math.random(IslandConst.SYNC_TEST_DELAY_L, IslandConst.SYNC_TEST_DELAY_R)

			LeanTween.delayedCall(var0_4 / 1000, System.Action(function()
				arg0_1:GetIsland():DispatchEvent(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_4.object_list)
			end))
		else
			arg0_1:GetIsland():DispatchEvent(IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE, arg0_4.object_list)
		end
	end)
	arg0_1:on(21304, function(arg0_6)
		local var0_6 = arg0_1:GetIsland()
		local var1_6 = getProxy(IslandProxy):GetIsland()

		pg.m02:sendNotification(GAME.ISLAND_EXIT, {
			id = var0_6.id,
			callback = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip4"))
				pg.m02:sendNotification(GAME.ISLAND_ENTER, {
					id = var1_6.id
				})
			end
		})
	end)
end

return var0_0
