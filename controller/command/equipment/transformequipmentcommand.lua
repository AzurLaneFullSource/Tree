local var0 = class("TransformEquipmentCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.candicate

	seriesAsync({
		function(arg0)
			if var1.type == DROP_TYPE_ITEM then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_compose_tip"),
					onYes = arg0
				})

				return
			elseif var1.type == DROP_TYPE_EQUIP and var1.template.shipId ~= nil then
				local var0 = var1.template.shipId
				local var1 = getProxy(BayProxy):getShipById(var0)
				local var2, var3 = ShipStatus.ShipStatusCheck("onModify", var1)

				if not var2 then
					pg.TipsMgr.GetInstance():ShowTips(var3)

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_equipment_consume", var1:getName(), var1.template:getConfig("name")),
					onYes = arg0
				})

				return
			end

			arg0()
		end,
		function(arg0)
			if var1.type == DROP_TYPE_EQUIP then
				return arg0({
					shipId = var1.template.shipId,
					pos = var1.template.shipPos,
					equipmentId = var1.template.id,
					formulaIds = var0.formulaIds
				})
			end

			local var0 = var1.composeCfg.id
			local var1 = 1
			local var2 = getProxy(BagProxy)
			local var3 = getProxy(PlayerProxy)
			local var4 = var3:getData()
			local var5 = pg.compose_data_template[var0]
			local var6 = getProxy(EquipmentProxy)
			local var7 = var6:getCapacity()

			if var4:getMaxEquipmentBag() < var7 + var1 then
				NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

				return
			end

			if var4.gold < var5.gold_num * var1 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						var5.gold_num * var1 - var4.gold,
						var5.gold_num * var1
					}
				})

				return
			end

			local var8 = var2:getItemById(var5.material_id)

			if not var8 or var8.count < var5.material_num * var1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			end

			pg.ConnectionMgr.GetInstance():Send(14006, {
				id = var0,
				num = var1
			}, 14007, function(arg0)
				if arg0.result == 0 then
					var6:addEquipmentById(var5.equip_id, var1)
					var4:consume({
						gold = var5.gold_num * var1
					})
					var3:updatePlayer(var4)
					var2:removeItemById(var5.material_id, var5.material_num * var1)
					arg0:sendNotification(GAME.COMPOSITE_EQUIPMENT_DONE, {
						equipment = Equipment.New({
							id = var5.equip_id
						}),
						count = var1,
						composeId = var0
					})
					arg0({
						equipmentId = var5.equip_id,
						formulaIds = var0.formulaIds
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", arg0.result))
				end
			end)
		end,
		function(arg0, arg1)
			arg0:ExecuteEquipTransform(arg1)
		end
	})
end

function var0.ExecuteEquipTransform(arg0, arg1)
	local var0 = arg1.shipId
	local var1 = var0
	local var2 = arg1.pos
	local var3 = arg1.equipmentId
	local var4 = arg1.formulaIds
	local var5

	if var0 then
		var5 = getProxy(BayProxy):getShipById(var0):getEquip(var2)

		assert(var5, "can not find equipment at ship.")

		var3 = var5.id
	elseif var3 ~= 0 then
		var5 = getProxy(EquipmentProxy):getEquipmentById(var3)

		assert(var5, "can not find equipment: " .. var3)

		var3 = var5.id
	end

	local var6, var7 = EquipmentTransformUtil.CheckEquipmentFormulasSucceed(var4, var3)

	if not var6 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var7))

		return
	end

	local var8 = {}
	local var9 = {}

	local function var10()
		local var0 = getProxy(BagProxy)
		local var1 = getProxy(PlayerProxy)

		for iter0, iter1 in pairs(var8) do
			if iter0 == "gold" then
				local var2 = var1:getData()
				local var3 = {
					gold = math.abs(iter1)
				}

				if iter1 > 0 then
					var2:consume(var3)
					var1:updatePlayer(var2)
				elseif iter1 < 0 then
					var2:addResources(var3)
					var1:updatePlayer(var2)
				end
			elseif iter1 > 0 then
				var0:removeItemById(iter0, iter1)
			elseif iter1 < 0 then
				var0:addItemById(iter0, -iter1)
			end
		end

		table.clear(var8)
	end

	local var11 = var3

	local function var12()
		var10()

		local var0 = getProxy(BayProxy)
		local var1 = getProxy(EquipmentProxy)
		local var2
		local var3

		if var0 then
			var2 = var0:getShipById(var0)
			var3 = var2:getEquip(var2)
		else
			var3 = var1:getEquipmentById(var3)
		end

		assert(var3, "Cant Get Equip " .. (var0 and "Ship " .. var0 .. " Pos " .. var2 or "ID " .. var3))

		local var4 = var3:MigrateTo(var11)

		if var2 then
			if not var2:isForbiddenAtPos(var4, var2) then
				var2:updateEquip(var2, var4)
				var0:updateShip(var2)
			else
				var2:updateEquip(var2, nil)
				var0:updateShip(var2)

				var0 = nil

				var1:addEquipment(var4)
			end
		else
			var1:removeEquipmentById(var3.id, 1)
			var1:addEquipmentById(var4.id, 1)
		end

		return var2, var3, var4
	end

	local var13 = var5
	local var14
	local var15
	local var16

	table.SerialIpairsAsync(var4, function(arg0, arg1, arg2)
		seriesAsync({
			function(arg0)
				local var0 = var0 and 14013 or 14015
				local var1 = var0 and 14014 or 14016
				local var2 = var0 and {
					ship_id = var0,
					pos = var2,
					upgrade_id = arg1
				} or {
					equip_id = var11,
					upgrade_id = arg1
				}

				pg.ConnectionMgr.GetInstance():Send(var0, var2, var1, arg0)
			end,
			function(arg0, arg1)
				if arg1.result == 0 then
					local var0 = pg.equip_upgrade_data[arg1]
					local var1 = var0.material_consume

					for iter0, iter1 in ipairs(var1) do
						local var2 = iter1[1]
						local var3 = iter1[2]

						var8[var2] = (var8[var2] or 0) + var3
					end

					var8.gold = (var8.gold or 0) + var0.coin_consume

					local var4 = Equipment.GetRevertRewardsStatic(var11)

					for iter2, iter3 in pairs(var4) do
						if iter2 ~= "gold" then
							var8[iter2] = (var8[iter2] or 0) - iter3
							var9[iter2] = (var9[iter2] or 0) + iter3
						end
					end

					assert(Equipment.CanInBag(var11), "Missing equip_data_template ID: " .. (var11 or "NIL"))

					if Equipment.CanInBag(var11) then
						local var5 = Equipment.getConfigData(var11).destory_gold or 0

						var8.gold = (var8.gold or 0) - var5
						var9.gold = (var9.gold or 0) + var5
					end

					var3 = var11
					var11 = var0.target_id
					var14, var15, var16 = var12()

					arg2()
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg1.result] .. arg1.result)
					arg0:sendNotification(GAME.TRANSFORM_EQUIPMENT_FAIL)
				end
			end
		})
	end, function()
		if not var0 and var1 then
			local var0 = getProxy(BayProxy):getShipById(var1)

			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_equipped_unavailable", var0:getName(), var16:getConfig("name")))
		end

		local var1 = {
			ship = var14,
			equip = var15,
			newEquip = var16
		}

		arg0:sendNotification(GAME.TRANSFORM_EQUIPMENT_DONE, var1)
		LoadContextCommand.LoadLayerOnTopContext(Context.New({
			mediator = EquipmentTransformInfoMediator,
			viewComponent = EquipmentTransformInfoLayer,
			data = {
				equipVO = var13
			},
			onRemoved = function()
				local var0 = getProxy(ContextProxy):getCurrentContext()
				local var1 = var0:getContextByMediator(EquipmentInfoMediator)

				if var1 then
					pg.m02:retrieveMediator(var1.mediator.__cname):getViewComponent():closeView()
				end

				local var2 = pg.m02:retrieveMediator(var0.mediator.__cname):getViewComponent()

				seriesAsync({
					function(arg0)
						var2:emit(BaseUI.ON_ACHIEVE, {
							{
								count = 1,
								id = var16 and var16.id or 0,
								type = DROP_TYPE_EQUIP
							}
						}, arg0)
					end,
					function(arg0)
						onNextTick(arg0)
					end,
					function(arg0)
						if not next(var9) then
							arg0()

							return
						end

						local var0 = {}

						for iter0, iter1 in pairs(var9) do
							if iter0 == "gold" then
								table.insert(var0, {
									type = DROP_TYPE_RESOURCE,
									id = res2id(iter0),
									count = iter1
								})
							else
								table.insert(var0, {
									type = DROP_TYPE_ITEM,
									id = iter0,
									count = iter1
								})
							end
						end

						var2:emit(BaseUI.ON_AWARD, {
							items = var0,
							title = AwardInfoLayer.TITLE.REVERT,
							removeFunc = arg0
						})
					end,
					function(arg0)
						arg0:sendNotification(GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED, var1)
					end
				})
			end
		}))
	end)
end

return var0
