local var0_0 = class("CowboyTownMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINI_GAME = "MINI_GAME"
var0_0.TASK = "TASK"
var0_0.EXPANSION = "EXPANSION"
var0_0.STORY = "STORY"
var0_0.SKIN = "SKIN"
var0_0.MINI_GAME_ID = 28

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	assert(var0_1, "Building Activity Not Found")

	arg0_1.activity = var0_1

	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	var0_0.super.BindEvent(arg0_2)
	arg0_2:bind(var0_0.MINI_GAME, function()
		arg0_2:sendNotification(GAME.GO_MINI_GAME, var0_0.MINI_GAME_ID)
	end)
	arg0_2:bind(var0_0.STORY, function()
		arg0_2:addSubLayers(Context.New({
			mediator = TownSkinMediator,
			viewComponent = TownSkinPage
		}))
	end)
	arg0_2:bind(var0_0.SKIN, function()
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_2:bind(var0_0.EXPANSION, function()
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.TOWN)
	end)
	arg0_2:bind(var0_0.TASK, function(arg0_7, arg1_7)
		arg0_2:addSubLayers(Context.New({
			mediator = SixYearUsTaskMediator,
			viewComponent = SixYearUsTaskScene
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_9:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TownSkinStory then
			arg0_9.viewComponent:UpdateStoryView()
		end
	elseif var0_9 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_9.viewComponent:UpdateTaskTips()
	end
end

return var0_0
