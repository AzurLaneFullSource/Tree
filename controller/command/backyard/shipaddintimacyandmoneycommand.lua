local var0_0 = class("ShipAddIntimacyAndMoneyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy):getBackYardShips()
	local var2_1 = {}

	for iter0_1, iter1_1 in pairs(var1_1) do
		if iter1_1.state_info_3 > 0 or iter1_1.state_info_4 > 0 then
			table.insert(var2_1, iter0_1)
		end
	end

	if #var2_1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = 0
	}, 19012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = {}
			local var2_2 = {}
			local var3_2 = 0

			for iter0_2, iter1_2 in ipairs(var2_1) do
				local var4_2 = var0_2:RawGetShipById(iter1_2)

				if var4_2.state_info_3 > 0 then
					table.insert(var1_2, var4_2)
				end

				if var4_2.state_info_4 > 0 then
					var3_2 = var3_2 + var4_2.state_info_4

					table.insert(var2_2, var4_2)
				end

				getProxy(DormProxy):clearInimacyAndMoney(iter1_2)
			end

			arg0_1:ShowIntimacyTip(var1_2)
			arg0_1:ShowMoneyTip(var2_2, var3_2)
			arg0_1:sendNotification(GAME.BACKYARD_ONE_KEY_DONE, {
				shipIds = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.ShowIntimacyTip(arg0_3, arg1_3)
	if #arg1_3 == 0 then
		return
	end

	if #arg1_3 == 1 then
		local var0_3 = arg1_3[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var0_3:getName()))

		return
	end

	if #arg1_3 > 1 then
		table.sort(arg1_3, function(arg0_4, arg1_4)
			return arg0_4.groupId < arg1_4.groupId
		end)

		local var1_3 = _.first(arg1_3, 2)
		local var2_3 = _.map(var1_3, function(arg0_5)
			return arg0_5:getName()
		end)
		local var3_3 = table.concat(var2_3, "、")

		if #arg1_3 == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var3_3))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ships_ok", var3_3))
		end

		return
	end
end

function var0_0.ShowMoneyTip(arg0_6, arg1_6, arg2_6)
	if #arg1_6 == 0 then
		return
	end

	if #arg1_6 == 1 then
		local var0_6 = arg1_6[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ok", var0_6:getName(), arg2_6))

		return
	end

	if #arg1_6 > 1 then
		table.sort(arg1_6, function(arg0_7, arg1_7)
			return arg0_7.groupId < arg1_7.groupId
		end)

		local var1_6 = _.first(arg1_6, 2)
		local var2_6 = _.map(var1_6, function(arg0_8)
			return arg0_8:getName()
		end)
		local var3_6 = table.concat(var2_6, "、")

		if #arg1_6 == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ok", var3_6, arg2_6))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ships_ok", var3_6, arg2_6))
		end
	end
end

return var0_0
