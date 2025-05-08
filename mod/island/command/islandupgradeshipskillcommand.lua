local var0_0 = class("IslandUpgradeShipSkillCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var0_1)

	if not var1_1 then
		return
	end

	local var2_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_1 = var1_1:GetUpgradeSkillConsume()

	if _.any(var3_1, function(arg0_2)
		local var0_2 = Drop.New({
			type = arg0_2[1],
			id = arg0_2[2],
			count = arg0_2[3]
		})

		return var0_2:getOwnedCount() < var0_2.count
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("资源不足"))

		return
	end

	if not var1_1:CanUpgradeMainSkill() then
		return
	end

	local var4_1 = var1_1:GetMainSkill()

	pg.ConnectionMgr.GetInstance():Send(21028, {
		shipid = var0_1,
		skilltid = var4_1
	}, 21029, function(arg0_3)
		if arg0_3.ret == 0 then
			for iter0_3, iter1_3 in pairs(var3_1) do
				local var0_3 = Drop.New({
					type = iter1_3[1],
					id = iter1_3[2],
					count = iter1_3[3]
				})

				arg0_1:sendNotification(GAME.CONSUME_ITEM, var0_3)
			end

			var1_1:UpgradeMainSkill()
			arg0_1:sendNotification(GAME.ISLAND_UPGRADE_SKILL_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n1("升级成功"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.ret] .. arg0_3.ret)
		end
	end)
end

return var0_0
