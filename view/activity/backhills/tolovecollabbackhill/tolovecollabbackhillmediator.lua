local var0_0 = class("ToLoveCollabBackHillMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINI_GAME = "MINI_GAME"
var0_0.TASK = "TASK"
var0_0.PUZZLE = "PUZZLE"
var0_0.TROPHY = "TROPHY"
var0_0.MINI_GAME_ID = 69

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	var0_0.super.BindEvent(arg0_2)
	arg0_2:bind(var0_0.MINI_GAME, function()
		arg0_2:sendNotification(GAME.GO_MINI_GAME, var0_0.MINI_GAME_ID)
	end)
	arg0_2:bind(var0_0.PUZZLE, function()
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.PUZZLE_CONNECT, {})
	end)
	arg0_2:bind(var0_0.TASK, function(arg0_5, arg1_5)
		arg0_2:addSubLayers(Context.New({
			mediator = ToLoveCollabTaskMediator,
			viewComponent = ToLoveCollabTaskScene
		}))
	end)
	arg0_2:bind(var0_0.TROPHY, function(arg0_6, arg1_6)
		arg0_2:addSubLayers(Context.New({
			mediator = MedalCollectionTemplateMediator,
			viewComponent = ToLoveCollabMedalView
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		-- block empty
	elseif var0_8 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_8.viewComponent:UpdateView()
	end
end

return var0_0
