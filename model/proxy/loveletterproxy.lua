local var0_0 = class("LoveLetterProxy", import(".NetProxy"))

var0_0.UPDATE_LOVE_LETTER = "LoveLetterProxy.UPDATE_LOVE_LETTER"

function var0_0.register(arg0_1)
	arg0_1.letterTextContent = {}
end

function var0_0.SetGroupList(arg0_2, arg1_2)
	arg0_2.data = {}
	arg0_2.levelAll = 0

	for iter0_2, iter1_2 in ipairs(arg1_2.medal_list) do
		arg0_2.data[iter1_2.group_id] = LoveLetter.New(iter1_2)
		arg0_2.levelAll = arg0_2.levelAll + arg0_2.data[iter1_2.group_id]:GetDisplayLevel()
	end

	for iter2_2, iter3_2 in ipairs(arg1_2.letter_list) do
		arg0_2:GetGroupData(iter3_2.group_id):SetUnlockLetters(iter3_2.letter_id_list)
	end

	arg0_2.giftRecord = {}

	for iter4_2, iter5_2 in ipairs(arg1_2.converted_list) do
		table.insert(arg0_2.giftRecord, {
			year = iter5_2.year,
			group_id = iter5_2.group_id,
			item_id = iter5_2.item_id
		})
	end

	arg0_2.rewardMarkDic = {}

	for iter6_2, iter7_2 in ipairs(arg1_2.rewarded_list) do
		arg0_2.rewardMarkDic[iter7_2] = true
	end
end

function var0_0.GetGroupData(arg0_3, arg1_3)
	if not arg0_3.data[arg1_3] then
		arg0_3.data[arg1_3] = LoveLetter.New({
			group_id = arg1_3
		})
	end

	return arg0_3.data[arg1_3]
end

function var0_0.LevelUp(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetGroupData(arg1_4)

	arg0_4.levelAll = arg0_4.levelAll - var0_4:GetDisplayLevel()

	var0_4:MaxLevelUp()

	arg0_4.levelAll = arg0_4.levelAll + var0_4:GetDisplayLevel()

	arg0_4:sendNotification(LoveLetterProxy.UPDATE_LOVE_LETTER)
end

function var0_0.UnlockLetter(arg0_5, arg1_5, arg2_5)
	arg0_5:GetGroupData(arg1_5):SetUnlockLetters({
		arg2_5
	})
end

function var0_0.CanGetReward(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg1_6) do
		local var0_6 = pg.lover_reward[iter1_6]

		assert(var0_6)

		if arg0_6.rewardMarkDic[iter1_6] then
			return false
		end

		if arg0_6.levelAll < var0_6.total_level then
			return false
		end
	end

	return true
end

function var0_0.MarkReward(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg1_7) do
		arg0_7.rewardMarkDic[iter1_7] = true
	end
end

function var0_0.GetLoveLetterItemDic(arg0_8)
	if not var0_0.letterItemDic then
		var0_0.letterItemDic = {}
		var0_0.letterIdMap = {}

		for iter0_8, iter1_8 in ipairs(pg.lover_letter_content.all) do
			local var0_8 = pg.lover_letter_content[iter1_8]

			var0_0.letterIdMap[var0_8.ship_group .. "_" .. var0_8.year] = iter1_8

			for iter2_8, iter3_8 in ipairs(var0_8.love_item) do
				for iter4_8, iter5_8 in ipairs({
					0,
					var0_8.ship_group
				}) do
					local var1_8 = iter3_8 .. "_" .. iter5_8

					var0_0.letterItemDic[var1_8] = var0_0.letterItemDic[var1_8] or {}
					var0_0.letterItemDic[var1_8][var0_8.year] = var0_8.ship_group
				end
			end
		end

		var0_0.groupChangeDic = {}

		for iter6_8, iter7_8 in ipairs(pg.lover_character_template.all) do
			local var2_8 = pg.lover_character_template[iter7_8]

			for iter8_8, iter9_8 in ipairs(var2_8.relate_group_id) do
				var0_0.groupChangeDic[iter9_8] = iter7_8
			end
		end
	end

	return var0_0.letterItemDic, var0_0.letterIdMap, var0_0.groupChangeDic
end

function var0_0.CanRealizeGift(arg0_9)
	local var0_9 = getProxy(BagProxy):GetAllLoveLetterItem()
	local var1_9, var2_9, var3_9 = arg0_9:GetLoveLetterItemDic()
	local var4_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.giftRecord) do
		local var5_9 = var3_9[iter1_9.group_id] or iter1_9.group_id

		var4_9[var5_9] = var4_9[var5_9] or {}

		table.insert(var4_9[var5_9], iter1_9)
	end

	for iter2_9, iter3_9 in pairs(var4_9) do
		if not underscore.any(var0_9, function(arg0_10)
			local var0_10, var1_10 = unpack(arg0_10)
			local var2_10 = var1_10 and var3_9[var1_10] or var1_10 or 0

			for iter0_10, iter1_10 in pairs(var1_9[var0_10 .. "_" .. var2_10]) do
				if iter1_10 == iter2_9 then
					return true
				end
			end

			return false
		end) then
			table.insertto(var0_9, underscore.map(iter3_9, function(arg0_11)
				if pg.item_data_statistics[arg0_11.item_id].type == Item.LOVE_LETTER_TYPE then
					return {
						arg0_11.item_id,
						arg0_11.group_id
					}
				else
					return {
						arg0_11.item_id,
						0
					}
				end
			end))
		end
	end

	if #var0_9 > #arg0_9.giftRecord then
		return var0_9
	else
		return false
	end
end

function var0_0.UpdateRealizeGift(arg0_12, arg1_12)
	local var0_12, var1_12, var2_12 = arg0_12:GetLoveLetterItemDic()
	local var3_12 = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		local var4_12 = var2_12[iter1_12.group_id] or iter1_12.group_id

		var3_12[var4_12] = var3_12[var4_12] or {}

		table.insert(var3_12[var4_12], iter1_12)
	end

	local var5_12 = {}

	for iter2_12, iter3_12 in ipairs(arg0_12.giftRecord) do
		local var6_12
		local var7_12 = var2_12[iter3_12.group_id] or iter3_12.group_id

		for iter4_12, iter5_12 in ipairs(var3_12[var7_12] or {}) do
			if iter5_12.item_id == iter3_12.item_id and iter5_12.year == iter3_12.year then
				var6_12 = iter4_12

				break
			end
		end

		if var6_12 then
			table.remove(var3_12[var7_12], var6_12)
		else
			var5_12[var7_12] = var5_12[var7_12] or {}

			table.insert(var5_12[var7_12], iter3_12)
		end
	end

	for iter6_12, iter7_12 in pairs(var3_12) do
		assert(#iter7_12 >= #(var5_12[iter6_12] or {}))

		local var8_12 = arg0_12:GetGroupData(iter6_12)

		arg0_12.levelAll = arg0_12.levelAll - var8_12:GetDisplayLevel()

		var8_12:AddGiftExp(#iter7_12 - #(var5_12[iter6_12] or {}))

		arg0_12.levelAll = arg0_12.levelAll + var8_12:GetDisplayLevel()

		for iter8_12, iter9_12 in ipairs(var5_12[iter6_12] or {}) do
			local var9_12 = var1_12[iter6_12 .. "_" .. iter9_12.year]

			var8_12.unlockLetterDic[var9_12] = var8_12.unlockLetterDic[var9_12] - 1
		end

		for iter10_12, iter11_12 in ipairs(iter7_12) do
			local var10_12 = var1_12[(var2_12[iter11_12.group_id] or iter11_12.group_id) .. "_" .. iter11_12.year]

			var8_12.unlockLetterDic[var10_12] = defaultValue(var8_12.unlockLetterDic[var10_12], 0) + 1
		end
	end

	arg0_12.giftRecord = arg1_12
	arg0_12.giftTip = false

	arg0_12:sendNotification(LoveLetterProxy.UPDATE_LOVE_LETTER)
end

function var0_0.AddLoveLetterExp(arg0_13, arg1_13, arg2_13)
	arg2_13 = arg0_13:GetGroupData(arg1_13):AddExp(arg2_13)

	return arg2_13
end

function var0_0.GetDisplayGroupList(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.data) do
		if iter1_14.exp ~= 0 then
			table.insert(var0_14, iter1_14.groupId)
		end
	end

	table.sort(var0_14)

	local var1_14 = getProxy(CollectionProxy):RawgetGroups()

	return underscore.map(var0_14, function(arg0_15)
		return var1_14[arg0_15]
	end)
end

function var0_0.GetAllLevel(arg0_16)
	return arg0_16.levelAll
end

function var0_0.GetAllLevelNextAwardIndex(arg0_17)
	for iter0_17, iter1_17 in ipairs(pg.lover_reward.all) do
		if not arg0_17.rewardMarkDic[iter1_17] then
			return iter0_17
		end
	end

	return nil
end

function var0_0.GetAllLevelAwardDisplayIndex(arg0_18)
	local var0_18

	for iter0_18, iter1_18 in ipairs(pg.lover_reward.all) do
		var0_18 = iter0_18

		if pg.lover_reward[iter1_18].total_level > arg0_18.levelAll then
			break
		end
	end

	return var0_18
end

function var0_0.GetAllLevelProgress(arg0_19)
	local var0_19 = arg0_19:GetAllLevelNextAwardIndex()

	if not var0_19 then
		return 0, 0
	else
		local var1_19 = pg.lover_reward.all
		local var2_19 = var0_19 > 1 and pg.lover_reward[var1_19[var0_19 - 1]].total_level or 0

		return arg0_19.levelAll - var2_19, pg.lover_reward[var1_19[var0_19]].total_level - var2_19
	end
end

function var0_0.GetAllLevelNextAward(arg0_20)
	local var0_20 = pg.lover_reward.all
	local var1_20 = var0_20[arg0_20:GetAllLevelNextAwardIndex() or #var0_20]

	return underscore.map(pg.lover_reward[var1_20].show_reward, function(arg0_21)
		return Drop.Create(arg0_21)
	end)
end

function var0_0.GetAllLevelRewardMarkDic(arg0_22)
	return arg0_22.rewardMarkDic
end

function var0_0.GetAllLevelReadyReward(arg0_23)
	local var0_23 = {}
	local var1_23 = arg0_23:GetAllLevelRewardMarkDic()

	for iter0_23, iter1_23 in ipairs(pg.lover_reward.all) do
		if pg.lover_reward[iter1_23].total_level > arg0_23.levelAll then
			break
		elseif not var1_23[iter1_23] then
			table.insert(var0_23, iter1_23)
		end
	end

	return var0_23
end

function var0_0.RecordLoveLetterContent(arg0_24, arg1_24, arg2_24)
	arg0_24.letterTextContent[arg1_24] = HXSet.hxLan(arg2_24)
end

function var0_0.GetLoveLetterContent(arg0_25, arg1_25)
	return arg0_25.letterTextContent[arg1_25]
end

function var0_0.GetDisPlayerGroupDatas(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.data or {}) do
		if iter1_26.exp > 0 then
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

function var0_0.GetTrophyList(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(arg0_27:GetDisPlayerGroupDatas()) do
		table.insertto(var0_27, iter1_27:GetTrophyList())
	end

	return var0_27
end

function var0_0.GetDisplayLetterList(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.data) do
		if iter1_28.exp > 0 and #iter1_28:GetDisplayLetterList() > 0 then
			table.insert(var0_28, iter0_28)
		end
	end

	table.sort(var0_28, CompareFuncs({
		function(arg0_29)
			return -arg0_28.data[arg0_29].level
		end,
		function(arg0_30)
			return -arg0_28.data[arg0_30].exp
		end,
		function(arg0_31)
			return arg0_31
		end
	}))

	local var1_28 = getProxy(CollectionProxy):RawgetGroups()

	return underscore.map(var0_28, function(arg0_32)
		return var1_28[arg0_32]
	end)
end

function var0_0.GetRecordGiftLetters(arg0_33, arg1_33)
	local var0_33 = {}
	local var1_33, var2_33, var3_33 = arg0_33:GetLoveLetterItemDic()

	for iter0_33, iter1_33 in ipairs(arg0_33.giftRecord) do
		if (var3_33[iter1_33.group_id] or iter1_33.group_id) == arg1_33 then
			table.insert(var0_33, var2_33[arg1_33 .. "_" .. iter1_33.year])
		end
	end

	return var0_33
end

function var0_0.IsTipRealizeGift(arg0_34)
	if not arg0_34.data then
		return false
	end

	if arg0_34.giftTip == nil then
		arg0_34.giftTip = arg0_34:CanRealizeGift()
	end

	return arg0_34.giftTip
end

function var0_0.IsTipLevelUp(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		if iter1_35:GetDisplayLevel() < iter1_35:GetMaxLevel() and iter1_35:CanLevelUp() then
			return true
		end
	end

	return false
end

function var0_0.IsTipAllLevelReward(arg0_36)
	local var0_36, var1_36 = arg0_36:GetAllLevelProgress()

	return var1_36 > 0 and var1_36 <= var0_36
end

function var0_0.IsTipUnlockLetter(arg0_37)
	for iter0_37, iter1_37 in pairs(arg0_37.data) do
		for iter2_37, iter3_37 in ipairs(pg.lover_letter_content.get_id_list_by_ship_group[iter0_37]) do
			if iter1_37:CanUnlockLetter(iter3_37) and not iter1_37:GetLetterUnlock(iter3_37) then
				return true
			end
		end
	end

	return false
end

function var0_0.GetSystemData(arg0_38, arg1_38)
	if not arg0_38.data then
		arg0_38:sendNotification(GAME.GET_ALL_LOVE_LETTER_DATA, {
			callback = arg1_38
		})
	else
		arg1_38()
	end
end

function var0_0.remove(arg0_39)
	arg0_39.data = nil
end

return var0_0
