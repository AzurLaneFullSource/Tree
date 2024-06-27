local var0_0 = class("ContextMediator", pm.Mediator)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:initNotificationHandleDic()
	var0_0.super.Ctor(arg0_1, nil, arg1_1)
end

function var0_0.initNotificationHandleDic(arg0_2)
	arg0_2.handleDic, arg0_2.handleElse = nil
end

function var0_0.listNotificationInterests(arg0_3)
	if arg0_3.handleDic then
		return underscore.keys(arg0_3.handleDic)
	else
		return var0_0.super.listNotificationInterests(arg0_3)
	end
end

function var0_0.handleNotification(arg0_4, arg1_4)
	if arg0_4.handleDic then
		switch(arg1_4:getName(), arg0_4.handleDic, arg0_4.handleElse, arg0_4, arg1_4)
	else
		var0_0.super.handleNotification(arg0_4, arg1_4)
	end
end

function var0_0.onRegister(arg0_5)
	arg0_5.event = {}

	arg0_5:bind(BaseUI.ON_BACK_PRESSED, function(arg0_6, arg1_6)
		arg0_5:onBackPressed(arg1_6)
	end)
	arg0_5:bind(BaseUI.AVALIBLE, function(arg0_7, arg1_7)
		arg0_5:onUIAvalible()
	end)
	arg0_5:bind(BaseUI.ON_BACK, function(arg0_8, arg1_8, arg2_8)
		if arg2_8 and arg2_8 > 0 then
			pg.UIMgr.GetInstance():LoadingOn(false)
			LeanTween.delayedCall(arg2_8, System.Action(function()
				pg.UIMgr.GetInstance():LoadingOff()
				arg0_5:sendNotification(GAME.GO_BACK, nil, arg1_8)
			end))
		else
			arg0_5:sendNotification(GAME.GO_BACK, nil, arg1_8)
		end
	end)
	arg0_5:bind(BaseUI.ON_RETURN, function(arg0_10, arg1_10)
		arg0_5:sendNotification(GAME.GO_BACK, arg1_10)
	end)
	arg0_5:bind(BaseUI.ON_HOME, function(arg0_11)
		local var0_11 = getProxy(ContextProxy):getCurrentContext()

		if var0_11.mediator == NewMainMediator then
			for iter0_11 = #var0_11.children, 1, -1 do
				local var1_11 = var0_11.children[iter0_11]

				arg0_5:sendNotification(GAME.REMOVE_LAYERS, {
					context = var1_11
				})
			end

			return
		end

		local var2_11 = var0_11:retriveLastChild()

		if var2_11 and var2_11 ~= var0_11 then
			arg0_5:sendNotification(GAME.REMOVE_LAYERS, {
				onHome = true,
				context = var2_11
			})
		end

		pg.PoolMgr.GetInstance():ClearAllTempCache()
		arg0_5:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	end)
	arg0_5:bind(BaseUI.ON_CLOSE, function(arg0_12)
		local var0_12 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_5.class)

		if var0_12 then
			arg0_5:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_12
			})
		end
	end)
	arg0_5:bind(BaseUI.ON_AWARD, function(arg0_13, arg1_13)
		local var0_13 = {}

		if _.all(arg1_13.items, function(arg0_14)
			return arg0_14.type == DROP_TYPE_ICON_FRAME or arg0_14.type == DROP_TYPE_CHAT_FRAME
		end) then
			table.insert(var0_13, function(arg0_15)
				onNextTick(arg0_15)
			end)
		else
			table.insert(var0_13, function(arg0_16)
				arg0_5:addSubLayers(Context.New({
					mediator = AwardInfoMediator,
					viewComponent = AwardInfoLayer,
					data = setmetatable({
						removeFunc = arg0_16
					}, {
						__index = arg1_13
					})
				}))
			end)
		end

		seriesAsync(var0_13, arg1_13.removeFunc)
	end)

	local function var0_5(arg0_17, arg1_17)
		local var0_17 = getProxy(BayProxy)
		local var1_17 = var0_17:getNewShip(true)
		local var2_17 = {}

		for iter0_17, iter1_17 in pairs(var1_17) do
			if iter1_17:isMetaShip() then
				table.insert(var2_17, iter1_17.configId)
			end
		end

		local var3_17 = #var1_17

		underscore.each(arg0_17, function(arg0_18)
			if arg0_18.type == DROP_TYPE_OPERATION then
				table.insert(var1_17, var0_17:getShipById(arg0_18.count))
			elseif arg0_18.type == DROP_TYPE_SHIP then
				local var0_18 = arg0_18.configId or arg0_18.id

				if Ship.isMetaShipByConfigID(var0_18) then
					local var1_18 = table.indexof(var2_17, var0_18)

					if var1_18 then
						table.remove(var2_17, var1_18)

						var3_17 = var3_17 - 1
					else
						local var2_18 = Ship.New({
							configId = var0_18
						})
						local var3_18 = getProxy(BayProxy):getMetaTransItemMap(var2_18.configId)

						if var3_18 then
							var2_18:setReMetaSpecialItemVO(var3_18)
						end

						table.insert(var1_17, var2_18)
					end
				else
					var3_17 = var3_17 - 1
				end
			end
		end)

		var1_17 = underscore.rest(var1_17, var3_17 + 1)

		if (pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value or 20) >= #var1_17 then
			for iter2_17, iter3_17 in ipairs(var1_17) do
				table.insert(arg1_17, function(arg0_19)
					arg0_5:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = iter3_17
						},
						onRemoved = arg0_19
					}))
				end)
			end
		end
	end

	local function var1_5(arg0_20, arg1_20)
		for iter0_20, iter1_20 in pairs(arg0_20) do
			if iter1_20.type == DROP_TYPE_SKIN and pg.ship_skin_template[iter1_20.id].skin_type ~= ShipSkin.SKIN_TYPE_REMAKE and not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter1_20.id) then
				table.insert(arg1_20, function(arg0_21)
					arg0_5:addSubLayers(Context.New({
						mediator = NewSkinMediator,
						viewComponent = NewSkinLayer,
						data = {
							skinId = iter1_20.id,
							LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
						},
						onRemoved = arg0_21
					}))
				end)
			end

			if iter1_20.type == DROP_TYPE_SKIN_TIMELIMIT then
				if iter1_20.count > 0 and not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter1_20.id) then
					table.insert(arg1_20, function(arg0_22)
						arg0_5:addSubLayers(Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								timeLimit = true,
								skinId = iter1_20.id,
								LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
							},
							onRemoved = arg0_22
						}))
					end)
				else
					table.insert(arg1_20, function(arg0_23)
						pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))
						arg0_23()
					end)
				end
			end
		end
	end

	local function var2_5(arg0_24, arg1_24)
		local var0_24 = 0

		for iter0_24, iter1_24 in ipairs(arg0_24) do
			if iter1_24.type == DROP_TYPE_COMMANDER_CAT then
				var0_24 = var0_24 + 1
			end
		end

		if var0_24 == 0 then
			return
		end

		local var1_24 = getProxy(CommanderProxy):GetNewestCommander(var0_24)

		for iter2_24, iter3_24 in ipairs(var1_24) do
			table.insert(arg1_24, function(arg0_25)
				arg0_5:addSubLayers(Context.New({
					viewComponent = NewCommanderScene,
					mediator = NewCommanderMediator,
					data = {
						commander = iter3_24,
						onExit = arg0_25
					}
				}))
			end)
		end
	end

	arg0_5:bind(BaseUI.ON_ACHIEVE, function(arg0_26, arg1_26, arg2_26)
		local var0_26 = {}

		if #arg1_26 > 0 then
			table.insert(var0_26, function(arg0_27)
				arg0_5.viewComponent:emit(BaseUI.ON_AWARD, {
					items = arg1_26,
					removeFunc = arg0_27
				})
			end)
			table.insert(var0_26, function(arg0_28)
				var0_5(arg1_26, var0_26)
				var1_5(arg1_26, var0_26)
				var2_5(arg1_26, var0_26)
				arg0_28()
			end)
		end

		seriesAsyncExtend(var0_26, arg2_26)
	end)
	arg0_5:bind(BaseUI.ON_WORLD_ACHIEVE, function(arg0_29, arg1_29)
		local var0_29 = {}
		local var1_29 = arg1_29.items

		if #var1_29 > 0 then
			table.insert(var0_29, function(arg0_30)
				arg0_5.viewComponent:emit(BaseUI.ON_AWARD, setmetatable({
					removeFunc = arg0_30
				}, {
					__index = arg1_29
				}))
			end)
			table.insert(var0_29, function(arg0_31)
				var0_5(var1_29, var0_29)
				var1_5(var1_29, var0_29)
				var2_5(var1_29, var0_29)
				arg0_31()
			end)
		end

		seriesAsyncExtend(var0_29, arg1_29.removeFunc)
	end)
	arg0_5:bind(BaseUI.ON_SHIP_EXP, function(arg0_32, arg1_32, arg2_32)
		arg0_5:addSubLayers(Context.New({
			mediator = ShipExpMediator,
			viewComponent = ShipExpLayer,
			data = arg1_32,
			onRemoved = arg2_32
		}))
	end)
	arg0_5:bind(BaseUI.ON_SPWEAPON, function(arg0_33, arg1_33)
		arg1_33.type = defaultValue(arg1_33.type, SpWeaponInfoLayer.TYPE_DEFAULT)

		arg0_5:addSubLayers(Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = arg1_33
		}))
	end)
	arg0_5:commonBind()
	arg0_5:register()
end

function var0_0.commonBind(arg0_34)
	var0_0.CommonBindDic = var0_0.CommonBindDic or {
		[BaseUI.ON_DROP] = function(arg0_35, arg1_35, arg2_35, arg3_35)
			if arg2_35.type == DROP_TYPE_EQUIP then
				arg0_35:addSubLayers(Context.New({
					mediator = EquipmentInfoMediator,
					viewComponent = EquipmentInfoLayer,
					data = {
						equipmentId = arg2_35:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						onRemoved = arg3_35,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_35.type == DROP_TYPE_SPWEAPON then
				arg0_35:addSubLayers(Context.New({
					mediator = SpWeaponInfoMediator,
					viewComponent = SpWeaponInfoLayer,
					data = {
						spWeaponConfigId = arg2_35:getConfig("id"),
						type = SpWeaponInfoLayer.TYPE_DISPLAY,
						onRemoved = arg3_35,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_35.type == DROP_TYPE_EQUIPMENT_SKIN then
				arg0_35:addSubLayers(Context.New({
					mediator = EquipmentSkinMediator,
					viewComponent = EquipmentSkinLayer,
					data = {
						skinId = arg2_35:getConfig("id"),
						mode = EquipmentSkinLayer.DISPLAY,
						weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_35.type == DROP_TYPE_EMOJI then
				arg0_35:addSubLayers(Context.New({
					mediator = ContextMediator,
					viewComponent = EmojiInfoLayer,
					data = {
						id = arg2_35.cfg.id
					}
				}))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = arg2_35,
					onNo = arg3_35,
					onYes = arg3_35,
					weight = LayerWeightConst.TOP_LAYER
				})
			end
		end,
		[BaseUI.ON_DROP_LIST] = function(arg0_36, arg1_36, arg2_36)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_ITEM_BOX,
				items = arg2_36.itemList,
				content = arg2_36.content,
				item2Row = arg2_36.item2Row,
				itemFunc = function(arg0_37)
					arg0_36.viewComponent:emit(BaseUI.ON_DROP, arg0_37, function()
						arg0_36.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2_36)
					end)
				end,
				weight = LayerWeightConst.TOP_LAYER
			})
		end,
		[BaseUI.ON_DROP_LIST_OWN] = function(arg0_39, arg1_39, arg2_39)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM_ESKIN,
				items = arg2_39.itemList,
				content = arg2_39.content,
				item2Row = arg2_39.item2Row,
				itemFunc = function(arg0_40)
					arg0_39.viewComponent:emit(BaseUI.ON_DROP, arg0_40, function()
						arg0_39.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2_39)
					end)
				end,
				weight = LayerWeightConst.TOP_LAYER
			})
		end,
		[BaseUI.ON_ITEM] = function(arg0_42, arg1_42, arg2_42, arg3_42)
			arg0_42:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_42
					}),
					confirmCall = arg3_42
				}
			}))
		end,
		[BaseUI.ON_ITEM_EXTRA] = function(arg0_43, arg1_43, arg2_43, arg3_43)
			arg0_43:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_43,
						extra = arg3_43
					})
				}
			}))
		end,
		[BaseUI.ON_SHIP] = function(arg0_44, arg1_44, arg2_44)
			arg0_44:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_SHIP,
						id = arg2_44
					})
				}
			}))
		end,
		[BaseUI.ON_EQUIPMENT] = function(arg0_45, arg1_45, arg2_45)
			arg2_45.type = defaultValue(arg2_45.type, EquipmentInfoMediator.TYPE_DEFAULT)

			arg0_45:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = arg2_45
			}))
		end
	}

	for iter0_34, iter1_34 in pairs(var0_0.CommonBindDic) do
		arg0_34:bind(iter0_34, function(...)
			return iter1_34(arg0_34, ...)
		end)
	end
end

function var0_0.register(arg0_47)
	return
end

function var0_0.onUIAvalible(arg0_48)
	return
end

function var0_0.setContextData(arg0_49, arg1_49)
	arg0_49.contextData = arg1_49
end

function var0_0.bind(arg0_50, arg1_50, arg2_50)
	arg0_50.viewComponent.event:connect(arg1_50, arg2_50)
	table.insert(arg0_50.event, {
		event = arg1_50,
		callback = arg2_50
	})
end

function var0_0.onRemove(arg0_51)
	arg0_51:remove()

	for iter0_51, iter1_51 in ipairs(arg0_51.event) do
		arg0_51.viewComponent.event:disconnect(iter1_51.event, iter1_51.callback)
	end

	arg0_51.event = {}
end

function var0_0.remove(arg0_52)
	return
end

function var0_0.addSubLayers(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53)
	assert(isa(arg1_53, Context), "should be an instance of Context")

	local var0_53 = arg0_53:GetContext()

	if arg2_53 then
		while var0_53.parent do
			var0_53 = var0_53.parent
		end
	end

	local var1_53 = {
		parentContext = var0_53,
		context = arg1_53,
		callback = arg3_53
	}

	var1_53 = arg4_53 and table.merge(var1_53, arg4_53) or var1_53

	arg0_53:sendNotification(GAME.LOAD_LAYERS, var1_53)
end

function var0_0.switchLayersOnParent(arg0_54, arg1_54, arg2_54)
	assert(isa(arg1_54, Context), "should be an instance of Context")

	local var0_54 = arg0_54:GetContext()
	local var1_54 = var0_54.parent

	if not arg1_54.data.isSubView then
		while var1_54.data.isSubView do
			var1_54 = var1_54.parent
		end
	end

	local var2_54 = {
		parentContext = var1_54,
		context = arg1_54,
		removeContexts = {
			var0_54
		}
	}

	var2_54 = arg2_54 and table.merge(var2_54, arg2_54) or var2_54

	arg0_54:sendNotification(GAME.LOAD_LAYERS, var2_54)
end

function var0_0.GetContext(arg0_55)
	return getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_55.class)
end

function var0_0.blockEvents(arg0_56)
	if arg0_56.event then
		for iter0_56, iter1_56 in ipairs(arg0_56.event) do
			arg0_56.viewComponent.event:block(iter1_56.event, iter1_56.callback)
		end
	end
end

function var0_0.unblockEvents(arg0_57)
	if arg0_57.event then
		for iter0_57, iter1_57 in ipairs(arg0_57.event) do
			arg0_57.viewComponent.event:unblock(iter1_57.event, iter1_57.callback)
		end
	end
end

function var0_0.onBackPressed(arg0_58, arg1_58)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0_58 = getProxy(ContextProxy)

	if arg1_58 then
		local var1_58 = var0_58:getContextByMediator(arg0_58.class).parent

		if var1_58 then
			local var2_58 = pg.m02:retrieveMediator(var1_58.mediator.__cname)

			if var2_58 and var2_58.viewComponent then
				var2_58.viewComponent:onBackPressed()
			end
		end
	else
		arg0_58.viewComponent:closeView()
	end
end

function var0_0.removeSubLayers(arg0_59, arg1_59, arg2_59)
	assert(isa(arg1_59, var0_0), "should be a ContextMediator Class")

	local var0_59 = getProxy(ContextProxy):getContextByMediator(arg0_59.class or arg0_59)

	if not var0_59 then
		return
	end

	local var1_59 = var0_59:getContextByMediator(arg1_59)

	if not var1_59 then
		return
	end

	arg0_59:sendNotification(GAME.REMOVE_LAYERS, {
		context = var1_59,
		callback = arg2_59
	})
end

return var0_0
