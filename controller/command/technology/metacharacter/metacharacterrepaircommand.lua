local var0 = class("MetaCharacterRepairCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipID
	local var2 = var0.attr
	local var3 = getProxy(BayProxy)
	local var4 = var3:getShipById(var1)
	local var5 = var4:getMetaCharacter()
	local var6 = var5:getAttrVO(var2)
	local var7 = var6:getItem()
	local var8 = var7:getTotalCnt()
	local var9 = var7:getItemId()

	if var8 > getProxy(BagProxy):getItemCountById(var9) then
		return
	end

	if var6:isMaxLevel() then
		return
	end

	print("63301 meta repair:", var1, var7.id)
	pg.ConnectionMgr.GetInstance():Send(63301, {
		ship_id = var1,
		repair_id = var7.id
	}, 63302, function(arg0)
		if arg0.result == 0 then
			print("63302 meta repair success:")
			var6:levelUp()
			var3:updateShip(var4)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(var5.id):updateShip(var4)
			arg0:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				id = var9,
				count = var8
			}))
			arg0:sendNotification(GAME.REPAIR_META_CHARACTER_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
