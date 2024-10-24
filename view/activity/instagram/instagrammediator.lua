local var0_0 = class("InstagramMediator", import("...base.ContextMediator"))

var0_0.ON_LIKE = "InstagramMediator:ON_LIKE"
var0_0.ON_SHARE = "InstagramMediator:ON_SHARE"
var0_0.ON_COMMENT = "InstagramMediator:ON_COMMENT"
var0_0.ON_REPLY_UPDATE = "InstagramMediator:ON_REPLY_UPDATE"
var0_0.ON_READED = "InstagramMediator:ON_READED"
var0_0.ON_COMMENT_LIST_UPDATE = "InstagramMediator:ON_COMMENT_LIST_UPDATE"
var0_0.ON_REFRESH_TIP = "InstagramMediator:ON_REFRESH_TIP"
var0_0.CLOSE_ALL = "InstagramMediator:CLOSE_ALL"
var0_0.CLOSE_DETAIL = "InstagramMediator:CLOSE_DETAIL"
var0_0.BACK_PRESSED = "InstagramMediator:BACK_PRESSED"

function var0_0.register(arg0_1)
	getProxy(InstagramProxy):InitLocalConfigs()
	arg0_1:bind(var0_0.ON_READED, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_MARK_READ,
			arg1 = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_LIKE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_LIKE,
			arg1 = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_SHARE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_SHARE,
			arg1 = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_COMMENT, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			cmd = ActivityConst.INSTAGRAM_OP_COMMENT,
			arg1 = arg1_5,
			arg2 = arg3_5,
			arg3 = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_REPLY_UPDATE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_UPDATE,
			arg1 = arg1_6,
			callback = function()
				arg0_1.viewComponent:UpdateCommentList()
			end
		})
	end)
	arg0_1:bind(var0_0.ON_COMMENT_LIST_UPDATE, function(arg0_8, arg1_8, arg2_8)
		arg0_1.viewComponent:UpdateInstagram(arg2_8, false)

		if arg0_1.contextData.instagram then
			arg0_1.viewComponent:emit(var0_0.ON_REPLY_UPDATE, arg1_8, arg2_8)
		end
	end)
	arg0_1.viewComponent:SetProxy(getProxy(InstagramProxy))
	arg0_1:bind(var0_0.CLOSE_ALL, function(arg0_9)
		arg0_1:sendNotification(InstagramMainMediator.CLOSE_ALL)
	end)
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		GAME.ACT_INSTAGRAM_OP_DONE,
		var0_0.CLOSE_DETAIL,
		var0_0.BACK_PRESSED
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	local function var2_11()
		arg0_11.viewComponent:SetProxy(getProxy(InstagramProxy))
		arg0_11.viewComponent:UpdateInstagram(var1_11.id)
		arg0_11.viewComponent:UpdateSelectedInstagram(var1_11.id)
		arg0_11:sendNotification(InstagramMainMediator.CHANGE_JUUS_TIP)
	end

	if var0_11 == GAME.ACT_INSTAGRAM_OP_DONE then
		arg0_11.viewComponent:SetProxy(getProxy(InstagramProxy))

		if var1_11.cmd == ActivityConst.INSTAGRAM_OP_SHARE then
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeInstagram)
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_LIKE then
			var2_11()
			arg0_11.viewComponent:UpdateLikeBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_click_like_success"))
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_COMMENT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_push_comment_success"))
			var2_11()
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_ACTIVE or var1_11.cmd == ActivityConst.INSTAGRAM_OP_UPDATE then
			arg0_11.viewComponent:InitList()
			var2_11()
		elseif var1_11.cmd == ActivityConst.INSTAGRAM_OP_MARK_READ then
			var2_11()
		end
	elseif var0_11 == var0_0.CLOSE_DETAIL then
		arg0_11.viewComponent:CloseDetail()
	elseif var0_11 == var0_0.BACK_PRESSED then
		arg0_11.viewComponent:onBackPressed()
	end
end

return var0_0
