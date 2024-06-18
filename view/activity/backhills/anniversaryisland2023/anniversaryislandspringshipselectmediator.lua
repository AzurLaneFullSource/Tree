local var0_0 = class("AnniversaryIslandSpringShipSelectMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringShipSelectMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.LOOG_PRESS_SHIP, function(arg0_2, arg1_2, arg2_2)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg2_2.id
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(AnniversaryIslandHotSpringMediator.OPEN_CHUANWU, {
			arg1_3,
			arg2_3
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.EXTEND_BACKYARD_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoMediator_ok_unlock"))
		arg0_4.viewComponent:UpdateSlots()
	elseif var0_4 == ActivityProxy.ACTIVITY_UPDATED and var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
		arg0_4.viewComponent:SetActivity(var1_4)
		arg0_4.viewComponent:UpdateSlots()
	end
end

return var0_0
