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
end

function var0_0.HandFishingStart(arg0_28, arg1_28)
	arg0_28:emitCore(ISLAND_EVT.START_FISHING, {
		unitId = arg1_28.user_id,
		fishPointId = arg1_28.point_id,
		rodId = arg1_28.rod_id,
		fishId = arg1_28.fish_id
	})
end

function var0_0.HandFishingStateChange(arg0_29, arg1_29)
	arg0_29:emitCore(ISLAND_EVT.FISHING_STATE_CHANGE, {
		unitId = arg1_29.user_id,
		fishPointId = arg1_29.point_id,
		op = arg1_29.type
	})
end

function var0_0.HandleAgoraData(arg0_30, arg1_30)
	if getProxy(IslandProxy):GetIsland().id == arg0_30:GetIsland().id then
		return
	end

	arg0_30:GetIsland():GetAgoraAgency():UpdatePlacedData(arg1_30)
end

function var0_0.HandlePlayerData(arg0_31, arg1_31)
	warning("HandlePlayerData>>>>>>>>>", arg1_31.state, arg1_31.map_id, arg1_31.id)

	if arg1_31.state == IslandConst.PLAYER_DATA_STATE_EMPTY then
		arg0_31:UpdatePlayerData(arg1_31)
	elseif arg1_31.state == IslandConst.PLAYER_DATA_STATE_ENTER then
		arg0_31:HandlePlayerEnter(arg1_31)
	elseif arg1_31.state == IslandConst.PLAYER_DATA_STATE_EXIT then
		arg0_31:HandlePlayerExit(arg1_31.id)
	end
end

function var0_0.HandlePlayerExit(arg0_32, arg1_32)
	if arg0_32:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_32] then
		arg0_32:GetIsland():GetVisitorAgency():DeletePlayer(arg1_32)
	end

	if arg0_32:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_32] then
		arg0_32:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_32)
	end
end

function var0_0.HandlePlayerEnter(arg0_33, arg1_33)
	local var0_33 = arg1_33.id

	if not arg0_33:GetIsland():GetVisitorAgency():GetPlayerList()[var0_33] then
		local var1_33 = IslandPlayer.New(arg1_33)

		arg0_33:GetIsland():GetVisitorAgency():AddPlayer(var1_33)

		if var1_33:IsInMap(arg0_33:GetIsland():GetMapId()) then
			arg0_33:GetIsland():GetVisitorAgency():AddMapVisitor(var1_33)
		end
	end
end

function var0_0.UpdatePlayerData(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_34.id]

	if var0_34 then
		var0_34:Flush(arg1_34)
	end

	local var1_34 = var0_34 and var0_34:IsInMap(arg0_34:GetIsland():GetMapId())
	local var2_34 = arg0_34:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_34.id]

	if var1_34 and not var2_34 then
		arg0_34:GetIsland():GetVisitorAgency():AddMapVisitor(var0_34)
	elseif not var1_34 and var2_34 then
		arg0_34:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_34.id)
	elseif var1_34 and var2_34 then
		var2_34:Flush(arg1_34)
	end
end

function var0_0.HandleOrderData(arg0_35, arg1_35)
	arg0_35:GetIsland():GetOrderAgency():UpdateOrAddOrder(arg1_35)
end

function var0_0.HandleTaskData(arg0_36, arg1_36)
	local var0_36 = arg0_36:GetIsland():GetTaskAgency()

	for iter0_36, iter1_36 in ipairs(arg1_36) do
		local var1_36 = underscore.all(iter1_36.process_list, function(arg0_37)
			return arg0_37.target_count == 0
		end)
		local var2_36 = IslandTask.New(iter1_36)

		if var1_36 then
			var0_36:AddTask(var2_36)
		else
			var0_36:UpdateTask(var2_36)
		end
	end
end

function var0_0.HandleRandomTaskData(arg0_38, arg1_38)
	arg0_38:GetIsland():GetTaskAgency():InitFutureTasks(arg1_38.task_list_random or {})

	local var0_38 = arg1_38.task_list or {}
	local var1_38 = arg0_38:GetIsland():GetTaskAgency()

	for iter0_38, iter1_38 in ipairs(var0_38) do
		local var2_38 = IslandTask.New(iter1_38)

		var1_38:AddTask(var2_38)
	end

	if #var0_38 > 0 then
		var1_38:TryAutoTrackTask()
	end
end

function var0_0.HandleManageData(arg0_39, arg1_39)
	local var0_39 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	if arg1_39.type == 1 then
		var0_39:DailyRefresh(arg1_39)
	elseif arg1_39.type == 2 then
		var0_39:UnlockDailyEvent(arg1_39)
	end
end

function var0_0.SyncStartManage(arg0_40, arg1_40)
	local var0_40 = getProxy(IslandProxy):GetIsland():GetManageAgency()
	local var1_40 = arg1_40.trade
	local var2_40 = var0_40:GetRestaurant(var1_40.id)

	if not var2_40 then
		var0_40:UnlockNewRestaurant(var1_40.id)

		var2_40 = var0_40:GetRestaurant(var1_40.id)
	end

	var2_40:UpdateData(var1_40)
	getProxy(IslandProxy):GetSharedIsland():DispatchEvent(IslandOpenRestaurantCommand.OPEN_RESTAURANT, {
		restId = var2_40.id,
		postList = var1_40.post_list
	})
end

function var0_0.HandleAchievementData(arg0_41, arg1_41)
	local var0_41 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		var0_41:UpdateRecord(iter1_41.event_type, iter1_41.event_arg, iter1_41.value)
	end
end

function var0_0.HandleBookData(arg0_42, arg1_42)
	getProxy(IslandProxy):GetIsland():GetBookAgency():HandlePushData(arg1_42)
end

function var0_0.HandleSlotFormulaData(arg0_43, arg1_43)
	local var0_43 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_43 = arg1_43.area_id
	local var2_43 = pg.island_production_slot[var1_43].place

	var0_43:GetBuilding(var2_43):GetDelegationSlotData(var1_43):AddFormulaNum(arg1_43)
end

function var0_0.HandleBuildUnlockData(arg0_44, arg1_44)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitBuildData(arg1_44.build)
end

function var0_0.HandleHandSlotUnlockData(arg0_45, arg1_45)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitHandSlotData(arg1_45.collect)
end

function var0_0.HandleSignInData(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetIsland():GetSignInAgency()

	var0_46:UpdateGiftEndTime(arg1_46.gift_timestamp)
	var0_46:UpdateFetchedList(arg1_46.gift_visitor)
	var0_46:SetGiftCnt(arg1_46.gift_count)
end

function var0_0.HandleSignInNotify(arg0_47, arg1_47)
	if arg1_47.cmd == 2 then
		local var0_47 = getProxy(FriendProxy):getFriend(arg1_47.island_id)
		local var1_47 = var0_47 and var0_47:GetName() or ""
		local var2_47 = IslandVisitorLog.New({
			id = arg1_47.island_id,
			cmd = IslandConst.VISITOR_LOG_CMD_GIFT,
			name = var1_47,
			time = pg.TimeMgr.GetInstance():GetServerTime()
		})

		if arg0_47:IsCurrentIsland(arg1_47.island_id) then
			local var3_47 = arg0_47:GetIsland():GetSignInAgency()
			local var4_47 = getProxy(PlayerProxy):getRawData().id

			var3_47:AddInviter(var4_47)
		end

		pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var2_47)
	end
end

function var0_0.HandleWildGatherInData(arg0_48, arg1_48)
	arg0_48:GetIsland():GetWildCollectAgency():UpdateGatherData(arg1_48)
end

function var0_0.HandleWildCollectInData(arg0_49, arg1_49)
	arg0_49:GetIsland():GetWildCollectAgency():UpdateCollectFragmentData(arg1_49)
end

function var0_0.HandleAbilityData(arg0_50, arg1_50)
	local var0_50 = getProxy(IslandProxy):GetSharedIsland()

	if not var0_50 then
		return
	end

	var0_50:GetAblityAgency():AddAblity(arg1_50.ability_id)
end

function var0_0.SyncStartDelegation(arg0_51, arg1_51)
	local var0_51 = arg0_51:GetIsland()
	local var1_51 = var0_51:GetBuildingAgency()
	local var2_51 = pg.island_production_slot[arg1_51.appoint_data.id].place

	var1_51:GetBuilding(var2_51):UpdateDeleationRoleDataBySlotId(arg1_51.appoint_data.id, arg1_51.appoint_data)

	local var3_51 = arg1_51.appoint_data.ship_id
	local var4_51 = arg1_51.appoint_data.id
	local var5_51 = arg1_51.appoint_data.formula_id

	var0_51:DispatchEvent(IslandStartDelegationCommand.START_DELEGATION, {
		build_id = var2_51,
		ship_id = var3_51,
		area_id = var4_51,
		formula_id = var5_51
	})
end

function var0_0.SyncEndDelegation(arg0_52, arg1_52)
	local var0_52 = arg0_52:GetIsland()
	local var1_52 = island:GetBuildingAgency():GetBuilding(arg0_52.buildId)
	local var2_52 = arg0_52.islandRoleDelegationData.formula_id
	local var3_52 = arg0_52.islandRoleDelegationData.ship_id
	local var4_52 = arg0_52.id

	var1_52:UpdateDeleationRewardDataBySlotId(arg0_52.id, {
		formula_id = var2_52
	})
	var1_52:UpdateDeleationRoleDataBySlotId(arg0_52.id, nil)
	var0_52:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
		remainReward = true,
		build_id = build_id,
		ship_id = var3_52,
		area_id = var4_52
	})
end

function var0_0.SyncResetSlotData(arg0_53, arg1_53)
	local var0_53 = arg0_53:GetIsland()
	local var1_53 = var0_53:GetBuildingAgency()

	for iter0_53, iter1_53 in ipairs(arg1_53.slot_list) do
		local var2_53 = pg.island_production_slot[iter1_53]
		local var3_53 = var2_53.place
		local var4_53 = var1_53:GetBuilding(var3_53)

		if var2_53.type == 9 or var2_53.type == 3 then
			local var5_53 = var4_53:GetDelegationSlotData(iter1_53)
			local var6_53 = var5_53 and var5_53:GetSlotRoleData()

			if var6_53 then
				local var7_53 = var6_53.ship_id
				local var8_53 = iter1_53

				var4_53:UpdateDeleationRoleDataBySlotId(iter1_53, nil)
				var0_53:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
					remainReward = false,
					build_id = var3_53,
					ship_id = var7_53,
					area_id = var8_53
				})
			end

			var4_53:UpdateDeleationRewardDataBySlotId(iter1_53, nil)
			var0_53:DispatchEvent(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, {
				build_id = var3_53,
				area_id = iter1_53
			})
		elseif var2_53.type == 1 then
			var4_53:UpdateHandPlantDataBySlotId({
				formula_id = 0,
				end_time = 0,
				state = 0,
				id = iter1_53
			})
			var0_53:DispatchEvent(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, {
				build_id = var3_53,
				area_id = iter1_53
			})
		end
	end
end

function var0_0.SyncStarthHandPlant(arg0_54, arg1_54)
	local var0_54 = arg0_54:GetIsland()
	local var1_54 = var0_54:GetBuildingAgency()

	for iter0_54, iter1_54 in ipairs(arg1_54.hand_list) do
		local var2_54 = pg.island_production_slot[iter1_54.id].place

		var1_54:GetBuilding(var2_54):UpdateHandPlantDataBySlotId(iter1_54)
		var0_54:DispatchEvent(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, {
			build_id = var2_54,
			area_id = iter1_54.id,
			formula_id = iter1_54.formula_id
		})
	end
end

function var0_0.ResponeAniamtion(arg0_55, arg1_55)
	arg0_55:GetIsland():DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.RESPON_ANIMATION_OP, {
		id = arg1_55.player_id,
		targetId = arg1_55.target_id,
		actionId = arg1_55.action_id
	})
end

function var0_0.AddChatMsg(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetIsland():GetVisitorAgency()
	local var1_56 = getProxy(PlayerProxy):getRawData()
	local var2_56 = arg1_56.user_id == var1_56.id and var1_56 or var0_56:GetPlayer(arg1_56.user_id)

	if not var2_56 then
		return
	end

	local var3_56 = ChatProxy.InjectPublicMsg(arg1_56.content, Clone(var2_56))
	local var4_56 = ChatMsg.New(ChatConst.ChannelIsland, var3_56)

	getProxy(IslandProxy):AddChatMsg(arg1_56.island_id, var4_56)
end

function var0_0.UpdateActivityNpc(arg0_57, arg1_57)
	local var0_57 = arg0_57:GetIsland():GetActivityNpcAgency()

	for iter0_57, iter1_57 in ipairs(arg1_57.refresh_list) do
		local var1_57 = {
			id = iter1_57.id,
			object_id = iter1_57.object_id
		}

		if iter1_57.type == IslandConst.ACTIVITY_NPC_OP_TYPE_UPDATE then
			var0_57:UpdateNpc(var1_57)
		elseif iter1_57.type == IslandConst.ACTIVITY_NPC_OP_TYPE_ADD then
			var0_57:AddNpc(var1_57)
		elseif iter1_57.type == IslandConst.ACTIVITY_NPC_OP_TYPE_DEL then
			var0_57:RemoveNpc(var1_57)
		end
	end
end

function var0_0.UpdatePlayerDressupData(arg0_58, arg1_58)
	local var0_58 = arg0_58:GetIsland()
	local var1_58 = var0_58:GetVisitorAgency():GetPlayer(arg1_58.user_id)

	if not var1_58 then
		return
	end

	local var2_58 = {}

	for iter0_58, iter1_58 in ipairs(arg1_58.dress_list) do
		local var3_58 = iter1_58.type
		local var4_58 = iter1_58.id
		local var5_58 = 0

		for iter2_58, iter3_58 in ipairs(arg1_58.dress_color or {}) do
			if iter3_58.id == var4_58 then
				var5_58 = iter3_58.color
			end
		end

		local var6_58 = var1_58:GetDressByType(var3_58)
		local var7_58 = var1_58:GetCurrentColorByDressId(var6_58)

		if var6_58 ~= var4_58 then
			var2_58[var3_58] = {
				changeedDressId = var4_58,
				changedDressColorId = var5_58
			}
		elseif var7_58 ~= var5_58 then
			var2_58[var3_58] = {
				changedDressColorId = var5_58
			}
		end
	end

	var0_58:DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.CHANGE_VISTER_DRESS, {
		id = arg1_58.user_id,
		changeDressData = var2_58
	})
	var1_58:ChangeDressupData(arg1_58.dress_list, arg1_58.dress_color)
end

return var0_0
