local var0_0 = class("InstagramChatProxy", import(".NetProxy"))
local var1_0 = pg.activity_ins_chat_group

function var0_0.register(arg0_1)
	arg0_1.chatList = {}
end

function var0_0.SetChatList(arg0_2, arg1_2)
	arg0_2.chatList = arg1_2

	arg0_2:SortChatList()

	arg0_2.notActiveTopicIds = arg0_2:GetNotActiveTopicIds()
end

function var0_0.GetChatList(arg0_3)
	return arg0_3.chatList
end

function var0_0.SortChatList(arg0_4)
	table.sort(arg0_4.chatList, function(arg0_5, arg1_5)
		if arg0_5.care ~= arg1_5.care then
			return arg0_5.care > arg1_5.care
		end

		local var0_5 = arg0_5:GetCharacterEndFlag()
		local var1_5 = arg1_5:GetCharacterEndFlag()

		if var0_5 ~= var1_5 then
			return var0_5 < var1_5
		end

		if arg0_5:GetLatestOperationTime() ~= arg1_5:GetLatestOperationTime() then
			return arg0_5:GetLatestOperationTime() > arg1_5:GetLatestOperationTime()
		end

		return arg0_5.characterId < arg1_5.characterId
	end)
end

function var0_0.GetCharacterChatById(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.chatList) do
		if iter1_6.characterId == arg1_6 then
			return iter1_6
		end
	end

	return nil
end

function var0_0.GetTopicById(arg0_7, arg1_7)
	local var0_7 = var1_0[arg1_7].ship_group

	for iter0_7, iter1_7 in ipairs(arg0_7.chatList) do
		if iter1_7.characterId == var0_7 then
			for iter2_7, iter3_7 in ipairs(iter1_7.topics) do
				if iter3_7.topicId == arg1_7 then
					return iter3_7
				end
			end
		end
	end

	return nil
end

function var0_0.GetCharacterChatByTopicId(arg0_8, arg1_8)
	local var0_8 = var1_0[arg1_8].ship_group

	return arg0_8:GetCharacterChatById(var0_8)
end

function var0_0.CreateNewChat(arg0_9, arg1_9, arg2_9)
	local var0_9 = var1_0[arg1_9].ship_group
	local var1_9 = {
		favorite = 0,
		skin_id = 0,
		id = var0_9,
		cur_chat_group = arg1_9,
		chat_group_list = {
			{
				read_flag = 0,
				id = arg1_9,
				op_time = arg2_9,
				reply_list = {}
			}
		}
	}
	local var2_9 = InstagramChat.New(var1_9)

	table.insert(arg0_9.chatList, var2_9)
end

function var0_0.SetTopicOperationTime(arg0_10, arg1_10, arg2_10)
	arg0_10:GetTopicById(arg1_10).operationTime = arg2_10
end

function var0_0.ActivateTopics(arg0_11, arg1_11)
	arg0_11:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
		operation = ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC,
		topicIdList = arg1_11
	})
end

function var0_0.SetCurrentTopic(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetTopicById(arg1_12)

	if var0_12 then
		local var1_12 = arg0_12:GetCharacterChatById(var0_12.characterId)

		if var1_12 then
			var1_12:SetCurrentTopic(arg1_12)
		end
	end
end

function var0_0.UpdateTopicDisplayWordList(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13:GetTopicById(arg1_13)

	if var0_13 then
		table.insert(var0_13.replyList, {
			key = arg2_13,
			value = arg3_13
		})
		var0_13:SetDisplayWordList()
	end
end

function var0_0.GetAllTopicIds(arg0_14)
	return Clone(var1_0.all)
end

function var0_0.GetNotActiveTopicIds(arg0_15)
	local var0_15 = arg0_15:GetAllTopicIds()

	for iter0_15, iter1_15 in ipairs(arg0_15.chatList) do
		for iter2_15, iter3_15 in ipairs(iter1_15.topics) do
			if iter3_15.active then
				for iter4_15 = #var0_15, 1, -1 do
					if var0_15[iter4_15] == iter3_15.topicId then
						table.remove(var0_15, iter4_15)
					end
				end
			end
		end
	end

	return var0_15
end

function var0_0.RemoveNotActiveTopicId(arg0_16, arg1_16)
	for iter0_16 = #arg0_16.notActiveTopicIds, 1, -1 do
		if arg0_16.notActiveTopicIds[iter0_16] == arg1_16 then
			table.remove(arg0_16.notActiveTopicIds, iter0_16)
		end
	end
end

function var0_0.GetNotActiveTopicIdsByType(arg0_17, arg1_17)
	local var0_17 = Clone(arg0_17.notActiveTopicIds)

	if var0_17 and #var0_17 > 0 then
		for iter0_17 = #var0_17, 1, -1 do
			if var1_0[var0_17[iter0_17]].trigger_type ~= arg1_17 then
				table.remove(var0_17, iter0_17)
			end
		end
	end

	return var0_17
end

function var0_0.SetChatSkin(arg0_18, arg1_18, arg2_18)
	arg0_18:GetCharacterChatById(arg1_18).skinId = arg2_18
end

function var0_0.UpdateAllChatBackGrounds(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.chatList) do
		if iter1_19.type == 1 then
			iter1_19:SetBackgrounds()
		end
	end
end

function var0_0.SetTopicReaded(arg0_20, arg1_20, arg2_20)
	arg0_20:GetTopicById(arg1_20).readFlag = arg2_20
end

function var0_0.SetAllTopicsReaded(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.chatList) do
		for iter2_21, iter3_21 in ipairs(iter1_21.topics) do
			if iter3_21.readFlag == 0 then
				iter3_21.readFlag = 1
			end
		end
	end
end

function var0_0.ShouldShowTip(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.chatList) do
		if iter1_22:GetCharacterEndFlag() == 0 then
			return true
		end
	end

	return false
end

return var0_0
