local var0_0 = class("IslandCheaterTavernAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	return
end

function var0_0.SetIsConnecting(arg0_2, arg1_2)
	arg0_2.isConnecting = arg1_2
end

function var0_0.IsConnecting(arg0_3)
	return arg0_3.isConnecting
end

function var0_0.SetUILoadOver(arg0_4, arg1_4)
	arg0_4.isUILoadOver = arg1_4

	if arg1_4 then
		for iter0_4, iter1_4 in ipairs(arg0_4.cacheFunc or {}) do
			iter1_4()
		end
	end

	arg0_4.cacheFunc = {}
end

function var0_0.IsUILoadOver(arg0_5)
	return arg0_5.isUILoadOver
end

function var0_0.AddCacheFunc(arg0_6, arg1_6)
	arg0_6.cacheFunc = arg0_6.cacheFunc or {}

	table.insert(arg0_6.cacheFunc, arg1_6)
end

function var0_0.SetStartGameData(arg0_7, arg1_7)
	arg0_7.player_dic = {}
	arg0_7.roomType = arg1_7.room_type
	arg0_7.allPlayerNum = #arg1_7.player_list
	arg0_7.curPlayerSeat = 0

	for iter0_7, iter1_7 in ipairs(arg1_7.player_list) do
		if iter1_7.user_id == getProxy(PlayerProxy):getRawData().id then
			arg0_7.curPlayerSeat = iter1_7.seat
		end

		arg0_7.player_dic[iter1_7.user_id] = IslandCheaterPlayer.New(iter1_7)
	end

	arg0_7:SetMainPlayerCards(arg1_7.card_list)
	arg0_7:SetRealCard(arg1_7.real_card)
end

function var0_0.SetResetGameData(arg0_8, arg1_8)
	arg0_8.player_dic = {}
	arg0_8.roomType = arg1_8.room_type
	arg0_8.allPlayerNum = #arg1_8.player_list + #arg1_8.out_player_list
	arg0_8.curPlayerSeat = 0

	for iter0_8, iter1_8 in ipairs(arg1_8.player_list) do
		if iter1_8.user_id == getProxy(PlayerProxy):getRawData().id then
			arg0_8.curPlayerSeat = iter1_8.seat
		end

		arg0_8.player_dic[iter1_8.user_id] = IslandCheaterPlayer.New(iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(arg1_8.out_player_list) do
		if iter3_8.user_id == getProxy(PlayerProxy):getRawData().id then
			arg0_8.curPlayerSeat = iter3_8.seat
		end

		iter3_8.card_num = 0
		arg0_8.player_dic[iter3_8.user_id] = IslandCheaterPlayer.New(iter3_8)

		arg0_8.player_dic[iter3_8.user_id]:SetOutState()
	end

	arg0_8:SetMainPlayerCards(arg1_8.card_list)
	arg0_8:SetRealCard(arg1_8.real_card)
end

function var0_0.GetRoomType(arg0_9)
	return arg0_9.roomType
end

function var0_0.UpdateGameDataEveryRound(arg0_10, arg1_10)
	arg0_10:SetMainPlayerCards(arg1_10.card_list)
	arg0_10:SetRealCard(arg1_10.real_card)

	for iter0_10, iter1_10 in pairs(arg0_10.player_dic) do
		if iter1_10.state == 0 then
			iter1_10.card_num = IslandCheaterTavernConst.cardNumEveryRound
		end
	end
end

function var0_0.SetMainPlayerCards(arg0_11, arg1_11)
	arg0_11.cardList = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		table.insert(arg0_11.cardList, IslandCheaterCard.New(iter1_11))
	end
end

function var0_0.GetMainPlayerCards(arg0_12)
	table.sort(arg0_12.cardList, function(arg0_13, arg1_13)
		return arg0_13.key < arg1_13.key
	end)

	return arg0_12.cardList
end

function var0_0.ClearMainPlayerCards(arg0_14)
	arg0_14.cardList = {}
end

function var0_0.MainPlayerPutCard(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg1_15 or {}) do
		for iter2_15, iter3_15 in ipairs(arg0_15.cardList) do
			if iter3_15.key == iter1_15 then
				table.insert(var0_15, iter2_15)
			end
		end
	end

	table.sort(var0_15, function(arg0_16, arg1_16)
		return arg1_16 < arg0_16
	end)

	for iter4_15, iter5_15 in ipairs(var0_15) do
		table.remove(arg0_15.cardList, iter5_15)
	end
end

function var0_0.GetMainPlayerAutoPutCard(arg0_17, arg1_17)
	local var0_17 = {}
	local var1_17 = arg0_17:GetMainPlayerCards()

	for iter0_17 = 1, arg1_17 do
		table.insert(var0_17, var1_17[iter0_17].key)
	end

	return var0_17
end

function var0_0.SetRealCard(arg0_18, arg1_18)
	arg0_18.real_card = arg1_18
end

function var0_0.GetRealCard(arg0_19)
	return arg0_19.real_card
end

function var0_0.ReducePlayerCardNum(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.player_dic[arg1_20]

	if var0_20 then
		var0_20:ReduceCardNum(arg2_20)
	end
end

function var0_0.GetPlayerCardNum(arg0_21, arg1_21)
	local var0_21 = arg0_21.player_dic[arg1_21]

	return var0_21 and var0_21:GetCardNum() or 0
end

function var0_0.UpdatePlayerBombState(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22.player_dic[arg1_22]

	if var0_22 then
		var0_22:UpdateBombState(arg2_22)

		if arg3_22 == 1 then
			var0_22:SetOutState()

			if arg1_22 == getProxy(PlayerProxy):getRawData().id then
				arg0_22:ClearMainPlayerCards()
			end
		end
	end
end

function var0_0.UpdatePlayerDelegateState(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.player_dic[arg1_23]

	if var0_23 then
		var0_23:UpdateDelegateState(arg2_23)
	end
end

function var0_0.GetPlayerCurrentAndAllHp(arg0_24, arg1_24)
	local var0_24 = arg0_24.player_dic[arg1_24]

	if var0_24 then
		return var0_24:GetCurrentAndAllHp()
	end

	return 0, 0
end

function var0_0.GetMainPlayer(arg0_25)
	local var0_25 = getProxy(PlayerProxy):getRawData().id

	return arg0_25.player_dic[var0_25]
end

function var0_0.GetPlayerData(arg0_26, arg1_26)
	return arg0_26.player_dic[arg1_26]
end

function var0_0.GetPlayerList(arg0_27)
	local var0_27 = {}
	local var1_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.player_dic) do
		local var2_27 = iter1_27.seat

		if iter1_27.user_id ~= getProxy(PlayerProxy):getRawData().id then
			local var3_27 = (iter1_27.seat - arg0_27.curPlayerSeat + arg0_27.allPlayerNum) % arg0_27.allPlayerNum

			var0_27[var3_27] = iter1_27
			var1_27[iter1_27.user_id] = var3_27
		end
	end

	return var0_27, var1_27
end

function var0_0.CheckCanOnlyQurey(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.player_dic) do
		if iter1_28.user_id ~= getProxy(PlayerProxy):getRawData().id and not iter1_28:IsOut() and iter1_28:GetCardNum() ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.GetCurrentPtNum(arg0_29)
	return 0
end

function var0_0.CheckWinerUserId(arg0_30)
	local var0_30
	local var1_30 = 0

	for iter0_30, iter1_30 in pairs(arg0_30.player_dic) do
		if not iter1_30:IsOut() then
			var0_30 = iter1_30.user_id
			var1_30 = var1_30 + 1
		end
	end

	if var1_30 == 1 then
		return var0_30
	end
end

return var0_0
