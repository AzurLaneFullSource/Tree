local var0_0 = class("BuildShipMediator", import("...base.ContextMediator"))

var0_0.OPEN_DESTROY = "BuildShipMediator OPEN_CHUANWUSTART"
var0_0.OPEN_START_PROJECT = "BuildShipMediator OPEN_START_PROJECT"
var0_0.ACTIVITY_OPERATION = "BuildShipMediator ACTIVITY_OPERATION"
var0_0.OPEN_PROJECT_LIST = "BuildShipMediator OPEN_PROJECT_LIST"
var0_0.REMOVE_PROJECT_LIST = "BuildShipMediator REMOVE_PROJECT_LIST"
var0_0.ON_BUILD = "BuildShipMediator ON_BUILD"
var0_0.ACT_ON_BUILD = "BuildShipMediator ACT_ON_BUILD"
var0_0.ON_UPDATE_ACT = "BuildShipMediator ON_UPDATE_ACT"
var0_0.ON_UPDATE_FREE_BUILD_ACT = "BuildShipMediator ON_UPDATE_FREE_BUILD_ACT"
var0_0.SIMULATION_BATTLE = "BuildShipMediator SIMULATION_BATTLE"
var0_0.ON_SUPPORT_SHOP = "BuildShipMediator ON_SUPPORT_SHOP"
var0_0.OPEN_PRAY_PAGE = "BuildShipMediator OPEN_PRAY_PAGE"
var0_0.CLOSE_PRAY_PAGE = "BuildShipMediator CLOSE_PRAY_PAGE"
var0_0.ON_BUILDPOOL_EXCHANGE = "BuildShipMediator:ON_BUILDPOOL_EXCHANGE"
var0_0.ON_BUILDPOOL_UR_EXCHANGE = "BuildShipMediator.ON_BUILDPOOL_UR_EXCHANGE"
var0_0.ON_SUPPORT_EXCHANGE = "BuildShipMediator:ON_SUPPORT_EXCHANGE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(BagProxy)

	arg0_1.useItem = pg.ship_data_create_material[1].use_item

	local var2_1 = var1_1:getItemById(arg0_1.useItem)

	arg0_1.viewComponent:setUseItem(var2_1)

	local var3_1 = getProxy(BayProxy):getShipById(var0_1.character)

	arg0_1.viewComponent:setFlagShip(var3_1)

	local var4_1 = getProxy(BuildShipProxy)
	local var5_1 = var4_1:getRawData()

	arg0_1.viewComponent:setStartCount(table.getCount(var5_1))
	arg0_1:bind(var0_0.ON_SUPPORT_SHOP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_MEDAL
		})
	end)
	arg0_1:bind(var0_0.OPEN_DESTROY, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			blockLock = true,
			mode = DockyardScene.MODE_DESTROY,
			selectedMax = getGameset("ship_select_limit")[1],
			leftTopInfo = i18n("word_destroy"),
			onShip = ShipStatus.canDestroyShip,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			preView = arg0_1.viewComponent.__cname
		})
	end)
	arg0_1:bind(var0_0.OPEN_PROJECT_LIST, function(arg0_4)
		if arg0_1.facade:hasMediator(BuildShipDetailMediator.__cname) then
			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = BuildShipDetailMediator,
			viewComponent = BuildShipDetailLayer,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
			}
		}))
	end)
	arg0_1:bind(var0_0.REMOVE_PROJECT_LIST, function(arg0_5)
		local var0_5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BuildShipDetailMediator)

		if var0_5 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_5
			})
		end
	end)
	arg0_1:bind(var0_0.ON_BUILD, function(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_1:sendNotification(GAME.BUILD_SHIP, {
			buildId = arg1_6,
			count = arg2_6,
			isTicket = arg3_6
		})
	end)
	arg0_1:bind(var0_0.ACT_ON_BUILD, function(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1_7,
			arg1 = arg3_7,
			arg2 = arg4_7 and 1 or 0,
			buildId = arg2_7
		})
	end)
	arg0_1:bind(var0_0.ON_SUPPORT_EXCHANGE, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.SUPPORT_SHIP, {
			count = arg1_8
		})
	end)
	arg0_1:bind(var0_0.ON_UPDATE_ACT, function(arg0_9)
		arg0_1.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())
		arg0_1.viewComponent:checkPage()
	end)
	arg0_1:bind(var0_0.OPEN_PRAY_PAGE, function(arg0_10)
		arg0_1:addSubLayers(Context.New({
			mediator = PrayPoolMediator,
			viewComponent = PrayPoolScene,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_PRAY_PAGE, function(arg0_11)
		local var0_11 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(PrayPoolMediator)

		if var0_11 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_11
			})
		end
	end)
	arg0_1:bind(var0_0.SIMULATION_BATTLE, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_12
		})
	end)
	arg0_1:bind(var0_0.ON_BUILDPOOL_EXCHANGE, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.ACTIVITY_BUILD_POOL_EXCHANGE, {
			activity_id = arg1_13
		})
	end)
	arg0_1:bind(var0_0.ON_BUILDPOOL_UR_EXCHANGE, function(arg0_14)
		arg0_1:addSubLayers(Context.New({
			viewComponent = BuildShipRegularExchangeLayer,
			mediator = BuildShipRegularExchangeMediator
		}))
	end)

	local var6_1 = var4_1:getFinishCount()

	arg0_1.viewComponent:updateQueueTip(var6_1)
	arg0_1.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())

	if arg0_1.contextData.goToPray == true then
		arg0_1.viewComponent:switchPage(arg0_1.viewComponent.PAGE_PRAY, true)
	end
end

function var0_0.buildFinishComeback(arg0_15)
	local var0_15 = getProxy(BuildShipProxy)

	if table.getCount(var0_15:getData()) == 0 and arg0_15.viewComponent then
		local var1_15 = BuildShip.getPageFromPoolType(var0_15:getLastBuildShipPoolType()) or BuildShipScene.PAGE_BUILD

		if var1_15 == BuildShipScene.PAGE_PRAY then
			local var2_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

			if not var2_15 or var2_15:isEnd() then
				var1_15 = BuildShipScene.PAGE_BUILD
			end
		end

		triggerToggle(arg0_15.viewComponent.toggles[var1_15], true)
	end
end

function var0_0.listNotificationInterests(arg0_16)
	return {
		GAME.BUILD_SHIP_DONE,
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		GAME.CONFIRM_GET_SHIP,
		BuildShipProxy.ADDED,
		BuildShipProxy.REMOVED,
		GAME.BEGIN_STAGE_DONE,
		GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE,
		GAME.REGULAR_BUILD_POOL_EXCHANGE_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUPPORT_SHIP_DONE,
		BuildShipProxy.REGULAR_BUILD_POOL_COUNT_UPDATE
	}
end

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()

	if var0_17 == PlayerProxy.UPDATED then
		arg0_17.viewComponent:setPlayer(var1_17)
	elseif var0_17 == GAME.CONFIRM_GET_SHIP then
		local var2_17 = getProxy(BuildShipProxy)
		local var3_17 = var2_17:getFinishCount()

		arg0_17.viewComponent:updateQueueTip(var3_17)

		local var4_17 = {}

		if var1_17.isBatch then
			var2_17:setSkipBatchBuildFlag(false)

			local var5_17 = {}

			for iter0_17, iter1_17 in ipairs(var1_17.ships) do
				local var6_17 = {
					type = DROP_TYPE_SHIP,
					id = iter1_17.configId
				}

				var6_17.count = 1
				var6_17.virgin = iter1_17.virgin
				var6_17.reMetaSpecialItemVO = iter1_17:getReMetaSpecialItemVO()
				var5_17[#var5_17 + 1] = var6_17
			end

			if #var5_17 > 0 then
				table.insert(var4_17, function(arg0_18)
					arg0_17.viewComponent:emit(BaseUI.ON_AWARD, {
						items = var5_17,
						title = AwardInfoLayer.TITLE.SHIP,
						removeFunc = arg0_18
					})
				end)
			end
		end

		seriesAsync(var4_17, function()
			if var1_17.isBatch and var3_17 > 0 then
				NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)
			else
				arg0_17:buildFinishComeback()
			end
		end)
	elseif var0_17 == GAME.BUILD_SHIP_DONE then
		triggerToggle(arg0_17.viewComponent.toggles[BuildShipScene.PAGE_QUEUE], true)
	elseif var0_17 == BagProxy.ITEM_UPDATED then
		local var7_17 = getProxy(BagProxy):getItemById(arg0_17.useItem)

		arg0_17.viewComponent:setUseItem(var7_17)
	elseif var0_17 == BuildShipProxy.ADDED or var0_17 == BuildShipProxy.REMOVED then
		local var8_17 = getProxy(BuildShipProxy):getRawData()

		arg0_17.viewComponent:setStartCount(table.getCount(var8_17))
	elseif var0_17 == GAME.SUPPORT_SHIP_DONE then
		local var9_17 = {}

		for iter2_17, iter3_17 in ipairs(var1_17.ships) do
			if iter3_17.virgin or iter3_17:getRarity() >= 4 then
				table.insert(var9_17, function(arg0_20)
					arg0_17:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = iter3_17
						},
						onRemoved = arg0_20
					}))
				end)
			end
		end

		seriesAsync(var9_17, function()
			arg0_17.viewComponent:emit(BaseUI.ON_AWARD, {
				items = underscore.map(var1_17.ships, function(arg0_22)
					local var0_22 = Drop.New({
						count = 1,
						type = DROP_TYPE_SHIP,
						id = arg0_22.configId
					})

					var0_22.virgin = arg0_22.virgin

					return var0_22
				end),
				title = AwardInfoLayer.TITLE.SHIP,
				removeFunc = function()
					if arg0_17.viewComponent then
						arg0_17.viewComponent.supportShipPoolPage:UpdateMedal()
					end
				end
			})
		end)
	elseif var0_17 == GAME.BEGIN_STAGE_DONE then
		arg0_17:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_17)
	elseif var0_17 == ActivityProxy.ACTIVITY_UPDATED then
		local var10_17 = var1_17

		if var10_17 then
			local var11_17 = var10_17:getConfig("type")

			if var11_17 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 then
				arg0_17.viewComponent:RefreshActivityBuildPool(var10_17)
			elseif var11_17 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				local var12_17 = pg.ship_data_create_exchange[var10_17.id] or {}

				if var10_17.data2 < (var12_17.exchange_available_times or 0) then
					arg0_17.viewComponent:RefreshActivityBuildPool(var10_17)
				else
					arg0_17.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())
					arg0_17.viewComponent:checkPage()
				end
			elseif var11_17 == ActivityConst.ACTIVITY_TYPE_BUILD_FREE then
				arg0_17.viewComponent:RefreshFreeBuildActivity()
			end
		end
	elseif var0_17 == BuildShipProxy.REGULAR_BUILD_POOL_COUNT_UPDATE then
		arg0_17.viewComponent:RefreshRegularExchangeCount()
	elseif var0_17 == GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE or var0_17 == GAME.REGULAR_BUILD_POOL_EXCHANGE_DONE then
		arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17.awards)
	end
end

return var0_0
