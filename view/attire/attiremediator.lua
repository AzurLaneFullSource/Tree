local var0 = class("AttireMediator", import("..base.ContextMediator"))

var0.ON_APPLY = "AttireMediator:ON_APPLY"
var0.ON_UNLOCK = "AttireMediator:ON_UNLOCK"
var0.ON_CHANGE_MEDAL_DISPLAY = "AttireMediator:ON_CHANGE_MEDAL_DISPLAY"

function var0.register(arg0)
	arg0:bind(var0.ON_APPLY, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ATTIRE_APPLY, {
			id = arg2,
			type = arg1
		})
	end)
	arg0:bind(var0.ON_UNLOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GET_ATTIRE, {
			id = arg2,
			type = arg1
		})
	end)
	arg0:bind(var0.ON_CHANGE_MEDAL_DISPLAY, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_PLAYER_MEDAL_DISPLAY, {
			medalList = arg1
		})
	end)

	local var0 = getProxy(AttireProxy)

	arg0.viewComponent:setAttires(var0:getDataAndTrophys(true))
	arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0.updateCurrPage(arg0)
	local var0 = getProxy(AttireProxy)

	arg0.viewComponent:setAttires(var0:getDataAndTrophys())
	arg0.viewComponent:updateCurrPage()
end

function var0.listNotificationInterests(arg0)
	return {
		AttireProxy.ATTIREFRAME_EXPIRED,
		GAME.ATTIRE_APPLY_DONE,
		PlayerProxy.UPDATED,
		GAME.GET_ATTIRE_DONE,
		GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == AttireProxy.ATTIREFRAME_EXPIRED then
		if arg0.viewComponent.page == AttireScene.PAGE_ICONFRAME or arg0.viewComponent.page == AttireScene.PAGE_CHATFRAME then
			arg0:updateCurrPage()
		end
	elseif var0 == GAME.ATTIRE_APPLY_DONE then
		arg0:updateCurrPage()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dress_up_success"))
	elseif var0 == PlayerProxy.UPDATED or var0 == GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE then
		arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
		arg0:updateCurrPage()
	elseif var0 == GAME.GET_ATTIRE_DONE then
		arg0:updateCurrPage()
	end
end

return var0
