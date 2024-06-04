local var0 = class("SelectTechnologyMediator", import("..base.ContextMediator"))

var0.ON_BLUEPRINT = "SelectTechnologyMediator:ON_BLUEPRINT"
var0.ON_TECHNOLOGY = "SelectTechnologyMediator:ON_TECHNOLOGY"
var0.ON_TRANSFORM_EQUIPMENT = "SelectTechnologyMediator:ON_TRANSFORM_EQUIPMENT"
var0.ON_META = "SelectTechnologyMediator:ON_META"

function var0.register(arg0)
	arg0:bind(var0.ON_TECHNOLOGY, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0:bind(var0.ON_BLUEPRINT, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT)
	end)
	arg0:bind(TechnologyConst.OPEN_TECHNOLOGY_TREE_SCENE, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY_TREE_SCENE)
	end)
	arg0:bind(var0.ON_TRANSFORM_EQUIPMENT, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPMENT_TRANSFORM)
	end)
	arg0:bind(var0.ON_META, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
	end)

	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var0:getData())

	local var1 = var0.onTechnologyNotify()

	arg0.viewComponent:notifyTechnology(var1)

	local var2 = var0.onBlueprintNotify()

	arg0.viewComponent:notifyBlueprint(var2)

	local var3 = getProxy(TechnologyNationProxy):getShowRedPointTag()

	arg0.viewComponent:notifyFleet(var3)

	local var4 = MetaCharacterConst.isMetaMainEntRedPoint()

	arg0.viewComponent:notifyMeta(var4)
end

function var0.onTechnologyNotify()
	local var0 = getProxy(TechnologyProxy):getPlanningTechnologys()

	return #var0 > 0 and var0[#var0]:isCompleted()
end

function var0.onBlueprintNotify()
	local var0 = getProxy(TechnologyProxy)

	if PlayerPrefs.GetString("technology_day_mark", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true) and var0:CheckPursuingCostTip() then
		return true
	end

	local var1 = var0:getBluePrints()
	local var2 = var0:getBuildingBluePrint()

	if not var2 then
		return _.any(_.values(var1), function(arg0)
			local var0 = arg0:getState() == ShipBluePrint.STATE_LOCK
			local var1, var2 = arg0:isFinishPrevTask()

			return var0 and var1
		end)
	else
		if var2:getState() == ShipBluePrint.STATE_DEV_FINISHED then
			return true
		end

		local var3 = false
		local var4 = var2:getTaskIds()

		return _.any(var4, function(arg0)
			local var0 = var2:getTaskStateById(arg0)
			local var1 = getProxy(TaskProxy):isFinishPrevTasks(arg0)

			return var0 == (ShipBluePrint.TASK_STATE_OPENING and var1) or var0 == ShipBluePrint.TASK_STATE_ACHIEVED
		end)
	end

	return false
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	end
end

return var0
