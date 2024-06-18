local var0_0 = class("ColoringMediator", import("..base.ContextMediator"))

var0_0.EVENT_GO_SCENE = "event go scene"
var0_0.EVENT_COLORING_CELL = "event coloring cell"
var0_0.EVENT_COLORING_CLEAR = "event coloring clear"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_GO_SCENE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_CELL, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.COLORING_CELL, arg1_3)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_CLEAR, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.COLORING_CLEAR, arg1_4)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	arg0_1.viewComponent:setActivity(var0_1)

	local var1_1 = getProxy(ColoringProxy)

	arg0_1.viewComponent:setColorItems(var1_1:getColorItems())
	arg0_1.viewComponent:setColorGroups(var1_1:getColorGroups())
	arg0_1.viewComponent:DidMediatorRegisterDone()
	arg0_1:tryColoringAchieve()
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.COLORING_CELL_DONE,
		GAME.COLORING_CLEAR_DONE,
		GAME.COLORING_ACHIEVE_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.COLORING_CELL_DONE then
		_.each(var1_6.cells, function(arg0_7)
			arg0_6.viewComponent:updateCell(arg0_7.row, arg0_7.column)
		end)
		arg0_6.viewComponent:updateSelectedColoring()

		if var1_6.stateChange then
			arg0_6.viewComponent:updatePage()
			arg0_6:tryColoringAchieve()
		end
	elseif var0_6 == GAME.COLORING_CLEAR_DONE then
		arg0_6.viewComponent:updateSelectedColoring()
	elseif var0_6 == GAME.COLORING_ACHIEVE_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.drops, function()
			arg0_6.viewComponent:updatePage()
		end)
	end
end

function var0_0.tryColoringAchieve(arg0_9)
	local var0_9 = getProxy(ColoringProxy):getColorGroups()

	for iter0_9, iter1_9 in ipairs(var0_9) do
		if iter1_9:getState() == ColorGroup.StateFinish and iter1_9:getHasAward() then
			arg0_9:sendNotification(GAME.COLORING_ACHIEVE, {
				activityId = arg0_9.viewComponent.activity.id,
				id = iter1_9.id
			})

			break
		end
	end
end

return var0_0
