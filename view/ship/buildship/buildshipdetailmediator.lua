local var0_0 = class("BuildShipDetailMediator", import("...base.ContextMediator"))

var0_0.ON_QUICK = "BuildShipDetailMediator.ON_QUICK"
var0_0.LAUNCH_ALL = "BuildShipDetailMediator.LAUNCH_ALL"
var0_0.ON_LAUNCHED = "BuildShipDetailMediator.ON_LAUNCHED"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:updatePlayer(var0_1:getData())

	arg0_1.bagProxy = getProxy(BagProxy)

	arg0_1.viewComponent:setItems(arg0_1.bagProxy:getData())

	local var1_1 = getProxy(BuildShipProxy)

	arg0_1.viewComponent:setProjectList(var1_1:getData())
	arg0_1.viewComponent:setWorkCount(var1_1:getMaxWorkCount())

	local var2_1 = getProxy(SettingsProxy)

	arg0_1:bind(var0_0.ON_QUICK, function(arg0_2, arg1_2, arg2_2)
		if arg2_2 then
			var2_1:setStopBuildSpeedupRemind()
			arg0_1.viewComponent:setBuildSpeedUpRemind(true)
		end

		arg0_1.isBatch = false

		arg0_1:GetShipProcess({
			arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_LAUNCHED, function(arg0_3, arg1_3)
		arg0_1.isBatch = false

		arg0_1:GetShipProcess({
			arg1_3
		})
	end)
	arg0_1:bind(var0_0.LAUNCH_ALL, function(arg0_4, arg1_4)
		if arg1_4 then
			var2_1:setStopBuildSpeedupRemind()
			arg0_1.viewComponent:setBuildSpeedUpRemind(true)
		end

		arg0_1.isBatch = true

		local var0_4 = {}

		for iter0_4, iter1_4 in ipairs(var1_1:getData()) do
			table.insert(var0_4, iter0_4)
		end

		arg0_1:GetShipProcess(var0_4)
	end)

	local var3_1 = var2_1:getStopBuildSpeedupRemind()

	arg0_1.viewComponent:setBuildSpeedUpRemind(var3_1)
end

function var0_0.GetShipProcess(arg0_5, arg1_5)
	local var0_5 = getProxy(BuildShipProxy)
	local var1_5 = {}

	table.insert(var1_5, function(arg0_6)
		arg0_5:sendNotification(GAME.BUILD_SHIP_IMMEDIATELY, {
			pos_list = arg1_5,
			callback = arg0_6
		})
	end)
	seriesAsync(var1_5, function()
		if arg0_5.isBatch and underscore.any(arg1_5, function(arg0_8)
			return var0_5:getBuildShip(arg0_8).state ~= BuildShip.FINISH
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoLayer_error_noQuickItem"))
		end

		arg0_5:sendNotification(GAME.GET_SHIP, {
			pos_list = arg1_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.GET_SHIP_DONE,
		BuildShipProxy.REMOVED,
		BuildShipProxy.UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == BagProxy.ITEM_UPDATED then
		arg0_10.viewComponent:setItems(arg0_10.bagProxy:getData())
		arg0_10.viewComponent:updateItem()
	elseif var0_10 == GAME.GET_SHIP_DONE then
		local var2_10 = getProxy(BuildShipProxy)

		arg0_10.viewComponent:setProjectList(var2_10:getData())
		arg0_10.viewComponent:initProjectList()

		local var3_10 = {}

		table.insert(var3_10, function(arg0_11)
			arg0_10.viewComponent:playGetShipAnimate(arg0_11, var1_10.type)
		end)

		for iter0_10, iter1_10 in ipairs(var1_10.ships) do
			table.insert(var3_10, function(arg0_12)
				local var0_12 = var2_10:getSkipBatchBuildFlag()

				if var0_12 and not iter1_10.virgin and iter1_10:getRarity() < 4 then
					arg0_12()
				else
					arg0_10:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = iter1_10,
							canSkipBatch = not var0_12 and iter0_10 < #var1_10.ships
						},
						onRemoved = arg0_12
					}))
				end
			end)
		end

		seriesAsync(var3_10, function()
			arg0_10:sendNotification(GAME.CONFIRM_GET_SHIP, {
				isBatch = arg0_10.isBatch,
				ships = var1_10.ships
			})
		end)
	elseif var0_10 == BuildShipProxy.UPDATED then
		arg0_10.viewComponent:updateProject(var1_10.index, var1_10.buildShip)
	elseif var0_10 == PlayerProxy.UPDATED then
		arg0_10.viewComponent:updatePlayer(var1_10)
	end
end

return var0_0
