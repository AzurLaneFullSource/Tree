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

		arg0_1:HandleAgoraData(arg0_3.update_list, arg0_3.delete_list, arg0_3.add_list)
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
	arg0_1:on(21518, function(arg0_6)
		arg0_1:HandleSlotFormulaData(arg0_6)
	end)
	arg0_1:on(21519, function(arg0_7)
		arg0_1:HandleBuildUnlockData(arg0_7)
	end)
end

function var0_0.HandleAgoraData(arg0_8, arg1_8, arg2_8, arg3_8)
	if getProxy(IslandProxy):GetIsland().id == arg0_8:GetIsland().id then
		return
	end

	local var0_8 = arg0_8:GetIsland():GetAgoraAgency()

	var0_8:DeletePlacements(arg2_8)
	var0_8:AddPlacements(arg3_8)
	var0_8:UpdatePlacements(arg1_8)
end

function var0_0.HandlePlayerData(arg0_9, arg1_9)
	if arg1_9.state == IslandConst.PLAYER_DATA_STATE_EMPTY then
		arg0_9:UpdatePlayerData(arg1_9)
	elseif arg1_9.state == IslandConst.PLAYER_DATA_STATE_ENTER then
		arg0_9:HandlePlayerEnter(arg1_9)
	elseif arg1_9.state == IslandConst.PLAYER_DATA_STATE_EXIT then
		arg0_9:HandlePlayerExit(arg1_9.id)
	end
end

function var0_0.HandlePlayerExit(arg0_10, arg1_10)
	if arg0_10:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_10] then
		arg0_10:GetIsland():GetVisitorAgency():DeletePlayer(arg1_10)
	end
end

function var0_0.HandlePlayerEnter(arg0_11, arg1_11)
	local var0_11 = arg1_11.id

	if not arg0_11:GetIsland():GetVisitorAgency():GetPlayerList()[var0_11] then
		local var1_11 = IslandPlayer.New({
			id = var0_11
		})

		arg0_11:GetIsland():GetVisitorAgency():AddPlayer(var1_11)
		arg0_11:UpdatePlayerData(arg1_11)
	end
end

function var0_0.UpdatePlayerData(arg0_12, arg1_12)
	arg0_12:GetIsland():GetVisitorAgency():GetPlayerList()[arg1_12.id]:UpdateName(arg1_12.name)
end

function var0_0.HandleOrderData(arg0_13, arg1_13)
	arg0_13:GetIsland():GetOrderAgency():UpdateOrAddOrder(arg1_13)
end

function var0_0.HandleTaskData(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetIsland():GetTaskAgency()

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		local var1_14 = underscore.all(iter1_14.process_list, function(arg0_15)
			return arg0_15.target_count == 0
		end)
		local var2_14 = IslandTask.New(iter1_14)

		if var1_14 then
			var0_14:AddTask(var2_14)
		else
			var0_14:UpdateTask(var2_14)
		end
	end
end

function var0_0.HandleSlotFormulaData(arg0_16, arg1_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var1_16 = arg1_16.area_id
	local var2_16 = pg.island_production_slot[var1_16].place

	var0_16:GetBuilding(var2_16):GetDelegationSlotData(var1_16):ResetFormulaNum(arg1_16)
end

function var0_0.HandleBuildUnlockData(arg0_17, arg1_17)
	getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitBuildData(arg1_17)
end

return var0_0
