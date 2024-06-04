local var0 = class("MetaCharActiveEnergyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId
	local var1 = getProxy(BayProxy)
	local var2 = var1:getShipById(var0)

	if not var2 then
		return
	end

	local var3 = var2:getMetaCharacter()
	local var4 = var3:getBreakOutInfo()
	local var5 = var4:getNextInfo()

	if not var5 then
		return
	end

	local var6, var7 = var4:getLimited()

	if var6 > var2.level or var7 > var3:getCurRepairExp() then
		pg.TipsMgr.GetInstance():ShowTips("level or repair progress is not enough")

		return
	end

	local var8, var9 = var4:getConsume()
	local var10 = getProxy(PlayerProxy):getData()

	if var8 > var10.gold then
		pg.TipsMgr.GetInstance():ShowTips("gold not enough")

		return
	end

	local var11 = getProxy(BagProxy)

	if _.any(var9, function(arg0)
		return var11:getItemCountById(arg0.itemId) < arg0.count
	end) then
		pg.TipsMgr.GetInstance():ShowTips("item not enough")

		return
	end

	print("63303 meta energy", var2.id)
	pg.ConnectionMgr.GetInstance():Send(63303, {
		ship_id = var2.id
	}, 63304, function(arg0)
		if arg0.result == 0 then
			print("63304 meta energy success", var2.id)

			local var0 = Clone(var2)

			arg0:updateStar(var2, var0.configId, var5.id)
			var1:updateShip(var2)

			local var1 = getProxy(CollectionProxy)
			local var2 = var1:getShipGroup(var0.groupId)

			if var2 then
				var2.star = var2:getStar()

				var1:updateShipGroup(var2)
			end

			var10:consume({
				gold = var8
			})
			getProxy(PlayerProxy):updatePlayer(var10)

			for iter0, iter1 in pairs(var9) do
				arg0:sendNotification(GAME.CONSUME_ITEM, Drop.New({
					type = DROP_TYPE_ITEM,
					id = iter1.itemId,
					count = iter1.count
				}))
			end

			getProxy(MetaCharacterProxy):getMetaProgressVOByID(var3.id):updateShip(var2)
			arg0:sendNotification(GAME.ENERGY_META_ACTIVATION_DONE, {
				newShip = var2,
				oldShip = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

function var0.updateStar(arg0, arg1, arg2, arg3)
	arg1.configId = arg3

	local var0 = pg.ship_data_template[arg1.configId]

	for iter0, iter1 in ipairs(var0.buff_list) do
		if not arg1.skills[iter1] then
			arg1.skills[iter1] = {
				exp = 0,
				level = 1,
				id = iter1
			}
		end
	end

	arg1:updateMaxLevel(var0.max_level)

	local var1 = pg.ship_data_template[arg2].buff_list

	for iter2, iter3 in ipairs(var1) do
		if not table.contains(var0.buff_list, iter3) then
			arg1.skills[iter3] = nil
		end
	end
end

return var0
