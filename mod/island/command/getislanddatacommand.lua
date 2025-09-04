local var0_0 = class("GetIslandDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.list

	arg0_1:GetIslandData(var1_1, var2_1)
end

function var0_0.GetIslandData(arg0_2, arg1_2, arg2_2)
	if LOCK_ISLAND_DISPLAY then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21200, {
		island_id = arg1_2
	}, 21201, function(arg0_3)
		local var0_3 = arg0_2:IsSelf(arg1_2)
		local var1_3 = (var0_3 and Island or SharedIsland).New(arg0_3.island)

		if arg0_3.player_position then
			local var2_3 = arg0_3.player_position.map_id
			local var3_3 = Vector3(arg0_3.player_position.position.x, arg0_3.player_position.position.y, arg0_3.player_position.position.z)
			local var4_3 = Vector3(arg0_3.player_position.rotation.x, arg0_3.player_position.rotation.y, arg0_3.player_position.rotation.z)

			var1_3:SetMapId(var2_3)
			var1_3:SetLastExitPosition(var2_3, var3_3, var4_3)
		end

		local var5_3 = {}

		for iter0_3, iter1_3 in ipairs(arg2_2) do
			local var6_3 = IslandPlayer.New(iter1_3)

			var5_3[iter1_3.id] = var6_3
		end

		var1_3:GetVisitorAgency():SetPlayerList(var5_3)

		if var0_3 then
			getProxy(IslandProxy):SetIsland(var1_3)
		else
			getProxy(IslandProxy):SetSharedIsland(var1_3)
		end

		arg0_2:AfterIslandInit()
		arg0_2:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = arg1_2,
			mapId = var1_3:GetMapId(),
			callback = function()
				arg0_2:GoScene(arg1_2)
			end
		})
	end)
end

function var0_0.IsSelf(arg0_5, arg1_5)
	return getProxy(PlayerProxy):getRawData().id == arg1_5
end

function var0_0.GoScene(arg0_6, arg1_6)
	if arg0_6:IsSelf(arg1_6) then
		arg0_6:sendNotification(GAME.GO_SCENE, SCENE.ISLAND, {
			id = arg1_6
		})
	else
		arg0_6:sendNotification(GAME.GO_SCENE, SCENE.SHARED_ISLAND, {
			id = arg1_6
		})
	end
end

function var0_0.AfterIslandInit(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland()

	var0_7:GetAchievementAgency():InitRuntimeRecords()
	var0_7:GetTechnologyAgency():InitLockData()
	var0_7:GetGlobalBuffAgency():InitShipSkillGlobalBuff()
end

return var0_0
