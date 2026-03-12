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

			if not pg.lover_character_template[var0_8.ship_group] then
				-- block empty
			else
				var0_0.letterIdMap[var0_8.ship_group .. "_" .. var0_8.year] = iter1_8

				for iter2_8, iter3_8 in ipairs(var0_8.love_item) do
					for iter4_8, iter5_8 in ipairs(table.insertto({
						var0_8.ship_group
					}, pg.lover_character_template[var0_8.ship_group].relate_group_id)) do
						for iter6_8, iter7_8 in ipairs({
							0,
							iter5_8
						}) do
							local var1_8 = iter3_8 .. "_" .. iter7_8

							var0_0.letterItemDic[var1_8] = var0_0.letterItemDic[var1_8] or {}
							var0_0.letterItemDic[var1_8][var0_8.year] = var0_8.ship_group
						end
					end
				end
			end
		end
	end

	return var0_0.letterItemDic, var0_0.letterIdMap
end

function var0_0.CanRealizeGift(arg0_9)
	local var0_9 = arg0_9:GetLoveLetterItemDic()
	local var1_9 = getProxy(BagProxy):GetAllLoveLetterItem()
	local var2_9 = {}

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var3_9, var4_9 = unpack(iter1_9)
		local var5_9 = underscore.values(var0_9[var3_9 .. "_" .. (var4_9 or 0)])[1]
		local var6_9 = var3_9 .. "_" .. var5_9

		var2_9[var6_9] = defaultValue(var2_9[var6_9], 0) + 1
	end

	local var7_9 = false

	for iter2_9, iter3_9 in ipairs(arg0_9.giftRecord) do
		if not var0_9[iter3_9.item_id .. "_" .. iter3_9.group_id] then
			var7_9 = true

			break
		end

		local var8_9 = underscore.values(var0_9[iter3_9.item_id .. "_" .. iter3_9.group_id])[1]
		local var9_9 = iter3_9.item_id .. "_" .. var8_9

		var2_9[var9_9] = defaultValue(var2_9[var9_9], 0) - 1
	end

	if var7_9 and #var1_9 > 0 then
		return var1_9
	end

	for iter4_9, iter5_9 in pairs(var2_9) do
		if iter5_9 > 0 then
			return var1_9
		end
	end

	return nil
end

function var0_0.UpdateRealizeGift(arg0_10, arg1_10)
	local var0_10, var1_10 = arg0_10:GetLoveLetterItemDic()
	local var2_10 = {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		local var3_10 = underscore.values(var0_10[iter1_10.item_id .. "_" .. iter1_10.group_id])[1]

		var2_10[var3_10] = var2_10[var3_10] or {}

		table.insert(var2_10[var3_10], iter1_10)
	end

	local var4_10 = {}

	for iter2_10, iter3_10 in ipairs(arg0_10.giftRecord) do
		local var5_10
		local var6_10

		if not var0_10[iter3_10.item_id .. "_" .. iter3_10.group_id] then
			var5_10 = nil
			var6_10 = pg.lover_character_template[iter3_10.group_id] and iter3_10.group_id or underscore.detect(pg.lover_character_template.all, function(arg0_11)
				return underscore.any(pg.lover_character_template[arg0_11].relate_group_id, function(arg0_12)
					return iter3_10.group_id == arg0_12
				end)
			end)
		else
			var6_10 = underscore.values(var0_10[iter3_10.item_id .. "_" .. iter3_10.group_id])[1]

			for iter4_10, iter5_10 in ipairs(var2_10[var6_10] or {}) do
				if iter5_10.item_id == iter3_10.item_id and iter5_10.year == iter3_10.year then
					var5_10 = iter4_10

					break
				end
			end
		end

		if var5_10 then
			table.remove(var2_10[var6_10], var5_10)
		else
			var4_10[var6_10] = var4_10[var6_10] or {}

			table.insert(var4_10[var6_10], iter3_10)
		end
	end

	for iter6_10, iter7_10 in pairs(var4_10) do
		local var7_10 = arg0_10:GetGroupData(iter6_10)

		arg0_10.levelAll = arg0_10.levelAll - #iter7_10

		var7_10:AddGiftExp(-#iter7_10)

		for iter8_10, iter9_10 in ipairs(iter7_10) do
			local var8_10 = var1_10[iter6_10 .. "_" .. iter9_10.year]

			var7_10.unlockLetterDic[var8_10] = var7_10.unlockLetterDic[var8_10] - 1
		end
	end

	for iter10_10, iter11_10 in pairs(var2_10) do
		local var9_10 = arg0_10:GetGroupData(iter10_10)

		arg0_10.levelAll = arg0_10.levelAll + #iter11_10

		var9_10:AddGiftExp(#iter11_10)

		for iter12_10, iter13_10 in ipairs(iter11_10) do
			local var10_10 = var1_10[iter10_10 .. "_" .. iter13_10.year]

			var9_10.unlockLetterDic[var10_10] = defaultValue(var9_10.unlockLetterDic[var10_10], 0) + 1
		end
	end

	arg0_10.giftRecord = arg1_10
	arg0_10.giftTip = false

	arg0_10:sendNotification(LoveLetterProxy.UPDATE_LOVE_LETTER)
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

	return underscore.map(var0_14, function(arg0_15)
		return ShipGroup.New({
			id = arg0_15
		})
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
	local var1_33, var2_33 = arg0_33:GetLoveLetterItemDic()

	for iter0_33, iter1_33 in ipairs(arg0_33.giftRecord) do
		if not var1_33[iter1_33.item_id .. "_" .. iter1_33.group_id] then
			-- block empty
		elseif underscore.values(var1_33[iter1_33.item_id .. "_" .. iter1_33.group_id])[1] == arg1_33 then
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
