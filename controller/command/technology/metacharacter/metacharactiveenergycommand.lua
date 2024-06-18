local var0_0 = class("MetaCharActiveEnergyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId
	local var1_1 = getProxy(BayProxy)
	local var2_1 = var1_1:getShipById(var0_1)

	if not var2_1 then
		return
	end

	local var3_1 = var2_1:getMetaCharacter()
	local var4_1 = var3_1:getBreakOutInfo()
	local var5_1 = var4_1:getNextInfo()

	if not var5_1 then
		return
	end

	local var6_1, var7_1 = var4_1:getLimited()

	if var6_1 > var2_1.level or var7_1 > var3_1:getCurRepairExp() then
		pg.TipsMgr.GetInstance():ShowTips("level or repair progress is not enough")

		return
	end

	local var8_1, var9_1 = var4_1:getConsume()
	local var10_1 = getProxy(PlayerProxy):getData()

	if var8_1 > var10_1.gold then
		pg.TipsMgr.GetInstance():ShowTips("gold not enough")

		return
	end

	local var11_1 = getProxy(BagProxy)

	if _.any(var9_1, function(arg0_2)
		return var11_1:getItemCountById(arg0_2.itemId) < arg0_2.count
	end) then
		pg.TipsMgr.GetInstance():ShowTips("item not enough")

		return
	end

	print("63303 meta energy", var2_1.id)
	pg.ConnectionMgr.GetInstance():Send(63303, {
		ship_id = var2_1.id
	}, 63304, function(arg0_3)
		if arg0_3.result == 0 then
			print("63304 meta energy success", var2_1.id)

			local var0_3 = Clone(var2_1)

			arg0_1:updateStar(var2_1, var0_3.configId, var5_1.id)
			var1_1:updateShip(var2_1)

			local var1_3 = getProxy(CollectionProxy)
			local var2_3 = var1_3:getShipGroup(var0_3.groupId)

			if var2_3 then
				var2_3.star = var2_1:getStar()

				var1_3:updateShipGroup(var2_3)
			end

			var10_1:consume({
				gold = var8_1
			})
			getProxy(PlayerProxy):updatePlayer(var10_1)

			for iter0_3, iter1_3 in pairs(var9_1) do
				arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
					type = DROP_TYPE_ITEM,
					id = iter1_3.itemId,
					count = iter1_3.count
				}))
			end

			getProxy(MetaCharacterProxy):getMetaProgressVOByID(var3_1.id):updateShip(var2_1)
			arg0_1:sendNotification(GAME.ENERGY_META_ACTIVATION_DONE, {
				newShip = var2_1,
				oldShip = var0_3
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
		end
	end)
end

function var0_0.updateStar(arg0_4, arg1_4, arg2_4, arg3_4)
	arg1_4.configId = arg3_4

	local var0_4 = pg.ship_data_template[arg1_4.configId]

	for iter0_4, iter1_4 in ipairs(var0_4.buff_list) do
		if not arg1_4.skills[iter1_4] then
			arg1_4.skills[iter1_4] = {
				exp = 0,
				level = 1,
				id = iter1_4
			}
		end
	end

	arg1_4:updateMaxLevel(var0_4.max_level)

	local var1_4 = pg.ship_data_template[arg2_4].buff_list

	for iter2_4, iter3_4 in ipairs(var1_4) do
		if not table.contains(var0_4.buff_list, iter3_4) then
			arg1_4.skills[iter3_4] = nil
		end
	end
end

return var0_0
