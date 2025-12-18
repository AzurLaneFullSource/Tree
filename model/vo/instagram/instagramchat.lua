local var0_0 = class("InstagramChat", import("..BaseVO"))
local var1_0 = pg.activity_ins_ship_group_template
local var2_0 = pg.activity_ins_chat_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.characterId = arg1_1.id
	arg0_1.skinId = arg1_1.skin_id
	arg0_1.care = arg1_1.favorite
	arg0_1.currentTopicId = arg1_1.cur_chat_group

	arg0_1:SetTopics(arg1_1.chat_group_list)

	arg0_1.currentTopic = arg0_1:GetTopic(arg0_1.currentTopicId)
	arg0_1.characterConfig = var1_0[arg0_1.characterId]
	arg0_1.name = arg0_1.characterConfig.name
	arg0_1.sculpture = arg0_1.characterConfig.sculpture
	arg0_1.sculptureII = arg0_1.characterConfig.sculpture_ii
	arg0_1.type = arg0_1.characterConfig.type
	arg0_1.nationality = arg0_1.characterConfig.nationality
	arg0_1.groupBackground = arg0_1.characterConfig.background
	arg0_1.skins = {}

	if arg0_1.type == 1 then
		arg0_1:SetBackgrounds()
	end
end

function var0_0.SetTopics(arg0_2, arg1_2)
	arg0_2.topics = {}
	arg0_2.allTopicIds = var2_0.get_id_list_by_ship_group[arg0_2.characterId]

	for iter0_2, iter1_2 in ipairs(arg0_2.allTopicIds) do
		local var0_2

		for iter2_2, iter3_2 in ipairs(arg1_2) do
			if iter3_2.id == iter1_2 then
				var0_2 = iter3_2
			end
		end

		local var1_2 = InstagramTopic.New(var2_0[iter1_2], var0_2)

		table.insert(arg0_2.topics, var1_2)
	end
end

function var0_0.GetTopic(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.topics) do
		if iter1_3.topicId == arg1_3 then
			return iter1_3
		end
	end

	return nil
end

function var0_0.SetCurrentTopic(arg0_4, arg1_4)
	arg0_4.currentTopicId = arg1_4
	arg0_4.currentTopic = arg0_4:GetTopic(arg1_4)
end

function var0_0.GetDisplayWord(arg0_5)
	return arg0_5.currentTopic:GetLatestCharacterWord()
end

function var0_0.GetCharacterEndFlag(arg0_6)
	local var0_6 = 1

	for iter0_6, iter1_6 in ipairs(arg0_6.topics) do
		if iter1_6.active and not iter1_6:IsCompleted() then
			var0_6 = 0

			break
		end
	end

	return var0_6
end

function var0_0.GetCharacterEndFlagExceptCurrent(arg0_7)
	local var0_7 = 1

	for iter0_7, iter1_7 in ipairs(arg0_7.topics) do
		if iter1_7.topicId ~= arg0_7.currentTopicId and iter1_7.active and not iter1_7:IsCompleted() then
			var0_7 = 0

			break
		end
	end

	return var0_7
end

function var0_0.GetLatestOperationTime(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.topics) do
		if iter1_8.active and var0_8 < iter1_8.operationTime then
			var0_8 = iter1_8.operationTime
		end
	end

	return var0_8
end

function var0_0.SetCare(arg0_9, arg1_9)
	arg0_9.care = arg1_9
end

function var0_0.SortTopicList(arg0_10)
	table.sort(arg0_10.topics, function(arg0_11, arg1_11)
		local var0_11 = arg0_11.isII and 1 or 0
		local var1_11 = arg1_11.isII and 1 or 0

		if var0_11 ~= var1_11 then
			return var0_11 < var1_11
		end

		local var2_11 = arg0_11.active and 1 or 0
		local var3_11 = arg1_11.active and 1 or 0

		if var2_11 ~= var3_11 then
			return var3_11 < var2_11
		end

		return arg0_11.topicId > arg1_11.topicId
	end)
end

function var0_0.SetBackgrounds(arg0_12)
	arg0_12.skins = ShipGroup.GetDisplayableSkinList(arg0_12.characterId)

	local var0_12 = getProxy(ShipSkinProxy):GetShareSkinsForShipGroupInJuus(arg0_12.characterId)

	for iter0_12, iter1_12 in ipairs(var0_12) do
		table.insert(arg0_12.skins, pg.ship_skin_template[iter1_12.id])
	end

	local var1_12 = getProxy(CollectionProxy):getGroups()

	for iter2_12 = #arg0_12.skins, 1, -1 do
		local var2_12 = arg0_12.skins[iter2_12]
		local var3_12 = var1_12[var2_12.ship_group]

		if var2_12.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and (not var3_12 or var3_12.married == 0) then
			table.remove(arg0_12.skins, iter2_12)
		end

		if var2_12.skin_type == ShipSkin.SKIN_TYPE_REMAKE and (not var3_12 or not var3_12.trans) then
			table.remove(arg0_12.skins, iter2_12)
		end

		if var2_12.skin_type == ShipSkin.SKIN_TYPE_DEFAULT and not var3_12 then
			table.remove(arg0_12.skins, iter2_12)
		end
	end
end

function var0_0.GetSkins(arg0_13)
	arg0_13:SetBackgrounds()

	return arg0_13.skins
end

function var0_0.GetPainting(arg0_14)
	local var0_14 = 0

	if arg0_14.currentTopic.isII then
		var0_14 = ShipGroup.getDefaultShipConfig(arg0_14.currentTopic.topicConfig.group_ii).skin_id
	else
		var0_14 = ShipGroup.getDefaultShipConfig(arg0_14.characterId).skin_id
	end

	local var1_14 = pg.ship_skin_template[var0_14]

	assert(var1_14, "ship_skin_template not exist: " .. var0_14)

	return var1_14.painting
end

function var0_0.GetPaintingId(arg0_15)
	local var0_15 = 0

	if arg0_15.currentTopic.isII then
		var0_15 = ShipGroup.getDefaultShipConfig(arg0_15.currentTopic.topicConfig.group_ii).skin_id
	else
		var0_15 = ShipGroup.getDefaultShipConfig(arg0_15.characterId).skin_id
	end

	return var0_15
end

return var0_0
