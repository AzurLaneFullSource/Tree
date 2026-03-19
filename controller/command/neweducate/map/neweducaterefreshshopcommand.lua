local var0_0 = class("NewEducateRefreshShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	if getProxy(NewEducateProxy):GetCurChar():GetFSM():CheckPriorityStystem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

		return
	end

	local var1_1 = getProxy(NewEducateProxy):GetCurChar()
	local var2_1 = var1_1:GetResByType(NewEducateChar.RES_TYPE.REFRESH_SHOP)
	local var3_1 = var1_1:GetResByType(NewEducateChar.RES_TYPE.MONEY)
	local var4_1 = pg.gameset.child2_shop_refresh_price.key_value

	if var2_1 <= 0 and var3_1 < var4_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(29072, {
		id = var0_1
	}, 29073, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1 > 0 and var1_1:GetResIdByType(NewEducateChar.RES_TYPE.REFRESH_SHOP) or var1_1:GetResIdByType(NewEducateChar.RES_TYPE.MONEY)
			local var1_2 = var2_1 > 0 and 1 or var4_1

			getProxy(NewEducateProxy):Cost({
				type = NewEducateConst.DROP_TYPE.RES,
				id = var0_2,
				number = var1_2
			})
			getProxy(NewEducateProxy):GetCurChar():GetFSM():GetState(NewEducateFSM.SYSTEM.MAP):OnRefreshShopDone(arg0_2.shops, var2_1 <= 0)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_SHOP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_RefreshShop_Error: " .. arg0_2.result)
		end
	end)
end

return var0_0
