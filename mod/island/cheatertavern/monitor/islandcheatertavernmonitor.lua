local var0_0 = class("IslandCheaterTavernMonitor", import("...Core.Net.IslandBaseMonitor"))

var0_0.ADD_CHEATERTAVERN_PLAYER = "IslandCheaterTavernMonitor:ADD_CHEATERTAVERN_PLAYER"
var0_0.INIT_PLAYER_DATA_DONE = "IslandCheaterTavernMonitor:INIT_PLAYER_DATA_DONE"

function var0_0.register(arg0_1)
	arg0_1.cheaterTavernAgency = arg0_1:GetIsland():GetCheaterTavernAgency()

	arg0_1:on(23101, function(arg0_2)
		arg0_1.cheaterTavernAgency:SetIsConnecting(true)

		if IslandCheaterTavernConst.changeSeat then
			local var0_2

			for iter0_2, iter1_2 in ipairs(arg0_2.player_list) do
				if iter1_2.user_id == getProxy(PlayerProxy):getRawData().id then
					var0_2 = iter1_2.seat
				end
			end

			local function var1_2(arg0_3, arg1_3, arg2_3)
				return (arg0_3 - arg1_3 + arg2_3 - 1) % 4 + 1
			end

			for iter2_2, iter3_2 in ipairs(arg0_2.player_list) do
				iter3_2.seat = var1_2(iter3_2.seat, var0_2, IslandCheaterTavernConst.currentMainSeat)
			end
		end

		arg0_1.cheaterTavernAgency:SetStartGameData(arg0_2)

		if arg0_1.cheaterTavernAgency:IsUILoadOver() then
			arg0_1:StartCheaterTevernGame(arg0_2)
			arg0_1:InitPlayerDate(arg0_2)
		else
			arg0_1.cheaterTavernAgency:AddCacheFunc(function()
				arg0_1:StartCheaterTevernGame(arg0_2)
				arg0_1:InitPlayerDate(arg0_2)
			end)
		end
	end)
	arg0_1:on(23102, function(arg0_5)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		arg0_1:CheaterTevernGameEveryRound(arg0_5)
	end)
	arg0_1:on(23105, function(arg0_6)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		if arg0_1.cheaterTavernAgency:IsUILoadOver() then
			arg0_1:PlayOperateHandle(arg0_6)
		else
			arg0_1.cheaterTavernAgency:AddCacheFunc(function()
				arg0_1:PlayOperateHandle(arg0_6)
			end)
		end
	end)
	arg0_1:on(23108, function(arg0_8)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		local var0_8 = getProxy(ActivityProxy)
		local var1_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_CHEAT_BAR)
		local var2_8

		if arg0_1.cheaterTavernAgency:GetRoomType() == 1 then
			var2_8 = 0
		else
			var2_8 = arg0_8.cur_score - var1_8.data1
			var1_8.data1 = arg0_8.cur_score
			var1_8.data2 = math.max(arg0_8.cur_score, var1_8.data2)

			var0_8:updateActivity(var1_8)
		end

		arg0_1.cheaterTavernAgency:GetMainPlayer():SetGameData(arg0_8.rank, var2_8)
		pg.m02:sendNotification(GAME.ISLAND_CHEATER_END_SCORE_NOTIFY, arg0_8)

		local var3_8 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_BAR_SIGN_ACT_ID)

		if var3_8[1] then
			pg.m02:sendNotification(GAME.MINI_GAME_TASK_PROGRESS_UPDATE, {
				progressAdd = 1,
				actId = ActivityConst.ISLAND_BAR_SIGN_ACT_ID,
				taskId = var3_8[1].id
			})
		end
	end)
	arg0_1:on(23116, function(arg0_9)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		pg.m02:sendNotification(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_9)
	end)
	arg0_1:on(23115, function(arg0_10)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		arg0_1.cheaterTavernAgency:UpdatePlayerDelegateState(arg0_10.user_id, arg0_10.state)
		pg.m02:sendNotification(GAME.ISLAND_CHEATER_DELEGATE_NOTIFY)
	end)
	arg0_1:on(23117, function(arg0_11)
		local var0_11 = getProxy(ActivityProxy)
		local var1_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_CHEAT_BAR)
		local var2_11 = arg0_11.cur_score - var1_11.data1

		var1_11.data1 = arg0_11.cur_score
		var1_11.data2 = math.max(arg0_11.cur_score, var1_11.data2)

		var0_11:updateActivity(var1_11)
	end)
end

function var0_0.InitPlayerDate(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg1_12.player_list or {}) do
		local var0_12 = iter1_12.seat
		local var1_12 = iter1_12.player_info
		local var2_12 = {
			user_view = PlayRoomTools.GetGameViewID(var1_12.user_view),
			seat = var0_12,
			id = var1_12.id
		}

		arg0_12:GetIsland():DispatchEvent(IslandCheaterTavernMonitor.ADD_CHEATERTAVERN_PLAYER, var2_12)
	end

	arg0_12:GetIsland():DispatchEvent(IslandCheaterTavernMonitor.INIT_PLAYER_DATA_DONE)
end

function var0_0.Init(arg0_13)
	return
end

function var0_0.StartCheaterTevernGame(arg0_14, arg1_14)
	local var0_14 = {
		user_id = arg1_14.user_id,
		operationType = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCard,
		auto_time = arg1_14.auto_time
	}

	pg.m02:sendNotification(GAME.ISLAND_CHEATER_FIRSTROND_START, {
		operation = var0_14
	})
end

function var0_0.CheaterTevernGameEveryRound(arg0_15, arg1_15)
	arg0_15.cheaterTavernAgency:UpdateGameDataEveryRound(arg1_15)

	local var0_15 = {
		user_id = arg1_15.user_id,
		operationType = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCard,
		auto_time = arg1_15.auto_time
	}

	pg.m02:sendNotification(GAME.ISLAND_CHEATER_FIRSTROND_START, {
		operation = var0_15
	})
end

function var0_0.PlayOperateHandle(arg0_16, arg1_16)
	local var0_16 = arg1_16.user_id
	local var1_16 = arg1_16.return_list
	local var2_16 = getProxy(PlayerProxy):getRawData().id
	local var3_16

	switch(arg1_16.type, {
		[IslandCheaterTavernConst.PlayerOperateType.PutCard] = function()
			local var0_17 = var1_16[1] == 1
			local var1_17 = var1_16[2]

			if var0_17 and var0_16 == getProxy(PlayerProxy):getRawData().id then
				var3_16 = arg0_16.cheaterTavernAgency:GetMainPlayerAutoPutCard(var1_17)

				arg0_16.cheaterTavernAgency:MainPlayerPutCard(var3_16)
			end

			arg0_16.cheaterTavernAgency:ReducePlayerCardNum(var0_16, var1_17)

			if var0_16 == var2_16 then
				IslandCheaterTavernRecordTools.AddRoundCnt()
				IslandCheaterTavernRecordTools.StopPutCardTime()
			end
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Query] = function()
			return
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Shoot] = function()
			local var0_19 = var1_16[1]
			local var1_19 = var1_16[2]

			warning(tostring(var0_16) .. "PlayOperateHandle" .. tostring(var0_19))
			arg0_16.cheaterTavernAgency:UpdatePlayerBombState(var0_16, var0_19, var1_19)
		end
	}, function()
		return
	end)
	pg.m02:sendNotification(GAME.ISLAND_CHEATER_OPERATE_DONE_NOTIFY, {
		data = arg1_16,
		putCard = var3_16
	})
end

return var0_0
