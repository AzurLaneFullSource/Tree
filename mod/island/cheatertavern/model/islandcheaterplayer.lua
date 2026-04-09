local var0_0 = class("IslandCheaterPlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.user_id = arg1_1.user_id
	arg0_1.seat = arg1_1.seat
	arg0_1.card_num = arg1_1.card_num
	arg0_1.bomb_dic = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.bomb_list) do
		arg0_1.bomb_dic[iter1_1.bomb_id] = iter1_1.state == 1
	end

	arg0_1.state = 0
	arg0_1.player_info = arg1_1.player_info
end

function var0_0.SetGameData(arg0_2, arg1_2, arg2_2)
	arg0_2.rank = arg1_2
	arg0_2.addScore = arg2_2
end

function var0_0.GetRank(arg0_3)
	return arg0_3.rank
end

function var0_0.GetAddScore(arg0_4)
	return arg0_4.addScore
end

function var0_0.GetName(arg0_5)
	return arg0_5.player_info.name
end

function var0_0.ReduceCardNum(arg0_6, arg1_6)
	arg0_6.card_num = arg0_6.card_num - arg1_6
end

function var0_0.GetCardNum(arg0_7)
	return arg0_7.card_num
end

function var0_0.UpdateBombState(arg0_8, arg1_8)
	arg0_8.bomb_dic[arg1_8] = true
end

function var0_0.UpdateDelegateState(arg0_9, arg1_9)
	arg0_9.delegateState = arg1_9
end

function var0_0.IsDelegate(arg0_10)
	return arg0_10.delegateState == 1
end

function var0_0.SetOutState(arg0_11)
	arg0_11.state = 1
end

function var0_0.IsOut(arg0_12)
	return arg0_12.state == 1
end

function var0_0.GetBombState(arg0_13, arg1_13)
	return arg0_13.bomb_dic[arg1_13] or false
end

function var0_0.GetCurrentAndAllHp(arg0_14)
	local var0_14 = 0
	local var1_14 = 0

	for iter0_14, iter1_14 in pairs(arg0_14.bomb_dic) do
		if iter1_14 then
			var0_14 = var0_14 + 1
		end

		var1_14 = var1_14 + 1
	end

	return var1_14 - var0_14, var1_14
end

function var0_0.GetCurrentBombId(arg0_15)
	local var0_15
	local var1_15 = 0
	local var2_15 = pg.gameset.bar_punishment_limit.key_value

	for iter0_15 = 1, var2_15 do
		if arg0_15.bomb_dic[iter0_15] == false and not var0_15 then
			var0_15 = iter0_15 - 1
		elseif arg0_15.bomb_dic[iter0_15] == true then
			var1_15 = var1_15 + 1
		end
	end

	if var0_15 == 0 then
		var0_15 = var2_15
	end

	return var0_15 or 1, var1_15
end

return var0_0
