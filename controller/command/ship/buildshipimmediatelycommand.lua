local var0_0 = class("BuildShipImmediatelyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type or 1
	local var2_1 = var0_1.pos_list
	local var3_1 = getProxy(BuildShipProxy)
	local var4_1 = underscore.filter(var2_1, function(arg0_2)
		return var3_1:getBuildShip(arg0_2).state ~= BuildShip.FINISH
	end)

	if #var4_1 == 0 then
		existCall(var0_1.callback)

		return
	end

	local var5_1 = getProxy(BagProxy)
	local var6_1 = var5_1:getItemCountById(ITEM_ID_EQUIP_QUICK_FINISH)

	if var6_1 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	else
		var4_1 = underscore.slice(var4_1, 1, var6_1)
	end

	pg.ConnectionMgr.GetInstance():Send(12008, {
		type = var1_1,
		pos_list = var4_1
	}, 12009, function(arg0_3)
		local var0_3 = {}

		for iter0_3, iter1_3 in ipairs(arg0_3.pos_list) do
			var5_1:removeItemById(ITEM_ID_EQUIP_QUICK_FINISH, 1)
			var3_1:getBuildShip(iter1_3):finish()
			var3_1:finishBuildShip(iter1_3)
		end

		if arg0_3.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_speedUp") .. i18n("word_succeed"))
			arg0_1:sendNotification(GAME.BUILD_SHIP_IMMEDIATELY_DONE)
			existCall(var0_1.callback)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShipImmediately", arg0_3.result))
		end
	end)
end

return var0_0
