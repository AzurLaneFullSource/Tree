local var0 = class("ShipAddIntimacyAndMoneyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(DormProxy):getBackYardShips()
	local var2 = {}

	for iter0, iter1 in pairs(var1) do
		if iter1.state_info_3 > 0 or iter1.state_info_4 > 0 then
			table.insert(var2, iter0)
		end
	end

	if #var2 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = 0
	}, 19012, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = {}
			local var2 = {}
			local var3 = 0

			for iter0, iter1 in ipairs(var2) do
				local var4 = var0:RawGetShipById(iter1)

				if var4.state_info_3 > 0 then
					table.insert(var1, var4)
				end

				if var4.state_info_4 > 0 then
					var3 = var3 + var4.state_info_4

					table.insert(var2, var4)
				end

				getProxy(DormProxy):clearInimacyAndMoney(iter1)
			end

			arg0:ShowIntimacyTip(var1)
			arg0:ShowMoneyTip(var2, var3)
			arg0:sendNotification(GAME.BACKYARD_ONE_KEY_DONE, {
				shipIds = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

function var0.ShowIntimacyTip(arg0, arg1)
	if #arg1 == 0 then
		return
	end

	if #arg1 == 1 then
		local var0 = arg1[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var0:getName()))

		return
	end

	if #arg1 > 1 then
		table.sort(arg1, function(arg0, arg1)
			return arg0.groupId < arg1.groupId
		end)

		local var1 = _.first(arg1, 2)
		local var2 = _.map(var1, function(arg0)
			return arg0:getName()
		end)
		local var3 = table.concat(var2, "、")

		if #arg1 == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var3))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ships_ok", var3))
		end

		return
	end
end

function var0.ShowMoneyTip(arg0, arg1, arg2)
	if #arg1 == 0 then
		return
	end

	if #arg1 == 1 then
		local var0 = arg1[1]

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ok", var0:getName(), arg2))

		return
	end

	if #arg1 > 1 then
		table.sort(arg1, function(arg0, arg1)
			return arg0.groupId < arg1.groupId
		end)

		local var1 = _.first(arg1, 2)
		local var2 = _.map(var1, function(arg0)
			return arg0:getName()
		end)
		local var3 = table.concat(var2, "、")

		if #arg1 == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ok", var3, arg2))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ships_ok", var3, arg2))
		end
	end
end

return var0
