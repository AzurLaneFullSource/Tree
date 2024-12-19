local var0_0 = class("SellItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.items
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(BagProxy)

	for iter0_1, iter1_1 in pairs(var1_1) do
		if var3_1:getItemCountById(iter1_1.id) < iter1_1.count then
			local var4_1 = var3_1:RawGetItemById(iter1_1.id)

			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var4_1:getConfig("name")))

			if var2_1 then
				var2_1(false)
			end

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(15008, {
		item_list = var1_1
	}, 15009, function(arg0_2)
		if arg0_2.result == 0 then
			for iter0_2, iter1_2 in pairs(var1_1) do
				reducePlayerOwn(Drop.Create({
					DROP_TYPE_ITEM,
					iter1_2.id,
					iter1_2.count
				}))
			end

			local var0_2 = {}
			local var1_2 = var3_1:GetSellingPrice(var1_1)

			for iter2_2, iter3_2 in pairs(var1_2) do
				local var2_2 = Drop.Create(iter3_2)

				if var2_2.count > 0 then
					addPlayerOwn(var2_2)
					table.insert(var0_2, var2_2)
				end
			end

			arg0_1:sendNotification(GAME.SELL_ITEM_DONE, {
				awards = var0_2
			})

			if var2_1 then
				var2_1(var0_2)
			end
		else
			if var2_1 then
				var2_1(nil)
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
