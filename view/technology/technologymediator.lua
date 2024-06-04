local var0 = class("TechnologyMediator", import("..base.ContextMediator"))

var0.ON_START = "TechnologyMediator:ON_START"
var0.ON_FINISHED = "TechnologyMediator:ON_FINISHED"
var0.ON_REFRESH = "TechnologyMediator:ON_REFRESH"
var0.ON_STOP = "TechnologyMediator:ON_STOP"
var0.ON_JOIN_QUEUE = "TechnologyMediator:ON_JOIN_QUEUE"
var0.ON_FINISH_QUEUE = "TechnologyMediator:ON_FINISH_QUEUE"
var0.ON_CLICK_SETTINGS_BTN = "TechnologyMediator:ON_CLICK_SETTINGS_BTN"

function var0.register(arg0)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		arg0:sendNotification(GAME.START_TECHNOLOGY, {
			id = arg1.id,
			pool_id = arg1.pool_id
		})
	end)
	arg0:bind(var0.ON_FINISHED, function(arg0, arg1)
		arg0:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1.id,
			pool_id = arg1.pool_id
		})
	end)
	arg0:bind(var0.ON_REFRESH, function(arg0)
		arg0:sendNotification(GAME.REFRESH_TECHNOLOGYS)
	end)
	arg0:bind(var0.ON_STOP, function(arg0, arg1)
		arg0:sendNotification(GAME.STOP_TECHNOLOGY, {
			id = arg1.id,
			pool_id = arg1.pool_id
		})
	end)
	arg0:bind(var0.ON_JOIN_QUEUE, function(arg0, arg1)
		arg0:sendNotification(GAME.JOIN_QUEUE_TECHNOLOGY, {
			id = arg1.id,
			pool_id = arg1.pool_id
		})
	end)
	arg0:bind(var0.ON_FINISH_QUEUE, function(arg0)
		arg0:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0:bind(var0.ON_CLICK_SETTINGS_BTN, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = TechnologySettingsLayer,
			mediator = TechnologySettingsMediator
		}))
	end)

	local var0 = getProxy(TechnologyProxy)

	arg0.viewComponent:setTechnologys(var0:getTechnologys(), var0.queue)
	arg0.viewComponent:setRefreshFlag(var0.refreshTechnologysFlag)

	local var1 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var1)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getName()

	if var1 == TechnologyProxy.TECHNOLOGY_UPDATED then
		arg0.viewComponent:updateTechnology(var0)
	elseif var1 == GAME.FINISH_TECHNOLOGY_DONE then
		if #var0.items > 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var0.items
			})
		end

		arg0:onRefresh()
	elseif var1 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		local var2 = {}

		for iter0, iter1 in ipairs(var0.dropInfos) do
			if #iter1 > 0 then
				table.insert(var2, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1,
						removeFunc = arg0
					})
				end)
			end
		end

		seriesAsync(var2, function()
			return
		end)
		arg0:onRefresh()
	elseif var1 == GAME.REFRESH_TECHNOLOGYS_DONE then
		arg0:onRefresh()
	elseif var1 == GAME.JOIN_QUEUE_TECHNOLOGY_DONE then
		arg0:onRefresh()
	elseif var1 == TechnologyProxy.REFRESH_UPDATED then
		arg0.viewComponent:setRefreshFlag(var0)
		arg0.viewComponent:updateRefreshBtn(var0)
	elseif var1 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var0)
	elseif var1 == TechnologySettingsMediator.EXIT_CALL then
		arg0.viewComponent:updatePickUpVersionChange()
	end
end

function var0.onRefresh(arg0)
	arg0.viewComponent:clearTimer()
	arg0.viewComponent:cancelSelected()

	local var0 = getProxy(TechnologyProxy)

	arg0.viewComponent:setTechnologys(var0:getTechnologys(), var0.queue)
	arg0.viewComponent:initTechnologys()
	arg0.viewComponent:initQueue()
	arg0.viewComponent:updateSettingsBtn()
end

return var0
