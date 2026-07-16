local var0_0 = {
	GetCurrencyCnt = function()
		return getProxy(AuctionGameBaseProxy).gold
	end,
	GetPreorderCurrentyCnt = function()
		return pg.gameset.auction_preorder_price.key_value
	end
}

function var0_0.GetLastLocationSelectedID()
	local var0_3 = getProxy(PlayerProxy):getPlayerId()
	local var1_3 = pg.auction_session.all[1]
	local var2_3 = PlayerPrefs.GetInt(string.format("AUCTION_GAME_SELECTED_LOCATION_%s", var0_3), var1_3)

	if pg.auction_session[var2_3] == nil then
		var2_3 = pg.auction_session.all[1]
	end

	local var3_3 = var0_0.GetCurrencyCnt()

	for iter0_3 = table.keyof(pg.auction_session.all, var2_3), 1, -1 do
		local var4_3 = pg.auction_session.all[iter0_3]

		if var3_3 >= pg.auction_session[var4_3].threshold then
			return var4_3
		end
	end

	return pg.auction_session.all[1]
end

function var0_0.SetLastLocationSelectedID(arg0_4)
	local var0_4 = getProxy(PlayerProxy):getPlayerId()

	PlayerPrefs.SetInt(string.format("AUCTION_GAME_SELECTED_LOCATION_%s", var0_4), arg0_4)
end

function var0_0.GetDisplayShipList()
	return (getProxy(PlayerProxy):getRawData():GetDisplayShipList())
end

function var0_0.GetDisplayShipVO(arg0_6, arg1_6)
	if arg1_6 == nil then
		arg1_6 = getProxy(SettingsProxy):getCurrentSecretaryIndex()
	end

	return arg0_6[arg1_6], arg1_6
end

function var0_0.GetPlayerNoSortList(arg0_7)
	local var0_7 = getProxy(AuctionGameProxy)
	local var1_7 = var0_7:GetRoundEventAndBidInfoList()[arg0_7] or {}
	local var2_7 = var0_7:GetBidOrderList() or {}
	local var3_7 = {}

	for iter0_7, iter1_7 in ipairs(var0_7:GetPlayerList()) do
		local var4_7 = iter1_7.id
		local var5_7 = (var1_7[var4_7] or {}).bidValue or 0

		var3_7[var4_7] = {
			num = 0,
			playerID = var4_7,
			bidValue = var5_7,
			bidOrder = table.keyof(var2_7, var4_7) or #var2_7 + 1,
			index = iter0_7
		}
	end

	local var6_7 = {}

	for iter2_7, iter3_7 in pairs(var3_7) do
		table.insert(var6_7, {
			id = iter2_7,
			data = iter3_7
		})
	end

	table.sort(var6_7, function(arg0_8, arg1_8)
		if arg0_8.data.bidValue == arg1_8.data.bidValue then
			if arg0_8.data.bidOrder == arg1_8.data.bidOrder then
				return arg0_8.data.index < arg1_8.data.index
			end

			return arg0_8.data.bidOrder < arg1_8.data.bidOrder
		end

		return arg0_8.data.bidValue > arg1_8.data.bidValue
	end)

	local var7_7
	local var8_7 = 0

	for iter4_7, iter5_7 in ipairs(var6_7) do
		if var7_7 and iter5_7.data.bidValue == var7_7.bidValue and iter5_7.data.bidOrder == var7_7.bidOrder then
			iter5_7.data.num = var8_7
		else
			iter5_7.data.num = iter4_7
			var8_7 = iter4_7
		end

		var7_7 = iter5_7.data
	end

	return var6_7
end

function var0_0.GetPosRange(arg0_9)
	if not arg0_9 or #arg0_9 == 0 then
		return {
			0,
			0
		}
	end

	local var0_9
	local var1_9
	local var2_9
	local var3_9

	for iter0_9, iter1_9 in ipairs(arg0_9) do
		local var4_9 = iter1_9.x
		local var5_9 = iter1_9.y

		var0_9 = var0_9 and math.min(var0_9, var4_9) or var4_9
		var1_9 = var1_9 and math.max(var1_9, var4_9) or var4_9
		var2_9 = var2_9 and math.min(var2_9, var5_9) or var5_9
		var3_9 = var3_9 and math.max(var3_9, var5_9) or var5_9
	end

	return {
		var1_9 - var0_9 + 1,
		var3_9 - var2_9 + 1
	}
end

function var0_0.IsNoBid()
	local var0_10 = getProxy(AuctionGameProxy):GetRoundEventAndBidInfoList()

	for iter0_10, iter1_10 in pairs(var0_10[#var0_10]) do
		if iter1_10.bidValue ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.IsBidSuccess()
	local var0_11 = getProxy(AuctionGameProxy):GetRoundEventAndBidInfoList()

	for iter0_11, iter1_11 in pairs(var0_11[#var0_11]) do
		if iter1_11.state == 1 then
			return true
		end
	end

	return false
end

function var0_0.GetRevealItemEffectName(arg0_12)
	local var0_12 = pg.auction_collection[arg0_12]
	local var1_12 = var0_12.rarity
	local var2_12 = var0_12.contour
	local var3_12 = {
		"hui",
		"lan",
		"zi",
		"jin",
		"cai"
	}

	return string.format("effect/vx_auctiongame_icon%sx%s_%s", var2_12[1], var2_12[2], var3_12[var1_12])
end

function var0_0.RefreshItemDataByEvent(arg0_13)
	local var0_13 = arg0_13.event_id
	local var1_13 = pg.auction_event[var0_13]

	if var1_13 == nil then
		return
	end

	print("触发事件:", var0_13, var1_13.describe)

	local var2_13 = getProxy(AuctionGameProxy)
	local var3_13 = var2_13:GetStoreItemDataList()
	local var4_13 = var1_13.group == AuctionGameConst.EVENT_TYPE_GROUP.COMMON

	switch(var1_13.type, {
		[AuctionGameConst.EVENT_TYPE.ITEM_CONTOUR_BY_SIZE] = function()
			for iter0_14, iter1_14 in ipairs(arg0_13.item_list) do
				local var0_14 = iter1_14.uid

				if var3_13[var0_14] == nil then
					var3_13[var0_14] = AuctionGameStoreItemData.New(iter1_14)
				else
					var3_13[var0_14]:UpdateContour(iter1_14.pos)
				end

				local var1_14 = var1_13.config_data

				var3_13[var0_14]:InitContour(var1_14[1], var1_14[2])
				var3_13[var0_14]:SetShowContour()
				var3_13[var0_14]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.ITEM_POSITION] = function()
			for iter0_15, iter1_15 in ipairs(arg0_13.item_list) do
				local var0_15 = iter1_15.uid

				if var3_13[var0_15] == nil then
					var3_13[var0_15] = AuctionGameStoreItemData.New(iter1_15)
				else
					var3_13[var0_15].position = iter1_15.pos[1]
				end

				var3_13[var0_15]:SetShowPos()
				var3_13[var0_15]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_ITEM_COUNT] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.RANDOM_ITEM_RARITY] = function()
			for iter0_17, iter1_17 in ipairs(arg0_13.item_list) do
				local var0_17 = iter1_17.uid

				if var3_13[var0_17] == nil then
					var3_13[var0_17] = AuctionGameStoreItemData.New(iter1_17)
				else
					var3_13[var0_17]:UpdateRarity(iter1_17.rarity)
				end

				var3_13[var0_17]:SetShowRarity()
				var3_13[var0_17]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.REVEAL_ITEM] = function()
			for iter0_18, iter1_18 in ipairs(arg0_13.item_list) do
				local var0_18 = iter1_18.uid

				var3_13[var0_18] = AuctionGameStoreItemData.New(iter1_18)

				var3_13[var0_18]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_TOTAL_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.MAX_CELL_ITEM_CONTOUR] = function()
			for iter0_20, iter1_20 in ipairs(arg0_13.item_list) do
				local var0_20 = iter1_20.uid

				if var3_13[var0_20] == nil then
					var3_13[var0_20] = AuctionGameStoreItemData.New(iter1_20)
				else
					var3_13[var0_20]:UpdateContour(iter1_20.pos)
				end

				var3_13[var0_20]:SetShowContour()
				var3_13[var0_20]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_ITEM_CONTOUR] = function()
			for iter0_21, iter1_21 in ipairs(arg0_13.item_list) do
				local var0_21 = iter1_21.uid

				if var3_13[var0_21] == nil then
					var3_13[var0_21] = AuctionGameStoreItemData.New(iter1_21)
				else
					var3_13[var0_21]:UpdateContour(iter1_21.pos)
					var3_13[var0_21]:UpdateRarity(iter1_21.rarity)
				end

				local var1_21 = var1_13.config_data[1]

				var3_13[var0_21]:UpdateRarity(var1_21)
				var3_13[var0_21]:SetShowContour()
				var3_13[var0_21]:SetShowRarity()
				var3_13[var0_21]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.MAX_PRICE_ITEM_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.MAX_CELL_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.MAX_RARITY] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.TOTAL_CELL_COUNT] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_ITEMS_TOTAL_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.AVERAGE_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.ALL_ITEM_CONTOUR] = function()
			for iter0_28, iter1_28 in ipairs(arg0_13.item_list) do
				local var0_28 = iter1_28.uid

				if var3_13[var0_28] == nil then
					var3_13[var0_28] = AuctionGameStoreItemData.New(iter1_28)
				else
					var3_13[var0_28]:UpdateContour(iter1_28.pos)
				end

				var3_13[var0_28]:SetShowContour()
				var3_13[var0_28]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_ITEMS_POSITION] = function()
			for iter0_29, iter1_29 in ipairs(arg0_13.item_list) do
				local var0_29 = iter1_29.uid

				if var3_13[var0_29] == nil then
					var3_13[var0_29] = AuctionGameStoreItemData.New(iter1_29)
				else
					var3_13[var0_29]:UpdateRarity(iter1_29.rarity)
					var3_13[var0_29]:UpdatePos(iter1_29.pos[1])
				end

				local var1_29 = var1_13.config_data[1]

				var3_13[var0_29]:UpdateRarity(var1_29)
				var3_13[var0_29]:SetShowRarity()
				var3_13[var0_29]:SetShowPos()
				var3_13[var0_29]:SetRevealFlag(true)
			end
		end,
		[AuctionGameConst.EVENT_TYPE.CONTOUR_AVERAGE_PRICE] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.RARITY_ITEMS_CELL_COUNT] = function()
			return
		end,
		[AuctionGameConst.EVENT_TYPE.NULL] = function()
			return
		end
	}, function()
		print("事件类型未支持:" .. var1_13.type)
	end)
	var2_13:AddEventSummary(var2_13:GetRound(), var4_13, {
		eventID = var0_13,
		value = arg0_13.int_value
	})
end

function var0_0.GuideInitPlayerList()
	getProxy(AuctionGameProxy):InitGameData(1)

	local var0_34 = getProxy(PlayerProxy):getRawData()
	local var1_34 = {
		player_list = {}
	}

	for iter0_34, iter1_34 in ipairs(AuctionGameConst.GUIDE_NPC_LIST) do
		local var2_34

		if iter0_34 == 1 then
			var2_34 = iter1_34.icon
		else
			var2_34 = ShipSkin.New({
				id = iter1_34.icon
			}):ToShip().configId
		end

		table.insert(var1_34.player_list, {
			user_id = tostring(iter0_34),
			sort = iter0_34,
			player_info = {
				level = 100,
				id = tostring(iter0_34),
				name = pg.ship_skin_template[iter1_34.icon].name,
				display = {
					icon = var2_34,
					skin = iter1_34.icon,
					icon_frame = iter1_34.icon_frame
				}
			}
		})
	end

	table.insert(var1_34.player_list, {
		sort = 4,
		user_id = var0_34.id,
		player_info = {
			id = var0_34.id,
			level = var0_34.level,
			name = var0_34.name,
			display = {
				icon = var0_34.icon,
				skin = var0_34.skinId,
				icon_frame = var0_34.iconFrame,
				chat_frame = var0_34.chatFrame,
				marry_flag = var0_34.propose and 1 or 0
			}
		}
	})
	getProxy(AuctionGameProxy):UpdatePlayerList(var1_34)
end

function var0_0.GuideRound1()
	local var0_35 = {
		round = 1,
		start_time = pg.TimeMgr.GetInstance():GetServerTime(),
		public_event_effect = var0_0.GetFirstRoundPublicEventData(),
		event_list = {
			501,
			401,
			201
		},
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_event_choose_time.key_value
	}
	local var1_35 = getProxy(AuctionGameProxy)

	var1_35:UpdateRoundData(var0_35)
	var1_35:ResetPlayerOptState()

	var1_35.phaseTimestamp = var0_35.timestamp

	pg.m02:sendNotification(GAME.AUCTION_GAME_NEW_ROUND)
end

function var0_0.GetFirstRoundPublicEventData(arg0_36)
	return {
		event_id = 102,
		item_list = {
			{
				uid = 7,
				rarity = AuctionGameConst.GUIDE_ITEM_LIST[7].rarity,
				pos = AuctionGameConst.GUIDE_ITEM_LIST[7].pos
			},
			{
				uid = 9,
				rarity = AuctionGameConst.GUIDE_ITEM_LIST[9].rarity,
				pos = AuctionGameConst.GUIDE_ITEM_LIST[9].pos
			}
		}
	}
end

function var0_0.GetSecondRoundPublicEventEffect(arg0_37)
	return {
		event_id = 1101,
		int_value = 3
	}
end

function var0_0.GuideSelectedEvent(arg0_38)
	local var0_38 = {}

	if arg0_38 == 201 then
		var0_38 = {
			result = 0,
			public_event_effect = {
				event_id = 201,
				item_list = {
					{
						uid = 1,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[1].pos[1]
						}
					},
					{
						uid = 4,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[4].pos[1]
						}
					},
					{
						uid = 5,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[5].pos[1]
						}
					},
					{
						uid = 10,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[10].pos[1]
						}
					}
				}
			}
		}
	elseif arg0_38 == 401 then
		var0_38 = {
			result = 0,
			public_event_effect = {
				event_id = 401,
				item_list = {
					{
						uid = 5,
						rarity = AuctionGameConst.GUIDE_ITEM_LIST[5].rarity,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[5].pos[1]
						}
					},
					{
						uid = 2,
						rarity = AuctionGameConst.GUIDE_ITEM_LIST[2].rarity,
						pos = {
							AuctionGameConst.GUIDE_ITEM_LIST[2].pos[1]
						}
					}
				}
			}
		}
	elseif arg0_38 == 501 then
		var0_38 = {
			result = 0,
			public_event_effect = {
				event_id = 501,
				item_list = {
					{
						uid = 3,
						id = AuctionGameConst.GUIDE_ITEM_LIST[3].id,
						rarity = AuctionGameConst.GUIDE_ITEM_LIST[3].rarity,
						pos = AuctionGameConst.GUIDE_ITEM_LIST[3].pos
					}
				}
			}
		}
	end

	local var1_38 = getProxy(AuctionGameProxy)

	var1_38:SetPersonalEventSelectedID(arg0_38)
	var1_38:UpdateEventEffect(var0_38.public_event_effect)

	var1_38.auctionState = AuctionGameConst.AUCTION_PHASE.BID

	var0_0.GuideSelectedEventOver()
end

function var0_0.GuideOperateNotify()
	local var0_39 = {
		round = 1,
		opt_type = 2,
		user_id = getProxy(PlayerProxy):getPlayerId()
	}

	getProxy(AuctionGameProxy):UpdatePlayerOptState(var0_39)
end

function var0_0.GuideSelectedEventOver()
	local var0_40 = {
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_bid_time.key_value,
		player_events = {
			{
				event_id = 501,
				user_id = getProxy(PlayerProxy):getPlayerId()
			},
			{
				event_id = 201,
				user_id = "1"
			},
			{
				event_id = 401,
				user_id = "2"
			},
			{
				event_id = 301,
				user_id = "3"
			}
		}
	}
	local var1_40 = getProxy(AuctionGameProxy)

	var1_40:UpdateGroundEventList(var0_40.player_events)

	if var0_40.event_effect then
		var1_40:UpdateEventEffect(var0_40.event_effect)
	end

	var1_40:ResetPlayerOptState()

	var1_40.phaseTimestamp = var0_40.timestamp

	pg.m02:sendNotification(GAME.AUCTION_GAME_BID_PHASE)
end

function var0_0.GuideBided(arg0_41)
	local var0_41 = getProxy(PlayerProxy):getPlayerId()
	local var1_41 = {
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_publicity_time.key_value,
		bid_list = {
			{
				state = 0,
				user_id = var0_41,
				price = arg0_41
			},
			{
				user_id = "1",
				state = 0,
				price = arg0_41
			},
			{
				user_id = "2",
				state = 0,
				price = AuctionGameConst.GUIDE_NPC_BID_VALUE[2][1]
			},
			{
				user_id = "3",
				state = 0,
				price = AuctionGameConst.GUIDE_NPC_BID_VALUE[3][1]
			}
		}
	}
	local var2_41 = getProxy(AuctionGameProxy)

	var2_41:UpdatePlayerBidList(var1_41.bid_list)

	var2_41.phaseTimestamp = var1_41.timestamp

	var0_0.GuideOperateNotify()
	pg.m02:sendNotification(GAME.AUCTION_GAME_ROUND_OVER)
end

function var0_0.GuideRound2()
	local var0_42 = {
		round = 2,
		start_time = pg.TimeMgr.GetInstance():GetServerTime(),
		public_event_effect = var0_0.GetSecondRoundPublicEventEffect(),
		event_list = {
			501,
			401,
			201
		},
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_event_choose_time.key_value
	}
	local var1_42 = getProxy(AuctionGameProxy)

	var1_42:UpdateRoundData(var0_42)
	var1_42:ResetPlayerOptState()

	var1_42.phaseTimestamp = var0_42.timestamp

	pg.m02:sendNotification(GAME.AUCTION_GAME_NEW_ROUND)
	var1_42:SetPersonalEventSelectedID(201)

	var1_42.auctionState = AuctionGameConst.AUCTION_PHASE.BID

	var0_0.GuideSelectedEventOver()
end

function var0_0.GuideSkipToRound2()
	local var0_43 = {
		{
			price = 0,
			state = 0,
			user_id = getProxy(PlayerProxy):getPlayerId()
		},
		{
			user_id = "1",
			price = 0,
			state = 0
		},
		{
			user_id = "2",
			state = 0,
			price = AuctionGameConst.GUIDE_NPC_BID_VALUE[2][1]
		},
		{
			user_id = "3",
			state = 0,
			price = AuctionGameConst.GUIDE_NPC_BID_VALUE[3][1]
		}
	}
	local var1_43 = {
		round = 1,
		public_event_effect = var0_0.GetFirstRoundPublicEventData(),
		event_list = {
			501,
			401,
			201
		}
	}
	local var2_43 = getProxy(AuctionGameProxy)

	var2_43:UpdateRoundData(var1_43)
	var2_43:UpdateGroundEventList({})
	var2_43:UpdatePlayerBidList(var0_43)

	local var3_43 = {
		round = 2,
		start_time = pg.TimeMgr.GetInstance():GetServerTime(),
		public_event_effect = var0_0.GetSecondRoundPublicEventEffect(),
		event_list = {
			501,
			401,
			201
		},
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_event_choose_time.key_value
	}
	local var4_43 = getProxy(AuctionGameProxy)

	var4_43:UpdateRoundData(var3_43)
	var4_43:ResetPlayerOptState()

	var4_43.phaseTimestamp = var3_43.timestamp

	pg.m02:sendNotification(GAME.AUCTION_GAME_NEW_ROUND)
	var4_43:SetPersonalEventSelectedID(201)

	var4_43.auctionState = AuctionGameConst.AUCTION_PHASE.BID

	var0_0.GuideSelectedEventOver()
end

function var0_0.GuideBided2(arg0_44)
	local var0_44 = getProxy(PlayerProxy):getPlayerId()
	local var1_44 = {
		timestamp = pg.TimeMgr.GetInstance():GetServerTime() + pg.gameset.auction_publicity_time.key_value,
		bid_list = {
			{
				state = 0,
				user_id = var0_44,
				price = arg0_44
			},
			{
				user_id = "1",
				state = 0,
				price = AuctionGameConst.GUIDE_NPC_BID_VALUE[1][2]
			},
			{
				user_id = "2",
				state = 0,
				price = AuctionGameConst.GUIDE_NPC_BID_VALUE[2][2]
			},
			{
				user_id = "3",
				state = 0,
				price = AuctionGameConst.GUIDE_NPC_BID_VALUE[3][2]
			}
		}
	}
	local var2_44 = getProxy(AuctionGameProxy)

	var2_44:UpdatePlayerBidList(var1_44.bid_list)

	var2_44.phaseTimestamp = var1_44.timestamp

	pg.m02:sendNotification(GAME.AUCTION_GAME_ROUND_OVER)
end

function var0_0.GuideSettlement()
	local var0_45 = 0

	for iter0_45, iter1_45 in ipairs(AuctionGameConst.GUIDE_ITEM_LIST) do
		var0_45 = var0_45 + pg.auction_collection[iter1_45.id].value
	end

	local var1_45 = {
		bid_user_id = getProxy(PlayerProxy):getPlayerId(),
		bid_price = AuctionGameConst.GUIDE_BID_VALUE,
		item_list = AuctionGameConst.GUIDE_ITEM_LIST,
		change_gold = var0_45 - AuctionGameConst.GUIDE_BID_VALUE
	}

	getProxy(AuctionGameProxy):UpdateSettlementData(var1_45)
	pg.m02:sendNotification(GAME.AUCTION_GAME_SETTLEMENT)
end

return var0_0
