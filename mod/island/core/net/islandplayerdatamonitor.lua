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
		arg0_1:HandleRandomTaskData(arg0_6.task_list_random)
	end)
	arg0_1:on(21422, function(arg0_7)
		arg0_1:HandleManageData(arg0_7)
	end)
	arg0_1:on(21053, function(arg0_8)
		arg0_1:HandleAchievementData(arg0_8.event_list)
	end)
	arg0_1:on(21518, function(arg0_9)
		if arg0_9.type == 1 or arg0_9.type == 3 then
			arg0_1:HandleSlotFormulaData(arg0_9)
		end

		if arg0_9.type == 1 or arg0_9.type == 2 then
			getProxy(IslandProxy):GetIsland():GetBuildingAgency():AddFormulaNum(arg0_9.formula_id, arg0_9.num)
		end
	end)
	arg0_1:on(21519, function(arg0_10)
		arg0_1:HandleBuildUnlockData(arg0_10)
	end)
	arg0_1:on(21515, function(arg0_11)
		arg0_1:HandleHandSlotUnlockData(arg0_11)
	end)
	arg0_1:on(21314, function(arg0_12)
		arg0_1:HandleSignInNotify(arg0_12)
		getProxy(IslandProxy):UpdateGiftTagCache(arg0_12.island_id, arg0_12.gift_count, arg0_12.gift_timestamp)

		if not arg0_1:IsSelf(arg0_12.island_id) then
			return
		end

		arg0_1:HandleSignInData(arg0_12)
	end)
	arg0_1:on(21528, function(arg0_13)
		if not arg0_1:IsSelf(arg0_13.island_id) then
			return
		end

		arg0_1:HandleWildGatherInData(arg0_13)
	end)
	arg0_1:on(21535, function(arg0_14)
		if not arg0_1:IsSelf(arg0_14.island_id) then
			return
		end

		arg0_1:HandleWildCollectInData(arg0_14)
	end)
	arg0_1:on(21227, function(arg0_15)
		if not arg0_1:IsSelf(arg0_15.island_id) then
			return
		end

		arg0_1:HandleAbilityData(arg0_15)
	end)
	arg0_1:on(21225, function(arg0_16)
		if not arg0_1:IsSelf(arg0_16.island_id) then
			return
		end

		arg0_1:SyncStartManage(arg0_16)
	end)
	arg0_1:on(21220, function(arg0_17)
		if not arg0_1:IsSelf(arg0_17.island_id) then
			return
		end

		arg0_1:SyncStartDelegation(arg0_17)
	end)
	arg0_1:on(21226, function(arg0_18)
		if not arg0_1:IsSelf(arg0_18.island_id) then
			return
		end

		arg0_1:SyncEndDelegation(arg0_18)
	end)
	arg0_1:on(21222, function(arg0_19)
		if not arg0_1:IsSelf(arg0_19.island_id) then
			return
		end

		arg0_1:SyncResetSlotData(arg0_19)
	end)
	arg0_1:on(21221, function(arg0_20)
		if not arg0_1:IsSelf(arg0_20.island_id) then
			return
		end

		arg0_1:SyncStarthHandPlant(arg0_20)
	end)
end

function var0_0.HandleAgoraData(arg0_21, arg1_21)
	if getProxy(IslandProxy):GetIsland().id == arg0_21:GetIsland().id then
		return
	end

	arg0_21:GetIsland():GetAgoraAgency():UpdatePlacedData(arg1_21)
end

function var0_0.HandlePlayerData(arg0_22, arg1_22)
	warning("HandlePlayerData>>>>>>>>>", arg1_22.state, arg1_22.map_id, arg1_22.id)

	if arg1_22.state == IslandConst.PLAYER_DATA_STATE_EMPTY then
		arg0_22:UpdatePlayerData(arg1_22)
	elseif arg1_22.state == IslandConst.PLAYER_DATA_STATE_ENTER then
		arg0_22:HandlePlayerEnter(arg1_22)
	elseif arg1_22.state == IslandConst.PLAYER_DATA_STATE_EXIT then
		arg0_22:HandlePlayerExit(arg1_22.id)
	end
end

function var0_0.HandlePlayerExit(arg0_23, arg1_23)
	if arg0_23:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_23] then
		arg0_23:GetIsland():GetVisitorAgency():DeletePlayer(arg1_23)
	end

	if arg0_23:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_23] then
		arg0_23:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_23)
	end
end

function var0_0.HandlePlayerEnter(arg0_24, arg1_24)
	local var0_24 = arg1_24.id

	if not arg0_24:GetIsland():GetVisitorAgency():GetPlayerList()[var0_24] then
		local var1_24 = IslandPlayer.New(arg1_24)

		arg0_24:GetIsland():GetVisitorAgency():AddPlayer(var1_24)

		if var1_24:IsInMap(arg0_24:GetIsland():GetMapId()) then
			arg0_24:GetIsland():GetVisitorAgency():AddMapVisitor(var1_24)
		end
	end
end

function var0_0.UpdatePlayerData(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_25.id]

	if var0_25 then
		var0_25:Flush(arg1_25)
	end

	local var1_25 = var0_25 and var0_25:IsInMap(arg0_25:GetIsland():GetMapId())
	local var2_25 = arg0_25:GetIsland():GetVisitorAgency():GetMapVisitorList()[arg1_25.id]

	if var1_25 and not var2_25 then
		arg0_25:GetIsland():GetVisitorAgency():AddMapVisitor(var0_25)
	elseif not var1_25 and var2_25 then
		arg0_25:GetIsland():GetVisitorAgency():DeleteMapVisitor(arg1_25.id)
	elseif var1_25 and var2_25 then
		var2_25:Flush(arg1_25)
	end
end

function var0_0.HandleOrderData(arg0_26, arg1_26)
	arg0_26:GetIsland():GetOrderAgency():UpdateOrAddOrder(arg1_26)
end

function var0_0.HandleTaskData(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetIsland():GetTaskAgency()

	for iter0_27, iter1_27 in ipairs(arg1_27) do
		local var1_27 = underscore.all(iter1_27.process_list, function(arg0_28)
			return arg0_28.target_count == 0
		end)
		local var2_27 = IslandTask.New(iter1_27)

		if var1_27 then
			var0_27:AddTask(var2_27)
		else
			var0_27:UpdateTask(var2_27)
		end
	end
end

function var0_0.HandleRandomTaskData(arg0_29, arg1_29)
	arg0_29:GetIsland():GetTaskAgency():InitFutureTasks(arg1_29 or {})
end

function var0_0.HandleManageData(arg0_30, arg1_30)
	local var0_30 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	if arg1_30.type == 1 then
		var0_30:DailyRefresh(arg1_30)
	elseif arg1_30.type == 2 then
		var0_30:UnlockDailyEvent(arg1_30)
	end
end

function var0_0.HandleAchievementData(arg0_31, arg1_31)
	local var0_31 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	for iter0_31, iter1_31 in ipairs(arg1_31) do
		var0_31:UpdateRecord(iter1_31.event_type, iter1_31.event_arg, iter1_31.value)
	end
end

function var0_0.HandleSlotFormulaData(arg0_32, arg1_32)
	local var0_32 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_32 = arg1_32.area_id
	local var2_32 = pg.island_production_slot[var1_32].place

	var0_32:GetBuilding(var2_32):GetDelegationSlotData(var1_32):AddFormulaNum(arg1_32)
end

function var0_0.HandleBuildUnlockData(arg0_33, arg1_33)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitBuildData(arg1_33.build)
end

function var0_0.HandleHandSlotUnlockData(arg0_34, arg1_34)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitHandSlotData(arg1_34.collect)
end

function var0_0.HandleSignInData(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetIsland():GetSignInAgency()

	var0_35:UpdateGiftEndTime(arg1_35.gift_timestamp)
	var0_35:UpdateFetchedList(arg1_35.gift_visitor)
	var0_35:SetGiftCnt(arg1_35.gift_count)
end

function var0_0.HandleSignInNotify(arg0_36, arg1_36)
	if arg1_36.cmd == 2 then
		local var0_36 = getProxy(FriendProxy):getFriend(arg1_36.island_id)
		local var1_36 = var0_36 and var0_36:GetName() or ""
		local var2_36 = IslandVisitorLog.New({
			id = arg1_36.island_id,
			cmd = IslandConst.VISITOR_LOG_CMD_GIFT,
			name = var1_36,
			time = pg.TimeMgr.GetInstance():GetServerTime()
		})

		pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var2_36)
	end
end

function var0_0.HandleWildGatherInData(arg0_37, arg1_37)
	arg0_37:GetIsland():GetWildCollectAgency():UpdateGatherData(arg1_37)
end

function var0_0.HandleWildCollectInData(arg0_38, arg1_38)
	arg0_38:GetIsland():GetWildCollectAgency():UpdateCollectFragmentData(arg1_38)
end

function var0_0.HandleAbilityData(arg0_39, arg1_39)
	local var0_39 = getProxy(IslandProxy):GetSharedIsland()

	if not var0_39 then
		return
	end

	var0_39:GetAblityAgency():AddAblity(arg1_39.ability_id)
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

function var0_0.SyncStartDelegation(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetIsland()
	local var1_41 = var0_41:GetBuildingAgency()
	local var2_41 = pg.island_production_slot[arg1_41.appoint_data.id].place

	var1_41:GetBuilding(var2_41):UpdateDeleationRoleDataBySlotId(arg1_41.appoint_data.id, arg1_41.appoint_data)

	local var3_41 = arg1_41.appoint_data.ship_id
	local var4_41 = arg1_41.appoint_data.id

	var0_41:DispatchEvent(IslandStartDelegationCommand.START_DELEGATION, {
		build_id = var2_41,
		ship_id = var3_41,
		area_id = var4_41
	})
end

function var0_0.SyncEndDelegation(arg0_42, arg1_42)
	local var0_42 = arg0_42:GetIsland()
	local var1_42 = island:GetBuildingAgency():GetBuilding(arg0_42.buildId)
	local var2_42 = arg0_42.islandRoleDelegationData.formula_id
	local var3_42 = arg0_42.islandRoleDelegationData.ship_id
	local var4_42 = arg0_42.id

	var1_42:UpdateDeleationRewardDataBySlotId(arg0_42.id, {
		formula_id = var2_42
	})
	var1_42:UpdateDeleationRoleDataBySlotId(arg0_42.id, nil)
	var0_42:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
		remainReward = true,
		build_id = build_id,
		ship_id = var3_42,
		area_id = var4_42
	})
end

function var0_0.SyncResetSlotData(arg0_43, arg1_43)
	local var0_43 = arg0_43:GetIsland()
	local var1_43 = var0_43:GetBuildingAgency()

	for iter0_43, iter1_43 in ipairs(arg1_43.slot_list) do
		local var2_43 = pg.island_production_slot[iter1_43]
		local var3_43 = var2_43.place
		local var4_43 = var1_43:GetBuilding(var3_43)

		if var2_43.type == 9 or var2_43.type == 3 then
			local var5_43 = var4_43:GetDelegationSlotData(iter1_43)
			local var6_43 = var5_43 and var5_43:GetSlotRoleData()

			if var6_43 then
				local var7_43 = var6_43.ship_id
				local var8_43 = iter1_43

				var4_43:UpdateDeleationRoleDataBySlotId(iter1_43, nil)
				var0_43:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
					remainReward = false,
					build_id = var3_43,
					ship_id = var7_43,
					area_id = var8_43
				})
			end

			var4_43:UpdateDeleationRewardDataBySlotId(iter1_43, nil)
			var0_43:DispatchEvent(IslandBuildingAgency.SLOT_RESET_DELEGATION_STATE_DONE, {
				build_id = var3_43,
				area_id = iter1_43
			})
		elseif var2_43.type == 1 then
			var4_43:UpdateHandPlantDataBySlotId({
				formula_id = 0,
				end_time = 0,
				state = 0,
				id = iter1_43
			})
			var0_43:DispatchEvent(IslandSlotHandPlantAwardCommand.START_HANDPLANT_AWARD_DONE, {
				build_id = var3_43,
				area_id = iter1_43
			})
		end
	end
end

function var0_0.SyncStarthHandPlant(arg0_44, arg1_44)
	local var0_44 = arg0_44:GetIsland()
	local var1_44 = var0_44:GetBuildingAgency()

	for iter0_44, iter1_44 in ipairs(arg1_44.hand_list) do
		local var2_44 = pg.island_production_slot[iter1_44.id].place

		var1_44:GetBuilding(var2_44):UpdateHandPlantDataBySlotId(iter1_44)
		var0_44:DispatchEvent(IslandSlotHandPlantCommand.START_HANDPLANT_DONE, {
			build_id = var2_44,
			area_id = iter1_44.id,
			formula_id = iter1_44.formula_id
		})
	end
end

return var0_0
