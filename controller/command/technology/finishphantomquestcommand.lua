local var0_0 = class("FinishPhantomQuestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bluePrintId
	local var2_1 = var0_1.questId
	local var3_1 = getProxy(TechnologyProxy):getBluePrintById(var1_1)
	local var4_1 = var3_1:getPhantomQuestInfo(var2_1)

	if var4_1.unlocked or var4_1.progress < var4_1.config.target_num then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12210, {
		ship_id = var3_1.shipId,
		skin_shadow_id = var2_1
	}, 12211, function(arg0_2)
		local var0_2 = ShipBluePrint.getPhantomQuestCostDrop(var4_1)

		if var0_2 then
			reducePlayerOwn(var0_2)
		end

		getProxy(BayProxy):updateShipSkin(var3_1.shipId, var2_1, 0)
		arg0_1:sendNotification(GAME.FINISH_PHANTOM_QUEST_DONE)
	end)
end

return var0_0
