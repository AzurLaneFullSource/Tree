local var0_0 = {
	FilterRoomType = function(arg0_1, arg1_1)
		if arg1_1 == PlayRoomConst.PLAY_ROOM_TYPE.ALL then
			return Clone(arg0_1)
		end

		local var0_1 = {}

		for iter0_1, iter1_1 in ipairs(arg0_1) do
			if iter1_1.roomType == arg1_1 then
				table.insert(var0_1, iter1_1)
			end
		end

		return var0_1
	end,
	FilterRoomState = function(arg0_2, arg1_2)
		if arg1_2 == PlayRoomConst.PLAY_ROOM_STATE.ALL then
			return Clone(arg0_2)
		end

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2) do
			if iter1_2.roomState == arg1_2 then
				table.insert(var0_2, iter1_2)
			end
		end

		return var0_2
	end,
	SortRoomList = function(arg0_3, arg1_3, arg2_3)
		if PlayRoomConst.ROOM_SORT_TYPE.ROOM_CREATE_TIME == arg1_3 then
			if arg2_3 then
				return arg0_3
			else
				return _.reverse(arg0_3)
			end
		end

		table.sort(arg0_3, function(arg0_4, arg1_4)
			return switch(arg1_3, {
				[PlayRoomConst.ROOM_SORT_TYPE.ROOM_PLAYER_SUM] = function()
					if arg0_4.teamCnt == arg1_4.teamCnt then
						return arg0_4.roomState < arg1_4.roomState
					end

					if arg2_3 then
						return arg0_4.teamCnt < arg1_4.teamCnt
					else
						return arg0_4.teamCnt > arg1_4.teamCnt
					end
				end,
				[PlayRoomConst.ROOM_SORT_TYPE.ROOM_VIEWER_CNT] = function()
					if arg0_4.viewerCnt == arg1_4.viewerCnt then
						return arg0_4.roomState < arg1_4.roomState
					end

					if arg2_3 then
						return arg0_4.viewerCnt < arg1_4.viewerCnt
					else
						return arg0_4.viewerCnt > arg1_4.viewerCnt
					end
				end
			})
		end)

		return arg0_3
	end,
	GetMaxTeamCnt = function(arg0_7)
		local var0_7 = pg.mode_room[arg0_7].count
		local var1_7 = 0

		for iter0_7, iter1_7 in ipairs(var0_7) do
			var1_7 = var1_7 + iter1_7
		end

		return var1_7
	end,
	GetMaxViewerCnt = function(arg0_8)
		return pg.mode_room[arg0_8].viewer_count
	end
}

function var0_0.GetMaxPlayerCnt(arg0_9)
	return var0_0.GetMaxTeamCnt(arg0_9)
end

function var0_0.IsViewer()
	local var0_10 = getProxy(PlayRoomProxy):GetRoomData()
	local var1_10 = getProxy(PlayerProxy):getPlayerId()

	return table.contains(var0_10.viewerList, var1_10)
end

function var0_0.IsPlayerFull()
	local var0_11 = getProxy(PlayRoomProxy):GetRoomData()

	return #var0_11.teamList >= var0_0.GetMaxTeamCnt(var0_11.gameType)
end

function var0_0.IsViewerFull()
	local var0_12 = getProxy(PlayRoomProxy):GetRoomData()

	return #var0_12.viewerList >= var0_0.GetMaxViewerCnt(var0_12.gameType)
end

function var0_0.GetUnfullTeamIndex(arg0_13)
	local var0_13 = getProxy(PlayRoomProxy):GetRoomData()
	local var1_13 = pg.mode_room[var0_13.gameType].count

	for iter0_13, iter1_13 in ipairs(var1_13) do
		if iter1_13 > #var0_13.teamPosList[iter0_13] then
			return iter0_13
		end
	end

	return nil
end

function var0_0.GetHostID()
	return getProxy(PlayRoomProxy):GetRoomData().roomID
end

function var0_0.CanStartGame()
	local var0_15 = getProxy(PlayRoomProxy):GetRoomData()

	return #var0_15.teamList == #var0_15.readyList
end

function var0_0.GetServerName(arg0_16)
	local var0_16 = bit.rshift(arg0_16, 26)

	for iter0_16, iter1_16 in pairs(getProxy(ServerProxy):getData()) do
		if table.keyof(iter1_16.ids, var0_16) then
			return iter1_16.name
		end
	end

	return i18n("match_ui_server_unkonw")
end

function var0_0.GetPtScrore(arg0_17)
	local var0_17 = var0_0.GameTypeToActivityType(arg0_17)
	local var1_17 = getProxy(ActivityProxy):getActivityByType(var0_17)

	return var1_17 and var1_17.data1 or 0
end

function var0_0.GetPtScoreIcon(arg0_18)
	local var0_18 = var0_0.GameTypeToActivityType(arg0_18)

	return switch(var0_18, {
		[ActivityConst.ACTIVITY_TYPE_ISLAND_CHEAT_BAR] = function()
			local var0_19 = getProxy(ActivityProxy):getActivityByType(var0_18)
			local var1_19 = var0_19 and var0_19.data1 or 0
			local var2_19

			for iter0_19, iter1_19 in ipairs(pg.island_integral_rank.all) do
				local var3_19 = pg.island_integral_rank[iter1_19]

				if var1_19 >= var3_19.lower_limit then
					var2_19 = var3_19.icon
				end
			end

			return var2_19
		end
	}, function()
		assert(false, "非法activity类型")
	end)
end

function var0_0.GameTypeToActivityType(arg0_21)
	return pg.mode_room[arg0_21].activity_type
end

function var0_0.SearchRoomList(arg0_22)
	local var0_22 = {}
	local var1_22 = getProxy(PlayRoomProxy):GetPlayRoomList()

	for iter0_22, iter1_22 in ipairs(var1_22) do
		if string.match(arg0_22, "^%d+$") ~= nil then
			local var2_22 = tonumber(arg0_22)

			if iter1_22.id == var2_22 then
				table.insert(var0_22, iter1_22)
			end
		end

		if iter1_22.name == arg0_22 then
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22
end

function var0_0.GetGameTypeID()
	return var0_0.GameTypeID or PlayRoomConst.GAME_TYPE.CHEATER_TAVERN
end

function var0_0.SetGameTypeID(arg0_24)
	var0_0.GameTypeID = arg0_24
end

function var0_0.ShowPunishementBox(arg0_25)
	local var0_25 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_25 <= var0_25 then
		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = i18n("match_ui_punishment1", arg0_25 - var0_25),
		yesText = i18n("match_ui_punishment2")
	})
end

function var0_0.GetGameViewID(arg0_26)
	local var0_26 = var0_0.GetGameTypeID()

	for iter0_26, iter1_26 in ipairs(arg0_26) do
		if iter1_26.game_type == var0_26 then
			return iter1_26
		end
	end

	assert(false, "未找到对应游戏类型的角色装扮：" .. var0_26)
end

return var0_0
