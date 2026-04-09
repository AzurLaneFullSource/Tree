local var0_0 = class("IslandCheaterTavernAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	return
end

function var0_0.SetIsConnecting(arg0_2)
	arg0_2.isConnecting = true
end

function var0_0.IsConnecting(arg0_3)
	return arg0_3.isConnecting
end

function var0_0.SetStartGameData(arg0_4, arg1_4)
	arg0_4.player_dic = {}
	arg0_4.roomType = arg1_4.room_type
	arg0_4.allPlayerNum = #arg1_4.player_list
	arg0_4.curPlayerSeat = 0

	for iter0_4, iter1_4 in ipairs(arg1_4.player_list) do
		if iter1_4.user_id == getProxy(PlayerProxy):getRawData().id then
			arg0_4.curPlayerSeat = iter1_4.seat
		end

		arg0_4.player_dic[iter1_4.user_id] = IslandCheaterPlayer.New(iter1_4)
	end

	arg0_4:SetMainPlayerCards(arg1_4.card_list)
	arg0_4:SetRealCard(arg1_4.real_card)
end

function var0_0.SetResetGameData(arg0_5, arg1_5)
	arg0_5.player_dic = {}
	arg0_5.roomType = arg1_5.room_type
	arg0_5.allPlayerNum = #arg1_5.player_list
	arg0_5.curPlayerSeat = 0

	for iter0_5, iter1_5 in ipairs(arg1_5.player_list) do
		if iter1_5.user_id == getProxy(PlayerProxy):getRawData().id then
			arg0_5.curPlayerSeat = iter1_5.seat
		end

		arg0_5.player_dic[iter1_5.user_id] = IslandCheaterPlayer.New(iter1_5)
	end

	arg0_5:SetMainPlayerCards(arg1_5.card_list)
	arg0_5:SetRealCard(arg1_5.real_card)
end

function var0_0.GetRoomType(arg0_6)
	return arg0_6.roomType
end

function var0_0.UpdateGameDataEveryRound(arg0_7, arg1_7)
	arg0_7:SetMainPlayerCards(arg1_7.card_list)
	arg0_7:SetRealCard(arg1_7.real_card)

	for iter0_7, iter1_7 in pairs(arg0_7.player_dic) do
		if iter1_7.state == 0 then
			iter1_7.card_num = IslandCheaterTavernConst.cardNumEveryRound
		end
	end
end

function var0_0.SetMainPlayerCards(arg0_8, arg1_8)
	arg0_8.cardList = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		table.insert(arg0_8.cardList, IslandCheaterCard.New(iter1_8))
	end
end

function var0_0.GetMainPlayerCards(arg0_9)
	table.sort(arg0_9.cardList, function(arg0_10, arg1_10)
		return arg0_10.key < arg1_10.key
	end)

	return arg0_9.cardList
end

function var0_0.MainPlayerPutCard(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11 or {}) do
		for iter2_11, iter3_11 in ipairs(arg0_11.cardList) do
			if iter3_11.key == iter1_11 then
				table.insert(var0_11, iter2_11)
			end
		end
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg1_12 < arg0_12
	end)

	for iter4_11, iter5_11 in ipairs(var0_11) do
		table.remove(arg0_11.cardList, iter5_11)
	end
end

function var0_0.GetMainPlayerAutoPutCard(arg0_13, arg1_13)
	local var0_13 = {}
	local var1_13 = arg0_13:GetMainPlayerCards()

	for iter0_13 = 1, arg1_13 do
		table.insert(var0_13, var1_13[iter0_13].key)
	end

	return var0_13
end

function var0_0.SetRealCard(arg0_14, arg1_14)
	arg0_14.real_card = arg1_14
end

function var0_0.GetRealCard(arg0_15)
	return arg0_15.real_card
end

function var0_0.ReducePlayerCardNum(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.player_dic[arg1_16]

	if var0_16 then
		var0_16:ReduceCardNum(arg2_16)
	end
end

function var0_0.GetPlayerCardNum(arg0_17, arg1_17)
	local var0_17 = arg0_17.player_dic[arg1_17]

	return var0_17 and var0_17:GetCardNum() or 0
end

function var0_0.UpdatePlayerBombState(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18.player_dic[arg1_18]

	if var0_18 then
		var0_18:UpdateBombState(arg2_18)

		if arg3_18 == 1 then
			var0_18:SetOutState()
		end
	end
end

function var0_0.UpdatePlayerDelegateState(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.player_dic[arg1_19]

	if var0_19 then
		var0_19:UpdateDelegateState(arg2_19)
	end
end

function var0_0.GetPlayerCurrentAndAllHp(arg0_20, arg1_20)
	local var0_20 = arg0_20.player_dic[arg1_20]

	if var0_20 then
		return var0_20:GetCurrentAndAllHp()
	end

	return 0, 0
end

function var0_0.GetMainPlayer(arg0_21)
	local var0_21 = getProxy(PlayerProxy):getRawData().id

	return arg0_21.player_dic[var0_21]
end

function var0_0.GetPlayerData(arg0_22, arg1_22)
	return arg0_22.player_dic[arg1_22]
end

function var0_0.GetPlayerList(arg0_23)
	local var0_23 = {}
	local var1_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.player_dic) do
		local var2_23 = iter1_23.seat

		if iter1_23.user_id ~= getProxy(PlayerProxy):getRawData().id then
			local var3_23 = (iter1_23.seat - arg0_23.curPlayerSeat + arg0_23.allPlayerNum) % arg0_23.allPlayerNum

			var0_23[var3_23] = iter1_23
			var1_23[iter1_23.user_id] = var3_23
		end
	end

	return var0_23, var1_23
end

function var0_0.CheckCanOnlyQurey(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.player_dic) do
		if iter1_24.user_id ~= getProxy(PlayerProxy):getRawData().id and not iter1_24:IsOut() and iter1_24:GetCardNum() ~= 0 then
			return false
		end
	end

	return true
end

function var0_0.GetCurrentPtNum(arg0_25)
	return 0
end

function var0_0.CheckWinerUserId(arg0_26)
	local var0_26
	local var1_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26.player_dic) do
		if not iter1_26:IsOut() then
			var0_26 = iter1_26.user_id
			var1_26 = var1_26 + 1
		end
	end

	if var1_26 == 1 then
		return var0_26
	end
end

return var0_0
