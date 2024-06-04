local var0 = class("ModBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.count
	local var2 = var0.id
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getBluePrintById(var2)

	if not var4 then
		return
	end

	if not var4:isUnlock() then
		return
	end

	local var5 = var4:getConfig("strengthen_item")

	if var1 > getProxy(BagProxy):getItemCountById(var5) then
		return
	end

	if var1 == 0 then
		return
	end

	if var4:isMaxLevel() and var4:isMaxFateLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_max_level_tip"))

		return
	end

	local var6 = var1 * var4:getItemExp()
	local var7 = Clone(var4)

	var7:addExp(var6)

	local var8 = getProxy(BayProxy)
	local var9 = var8:getShipById(var4.shipId)
	local var10 = var7.fateLevel > 0 and var7:getFateStrengthenConfig(var7.fateLevel) or var7:getStrengthenConfig(math.max(var7.level, 1))

	if var9.level < var10.need_lv then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buleprint_need_level_tip", var10.need_lv))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63204, {
		ship_id = var4.shipId,
		count = var1
	}, 63205, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				count = var1,
				id = var5
			}))

			local var0 = Clone(var4)
			local var1 = var4:getItemExp()

			var4:addExp(var1 * var1)

			if var4.level > var0.level then
				for iter0 = var0.level + 1, var4.level do
					local var2 = var4:getStrengthenConfig(iter0)

					if var2.special == 1 and type(var2.special_effect) == "table" then
						local var3 = var2.special_effect

						for iter1, iter2 in ipairs(var3) do
							local var4 = iter2[1]

							if var4 == ShipBluePrint.STRENGTHEN_TYPE_SKILL then
								local var5 = iter2[2]
								local var6 = getProxy(BayProxy)
								local var7 = var6:getShipById(var4.shipId)

								for iter3, iter4 in ipairs(var5) do
									var7.skills[var2] = {
										exp = 0,
										level = 1,
										id = iter4
									}

									pg.TipsMgr.GetInstance():ShowTips(iter2[3])
								end

								var6:updateShip(var7)
							elseif var4 == ShipBluePrint.STRENGTHEN_TYPE_SKIN then
								getProxy(ShipSkinProxy):addSkin(ShipSkin.New({
									id = iter2[2]
								}))

								local var8 = pg.ship_skin_template[iter2[2]].name

								pg.TipsMgr.GetInstance():ShowTips(iter2[3])
							elseif var4 == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
								local var9 = getProxy(BayProxy):getShipById(var4.shipId)

								arg0:upgradeStar(var9)
							end
						end
					end
				end
			elseif var4.fateLevel > var0.fateLevel then
				for iter5 = var0.fateLevel + 1, var4.fateLevel do
					local var10 = var4:getFateStrengthenConfig(iter5)

					if var10.special == 1 and type(var10.special_effect) == "table" then
						local var11 = var10.special_effect

						for iter6, iter7 in ipairs(var11) do
							if iter7[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
								local var12 = getProxy(BayProxy)
								local var13 = var12:getShipById(var4.shipId)
								local var14 = iter7[2][1]
								local var15 = iter7[2][2]
								local var16 = Clone(var13.skills[var14])

								assert(var16, "shipVO without this skill" .. var14)

								var16.id = var15
								var13.skills[var14] = nil
								var13.skills[var15] = var16

								pg.TipsMgr.GetInstance():ShowTips(iter7[3])
								var12:updateShip(var13)

								local var17 = getProxy(NavalAcademyProxy)
								local var18 = var17:getStudentByShipId(var13.id)

								if var18 and var18.skillId == var14 then
									var18.skillId = var15

									var17:updateStudent(var18)
								end
							end
						end
					end
				end
			end

			local var19 = var8:getShipById(var4.shipId)

			var19.strengthList = {}

			table.insert(var19.strengthList, {
				level = var4.level + math.max(var4.fateLevel, 0),
				exp = var4.exp
			})
			var8:updateShip(var19)
			arg0:sendNotification(GAME.MOD_BLUEPRINT_ANIM_LOCK)
			var3:updateBluePrint(var4)
			arg0:sendNotification(GAME.MOD_BLUEPRINT_DONE, {
				oldBluePrint = var0,
				newBluePrint = var4
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_erro") .. arg0.result)
		end
	end)
end

function var0.upgradeStar(arg0, arg1)
	local var0 = Clone(arg1)
	local var1 = getProxy(CollectionProxy):getShipGroup(var0.groupId)
	local var2 = pg.ship_data_breakout[arg1.configId]

	if var2.breakout_id ~= 0 then
		arg1.configId = var2.breakout_id

		local var3 = pg.ship_data_template[arg1.configId]

		for iter0, iter1 in ipairs(var3.buff_list) do
			if not arg1.skills[iter1] then
				arg1.skills[iter1] = {
					exp = 0,
					level = 1,
					id = iter1
				}
			end
		end

		arg1:updateMaxLevel(var3.max_level)

		local var4 = pg.ship_data_template[var0.configId].buff_list

		for iter2, iter3 in ipairs(var4) do
			if not table.contains(var3.buff_list, iter3) then
				arg1.skills[iter3] = nil
			end
		end

		getProxy(BayProxy):updateShip(arg1)
	end
end

return var0
