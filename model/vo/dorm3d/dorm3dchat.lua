local var0_0 = class("Dorm3dChat", import("..BaseVO"))
local var1_0 = pg.dorm3d_ins_ship_group_template
local var2_0 = pg.dorm3d_ins_chat_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.characterId = arg1_1.ship_group
	arg0_1.skinId = arg1_1.cur_back
	arg0_1.care = arg1_1.care_flag
	arg0_1.currentTopicId = arg1_1.cur_comm_id

	arg0_1:SetTopics(arg1_1.comm_list)

	arg0_1.currentTopic = arg0_1:GetTopic(arg0_1.currentTopicId)
	arg0_1.characterConfig = var1_0[arg0_1.characterId]
	arg0_1.name = arg0_1.characterConfig.name
	arg0_1.sculpture = arg0_1.characterConfig.sculpture
	arg0_1.groupBackground = arg0_1.characterConfig.background
	arg0_1.type = arg0_1.characterConfig.type
	arg0_1.skins = {}

	if arg0_1.type == 1 then
		arg0_1:SetBackgrounds()
	end
end

function var0_0.SetTopics(arg0_2, arg1_2)
	arg0_2.topics = {}
	arg0_2.allTopicIds = var2_0.get_id_list_by_ship_group[arg0_2.characterId]

	for iter0_2, iter1_2 in ipairs(arg0_2.allTopicIds or {}) do
		if var2_0[iter1_2].type == "1" then
			local var0_2

			for iter2_2, iter3_2 in ipairs(arg1_2) do
				if iter3_2.id == iter1_2 then
					var0_2 = iter3_2
				end
			end

			local var1_2 = Dorm3dTopic.New(var2_0[iter1_2], var0_2)

			table.insert(arg0_2.topics, var1_2)
		end
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

function var0_0.GetCharacterEndFlag(arg0_5)
	local var0_5 = 1

	for iter0_5, iter1_5 in ipairs(arg0_5.topics) do
		if iter1_5.active and not iter1_5:IsCompleted() then
			var0_5 = 0

			break
		end
	end

	return var0_5
end

function var0_0.GetCharacterEndFlagExceptCurrent(arg0_6)
	local var0_6 = 1

	for iter0_6, iter1_6 in ipairs(arg0_6.topics) do
		if iter1_6.topicId ~= arg0_6.currentTopicId and iter1_6.active and not iter1_6:IsCompleted() then
			var0_6 = 0

			break
		end
	end

	return var0_6
end

function var0_0.GetLatestOperationTime(arg0_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7.topics) do
		if iter1_7.active and var0_7 < iter1_7.operationTime then
			var0_7 = iter1_7.operationTime
		end
	end

	return var0_7
end

function var0_0.SetCare(arg0_8, arg1_8)
	arg0_8.care = arg1_8
end

function var0_0.SortTopicList(arg0_9)
	table.sort(arg0_9.topics, function(arg0_10, arg1_10)
		local var0_10 = arg0_10.active and 1 or 0
		local var1_10 = arg1_10.active and 1 or 0

		if var0_10 ~= var1_10 then
			return var1_10 < var0_10
		end

		return arg0_10.topicId > arg1_10.topicId
	end)
end

function var0_0.SetBackgrounds(arg0_11)
	arg0_11.skins = arg0_11:getDisplayableSkinList()

	local var0_11 = getProxy(CollectionProxy):getGroups()[arg0_11.characterId]

	for iter0_11 = #arg0_11.skins, 1, -1 do
		local var1_11 = arg0_11.skins[iter0_11]

		if var1_11.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and (not var0_11 or var0_11 and var0_11.married == 0) then
			table.remove(arg0_11.skins, iter0_11)
		end

		if var1_11.skin_type == ShipSkin.SKIN_TYPE_REMAKE and (not var0_11 or var0_11 and not var0_11.trans) then
			table.remove(arg0_11.skins, iter0_11)
		end
	end
end

function var0_0.GetSkins(arg0_12)
	arg0_12:SetBackgrounds()

	return arg0_12.skins
end

function var0_0.GetPainting(arg0_13)
	local var0_13 = ShipGroup.getDefaultShipConfig(arg0_13.characterId).skin_id
	local var1_13 = pg.ship_skin_template[var0_13]

	assert(var1_13, "ship_skin_template not exist: " .. var0_13)

	return var1_13.painting
end

function var0_0.GetPaintingId(arg0_14)
	return ShipGroup.getDefaultShipConfig(arg0_14.characterId).skin_id
end

function var0_0.getDisplayableSkinList(arg0_15)
	local var0_15 = {}

	local function var1_15(arg0_16)
		return arg0_16.skin_type == ShipSkin.SKIN_TYPE_OLD or arg0_16.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not getProxy(ShipSkinProxy):hasSkin(arg0_16.id)
	end

	local function var2_15(arg0_17)
		return getProxy(ShipSkinProxy):InShowTime(arg0_17)
	end

	for iter0_15, iter1_15 in ipairs(pg.ship_skin_template.all) do
		local var3_15 = pg.ship_skin_template[iter1_15]

		if var3_15.ship_group == arg0_15.characterId and var3_15.no_showing ~= "1" and not var1_15(var3_15) and var2_15(var3_15.id) then
			table.insert(var0_15, var3_15)
		end
	end

	return var0_15
end

function var0_0.GetTopicsSortByActivateTime(arg0_18)
	local var0_18 = Clone(arg0_18.topics)

	table.sort(var0_18, function(arg0_19, arg1_19)
		local var0_19 = arg0_19.active and 1 or 0
		local var1_19 = arg1_19.active and 1 or 0

		if var0_19 ~= var1_19 then
			return var1_19 < var0_19
		end

		local var2_19 = arg0_19.operationTime
		local var3_19 = arg1_19.operationTime

		if var2_19 ~= var3_19 then
			return var3_19 < var2_19
		end

		return arg0_19.topicId > arg1_19.topicId
	end)

	return var0_18
end

return var0_0
