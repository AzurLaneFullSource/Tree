local var0_0 = class("Dorm3dChatMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_CARE = "Dorm3dChatMediator:CHANGE_CARE"
var0_0.REPLY = "Dorm3dChatMediator:REPLY"
var0_0.GET_REDPACKET = "Dorm3dChatMediator:GET_REDPACKET"
var0_0.SET_CURRENT_TOPIC = "Dorm3dChatMediator:SET_CURRENT_TOPIC"
var0_0.SET_CURRENT_BACKGROUND = "Dorm3dChatMediator:SET_CURRENT_BACKGROUND"
var0_0.SET_READED = "Dorm3dChatMediator:SET_READED"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_CARE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_CARE,
			characterId = arg1_2,
			care = arg2_2
		})
	end)
	arg0_1:bind(var0_0.REPLY, function(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			isRedPacket = false,
			operation = Dorm3dChatProxy.APARTMENT_CHAT_REPLY,
			characterId = arg1_3,
			topicId = arg2_3,
			wordId = arg3_3,
			replyId = arg4_3
		})
	end)
	arg0_1:bind(var0_0.GET_REDPACKET, function(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			isRedPacket = true,
			operation = Dorm3dChatProxy.APARTMENT_CHAT_REPLY,
			characterId = arg1_4,
			topicId = arg2_4,
			wordId = arg3_4,
			replyId = arg4_4
		})
	end)
	arg0_1:bind(var0_0.SET_CURRENT_TOPIC, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_TOPIC,
			characterId = arg1_5,
			topicId = arg2_5
		})
	end)
	arg0_1:bind(var0_0.SET_CURRENT_BACKGROUND, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_SKIN,
			characterId = arg1_6,
			skinId = arg2_6
		})
	end)
	arg0_1:bind(var0_0.SET_READED, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP, {
			operation = Dorm3dChatProxy.APARTMENT_CHAT_SET_READTIP,
			characterId = arg1_7,
			topicIdList = arg2_7
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.APARTMENT_CHAT_OP_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.APARTMENT_CHAT_OP_DONE then
		local var2_9 = getProxy(Dorm3dChatProxy)
		local var3_9 = false
		local var4_9 = false

		if var1_9.operation == var2_9.APARTMENT_CHAT_REPLY then
			if var1_9.awards ~= nil then
				arg0_9.viewComponent:SetEndAniEvent(arg0_9.viewComponent.redPacketGot, function()
					arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards)
				end)
				arg0_9.viewComponent:UpdateRedPacketUI(var1_9.redPacketId)
			end

			var3_9 = true
		elseif var1_9.operation == var2_9.APARTMENT_CHAT_SET_SKIN then
			-- block empty
		elseif var1_9.operation == var2_9.APARTMENT_CHAT_SET_CARE then
			-- block empty
		elseif var1_9.operation == var2_9.APARTMENT_CHAT_SET_TOPIC then
			-- block empty
		elseif var1_9.operation == var2_9.APARTMENT_CHAT_SET_READTIP then
			var4_9 = true
		end

		if var1_9.operation == var2_9.APARTMENT_CHAT_REPLY then
			if var1_9.awards ~= nil then
				arg0_9.viewComponent:ChangeFresh()
			else
				arg0_9.viewComponent:SetEndAniEvent(arg0_9.viewComponent.optionPanel, function()
					arg0_9.viewComponent:UpdateChat(var3_9, var4_9)
				end)
				arg0_9.viewComponent.optionPanel:GetComponent(typeof(Animation)):Play("anim_newinstagram_option_out")
			end
		else
			arg0_9.viewComponent:UpdateChat(var3_9, var4_9)
		end
	end
end

return var0_0
