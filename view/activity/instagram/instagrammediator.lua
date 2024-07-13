local var0_0 = class("InstagramMediator", import("...base.ContextMediator"))

var0_0.ON_LIKE = "InstagramMediator:ON_LIKE"
var0_0.ON_SHARE = "InstagramMediator:ON_SHARE"
var0_0.ON_COMMENT = "InstagramMediator:ON_COMMENT"
var0_0.ON_REPLY_UPDATE = "InstagramMediator:ON_REPLY_UPDATE"
var0_0.ON_READED = "InstagramMediator:ON_READED"
var0_0.ON_COMMENT_LIST_UPDATE = "InstagramMediator:ON_COMMENT_LIST_UPDATE"

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
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.ACT_INSTAGRAM_OP_DONE
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	local function var2_10()
		arg0_10.viewComponent:SetProxy(getProxy(InstagramProxy))
		arg0_10.viewComponent:UpdateInstagram(var1_10.id)
		arg0_10.viewComponent:UpdateSelectedInstagram(var1_10.id)
	end

	if var0_10 == GAME.ACT_INSTAGRAM_OP_DONE then
		arg0_10.viewComponent:SetProxy(getProxy(InstagramProxy))

		if var1_10.cmd == ActivityConst.INSTAGRAM_OP_SHARE then
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeInstagram)
		elseif var1_10.cmd == ActivityConst.INSTAGRAM_OP_LIKE then
			var2_10()
			arg0_10.viewComponent:UpdateLikeBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_click_like_success"))
		elseif var1_10.cmd == ActivityConst.INSTAGRAM_OP_COMMENT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_push_comment_success"))
			var2_10()
		elseif var1_10.cmd == ActivityConst.INSTAGRAM_OP_ACTIVE or var1_10.cmd == ActivityConst.INSTAGRAM_OP_UPDATE then
			arg0_10.viewComponent:InitList()
			var2_10()
		elseif var1_10.cmd == ActivityConst.INSTAGRAM_OP_MARK_READ then
			var2_10()
		end
	end
end

return var0_0
