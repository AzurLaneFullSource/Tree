local var0_0 = class("WorldMediaCollectionMediator", ContextMediator)

var0_0.BEGIN_STAGE = "WorldMediaCollectionMediator BEGIN_STAGE"
var0_0.ON_ADD_SUBLAYER = "WorldMediaCollectionMediator.ON_ADD_SUBLAYER"
var0_0.GO_TASK = "WorldMediaCollectionMediator.GO_TASK"
var0_0.TRIGGER_PERSONAL_TASK = "WorldMediaCollectionMediator.TRIGGER_PERSONAL_TASK"
var0_0.OPEN_LOVE_LETTER_DISPLAY = "WorldMediaCollectionMediator.OPEN_LOVE_LETTER_DISPLAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BEGIN_STAGE, function(arg0_2, arg1_2)
		arg0_1.contextData.revertBgm = pg.CriMgr.GetInstance().bgmNow

		arg0_1:sendNotification(GAME.BEGIN_STAGE, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_ADD_SUBLAYER, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(arg1_3)
	end)
	arg0_1:bind(var0_0.GO_TASK, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
			page = TaskScene.PAGE_TYPE_BRANCH
		})
	end)
	arg0_1:bind(var0_0.OPEN_LOVE_LETTER_DISPLAY, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterDisplayMediator,
			viewComponent = LoveLetterDisplayLayer,
			data = setmetatable({
				groupId = arg1_5
			}, {
				__index = getProxy(LoveLetterProxy):GetGroupData(arg1_5):GetLetterDataFromId()
			})
		}))
	end)
	arg0_1:bind(var0_0.TRIGGER_PERSONAL_TASK, function(arg0_6, arg1_6, arg2_6)
		arg0_1:TriggerPersonalTask(arg1_6, arg2_6)
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		GAME.UNLOCK_LOVE_LETTER_DONE,
		GAME.STORY_UPDATE_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:UpdateView()
	elseif var0_8 == GAME.BEGIN_STAGE_DONE then
		arg0_8:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_8)
	elseif var0_8 == GAME.UNLOCK_LOVE_LETTER_DONE then
		pg.EasyRedDotMgr.GetInstance():TriggerMarks("love_letter_unlock_letter")
	elseif var0_8 == GAME.STORY_UPDATE_DONE then
		arg0_8.contextData.listenStoryDic = arg0_8.contextData.listenStoryDic or {}

		existCall(arg0_8.contextData.listenStoryDic[var1_8.storyName])

		arg0_8.contextData.listenStoryDic[var1_8.storyName] = nil
	end
end

function var0_0.TriggerPersonalTask(arg0_9, arg1_9, arg2_9)
	assert(arg1_9 and arg1_9 ~= 0, "invalid groupId:" .. tostring(arg1_9))

	local var0_9 = (pg.task_data_trigger.get_id_list_by_group_id[arg1_9] or {})[1]
	local var1_9 = var0_9 and pg.task_data_trigger[var0_9].task_id

	assert(var1_9 and var1_9 ~= 0, "invalid taskId for groupId:" .. tostring(arg1_9))

	if not getProxy(TaskProxy):getFinishTaskById(var1_9) then
		local var2_9 = pg.task_data_template[var1_9].story_id

		arg0_9.contextData.listenStoryDic = arg0_9.contextData.listenStoryDic or {}
		arg0_9.contextData.listenStoryDic[var2_9] = arg2_9

		pg.m02:sendNotification(GAME.TRIGGER_TASK, var1_9)
	end
end

return var0_0
