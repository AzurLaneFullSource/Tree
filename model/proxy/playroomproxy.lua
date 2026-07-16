local var0_0 = class("PlayRoomData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.gameType = arg1_1.game_type
	arg0_1.name = arg1_1.name
	arg0_1.roomType = arg1_1.type
	arg0_1.teamCnt = arg1_1.player_num or 0
	arg0_1.viewerCnt = arg1_1.viewer_num or 0
	arg0_1.roomState = arg1_1.play_flag or PlayRoomConst.PLAY_ROOM_STATE.WAIT
end

function var0_0.GetPlayer(arg0_2, arg1_2)
	return arg0_2.playerDataList and arg0_2.playerDataList[arg1_2] or nil
end

local var1_0 = class("PlayerData")

function var1_0.Ctor(arg0_3, arg1_3)
	arg0_3.id = arg1_3.id
	arg0_3.level = arg1_3.level
	arg0_3.name = arg1_3.name
	arg0_3.guildName = arg1_3.guild_name
	arg0_3.display = arg1_3.display
	arg0_3.user_view = arg1_3.user_view
end

local var2_0 = class("PlayRoomInfoData")

function var2_0.UpdateRoomData(arg0_4, arg1_4)
	arg0_4.roomID = arg1_4.id
	arg0_4.roomType = arg1_4.type
	arg0_4.gameType = arg1_4.game_type
	arg0_4.roomState = arg1_4.play_flag or PlayRoomConst.PLAY_ROOM_STATE.WAIT

	arg0_4:UpdatePlayerList(arg1_4.id, arg1_4.player_list, arg1_4.team_list, arg1_4.ready_list)
end

function var2_0.UpdatePlayerList(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg0_5.playerList = {}
	arg0_5.playerDataList = {}

	for iter0_5, iter1_5 in ipairs(arg2_5) do
		local var0_5 = iter1_5.id

		table.insert(arg0_5.playerList, var0_5)

		arg0_5.playerDataList[var0_5] = var1_0.New(iter1_5)
	end

	arg0_5.teamList = {}
	arg0_5.teamPosList = {}

	for iter2_5, iter3_5 in ipairs(arg3_5) do
		arg0_5.teamPosList[iter2_5] = {}

		for iter4_5, iter5_5 in ipairs(iter3_5.user_id_list) do
			if iter5_5 ~= 0 then
				table.insert(arg0_5.teamList, iter5_5)
				table.insert(arg0_5.teamPosList[iter2_5], iter5_5)
			end
		end
	end

	arg0_5.readyList = {}

	for iter6_5, iter7_5 in ipairs(arg4_5) do
		table.insert(arg0_5.readyList, iter7_5)
	end

	arg0_5.viewerList = {}

	for iter8_5, iter9_5 in ipairs(arg0_5.playerList) do
		if not table.contains(arg0_5.teamList, iter9_5) then
			table.insert(arg0_5.viewerList, iter9_5)
		elseif iter9_5 == arg1_5 then
			table.insert(arg0_5.readyList, iter9_5)
		end
	end
end

function var2_0.GetPlayer(arg0_6, arg1_6)
	return arg0_6.playerDataList and arg0_6.playerDataList[arg1_6] or nil
end

local var3_0 = class("MatchReadyRoom")

function var3_0.UpdateRoomData(arg0_7, arg1_7)
	arg0_7.gameType = arg1_7.game_type
	arg0_7.endTimestamp = arg1_7.time

	arg0_7:UpdatePlayerList(arg1_7.player_list, arg1_7.team_list, arg1_7.ready_list)
end

function var3_0.UpdatePlayerList(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8.playerList = {}
	arg0_8.playerDataList = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var0_8 = iter1_8.id

		table.insert(arg0_8.playerList, var0_8)

		arg0_8.playerDataList[var0_8] = var1_0.New(iter1_8)
	end

	arg0_8.teamList = {}
	arg0_8.teamPosList = {}

	for iter2_8, iter3_8 in ipairs(arg2_8) do
		arg0_8.teamPosList[iter2_8] = {}

		for iter4_8, iter5_8 in ipairs(iter3_8.user_id_list) do
			if iter5_8 ~= 0 then
				table.insert(arg0_8.teamList, iter5_8)
				table.insert(arg0_8.teamPosList[iter2_8], iter5_8)
			end
		end
	end

	arg0_8.readyList = {}

	for iter6_8, iter7_8 in ipairs(arg3_8) do
		table.insert(arg0_8.readyList, iter7_8)
	end
end

function var3_0.GetPlayer(arg0_9, arg1_9)
	return arg0_9.playerDataList and arg0_9.playerDataList[arg1_9] or nil
end

local var4_0 = class("GameLoadData")

function var4_0.UpdateData(arg0_10, arg1_10)
	arg0_10.gameType = arg1_10.game_type
	arg0_10.isAllLoadOver = true

	arg0_10:UpdatePlayerList(arg1_10.player_list, arg1_10.team_list, arg1_10.load_list)

	arg0_10.overTime = arg1_10.time
end

function var4_0.UpdatePlayerList(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11.playerList = {}
	arg0_11.playerDataList = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		local var0_11 = iter1_11.id

		table.insert(arg0_11.playerList, var0_11)

		arg0_11.playerDataList[var0_11] = var1_0.New(iter1_11)
	end

	arg0_11.teamList = {}
	arg0_11.teamPosList = {}

	for iter2_11, iter3_11 in ipairs(arg2_11) do
		arg0_11.teamPosList[iter2_11] = {}

		for iter4_11, iter5_11 in ipairs(iter3_11.user_id_list) do
			if iter5_11 ~= 0 then
				table.insert(arg0_11.teamList, iter5_11)
				table.insert(arg0_11.teamPosList[iter2_11], iter5_11)
			end
		end
	end

	arg0_11.loadList = {}

	for iter6_11, iter7_11 in ipairs(arg3_11) do
		arg0_11.loadList[iter7_11.user_id] = iter7_11.load

		if iter7_11.load < 100 then
			arg0_11.isAllLoadOver = false
		end
	end
end

local var5_0 = class("RankData")

function var5_0.UpdateData(arg0_12, arg1_12, arg2_12)
	arg0_12.playerData = var1_0.New(arg1_12.player)
	arg0_12.score = arg1_12.score
	arg0_12.rankIndex = arg2_12
end

local var6_0 = class("PlayRoomProxy", import(".NetProxy"))

var6_0.CHAT_MSG_UPDATE = "PlayRoomProxy.CHAT_MSG_UPDATE"

function var6_0.register(arg0_13)
	arg0_13.playRoomList = {}

	arg0_13:on(23099, function(arg0_14)
		if arg0_13.roomData == nil then
			return
		end

		arg0_13:UpdateRoomData(arg0_14.room)
	end)
	arg0_13:on(23096, function(arg0_15)
		if arg0_15.reason == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("match_ui_room_out"))
		end

		if arg0_13.roomData and arg0_13.roomData.roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
			if arg0_13.matchReadyRoom == nil then
				arg0_13:ExitRoom()
			else
				local var0_15 = arg0_13.matchReadyRoom.readyList
				local var1_15 = getProxy(PlayerProxy):getPlayerId()
				local var2_15 = table.keyof(var0_15, var1_15)
				local var3_15 = arg0_13.matchReadyRoom.endTimestamp

				arg0_13:ExitMatchReadyRoom()

				if arg0_13.matchStartTime then
					local var4_15 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_13.matchStartTime

					pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomMatch("bar", 2, 1, var4_15, 2))

					arg0_13.matchStartTime = nil
				end

				arg0_13:sendNotification(GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM)

				if arg0_15.reason == 3 then
					arg0_13:sendNotification(GAME.PLAY_ROOM_CREATE_ROOM, {
						type = PlayRoomConst.PLAY_ROOM_TYPE.MATCH,
						gameType = arg0_13.roomData.gameType
					})
					arg0_13:sendNotification(GAME.PLAY_ROOM_START_GAME)
				else
					arg0_13:ExitRoom()
				end
			end
		else
			arg0_13:ExitRoom()
			arg0_13:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM_DONE)
		end
	end)
	arg0_13:on(23097, function(arg0_16)
		arg0_13:AddInviteList(arg0_16)
	end)
	arg0_13:on(23095, function(arg0_17)
		arg0_13:UpdateMatchRoomData(arg0_17)
	end)
	arg0_13:on(23094, function(arg0_18)
		arg0_13:UpdateGameLoadData(arg0_18)
	end)

	arg0_13.inviteList = {}
	arg0_13.inviteRecordList = {}

	arg0_13:on(50116, function(arg0_19)
		arg0_13:AddChatMsg(arg0_19)
	end)

	arg0_13.chatMsgs = {}
	arg0_13.rankList = {}
	arg0_13.selfRankData = {}
	arg0_13.matchCD = 0
	arg0_13.isPlayingGame = false
end

function var6_0.GetPlayRoomList(arg0_20)
	return arg0_20.playRoomList
end

function var6_0.UpdateRoomList(arg0_21, arg1_21)
	arg0_21.playRoomList = {}

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		table.insert(arg0_21.playRoomList, var0_0.New(iter1_21))
	end
end

function var6_0.UpdateRoomData(arg0_22, arg1_22)
	if arg0_22.roomData == nil then
		arg0_22.roomData = var2_0.New()

		arg0_22:ClearChatMsgList()
	end

	arg0_22.roomData:UpdateRoomData(arg1_22)

	if not arg0_22.isPlayingGame then
		arg0_22:sendNotification(GAME.PLAY_ROOM_REDAY_ROOM_REFRESH)
	end
end

function var6_0.GetRoomData(arg0_23)
	return arg0_23.roomData
end

function var6_0.ExitRoom(arg0_24)
	arg0_24:SetStartMatch(false)

	if arg0_24.matchStartTime then
		local var0_24 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_24.matchStartTime

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomMatch("bar", 2, 1, var0_24, 1))

		arg0_24.matchStartTime = nil
	end

	arg0_24.roomData = nil
end

function var6_0.SetPlayingGameState(arg0_25, arg1_25)
	arg0_25.isPlayingGame = arg1_25
end

function var6_0.GetPlayingGameState(arg0_26)
	return arg0_26.isPlayingGame
end

function var6_0.AddInviteList(arg0_27, arg1_27)
	if arg0_27.roomData then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomInvate("bar", arg1_27.invitor.id, 3))

		return
	end

	table.insert(arg0_27.inviteList, {
		roomData = var0_0.New(arg1_27.room),
		invitor = var1_0.New(arg1_27.invitor),
		timestamp = pg.TimeMgr.GetInstance():GetServerTime()
	})
end

function var6_0.GetInviteList(arg0_28)
	local var0_28 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_28 = #arg0_28.inviteList, 1, -1 do
		if var0_28 - arg0_28.inviteList[iter0_28].timestamp > pg.gameset.match_refuseCD.key_value then
			table.remove(arg0_28.inviteList, 1)
		end
	end

	return arg0_28.inviteList
end

function var6_0.RefuseInvite(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.inviteList) do
		if iter1_29.roomData.id == arg1_29 then
			table.remove(arg0_29.inviteList, iter0_29)

			break
		end
	end
end

function var6_0.ClearInviteList(arg0_30)
	arg0_30.inviteList = {}
end

function var6_0.AddInviteRecord(arg0_31, arg1_31)
	table.insert(arg0_31.inviteRecordList, {
		id = arg1_31,
		timestamp = pg.TimeMgr.GetInstance():GetServerTime()
	})
end

function var6_0.RemoveInviteRecord(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.inviteRecordList) do
		if iter1_32.id == arg1_32 then
			table.remove(arg0_32.inviteRecordList, iter0_32)

			return
		end
	end
end

function var6_0.GetInviteRecordList(arg0_33)
	local var0_33 = pg.gameset.match_refuseCD.key_value
	local var1_33 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_33 = #arg0_33.inviteRecordList, 1, -1 do
		if var1_33 >= arg0_33.inviteRecordList[iter0_33].timestamp + var0_33 then
			table.remove(arg0_33.inviteRecordList, iter0_33)
		end
	end

	return arg0_33.inviteRecordList
end

function var6_0.GetInviteRecordByID(arg0_34, arg1_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.inviteRecordList) do
		if iter1_34.id == arg1_34 then
			return iter1_34
		end
	end
end

function var6_0.ClearInviteRecordList(arg0_35)
	arg0_35.inviteRecordList = {}
end

function var6_0.UpdateMatchRoomData(arg0_36, arg1_36)
	local var0_36 = false

	if arg0_36.matchReadyRoom == nil then
		var0_36 = true
		arg0_36.matchReadyRoom = var3_0.New()

		arg0_36:SetStartMatch(false)

		if arg0_36.matchStartTime then
			local var1_36 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_36.matchStartTime

			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPlayRoomMatch("bar", 2, 1, var1_36, 3))

			arg0_36.matchStartTime = nil
		end
	end

	arg0_36.matchReadyRoom:UpdateRoomData(arg1_36)

	if var0_36 then
		arg0_36:sendNotification(GAME.PLAY_ROOM_MATCH_ENTER_READY_ROOM)
	else
		arg0_36:sendNotification(GAME.PLAY_ROOM_MATCH_REDAY_ROOM_REFRESH)
	end
end

function var6_0.GetMatchRoomData(arg0_37)
	return arg0_37.matchReadyRoom
end

function var6_0.ExitMatchReadyRoom(arg0_38)
	arg0_38.matchReadyRoom = nil
end

function var6_0.GetMatchTime(arg0_39)
	return arg0_39.matchEndTime or 0
end

function var6_0.SetStartMatch(arg0_40, arg1_40)
	if arg1_40 then
		arg0_40:RefreshMatchTime()
	else
		arg0_40.matchEndTime = nil
	end
end

function var6_0.GetMatchFlag(arg0_41)
	return arg0_41.matchReadyRoom == nil and arg0_41:GetMatchTime() >= pg.TimeMgr.GetInstance():GetServerTime()
end

function var6_0.RefreshMatchTime(arg0_42)
	arg0_42.matchStartTime = pg.TimeMgr.GetInstance():GetServerTime() - 1
	arg0_42.matchEndTime = arg0_42.matchStartTime + pg.gameset.level_get_proficency.key_value
end

function var6_0.GetMatchStarTime(arg0_43)
	return arg0_43.matchStartTime or pg.TimeMgr.GetInstance():GetServerTime()
end

function var6_0.SetExitMatchFlag(arg0_44, arg1_44)
	arg0_44.exitMatchFlag = arg1_44 == 0
end

function var6_0.SetMatchCD(arg0_45, arg1_45)
	if arg1_45 <= 0 then
		return
	end

	arg0_45.matchCD = arg1_45
end

function var6_0.GetMatchCD(arg0_46)
	return arg0_46.matchCD
end

function var6_0.UpdateGameLoadData(arg0_47, arg1_47)
	local var0_47 = false

	if arg0_47.gameLoadData == nil then
		var0_47 = true
		arg0_47.gameLoadData = var4_0.New()
	end

	arg0_47.gameLoadData:UpdateData(arg1_47)

	if var0_47 and arg0_47.roomData then
		arg0_47.roomData.roomState = PlayRoomConst.PLAY_ROOM_STATE.PLAYING

		arg0_47:ExitMatchReadyRoom()
		arg0_47:sendNotification(GAME.PLAY_ROOM_CLOSE_MATCH_READY)
		arg0_47:sendNotification(GAME.PLAY_ROOM_ENTER_LOAD)
	end

	if arg0_47.gameLoadData.isAllLoadOver then
		arg0_47.gameLoadData = nil

		arg0_47:sendNotification(GAME.PLAY_ROOM_ALL_LOAD_OVER)
		arg0_47:SetPlayingGameState(true)
	end
end

function var6_0.GetGameLoadData(arg0_48)
	return arg0_48.gameLoadData
end

function var6_0.GetLoadOverTime(arg0_49)
	return arg0_49.gameLoadData.overTime
end

function var6_0.AddChatMsg(arg0_50, arg1_50)
	local var0_50 = ChatProxy.InjectPublicMsg(arg1_50.content, Player.New(arg1_50.player))
	local var1_50 = ChatMsg.New(ChatConst.ChannelPlayRoom, var0_50)

	var1_50.typePlayRoom = arg1_50.type

	table.insert(arg0_50.chatMsgs, var1_50)
	arg0_50:sendNotification(PlayRoomProxy.CHAT_MSG_UPDATE, {
		msg = var1_50
	})
end

function var6_0.GetChatMsgs(arg0_51)
	return underscore.to_array(arg0_51.chatMsgs)
end

function var6_0.ClearChatMsgList(arg0_52)
	arg0_52.chatMsgs = {}
end

function var6_0.UpdateRankData(arg0_53, arg1_53, arg2_53)
	arg0_53.rankList[arg1_53] = {}
	arg0_53.selfRankData[arg1_53] = var5_0.New()

	local var0_53 = getProxy(PlayerProxy):getPlayerId()

	for iter0_53, iter1_53 in ipairs(arg2_53.rank_list) do
		local var1_53 = var5_0.New()

		var1_53:UpdateData(iter1_53, iter0_53)
		table.insert(arg0_53.rankList[arg1_53], var1_53)

		if iter1_53.player.id == var0_53 then
			arg0_53.selfRankData[arg1_53]:UpdateData(iter1_53, iter0_53)
		end
	end
end

function var6_0.GetRankData(arg0_54, arg1_54)
	return arg0_54.rankList[arg1_54] or {}
end

function var6_0.GetSelfRankData(arg0_55, arg1_55)
	if arg0_55.selfRankData[arg1_55].rankIndex then
		return arg0_55.selfRankData[arg1_55]
	end

	local var0_55 = getProxy(PlayerProxy):getData()
	local var1_55 = getProxy(GuildProxy):getData()

	arg0_55.selfRankData[arg1_55]:UpdateData({
		score = PlayRoomTools.GetPtScrore(arg1_55),
		player = {
			id = var0_55.id,
			level = var0_55.level,
			name = var0_55.name,
			guild_name = var1_55 and var1_55.name or "",
			display = var0_55.displayInfo
		}
	}, 0)

	return arg0_55.selfRankData[arg1_55]
end

return var6_0
