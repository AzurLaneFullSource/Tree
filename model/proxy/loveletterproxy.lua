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
		if iter5_9 ~= 0 then
			assert(#var1_9 >= #arg0_9.giftRecord)

			return var1_9
		else
			return nil
		end
	end
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
		local var6_10 = underscore.values(var0_10[iter3_10.item_id .. "_" .. iter3_10.group_id])[1]

		for iter4_10, iter5_10 in ipairs(var2_10[var6_10] or {}) do
			if iter5_10.item_id == iter3_10.item_id and iter5_10.year == iter3_10.year then
				var5_10 = iter4_10

				break
			end
		end

		if var5_10 then
			table.remove(var2_10[var6_10], var5_10)
		else
			var4_10[var6_10] = var4_10[var6_10] or {}

			table.insert(var4_10[var6_10], iter3_10)
		end
	end

	for iter6_10, iter7_10 in pairs(var2_10) do
		assert(#iter7_10 >= #(var4_10[iter6_10] or {}))

		local var7_10 = arg0_10:GetGroupData(iter6_10)

		arg0_10.levelAll = arg0_10.levelAll - var7_10:GetDisplayLevel()

		var7_10:AddGiftExp(#iter7_10 - #(var4_10[iter6_10] or {}))

		arg0_10.levelAll = arg0_10.levelAll + var7_10:GetDisplayLevel()

		for iter8_10, iter9_10 in ipairs(var4_10[iter6_10] or {}) do
			local var8_10 = var1_10[iter6_10 .. "_" .. iter9_10.year]

			var7_10.unlockLetterDic[var8_10] = var7_10.unlockLetterDic[var8_10] - 1
		end

		for iter10_10, iter11_10 in ipairs(iter7_10) do
			local var9_10 = var1_10[underscore.values(var0_10[iter11_10.item_id .. "_" .. iter11_10.group_id])[1] .. "_" .. iter11_10.year]

			var7_10.unlockLetterDic[var9_10] = defaultValue(var7_10.unlockLetterDic[var9_10], 0) + 1
		end
	end

	arg0_10.giftRecord = arg1_10
	arg0_10.giftTip = false

	arg0_10:sendNotification(LoveLetterProxy.UPDATE_LOVE_LETTER)
end

function var0_0.AddLoveLetterExp(arg0_11, arg1_11, arg2_11)
	arg2_11 = arg0_11:GetGroupData(arg1_11):AddExp(arg2_11)

	return arg2_11
end

function var0_0.GetDisplayGroupList(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.data) do
		if iter1_12.exp ~= 0 then
			table.insert(var0_12, iter1_12.groupId)
		end
	end

	table.sort(var0_12)

	local var1_12 = getProxy(CollectionProxy):RawgetGroups()

	return underscore.map(var0_12, function(arg0_13)
		return var1_12[arg0_13]
	end)
end

function var0_0.GetAllLevel(arg0_14)
	return arg0_14.levelAll
end

function var0_0.GetAllLevelNextAwardIndex(arg0_15)
	for iter0_15, iter1_15 in ipairs(pg.lover_reward.all) do
		if not arg0_15.rewardMarkDic[iter1_15] then
			return iter0_15
		end
	end

	return nil
end

function var0_0.GetAllLevelAwardDisplayIndex(arg0_16)
	local var0_16

	for iter0_16, iter1_16 in ipairs(pg.lover_reward.all) do
		var0_16 = iter0_16

		if pg.lover_reward[iter1_16].total_level > arg0_16.levelAll then
			break
		end
	end

	return var0_16
end

function var0_0.GetAllLevelProgress(arg0_17)
	local var0_17 = arg0_17:GetAllLevelNextAwardIndex()

	if not var0_17 then
		return 0, 0
	else
		local var1_17 = pg.lover_reward.all
		local var2_17 = var0_17 > 1 and pg.lover_reward[var1_17[var0_17 - 1]].total_level or 0

		return arg0_17.levelAll - var2_17, pg.lover_reward[var1_17[var0_17]].total_level - var2_17
	end
end

function var0_0.GetAllLevelNextAward(arg0_18)
	local var0_18 = pg.lover_reward.all
	local var1_18 = var0_18[arg0_18:GetAllLevelNextAwardIndex() or #var0_18]

	return underscore.map(pg.lover_reward[var1_18].show_reward, function(arg0_19)
		return Drop.Create(arg0_19)
	end)
end

function var0_0.GetAllLevelRewardMarkDic(arg0_20)
	return arg0_20.rewardMarkDic
end

function var0_0.GetAllLevelReadyReward(arg0_21)
	local var0_21 = {}
	local var1_21 = arg0_21:GetAllLevelRewardMarkDic()

	for iter0_21, iter1_21 in ipairs(pg.lover_reward.all) do
		if pg.lover_reward[iter1_21].total_level > arg0_21.levelAll then
			break
		elseif not var1_21[iter1_21] then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

function var0_0.RecordLoveLetterContent(arg0_22, arg1_22, arg2_22)
	arg0_22.letterTextContent[arg1_22] = HXSet.hxLan(arg2_22)
end

function var0_0.GetLoveLetterContent(arg0_23, arg1_23)
	return arg0_23.letterTextContent[arg1_23]
end

function var0_0.GetDisPlayerGroupDatas(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.data or {}) do
		if iter1_24.exp > 0 then
			table.insert(var0_24, iter1_24)
		end
	end

	return var0_24
end

function var0_0.GetTrophyList(arg0_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in ipairs(arg0_25:GetDisPlayerGroupDatas()) do
		table.insertto(var0_25, iter1_25:GetTrophyList())
	end

	return var0_25
end

function var0_0.GetDisplayLetterList(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.data) do
		if iter1_26.exp > 0 and #iter1_26:GetDisplayLetterList() > 0 then
			table.insert(var0_26, iter0_26)
		end
	end

	table.sort(var0_26, CompareFuncs({
		function(arg0_27)
			return -arg0_26.data[arg0_27].level
		end,
		function(arg0_28)
			return -arg0_26.data[arg0_28].exp
		end,
		function(arg0_29)
			return arg0_29
		end
	}))

	local var1_26 = getProxy(CollectionProxy):RawgetGroups()

	return underscore.map(var0_26, function(arg0_30)
		return var1_26[arg0_30]
	end)
end

function var0_0.GetRecordGiftLetters(arg0_31, arg1_31)
	local var0_31 = {}
	local var1_31, var2_31 = arg0_31:GetLoveLetterItemDic()

	for iter0_31, iter1_31 in ipairs(arg0_31.giftRecord) do
		if not var1_31[iter1_31.item_id .. "_" .. iter1_31.group_id] then
			-- block empty
		elseif underscore.values(var1_31[iter1_31.item_id .. "_" .. iter1_31.group_id])[1] == arg1_31 then
			table.insert(var0_31, var2_31[arg1_31 .. "_" .. iter1_31.year])
		end
	end

	return var0_31
end

function var0_0.IsTipRealizeGift(arg0_32)
	if not arg0_32.data then
		return false
	end

	if arg0_32.giftTip == nil then
		arg0_32.giftTip = arg0_32:CanRealizeGift()
	end

	return arg0_32.giftTip
end

function var0_0.IsTipLevelUp(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.data) do
		if iter1_33:GetDisplayLevel() < iter1_33:GetMaxLevel() and iter1_33:CanLevelUp() then
			return true
		end
	end

	return false
end

function var0_0.IsTipAllLevelReward(arg0_34)
	local var0_34, var1_34 = arg0_34:GetAllLevelProgress()

	return var1_34 > 0 and var1_34 <= var0_34
end

function var0_0.IsTipUnlockLetter(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.data) do
		for iter2_35, iter3_35 in ipairs(pg.lover_letter_content.get_id_list_by_ship_group[iter0_35]) do
			if iter1_35:CanUnlockLetter(iter3_35) and not iter1_35:GetLetterUnlock(iter3_35) then
				return true
			end
		end
	end

	return false
end

function var0_0.GetSystemData(arg0_36, arg1_36)
	if not arg0_36.data then
		arg0_36:sendNotification(GAME.GET_ALL_LOVE_LETTER_DATA, {
			callback = arg1_36
		})
	else
		arg1_36()
	end
end

function var0_0.remove(arg0_37)
	arg0_37.data = nil
end

return var0_0
