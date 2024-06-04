local var0 = class("CollectionGetAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.index
	local var3 = false
	local var4 = 0
	local var5 = getProxy(PlayerProxy):getData()
	local var6 = pg.storeup_data_template[var1].award_display[var2]

	if var6 and var6[1] == DROP_TYPE_RESOURCE then
		var4 = var6[2]
		var3 = true
	end

	if var3 and var4 == 1 and var5:GoldMax(1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_collect"))

		return
	end

	if var3 and var4 == 2 and var5:OilMax(1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_collect"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17005, {
		id = var1,
		award_index = var2
	}, 17006, function(arg0)
		if arg0.result == 0 then
			getProxy(CollectionProxy):updateAward(var1, var2)

			local var0 = pg.storeup_data_template[var1].award_display[var2]

			if var0[1] == DROP_TYPE_RESOURCE then
				local var1 = getProxy(PlayerProxy)
				local var2 = var1:getData()

				var2:addResources({
					[id2res(var0[2])] = var0[3]
				})
				var1:updatePlayer(var2)
			elseif var0[1] == DROP_TYPE_ITEM then
				getProxy(BagProxy):addItemById(var0[2], var0[3])
			elseif var0[1] == DROP_TYPE_EQUIP then
				getProxy(EquipmentProxy):addEquipmentById(var0[2], var0[3])
			elseif var0[1] == DROP_TYPE_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", pg.ship_data_statistics[var0[2]].name))
			elseif var0[1] == DROP_TYPE_FURNITURE then
				local var3 = getProxy(DormProxy)
				local var4 = Furniture.New({
					count = 1,
					id = var0[2]
				})

				var3:AddFurniture(var4)
			end

			local var5 = {}

			table.insert(var5, Drop.Create(var0))
			arg0:sendNotification(GAME.COLLECT_GET_AWARD_DONE, {
				id = var1,
				items = var5
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_takeOk"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("collection_getResource_error", arg0.result))
		end
	end)
end

return var0
