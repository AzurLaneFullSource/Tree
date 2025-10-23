local var0_0 = class("IslandSlotCollectCommand", pm.SimpleCommand)

var0_0.START_HAND_COLLECT_DONE = "IslandSlotCollectCommand:START_HAND_COLLECT_DONE"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1:GetBuildingAgency()
	local var5_1 = var0_1.type

	pg.ConnectionMgr.GetInstance():Send(21507, {
		build_id = var1_1,
		area_id = var2_1,
		type = var5_1
	}, 21508, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var4_1:GetBuilding(var1_1)
			local var1_2 = {
				id = var2_1
			}

			if var5_1 == 2 then
				var1_2 = {
					id = var2_1
				}
			end

			var0_2:GetBuildingCollectData():UpdateCollectRefreshtTime(arg0_2.refresh_time)
			var0_2:GetBuildingCollectData():UpdateGetCollectNum(var5_1)
			var0_2:UpdateCollectDataBySlotId(var1_2, var5_1)

			local var2_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_DROPMAIN_AWARD, {
				dropData = var2_2
			})
			var3_1:DispatchEvent(var0_0.START_HAND_COLLECT_DONE, {
				build_id = var1_1,
				area_id = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
