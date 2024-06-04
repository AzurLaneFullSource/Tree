local var0 = class("MonthCardSetMediator", import("..base.ContextMediator"))

var0.ON_SET_RATIO = "MonthCardSetMediator:ON_SET_RATIO"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0:bind(var0.ON_SET_RATIO, function(arg0, arg1)
		if var0:getCardById(VipCard.MONTH).data ~= arg1 then
			arg0:sendNotification(GAME.MONTH_CARD_SET_RATIO, arg1)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("month_card_set_ratio_not_change"))
		end
	end)
	arg0.viewComponent:setPlayer(var0)

	local var1 = var0:getCardById(VipCard.MONTH)

	arg0.viewComponent:setRatio(var1.data)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
