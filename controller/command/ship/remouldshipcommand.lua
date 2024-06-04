local var0 = class("RemouldShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.remouldId
	local var3 = var0.materialIds or {}

	if not var1 or not var2 then
		return
	end

	local var4 = getProxy(PlayerProxy):getData()
	local var5 = pg.transform_data_template[var2]

	assert(var5, "transform_data_template>>>." .. var2)

	if var5.use_gold > var4.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var6 = getProxy(BayProxy)
	local var7 = var6:getShipById(var1)
	local var8 = var7.transforms[var2]
	local var9 = 0

	if var8 then
		var9 = var7.transforms[var2].level

		if var9 == #var5.effect then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_max_level"))

			return
		end
	end

	local var10 = var9 + 1
	local var11 = var5.use_item[var10] or {}
	local var12 = getProxy(BagProxy)

	for iter0, iter1 in ipairs(var11) do
		if var12:getItemCountById(iter1[1]) < iter1[2] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end
	end

	if var5.use_ship ~= 0 then
		if table.getCount(var3) ~= var5.use_ship then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_ship_no_enough"))

			return
		end

		for iter2, iter3 in ipairs(var3) do
			if not var6:getShipById(iter3) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_ship_on_exist"))

				return
			end
		end
	end

	for iter4, iter5 in ipairs(var5.ship_id) do
		if iter5[1] == var7.configId and getProxy(EquipmentProxy):getCapacity() >= var4:getMaxEquipmentBag() then
			local var13 = Clone(var7)

			var13.configId = iter5[2]

			for iter6, iter7 in ipairs(var13.equipments) do
				if iter7 and var13:isForbiddenAtPos(iter7, iter6) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_cant_unload"))

					return
				end
			end
		end
	end

	local var14
	local var15
	local var16

	for iter8, iter9 in ipairs(var5.ship_id) do
		if var7.configId == iter9[1] then
			var14, var15 = unpack(iter9)

			break
		end
	end

	if var14 and var15 then
		var16 = TeamType.GetTeamFromShipType(pg.ship_data_statistics[var14].type) ~= TeamType.GetTeamFromShipType(pg.ship_data_statistics[var15].type)
	end

	local var17 = {}

	if var16 then
		if var7:getFlag("inFleet") and not getProxy(FleetProxy):GetRegularFleetByShip(var7):canRemove(var7) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_forward",
				content = i18n("shipmodechange_reject_1stfleet_only"),
				onYes = function()
					arg0:sendNotification(GAME.GO_SCENE, SCENE.BIANDUI)
				end
			})

			return
		end

		table.insert(var17, function(arg0)
			local var0

			local function var1()
				local var0, var1 = ShipStatus.ShipStatusCheck("onTeamChange", var7, var1)

				if var0 then
					arg0()
				elseif var1 then
					pg.TipsMgr.GetInstance():ShowTips(var1)
				end
			end

			var1()
		end)

		if var7:getFlag("inWorld") then
			table.insert(var17, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("shipchange_alert_inworld"),
					onYes = arg0
				})
			end)
		end

		if var7:getFlag("inElite") then
			table.insert(var17, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("shipchange_alert_indiff"),
					onYes = function()
						arg0:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
							shipId = var7.id,
							callback = arg0
						})
					end
				})
			end)
		end
	end

	table.insert(var17, function(arg0)
		local var0 = {}
		local var1 = var5.skin_id

		if var1 and var1 ~= 0 then
			PaintingGroupConst.AddPaintingNameBySkinID(var0, var1)
		end

		local var2 = {
			isShowBox = true,
			paintingNameList = var0,
			finishFunc = arg0
		}

		PaintingGroupConst.PaintingDownload(var2)
	end)
	seriesAsync(var17, function()
		pg.ConnectionMgr.GetInstance():Send(12011, {
			ship_id = var1,
			remould_id = var2,
			material_id = var3
		}, 12012, function(arg0)
			if arg0.result == 0 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_REMOULD_SHIP, var7.groupId)

				if var16 and var7:getFlag("inWorld") then
					local var0 = nowWorld()
					local var1 = var0:GetFleet(var0:GetShip(var7.id).fleetId)
					local var2 = underscore.filter(var1:GetShips(true), function(arg0)
						return arg0.id ~= var7.id
					end)

					var1:UpdateShips(var2)
					pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
				end

				if var8 then
					local var3 = var7.transforms[var2].level

					var7.transforms[var2].level = var3 + 1
				else
					var7.transforms[var2] = {
						level = 1,
						id = var2
					}
				end

				for iter0, iter1 in ipairs(var5.edit_trans) do
					if var7.transforms[iter1] then
						var7.transforms[iter1] = nil
					end
				end

				local var4 = getProxy(NavalAcademyProxy)
				local var5 = var4:getStudentByShipId(var1)
				local var6 = var5 and var5:getSkillId(var7)

				if var14 and var15 then
					var7.configId = var15

					local var7 = pg.ship_data_template[var14].buff_list
					local var8 = pg.ship_data_template[var15].buff_list

					for iter2 = 1, math.max(#var7, #var8) do
						local var9 = var7[iter2]
						local var10 = var8[iter2]

						if var9 == var10 then
							-- block empty
						else
							local var11

							if var9 then
								var11 = var7.skills[var9]
								var11.id = var10
								var7.skills[var9] = nil
							else
								var11 = {
									exp = 0,
									level = 1,
									id = var10
								}
							end

							var7.skills[var10] = var11

							pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_unlock_skill", pg.skill_data_template[var10].name))

							if var5 and var6 == var9 then
								var5:updateSkillId(var10)
								var4:updateStudent(var5)
							end
						end
					end
				end

				_.each(var5.ship_id, function(arg0)
					if arg0[1] == var7.configId then
						-- block empty
					end
				end)

				for iter3, iter4 in pairs(var5.use_item[var10] or {}) do
					var12:removeItemById(iter4[1], iter4[2])
				end

				local var12 = getProxy(PlayerProxy)
				local var13 = var12:getData()

				var13:consume({
					gold = var5.use_gold
				})
				var12:updatePlayer(var13)

				local var14 = {}

				if var5.skin_id ~= 0 then
					var7:updateSkinId(var5.skin_id)
					table.insert(var14, {
						count = 1,
						type = DROP_TYPE_SKIN,
						id = var5.skin_id
					})

					local var15 = getProxy(CollectionProxy)
					local var16 = var15:getShipGroup(var7.groupId)

					if var16 and not var16.trans then
						var16.trans = true

						var15:updateShipGroup(var16)
					end
				end

				if var5.skill_id ~= 0 and not var7.skills[var5.skill_id] then
					var7.skills[var5.skill_id] = {
						exp = 0,
						level = 1,
						id = var5.skill_id
					}

					local var17 = pg.skill_data_template[var5.skill_id].name

					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_remould_material_unlock_skill", var17))
				end

				var7:updateName()

				local var18 = var7:GetSpWeapon()

				if var18 and not var7:CanEquipSpWeapon(var18) then
					var7:UpdateSpWeapon(nil)
					getProxy(EquipmentProxy):AddSpWeapon(var18)
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var18:GetName()), "red")
				end

				var6:updateShip(var7)

				local var19 = getProxy(EquipmentProxy)

				for iter5, iter6 in ipairs(var3 or {}) do
					local var20 = var6:getShipById(iter6)

					for iter7, iter8 in ipairs(var20.equipments) do
						if iter8 then
							var19:addEquipment(iter8)
						end

						if var20:getEquipSkin(iter7) ~= 0 then
							var19:addEquipmentSkin(var20:getEquipSkin(iter7), 1)
							pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
						end
					end

					local var21 = var20:GetSpWeapon()

					if var21 then
						var20:UpdateSpWeapon(nil)
						var19:AddSpWeapon(var21)
					end

					var6:removeShipById(iter6)
				end

				local var22 = {}

				for iter9, iter10 in ipairs(var7.equipments) do
					if iter10 and not var7:canEquipAtPos(iter10, iter9) then
						table.insert(var22, function(arg0)
							arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
								shipId = var7.id,
								pos = iter9,
								callback = arg0
							})
						end)
					end
				end

				seriesAsync(var22, function()
					arg0:sendNotification(GAME.REMOULD_SHIP_DONE, {
						ship = var6:getShipById(var1),
						awards = var14
					})

					local var0 = nowWorld()
					local var1 = var0 and var0:GetBossProxy()

					if var1 and var1.isSetup then
						var1:CheckRemouldShip()
					end
				end)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_remouldShip", arg0.result))
			end
		end)
	end)
end

return var0
