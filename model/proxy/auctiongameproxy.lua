local var0_0 = class("AuctionGameProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:on(23400, function(arg0_2)
		arg0_1:UpdatePlayerList(arg0_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_QUICK_MATCH_SUCCESS)
	end)
	arg0_1:on(23401, function(arg0_3)
		print("竞拍活动：新轮次开始")
		arg0_1:UpdateRoundData(arg0_3)
		arg0_1:ResetPlayerOptState()

		arg0_1.phaseTimestamp = arg0_3.timestamp

		arg0_1:sendNotification(GAME.AUCTION_GAME_NEW_ROUND)
	end)
	arg0_1:on(23404, function(arg0_4)
		print("竞拍活动：所有玩家完成个人选择事件")
		arg0_1:UpdateGroundEventList(arg0_4.player_events)

		if arg0_4.event_effect and arg0_4.event_effect.event_id ~= 0 then
			arg0_1:SetPersonalEventSelectedID(arg0_4.event_effect.event_id)
			arg0_1:UpdateEventEffect(arg0_4.event_effect)
		end

		arg0_1.auctionState = AuctionGameConst.AUCTION_PHASE.BID

		arg0_1:ResetPlayerOptState()

		arg0_1.phaseTimestamp = arg0_4.timestamp

		arg0_1:sendNotification(GAME.AUCTION_GAME_BID_PHASE)
	end)
	arg0_1:on(23412, function(arg0_5)
		print("竞拍活动：玩家操作完成", arg0_5.user_id)
		arg0_1:UpdatePlayerOptState(arg0_5)
	end)
	arg0_1:on(23407, function(arg0_6)
		print("竞拍活动：出价结果通知")

		if table.keyof(arg0_1.leaverList, getProxy(PlayerProxy):getPlayerId()) then
			return
		end

		arg0_1:UpdatePlayerBidList(arg0_6.bid_list)

		arg0_1.phaseTimestamp = arg0_6.timestamp

		arg0_1:sendNotification(GAME.AUCTION_GAME_ROUND_OVER)

		arg0_1.auctionState = AuctionGameConst.AUCTION_PHASE.ROUND_OVER
	end)
	arg0_1:on(23408, function(arg0_7)
		print("竞拍活动：竞拍结算")
		arg0_1:UpdateSettlementData(arg0_7)
		arg0_1:sendNotification(GAME.AUCTION_GAME_SETTLEMENT)
	end)
	arg0_1:on(23411, function(arg0_8)
		for iter0_8, iter1_8 in ipairs(arg0_8.user_ids) do
			if iter1_8 == getProxy(PlayerProxy):getPlayerId() then
				arg0_1:sendNotification(GAME.AUCTION_GAME_KICK)
			end

			print("竞拍活动：被服务器踢出游戏", iter1_8)
			table.insert(arg0_1.leaverList, iter1_8)
		end
	end)
	arg0_1:on(23415, function(arg0_9)
		if arg0_1.switchEmojiFlag == 1 then
			return
		end

		print("竞拍活动：收到表情")
		arg0_1:sendNotification(GAME.AUCTION_GAME_SHOW_EMOJI, {
			userID = arg0_9.user_id,
			emojiID = arg0_9.expression_id
		})
	end)
	arg0_1:InitGameData()
end

function var0_0.InitGameData(arg0_10, arg1_10)
	arg0_10.auctionID = arg1_10
	arg0_10.playerList = {}
	arg0_10.round = 0
	arg0_10.storeItemDataList = {}
	arg0_10.personalEventList = {}
	arg0_10.personalEventSelectedID = 0
	arg0_10.eventSummary = {}
	arg0_10.roundEventAndBidInfoList = {}
	arg0_10.forfeit = false
	arg0_10.playerOptStateList = {}
	arg0_10.phaseTimestamp = 0
	arg0_10.leaverList = {}
	arg0_10.forfeitList = {}
	arg0_10.sendEmojiTimestamp = 0
	arg0_10.switchEmojiFlag = 0
	arg0_10.auctionState = AuctionGameConst.AUCTION_PHASE.WAIT
end

function var0_0.UpdatePlayerList(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11.player_list) do
		var0_11[iter1_11.sort] = Player.New({
			id = iter1_11.user_id,
			name = iter1_11.player_info.name,
			display = iter1_11.player_info.display
		})
	end

	local var1_11 = {}
	local var2_11

	for iter2_11, iter3_11 in ipairs(var0_11) do
		if iter3_11.id == getProxy(PlayerProxy):getPlayerId() then
			var2_11 = iter3_11
		else
			table.insert(var1_11, iter3_11)
		end
	end

	table.insert(var1_11, var2_11)

	arg0_11.playerList = var1_11
	arg0_11.storeLine = arg1_11.line or 10

	print("最大行数：", arg1_11.line)
end

function var0_0.GetPlayerList(arg0_12)
	return arg0_12.playerList
end

function var0_0.GetPlayerVO(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.playerList) do
		if iter1_13.id == arg1_13 then
			return iter1_13
		end
	end
end

function var0_0.UpdateRoundData(arg0_14, arg1_14)
	arg0_14.round = arg1_14.round

	arg0_14:UpdateEventEffect(arg1_14.public_event_effect)

	arg0_14.auctionState = AuctionGameConst.AUCTION_PHASE.COMMON_EVENT
	arg0_14.personalEventList = {}

	for iter0_14, iter1_14 in ipairs(arg1_14.event_list) do
		table.insert(arg0_14.personalEventList, iter1_14)
	end

	arg0_14.auctionState = AuctionGameConst.AUCTION_PHASE.PERSONAL_EVENT
	arg0_14.personalEventSelectedID = 0

	if arg1_14.round == 1 then
		arg0_14.startTime = arg1_14.start_time
	end
end

function var0_0.GetAuctionID(arg0_15)
	return arg0_15.auctionID
end

function var0_0.GetRound(arg0_16)
	return arg0_16.round
end

function var0_0.GetTimestamp(arg0_17)
	return arg0_17.phaseTimestamp
end

function var0_0.GetMaxLineCnt(arg0_18)
	return arg0_18.storeLine > 10 and arg0_18.storeLine or 10
end

function var0_0.GetCurStoreLine(arg0_19)
	local var0_19 = 10

	for iter0_19, iter1_19 in pairs(arg0_19.storeItemDataList) do
		local var1_19 = iter1_19.position.y
		local var2_19 = iter1_19.contour[2] + var1_19 - 1

		if var0_19 < var2_19 then
			var0_19 = var2_19
		end
	end

	return var0_19
end

function var0_0.GetStoreItemDataList(arg0_20)
	return arg0_20.storeItemDataList
end

function var0_0.GetLeaverList(arg0_21)
	return arg0_21.leaverList
end

function var0_0.GetForfeitList(arg0_22)
	return arg0_22.forfeitList
end

function var0_0.UpdateEventEffect(arg0_23, arg1_23)
	AuctionGameTools.RefreshItemDataByEvent(arg1_23)
	arg0_23:sendNotification(GAME.AUCTION_GAME_EVENT_EFFECT_UPDATE)
end

function var0_0.GetPersonalEventList(arg0_24)
	return arg0_24.personalEventList
end

function var0_0.GetPersonalEventSelectedID(arg0_25)
	return arg0_25.personalEventSelectedID
end

function var0_0.SetPersonalEventSelectedID(arg0_26, arg1_26)
	arg0_26.personalEventSelectedID = arg1_26

	if arg0_26.auctionState < AuctionGameConst.AUCTION_PHASE.WAIT_BID then
		arg0_26.auctionState = AuctionGameConst.AUCTION_PHASE.WAIT_BID
	end
end

function var0_0.AddEventSummary(arg0_27, arg1_27, arg2_27, arg3_27)
	arg0_27.eventSummary[arg1_27] = arg0_27.eventSummary[arg1_27] or {}

	if arg2_27 then
		arg0_27.eventSummary[arg1_27].commonEventData = arg3_27
	else
		arg0_27.eventSummary[arg1_27].personalEventData = arg3_27
	end
end

function var0_0.GetEventSummary(arg0_28)
	return arg0_28.eventSummary
end

function var0_0.GetRoundEventAndBidInfoList(arg0_29)
	return arg0_29.roundEventAndBidInfoList
end

function var0_0.GetRoundEventAndBidInfo(arg0_30, arg1_30, arg2_30)
	return arg0_30.roundEventAndBidInfoList[arg1_30][arg2_30]
end

function var0_0.UpdateGroundEventList(arg0_31, arg1_31)
	arg0_31.roundEventAndBidInfoList[arg0_31.round] = arg0_31.roundEventAndBidInfoList[arg0_31.round] or {}

	for iter0_31, iter1_31 in ipairs(arg1_31) do
		arg0_31.roundEventAndBidInfoList[arg0_31.round][iter1_31.user_id] = arg0_31.roundEventAndBidInfoList[arg0_31.round][iter1_31.user_id] or {}
		arg0_31.roundEventAndBidInfoList[arg0_31.round][iter1_31.user_id].eventID = iter1_31.event_id

		if iter1_31.event_id == nil or iter1_31.event_id == 0 then
			originalPrint(string.format("竞拍活动:轮数:%s, 玩家ID:%s, 选择事件ID:<color=red>%s</color>", arg0_31.round, iter1_31.user_id, iter1_31.event_id))
		end
	end
end

function var0_0.UpdatePlayerBidList(arg0_32, arg1_32)
	arg0_32.roundEventAndBidInfoList[arg0_32.round] = arg0_32.roundEventAndBidInfoList[arg0_32.round] or {}

	for iter0_32, iter1_32 in ipairs(arg1_32) do
		arg0_32.roundEventAndBidInfoList[arg0_32.round][iter1_32.user_id] = arg0_32.roundEventAndBidInfoList[arg0_32.round][iter1_32.user_id] or {}
		arg0_32.roundEventAndBidInfoList[arg0_32.round][iter1_32.user_id].bidValue = iter1_32.price
		arg0_32.roundEventAndBidInfoList[arg0_32.round][iter1_32.user_id].state = iter1_32.state

		originalPrint(string.format("竞拍活动:轮数:%s, 玩家ID:%s, 出价:%s", arg0_32.round, iter1_32.user_id, iter1_32.price))
	end
end

function var0_0.ResetPlayerOptState(arg0_33)
	arg0_33.playerOptStateList = {}
	arg0_33.playerBidOrderList = {}

	arg0_33:sendNotification(GAME.AUCTION_GAME_PLAYER_OPT_STATE_UPDATE)
end

function var0_0.UpdatePlayerOptState(arg0_34, arg1_34)
	arg0_34.playerOptStateList[arg1_34.user_id] = arg1_34.opt_type

	if arg1_34.opt_type == 2 then
		table.insert(arg0_34.playerBidOrderList, arg1_34.user_id)
	elseif arg1_34.opt_type == 3 then
		table.insert(arg0_34.forfeitList, arg1_34.user_id)
	end

	arg0_34:sendNotification(GAME.AUCTION_GAME_PLAYER_OPT_STATE_UPDATE)
end

function var0_0.GetPlayerOptStateList(arg0_35)
	return arg0_35.playerOptStateList
end

function var0_0.GetBidOrderList(arg0_36)
	return arg0_36.playerBidOrderList
end

function var0_0.FinishBid(arg0_37, arg1_37)
	arg0_37.auctionState = AuctionGameConst.AUCTION_PHASE.WAIT_OVER
end

function var0_0.GetAuctionState(arg0_38)
	return arg0_38.auctionState
end

function var0_0.SetForfeit(arg0_39)
	arg0_39.forfeit = true
end

function var0_0.GetForfeit(arg0_40)
	return arg0_40.forfeit
end

function var0_0.SetSendEmojiTimestamp(arg0_41, arg1_41)
	arg0_41.sendEmojiTimestamp = arg1_41
end

function var0_0.GetSendEmojiTimestamp(arg0_42)
	return arg0_42.sendEmojiTimestamp
end

function var0_0.SetSwitchEmojiFlag(arg0_43, arg1_43)
	arg0_43.switchEmojiFlag = arg1_43
end

function var0_0.GetSwitchEmojiFlag(arg0_44)
	return arg0_44.switchEmojiFlag
end

function var0_0.UpdateSettlementData(arg0_45, arg1_45)
	arg0_45.settlementVO = AuctionGameSettlementData.New(arg1_45)
end

function var0_0.GetSettlementData(arg0_46)
	return arg0_46.settlementVO
end

return var0_0
