local var0_0 = class("ComposeItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = getProxy(BagProxy)
	local var4_1 = var3_1:getItemById(var1_1)

	if var2_1 == 0 then
		return
	end

	local var5_1 = var4_1:getConfig("target_id")
	local var6_1 = var4_1:getConfig("compose_number")

	if var2_1 > var4_1.count / var6_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(15006, {
		id = var1_1,
		num = var2_1
	}, 15007, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:removeItemById(var1_1, var2_1 * var6_1)

			local var0_2 = Drop.New({
				type = DROP_TYPE_ITEM,
				id = var5_1,
				count = var2_1
			})

			arg0_1:sendNotification(GAME.ADD_ITEM, var0_2)
			arg0_1:sendNotification(GAME.USE_ITEM_DONE, {
				var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
