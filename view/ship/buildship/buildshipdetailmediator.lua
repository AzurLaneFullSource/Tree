local var0 = class("BuildShipDetailMediator", import("...base.ContextMediator"))

var0.ON_QUICK = "BuildShipDetailMediator.ON_QUICK"
var0.LAUNCH_ALL = "BuildShipDetailMediator.LAUNCH_ALL"
var0.ON_LAUNCHED = "BuildShipDetailMediator.ON_LAUNCHED"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:updatePlayer(var0:getData())

	arg0.bagProxy = getProxy(BagProxy)

	arg0.viewComponent:setItems(arg0.bagProxy:getData())

	local var1 = getProxy(BuildShipProxy)

	arg0.viewComponent:setProjectList(var1:getData())
	arg0.viewComponent:setWorkCount(var1:getMaxWorkCount())

	local var2 = getProxy(SettingsProxy)

	arg0:bind(var0.ON_QUICK, function(arg0, arg1, arg2)
		if arg2 then
			var2:setStopBuildSpeedupRemind()
			arg0.viewComponent:setBuildSpeedUpRemind(true)
		end

		arg0.isBatch = false

		arg0:GetShipProcess({
			arg1
		})
	end)
	arg0:bind(var0.ON_LAUNCHED, function(arg0, arg1)
		arg0.isBatch = false

		arg0:GetShipProcess({
			arg1
		})
	end)
	arg0:bind(var0.LAUNCH_ALL, function(arg0, arg1)
		if arg1 then
			var2:setStopBuildSpeedupRemind()
			arg0.viewComponent:setBuildSpeedUpRemind(true)
		end

		arg0.isBatch = true

		local var0 = {}

		for iter0, iter1 in ipairs(var1:getData()) do
			table.insert(var0, iter0)
		end

		arg0:GetShipProcess(var0)
	end)

	local var3 = var2:getStopBuildSpeedupRemind()

	arg0.viewComponent:setBuildSpeedUpRemind(var3)
end

function var0.GetShipProcess(arg0, arg1)
	local var0 = getProxy(BuildShipProxy)
	local var1 = {}

	table.insert(var1, function(arg0)
		arg0:sendNotification(GAME.BUILD_SHIP_IMMEDIATELY, {
			pos_list = arg1,
			callback = arg0
		})
	end)
	seriesAsync(var1, function()
		if arg0.isBatch and underscore.any(arg1, function(arg0)
			return var0:getBuildShip(arg0).state ~= BuildShip.FINISH
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoLayer_error_noQuickItem"))
		end

		arg0:sendNotification(GAME.GET_SHIP, {
			pos_list = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.GET_SHIP_DONE,
		BuildShipProxy.REMOVED,
		BuildShipProxy.UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(arg0.bagProxy:getData())
		arg0.viewComponent:updateItem()
	elseif var0 == GAME.GET_SHIP_DONE then
		local var2 = getProxy(BuildShipProxy)

		arg0.viewComponent:setProjectList(var2:getData())
		arg0.viewComponent:initProjectList()

		local var3 = {}

		table.insert(var3, function(arg0)
			arg0.viewComponent:playGetShipAnimate(arg0, var1.type)
		end)

		for iter0, iter1 in ipairs(var1.ships) do
			table.insert(var3, function(arg0)
				local var0 = var2:getSkipBatchBuildFlag()

				if var0 and not iter1.virgin and iter1:getRarity() < 4 then
					arg0()
				else
					arg0:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = iter1,
							canSkipBatch = not var0 and iter0 < #var1.ships
						},
						onRemoved = arg0
					}))
				end
			end)
		end

		seriesAsync(var3, function()
			arg0:sendNotification(GAME.CONFIRM_GET_SHIP, {
				isBatch = arg0.isBatch,
				ships = var1.ships
			})
		end)
	elseif var0 == BuildShipProxy.UPDATED then
		arg0.viewComponent:updateProject(var1.index, var1.buildShip)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updatePlayer(var1)
	end
end

return var0
