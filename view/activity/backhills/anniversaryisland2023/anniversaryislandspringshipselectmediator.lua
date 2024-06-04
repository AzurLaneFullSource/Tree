local var0 = class("AnniversaryIslandSpringShipSelectMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringShipSelectMediator"))

function var0.register(arg0)
	arg0:bind(var0.LOOG_PRESS_SHIP, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg2.id
		})
	end)
	arg0:bind(var0.OPEN_CHUANWU, function(arg0, arg1, arg2)
		arg0:sendNotification(AnniversaryIslandHotSpringMediator.OPEN_CHUANWU, {
			arg1,
			arg2
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)

	arg0.viewComponent:SetActivity(var0)
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EXTEND_BACKYARD_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoMediator_ok_unlock"))
		arg0.viewComponent:UpdateSlots()
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
		arg0.viewComponent:SetActivity(var1)
		arg0.viewComponent:UpdateSlots()
	end
end

return var0
