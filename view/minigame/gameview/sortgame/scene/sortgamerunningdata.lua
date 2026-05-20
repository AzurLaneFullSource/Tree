local var0_0 = class("SortGameRunningData")

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.SetChapterData(arg0_2, arg1_2)
	arg0_2._chapter = arg1_2

	arg0_2:initData()
end

function var0_0.initData(arg0_3)
	arg0_3._playerIds = arg0_3:GetChapterConfig("player_list")
	arg0_3._playerWantedItem = arg0_3:GetPlayersItems(arg0_3._playerIds)
end

function var0_0.GetPlayerName(arg0_4, arg1_4)
	return SortGameConst.player_data[arg1_4].name
end

function var0_0.GetPlayerIdByItem(arg0_5, arg1_5)
	for iter0_5 = 1, #arg0_5._playerIds do
		local var0_5 = arg0_5._playerIds[iter0_5]

		if table.contains(SortGameConst.player_data[var0_5].items, arg1_5) then
			return var0_5
		end
	end

	return nil
end

function var0_0.GetChapterConfig(arg0_6, arg1_6)
	return Clone(arg0_6._chapter[arg1_6])
end

function var0_0.GetBoundConfig(arg0_7)
	return Clone(SortGameConst.bounds_data[arg0_7._chapter.bound])
end

function var0_0.GetOffsetConfig(arg0_8)
	return Clone(SortGameConst.grid_offset[arg0_8._chapter.offset])
end

function var0_0.GetAllPlayerItems(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9._playerIds) do
		for iter2_9 = 1, #SortGameConst.player_data[iter1_9].items do
			local var1_9 = SortGameConst.player_data[iter1_9].items[iter2_9]

			table.insert(var0_9, var1_9)
		end
	end

	return var0_9
end

function var0_0.GetPlayers(arg0_10)
	return arg0_10._playerIds
end

function var0_0.GetPlayersItems(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg1_11) do
		local var1_11 = arg0_11:GetPlayerItems(iter1_11)

		for iter2_11 = 1, #var1_11 do
			table.insert(var0_11, var1_11[iter2_11])
		end
	end

	return var0_11
end

function var0_0.GetPlayerItems(arg0_12, arg1_12)
	local var0_12 = {}

	if arg1_12 then
		for iter0_12 = 1, #SortGameConst.player_data[arg1_12].items do
			local var1_12 = SortGameConst.player_data[arg1_12].items[iter0_12]

			table.insert(var0_12, var1_12)
		end
	end

	return var0_12
end

function var0_0.GetComonItems(arg0_13)
	local var0_13 = {}
	local var1_13 = arg0_13:GetPlayersItems(arg0_13._playerIds)

	for iter0_13 = 1, #SortGameConst.common_item_id do
		local var2_13 = SortGameConst.common_item_id[iter0_13]

		if not table.contains(var1_13, var2_13) then
			table.insert(var0_13, var2_13)
		end
	end

	arg0_13:shuffleArray(var0_13)

	return var0_13
end

function var0_0.shuffleArray(arg0_14, arg1_14)
	for iter0_14 = #arg1_14, 2, -1 do
		local var0_14 = math.random(1, iter0_14)

		arg1_14[iter0_14], arg1_14[var0_14] = arg1_14[var0_14], arg1_14[iter0_14]
	end
end

function var0_0.GetPlayerPrefab(arg0_15, arg1_15)
	if arg1_15 == nil then
		arg1_15 = arg0_15._playerIds[math.random(1, #arg0_15._playerIds)]
	end

	return Clone(SortGameConst.player_data[arg1_15].prefab)
end

function var0_0.GetRandomWantedItem(arg0_16, arg1_16)
	if #arg0_16._playerWantedItem == 0 then
		return nil
	end

	local var0_16 = arg0_16:GetItemCountDic(arg1_16)

	for iter0_16 = 1, #arg0_16._playerWantedItem do
		local var1_16 = arg0_16._playerWantedItem[iter0_16]

		if var0_16[var1_16] and var0_16[var1_16] >= 3 then
			return var1_16
		end
	end

	return nil
end

function var0_0.GetItemCountDic(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17 = 1, #arg1_17 do
		local var1_17 = arg1_17[iter0_17]

		if var0_17[var1_17] == nil then
			var0_17[var1_17] = 1
		else
			var0_17[var1_17] = var0_17[var1_17] + 1
		end
	end

	return var0_17
end

function var0_0.GetSpeakData(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:GetChatConfig(arg1_18, arg2_18)

	if var0_18 ~= nil then
		return {
			text = var0_18.text,
			time = var0_18.show_time / 1000,
			icon = var0_18.sculpture
		}
	end

	return nil
end

function var0_0.GetChatConfig(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg2_19 or arg0_19:GetPlayerName(arg0_19._playerIds[math.random(1, #arg0_19._playerIds)])

	for iter0_19 = 1, #pg.activity_event_sortgame_chat.all do
		local var1_19 = pg.activity_event_sortgame_chat.all[iter0_19]
		local var2_19 = pg.activity_event_sortgame_chat[var1_19]

		if var2_19.sculpture == var0_19 and var2_19.type == arg1_19 then
			return var2_19
		end
	end

	return nil
end

function var0_0.Clear(arg0_20)
	return
end

function var0_0.Dispose(arg0_21)
	return
end

return var0_0
