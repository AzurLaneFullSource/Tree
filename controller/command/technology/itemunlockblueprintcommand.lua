local var0 = class("ItemUnlockBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.itemId
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getBluePrintById(var1)
	local var5 = getProxy(BagProxy)

	if not var4 or not var5:getItemCountById(var2) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63214, {
		group = var1,
		itemid = var2
	}, 63215, function(arg0)
		if arg0.result == 0 then
			local var0 = Ship.New(arg0.ship)

			getProxy(BayProxy):addShip(var0)
			var4:unlock(var0.id)
			var3:updateBluePrint(var4)
			var5:removeItemById(var2, 1)
			arg0:sendNotification(GAME.ITEM_LOCK_SHIP_BLUPRINT_DONE, {
				ship = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0.result)
		end
	end)
end

return var0
