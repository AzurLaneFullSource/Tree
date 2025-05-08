local var0_0 = class("EnterIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(21202, {
		island_id = var0_1
	}, 21203, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:GetIslandData(var0_1, arg0_2.player_list)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.GetIslandData(arg0_3, arg1_3, arg2_3)
	pg.ConnectionMgr.GetInstance():Send(21200, {
		island_id = arg1_3
	}, 21201, function(arg0_4)
		local var0_4 = arg0_3:IsSelf(arg1_3)
		local var1_4 = (var0_4 and Island or SharedIsland).New(arg0_4.island)
		local var2_4 = {}

		for iter0_4, iter1_4 in ipairs(arg2_3) do
			var2_4[iter1_4.id] = IslandPlayer.New(iter1_4)
		end

		var1_4:GetVisitorAgency():SetPlayerList(var2_4)

		if var0_4 then
			getProxy(IslandProxy):SetIsland(var1_4)
		else
			getProxy(IslandProxy):SetSharedIsland(var1_4)
		end

		arg0_3:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = arg1_3,
			mapId = var1_4:GetMapId(),
			callback = function()
				arg0_3:GoScene(arg1_3)
			end
		})
	end)
end

function var0_0.IsSelf(arg0_6, arg1_6)
	return getProxy(PlayerProxy):getRawData().id == arg1_6
end

function var0_0.GoScene(arg0_7, arg1_7)
	if arg0_7:IsSelf(arg1_7) then
		arg0_7:sendNotification(GAME.GO_SCENE, SCENE.ISLAND, {
			id = arg1_7
		})
	else
		arg0_7:sendNotification(GAME.GO_SCENE, SCENE.SHARED_ISLAND, {
			id = arg1_7
		})
	end
end

return var0_0
