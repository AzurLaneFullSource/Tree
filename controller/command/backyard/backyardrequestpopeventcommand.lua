local var0_0 = class("BackYardRequestPopEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19009, {
		type = 0
	}, 19010, function(arg0_2)
		local var0_2 = getProxy(DormProxy):getRawData()

		for iter0_2, iter1_2 in ipairs(arg0_2.pop_list) do
			local var1_2 = iter1_2.id
			local var2_2 = iter1_2.intimacy
			local var3_2 = iter1_2.dorm_icon

			var0_2:AddInimacyAndMoney(var1_2, var2_2, var3_2)
			getProxy(DormProxy):updateDrom(var0_2, BackYardConst.DORM_UPDATE_TYPE_SHIP)
			arg0_1:sendNotification(DormProxy.INIMACY_AND_MONEY_ADD, {
				id = var1_2,
				intimacy = var2_2,
				money = var3_2
			})
		end
	end)
end

return var0_0
