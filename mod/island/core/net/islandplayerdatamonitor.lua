local var0_0 = class("IslandPlayerDataMonitor", import(".IslandBaseMonitor"))

function var0_0.register(arg0_1)
	arg0_1:on(21206, function(arg0_2)
		if not arg0_1:IsCurrentIsland(arg0_2.island_id) then
			return
		end

		for iter0_2, iter1_2 in ipairs(arg0_2.player_list) do
			arg0_1:HandlePlayerData(iter1_2)
		end
	end)
	arg0_1:on(21309, function(arg0_3)
		if not arg0_1:IsCurrentIsland(arg0_3.island_id) then
			return
		end

		arg0_1:HandleAgoraData(arg0_3.update_data)
	end)
	arg0_1:on(21407, function(arg0_4)
		if not arg0_1:IsCurrentIsland(arg0_4.island_id) then
			return
		end

		arg0_1:HandleOrderData(arg0_4.order_info)
	end)
	arg0_1:on(21040, function(arg0_5)
		arg0_1:HandleTaskData(arg0_5.task_list)
	end)
	arg0_1:on(21043, function(arg0_6)
		arg0_1:HandleRandomTaskData(arg0_6)
	end)
	arg0_1:on(21422, function(arg0_7)
		arg0_1:HandleManageData(arg0_7)
	end)
	arg0_1:on(21053, function(arg0_8)
		arg0_1:HandleAchievementData(arg0_8.event_list)
	end)
	arg0_1:on(21342, function(arg0_9)
		arg0_1:HandleBookData(arg0_9.item_list)
	end)
	arg0_1:on(21518, function(arg0_10)
		arg0_1:HandleSlotFormulaData(arg0_10)
		getProxy(IslandProxy):GetIsland():GetBuildingAgency():AddFormulaNum(arg0_10.formula_id, arg0_10.comb_num)
	end)
	arg0_1:on(21519, function(arg0_11)
		arg0_1:HandleBuildUnlockData(arg0_11)
	end)
	arg0_1:on(21515, function(arg0_12)
		arg0_1:HandleHandSlotUnlockData(arg0_12)
	end)
	arg0_1:on(21314, function(arg0_13)
		arg0_1:HandleSignInNotify(arg0_13)
		getProxy(IslandProxy):UpdateGiftTagCache(arg0_13.island_id, arg0_13.gift_count, arg0_13.gift_timestamp)

		if not arg0_1:IsCurrentIsland(arg0_13.island_id) then
			return
		end

		arg0_1:HandleSignInData(arg0_13)
	end)
	arg0_1:on(21528, function(arg0_14)
		if not arg0_1:IsCurrentIsland(arg0_14.island_id) then
			return
		end

		arg0_1:HandleWildGatherInData(arg0_14)
	end)
	arg0_1:on(21535, function(arg0_15)
		if not arg0_1:IsCurrentIsland(arg0_15.island_id) then
			return
		end

		arg0_1:HandleWildCollectInData(arg0_15)
	end)
	arg0_1:on(21227, function(arg0_16)
		if not arg0_1:IsCurrentIsland(arg0_16.island_id) then
			return
		end

		arg0_1:HandleAbilityData(arg0_16)
	end)
	arg0_1:on(21225, function(arg0_17)
		if not arg0_1:IsCurrentIsland(arg0_17.island_id) then
			return
		end

		arg0_1:SyncStartManage(arg0_17)
	end)
	arg0_1:on(21220, function(arg0_18)
		if not arg0_1:IsCurrentIsland(arg0_18.island_id) then
			return
		end

		arg0_1:SyncStartDelegation(arg0_18)
	end)
	arg0_1:on(21226, function(arg0_19)
		if not arg0_1:IsCurrentIsland(arg0_19.island_id) then
			return
		end

		arg0_1:SyncEndDelegation(arg0_19)
	end)
	arg0_1:on(21222, function(arg0_20)
		if not arg0_1:IsCurrentIsland(arg0_20.island_id) then
			return
		end

		arg0_1:SyncResetSlotData(arg0_20)
	end)
	arg0_1:on(21221, function(arg0_21)
		if not arg0_1:IsCurrentIsland(arg0_21.island_id) then
			return
		end

		arg0_1:SyncStarthHandPlant(arg0_21)
	end)
	arg0_1:on(21701, function(arg0_22)
		arg0_1:ResponeAniamtion(arg0_22)
	end)
	arg0_1:on(21325, function(arg0_23)
		arg0_1:AddChatMsg(arg0_23)
	end)
	arg0_1:on(21228, function(arg0_24)
		if not arg0_1:IsCurrentIsland(arg0_24.island_id) then
			return
		end

		arg0_1:UpdateActivityNpc(arg0_24)
	end)
	arg0_1:on(21224, function(arg0_25)
		if not arg0_1:IsCurrentIsland(arg0_25.island_id) then
			return
		end

		arg0_1:UpdatePlayerDressupData(arg0_25)
	end)
	arg0_1:on(21232, function(arg0_26)
		if not arg0_1:IsCurrentIsland(arg0_26.island_id) then
			return
		end

		arg0_1:HandFishingStart(arg0_26)
	end)
	arg0_1:on(21233, function(arg0_27)
		if not arg0_1:IsCurrentIsland(arg0_27.island_id) then
			return
		end

		arg0_1:HandFishingStateChange(arg0_27)
	end)
	arg0_1:on(21242, function(arg0_28)
		if not arg0_1:IsCurrentIsland(arg0_28.island_id) then
			return
		end

		arg0_1:UpdateTradePrice(arg0_28)
	end)
	arg0_1:on(21247, function(arg0_29)
		arg0_1:HandleTradeNotify(arg0_29)
	end)
end

function var0_0.HandFishingStart(arg0_30, arg1_30)
	arg0_30:emitCore(ISLAND_EVT.START_FISHING, {
		unitId = arg1_30.user_id,
		fishPointId = arg1_30.point_id,
		rodId = arg1_30.rod_id,
		fishId = arg1_30.fish_id
	})
end

function var0_0.HandFishingStateChange(arg0_31, arg1_31)
	arg0_31:emitCore(ISLAND_EVT.FISHING_STATE_CHANGE, {
		unitId = arg1_31.user_id,
		fishPointId = arg1_31.point_id,
		op = arg1_31.type
	})
end

function var0_0.UpdateTradePrice(arg0_32, arg1_32)
	local var0_32 = arg1_32.today_price.timestamp
	local var1_32 = arg1_32.today_price.price

	arg0_32:GetIsland():GetTradeAgency():UpdateTodayPrice(var0_32, var1_32)
end

function var0_0.HandleAgoraData(arg0_33, arg1_33)
	if getProxy(IslandProxy):GetIsland().id == arg0_33:GetIsland().id then
		return
	end

	arg0_33:GetIsland():GetAgoraAgency():UpdatePlacedData(arg1_33)
end

function var0_0.HandlePlayerData(arg0_34, arg1_34)
	warning("HandlePlayerData>>>>>>>>>", arg1_34.state, arg1_34.map_id, arg1_34.id)

	if arg1_34.state == IslandConst.PLAYER_DATA_STATE_EMPTY then
		arg0_34:UpdatePlayerData(arg1_34)
	elseif arg1_34.state == IslandConst.PLAYER_DATA_STATE_ENTER then
		arg0_34:HandlePlayerEnter(arg1_34)
	elseif arg1_34.state == IslandConst.PLAYER_DATA_STATE_EXIT then
		arg0_34:HandlePlayerExit(arg1_34.id)
	end
end

function var0_0.HandlePlayerExit(arg0_35, arg1_35)
	if arg0_35:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_35] then
		arg0_35:GetIsland():GetVisitorAgency():DeletePlayer(arg1_35)
	end

	if arg0_35:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_35] then
		arg0_35:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_35)
	end
end

function var0_0.HandlePlayerEnter(arg0_36, arg1_36)
	local var0_36 = arg1_36.id

	if not arg0_36:GetIsland():GetVisitorAgency():GetPlayerList()[var0_36] then
		local var1_36 = IslandPlayer.New(arg1_36)

		arg0_36:GetIsland():GetVisitorAgency():AddPlayer(var1_36)

		if var1_36:IsInMap(arg0_36:GetIsland():GetMapId()) then
			arg0_36:GetIsland():GetVisitorAgency():AddMapVisitor(var1_36)
		end
	end
end

function var0_0.UpdatePlayerData(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_37.id]

	if var0_37 then
		var0_37:Flush(arg1_37)
	end

	local var1_37 = var0_37 and var0_37:IsInMap(arg0_37:GetIsland():GetMapId())
	local var2_37 = arg0_37:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_37.id]

	if var1_37 and not var2_37 then
		arg0_37:GetIsland():GetVisitorAgency():AddMapVisitor(var0_37)
	elseif not var1_37 and var2_37 then
		arg0_37:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_37.id)
	elseif var1_37 and var2_37 then
		var2_37:Flush(arg1_37)
	end
end

function var0_0.HandleOrderData(arg0_38, arg1_38)
	arg0_38:GetIsland():GetOrderAgency():UpdateOrAddOrder(arg1_38)
end

function var0_0.HandleTaskData(arg0_39, arg1_39)
	local var0_39 = arg0_39:GetIsland():GetTaskAgency()

	for iter0_39, iter1_39 in ipairs(arg1_39) do
		local var1_39 = underscore.all(iter1_39.process_list, function(arg0_40)
			return arg0_40.target_count == 0
		end)
		local var2_39 = IslandTask.New(iter1_39)

		if var1_39 then
			var0_39:AddTask(var2_39)
		else
			var0_39:UpdateTask(var2_39)
		end
	end
end

function var0_0.HandleRandomTaskData(arg0_41, arg1_41)
	arg0_41:GetIsland():GetTaskAgency():InitFutureTasks(arg1_41.task_list_random or {})

	local var0_41 = arg1_41.task_list or {}
	local var1_41 = arg0_41:GetIsland():GetTaskAgency()

	for iter0_41, iter1_41 in ipairs(var0_41) do
		local var2_41 = IslandTask.New(iter1_41)

		var1_41:AddTask(var2_41)
	end

	if #var0_41 > 0 then
		var1_41:TryAutoTrackTask()
	end
end

function var0_0.HandleManageData(arg0_42, arg1_42)
	local var0_42 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	if arg1_42.type == 1 then
		var0_42:DailyRefresh(arg1_42)
	elseif arg1_42.type == 2 then
		var0_42:UnlockDailyEvent(arg1_42)
	end
end

function var0_0.SyncStartManage(arg0_43, arg1_43)
	local var0_43 = getProxy(IslandProxy):GetIsland():GetManageAgency()
	local var1_43 = arg1_43.trade
	local var2_43 = var0_43:GetRestaurant(var1_43.id)

	if not var2_43 then
		var0_43:UnlockNewRestaurant(var1_43.id)

		var2_43 = var0_43:GetRestaurant(var1_43.id)
	end

	var2_43:UpdateData(var1_43)
	getProxy(IslandProxy):GetSharedIsland():DispatchEvent(IslandOpenRestaurantCommand.OPEN_RESTAURANT, {
		restId = var2_43.id,
		postList = var1_43.post_list
	})
end

function var0_0.HandleAchievementData(arg0_44, arg1_44)
	local var0_44 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	for iter0_44, iter1_44 in ipairs(arg1_44) do
		var0_44:UpdateRecord(iter1_44.event_type, iter1_44.event_arg, iter1_44.value)
	end
end

function var0_0.HandleBookData(arg0_45, arg1_45)
	getProxy(IslandProxy):GetIsland():GetBookAgency():HandlePushData(arg1_45)
end

function var0_0.HandleSlotFormulaData(arg0_46, arg1_46)
	local var0_46 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_46 = arg1_46.area_id
	local var2_46 = pg.island_production_slot[var1_46].place

	var0_46:GetBuilding(var2_46):GetDelegationSlotData(var1_46):AddFormulaNum(arg1_46)
end

function var0_0.HandleBuildUnlockData(arg0_47, arg1_47)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitBuildData(arg1_47.build)
end

function var0_0.HandleHandSlotUnlockData(arg0_48, arg1_48)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitHandSlotData(arg1_48.collect)
end

function var0_0.HandleSignInData(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetIsland():GetSignInAgency()

	var0_49:UpdateGiftEndTime(arg1_49.gift_timestamp)
	var0_49:UpdateFetchedList(arg1_49.gift_visitor)
	var0_49:SetGiftCnt(arg1_49.gift_count)
end

function var0_0.HandleTradeNotify(arg0_50, arg1_50)
	local var0_50 = getProxy(FriendProxy):getFriend(arg1_50.island_id)
	local var1_50 = var0_50 and var0_50:GetName() or ""
	local var2_50 = IslandVisitorLog.New({
		id = arg1_50.island_id,
		cmd = IslandConst.VISITOR_LOG_CMD_TRADE,
		name = var1_50,
		time = pg.TimeMgr.GetInstance():GetServerTime(),
		mapId = arg1_50.map_id,
		extraInfo = arg1_50.price
	})
	local var3_50 = var2_50:BuildWhitoutTime()

	if not var3_50 or var3_50 == "" then
		return
	end

	pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var2_50)
end

function var0_0.HandleSignInNotify(arg0_51, arg1_51)
	if arg1_51.cmd == 2 then
		local var0_51 = getProxy(FriendProxy):getFriend(arg1_51.island_id)
		local var1_51 = var0_51 and var0_51:GetName() or ""
		local var2_51 = IslandVisitorLog.New({
			id = arg1_51.island_id,
			cmd = IslandConst.VISITOR_LOG_CMD_GIFT,
			name = var1_51,
			time = pg.TimeMgr.GetInstance():GetServerTime()
		})

		if arg0_51:IsCurrentIsland(arg1_51.island_id) then
			local var3_51 = arg0_51:GetIsland():GetSignInAgency()
			local var4_51 = getProxy(PlayerProxy):getRawData().id

			var3_51:AddInviter(var4_51)
		end

		pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var2_51)
	end
end

function var0_0.HandleWildGatherInData(arg0_52, arg1_52)
	arg0_52:GetIsland():GetWildCollectAgency():UpdateGatherData(arg1_52)
end

function var0_0.HandleWildCollectInData(arg0_53, arg1_53)
	arg0_53:GetIsland():GetWildCollectAgency():UpdateCollectFragmentData(arg1_53)
end

function var0_0.HandleAbilityData(arg0_54, arg1_54)
	local var0_54 = getProxy(IslandProxy):GetSharedIsland()

	if not var0_54 then
		return
	end

	var0_54:GetAblityAgency():AddAblity(arg1_54.ability_id)
end

function var0_0.SyncStartDelegation(arg0_55, arg1_55)
	local var0_55 = arg0_55:GetIsland()
	local var1_55 = var0_55:GetBuildingAgency()
	local var2_55 = pg.island_production_slot[arg1_55.appoint_data.id].place

	var1_55:GetBuilding(var2_55):UpdateDeleationRoleDataBySlotId(arg1_55.appoint_data.id, arg1_55.appoint_data)

	local var3_55 = arg1_55.appoint_data.ship_id
	local var4_55 = arg1_55.appoint_data.id
	local var5_55 = arg1_55.appoint_data.formula_id

	var0_55:DispatchEvent(IslandStartDelegationCommand.START_DELEGATION, {
		build_id = var2_55,
		ship_id = var3_55,
		area_id = var4_55,
		formula_id = var5_55
	})
end

function var0_0.SyncEndDelegation(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetIsland()
	local var1_56 = island:GetBuildingAgency():GetBuilding(arg0_56.buildId)
	local var2_56 = arg0_56.islandRoleDelegationData.formula_id
	local var3_56 = arg0_56.islandRoleDelegationData.ship_id
	local var4_56 = arg0_56.id

	var1_56:UpdateDeleationRewardDataBySlotId(arg0_56.id, {
		formula_id = var2_56
	})
	var1_56:UpdateDeleationRoleDataBySlotId(arg0_56.id, nil)
	var0_56:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
		remainReward = true,
		build_id = build_id,
		ship_id = var3_56,
		area_id = var4_56
	})
end

function var0_0.SyncResetSlotData(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetIsland()
	local var1_57 = var0_57:GetBuildingAgency()

	for iter0_57, iter1_57 in ipairs(arg1_57.slot_list) do
		local var2_57 = pg.island_production_slot[iter1_57]
		local var3_57 = var2_57.place
		local var4_57 = var1_57:GetBuilding(var3_57)

		if var2_57.type == 9 or var2_57.type == 3 then
			local var5_57 = var4_57:GetDelegationSlotData(iter1_57)
			local var6_57 = var5_57 and var5_57:GetSlotRoleData()

			if var6_57 then
				local var7_57 = var6_57.ship_id
				local var8_57 = iter1_57

				var4_57:UpdateDeleationRoleDataBySlotId(iter1_57, nil)
				var0_57:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
					remainReward = false,
					build_id = var3_57,
					ship_id = var7_57,
					area_id = var8_57
				})
			end

			var4_57:UpdateDeleationRewardDataBySlotId(iter1_57, nil)
			var0_57:DispatchEvent(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, {
				build_id = var3_57,
				area_id = iter1_57
			})
		elseif var2_57.type == 1 then
			var4_57:UpdateHandPlantDataBySlotId({
				formula_id = 0,
				end_time = 0,
				state = 0,
				id = iter1_57
			})
			var0_57:DispatchEvent(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, {
				build_id = var3_57,
				area_id = iter1_57
			})
		end
	end
end

function var0_0.SyncStarthHandPlant(arg0_58, arg1_58)
	local var0_58 = arg0_58:GetIsland()
	local var1_58 = var0_58:GetBuildingAgency()

	for iter0_58, iter1_58 in ipairs(arg1_58.hand_list) do
		local var2_58 = pg.island_production_slot[iter1_58.id].place

		var1_58:GetBuilding(var2_58):UpdateHandPlantDataBySlotId(iter1_58)
		var0_58:DispatchEvent(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, {
			build_id = var2_58,
			area_id = iter1_58.id,
			formula_id = iter1_58.formula_id
		})
	end
end

function var0_0.ResponeAniamtion(arg0_59, arg1_59)
	arg0_59:GetIsland():DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.RESPON_ANIMATION_OP, {
		id = arg1_59.player_id,
		targetId = arg1_59.target_id,
		actionId = arg1_59.action_id
	})
end

function var0_0.AddChatMsg(arg0_60, arg1_60)
	local var0_60 = arg0_60:GetIsland():GetVisitorAgency()
	local var1_60 = getProxy(PlayerProxy):getRawData()
	local var2_60 = arg1_60.user_id == var1_60.id and var1_60 or var0_60:GetPlayer(arg1_60.user_id)

	if not var2_60 then
		return
	end

	local var3_60 = ChatProxy.InjectPublicMsg(arg1_60.content, Clone(var2_60))
	local var4_60 = ChatMsg.New(ChatConst.ChannelIsland, var3_60)

	getProxy(IslandProxy):AddChatMsg(arg1_60.island_id, var4_60)
end

function var0_0.UpdateActivityNpc(arg0_61, arg1_61)
	local var0_61 = arg0_61:GetIsland():GetActivityNpcAgency()

	for iter0_61, iter1_61 in ipairs(arg1_61.refresh_list) do
		local var1_61 = {
			id = iter1_61.id,
			object_id = iter1_61.object_id
		}

		if iter1_61.type == IslandConst.ACTIVITY_NPC_OP_TYPE_UPDATE then
			var0_61:UpdateNpc(var1_61)
		elseif iter1_61.type == IslandConst.ACTIVITY_NPC_OP_TYPE_ADD then
			var0_61:AddNpc(var1_61)
		elseif iter1_61.type == IslandConst.ACTIVITY_NPC_OP_TYPE_DEL then
			var0_61:RemoveNpc(var1_61)
		end
	end
end

function var0_0.UpdatePlayerDressupData(arg0_62, arg1_62)
	local var0_62 = arg0_62:GetIsland()
	local var1_62 = var0_62:GetVisitorAgency():GetPlayer(arg1_62.user_id)

	if not var1_62 then
		return
	end

	local var2_62 = {}

	for iter0_62, iter1_62 in ipairs(arg1_62.dress_list) do
		local var3_62 = iter1_62.type
		local var4_62 = iter1_62.id
		local var5_62 = 0

		for iter2_62, iter3_62 in ipairs(arg1_62.dress_color or {}) do
			if iter3_62.id == var4_62 then
				var5_62 = iter3_62.color
			end
		end

		local var6_62 = var1_62:GetDressByType(var3_62)
		local var7_62 = var1_62:GetCurrentColorByDressId(var6_62)

		if var6_62 ~= var4_62 then
			var2_62[var3_62] = {
				changeedDressId = var4_62,
				changedDressColorId = var5_62
			}
		elseif var7_62 ~= var5_62 then
			var2_62[var3_62] = {
				changedDressColorId = var5_62
			}
		end
	end

	var0_62:DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.CHANGE_VISTER_DRESS, {
		id = arg1_62.user_id,
		changeDressData = var2_62
	})
	var1_62:ChangeDressupData(arg1_62.dress_list, arg1_62.dress_color)
end

return var0_0
