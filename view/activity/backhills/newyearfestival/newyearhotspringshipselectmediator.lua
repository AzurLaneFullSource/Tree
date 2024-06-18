local var0_0 = class("NewYearHotSpringShipSelectMediator", import("view.base.ContextMediator"))

var0_0.EXTEND = "NewYearHotSpringShipSelectMediator:EXTEND"
var0_0.OPEN_CHUANWU = "NewYearHotSpringShipSelectMediator:OPEN_CHUANWU"
var0_0.LOOG_PRESS_SHIP = "NewYearHotSpringShipSelectMediator:LOOG_PRESS_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EXTEND, function(arg0_2)
		arg0_1:sendNotification(NewYearHotSpringMediator.UNLOCK_SLOT, arg0_1.contextData.actId)
	end)
	arg0_1:bind(var0_0.LOOG_PRESS_SHIP, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg2_3.id
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(NewYearHotSpringMediator.OPEN_CHUANWU, {
			arg1_4,
			arg2_4
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.EXTEND_BACKYARD_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.EXTEND_BACKYARD_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoMediator_ok_unlock"))
		arg0_6.viewComponent:UpdateSlots()
	elseif var0_6 == ActivityProxy.ACTIVITY_UPDATED and var1_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
		arg0_6.viewComponent:SetActivity(var1_6)
		arg0_6.viewComponent:UpdateSlots()
	end
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
