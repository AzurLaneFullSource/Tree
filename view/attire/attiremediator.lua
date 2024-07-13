local var0_0 = class("AttireMediator", import("..base.ContextMediator"))

var0_0.ON_APPLY = "AttireMediator:ON_APPLY"
var0_0.ON_UNLOCK = "AttireMediator:ON_UNLOCK"
var0_0.ON_CHANGE_MEDAL_DISPLAY = "AttireMediator:ON_CHANGE_MEDAL_DISPLAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_APPLY, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ATTIRE_APPLY, {
			id = arg2_2,
			type = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.GET_ATTIRE, {
			id = arg2_3,
			type = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_MEDAL_DISPLAY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_MEDAL_DISPLAY, {
			medalList = arg1_4
		})
	end)

	local var0_1 = getProxy(AttireProxy)

	arg0_1.viewComponent:setAttires(var0_1:getDataAndTrophys(true))
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.updateCurrPage(arg0_5)
	local var0_5 = getProxy(AttireProxy)

	arg0_5.viewComponent:setAttires(var0_5:getDataAndTrophys())
	arg0_5.viewComponent:updateCurrPage()
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		AttireProxy.ATTIREFRAME_EXPIRED,
		GAME.ATTIRE_APPLY_DONE,
		PlayerProxy.UPDATED,
		GAME.GET_ATTIRE_DONE,
		GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == AttireProxy.ATTIREFRAME_EXPIRED then
		if arg0_7.viewComponent.page == AttireScene.PAGE_ICONFRAME or arg0_7.viewComponent.page == AttireScene.PAGE_CHATFRAME then
			arg0_7:updateCurrPage()
		end
	elseif var0_7 == GAME.ATTIRE_APPLY_DONE then
		arg0_7:updateCurrPage()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dress_up_success"))
	elseif var0_7 == PlayerProxy.UPDATED or var0_7 == GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE then
		arg0_7.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
		arg0_7:updateCurrPage()
	elseif var0_7 == GAME.GET_ATTIRE_DONE then
		arg0_7:updateCurrPage()
	end
end

return var0_0
