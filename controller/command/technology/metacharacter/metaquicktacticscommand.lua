local var0 = class("MetaQuickTacticsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipID
	local var2 = var0.skillID
	local var3 = var0.useCountDict
	local var4 = ""
	local var5 = {
		ship_id = var1,
		skill_id = var2,
		books = {}
	}

	for iter0, iter1 in pairs(var3) do
		local var6 = {
			id = iter0,
			num = iter1
		}

		table.insert(var5.books, var6)

		var4 = var4 .. iter0 .. "-" .. iter1 .. ","
	end

	print("63319 send qucik tactics data", var1, var2, var4)
	pg.ConnectionMgr.GetInstance():Send(63319, var5, 63320, function(arg0)
		print("63320 qucik tactics done:", arg0.ret)

		if arg0.ret == 0 then
			print("after quick", arg0.level, arg0.exp)

			local var0 = getProxy(BayProxy)
			local var1 = getProxy(BagProxy)
			local var2 = getProxy(MetaCharacterProxy)
			local var3 = var0:getShipById(var1)
			local var4 = var3:getMetaSkillLevelBySkillID(var2) < arg0.level

			var3:updateSkill({
				skill_id = var2,
				skill_lv = arg0.level,
				skill_exp = arg0.exp
			})
			var0:updateShip(var3)
			var2:getMetaTacticsInfoByShipID(var1):setNewExp(var2, arg0.exp)

			for iter0, iter1 in pairs(var3) do
				if iter1 > 0 then
					var1:removeItemById(iter0, iter1)
				end
			end

			arg0:sendNotification(GAME.META_QUICK_TACTICS_DONE, {
				skillID = var2,
				skillLevel = arg0.level,
				skillExp = arg0.exp,
				isLevelUp = var4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.ret))
		end
	end)
end

return var0
