local var0_0 = class("MetaQuickTacticsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipID
	local var2_1 = var0_1.skillID
	local var3_1 = var0_1.useCountDict
	local var4_1 = ""
	local var5_1 = {
		ship_id = var1_1,
		skill_id = var2_1,
		books = {}
	}

	for iter0_1, iter1_1 in pairs(var3_1) do
		local var6_1 = {
			id = iter0_1,
			num = iter1_1
		}

		table.insert(var5_1.books, var6_1)

		var4_1 = var4_1 .. iter0_1 .. "-" .. iter1_1 .. ","
	end

	print("63319 send qucik tactics data", var1_1, var2_1, var4_1)
	pg.ConnectionMgr.GetInstance():Send(63319, var5_1, 63320, function(arg0_2)
		print("63320 qucik tactics done:", arg0_2.ret)

		if arg0_2.ret == 0 then
			print("after quick", arg0_2.level, arg0_2.exp)

			local var0_2 = getProxy(BayProxy)
			local var1_2 = getProxy(BagProxy)
			local var2_2 = getProxy(MetaCharacterProxy)
			local var3_2 = var0_2:getShipById(var1_1)
			local var4_2 = var3_2:getMetaSkillLevelBySkillID(var2_1) < arg0_2.level

			var3_2:updateSkill({
				skill_id = var2_1,
				skill_lv = arg0_2.level,
				skill_exp = arg0_2.exp
			})
			var0_2:updateShip(var3_2)
			var2_2:getMetaTacticsInfoByShipID(var1_1):setNewExp(var2_1, arg0_2.exp)

			for iter0_2, iter1_2 in pairs(var3_1) do
				if iter1_2 > 0 then
					var1_2:removeItemById(iter0_2, iter1_2)
				end
			end

			arg0_1:sendNotification(GAME.META_QUICK_TACTICS_DONE, {
				skillID = var2_1,
				skillLevel = arg0_2.level,
				skillExp = arg0_2.exp,
				isLevelUp = var4_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.ret))
		end
	end)
end

return var0_0
