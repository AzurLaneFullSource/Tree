local var0_0 = class("CollectionGetAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.index
	local var3_1 = false
	local var4_1 = 0
	local var5_1 = getProxy(PlayerProxy):getData()
	local var6_1 = pg.storeup_data_template[var1_1].award_display[var2_1]

	if var6_1 and var6_1[1] == DROP_TYPE_RESOURCE then
		var4_1 = var6_1[2]
		var3_1 = true
	end

	if var3_1 and var4_1 == 1 and var5_1:GoldMax(1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_collect"))

		return
	end

	if var3_1 and var4_1 == 2 and var5_1:OilMax(1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_collect"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17005, {
		id = var1_1,
		award_index = var2_1
	}, 17006, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(CollectionProxy):updateAward(var1_1, var2_1)

			local var0_2 = pg.storeup_data_template[var1_1].award_display[var2_1]

			if var0_2[1] == DROP_TYPE_RESOURCE then
				local var1_2 = getProxy(PlayerProxy)
				local var2_2 = var1_2:getData()

				var2_2:addResources({
					[id2res(var0_2[2])] = var0_2[3]
				})
				var1_2:updatePlayer(var2_2)
			elseif var0_2[1] == DROP_TYPE_ITEM then
				getProxy(BagProxy):addItemById(var0_2[2], var0_2[3])
			elseif var0_2[1] == DROP_TYPE_EQUIP then
				getProxy(EquipmentProxy):addEquipmentById(var0_2[2], var0_2[3])
			elseif var0_2[1] == DROP_TYPE_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", pg.ship_data_statistics[var0_2[2]].name))
			elseif var0_2[1] == DROP_TYPE_FURNITURE then
				local var3_2 = getProxy(DormProxy)
				local var4_2 = Furniture.New({
					count = 1,
					id = var0_2[2]
				})

				var3_2:AddFurniture(var4_2)
			end

			local var5_2 = {}

			table.insert(var5_2, Drop.Create(var0_2))
			arg0_1:sendNotification(GAME.COLLECT_GET_AWARD_DONE, {
				id = var1_1,
				items = var5_2
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_takeOk"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("collection_getResource_error", arg0_2.result))
		end
	end)
end

return var0_0
