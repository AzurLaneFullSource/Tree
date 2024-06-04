local var0 = class("BuildShipImmediatelyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type or 1
	local var2 = var0.pos_list
	local var3 = getProxy(BuildShipProxy)
	local var4 = underscore.filter(var2, function(arg0)
		return var3:getBuildShip(arg0).state ~= BuildShip.FINISH
	end)

	if #var4 == 0 then
		existCall(var0.callback)

		return
	end

	local var5 = getProxy(BagProxy)
	local var6 = var5:getItemCountById(ITEM_ID_EQUIP_QUICK_FINISH)

	if var6 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	else
		var4 = underscore.slice(var4, 1, var6)
	end

	pg.ConnectionMgr.GetInstance():Send(12008, {
		type = var1,
		pos_list = var4
	}, 12009, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.pos_list) do
			var5:removeItemById(ITEM_ID_EQUIP_QUICK_FINISH, 1)
			var3:getBuildShip(iter1):finish()
			var3:finishBuildShip(iter1)
		end

		if arg0.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_speedUp") .. i18n("word_succeed"))
			arg0:sendNotification(GAME.BUILD_SHIP_IMMEDIATELY_DONE)
			existCall(var0.callback)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShipImmediately", arg0.result))
		end
	end)
end

return var0
