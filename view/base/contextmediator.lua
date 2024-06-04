local var0 = class("ContextMediator", pm.Mediator)

function var0.Ctor(arg0, arg1)
	arg0:initNotificationHandleDic()
	var0.super.Ctor(arg0, nil, arg1)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic, arg0.handleElse = nil
end

function var0.listNotificationInterests(arg0)
	if arg0.handleDic then
		return underscore.keys(arg0.handleDic)
	else
		return var0.super.listNotificationInterests(arg0)
	end
end

function var0.handleNotification(arg0, arg1)
	if arg0.handleDic then
		switch(arg1:getName(), arg0.handleDic, arg0.handleElse, arg0, arg1)
	else
		var0.super.handleNotification(arg0, arg1)
	end
end

function var0.onRegister(arg0)
	arg0.event = {}

	arg0:bind(BaseUI.ON_BACK_PRESSED, function(arg0, arg1)
		arg0:onBackPressed(arg1)
	end)
	arg0:bind(BaseUI.AVALIBLE, function(arg0, arg1)
		arg0:onUIAvalible()
	end)
	arg0:bind(BaseUI.ON_BACK, function(arg0, arg1, arg2)
		if arg2 and arg2 > 0 then
			pg.UIMgr.GetInstance():LoadingOn(false)
			LeanTween.delayedCall(arg2, System.Action(function()
				pg.UIMgr.GetInstance():LoadingOff()
				arg0:sendNotification(GAME.GO_BACK, nil, arg1)
			end))
		else
			arg0:sendNotification(GAME.GO_BACK, nil, arg1)
		end
	end)
	arg0:bind(BaseUI.ON_RETURN, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_BACK, arg1)
	end)
	arg0:bind(BaseUI.ON_HOME, function(arg0)
		local var0 = getProxy(ContextProxy):getCurrentContext()

		if var0.mediator == NewMainMediator then
			for iter0 = #var0.children, 1, -1 do
				local var1 = var0.children[iter0]

				arg0:sendNotification(GAME.REMOVE_LAYERS, {
					context = var1
				})
			end

			return
		end

		local var2 = var0:retriveLastChild()

		if var2 and var2 ~= var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				onHome = true,
				context = var2
			})
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	end)
	arg0:bind(BaseUI.ON_CLOSE, function(arg0)
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0.class)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end)
	arg0:bind(BaseUI.ON_AWARD, function(arg0, arg1)
		local var0 = {}

		if _.all(arg1.items, function(arg0)
			return arg0.type == DROP_TYPE_ICON_FRAME or arg0.type == DROP_TYPE_CHAT_FRAME
		end) then
			table.insert(var0, function(arg0)
				onNextTick(arg0)
			end)
		else
			table.insert(var0, function(arg0)
				arg0:addSubLayers(Context.New({
					mediator = AwardInfoMediator,
					viewComponent = AwardInfoLayer,
					data = setmetatable({
						removeFunc = arg0
					}, {
						__index = arg1
					})
				}))
			end)
		end

		seriesAsync(var0, arg1.removeFunc)
	end)

	local function var0(arg0, arg1)
		local var0 = getProxy(BayProxy)
		local var1 = var0:getNewShip(true)
		local var2 = {}

		for iter0, iter1 in pairs(var1) do
			if iter1:isMetaShip() then
				table.insert(var2, iter1.configId)
			end
		end

		local var3 = #var1

		underscore.each(arg0, function(arg0)
			if arg0.type == DROP_TYPE_OPERATION then
				table.insert(var1, var0:getShipById(arg0.count))
			elseif arg0.type == DROP_TYPE_SHIP then
				local var0 = arg0.configId or arg0.id

				if Ship.isMetaShipByConfigID(var0) then
					local var1 = table.indexof(var2, var0)

					if var1 then
						table.remove(var2, var1)

						var3 = var3 - 1
					else
						local var2 = Ship.New({
							configId = var0
						})
						local var3 = getProxy(BayProxy):getMetaTransItemMap(var2.configId)

						if var3 then
							var2:setReMetaSpecialItemVO(var3)
						end

						table.insert(var1, var2)
					end
				else
					var3 = var3 - 1
				end
			end
		end)

		var1 = underscore.rest(var1, var3 + 1)

		if (pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value or 20) >= #var1 then
			for iter2, iter3 in ipairs(var1) do
				table.insert(arg1, function(arg0)
					arg0:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = iter3
						},
						onRemoved = arg0
					}))
				end)
			end
		end
	end

	local function var1(arg0, arg1)
		for iter0, iter1 in pairs(arg0) do
			if iter1.type == DROP_TYPE_SKIN and pg.ship_skin_template[iter1.id].skin_type ~= ShipSkin.SKIN_TYPE_REMAKE and not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter1.id) then
				table.insert(arg1, function(arg0)
					arg0:addSubLayers(Context.New({
						mediator = NewSkinMediator,
						viewComponent = NewSkinLayer,
						data = {
							skinId = iter1.id,
							LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
						},
						onRemoved = arg0
					}))
				end)
			end

			if iter1.type == DROP_TYPE_SKIN_TIMELIMIT then
				if iter1.count > 0 and not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter1.id) then
					table.insert(arg1, function(arg0)
						arg0:addSubLayers(Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								timeLimit = true,
								skinId = iter1.id,
								LayerWeightMgr_weight = LayerWeightConst.SECOND_LAYER
							},
							onRemoved = arg0
						}))
					end)
				else
					table.insert(arg1, function(arg0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("already_have_the_skin"))
						arg0()
					end)
				end
			end
		end
	end

	local function var2(arg0, arg1)
		local var0 = 0

		for iter0, iter1 in ipairs(arg0) do
			if iter1.type == DROP_TYPE_COMMANDER_CAT then
				var0 = var0 + 1
			end
		end

		if var0 == 0 then
			return
		end

		local var1 = getProxy(CommanderProxy):GetNewestCommander(var0)

		for iter2, iter3 in ipairs(var1) do
			table.insert(arg1, function(arg0)
				arg0:addSubLayers(Context.New({
					viewComponent = NewCommanderScene,
					mediator = NewCommanderMediator,
					data = {
						commander = iter3,
						onExit = arg0
					}
				}))
			end)
		end
	end

	arg0:bind(BaseUI.ON_ACHIEVE, function(arg0, arg1, arg2)
		local var0 = {}

		if #arg1 > 0 then
			table.insert(var0, function(arg0)
				arg0.viewComponent:emit(BaseUI.ON_AWARD, {
					items = arg1,
					removeFunc = arg0
				})
			end)
			table.insert(var0, function(arg0)
				var0(arg1, var0)
				var1(arg1, var0)
				var2(arg1, var0)
				arg0()
			end)
		end

		seriesAsyncExtend(var0, arg2)
	end)
	arg0:bind(BaseUI.ON_WORLD_ACHIEVE, function(arg0, arg1)
		local var0 = {}
		local var1 = arg1.items

		if #var1 > 0 then
			table.insert(var0, function(arg0)
				arg0.viewComponent:emit(BaseUI.ON_AWARD, setmetatable({
					removeFunc = arg0
				}, {
					__index = arg1
				}))
			end)
			table.insert(var0, function(arg0)
				var0(var1, var0)
				var1(var1, var0)
				var2(var1, var0)
				arg0()
			end)
		end

		seriesAsyncExtend(var0, arg1.removeFunc)
	end)
	arg0:bind(BaseUI.ON_SHIP_EXP, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = ShipExpMediator,
			viewComponent = ShipExpLayer,
			data = arg1,
			onRemoved = arg2
		}))
	end)
	arg0:bind(BaseUI.ON_SPWEAPON, function(arg0, arg1)
		arg1.type = defaultValue(arg1.type, SpWeaponInfoLayer.TYPE_DEFAULT)

		arg0:addSubLayers(Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = arg1
		}))
	end)
	arg0:commonBind()
	arg0:register()
end

function var0.commonBind(arg0)
	var0.CommonBindDic = var0.CommonBindDic or {
		[BaseUI.ON_DROP] = function(arg0, arg1, arg2, arg3)
			if arg2.type == DROP_TYPE_EQUIP then
				arg0:addSubLayers(Context.New({
					mediator = EquipmentInfoMediator,
					viewComponent = EquipmentInfoLayer,
					data = {
						equipmentId = arg2:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						onRemoved = arg3,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2.type == DROP_TYPE_SPWEAPON then
				arg0:addSubLayers(Context.New({
					mediator = SpWeaponInfoMediator,
					viewComponent = SpWeaponInfoLayer,
					data = {
						spWeaponConfigId = arg2:getConfig("id"),
						type = SpWeaponInfoLayer.TYPE_DISPLAY,
						onRemoved = arg3,
						LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2.type == DROP_TYPE_EQUIPMENT_SKIN then
				arg0:addSubLayers(Context.New({
					mediator = EquipmentSkinMediator,
					viewComponent = EquipmentSkinLayer,
					data = {
						skinId = arg2:getConfig("id"),
						mode = EquipmentSkinLayer.DISPLAY,
						weight = LayerWeightConst.TOP_LAYER
					}
				}))
			elseif arg2.type == DROP_TYPE_EMOJI then
				arg0:addSubLayers(Context.New({
					mediator = ContextMediator,
					viewComponent = EmojiInfoLayer,
					data = {
						id = arg2.cfg.id
					}
				}))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = arg2,
					onNo = arg3,
					onYes = arg3,
					weight = LayerWeightConst.TOP_LAYER
				})
			end
		end,
		[BaseUI.ON_DROP_LIST] = function(arg0, arg1, arg2)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_ITEM_BOX,
				items = arg2.itemList,
				content = arg2.content,
				item2Row = arg2.item2Row,
				itemFunc = function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_DROP, arg0, function()
						arg0.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2)
					end)
				end,
				weight = LayerWeightConst.TOP_LAYER
			})
		end,
		[BaseUI.ON_DROP_LIST_OWN] = function(arg0, arg1, arg2)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM_ESKIN,
				items = arg2.itemList,
				content = arg2.content,
				item2Row = arg2.item2Row,
				itemFunc = function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_DROP, arg0, function()
						arg0.viewComponent:emit(BaseUI.ON_DROP_LIST, arg2)
					end)
				end,
				weight = LayerWeightConst.TOP_LAYER
			})
		end,
		[BaseUI.ON_ITEM] = function(arg0, arg1, arg2, arg3)
			arg0:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2
					}),
					confirmCall = arg3
				}
			}))
		end,
		[BaseUI.ON_ITEM_EXTRA] = function(arg0, arg1, arg2, arg3)
			arg0:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_ITEM,
						id = arg2,
						extra = arg3
					})
				}
			}))
		end,
		[BaseUI.ON_SHIP] = function(arg0, arg1, arg2)
			arg0:addSubLayers(Context.New({
				mediator = ItemInfoMediator,
				viewComponent = ItemInfoLayer,
				data = {
					drop = Drop.New({
						type = DROP_TYPE_SHIP,
						id = arg2
					})
				}
			}))
		end,
		[BaseUI.ON_EQUIPMENT] = function(arg0, arg1, arg2)
			arg2.type = defaultValue(arg2.type, EquipmentInfoMediator.TYPE_DEFAULT)

			arg0:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = arg2
			}))
		end
	}

	for iter0, iter1 in pairs(var0.CommonBindDic) do
		arg0:bind(iter0, function(...)
			return iter1(arg0, ...)
		end)
	end
end

function var0.register(arg0)
	return
end

function var0.onUIAvalible(arg0)
	return
end

function var0.setContextData(arg0, arg1)
	arg0.contextData = arg1
end

function var0.bind(arg0, arg1, arg2)
	arg0.viewComponent.event:connect(arg1, arg2)
	table.insert(arg0.event, {
		event = arg1,
		callback = arg2
	})
end

function var0.onRemove(arg0)
	arg0:remove()

	for iter0, iter1 in ipairs(arg0.event) do
		arg0.viewComponent.event:disconnect(iter1.event, iter1.callback)
	end

	arg0.event = {}
end

function var0.remove(arg0)
	return
end

function var0.addSubLayers(arg0, arg1, arg2, arg3, arg4)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = arg0:GetContext()

	if arg2 then
		while var0.parent do
			var0 = var0.parent
		end
	end

	local var1 = {
		parentContext = var0,
		context = arg1,
		callback = arg3
	}

	var1 = arg4 and table.merge(var1, arg4) or var1

	arg0:sendNotification(GAME.LOAD_LAYERS, var1)
end

function var0.switchLayersOnParent(arg0, arg1, arg2)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = arg0:GetContext()
	local var1 = var0.parent

	if not arg1.data.isSubView then
		while var1.data.isSubView do
			var1 = var1.parent
		end
	end

	local var2 = {
		parentContext = var1,
		context = arg1,
		removeContexts = {
			var0
		}
	}

	var2 = arg2 and table.merge(var2, arg2) or var2

	arg0:sendNotification(GAME.LOAD_LAYERS, var2)
end

function var0.GetContext(arg0)
	return getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0.class)
end

function var0.blockEvents(arg0)
	if arg0.event then
		for iter0, iter1 in ipairs(arg0.event) do
			arg0.viewComponent.event:block(iter1.event, iter1.callback)
		end
	end
end

function var0.unblockEvents(arg0)
	if arg0.event then
		for iter0, iter1 in ipairs(arg0.event) do
			arg0.viewComponent.event:unblock(iter1.event, iter1.callback)
		end
	end
end

function var0.onBackPressed(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0 = getProxy(ContextProxy)

	if arg1 then
		local var1 = var0:getContextByMediator(arg0.class).parent

		if var1 then
			local var2 = pg.m02:retrieveMediator(var1.mediator.__cname)

			if var2 and var2.viewComponent then
				var2.viewComponent:onBackPressed()
			end
		end
	else
		arg0.viewComponent:closeView()
	end
end

function var0.removeSubLayers(arg0, arg1, arg2)
	assert(isa(arg1, var0), "should be a ContextMediator Class")

	local var0 = getProxy(ContextProxy):getContextByMediator(arg0.class or arg0)

	if not var0 then
		return
	end

	local var1 = var0:getContextByMediator(arg1)

	if not var1 then
		return
	end

	arg0:sendNotification(GAME.REMOVE_LAYERS, {
		context = var1,
		callback = arg2
	})
end

return var0
