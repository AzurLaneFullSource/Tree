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
			return arg0_14.type == DROP_TYPE_ICON_FRAME or arg0_14.type == DROP_TYPE_CHAT_FRAME or arg0_14.type == DROP_TYPE_LIVINGAREA_COVER
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
						removeFunc = arg0_16,
						auto = arg1_13.auto
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
	arg0_5:bind(BaseUI.ON_ACHIEVE_AUTO, function(arg0_29, arg1_29, arg2_29, arg3_29)
		local var0_29 = {}

		if #arg1_29 > 0 then
			table.insert(var0_29, function(arg0_30)
				arg0_5.viewComponent:emit(BaseUI.ON_AWARD, {
					items = arg1_29,
					removeFunc = arg0_30,
					auto = arg2_29 or 2
				})
			end)
			table.insert(var0_29, function(arg0_31)
				var0_5(arg1_29, var0_29)
				var1_5(arg1_29, var0_29)
				var2_5(arg1_29, var0_29)
				arg0_31()
			end)
		end

		seriesAsyncExtend(var0_29, arg3_29)
	end)
	arg0_5:bind(BaseUI.ON_WORLD_ACHIEVE, function(arg0_32, arg1_32)
		local var0_32 = {}
		local var1_32 = arg1_32.items

		if #var1_32 > 0 then
			table.insert(var0_32, function(arg0_33)
				arg0_5.viewComponent:emit(BaseUI.ON_AWARD, setmetatable({
					removeFunc = arg0_33
				}, {
					__index = arg1_32
				}))
			end)
			table.insert(var0_32, function(arg0_34)
				var0_5(var1_32, var0_32)
				var1_5(var1_32, var0_32)
				var2_5(var1_32, var0_32)
				arg0_34()
			end)
		end

		seriesAsyncExtend(var0_32, arg1_32.removeFunc)
	end)
	arg0_5:bind(BaseUI.ON_SHIP_EXP, function(arg0_35, arg1_35, arg2_35)
		arg0_5:addSubLayers(Context.New({
			mediator = ShipExpMediator,
			viewComponent = ShipExpLayer,
			data = arg1_35,
			onRemoved = arg2_35
		}))
	end)
	arg0_5:bind(BaseUI.ON_SPWEAPON, function(arg0_36, arg1_36)
		arg1_36.type = defaultValue(arg1_36.type, SpWeaponInfoLayer.TYPE_DEFAULT)

		arg0_5:addSubLayers(Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = arg1_36
		}))
	end)
	arg0_5:commonBind()
	arg0_5:register()
end

function var0_0.commonBind(arg0_37)
	var0_0.CommonBindDic = var0_0.CommonBindDic or {
		[BaseUI.ON_DROP] = function(arg0_38, arg1_38, arg2_38, arg3_38)
			if arg2_38.type == DROP_TYPE_EQUIP then
				arg0_38:addSubLayers(Context.New({
					mediator = EquipmentInfoMediator,
					viewComponent = EquipmentInfoLayer,
					data = {
						equipmentId = arg2_38:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						onRemoved = arg3_38,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_38.type == DROP_TYPE_SPWEAPON then
				arg0_38:addSubLayers(Context.New({
					mediator = SpWeaponInfoMediator,
					viewComponent = SpWeaponInfoLayer,
					data = {
						spWeaponConfigId = arg2_38:getConfig("id"),
						type = SpWeaponInfoLayer.TYPE_DISPLAY,
						onRemoved = arg3_38,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_38.type == DROP_TYPE_EQUIPMENT_SKIN then
				arg0_38:addSubLayers(Context.New({
					mediator = EquipmentSkinMediator,
					viewComponent = EquipmentSkinLayer,
					data = {
						skinId = arg2_38:getConfig("id"),
						mode = EquipmentSkinLayer.DISPLAY,
						weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2_38.type == DROP_TYPE_EMOJI then
				arg0_38:addSubLayers(Context.New({
					mediator = ContextMediator,
					viewComponent = EmojiInfoLayer,
					data = {
						id = arg2_38.cfg.id
					}
				}))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = arg2_38,
					onNo = arg3_38,
					onYes = arg3_38,
					weight = LayerWeightConst.TOP_LAYER
				})
			end
		end,
		[BaseUI.ON_DROP_LIST] = function(arg0_39, arg1_39, arg2_39)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_ITEM_BOX,
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
		[BaseUI.ON_DROP_LIST_OWN] = function(arg0_42, arg1_42, arg2_42)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM_ESKIN,
				items = arg2_42.itemList,
				content = arg2_42.content,
				item2Row = arg2_42.item2Row,
				itemFunc = function(arg0_43)
					arg0_42.viewComponent:emit(BaseUI.ON_DROP, arg0_43, function()
						arg0_42.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2_42)
					end)
				end,
				weight = LayerWeightConst.TOP_LAYER
			})
		end,
		[BaseUI.ON_ITEM] = function(arg0_45, arg1_45, arg2_45, arg3_45)
			arg0_45:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_45
					}),
					confirmCall = arg3_45
				}
			}))
		end,
		[BaseUI.ON_ITEM_EXTRA] = function(arg0_46, arg1_46, arg2_46, arg3_46)
			arg0_46:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_46,
						extra = arg3_46
					})
				}
			}))
		end,
		[BaseUI.ON_SHIP] = function(arg0_47, arg1_47, arg2_47)
			arg0_47:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_SHIP,
						id = arg2_47
					})
				}
			}))
		end,
		[BaseUI.ON_EQUIPMENT] = function(arg0_48, arg1_48, arg2_48)
			arg2_48.type = defaultValue(arg2_48.type, EquipmentInfoMediator.TYPE_DEFAULT)

			arg0_48:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = arg2_48
			}))
		end,
		[BaseUI.ON_NEW_DROP] = function(arg0_49, arg1_49, arg2_49)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_DROP, setmetatable(arg2_49, {
				__index = {
					blurParams = {
						weight = LayerWeightConst.TOP_LAYER
					}
				}
			}))
		end,
		[BaseUI.ON_NEW_STYLE_DROP] = function(arg0_50, arg1_50, arg2_50)
			local var0_50 = pg.NewStyleMsgboxMgr.TYPE_COMMON_DROP
			local var1_50 = setmetatable(arg2_50, {
				__index = {
					blurParams = {
						weight = LayerWeightConst.TOP_LAYER
					}
				}
			})

			if arg2_50.useDeepShow then
				pg.NewStyleMsgboxMgr.GetInstance():DeepShow(var0_50, var1_50)
			else
				pg.NewStyleMsgboxMgr.GetInstance():Show(var0_50, var1_50)
			end
		end,
		[BaseUI.ON_NEW_STYLE_ITEMS] = function(arg0_51, arg1_51, arg2_51)
			local var0_51 = pg.NewStyleMsgboxMgr.TYPE_COMMON_ITEMS
			local var1_51 = setmetatable(arg2_51, {
				__index = {
					btnList = {
						{
							type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
							name = i18n("msgbox_text_confirm"),
							sound = SFX_CONFIRM
						}
					},
					blurParams = {
						weight = LayerWeightConst.TOP_LAYER
					},
					items = arg2_51.itemList,
					content = arg2_51.content,
					itemFunc = function(arg0_52)
						arg0_51.viewComponent:emit(BaseUI.ON_NEW_STYLE_DROP, {
							useDeepShow = true,
							drop = arg0_52
						})
					end
				}
			})

			if arg2_51.useDeepShow then
				pg.NewStyleMsgboxMgr.GetInstance():DeepShow(var0_51, var1_51)
			else
				pg.NewStyleMsgboxMgr.GetInstance():Show(var0_51, var1_51)
			end
		end
	}

	for iter0_37, iter1_37 in pairs(var0_0.CommonBindDic) do
		arg0_37:bind(iter0_37, function(...)
			return iter1_37(arg0_37, ...)
		end)
	end
end

function var0_0.register(arg0_54)
	return
end

function var0_0.onUIAvalible(arg0_55)
	return
end

function var0_0.setContextData(arg0_56, arg1_56)
	arg0_56.contextData = arg1_56
end

function var0_0.bind(arg0_57, arg1_57, arg2_57)
	arg0_57.viewComponent.event:connect(arg1_57, arg2_57)
	table.insert(arg0_57.event, {
		event = arg1_57,
		callback = arg2_57
	})
end

function var0_0.onRemove(arg0_58)
	arg0_58:remove()

	for iter0_58, iter1_58 in ipairs(arg0_58.event) do
		arg0_58.viewComponent.event:disconnect(iter1_58.event, iter1_58.callback)
	end

	arg0_58.event = {}
end

function var0_0.remove(arg0_59)
	return
end

function var0_0.addSubLayers(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60)
	assert(isa(arg1_60, Context), "should be an instance of Context")

	local var0_60 = arg0_60:GetContext()

	if arg2_60 then
		while var0_60.parent do
			var0_60 = var0_60.parent
		end
	end

	local var1_60 = {
		parentContext = var0_60,
		context = arg1_60,
		callback = arg3_60
	}

	var1_60 = arg4_60 and table.merge(var1_60, arg4_60) or var1_60

	arg0_60:sendNotification(GAME.LOAD_LAYERS, var1_60)
end

function var0_0.GetContext(arg0_61)
	return getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_61.class)
end

function var0_0.blockEvents(arg0_62)
	if arg0_62.event then
		for iter0_62, iter1_62 in ipairs(arg0_62.event) do
			arg0_62.viewComponent.event:block(iter1_62.event, iter1_62.callback)
		end
	end
end

function var0_0.unblockEvents(arg0_63)
	if arg0_63.event then
		for iter0_63, iter1_63 in ipairs(arg0_63.event) do
			arg0_63.viewComponent.event:unblock(iter1_63.event, iter1_63.callback)
		end
	end
end

function var0_0.onBackPressed(arg0_64, arg1_64)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0_64 = getProxy(ContextProxy)

	if arg1_64 then
		local var1_64 = var0_64:getContextByMediator(arg0_64.class).parent

		if var1_64 then
			local var2_64 = pg.m02:retrieveMediator(var1_64.mediator.__cname)

			if var2_64 and var2_64.viewComponent then
				var2_64.viewComponent:onBackPressed()
			end
		end
	else
		arg0_64.viewComponent:closeView()
	end
end

function var0_0.removeSubLayers(arg0_65, arg1_65, arg2_65)
	assert(isa(arg1_65, var0_0), "should be a ContextMediator Class")

	local var0_65 = getProxy(ContextProxy):getContextByMediator(arg0_65.class or arg0_65)

	if not var0_65 then
		return
	end

	local var1_65 = var0_65:getContextByMediator(arg1_65)

	if not var1_65 then
		return
	end

	arg0_65:sendNotification(GAME.REMOVE_LAYERS, {
		context = var1_65,
		callback = arg2_65
	})
end

return var0_0
