local var0 = class("BuildShipMediator", import("...base.ContextMediator"))

var0.OPEN_DESTROY = "BuildShipMediator OPEN_CHUANWUSTART"
var0.OPEN_START_PROJECT = "BuildShipMediator OPEN_START_PROJECT"
var0.ACTIVITY_OPERATION = "BuildShipMediator ACTIVITY_OPERATION"
var0.OPEN_PROJECT_LIST = "BuildShipMediator OPEN_PROJECT_LIST"
var0.REMOVE_PROJECT_LIST = "BuildShipMediator REMOVE_PROJECT_LIST"
var0.ON_BUILD = "BuildShipMediator ON_BUILD"
var0.ACT_ON_BUILD = "BuildShipMediator ACT_ON_BUILD"
var0.ON_UPDATE_ACT = "BuildShipMediator ON_UPDATE_ACT"
var0.ON_UPDATE_FREE_BUILD_ACT = "BuildShipMediator ON_UPDATE_FREE_BUILD_ACT"
var0.SIMULATION_BATTLE = "BuildShipMediator SIMULATION_BATTLE"
var0.ON_SUPPORT_SHOP = "BuildShipMediator ON_SUPPORT_SHOP"
var0.OPEN_PRAY_PAGE = "BuildShipMediator OPEN_PRAY_PAGE"
var0.CLOSE_PRAY_PAGE = "BuildShipMediator CLOSE_PRAY_PAGE"
var0.ON_BUILDPOOL_EXCHANGE = "BuildShipMediator:ON_BUILDPOOL_EXCHANGE"
var0.ON_BUILDPOOL_UR_EXCHANGE = "BuildShipMediator.ON_BUILDPOOL_UR_EXCHANGE"
var0.ON_SUPPORT_EXCHANGE = "BuildShipMediator:ON_SUPPORT_EXCHANGE"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)

	local var1 = getProxy(BagProxy)

	arg0.useItem = pg.ship_data_create_material[1].use_item

	local var2 = var1:getItemById(arg0.useItem)

	arg0.viewComponent:setUseItem(var2)

	local var3 = getProxy(BayProxy):getShipById(var0.character)

	arg0.viewComponent:setFlagShip(var3)

	local var4 = getProxy(BuildShipProxy)
	local var5 = var4:getRawData()

	arg0.viewComponent:setStartCount(table.getCount(var5))
	arg0:bind(var0.ON_SUPPORT_SHOP, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_MEDAL
		})
	end)
	arg0:bind(var0.OPEN_DESTROY, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			blockLock = true,
			mode = DockyardScene.MODE_DESTROY,
			selectedMax = getGameset("ship_select_limit")[1],
			leftTopInfo = i18n("word_destroy"),
			onShip = ShipStatus.canDestroyShip,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			preView = arg0.viewComponent.__cname
		})
	end)
	arg0:bind(var0.OPEN_PROJECT_LIST, function(arg0)
		if arg0.facade:hasMediator(BuildShipDetailMediator.__cname) then
			return
		end

		arg0:addSubLayers(Context.New({
			mediator = BuildShipDetailMediator,
			viewComponent = BuildShipDetailLayer,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
			}
		}))
	end)
	arg0:bind(var0.REMOVE_PROJECT_LIST, function(arg0)
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BuildShipDetailMediator)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end)
	arg0:bind(var0.ON_BUILD, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.BUILD_SHIP, {
			buildId = arg1,
			count = arg2,
			isTicket = arg3
		})
	end)
	arg0:bind(var0.ACT_ON_BUILD, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1,
			arg1 = arg3,
			arg2 = arg4 and 1 or 0,
			buildId = arg2
		})
	end)
	arg0:bind(var0.ON_SUPPORT_EXCHANGE, function(arg0, arg1)
		arg0:sendNotification(GAME.SUPPORT_SHIP, {
			count = arg1
		})
	end)
	arg0:bind(var0.ON_UPDATE_ACT, function(arg0)
		arg0.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())
		arg0.viewComponent:checkPage()
	end)
	arg0:bind(var0.OPEN_PRAY_PAGE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = PrayPoolMediator,
			viewComponent = PrayPoolScene,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
			}
		}))
	end)
	arg0:bind(var0.CLOSE_PRAY_PAGE, function(arg0)
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(PrayPoolMediator)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end)
	arg0:bind(var0.SIMULATION_BATTLE, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1
		})
	end)
	arg0:bind(var0.ON_BUILDPOOL_EXCHANGE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_BUILD_POOL_EXCHANGE, {
			activity_id = arg1
		})
	end)
	arg0:bind(var0.ON_BUILDPOOL_UR_EXCHANGE, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = BuildShipRegularExchangeLayer,
			mediator = BuildShipRegularExchangeMediator
		}))
	end)

	local var6 = var4:getFinishCount()

	arg0.viewComponent:updateQueueTip(var6)
	arg0.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())

	if arg0.contextData.goToPray == true then
		arg0.viewComponent:switchPage(arg0.viewComponent.PAGE_PRAY, true)
	end
end

function var0.buildFinishComeback(arg0)
	local var0 = getProxy(BuildShipProxy)

	if table.getCount(var0:getData()) == 0 and arg0.viewComponent then
		local var1 = BuildShip.getPageFromPoolType(var0:getLastBuildShipPoolType()) or BuildShipScene.PAGE_BUILD

		if var1 == BuildShipScene.PAGE_PRAY then
			local var2 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

			if not var2 or var2:isEnd() then
				var1 = BuildShipScene.PAGE_BUILD
			end
		end

		triggerToggle(arg0.viewComponent.toggles[var1], true)
	end
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.CONFIRM_GET_SHIP then
		local var2 = getProxy(BuildShipProxy)
		local var3 = var2:getFinishCount()

		arg0.viewComponent:updateQueueTip(var3)

		local var4 = {}

		if var1.isBatch then
			var2:setSkipBatchBuildFlag(false)

			local var5 = {}

			for iter0, iter1 in ipairs(var1.ships) do
				local var6 = {
					type = DROP_TYPE_SHIP,
					id = iter1.configId
				}

				var6.count = 1
				var6.virgin = iter1.virgin
				var6.reMetaSpecialItemVO = iter1:getReMetaSpecialItemVO()
				var5[#var5 + 1] = var6
			end

			if #var5 > 0 then
				table.insert(var4, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_AWARD, {
						items = var5,
						title = AwardInfoLayer.TITLE.SHIP,
						removeFunc = arg0
					})
				end)
			end
		end

		seriesAsync(var4, function()
			if var1.isBatch and var3 > 0 then
				NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)
			else
				arg0:buildFinishComeback()
			end
		end)
	elseif var0 == GAME.BUILD_SHIP_DONE then
		triggerToggle(arg0.viewComponent.toggles[BuildShipScene.PAGE_QUEUE], true)
	elseif var0 == BagProxy.ITEM_UPDATED then
		local var7 = getProxy(BagProxy):getItemById(arg0.useItem)

		arg0.viewComponent:setUseItem(var7)
	elseif var0 == BuildShipProxy.ADDED or var0 == BuildShipProxy.REMOVED then
		local var8 = getProxy(BuildShipProxy):getRawData()

		arg0.viewComponent:setStartCount(table.getCount(var8))
	elseif var0 == GAME.SUPPORT_SHIP_DONE then
		local var9 = {}

		for iter2, iter3 in ipairs(var1.ships) do
			if iter3.virgin or iter3:getRarity() >= 4 then
				table.insert(var9, function(arg0)
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

		seriesAsync(var9, function()
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = underscore.map(var1.ships, function(arg0)
					local var0 = Drop.New({
						count = 1,
						type = DROP_TYPE_SHIP,
						id = arg0.configId
					})

					var0.virgin = arg0.virgin

					return var0
				end),
				title = AwardInfoLayer.TITLE.SHIP,
				removeFunc = function()
					if arg0.viewComponent then
						arg0.viewComponent.supportShipPoolPage:UpdateMedal()
					end
				end
			})
		end)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		local var10 = var1

		if var10 then
			local var11 = var10:getConfig("type")

			if var11 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 then
				arg0.viewComponent:RefreshActivityBuildPool(var10)
			elseif var11 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD then
				local var12 = pg.ship_data_create_exchange[var10.id] or {}

				if var10.data2 < (var12.exchange_available_times or 0) then
					arg0.viewComponent:RefreshActivityBuildPool(var10)
				else
					arg0.viewComponent:setPools(getProxy(BuildShipProxy):GetPools())
					arg0.viewComponent:checkPage()
				end
			elseif var11 == ActivityConst.ACTIVITY_TYPE_BUILD_FREE then
				arg0.viewComponent:RefreshFreeBuildActivity()
			end
		end
	elseif var0 == BuildShipProxy.REGULAR_BUILD_POOL_COUNT_UPDATE then
		arg0.viewComponent:RefreshRegularExchangeCount()
	elseif var0 == GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE or var0 == GAME.REGULAR_BUILD_POOL_EXCHANGE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	end
end

return var0
