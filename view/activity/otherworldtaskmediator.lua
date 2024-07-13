local var0_0 = class("OtherWorldTaskMediator", import("..base.ContextMediator"))

var0_0.SUBMIT_TASK_ALL = "activity submit task all"
var0_0.SUBMIT_TASK = "activity submit task "
var0_0.TASK_GO = "activity task go "
var0_0.SHOW_DETAIL = "activity task show detail"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK_ALL, function(arg0_2, arg1_2)
		arg0_1:checkActStory(arg1_2.activityId, arg1_2.ids, function()
			arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = arg1_2.activityId,
				task_ids = arg1_2.ids
			})
		end)
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_4, arg1_4)
		arg0_1:checkActStory(arg1_4.activityId, {
			arg1_4.id
		}, function()
			arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = arg1_4.activityId,
				task_ids = {
					arg1_4.id
				}
			})
		end)
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_6, arg1_6)
		arg0_1.viewComponent:closeView()

		local var0_6 = arg1_6.taskVO:getConfig("scene")

		if var0_6[1] == SCENE.OTHERWORLD_MAP then
			pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_MAP, {
				mode = var0_6[2].mode
			})
		else
			arg0_1:sendNotification(GAME.TASK_GO, {
				taskVO = arg1_6.taskVO
			})
		end
	end)
	arg0_1:bind(var0_0.SHOW_DETAIL, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1_7
			}
		}))
	end)
end

function var0_0.checkActStory(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = pg.activity_template[arg1_8].config_client.task_story

	if not var0_8 then
		arg3_8()

		return
	end

	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var2_8 = iter1_8[1]
		local var3_8 = iter1_8[2]

		if table.contains(arg2_8, var2_8) then
			table.insert(var1_8, var3_8)
		end
	end

	local var4_8 = {}

	for iter2_8, iter3_8 in ipairs(var1_8) do
		table.insert(var4_8, function(arg0_9)
			pg.NewStoryMgr.GetInstance():Play(iter3_8, arg0_9, true)
		end)
	end

	seriesAsync(var4_8, function()
		arg3_8()
	end)
end

function var0_0.onUIAvalible(arg0_11)
	return
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		if #var1_13.awards > 0 then
			arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards)
		end

		if var1_13.callback then
			-- block empty
		end

		arg0_13.viewComponent:updateTask(true)
	elseif var0_13 == GAME.ZERO_HOUR_OP_DONE then
		arg0_13.viewComponent:updateTask(true)
	end
end

return var0_0
