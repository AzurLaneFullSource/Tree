local var0_0 = class("ModBluePrintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.count
	local var2_1 = var0_1.id
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getBluePrintById(var2_1)

	if not var4_1 then
		return
	end

	if not var4_1:isUnlock() then
		return
	end

	local var5_1 = var4_1:getConfig("strengthen_item")

	if var1_1 > getProxy(BagProxy):getItemCountById(var5_1) then
		return
	end

	if var1_1 == 0 then
		return
	end

	if var4_1:isMaxLevel() and var4_1:isMaxFateLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_max_level_tip"))

		return
	end

	local var6_1 = var1_1 * var4_1:getItemExp()
	local var7_1 = Clone(var4_1)

	var7_1:addExp(var6_1)

	local var8_1 = getProxy(BayProxy)
	local var9_1 = var8_1:getShipById(var4_1.shipId)
	local var10_1 = var7_1.fateLevel > 0 and var7_1:getFateStrengthenConfig(var7_1.fateLevel) or var7_1:getStrengthenConfig(math.max(var7_1.level, 1))

	if var9_1.level < var10_1.need_lv then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buleprint_need_level_tip", var10_1.need_lv))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63204, {
		ship_id = var4_1.shipId,
		count = var1_1
	}, 63205, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
				type = DROP_TYPE_ITEM,
				count = var1_1,
				id = var5_1
			}))

			local var0_2 = Clone(var4_1)
			local var1_2 = var4_1:getItemExp()

			var4_1:addExp(var1_2 * var1_1)

			if var4_1.level > var0_2.level then
				for iter0_2 = var0_2.level + 1, var4_1.level do
					local var2_2 = var4_1:getStrengthenConfig(iter0_2)

					if var2_2.special == 1 and type(var2_2.special_effect) == "table" then
						local var3_2 = var2_2.special_effect

						for iter1_2, iter2_2 in ipairs(var3_2) do
							local var4_2 = iter2_2[1]

							if var4_2 == ShipBluePrint.STRENGTHEN_TYPE_SKILL then
								local var5_2 = iter2_2[2]
								local var6_2 = getProxy(BayProxy)
								local var7_2 = var6_2:getShipById(var4_1.shipId)

								for iter3_2, iter4_2 in ipairs(var5_2) do
									var7_2.skills[var2_1] = {
										exp = 0,
										level = 1,
										id = iter4_2
									}

									pg.TipsMgr.GetInstance():ShowTips(iter2_2[3])
								end

								var6_2:updateShip(var7_2)
							elseif var4_2 == ShipBluePrint.STRENGTHEN_TYPE_SKIN then
								getProxy(ShipSkinProxy):addSkin(ShipSkin.New({
									id = iter2_2[2]
								}))

								local var8_2 = pg.ship_skin_template[iter2_2[2]].name

								pg.TipsMgr.GetInstance():ShowTips(iter2_2[3])
							elseif var4_2 == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
								local var9_2 = getProxy(BayProxy):getShipById(var4_1.shipId)

								arg0_1:upgradeStar(var9_2)
							end
						end
					end
				end
			elseif var4_1.fateLevel > var0_2.fateLevel then
				for iter5_2 = var0_2.fateLevel + 1, var4_1.fateLevel do
					local var10_2 = var4_1:getFateStrengthenConfig(iter5_2)

					if var10_2.special == 1 and type(var10_2.special_effect) == "table" then
						local var11_2 = var10_2.special_effect

						for iter6_2, iter7_2 in ipairs(var11_2) do
							if iter7_2[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
								local var12_2 = getProxy(BayProxy)
								local var13_2 = var12_2:getShipById(var4_1.shipId)
								local var14_2 = iter7_2[2][1]
								local var15_2 = iter7_2[2][2]
								local var16_2 = Clone(var13_2.skills[var14_2])

								assert(var16_2, "shipVO without this skill" .. var14_2)

								var16_2.id = var15_2
								var13_2.skills[var14_2] = nil
								var13_2.skills[var15_2] = var16_2

								pg.TipsMgr.GetInstance():ShowTips(iter7_2[3])
								var12_2:updateShip(var13_2)

								local var17_2 = getProxy(NavalAcademyProxy)
								local var18_2 = var17_2:getStudentByShipId(var13_2.id)

								if var18_2 and var18_2.skillId == var14_2 then
									var18_2.skillId = var15_2

									var17_2:updateStudent(var18_2)
								end
							end
						end
					end
				end
			end

			local var19_2 = var8_1:getShipById(var4_1.shipId)

			var19_2.strengthList = {}

			table.insert(var19_2.strengthList, {
				level = var4_1.level + math.max(var4_1.fateLevel, 0),
				exp = var4_1.exp
			})
			var8_1:updateShip(var19_2)
			arg0_1:sendNotification(GAME.MOD_BLUEPRINT_ANIM_LOCK)
			var3_1:updateBluePrint(var4_1)
			arg0_1:sendNotification(GAME.MOD_BLUEPRINT_DONE, {
				oldBluePrint = var0_2,
				newBluePrint = var4_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_erro") .. arg0_2.result)
		end
	end)
end

function var0_0.upgradeStar(arg0_3, arg1_3)
	local var0_3 = Clone(arg1_3)
	local var1_3 = getProxy(CollectionProxy):getShipGroup(var0_3.groupId)
	local var2_3 = pg.ship_data_breakout[arg1_3.configId]

	if var2_3.breakout_id ~= 0 then
		arg1_3.configId = var2_3.breakout_id

		local var3_3 = pg.ship_data_template[arg1_3.configId]

		for iter0_3, iter1_3 in ipairs(var3_3.buff_list) do
			if not arg1_3.skills[iter1_3] then
				arg1_3.skills[iter1_3] = {
					exp = 0,
					level = 1,
					id = iter1_3
				}
			end
		end

		arg1_3:updateMaxLevel(var3_3.max_level)

		local var4_3 = pg.ship_data_template[var0_3.configId].buff_list

		for iter2_3, iter3_3 in ipairs(var4_3) do
			if not table.contains(var3_3.buff_list, iter3_3) then
				arg1_3.skills[iter3_3] = nil
			end
		end

		getProxy(BayProxy):updateShip(arg1_3)
	end
end

return var0_0
