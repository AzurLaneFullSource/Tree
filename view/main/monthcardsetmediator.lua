local var0_0 = class("MonthCardSetMediator", import("..base.ContextMediator"))

var0_0.ON_SET_RATIO = "MonthCardSetMediator:ON_SET_RATIO"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1:bind(var0_0.ON_SET_RATIO, function(arg0_2, arg1_2)
		if var0_1:getCardById(VipCard.MONTH).data ~= arg1_2 then
			arg0_1:sendNotification(GAME.MONTH_CARD_SET_RATIO, arg1_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("month_card_set_ratio_not_change"))
		end
	end)
	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = var0_1:getCardById(VipCard.MONTH)

	arg0_1.viewComponent:setRatio(var1_1.data)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
