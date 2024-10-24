local var0_0 = class("InstagramChatMediator", import("...base.ContextMediator"))

var0_0.CHANGE_CARE = "InstagramChatMediator:CHANGE_CARE"
var0_0.REPLY = "InstagramChatMediator:REPLY"
var0_0.GET_REDPACKET = "InstagramChatMediator:GET_REDPACKET"
var0_0.SET_CURRENT_TOPIC = "InstagramChatMediator:SET_CURRENT_TOPIC"
var0_0.SET_CURRENT_BACKGROUND = "InstagramChatMediator:SET_CURRENT_BACKGROUND"
var0_0.SET_READED = "InstagramChatMediator:SET_READED"
var0_0.CLOSE_ALL = "InstagramChatMediator:CLOSE_ALL"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_CARE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			operation = ActivityConst.INSTAGRAM_CHAT_SET_CARE,
			characterId = arg1_2,
			care = arg2_2
		})
	end)
	arg0_1:bind(var0_0.REPLY, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			isRedPacket = false,
			operation = ActivityConst.INSTAGRAM_CHAT_REPLY,
			topicId = arg1_3,
			wordId = arg2_3,
			replyId = arg3_3
		})
	end)
	arg0_1:bind(var0_0.GET_REDPACKET, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			isRedPacket = true,
			operation = ActivityConst.INSTAGRAM_CHAT_REPLY,
			topicId = arg1_4,
			wordId = arg2_4,
			replyId = arg3_4
		})
	end)
	arg0_1:bind(var0_0.SET_CURRENT_TOPIC, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			operation = ActivityConst.INSTAGRAM_CHAT_SET_TOPIC,
			topicId = arg1_5
		})
	end)
	arg0_1:bind(var0_0.SET_CURRENT_BACKGROUND, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			operation = ActivityConst.INSTAGRAM_CHAT_SET_SKIN,
			characterId = arg1_6,
			skinId = arg2_6
		})
	end)
	arg0_1:bind(var0_0.SET_READED, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT, {
			operation = ActivityConst.INSTAGRAM_CHAT_SET_READTIP,
			topicIdList = arg1_7
		})
	end)
	arg0_1:bind(var0_0.CLOSE_ALL, function(arg0_8)
		arg0_1:sendNotification(InstagramMainMediator.CLOSE_ALL)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.ACT_INSTAGRAM_CHAT_DONE
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == GAME.ACT_INSTAGRAM_CHAT_DONE then
		local var2_10 = getProxy(InstagramChatProxy)
		local var3_10 = false
		local var4_10 = false

		if var1_10.operation == ActivityConst.INSTAGRAM_CHAT_REPLY then
			if var1_10.awards ~= nil then
				arg0_10.viewComponent:SetEndAniEvent(arg0_10.viewComponent.redPacketGot, function()
					arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_10.awards)
				end)
				arg0_10.viewComponent:UpdateRedPacketUI(var1_10.redPacketId)
			end

			var3_10 = true
		elseif var1_10.operation == ActivityConst.INSTAGRAM_CHAT_SET_SKIN then
			-- block empty
		elseif var1_10.operation == ActivityConst.INSTAGRAM_CHAT_SET_CARE then
			-- block empty
		elseif var1_10.operation == ActivityConst.INSTAGRAM_CHAT_SET_TOPIC then
			-- block empty
		elseif var1_10.operation == ActivityConst.INSTAGRAM_CHAT_SET_READTIP then
			arg0_10:sendNotification(InstagramMainMediator.CHANGE_CHAT_TIP)

			var4_10 = true
		end

		if var1_10.operation == ActivityConst.INSTAGRAM_CHAT_REPLY then
			if var1_10.awards ~= nil then
				arg0_10.viewComponent:ChangeFresh()
			else
				arg0_10.viewComponent:SetEndAniEvent(arg0_10.viewComponent.optionPanel, function()
					arg0_10.viewComponent:UpdateCharaList(var3_10, var4_10)
				end)
				arg0_10.viewComponent.optionPanel:GetComponent(typeof(Animation)):Play("anim_newinstagram_option_out")
			end
		else
			arg0_10.viewComponent:UpdateCharaList(var3_10, var4_10)
		end
	end
end

return var0_0
