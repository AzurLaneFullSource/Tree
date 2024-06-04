local var0 = class("PrayPoolMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(PrayPoolConst.CLICK_INDEX_BTN, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(PrayPoolConst.CLICK_BUILD_BTN, function(arg0, arg1)
		arg0:sendNotification(PrayPoolConst.BUILD_PRAY_POOL_CMD, arg1)
	end)
	arg0:bind(PrayPoolConst.START_BUILD_SHIP_EVENT, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			buildId = arg1,
			activity_id = ActivityConst.ACTIVITY_PRAY_POOL,
			arg1 = arg2,
			arg2 = arg3
		})
	end)

	local var0 = getProxy(ActivityProxy)
	local var1 = getProxy(PrayProxy)

	if var1:getPageState() ~= PrayProxy.STAGE_BUILD_SUCCESS then
		local var2 = var0:getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

		if var2 then
			local var3 = var2:getData1()
			local var4 = var2:getData1List()

			if var3 and table.indexof(pg.activity_ship_create.all, var3, 1) then
				var1:setSelectedPoolNum(var3)
				var1:setSelectedShipList(var4)
				var1:updatePageState(PrayProxy.STAGE_BUILD_SUCCESS)
			end
		end
	end
end

function var0.listNotificationInterests(arg0)
	return {
		PrayPoolConst.BUILD_PRAY_POOL_SUCCESS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PrayPoolConst.BUILD_PRAY_POOL_SUCCESS then
		arg0.viewComponent:switchPage(var1)
	end
end

return var0
