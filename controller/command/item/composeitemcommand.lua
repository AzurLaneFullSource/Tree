local var0 = class("ComposeItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = getProxy(BagProxy)
	local var4 = var3:getItemById(var1)

	if var2 == 0 then
		return
	end

	local var5 = var4:getConfig("target_id")
	local var6 = var4:getConfig("compose_number")

	if var2 > var4.count / var6 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15006, {
		id = var1,
		num = var2
	}, 15007, function(arg0)
		if arg0.result == 0 then
			var3:removeItemById(var1, var2 * var6)

			local var0 = Drop.New({
				type = DROP_TYPE_ITEM,
				id = var5,
				count = var2
			})

			arg0:sendNotification(GAME.ADD_ITEM, var0)
			arg0:sendNotification(GAME.USE_ITEM_DONE, {
				var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
