local var0_0 = class("InstagramChatMediator", import("...base.ContextMediator"))

var0_0.CHANGE_CARE = "InstagramChatMediator:CHANGE_CARE"
var0_0.REPLY = "InstagramChatMediator:REPLY"
var0_0.GET_REDPACKET = "InstagramChatMediator:GET_REDPACKET"
var0_0.SET_CURRENT_TOPIC = "InstagramChatMediator:SET_CURRENT_TOPIC"
var0_0.SET_CURRENT_BACKGROUND = "InstagramChatMediator:SET_CURRENT_BACKGROUND"
var0_0.SET_READED = "InstagramChatMediator:SET_READED"
var0_0.CLOSE_ALL = "InstagramChatMediator:CLOSE_ALL"
var0_0.ON_OFFICIAL_ACCOUNTS_OPERATE = "InstagramChatMediator:ON_OFFICIAL_ACCOUNTS_OPERATE"
var0_0.BACK_PRESSED = "InstagramChatMediator:BACK_PRESSED"

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
	arg0_1:bind(var0_0.ON_OFFICIAL_ACCOUNTS_OPERATE, function(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			cmd = arg1_9 or 0,
			arg1 = arg2_9 or 0,
			arg2 = arg3_9 or 0,
			arg3 = arg4_9 or 0
		})
	end)
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		GAME.ACT_INSTAGRAM_CHAT_DONE,
		GAME.ACT_INSTAGRAM_OP_DONE,
		var0_0.BACK_PRESSED
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GAME.ACT_INSTAGRAM_CHAT_DONE then
		local var2_11 = getProxy(InstagramChatProxy)
		local var3_11 = false
		local var4_11 = false

		if var1_11.operation == ActivityConst.INSTAGRAM_CHAT_REPLY then
			if var1_11.awards ~= nil then
				arg0_11.viewComponent:SetEndAniEvent(arg0_11.viewComponent.redPacketGot, function()
					arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards)
				end)
				arg0_11.viewComponent:UpdateRedPacketUI(var1_11.redPacketId)
			end

			var3_11 = true
		elseif var1_11.operation == ActivityConst.INSTAGRAM_CHAT_SET_SKIN then
			-- block empty
		elseif var1_11.operation == ActivityConst.INSTAGRAM_CHAT_SET_CARE then
			-- block empty
		elseif var1_11.operation == ActivityConst.INSTAGRAM_CHAT_SET_TOPIC then
			-- block empty
		elseif var1_11.operation == ActivityConst.INSTAGRAM_CHAT_SET_READTIP then
			arg0_11:sendNotification(InstagramMainMediator.CHANGE_CHAT_TIP)

			var4_11 = true
		end

		if var1_11.operation == ActivityConst.INSTAGRAM_CHAT_REPLY then
			if var1_11.awards ~= nil then
				arg0_11.viewComponent:ChangeFresh()
			else
				arg0_11.viewComponent:SetEndAniEvent(arg0_11.viewComponent.optionPanel, function()
					arg0_11.viewComponent:UpdateCharaList(var3_11, var4_11)
				end)
				arg0_11.viewComponent.optionPanel:GetComponent(typeof(Animation)):Play("anim_newinstagram_option_out")
			end
		else
			arg0_11.viewComponent:UpdateCharaList(var3_11, var4_11)
		end
	elseif var0_11 == GAME.ACT_INSTAGRAM_OP_DONE then
		if var1_11.cmd == ActivityConst.INSTAGRAM_OP_SHARE then
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeInstagram)
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_LIKE then
			arg0_11.viewComponent:UpdateLinkBtn(var1_11.id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_click_like_success"))
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_COMMENT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_push_comment_success"))
			arg0_11.viewComponent:UpdateCommentList(var1_11.id)
			arg0_11.viewComponent:AddOfficialAccountsTimer()
			arg0_11.viewComponent:ReadOfficialAccountComment()
			arg0_11.viewComponent:RefreshOfficialAccountTips()
			arg0_11:sendNotification(InstagramMainMediator.CHANGE_CHAT_TIP)
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_ACTIVE or var1_11.cmd == ActivityConst.INSTAGRAM_OP_UPDATE then
			arg0_11.viewComponent:UpdateCommentList(var1_11.id)
			arg0_11.viewComponent:AddOfficialAccountsTimer()
			arg0_11.viewComponent:ReadOfficialAccountComment()
			arg0_11.viewComponent:RefreshOfficialAccountTips()
			arg0_11:sendNotification(InstagramMainMediator.CHANGE_CHAT_TIP)
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_MARK_READ then
			arg0_11.viewComponent:RefreshOfficialAccountTips()
			arg0_11:sendNotification(InstagramMainMediator.CHANGE_CHAT_TIP)
		end
	elseif var0_11 == var0_0.BACK_PRESSED then
		arg0_11.viewComponent:onBackPressed()
	end
end

return var0_0
