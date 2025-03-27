local var0_0 = class("ClueMapMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_SUBMIT_ONESTEP = "ClueMapMediator.ON_TASK_SUBMIT_ONESTEP"
var0_0.OPEN_SINGLE_CLUE_GROUP = "ClueMapMediator.OPEN_SINGLE_CLUE_GROUP"
var0_0.OPEN_CLUE_BOOK = "ClueMapMediator.OPEN_CLUE_BOOK"
var0_0.OPEN_CLUE_TASk = "ClueMapMediator.OPEN_CLUE_TASk"
var0_0.OPEN_STAGE = "ClueMapMediator.OPEN_STAGE"
var0_0.ON_FLEET_SELECT = "ClueMapMediator.ON_FLEET_SELECT"
var0_0.OPEN_CLUE_JUMP = "ClueMapMediator.OPEN_CLUE_JUMP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_2,
			task_ids = arg2_2,
			callback = arg3_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_SINGLE_CLUE_GROUP, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = ClueGroupSingleView,
			mediator = ClueGroupSingleMediator,
			data = {
				clueGroupId = arg1_3,
				submitClueIds = arg2_3
			},
			onRemoved = arg3_3
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CLUE_BOOK, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = ClueBookLayer,
			mediator = ClueBookMediator,
			onRemoved = arg1_4
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CLUE_TASk, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = ClueTasksLayer,
			mediator = ClueTasksMediator,
			onRemoved = arg1_5
		}))
	end)
	arg0_1:bind(var0_0.OPEN_STAGE, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = ClueBuffSelectLayer,
			mediator = ClueBuffSelectMediator,
			data = {
				clueSingleEnemyID = arg1_6
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		var0_0.ON_FLEET_SELECT,
		var0_0.OPEN_CLUE_JUMP,
		PlayerProxy.UPDATED,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == var0_0.ON_FLEET_SELECT then
		arg0_8.viewComponent:ShowNormalFleet(var1_8.singleID)
	elseif var0_8 == var0_0.OPEN_CLUE_JUMP then
		local var2_8 = var1_8.jumpID
		local var3_8 = pg.activity_clue_group[var2_8]

		arg0_8:addSubLayers(Context.New({
			viewComponent = ClueBuffSelectLayer,
			mediator = ClueBuffSelectMediator,
			data = {
				clueSingleEnemyID = var3_8.unlock_jump[1][1],
				preSelectedBuffList = Clone(var3_8.unlock_jump[2])
			}
		}))

		local var4_8 = pg.activity_single_enemy[var3_8.unlock_jump[1][1]].type

		if var4_8 == 1 or var4_8 == 2 or var4_8 == 3 then
			triggerToggle(arg0_8.viewComponent.mapsSwitch[var4_8], true)
		end
	elseif var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:ShowResUI()
	elseif var0_8 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_8.viewComponent:RefreshPtAndTicket()
	end
end

return var0_0
