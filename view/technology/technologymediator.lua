local var0_0 = class("TechnologyMediator", import("..base.ContextMediator"))

var0_0.ON_START = "TechnologyMediator:ON_START"
var0_0.ON_FINISHED = "TechnologyMediator:ON_FINISHED"
var0_0.ON_REFRESH = "TechnologyMediator:ON_REFRESH"
var0_0.ON_STOP = "TechnologyMediator:ON_STOP"
var0_0.ON_JOIN_QUEUE = "TechnologyMediator:ON_JOIN_QUEUE"
var0_0.ON_FINISH_QUEUE = "TechnologyMediator:ON_FINISH_QUEUE"
var0_0.ON_CLICK_SETTINGS_BTN = "TechnologyMediator:ON_CLICK_SETTINGS_BTN"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_START, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.START_TECHNOLOGY, {
			id = arg1_2.id,
			pool_id = arg1_2.pool_id
		})
	end)
	arg0_1:bind(var0_0.ON_FINISHED, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1_3.id,
			pool_id = arg1_3.pool_id
		})
	end)
	arg0_1:bind(var0_0.ON_REFRESH, function(arg0_4)
		arg0_1:sendNotification(GAME.REFRESH_TECHNOLOGYS)
	end)
	arg0_1:bind(var0_0.ON_STOP, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.STOP_TECHNOLOGY, {
			id = arg1_5.id,
			pool_id = arg1_5.pool_id
		})
	end)
	arg0_1:bind(var0_0.ON_JOIN_QUEUE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.JOIN_QUEUE_TECHNOLOGY, {
			id = arg1_6.id,
			pool_id = arg1_6.pool_id
		})
	end)
	arg0_1:bind(var0_0.ON_FINISH_QUEUE, function(arg0_7)
		arg0_1:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.ON_CLICK_SETTINGS_BTN, function(arg0_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = TechnologySettingsLayer,
			mediator = TechnologySettingsMediator
		}))
	end)

	local var0_1 = getProxy(TechnologyProxy)

	arg0_1.viewComponent:setTechnologys(var0_1:getTechnologys(), var0_1.queue)
	arg0_1.viewComponent:setRefreshFlag(var0_1.refreshTechnologysFlag)

	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var1_1)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.FINISH_TECHNOLOGY_DONE,
		GAME.REFRESH_TECHNOLOGYS_DONE,
		GAME.JOIN_QUEUE_TECHNOLOGY_DONE,
		GAME.FINISH_QUEUE_TECHNOLOGY_DONE,
		TechnologyProxy.TECHNOLOGY_UPDATED,
		TechnologyProxy.REFRESH_UPDATED,
		PlayerProxy.UPDATED,
		TechnologySettingsMediator.EXIT_CALL
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getBody()
	local var1_10 = arg1_10:getName()

	if var1_10 == TechnologyProxy.TECHNOLOGY_UPDATED then
		arg0_10.viewComponent:updateTechnology(var0_10)
	elseif var1_10 == GAME.FINISH_TECHNOLOGY_DONE then
		if #var0_10.items > 0 then
			arg0_10.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var0_10.items
			})
		end

		arg0_10:onRefresh()
	elseif var1_10 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		local var2_10 = {}

		for iter0_10, iter1_10 in ipairs(var0_10.dropInfos) do
			if #iter1_10 > 0 then
				table.insert(var2_10, function(arg0_11)
					arg0_10.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1_10,
						removeFunc = arg0_11
					})
				end)
			end
		end

		seriesAsync(var2_10, function()
			return
		end)
		arg0_10:onRefresh()
	elseif var1_10 == GAME.REFRESH_TECHNOLOGYS_DONE then
		arg0_10:onRefresh()
	elseif var1_10 == GAME.JOIN_QUEUE_TECHNOLOGY_DONE then
		arg0_10:onRefresh()
	elseif var1_10 == TechnologyProxy.REFRESH_UPDATED then
		arg0_10.viewComponent:setRefreshFlag(var0_10)
		arg0_10.viewComponent:updateRefreshBtn(var0_10)
	elseif var1_10 == PlayerProxy.UPDATED then
		arg0_10.viewComponent:setPlayer(var0_10)
	elseif var1_10 == TechnologySettingsMediator.EXIT_CALL then
		arg0_10.viewComponent:updatePickUpVersionChange()
	end
end

function var0_0.onRefresh(arg0_13)
	arg0_13.viewComponent:clearTimer()
	arg0_13.viewComponent:cancelSelected()

	local var0_13 = getProxy(TechnologyProxy)

	arg0_13.viewComponent:setTechnologys(var0_13:getTechnologys(), var0_13.queue)
	arg0_13.viewComponent:initTechnologys()
	arg0_13.viewComponent:initQueue()
	arg0_13.viewComponent:updateSettingsBtn()
end

return var0_0
