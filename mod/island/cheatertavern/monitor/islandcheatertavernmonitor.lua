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

		onNextTick(function()
			arg0_1:StartCheaterTevernGame(arg0_2)
			arg0_1:InitPlayerDate(arg0_2)
		end)
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

		arg0_1:PlayOperateHandle(arg0_6)
	end)
	arg0_1:on(23108, function(arg0_7)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		local var0_7 = getProxy(ActivityProxy)
		local var1_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_CHEAT_BAR)
		local var2_7

		if arg0_1.cheaterTavernAgency:GetRoomType() == 1 then
			var2_7 = 0
		else
			var2_7 = arg0_7.cur_score - var1_7.data1
			var1_7.data1 = arg0_7.cur_score
			var1_7.data2 = math.max(arg0_7.cur_score, var1_7.data2)

			var0_7:updateActivity(var1_7)
		end

		arg0_1.cheaterTavernAgency:GetMainPlayer():SetGameData(arg0_7.rank, var2_7)
		pg.m02:sendNotification(GAME.ISLAND_CHEATER_END_SCORE_NOTIFY, arg0_7)

		local var3_7 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_BAR_SIGN_ACT_ID)

		if var3_7[1] then
			pg.m02:sendNotification(GAME.MINI_GAME_TASK_PROGRESS_UPDATE, {
				progressAdd = 1,
				actId = ActivityConst.ISLAND_BAR_SIGN_ACT_ID,
				taskId = var3_7[1].id
			})
		end
	end)
	arg0_1:on(23116, function(arg0_8)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		pg.m02:sendNotification(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_8)
	end)
	arg0_1:on(23115, function(arg0_9)
		if not arg0_1.cheaterTavernAgency:IsConnecting() then
			return
		end

		arg0_1.cheaterTavernAgency:UpdatePlayerDelegateState(arg0_9.user_id, arg0_9.state)
		pg.m02:sendNotification(GAME.ISLAND_CHEATER_DELEGATE_NOTIFY)
	end)
	arg0_1:on(23117, function(arg0_10)
		local var0_10 = getProxy(ActivityProxy)
		local var1_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_CHEAT_BAR)
		local var2_10 = arg0_10.cur_score - var1_10.data1

		var1_10.data1 = arg0_10.cur_score
		var1_10.data2 = math.max(arg0_10.cur_score, var1_10.data2)

		var0_10:updateActivity(var1_10)
	end)
end

function var0_0.InitPlayerDate(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg1_11.player_list or {}) do
		local var0_11 = iter1_11.seat
		local var1_11 = iter1_11.player_info
		local var2_11 = {
			user_view = PlayRoomTools.GetGameViewID(var1_11.user_view),
			seat = var0_11,
			id = var1_11.id
		}

		arg0_11:GetIsland():DispatchEvent(IslandCheaterTavernMonitor.ADD_CHEATERTAVERN_PLAYER, var2_11)
	end

	arg0_11:GetIsland():DispatchEvent(IslandCheaterTavernMonitor.INIT_PLAYER_DATA_DONE)
end

function var0_0.Init(arg0_12)
	return
end

function var0_0.StartCheaterTevernGame(arg0_13, arg1_13)
	arg0_13.cheaterTavernAgency:SetStartGameData(arg1_13)

	local var0_13 = {
		user_id = arg1_13.user_id,
		operationType = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCard,
		auto_time = arg1_13.auto_time
	}

	pg.m02:sendNotification(GAME.ISLAND_CHEATER_FIRSTROND_START, {
		operation = var0_13
	})
end

function var0_0.CheaterTevernGameEveryRound(arg0_14, arg1_14)
	arg0_14.cheaterTavernAgency:UpdateGameDataEveryRound(arg1_14)

	local var0_14 = {
		user_id = arg1_14.user_id,
		operationType = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCard,
		auto_time = arg1_14.auto_time
	}

	pg.m02:sendNotification(GAME.ISLAND_CHEATER_FIRSTROND_START, {
		operation = var0_14
	})
end

function var0_0.PlayOperateHandle(arg0_15, arg1_15)
	local var0_15 = arg1_15.user_id
	local var1_15 = arg1_15.return_list
	local var2_15 = getProxy(PlayerProxy):getRawData().id
	local var3_15

	switch(arg1_15.type, {
		[IslandCheaterTavernConst.PlayerOperateType.PutCard] = function()
			local var0_16 = var1_15[1] == 1
			local var1_16 = var1_15[2]

			if var0_16 and var0_15 == getProxy(PlayerProxy):getRawData().id then
				var3_15 = arg0_15.cheaterTavernAgency:GetMainPlayerAutoPutCard(var1_16)

				arg0_15.cheaterTavernAgency:MainPlayerPutCard(var3_15)
			end

			arg0_15.cheaterTavernAgency:ReducePlayerCardNum(var0_15, var1_16)

			if var0_15 == var2_15 then
				IslandCheaterTavernRecordTools.AddRoundCnt()
				IslandCheaterTavernRecordTools.StopPutCardTime()
			end
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Query] = function()
			return
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Shoot] = function()
			local var0_18 = var1_15[1]
			local var1_18 = var1_15[2]

			warning(tostring(var0_15) .. "PlayOperateHandle" .. tostring(var0_18))
			arg0_15.cheaterTavernAgency:UpdatePlayerBombState(var0_15, var0_18, var1_18)
		end
	}, function()
		return
	end)
	pg.m02:sendNotification(GAME.ISLAND_CHEATER_OPERATE_DONE_NOTIFY, {
		data = arg1_15,
		putCard = var3_15
	})
end

return var0_0
