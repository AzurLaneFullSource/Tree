local var0_0 = class("Dorm3dChatProxy", import(".NetProxy"))
local var1_0 = pg.dorm3d_ins_chat_group

var0_0.APARTMENT_CHAT_REPLY = 1
var0_0.APARTMENT_CHAT_SET_SKIN = 2
var0_0.APARTMENT_CHAT_SET_CARE = 3
var0_0.APARTMENT_CHAT_SET_TOPIC = 4
var0_0.APARTMENT_CHAT_SET_READTIP = 5
var0_0.APARTMENT_CHAT_TRIGGER_EVENT = 6

function var0_0.register(arg0_1)
	arg0_1.chatList = {}
end

function var0_0.HandleAct(arg0_2, arg1_2)
	if arg0_2:GetCharacterChatByTopicId(arg1_2.act_id) then
		local var0_2 = arg0_2:GetTopicById(arg1_2.act_id)

		if var0_2 then
			var0_2:Activate(arg1_2.time)
		end
	else
		arg0_2:CreateNewChat(arg1_2.act_id, arg1_2.time)
	end
end

function var0_0.CreateChat(arg0_3, arg1_3)
	local var0_3 = Dorm3dChat.New(arg1_3)

	table.insert(arg0_3.chatList, var0_3)
end

function var0_0.SetChatList(arg0_4, arg1_4)
	arg0_4.chatList = arg1_4
end

function var0_0.GetChatList(arg0_5)
	return arg0_5.chatList
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
		cur_back = 0,
		care_flag = 0,
		ship_group = var0_9,
		cur_comm_id = arg1_9,
		comm_list = {
			{
				read_flag = 0,
				id = arg1_9,
				time = arg2_9,
				reply_list = {}
			}
		}
	}
	local var2_9 = Dorm3dChat.New(var1_9)

	table.insert(arg0_9.chatList, var2_9)
end

function var0_0.SetTopicOperationTime(arg0_10, arg1_10, arg2_10)
	arg0_10:GetTopicById(arg1_10).operationTime = arg2_10
end

function var0_0.SetCurrentTopic(arg0_11, arg1_11)
	local var0_11 = arg0_11:GetTopicById(arg1_11)

	if var0_11 then
		local var1_11 = arg0_11:GetCharacterChatById(var0_11.characterId)

		if var1_11 then
			var1_11:SetCurrentTopic(arg1_11)
		end
	end
end

function var0_0.UpdateTopicDisplayWordList(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12:GetTopicById(arg1_12)

	if var0_12 then
		table.insert(var0_12.replyList, {
			key = arg2_12,
			value = arg3_12
		})
		var0_12:SetDisplayWordList()
	end
end

function var0_0.GetAllTopicIds(arg0_13)
	return Clone(var1_0.all)
end

function var0_0.SetChatSkin(arg0_14, arg1_14, arg2_14)
	arg0_14:GetCharacterChatById(arg1_14).skinId = arg2_14
end

function var0_0.UpdateAllChatBackGrounds(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.chatList) do
		if iter1_15.type == 1 then
			iter1_15:SetBackgrounds()
		end
	end
end

function var0_0.SetTopicReaded(arg0_16, arg1_16, arg2_16)
	arg0_16:GetTopicById(arg1_16).readFlag = arg2_16
end

function var0_0.ShouldShowTip(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.chatList) do
		if iter1_17:GetCharacterEndFlag() == 0 and getProxy(Dorm3dInsProxy):GetRoomByGroupId(iter1_17.characterId):IsDownloaded() then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowShipTip(arg0_18, arg1_18)
	local var0_18 = arg0_18:GetCharacterChatById(arg1_18)

	if var0_18 and var0_18:GetCharacterEndFlag() == 0 then
		return true
	else
		return false
	end
end

function var0_0.TriggerEvent(arg0_19, arg1_19)
	if DORM_LOCK_INS then
		return
	end

	arg0_19:sendNotification(GAME.APARTMENT_CHAT_OP, {
		operation = Dorm3dChatProxy.APARTMENT_CHAT_TRIGGER_EVENT,
		eventList = arg1_19
	})
end

function var0_0.GetChatCare(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetCharacterChatById(arg1_20)

	if var0_20 then
		return var0_20.care
	end

	return 0
end

function var0_0.SetChatCare(arg0_21, arg1_21, arg2_21)
	arg0_21:sendNotification(GAME.APARTMENT_CHAT_OP, {
		operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_CARE,
		characterId = arg1_21,
		care = arg2_21
	})
end

function var0_0.AutoChangeCurrentTopic(arg0_22, arg1_22)
	if arg1_22 and (not arg1_22.currentTopic or arg1_22.currentTopic:IsCompleted()) then
		local var0_22 = arg1_22:GetTopicsSortByActivateTime()

		for iter0_22, iter1_22 in ipairs(var0_22) do
			if iter1_22.active and not iter1_22:IsCompleted() then
				arg0_22:sendNotification(GAME.APARTMENT_CHAT_OP, {
					operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_TOPIC,
					characterId = arg1_22.characterId,
					topicId = iter1_22.topicId
				})

				break
			end
		end
	end
end

return var0_0
