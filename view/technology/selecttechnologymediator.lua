local var0_0 = class("SelectTechnologyMediator", import("..base.ContextMediator"))

var0_0.ON_BLUEPRINT = "SelectTechnologyMediator:ON_BLUEPRINT"
var0_0.ON_TECHNOLOGY = "SelectTechnologyMediator:ON_TECHNOLOGY"
var0_0.ON_TRANSFORM_EQUIPMENT = "SelectTechnologyMediator:ON_TRANSFORM_EQUIPMENT"
var0_0.ON_META = "SelectTechnologyMediator:ON_META"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TECHNOLOGY, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.ON_BLUEPRINT, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT)
	end)
	arg0_1:bind(TechnologyConst.OPEN_TECHNOLOGY_TREE_SCENE, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY_TREE_SCENE)
	end)
	arg0_1:bind(var0_0.ON_TRANSFORM_EQUIPMENT, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPMENT_TRANSFORM)
	end)
	arg0_1:bind(var0_0.ON_META, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
	end)

	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getData())

	local var1_1 = var0_0.onTechnologyNotify()

	arg0_1.viewComponent:notifyTechnology(var1_1)

	local var2_1 = var0_0.onBlueprintNotify()

	arg0_1.viewComponent:notifyBlueprint(var2_1)

	local var3_1 = getProxy(TechnologyNationProxy):getShowRedPointTag()

	arg0_1.viewComponent:notifyFleet(var3_1)

	local var4_1 = MetaCharacterConst.isMetaMainEntRedPoint()

	arg0_1.viewComponent:notifyMeta(var4_1)
end

function var0_0.onTechnologyNotify()
	local var0_7 = getProxy(TechnologyProxy):getPlanningTechnologys()

	return #var0_7 > 0 and var0_7[#var0_7]:isCompleted()
end

function var0_0.onBlueprintNotify()
	local var0_8 = getProxy(TechnologyProxy)

	if PlayerPrefs.GetString("technology_day_mark", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true) and var0_8:CheckPursuingCostTip() then
		return true
	end

	local var1_8 = var0_8:getBluePrints()
	local var2_8 = var0_8:getBuildingBluePrint()

	if not var2_8 then
		return _.any(_.values(var1_8), function(arg0_9)
			local var0_9 = arg0_9:getState() == ShipBluePrint.STATE_LOCK
			local var1_9, var2_9 = arg0_9:isFinishPrevTask()

			return var0_9 and var1_9
		end)
	else
		if var2_8:getState() == ShipBluePrint.STATE_DEV_FINISHED then
			return true
		end

		local var3_8 = false
		local var4_8 = var2_8:getTaskIds()

		return _.any(var4_8, function(arg0_10)
			local var0_10 = var2_8:getTaskStateById(arg0_10)
			local var1_10 = getProxy(TaskProxy):isFinishPrevTasks(arg0_10)

			return var0_10 == (ShipBluePrint.TASK_STATE_OPENING and var1_10) or var0_10 == ShipBluePrint.TASK_STATE_ACHIEVED
		end)
	end

	return false
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == PlayerProxy.UPDATED then
		arg0_12.viewComponent:setPlayer(var1_12)
	end
end

return var0_0
