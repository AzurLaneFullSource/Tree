local var0_0 = class("ShipAddIntimacyAndMoneyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy)
	local var2_1 = var1_1:getRawData():GetHasMoneyOrIntimacyShips()

	if #var2_1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = 0
	}, 19012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = getProxy(DormProxy):getRawData()
			local var2_2 = {}
			local var3_2 = {}
			local var4_2 = 0

			for iter0_2, iter1_2 in ipairs(var2_1) do
				local var5_2 = iter1_2.id
				local var6_2 = var0_2:RawGetShipById(var5_2)

				if iter1_2:HasIntimacy() then
					table.insert(var2_2, var6_2)
				end

				if iter1_2:HasMoney() then
					var4_2 = var4_2 + iter1_2:GetMoney()

					table.insert(var3_2, var6_2)
				end

				var1_2:HarvestInimacyAndMoney(var5_2)
			end

			var1_1:updateDrom(var1_2, BackYardConst.DORM_UPDATE_TYPE_SHIP)
			arg0_1:ShowIntimacyTip(var2_2)
			arg0_1:ShowMoneyTip(var3_2, var4_2)
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
