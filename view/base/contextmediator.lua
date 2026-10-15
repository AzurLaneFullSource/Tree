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
			elseif arg0_18.type == DROP_TYPE_VITEM and arg0_18:getConfig("virtual_type") == 17 then
				local var0_18 = getProxy(ActivityProxy):getActivityById(arg0_18:getConfig("link_id"))

				table.insert(var1_17, var0_17:getShipById(var0_18.data2))
			elseif arg0_18.type == DROP_TYPE_SHIP then
				local var1_18 = arg0_18.configId or arg0_18.id

				if Ship.isMetaShipByConfigID(var1_18) then
					local var2_18 = table.indexof(var2_17, var1_18)

					if var2_18 then
						table.remove(var2_17, var2_18)

						var3_17 = var3_17 - 1
					else
						local var3_18 = Ship.New({
							configId = var1_18
						})
						local var4_18 = getProxy(BayProxy):getMetaTransItemMap(var3_18.configId)

						if var4_18 then
							var3_18:setReMetaSpecialItemVO(var4_18)
						end

						table.insert(var1_17, var3_18)
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
		for iter0_20, iter1_20 in ipairs(arg0_20) do
			if iter1_20.type == DROP_TYPE_SKIN and pg.ship_skin_template[iter1_20.id].skin_type ~= ShipSkin.SKIN_TYPE_REMAKE then
				table.insert(arg1_20, function(arg0_21)
					arg0_5:addSubLayers(Context.New({
						mediator = NewSkinMediator,
						viewComponent = NewSkinLayer,
						data = {
							skinId = iter1_20.id
						},
						onRemoved = arg0_21
					}))
				end)
			end

			if iter1_20.type == DROP_TYPE_SKIN_TIMELIMIT then
				if iter1_20.count > 0 and not getProxy(ShipSkinProxy):hasNonLimitSkin(iter1_20.id) then
					table.insert(arg1_20, function(arg0_22)
						arg0_5:addSubLayers(Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								timeLimit = true,
								skinId = iter1_20.id
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
			data = arg1_36,
			onRemoved = arg1_36 and arg1_36.onRemoved or nil
		}))
	end)
	arg0_5:bind(BaseUI.ON_ADD_SUBLAYER, function(arg0_37, arg1_37)
		arg0_5:addSubLayers(arg1_37)
	end)
	arg0_5:bind(BaseUI.ON_GO_SCENE, function(arg0_38, arg1_38, arg2_38)
		arg0_5:sendNotification(GAME.GO_SCENE, arg1_38, arg2_38)
	end)
	arg0_5:commonBind()
	arg0_5:register()
end

function var0_0.commonBind(arg0_39)
	var0_0.CommonBindDic = var0_0.CommonBindDic or {
		[BaseUI.ON_DROP] = function(arg0_40, arg1_40, arg2_40, arg3_40)
			if arg2_40.type == DROP_TYPE_EQUIP then
				arg0_40:addSubLayers(Context.New({
					mediator = EquipmentInfoMediator,
					viewComponent = EquipmentInfoLayer,
					data = {
						equipmentId = arg2_40:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						onRemoved = arg3_40
					}
				}))
			elseif arg2_40.type == DROP_TYPE_SPWEAPON then
				arg0_40:addSubLayers(Context.New({
					mediator = SpWeaponInfoMediator,
					viewComponent = SpWeaponInfoLayer,
					data = {
						spWeaponConfigId = arg2_40:getConfig("id"),
						type = SpWeaponInfoLayer.TYPE_DISPLAY,
						onRemoved = arg3_40
					}
				}))
			elseif arg2_40.type == DROP_TYPE_EQUIPMENT_SKIN then
				arg0_40:addSubLayers(Context.New({
					mediator = EquipmentSkinMediator,
					viewComponent = EquipmentSkinLayer,
					data = {
						skinId = arg2_40:getConfig("id"),
						mode = EquipmentSkinLayer.DISPLAY
					}
				}))
			elseif arg2_40.type == DROP_TYPE_EMOJI then
				arg0_40:addSubLayers(Context.New({
					mediator = ContextMediator,
					viewComponent = EmojiInfoLayer,
					data = {
						id = arg2_40.cfg.id
					}
				}))
			elseif arg2_40.type == DROP_TYPE_COMBAT_UI_STYLE and not arg2_40.notPlay then
				arg0_40:addSubLayers(Context.New({
					mediator = CombatSkinInfoMediator,
					viewComponent = CombatSkinInfoLayer,
					data = {
						skinID = arg2_40:getConfig("id")
					}
				}))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = arg2_40,
					onNo = arg3_40,
					onYes = arg3_40
				})
			end
		end,
		[BaseUI.ON_DROP_LIST] = function(arg0_41, arg1_41, arg2_41)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_ITEM_BOX,
				items = arg2_41.itemList,
				content = arg2_41.content,
				item2Row = arg2_41.item2Row,
				itemFunc = function(arg0_42)
					arg0_41.viewComponent:emit(BaseUI.ON_DROP, arg0_42, function()
						arg0_41.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2_41)
					end)
				end
			})
		end,
		[BaseUI.ON_DROP_LIST_OWN] = function(arg0_44, arg1_44, arg2_44)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM_ESKIN,
				items = arg2_44.itemList,
				content = arg2_44.content,
				item2Row = arg2_44.item2Row,
				itemFunc = function(arg0_45)
					arg0_44.viewComponent:emit(BaseUI.ON_DROP, arg0_45, function()
						arg0_44.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2_44)
					end)
				end
			})
		end,
		[BaseUI.ON_ITEM] = function(arg0_47, arg1_47, arg2_47, arg3_47)
			arg0_47:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_47
					}),
					confirmCall = arg3_47
				}
			}))
		end,
		[BaseUI.ON_ITEM_EXTRA] = function(arg0_48, arg1_48, arg2_48, arg3_48)
			arg0_48:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2_48,
						extra = arg3_48
					})
				}
			}))
		end,
		[BaseUI.ON_SHIP] = function(arg0_49, arg1_49, arg2_49)
			arg0_49:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_SHIP,
						id = arg2_49
					})
				}
			}))
		end,
		[BaseUI.ON_EQUIPMENT] = function(arg0_50, arg1_50, arg2_50)
			arg2_50.type = defaultValue(arg2_50.type, EquipmentInfoMediator.TYPE_DEFAULT)

			arg0_50:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = arg2_50,
				onRemoved = arg2_50 and arg2_50.onRemoved or nil
			}))
		end,
		[BaseUI.ON_NEW_DROP] = function(arg0_51, arg1_51, arg2_51)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_DROP, arg2_51)
		end,
		[BaseUI.ON_NEW_STYLE_DROP] = function(arg0_52, arg1_52, arg2_52)
			local var0_52 = pg.NewStyleMsgboxMgr.TYPE_COMMON_DROP
			local var1_52 = arg2_52

			if arg2_52.useDeepShow then
				pg.NewStyleMsgboxMgr.GetInstance():DeepShow(var0_52, var1_52)
			else
				pg.NewStyleMsgboxMgr.GetInstance():Show(var0_52, var1_52)
			end
		end,
		[BaseUI.ON_NEW_STYLE_ITEMS] = function(arg0_53, arg1_53, arg2_53)
			local var0_53 = pg.NewStyleMsgboxMgr.TYPE_COMMON_ITEMS
			local var1_53 = setmetatable(arg2_53, {
				__index = {
					btnList = {
						{
							type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
							name = i18n("msgbox_text_confirm"),
							sound = SFX_CONFIRM
						}
					},
					items = arg2_53.itemList,
					content = arg2_53.content,
					itemFunc = function(arg0_54)
						arg0_53.viewComponent:emit(BaseUI.ON_NEW_STYLE_DROP, {
							useDeepShow = true,
							drop = arg0_54
						})
					end
				}
			})

			if arg2_53.useDeepShow then
				pg.NewStyleMsgboxMgr.GetInstance():DeepShow(var0_53, var1_53)
			else
				pg.NewStyleMsgboxMgr.GetInstance():Show(var0_53, var1_53)
			end
		end
	}

	for iter0_39, iter1_39 in pairs(var0_0.CommonBindDic) do
		arg0_39:bind(iter0_39, function(...)
			return iter1_39(arg0_39, ...)
		end)
	end
end

function var0_0.register(arg0_56)
	return
end

function var0_0.onUIAvalible(arg0_57)
	return
end

function var0_0.setContextData(arg0_58, arg1_58)
	arg0_58.contextData = arg1_58
end

function var0_0.bind(arg0_59, arg1_59, arg2_59)
	arg0_59.viewComponent.event:connect(arg1_59, arg2_59)
	table.insert(arg0_59.event, {
		event = arg1_59,
		callback = arg2_59
	})
end

function var0_0.onRemove(arg0_60)
	arg0_60:remove()

	for iter0_60, iter1_60 in ipairs(arg0_60.event) do
		arg0_60.viewComponent.event:disconnect(iter1_60.event, iter1_60.callback)
	end

	arg0_60.event = {}
end

function var0_0.remove(arg0_61)
	return
end

function var0_0.addSubLayers(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62)
	assert(isa(arg1_62, Context), "should be an instance of Context")

	local var0_62 = arg0_62:GetContext()

	if arg2_62 then
		while var0_62.parent do
			var0_62 = var0_62.parent
		end
	end

	local var1_62 = {
		parentContext = var0_62,
		context = arg1_62,
		callback = arg3_62
	}

	var1_62 = arg4_62 and table.merge(var1_62, arg4_62) or var1_62

	arg0_62:sendNotification(GAME.LOAD_LAYERS, var1_62)
end

function var0_0.GetContext(arg0_63)
	return getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_63.class)
end

function var0_0.blockEvents(arg0_64)
	if arg0_64.event then
		for iter0_64, iter1_64 in ipairs(arg0_64.event) do
			arg0_64.viewComponent.event:block(iter1_64.event, iter1_64.callback)
		end
	end
end

function var0_0.unblockEvents(arg0_65)
	if arg0_65.event then
		for iter0_65, iter1_65 in ipairs(arg0_65.event) do
			arg0_65.viewComponent.event:unblock(iter1_65.event, iter1_65.callback)
		end
	end
end

function var0_0.onBackPressed(arg0_66, arg1_66)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0_66 = getProxy(ContextProxy)

	if arg1_66 then
		local var1_66 = var0_66:getContextByMediator(arg0_66.class).parent

		if var1_66 then
			local var2_66 = pg.m02:retrieveMediator(var1_66.mediator.__cname)

			if var2_66 and var2_66.viewComponent then
				var2_66.viewComponent:onBackPressed()
			end
		end
	else
		arg0_66.viewComponent:closeView()
	end
end

function var0_0.removeSubLayers(arg0_67, arg1_67, arg2_67)
	assert(isa(arg1_67, var0_0), "should be a ContextMediator Class")

	local var0_67 = getProxy(ContextProxy):getContextByMediator(arg0_67.class or arg0_67)

	if not var0_67 then
		return
	end

	local var1_67 = var0_67:getContextByMediator(arg1_67)

	if not var1_67 then
		return
	end

	arg0_67:sendNotification(GAME.REMOVE_LAYERS, {
		context = var1_67,
		callback = arg2_67
	})
end

return var0_0
