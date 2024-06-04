local var0 = class("CompositeEquipmentCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.count
	local var2 = var0.id
	local var3 = getProxy(BagProxy)
	local var4 = var3:getData()
	local var5 = getProxy(PlayerProxy)
	local var6 = var5:getData()
	local var7 = pg.compose_data_template[var2]
	local var8 = getProxy(EquipmentProxy)
	local var9 = var8:getCapacity()

	if var6:getMaxEquipmentBag() < var9 + var1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	if var6.gold < var7.gold_num * var1 then
		GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
			{
				59001,
				var7.gold_num * var1 - var6.gold,
				var7.gold_num * var1
			}
		})

		return
	end

	if not var4[var7.material_id] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	if var4[var7.material_id].count < var7.material_num * var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(14006, {
		id = var2,
		num = var1
	}, 14007, function(arg0)
		if arg0.result == 0 then
			var8:addEquipmentById(var7.equip_id, var1)
			var6:consume({
				gold = var7.gold_num * var1
			})
			var5:updatePlayer(var6)
			var3:removeItemById(var7.material_id, var7.material_num * var1)
			arg0:sendNotification(GAME.COMPOSITE_EQUIPMENT_DONE, {
				equipment = Equipment.New({
					id = var7.equip_id
				}),
				count = var1,
				composeId = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", arg0.result))
		end
	end)
end

return var0
