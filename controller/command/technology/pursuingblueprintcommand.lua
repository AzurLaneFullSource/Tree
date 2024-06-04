local var0 = class("PursuingBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.count
	local var2 = var0.id

	if var1 == 0 then
		return
	end

	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getBluePrintById(var2)

	if not var4 then
		return
	end

	if not var4:isUnlock() then
		return
	end

	local var5 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold)
	local var6 = var3:calcPursuingCost(var4, var1)

	if var5 < var6 then
		return
	end

	if var4:isMaxLevel() and var4:isMaxFateLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_max_level_tip"))

		return
	end

	local var7 = var1 * var4:getItemExp()
	local var8 = Clone(var4)

	var8:addExp(var7)

	local var9 = var8:getStrengthenConfig(math.max(var8.level, 1))
	local var10 = getProxy(BayProxy)

	if var10:getShipById(var4.shipId).level < var9.need_lv then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buleprint_need_level_tip", var9.need_lv))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63212, {
		ship_id = var4.shipId,
		count = var1
	}, 63213, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1:consume({
				gold = var6
			})
			var0:updatePlayer(var1)
			var3:addPursuingTimes(var1, var4:isRarityUR())

			local var2 = Clone(var4)
			local var3 = var4:getItemExp()

			var4:addExp(var3 * var1)

			if var4.level > var2.level then
				for iter0 = var2.level + 1, var4.level do
					local var4 = var4:getStrengthenConfig(iter0)

					if var4.special == 1 and type(var4.special_effect) == "table" then
						local var5 = var4.special_effect

						for iter1, iter2 in ipairs(var5) do
							local var6 = iter2[1]

							if var6 == ShipBluePrint.STRENGTHEN_TYPE_SKILL then
								local var7 = iter2[2]
								local var8 = getProxy(BayProxy)
								local var9 = var8:getShipById(var4.shipId)

								for iter3, iter4 in ipairs(var7) do
									var9.skills[var2] = {
										exp = 0,
										level = 1,
										id = iter4
									}

									pg.TipsMgr.GetInstance():ShowTips(iter2[3])
								end

								var8:updateShip(var9)
							elseif var6 == ShipBluePrint.STRENGTHEN_TYPE_SKIN then
								getProxy(ShipSkinProxy):addSkin(ShipSkin.New({
									id = iter2[2]
								}))

								local var10 = pg.ship_skin_template[iter2[2]].name

								pg.TipsMgr.GetInstance():ShowTips(iter2[3])
							elseif var6 == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
								local var11 = getProxy(BayProxy):getShipById(var4.shipId)

								arg0:upgradeStar(var11)
							end
						end
					end
				end
			elseif var4.fateLevel > var2.fateLevel then
				for iter5 = var2.fateLevel + 1, var4.fateLevel do
					local var12 = var4:getFateStrengthenConfig(iter5)

					if var12.special == 1 and type(var12.special_effect) == "table" then
						local var13 = var12.special_effect

						for iter6, iter7 in ipairs(var13) do
							if iter7[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
								local var14 = getProxy(BayProxy)
								local var15 = var14:getShipById(var4.shipId)
								local var16 = iter7[2][1]
								local var17 = iter7[2][2]
								local var18 = Clone(var15.skills[var16])

								assert(var18, "shipVO without this skill" .. var16)

								var18.id = var17
								var15.skills[var16] = nil
								var15.skills[var17] = var18

								pg.TipsMgr.GetInstance():ShowTips(iter7[3])
								var14:updateShip(var15)

								local var19 = getProxy(NavalAcademyProxy)
								local var20 = var19:getStudentByShipId(var15.id)

								if var20 and var20.skillId == var16 then
									var20.skillId = var17

									var19:updateStudent(var20)
								end
							end
						end
					end
				end
			end

			local var21 = var10:getShipById(var4.shipId)

			var21.strengthList = {}

			table.insert(var21.strengthList, {
				level = var4.level + math.max(var4.fateLevel, 0),
				exp = var4.exp
			})
			var10:updateShip(var21)
			arg0:sendNotification(GAME.MOD_BLUEPRINT_ANIM_LOCK)
			var3:updateBluePrint(var4)
			arg0:sendNotification(GAME.MOD_BLUEPRINT_DONE, {
				oldBluePrint = var2,
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
