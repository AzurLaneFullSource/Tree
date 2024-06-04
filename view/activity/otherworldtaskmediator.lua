local var0 = class("OtherWorldTaskMediator", import("..base.ContextMediator"))

var0.SUBMIT_TASK_ALL = "activity submit task all"
var0.SUBMIT_TASK = "activity submit task "
var0.TASK_GO = "activity task go "
var0.SHOW_DETAIL = "activity task show detail"

function var0.register(arg0)
	arg0:bind(var0.SUBMIT_TASK_ALL, function(arg0, arg1)
		arg0:checkActStory(arg1.activityId, arg1.ids, function()
			arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
				act_id = arg1.activityId,
				task_ids = arg1.ids
			})
		end)
	end)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0:checkActStory(arg1.activityId, {
			arg1.id
		}, function()
			arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
				act_id = arg1.activityId,
				task_ids = {
					arg1.id
				}
			})
		end)
	end)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0.viewComponent:closeView()

		local var0 = arg1.taskVO:getConfig("scene")

		if var0[1] == SCENE.OTHERWORLD_MAP then
			pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_MAP, {
				mode = var0[2].mode
			})
		else
			arg0:sendNotification(GAME.TASK_GO, {
				taskVO = arg1.taskVO
			})
		end
	end)
	arg0:bind(var0.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)
end

function var0.checkActStory(arg0, arg1, arg2, arg3)
	local var0 = pg.activity_template[arg1].config_client.task_story

	if not var0 then
		arg3()

		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[1]
		local var3 = iter1[2]

		if table.contains(arg2, var2) then
			table.insert(var1, var3)
		end
	end

	local var4 = {}

	for iter2, iter3 in ipairs(var1) do
		table.insert(var4, function(arg0)
			pg.NewStoryMgr.GetInstance():Play(iter3, arg0, true)
		end)
	end

	seriesAsync(var4, function()
		arg3()
	end)
end

function var0.onUIAvalible(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_AVATAR_TASK_DONE,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_AVATAR_TASK_DONE then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		if var1.callback then
			-- block empty
		end

		arg0.viewComponent:updateTask(true)
	elseif var0 == GAME.ZERO_HOUR_OP_DONE then
		arg0.viewComponent:updateTask(true)
	end
end

return var0
