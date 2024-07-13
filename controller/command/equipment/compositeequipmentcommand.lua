local var0_0 = class("CompositeEquipmentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.count
	local var2_1 = var0_1.id
	local var3_1 = getProxy(BagProxy)
	local var4_1 = var3_1:getData()
	local var5_1 = getProxy(PlayerProxy)
	local var6_1 = var5_1:getData()
	local var7_1 = pg.compose_data_template[var2_1]
	local var8_1 = getProxy(EquipmentProxy)
	local var9_1 = var8_1:getCapacity()

	if var6_1:getMaxEquipmentBag() < var9_1 + var1_1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	if var6_1.gold < var7_1.gold_num * var1_1 then
		GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
			{
				59001,
				var7_1.gold_num * var1_1 - var6_1.gold,
				var7_1.gold_num * var1_1
			}
		})

		return
	end

	if not var4_1[var7_1.material_id] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	if var4_1[var7_1.material_id].count < var7_1.material_num * var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(14006, {
		id = var2_1,
		num = var1_1
	}, 14007, function(arg0_2)
		if arg0_2.result == 0 then
			var8_1:addEquipmentById(var7_1.equip_id, var1_1)
			var6_1:consume({
				gold = var7_1.gold_num * var1_1
			})
			var5_1:updatePlayer(var6_1)
			var3_1:removeItemById(var7_1.material_id, var7_1.material_num * var1_1)
			arg0_1:sendNotification(GAME.COMPOSITE_EQUIPMENT_DONE, {
				equipment = Equipment.New({
					id = var7_1.equip_id
				}),
				count = var1_1,
				composeId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", arg0_2.result))
		end
	end)
end

return var0_0
