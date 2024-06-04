local var0 = class("CastleMainMediator", import("..base.ContextMediator"))

var0.CASTLE_ACT_OP = "castle act op"
var0.ADD_ITEM = "add item"
var0.UPDATE_ACTIVITY = "update activity"
var0.CASTLE_FIRST_STORY_OP_DONE = "castle first story op done"
var0.ON_TASK_SUBMIT = "on task submit"
var0.UPDATE_GUIDE = "CastleMainMediator.UPDATE_GUIDE"

function var0.register(arg0)
	arg0:bind(var0.CASTLE_ACT_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.CASTLE_ACT_OP, arg1)
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1
		})
	end)
	arg0:bind(var0.ADD_ITEM, function(arg0, arg1)
		return
	end)
	arg0:bind(var0.UPDATE_ACTIVITY, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = arg1.id
		})
	end)
	arg0:bind(var0.UPDATE_GUIDE, function(arg0, arg1)
		arg0:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1
		})
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.CASTLE_STORY_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:StoryActEnd(var0.number[1])
		end,
		[GAME.CASTLE_DICE_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:RollDice(var0.number[1], var0.number[2])
		end,
		[GAME.CASTLE_FIRST_STORY_OP_DONE] = function(arg0, arg1)
			arg0.viewComponent:FirstStory()
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, function()
				arg0.viewComponent:UpdateFlush()
			end)
		end
	}
end

return var0
