local var0 = class("InstagramMediator", import("...base.ContextMediator"))

var0.ON_LIKE = "InstagramMediator:ON_LIKE"
var0.ON_SHARE = "InstagramMediator:ON_SHARE"
var0.ON_COMMENT = "InstagramMediator:ON_COMMENT"
var0.ON_REPLY_UPDATE = "InstagramMediator:ON_REPLY_UPDATE"
var0.ON_READED = "InstagramMediator:ON_READED"
var0.ON_COMMENT_LIST_UPDATE = "InstagramMediator:ON_COMMENT_LIST_UPDATE"

function var0.register(arg0)
	getProxy(InstagramProxy):InitLocalConfigs()
	arg0:bind(var0.ON_READED, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_MARK_READ,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.ON_LIKE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_LIKE,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.ON_SHARE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_SHARE,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.ON_COMMENT, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			cmd = ActivityConst.INSTAGRAM_OP_COMMENT,
			arg1 = arg1,
			arg2 = arg3,
			arg3 = arg2
		})
	end)
	arg0:bind(var0.ON_REPLY_UPDATE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			arg2 = 0,
			cmd = ActivityConst.INSTAGRAM_OP_UPDATE,
			arg1 = arg1,
			callback = function()
				arg0.viewComponent:UpdateCommentList()
			end
		})
	end)
	arg0:bind(var0.ON_COMMENT_LIST_UPDATE, function(arg0, arg1, arg2)
		arg0.viewComponent:UpdateInstagram(arg2, false)

		if arg0.contextData.instagram then
			arg0.viewComponent:emit(var0.ON_REPLY_UPDATE, arg1, arg2)
		end
	end)
	arg0.viewComponent:SetProxy(getProxy(InstagramProxy))
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ACT_INSTAGRAM_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	local function var2()
		arg0.viewComponent:SetProxy(getProxy(InstagramProxy))
		arg0.viewComponent:UpdateInstagram(var1.id)
		arg0.viewComponent:UpdateSelectedInstagram(var1.id)
	end

	if var0 == GAME.ACT_INSTAGRAM_OP_DONE then
		arg0.viewComponent:SetProxy(getProxy(InstagramProxy))

		if var1.cmd == ActivityConst.INSTAGRAM_OP_SHARE then
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeInstagram)
		elseif var1.cmd == ActivityConst.INSTAGRAM_OP_LIKE then
			var2()
			arg0.viewComponent:UpdateLikeBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_click_like_success"))
		elseif var1.cmd == ActivityConst.INSTAGRAM_OP_COMMENT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ins_push_comment_success"))
			var2()
		elseif var1.cmd == ActivityConst.INSTAGRAM_OP_ACTIVE or var1.cmd == ActivityConst.INSTAGRAM_OP_UPDATE then
			arg0.viewComponent:InitList()
			var2()
		elseif var1.cmd == ActivityConst.INSTAGRAM_OP_MARK_READ then
			var2()
		end
	end
end

return var0
