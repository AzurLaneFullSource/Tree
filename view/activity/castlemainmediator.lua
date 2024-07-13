local var0_0 = class("CastleMainMediator", import("..base.ContextMediator"))

var0_0.CASTLE_ACT_OP = "castle act op"
var0_0.ADD_ITEM = "add item"
var0_0.UPDATE_ACTIVITY = "update activity"
var0_0.CASTLE_FIRST_STORY_OP_DONE = "castle first story op done"
var0_0.ON_TASK_SUBMIT = "on task submit"
var0_0.UPDATE_GUIDE = "CastleMainMediator.UPDATE_GUIDE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CASTLE_ACT_OP, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CASTLE_ACT_OP, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ADD_ITEM, function(arg0_4, arg1_4)
		return
	end)
	arg0_1:bind(var0_0.UPDATE_ACTIVITY, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = arg1_5.id
		})
	end)
	arg0_1:bind(var0_0.UPDATE_GUIDE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_6
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_7)
	arg0_7.handleDic = {
		[GAME.CASTLE_STORY_OP_DONE] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			arg0_8.viewComponent:StoryActEnd(var0_8.number[1])
		end,
		[GAME.CASTLE_DICE_OP_DONE] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()

			arg0_9.viewComponent:RollDice(var0_9.number[1], var0_9.number[2])
		end,
		[GAME.CASTLE_FIRST_STORY_OP_DONE] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:FirstStory()
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_11, function()
				arg0_11.viewComponent:UpdateFlush()
			end)
		end
	}
end

return var0_0
