local var0 = class("ColoringMediator", import("..base.ContextMediator"))

var0.EVENT_GO_SCENE = "event go scene"
var0.EVENT_COLORING_CELL = "event coloring cell"
var0.EVENT_COLORING_CLEAR = "event coloring clear"

function var0.register(arg0)
	arg0:bind(var0.EVENT_GO_SCENE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
	end)
	arg0:bind(var0.EVENT_COLORING_CELL, function(arg0, arg1)
		arg0:sendNotification(GAME.COLORING_CELL, arg1)
	end)
	arg0:bind(var0.EVENT_COLORING_CLEAR, function(arg0, arg1)
		arg0:sendNotification(GAME.COLORING_CLEAR, arg1)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	arg0.viewComponent:setActivity(var0)

	local var1 = getProxy(ColoringProxy)

	arg0.viewComponent:setColorItems(var1:getColorItems())
	arg0.viewComponent:setColorGroups(var1:getColorGroups())
	arg0.viewComponent:DidMediatorRegisterDone()
	arg0:tryColoringAchieve()
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.COLORING_CELL_DONE,
		GAME.COLORING_CLEAR_DONE,
		GAME.COLORING_ACHIEVE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COLORING_CELL_DONE then
		_.each(var1.cells, function(arg0)
			arg0.viewComponent:updateCell(arg0.row, arg0.column)
		end)
		arg0.viewComponent:updateSelectedColoring()

		if var1.stateChange then
			arg0.viewComponent:updatePage()
			arg0:tryColoringAchieve()
		end
	elseif var0 == GAME.COLORING_CLEAR_DONE then
		arg0.viewComponent:updateSelectedColoring()
	elseif var0 == GAME.COLORING_ACHIEVE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.drops, function()
			arg0.viewComponent:updatePage()
		end)
	end
end

function var0.tryColoringAchieve(arg0)
	local var0 = getProxy(ColoringProxy):getColorGroups()

	for iter0, iter1 in ipairs(var0) do
		if iter1:getState() == ColorGroup.StateFinish and iter1:getHasAward() then
			arg0:sendNotification(GAME.COLORING_ACHIEVE, {
				activityId = arg0.viewComponent.activity.id,
				id = iter1.id
			})

			break
		end
	end
end

return var0
