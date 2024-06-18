local var0_0 = class("PrayPoolMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(PrayPoolConst.CLICK_INDEX_BTN, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_2
		}))
	end)
	arg0_1:bind(PrayPoolConst.CLICK_BUILD_BTN, function(arg0_3, arg1_3)
		arg0_1:sendNotification(PrayPoolConst.BUILD_PRAY_POOL_CMD, arg1_3)
	end)
	arg0_1:bind(PrayPoolConst.START_BUILD_SHIP_EVENT, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			buildId = arg1_4,
			activity_id = ActivityConst.ACTIVITY_PRAY_POOL,
			arg1 = arg2_4,
			arg2 = arg3_4
		})
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = getProxy(PrayProxy)

	if var1_1:getPageState() ~= PrayProxy.STAGE_BUILD_SUCCESS then
		local var2_1 = var0_1:getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

		if var2_1 then
			local var3_1 = var2_1:getData1()
			local var4_1 = var2_1:getData1List()

			if var3_1 and table.indexof(pg.activity_ship_create.all, var3_1, 1) then
				var1_1:setSelectedPoolNum(var3_1)
				var1_1:setSelectedShipList(var4_1)
				var1_1:updatePageState(PrayProxy.STAGE_BUILD_SUCCESS)
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		PrayPoolConst.BUILD_PRAY_POOL_SUCCESS
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == PrayPoolConst.BUILD_PRAY_POOL_SUCCESS then
		arg0_6.viewComponent:switchPage(var1_6)
	end
end

return var0_0
