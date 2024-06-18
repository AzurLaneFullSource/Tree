local var0_0 = class("ItemUnlockBluePrintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.itemId
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getBluePrintById(var1_1)
	local var5_1 = getProxy(BagProxy)

	if not var4_1 or not var5_1:getItemCountById(var2_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63214, {
		group = var1_1,
		itemid = var2_1
	}, 63215, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Ship.New(arg0_2.ship)

			getProxy(BayProxy):addShip(var0_2)
			var4_1:unlock(var0_2.id)
			var3_1:updateBluePrint(var4_1)
			var5_1:removeItemById(var2_1, 1)
			arg0_1:sendNotification(GAME.ITEM_LOCK_SHIP_BLUPRINT_DONE, {
				ship = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
