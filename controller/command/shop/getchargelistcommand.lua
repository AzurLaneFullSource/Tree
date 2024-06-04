local var0 = class("GetChargeListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(16104, {
		type = 0
	}, 16105, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.pay_list) do
			local var1 = Goods.Create(iter1, Goods.TYPE_CHARGE)

			var0[var1.id] = var1
		end

		local var2 = {}

		for iter2, iter3 in ipairs(arg0.first_pay_list) do
			table.insert(var2, iter3)
		end

		local var3 = {}

		for iter4, iter5 in ipairs(arg0.normal_list) do
			local var4 = Goods.Create(iter5, Goods.TYPE_GIFT_PACKAGE)

			var3[var4.id] = var4

			table.insert(var3, iter5)
		end

		local var5 = {}

		for iter6, iter7 in ipairs(arg0.normal_group_list) do
			table.insert(var5, iter7)
		end

		local var6 = getProxy(ShopsProxy)

		var6:setChargedList(var0)
		var6:setFirstChargeList(var2)
		var6:setNormalList(var3)
		var6:setNormalGroupList(var5)

		var6.refreshChargeList = false

		arg0:sendNotification(GAME.GET_CHARGE_LIST_DONE, {
			chargedList = var0,
			firstChargeIds = var2,
			normalList = var3,
			normalGroupList = var5
		})

		if var0 and var0.callback then
			var0.callback()
		end
	end)
end

return var0
