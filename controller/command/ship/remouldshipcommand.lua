local var0_0 = class("RemouldShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.remouldId
	local var3_1 = var0_1.materialIds or {}

	if not var1_1 or not var2_1 then
		return
	end

	local var4_1 = getProxy(PlayerProxy):getData()
	local var5_1 = pg.transform_data_template[var2_1]

	assert(var5_1, "transform_data_template>>>." .. var2_1)

	if var5_1.use_gold > var4_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var6_1 = getProxy(BayProxy)
	local var7_1 = var6_1:getShipById(var1_1)
	local var8_1 = var7_1.transforms[var2_1]
	local var9_1 = 0

	if var8_1 then
		var9_1 = var7_1.transforms[var2_1].level

		if var9_1 == #var5_1.effect then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_max_level"))

			return
		end
	end

	local var10_1 = var9_1 + 1
	local var11_1 = var5_1.use_item[var10_1] or {}
	local var12_1 = getProxy(BagProxy)

	for iter0_1, iter1_1 in ipairs(var11_1) do
		if var12_1:getItemCountById(iter1_1[1]) < iter1_1[2] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end
	end

	if var5_1.use_ship ~= 0 then
		if table.getCount(var3_1) ~= var5_1.use_ship then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_ship_no_enough"))

			return
		end

		for iter2_1, iter3_1 in ipairs(var3_1) do
			if not var6_1:getShipById(iter3_1) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_ship_on_exist"))

				return
			end
		end
	end

	for iter4_1, iter5_1 in ipairs(var5_1.ship_id) do
		if iter5_1[1] == var7_1.configId and getProxy(EquipmentProxy):getCapacity() >= var4_1:getMaxEquipmentBag() then
			local var13_1 = Clone(var7_1)

			var13_1.configId = iter5_1[2]

			for iter6_1, iter7_1 in ipairs(var13_1.equipments) do
				if iter7_1 and var13_1:isForbiddenAtPos(iter7_1, iter6_1) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_cant_unload"))

					return
				end
			end
		end
	end

	local var14_1
	local var15_1
	local var16_1

	for iter8_1, iter9_1 in ipairs(var5_1.ship_id) do
		if var7_1.configId == iter9_1[1] then
			var14_1, var15_1 = unpack(iter9_1)

			break
		end
	end

	if var14_1 and var15_1 then
		var16_1 = TeamType.GetTeamFromShipType(pg.ship_data_statistics[var14_1].type) ~= TeamType.GetTeamFromShipType(pg.ship_data_statistics[var15_1].type)
	end

	local var17_1 = {}

	if var16_1 then
		if var7_1:getFlag("inFleet") and not getProxy(FleetProxy):GetRegularFleetByShip(var7_1):canRemove(var7_1) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				content = i18n("shipmodechange_reject_1stfleet_only"),
				onYes = function()
					arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BIANDUI)
				end
			})

			return
		end

		table.insert(var17_1, function(arg0_3)
			local var0_3

			local function var1_3()
				local var0_4, var1_4 = ShipStatus.ShipStatusCheck("onTeamChange", var7_1, var1_3)

				if var0_4 then
					arg0_3()
				elseif var1_4 then
					pg.TipsMgr.GetInstance():ShowTips(var1_4)
				end
			end

			var1_3()
		end)

		if var7_1:getFlag("inWorld") then
			table.insert(var17_1, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("shipchange_alert_inworld"),
					onYes = arg0_5
				})
			end)
		end

		if var7_1:getFlag("inElite") then
			table.insert(var17_1, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("shipchange_alert_indiff"),
					onYes = function()
						arg0_1:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
							shipId = var7_1.id,
							callback = arg0_6
						})
					end
				})
			end)
		end
	end

	table.insert(var17_1, function(arg0_8)
		local var0_8 = {}
		local var1_8 = var5_1.skin_id

		if var1_8 and var1_8 ~= 0 then
			PaintingGroupConst.AddPaintingNameBySkinID(var0_8, var1_8)
		end

		local var2_8 = {
			isShowBox = true,
			paintingNameList = var0_8,
			finishFunc = arg0_8
		}

		PaintingGroupConst.PaintingDownload(var2_8)
	end)
	seriesAsync(var17_1, function()
		pg.ConnectionMgr.GetInstance():Send(12011, {
			ship_id = var1_1,
			remould_id = var2_1,
			material_id = var3_1
		}, 12012, function(arg0_10)
			if arg0_10.result == 0 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_REMOULD_SHIP, var7_1.groupId)

				if var16_1 and var7_1:getFlag("inWorld") then
					local var0_10 = nowWorld()
					local var1_10 = var0_10:GetFleet(var0_10:GetShip(var7_1.id).fleetId)
					local var2_10 = underscore.filter(var1_10:GetShips(true), function(arg0_11)
						return arg0_11.id ~= var7_1.id
					end)

					var1_10:UpdateShips(var2_10)
					pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
				end

				if var8_1 then
					local var3_10 = var7_1.transforms[var2_1].level

					var7_1.transforms[var2_1].level = var3_10 + 1
				else
					var7_1.transforms[var2_1] = {
						level = 1,
						id = var2_1
					}
				end

				for iter0_10, iter1_10 in ipairs(var5_1.edit_trans) do
					if var7_1.transforms[iter1_10] then
						var7_1.transforms[iter1_10] = nil
					end
				end

				local var4_10 = getProxy(NavalAcademyProxy)
				local var5_10 = var4_10:getStudentByShipId(var1_1)
				local var6_10 = var5_10 and var5_10:getSkillId(var7_1)

				if var14_1 and var15_1 then
					var7_1.configId = var15_1

					local var7_10 = pg.ship_data_template[var14_1].buff_list
					local var8_10 = pg.ship_data_template[var15_1].buff_list

					for iter2_10 = 1, math.max(#var7_10, #var8_10) do
						local var9_10 = var7_10[iter2_10]
						local var10_10 = var8_10[iter2_10]

						if var9_10 == var10_10 then
							-- block empty
						else
							local var11_10

							if var9_10 then
								var11_10 = var7_1.skills[var9_10]
								var11_10.id = var10_10
								var7_1.skills[var9_10] = nil
							else
								var11_10 = {
									exp = 0,
									level = 1,
									id = var10_10
								}
							end

							var7_1.skills[var10_10] = var11_10

							pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_unlock_skill", pg.skill_data_template[var10_10].name))

							if var5_10 and var6_10 == var9_10 then
								var5_10:updateSkillId(var10_10)
								var4_10:updateStudent(var5_10)
							end
						end
					end
				end

				_.each(var5_1.ship_id, function(arg0_12)
					if arg0_12[1] == var7_1.configId then
						-- block empty
					end
				end)

				for iter3_10, iter4_10 in pairs(var5_1.use_item[var10_1] or {}) do
					var12_1:removeItemById(iter4_10[1], iter4_10[2])
				end

				local var12_10 = getProxy(PlayerProxy)
				local var13_10 = var12_10:getData()

				var13_10:consume({
					gold = var5_1.use_gold
				})
				var12_10:updatePlayer(var13_10)

				local var14_10 = {}

				if var5_1.skin_id ~= 0 then
					var7_1:updateSkinId(var5_1.skin_id)
					table.insert(var14_10, {
						count = 1,
						type = DROP_TYPE_SKIN,
						id = var5_1.skin_id
					})

					local var15_10 = getProxy(CollectionProxy)
					local var16_10 = var15_10:getShipGroup(var7_1.groupId)

					if var16_10 and not var16_10.trans then
						var16_10.trans = true

						var15_10:updateShipGroup(var16_10)
					end
				end

				if var5_1.skill_id ~= 0 and not var7_1.skills[var5_1.skill_id] then
					var7_1.skills[var5_1.skill_id] = {
						exp = 0,
						level = 1,
						id = var5_1.skill_id
					}

					local var17_10 = pg.skill_data_template[var5_1.skill_id].name

					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_unlock_skill", var17_10))
				end

				var7_1:updateName()

				local var18_10 = var7_1:GetSpWeapon()

				if var18_10 and not var7_1:CanEquipSpWeapon(var18_10) then
					var7_1:UpdateSpWeapon(nil)
					getProxy(EquipmentProxy):AddSpWeapon(var18_10)
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var18_10:GetName()), "red")
				end

				var6_1:updateShip(var7_1)

				local var19_10 = getProxy(EquipmentProxy)

				for iter5_10, iter6_10 in ipairs(var3_1 or {}) do
					local var20_10 = var6_1:getShipById(iter6_10)

					for iter7_10, iter8_10 in ipairs(var20_10.equipments) do
						if iter8_10 then
							var19_10:addEquipment(iter8_10)
						end

						if var20_10:getEquipSkin(iter7_10) ~= 0 then
							var19_10:addEquipmentSkin(var20_10:getEquipSkin(iter7_10), 1)
							pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
						end
					end

					local var21_10 = var20_10:GetSpWeapon()

					if var21_10 then
						var20_10:UpdateSpWeapon(nil)
						var19_10:AddSpWeapon(var21_10)
					end

					var6_1:removeShipById(iter6_10)
				end

				local var22_10 = {}

				for iter9_10, iter10_10 in ipairs(var7_1.equipments) do
					if iter10_10 and not var7_1:canEquipAtPos(iter10_10, iter9_10) then
						table.insert(var22_10, function(arg0_13)
							arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
								shipId = var7_1.id,
								pos = iter9_10,
								callback = arg0_13
							})
						end)
					end
				end

				seriesAsync(var22_10, function()
					arg0_1:sendNotification(GAME.REMOULD_SHIP_DONE, {
						ship = var6_1:getShipById(var1_1),
						awards = var14_10
					})

					local var0_14 = nowWorld()
					local var1_14 = var0_14 and var0_14:GetBossProxy()

					if var1_14 and var1_14.isSetup then
						var1_14:CheckRemouldShip()
					end
				end)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_remouldShip", arg0_10.result))
			end
		end)
	end)
end

return var0_0
