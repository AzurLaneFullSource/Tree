local var0_0 = class("TransformEquipmentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.candicate

	seriesAsync({
		function(arg0_2)
			if var1_1.type == DROP_TYPE_ITEM then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_compose_tip"),
					onYes = arg0_2
				})

				return
			elseif var1_1.type == DROP_TYPE_EQUIP and var1_1.template.shipId ~= nil then
				local var0_2 = var1_1.template.shipId
				local var1_2 = getProxy(BayProxy):getShipById(var0_2)
				local var2_2, var3_2 = ShipStatus.ShipStatusCheck("onModify", var1_2)

				if not var2_2 then
					pg.TipsMgr.GetInstance():ShowTips(var3_2)

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_equipment_consume", var1_2:getName(), var1_1.template:getConfig("name")),
					onYes = arg0_2
				})

				return
			end

			arg0_2()
		end,
		function(arg0_3)
			if var1_1.type == DROP_TYPE_EQUIP then
				return arg0_3({
					shipId = var1_1.template.shipId,
					pos = var1_1.template.shipPos,
					equipmentId = var1_1.template.id,
					formulaIds = var0_1.formulaIds
				})
			end

			local var0_3 = var1_1.composeCfg.id
			local var1_3 = 1
			local var2_3 = getProxy(BagProxy)
			local var3_3 = getProxy(PlayerProxy)
			local var4_3 = var3_3:getData()
			local var5_3 = pg.compose_data_template[var0_3]
			local var6_3 = getProxy(EquipmentProxy)
			local var7_3 = var6_3:getCapacity()

			if var4_3:getMaxEquipmentBag() < var7_3 + var1_3 then
				NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

				return
			end

			if var4_3.gold < var5_3.gold_num * var1_3 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						var5_3.gold_num * var1_3 - var4_3.gold,
						var5_3.gold_num * var1_3
					}
				})

				return
			end

			local var8_3 = var2_3:getItemById(var5_3.material_id)

			if not var8_3 or var8_3.count < var5_3.material_num * var1_3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			end

			pg.ConnectionMgr.GetInstance():Send(14006, {
				id = var0_3,
				num = var1_3
			}, 14007, function(arg0_4)
				if arg0_4.result == 0 then
					var6_3:addEquipmentById(var5_3.equip_id, var1_3)
					var4_3:consume({
						gold = var5_3.gold_num * var1_3
					})
					var3_3:updatePlayer(var4_3)
					var2_3:removeItemById(var5_3.material_id, var5_3.material_num * var1_3)
					arg0_1:sendNotification(GAME.COMPOSITE_EQUIPMENT_DONE, {
						equipment = Equipment.New({
							id = var5_3.equip_id
						}),
						count = var1_3,
						composeId = var0_3
					})
					arg0_3({
						equipmentId = var5_3.equip_id,
						formulaIds = var0_1.formulaIds
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", arg0_4.result))
				end
			end)
		end,
		function(arg0_5, arg1_5)
			arg0_1:ExecuteEquipTransform(arg1_5)
		end
	})
end

function var0_0.ExecuteEquipTransform(arg0_6, arg1_6)
	local var0_6 = arg1_6.shipId
	local var1_6 = var0_6
	local var2_6 = arg1_6.pos
	local var3_6 = arg1_6.equipmentId
	local var4_6 = arg1_6.formulaIds
	local var5_6

	if var0_6 then
		var5_6 = getProxy(BayProxy):getShipById(var0_6):getEquip(var2_6)

		assert(var5_6, "can not find equipment at ship.")

		var3_6 = var5_6.id
	elseif var3_6 ~= 0 then
		var5_6 = getProxy(EquipmentProxy):getEquipmentById(var3_6)

		assert(var5_6, "can not find equipment: " .. var3_6)

		var3_6 = var5_6.id
	end

	local var6_6, var7_6 = EquipmentTransformUtil.CheckEquipmentFormulasSucceed(var4_6, var3_6)

	if not var6_6 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var7_6))

		return
	end

	local var8_6 = {}
	local var9_6 = {}

	local function var10_6()
		local var0_7 = getProxy(BagProxy)
		local var1_7 = getProxy(PlayerProxy)

		for iter0_7, iter1_7 in pairs(var8_6) do
			if iter0_7 == "gold" then
				local var2_7 = var1_7:getData()
				local var3_7 = {
					gold = math.abs(iter1_7)
				}

				if iter1_7 > 0 then
					var2_7:consume(var3_7)
					var1_7:updatePlayer(var2_7)
				elseif iter1_7 < 0 then
					var2_7:addResources(var3_7)
					var1_7:updatePlayer(var2_7)
				end
			elseif iter1_7 > 0 then
				var0_7:removeItemById(iter0_7, iter1_7)
			elseif iter1_7 < 0 then
				var0_7:addItemById(iter0_7, -iter1_7)
			end
		end

		table.clear(var8_6)
	end

	local var11_6 = var3_6

	local function var12_6()
		var10_6()

		local var0_8 = getProxy(BayProxy)
		local var1_8 = getProxy(EquipmentProxy)
		local var2_8
		local var3_8

		if var0_6 then
			var2_8 = var0_8:getShipById(var0_6)
			var3_8 = var2_8:getEquip(var2_6)
		else
			var3_8 = var1_8:getEquipmentById(var3_6)
		end

		assert(var3_8, "Cant Get Equip " .. (var0_6 and "Ship " .. var0_6 .. " Pos " .. var2_6 or "ID " .. var3_6))

		local var4_8 = var3_8:MigrateTo(var11_6)

		if var2_8 then
			if not var2_8:isForbiddenAtPos(var4_8, var2_6) then
				var2_8:updateEquip(var2_6, var4_8)
				var0_8:updateShip(var2_8)
			else
				var2_8:updateEquip(var2_6, nil)
				var0_8:updateShip(var2_8)

				var0_6 = nil

				var1_8:addEquipment(var4_8)
			end
		else
			var1_8:removeEquipmentById(var3_8.id, 1)
			var1_8:addEquipmentById(var4_8.id, 1)
		end

		return var2_8, var3_8, var4_8
	end

	local var13_6 = var5_6
	local var14_6
	local var15_6
	local var16_6

	table.SerialIpairsAsync(var4_6, function(arg0_9, arg1_9, arg2_9)
		seriesAsync({
			function(arg0_10)
				local var0_10 = var0_6 and 14013 or 14015
				local var1_10 = var0_6 and 14014 or 14016
				local var2_10 = var0_6 and {
					ship_id = var0_6,
					pos = var2_6,
					upgrade_id = arg1_9
				} or {
					equip_id = var11_6,
					upgrade_id = arg1_9
				}

				pg.ConnectionMgr.GetInstance():Send(var0_10, var2_10, var1_10, arg0_10)
			end,
			function(arg0_11, arg1_11)
				if arg1_11.result == 0 then
					local var0_11 = pg.equip_upgrade_data[arg1_9]
					local var1_11 = var0_11.material_consume

					for iter0_11, iter1_11 in ipairs(var1_11) do
						local var2_11 = iter1_11[1]
						local var3_11 = iter1_11[2]

						var8_6[var2_11] = (var8_6[var2_11] or 0) + var3_11
					end

					var8_6.gold = (var8_6.gold or 0) + var0_11.coin_consume

					local var4_11 = Equipment.GetRevertRewardsStatic(var11_6)

					for iter2_11, iter3_11 in pairs(var4_11) do
						if iter2_11 ~= "gold" then
							var8_6[iter2_11] = (var8_6[iter2_11] or 0) - iter3_11
							var9_6[iter2_11] = (var9_6[iter2_11] or 0) + iter3_11
						end
					end

					assert(Equipment.CanInBag(var11_6), "Missing equip_data_template ID: " .. (var11_6 or "NIL"))

					if Equipment.CanInBag(var11_6) then
						local var5_11 = Equipment.getConfigData(var11_6).destory_gold or 0

						var8_6.gold = (var8_6.gold or 0) - var5_11
						var9_6.gold = (var9_6.gold or 0) + var5_11
					end

					var3_6 = var11_6
					var11_6 = var0_11.target_id
					var14_6, var15_6, var16_6 = var12_6()

					arg2_9()
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg1_11.result] .. arg1_11.result)
					arg0_6:sendNotification(GAME.TRANSFORM_EQUIPMENT_FAIL)
				end
			end
		})
	end, function()
		if not var0_6 and var1_6 then
			local var0_12 = getProxy(BayProxy):getShipById(var1_6)

			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_equipped_unavailable", var0_12:getName(), var16_6:getConfig("name")))
		end

		local var1_12 = {
			ship = var14_6,
			equip = var15_6,
			newEquip = var16_6
		}

		arg0_6:sendNotification(GAME.TRANSFORM_EQUIPMENT_DONE, var1_12)
		LoadContextCommand.LoadLayerOnTopContext(Context.New({
			mediator = EquipmentTransformInfoMediator,
			viewComponent = EquipmentTransformInfoLayer,
			data = {
				equipVO = var13_6
			},
			onRemoved = function()
				local var0_13 = getProxy(ContextProxy):getCurrentContext()
				local var1_13 = var0_13:getContextByMediator(EquipmentInfoMediator)

				if var1_13 then
					pg.m02:retrieveMediator(var1_13.mediator.__cname):getViewComponent():closeView()
				end

				local var2_13 = pg.m02:retrieveMediator(var0_13.mediator.__cname):getViewComponent()

				seriesAsync({
					function(arg0_14)
						var2_13:emit(BaseUI.ON_ACHIEVE, {
							{
								count = 1,
								id = var16_6 and var16_6.id or 0,
								type = DROP_TYPE_EQUIP
							}
						}, arg0_14)
					end,
					function(arg0_15)
						onNextTick(arg0_15)
					end,
					function(arg0_16)
						if not next(var9_6) then
							arg0_16()

							return
						end

						local var0_16 = {}

						for iter0_16, iter1_16 in pairs(var9_6) do
							if iter0_16 == "gold" then
								table.insert(var0_16, {
									type = DROP_TYPE_RESOURCE,
									id = res2id(iter0_16),
									count = iter1_16
								})
							else
								table.insert(var0_16, {
									type = DROP_TYPE_ITEM,
									id = iter0_16,
									count = iter1_16
								})
							end
						end

						var2_13:emit(BaseUI.ON_AWARD, {
							items = var0_16,
							title = AwardInfoLayer.TITLE.REVERT,
							removeFunc = arg0_16
						})
					end,
					function(arg0_17)
						arg0_6:sendNotification(GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED, var1_12)
					end
				})
			end
		}))
	end)
end

return var0_0
