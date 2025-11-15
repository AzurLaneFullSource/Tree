local var0_0 = class("IslandPlayerDataMonitor", import(".IslandBaseMonitor"))

function var0_0.register(arg0_1)
	arg0_1:on(21206, function(arg0_2)
		if not arg0_1:IsSelf(arg0_2.island_id) then
			return
		end

		for iter0_2, iter1_2 in ipairs(arg0_2.player_list) do
			arg0_1:HandlePlayerData(iter1_2)
		end
	end)
	arg0_1:on(21309, function(arg0_3)
		if not arg0_1:IsSelf(arg0_3.island_id) then
			return
		end

		arg0_1:HandleAgoraData(arg0_3.update_data)
	end)
	arg0_1:on(21407, function(arg0_4)
		if not arg0_1:IsSelf(arg0_4.island_id) then
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

		if not arg0_1:IsSelf(arg0_13.island_id) then
			return
		end

		arg0_1:HandleSignInData(arg0_13)
	end)
	arg0_1:on(21528, function(arg0_14)
		if not arg0_1:IsSelf(arg0_14.island_id) then
			return
		end

		arg0_1:HandleWildGatherInData(arg0_14)
	end)
	arg0_1:on(21535, function(arg0_15)
		if not arg0_1:IsSelf(arg0_15.island_id) then
			return
		end

		arg0_1:HandleWildCollectInData(arg0_15)
	end)
	arg0_1:on(21227, function(arg0_16)
		if not arg0_1:IsSelf(arg0_16.island_id) then
			return
		end

		arg0_1:HandleAbilityData(arg0_16)
	end)
	arg0_1:on(21225, function(arg0_17)
		if not arg0_1:IsSelf(arg0_17.island_id) then
			return
		end

		arg0_1:SyncStartManage(arg0_17)
	end)
	arg0_1:on(21220, function(arg0_18)
		if not arg0_1:IsSelf(arg0_18.island_id) then
			return
		end

		arg0_1:SyncStartDelegation(arg0_18)
	end)
	arg0_1:on(21226, function(arg0_19)
		if not arg0_1:IsSelf(arg0_19.island_id) then
			return
		end

		arg0_1:SyncEndDelegation(arg0_19)
	end)
	arg0_1:on(21222, function(arg0_20)
		if not arg0_1:IsSelf(arg0_20.island_id) then
			return
		end

		arg0_1:SyncResetSlotData(arg0_20)
	end)
	arg0_1:on(21221, function(arg0_21)
		if not arg0_1:IsSelf(arg0_21.island_id) then
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
		if not arg0_1:IsSelf(arg0_24.island_id) then
			return
		end

		arg0_1:UpdateActivityNpc(arg0_24)
	end)
	arg0_1:on(21224, function(arg0_25)
		if not arg0_1:IsSelf(arg0_25.island_id) then
			return
		end

		arg0_1:UpdatePlayerDressupData(arg0_25)
	end)
end

function var0_0.HandleAgoraData(arg0_26, arg1_26)
	if getProxy(IslandProxy):GetIsland().id == arg0_26:GetIsland().id then
		return
	end

	arg0_26:GetIsland():GetAgoraAgency():UpdatePlacedData(arg1_26)
end

function var0_0.HandlePlayerData(arg0_27, arg1_27)
	warning("HandlePlayerData>>>>>>>>>", arg1_27.state, arg1_27.map_id, arg1_27.id)

	if arg1_27.state == IslandConst.PLAYER_DATA_STATE_EMPTY then
		arg0_27:UpdatePlayerData(arg1_27)
	elseif arg1_27.state == IslandConst.PLAYER_DATA_STATE_ENTER then
		arg0_27:HandlePlayerEnter(arg1_27)
	elseif arg1_27.state == IslandConst.PLAYER_DATA_STATE_EXIT then
		arg0_27:HandlePlayerExit(arg1_27.id)
	end
end

function var0_0.HandlePlayerExit(arg0_28, arg1_28)
	if arg0_28:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_28] then
		arg0_28:GetIsland():GetVisitorAgency():DeletePlayer(arg1_28)
	end

	if arg0_28:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_28] then
		arg0_28:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_28)
	end
end

function var0_0.HandlePlayerEnter(arg0_29, arg1_29)
	local var0_29 = arg1_29.id

	if not arg0_29:GetIsland():GetVisitorAgency():GetPlayerList()[var0_29] then
		local var1_29 = IslandPlayer.New(arg1_29)

		arg0_29:GetIsland():GetVisitorAgency():AddPlayer(var1_29)

		if var1_29:IsInMap(arg0_29:GetIsland():GetMapId()) then
			arg0_29:GetIsland():GetVisitorAgency():AddMapVisitor(var1_29)
		end
	end
end

function var0_0.UpdatePlayerData(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_30.id]

	if var0_30 then
		var0_30:Flush(arg1_30)
	end

	local var1_30 = var0_30 and var0_30:IsInMap(arg0_30:GetIsland():GetMapId())
	local var2_30 = arg0_30:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_30.id]

	if var1_30 and not var2_30 then
		arg0_30:GetIsland():GetVisitorAgency():AddMapVisitor(var0_30)
	elseif not var1_30 and var2_30 then
		arg0_30:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_30.id)
	elseif var1_30 and var2_30 then
		var2_30:Flush(arg1_30)
	end
end

function var0_0.HandleOrderData(arg0_31, arg1_31)
	arg0_31:GetIsland():GetOrderAgency():UpdateOrAddOrder(arg1_31)
end

function var0_0.HandleTaskData(arg0_32, arg1_32)
	local var0_32 = arg0_32:GetIsland():GetTaskAgency()

	for iter0_32, iter1_32 in ipairs(arg1_32) do
		local var1_32 = underscore.all(iter1_32.process_list, function(arg0_33)
			return arg0_33.target_count == 0
		end)
		local var2_32 = IslandTask.New(iter1_32)

		if var1_32 then
			var0_32:AddTask(var2_32)
		else
			var0_32:UpdateTask(var2_32)
		end
	end
end

function var0_0.HandleRandomTaskData(arg0_34, arg1_34)
	arg0_34:GetIsland():GetTaskAgency():InitFutureTasks(arg1_34.task_list_random or {})

	local var0_34 = arg1_34.task_list or {}
	local var1_34 = arg0_34:GetIsland():GetTaskAgency()

	for iter0_34, iter1_34 in ipairs(var0_34) do
		local var2_34 = IslandTask.New(iter1_34)

		var1_34:AddTask(var2_34)
	end

	if #var0_34 > 0 then
		var1_34:TryAutoTrackTask()
	end
end

function var0_0.HandleManageData(arg0_35, arg1_35)
	local var0_35 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	if arg1_35.type == 1 then
		var0_35:DailyRefresh(arg1_35)
	elseif arg1_35.type == 2 then
		var0_35:UnlockDailyEvent(arg1_35)
	end
end

function var0_0.HandleAchievementData(arg0_36, arg1_36)
	local var0_36 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	for iter0_36, iter1_36 in ipairs(arg1_36) do
		var0_36:UpdateRecord(iter1_36.event_type, iter1_36.event_arg, iter1_36.value)
	end
end

function var0_0.HandleBookData(arg0_37, arg1_37)
	getProxy(IslandProxy):GetIsland():GetBookAgency():HandlePushData(arg1_37)
end

function var0_0.HandleSlotFormulaData(arg0_38, arg1_38)
	local var0_38 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_38 = arg1_38.area_id
	local var2_38 = pg.island_production_slot[var1_38].place

	var0_38:GetBuilding(var2_38):GetDelegationSlotData(var1_38):AddFormulaNum(arg1_38)
end

function var0_0.HandleBuildUnlockData(arg0_39, arg1_39)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitBuildData(arg1_39.build)
end

function var0_0.HandleHandSlotUnlockData(arg0_40, arg1_40)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitHandSlotData(arg1_40.collect)
end

function var0_0.HandleSignInData(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetIsland():GetSignInAgency()

	var0_41:UpdateGiftEndTime(arg1_41.gift_timestamp)
	var0_41:UpdateFetchedList(arg1_41.gift_visitor)
	var0_41:SetGiftCnt(arg1_41.gift_count)
end

function var0_0.HandleSignInNotify(arg0_42, arg1_42)
	if arg1_42.cmd == 2 then
		local var0_42 = getProxy(FriendProxy):getFriend(arg1_42.island_id)
		local var1_42 = var0_42 and var0_42:GetName() or ""
		local var2_42 = IslandVisitorLog.New({
			id = arg1_42.island_id,
			cmd = IslandConst.VISITOR_LOG_CMD_GIFT,
			name = var1_42,
			time = pg.TimeMgr.GetInstance():GetServerTime()
		})

		if arg0_42:IsSelf(arg1_42.island_id) then
			local var3_42 = arg0_42:GetIsland():GetSignInAgency()
			local var4_42 = getProxy(PlayerProxy):getRawData().id

			var3_42:AddInviter(var4_42)
		end

		pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var2_42)
	end
end

function var0_0.HandleWildGatherInData(arg0_43, arg1_43)
	arg0_43:GetIsland():GetWildCollectAgency():UpdateGatherData(arg1_43)
end

function var0_0.HandleWildCollectInData(arg0_44, arg1_44)
	arg0_44:GetIsland():GetWildCollectAgency():UpdateCollectFragmentData(arg1_44)
end

function var0_0.HandleAbilityData(arg0_45, arg1_45)
	local var0_45 = getProxy(IslandProxy):GetSharedIsland()

	if not var0_45 then
		return
	end

	var0_45:GetAblityAgency():AddAblity(arg1_45.ability_id)
end

function var0_0.SyncStartManage(arg0_46, arg1_46)
	local var0_46 = getProxy(IslandProxy):GetIsland():GetManageAgency()
	local var1_46 = arg1_46.trade
	local var2_46 = var0_46:GetRestaurant(var1_46.id)

	if not var2_46 then
		var0_46:UnlockNewRestaurant(var1_46.id)

		var2_46 = var0_46:GetRestaurant(var1_46.id)
	end

	var2_46:UpdateData(var1_46)
	getProxy(IslandProxy):GetSharedIsland():DispatchEvent(IslandOpenRestaurantCommand.OPEN_RESTAURANT, {
		restId = var2_46.id,
		postList = var1_46.post_list
	})
end

function var0_0.SyncStartDelegation(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetIsland()
	local var1_47 = var0_47:GetBuildingAgency()
	local var2_47 = pg.island_production_slot[arg1_47.appoint_data.id].place

	var1_47:GetBuilding(var2_47):UpdateDeleationRoleDataBySlotId(arg1_47.appoint_data.id, arg1_47.appoint_data)

	local var3_47 = arg1_47.appoint_data.ship_id
	local var4_47 = arg1_47.appoint_data.id

	var0_47:DispatchEvent(IslandStartDelegationCommand.START_DELEGATION, {
		build_id = var2_47,
		ship_id = var3_47,
		area_id = var4_47
	})
end

function var0_0.SyncEndDelegation(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetIsland()
	local var1_48 = island:GetBuildingAgency():GetBuilding(arg0_48.buildId)
	local var2_48 = arg0_48.islandRoleDelegationData.formula_id
	local var3_48 = arg0_48.islandRoleDelegationData.ship_id
	local var4_48 = arg0_48.id

	var1_48:UpdateDeleationRewardDataBySlotId(arg0_48.id, {
		formula_id = var2_48
	})
	var1_48:UpdateDeleationRoleDataBySlotId(arg0_48.id, nil)
	var0_48:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
		remainReward = true,
		build_id = build_id,
		ship_id = var3_48,
		area_id = var4_48
	})
end

function var0_0.SyncResetSlotData(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetIsland()
	local var1_49 = var0_49:GetBuildingAgency()

	for iter0_49, iter1_49 in ipairs(arg1_49.slot_list) do
		local var2_49 = pg.island_production_slot[iter1_49]
		local var3_49 = var2_49.place
		local var4_49 = var1_49:GetBuilding(var3_49)

		if var2_49.type == 9 or var2_49.type == 3 then
			local var5_49 = var4_49:GetDelegationSlotData(iter1_49)
			local var6_49 = var5_49 and var5_49:GetSlotRoleData()

			if var6_49 then
				local var7_49 = var6_49.ship_id
				local var8_49 = iter1_49

				var4_49:UpdateDeleationRoleDataBySlotId(iter1_49, nil)
				var0_49:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
					remainReward = false,
					build_id = var3_49,
					ship_id = var7_49,
					area_id = var8_49
				})
			end

			var4_49:UpdateDeleationRewardDataBySlotId(iter1_49, nil)
			var0_49:DispatchEvent(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, {
				build_id = var3_49,
				area_id = iter1_49
			})
		elseif var2_49.type == 1 then
			var4_49:UpdateHandPlantDataBySlotId({
				formula_id = 0,
				end_time = 0,
				state = 0,
				id = iter1_49
			})
			var0_49:DispatchEvent(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, {
				build_id = var3_49,
				area_id = iter1_49
			})
		end
	end
end

function var0_0.SyncStarthHandPlant(arg0_50, arg1_50)
	local var0_50 = arg0_50:GetIsland()
	local var1_50 = var0_50:GetBuildingAgency()

	for iter0_50, iter1_50 in ipairs(arg1_50.hand_list) do
		local var2_50 = pg.island_production_slot[iter1_50.id].place

		var1_50:GetBuilding(var2_50):UpdateHandPlantDataBySlotId(iter1_50)
		var0_50:DispatchEvent(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, {
			build_id = var2_50,
			area_id = iter1_50.id,
			formula_id = iter1_50.formula_id
		})
	end
end

function var0_0.ResponeAniamtion(arg0_51, arg1_51)
	arg0_51:GetIsland():DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.RESPON_ANIMATION_OP, {
		id = arg1_51.player_id,
		targetId = arg1_51.target_id,
		actionId = arg1_51.action_id
	})
end

function var0_0.AddChatMsg(arg0_52, arg1_52)
	local var0_52 = arg0_52:GetIsland():GetVisitorAgency()
	local var1_52 = getProxy(PlayerProxy):getRawData()
	local var2_52 = arg1_52.user_id == var1_52.id and var1_52 or var0_52:GetPlayer(arg1_52.user_id)

	if not var2_52 then
		return
	end

	local var3_52 = ChatProxy.InjectPublicMsg(arg1_52.content, Clone(var2_52))
	local var4_52 = ChatMsg.New(ChatConst.ChannelIsland, var3_52)

	getProxy(IslandProxy):AddChatMsg(arg1_52.island_id, var4_52)
end

function var0_0.UpdateActivityNpc(arg0_53, arg1_53)
	local var0_53 = arg0_53:GetIsland():GetActivityNpcAgency()

	for iter0_53, iter1_53 in ipairs(arg1_53.refresh_list) do
		local var1_53 = {
			id = iter1_53.id,
			object_id = iter1_53.object_id
		}

		if iter1_53.type == IslandConst.ACTIVITY_NPC_OP_TYPE_UPDATE then
			var0_53:UpdateNpc(var1_53)
		elseif iter1_53.type == IslandConst.ACTIVITY_NPC_OP_TYPE_ADD then
			var0_53:AddNpc(var1_53)
		elseif iter1_53.type == IslandConst.ACTIVITY_NPC_OP_TYPE_DEL then
			var0_53:RemoveNpc(var1_53)
		end
	end
end

function var0_0.UpdatePlayerDressupData(arg0_54, arg1_54)
	local var0_54 = arg0_54:GetIsland()
	local var1_54 = var0_54:GetVisitorAgency():GetPlayer(arg1_54.user_id)

	if not var1_54 then
		return
	end

	local var2_54 = {}

	for iter0_54, iter1_54 in ipairs(arg1_54.dress_list) do
		local var3_54 = iter1_54.type
		local var4_54 = iter1_54.id
		local var5_54 = 0

		for iter2_54, iter3_54 in ipairs(arg1_54.dress_color or {}) do
			if iter3_54.id == var4_54 then
				var5_54 = iter3_54.color
			end
		end

		local var6_54 = var1_54:GetDressByType(var3_54)
		local var7_54 = var1_54:GetCurrentColorByDressId(var6_54)

		if var6_54 ~= var4_54 then
			var2_54[var3_54] = {
				changeedDressId = var4_54,
				changedDressColorId = var5_54
			}
		elseif var7_54 ~= var5_54 then
			var2_54[var3_54] = {
				changedDressColorId = var5_54
			}
		end
	end

	var0_54:DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.CHANGE_VISTER_DRESS, {
		id = arg1_54.user_id,
		changeDressData = var2_54
	})
	var1_54:ChangeDressupData(arg1_54.dress_list, arg1_54.dress_color)
end

return var0_0
