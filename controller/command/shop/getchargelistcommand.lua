local var0_0 = class("GetChargeListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(16104, {
		type = 0
	}, 16105, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.pay_list) do
			local var1_2 = Goods.Create(iter1_2, Goods.TYPE_CHARGE)

			var0_2[var1_2.id] = var1_2
		end

		local var2_2 = {}

		for iter2_2, iter3_2 in ipairs(arg0_2.first_pay_list) do
			table.insert(var2_2, iter3_2)
		end

		local var3_2 = {}

		for iter4_2, iter5_2 in ipairs(arg0_2.normal_list) do
			local var4_2 = Goods.Create(iter5_2, Goods.TYPE_GIFT_PACKAGE)

			var3_2[var4_2.id] = var4_2

			table.insert(var3_2, iter5_2)
		end

		local var5_2 = {}

		for iter6_2, iter7_2 in ipairs(arg0_2.normal_group_list) do
			table.insert(var5_2, iter7_2)
		end

		local var6_2 = getProxy(ShopsProxy)

		var6_2:setChargedList(var0_2)
		var6_2:setFirstChargeList(var2_2)
		var6_2:setNormalList(var3_2)
		var6_2:setNormalGroupList(var5_2)

		var6_2.refreshChargeList = false

		getProxy(ApartmentProxy):InitGiftDaily()
		arg0_1:sendNotification(GAME.GET_CHARGE_LIST_DONE, {
			chargedList = var0_2,
			firstChargeIds = var2_2,
			normalList = var3_2,
			normalGroupList = var5_2
		})

		if var0_1 and var0_1.callback then
			var0_1.callback()
		end
	end)
end

return var0_0
