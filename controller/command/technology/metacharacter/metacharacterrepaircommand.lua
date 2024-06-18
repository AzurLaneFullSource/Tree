local var0_0 = class("MetaCharacterRepairCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipID
	local var2_1 = var0_1.attr
	local var3_1 = getProxy(BayProxy)
	local var4_1 = var3_1:getShipById(var1_1)
	local var5_1 = var4_1:getMetaCharacter()
	local var6_1 = var5_1:getAttrVO(var2_1)
	local var7_1 = var6_1:getItem()
	local var8_1 = var7_1:getTotalCnt()
	local var9_1 = var7_1:getItemId()

	if var8_1 > getProxy(BagProxy):getItemCountById(var9_1) then
		return
	end

	if var6_1:isMaxLevel() then
		return
	end

	print("63301 meta repair:", var1_1, var7_1.id)
	pg.ConnectionMgr.GetInstance():Send(63301, {
		ship_id = var1_1,
		repair_id = var7_1.id
	}, 63302, function(arg0_2)
		if arg0_2.result == 0 then
			print("63302 meta repair success:")
			var6_1:levelUp()
			var3_1:updateShip(var4_1)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(var5_1.id):updateShip(var4_1)
			arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				id = var9_1,
				count = var8_1
			}))
			arg0_1:sendNotification(GAME.REPAIR_META_CHARACTER_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
