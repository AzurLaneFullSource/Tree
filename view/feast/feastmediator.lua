local var0_0 = class("FeastMediator", import("view.backYard.CourtYardMediator"))

var0_0.SET_UP = "FeastMediator:SET_UP"
var0_0.MAKE_TICKET = "FeastMediator:MAKE_TICKET"
var0_0.GIVE_TICKET = "FeastMediator:GIVE_TICKET"
var0_0.GIVE_GIFT = "FeastMediator:GIVE_GIFT"
var0_0.EVENT_PT_OPERATION = "FeastMediator:EVENT_PT_OPERATION"
var0_0.ON_SUBMIT = "FeastMediator:ON_SUBMIT"
var0_0.ON_GO = "FeastMediator:ON_GO"
var0_0.ON_SUBMIT_ONE_KEY = "FeastMediator:ON_SUBMIT_ONE_KEY"
var0_0.ON_SHIP_ENTER_FEAST = "FeastMediator:ON_SHIP_ENTER_FEAST"

function var0_0.register(arg0_1)
	arg0_1.caches = {}

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0_1:bind(var0_0.SET_UP, function(arg0_2, arg1_2)
		local var0_2 = arg0_1:GenCourtYardData(arg1_2)

		_courtyard = CourtYardBridge.New(var0_2)
	end)
	arg0_1:bind(var0_0.MAKE_TICKET, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.FEAST_OP, {
			activityId = var0_1.id,
			cmd = FeastDorm.OP_MAKE_TICKET,
			arg1 = arg1_3
		})
	end)
	arg0_1:bind(var0_0.GIVE_TICKET, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.FEAST_OP, {
			activityId = var0_1.id,
			cmd = FeastDorm.OP_GIVE_TICKET,
			arg1 = arg1_4
		})
	end)
	arg0_1:bind(var0_0.GIVE_GIFT, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.FEAST_OP, {
			activityId = var0_1.id,
			cmd = FeastDorm.OP_GIVE_GIFT,
			arg1 = arg1_5
		})
	end)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_6)
	end)
	arg0_1:bind(var0_0.ON_SUBMIT, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_7)
	end)
	arg0_1:bind(var0_0.ON_GO, function(arg0_8, arg1_8)
		arg0_1:HandleTaskGo(arg1_8)
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_ONE_KEY, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_9
		})
	end)
	arg0_1:bind(var0_0.ON_SHIP_ENTER_FEAST, function(arg0_10, arg1_10)
		if _courtyard then
			_courtyard:GetController():ShipEnterFeast(arg1_10)
		end
	end)
	arg0_1:sendNotification(GAME.FEAST_OP, {
		activityId = var0_1.id,
		cmd = FeastDorm.OP_ENTER
	})
end

function var0_0.HandleTaskGo(arg0_11, arg1_11)
	if arg1_11:IsActRoutineType() and arg1_11:getConfig("sub_type") == 430 then
		-- block empty
	elseif arg1_11:IsActRoutineType() and arg1_11:getConfig("sub_type") == 431 then
		arg0_11.viewComponent:emit(FeastScene.GO_INTERACTION)
	elseif arg1_11:IsActType() and (arg1_11:getConfig("sub_type") == 432 or arg1_11:getConfig("sub_type") == 433) then
		arg0_11.viewComponent:emit(FeastScene.GO_INVITATION)
	elseif arg1_11:IsActType() and arg1_11:getConfig("sub_type") == 417 then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
	else
		arg0_11:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_11
		})
	end
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		CourtYardEvent._QUIT,
		CourtYardEvent._INITED,
		CourtYardEvent._FEAST_INTERACTION,
		GAME.ACT_NEW_PT_DONE,
		GAME.SUBMIT_TASK_DONE,
		GAME.FEAST_OP_DONE,
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()
	local var2_13 = arg1_13:getType()

	if var0_13 == CourtYardEvent._QUIT then
		arg0_13.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_13 == CourtYardEvent._INITED then
		arg0_13.viewComponent:OnCourtYardLoaded()
	elseif var0_13 == CourtYardEvent._FEAST_INTERACTION then
		local var3_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if not var3_13 or var3_13:isEnd() then
			return
		end

		local var4_13 = var1_13.groupId
		local var5_13 = var1_13.special

		arg0_13:sendNotification(GAME.FEAST_OP, {
			activityId = var3_13.id,
			cmd = FeastDorm.OP_INTERACTION,
			arg1 = var4_13,
			arg2 = var5_13
		})
	elseif var0_13 == GAME.FEAST_OP_DONE then
		local var6_13 = 0
		local var7_13 = true

		if var1_13.cmd == FeastDorm.OP_INTERACTION then
			_courtyard:GetController():UpdateBubble(var1_13.groupId, var1_13.value)

			if var1_13.chat and var1_13.chat ~= "" then
				_courtyard:GetController():UpdateChatBubble(var1_13.groupId, var1_13.chat)
			end

			var6_13 = CourtYardConst.FEAST_EFFECT_TIME
		elseif var1_13.cmd == FeastDorm.OP_GIVE_TICKET then
			local var8_13 = getProxy(FeastProxy):getRawData():GetFeastShip(var1_13.groupId)

			_courtyard:GetController():AddShipWithSpecialPosition(var8_13)
			arg0_13.viewComponent:emit(FeastScene.ON_GOT_TICKET, var1_13.awards)

			local var9_13 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(var1_13.groupId)

			var7_13 = false
		elseif var1_13.cmd == FeastDorm.OP_RANDOM_SHIPS then
			_courtyard:GetController():ExitAllShip()

			local var10_13 = {}

			for iter0_13, iter1_13 in ipairs(var1_13.ships or {}) do
				table.insert(var10_13, function(arg0_14)
					_courtyard:GetController():AddShip(iter1_13)
					onNextTick(arg0_14)
				end)
			end

			seriesAsync(var10_13)
		elseif var1_13.cmd == FeastDorm.OP_GIVE_GIFT then
			arg0_13.viewComponent:emit(FeastScene.ON_GOT_GIFT, var1_13.awards)

			local var11_13 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(var1_13.groupId)

			var7_13 = false
		elseif var1_13.cmd == FeastDorm.OP_MAKE_TICKET then
			arg0_13.viewComponent:emit(FeastScene.ON_MAKE_TICKET, var1_13.groupId)
		end

		if #var1_13.awards > 0 and var7_13 then
			local var12_13 = var1_13.cmd == FeastDorm.OP_INTERACTION and #arg0_13.caches == 0 and var6_13 or 0

			table.insert(arg0_13.caches, {
				var1_13.awards,
				var12_13
			})

			if #arg0_13.caches == 1 then
				arg0_13:DisplayAwards()
			end
		end
	elseif var0_13 == TaskProxy.TASK_ADDED or var0_13 == TaskProxy.TASK_UPDATED or var0_13 == TaskProxy.TASK_REMOVED then
		arg0_13.viewComponent:emit(FeastScene.ON_TASK_UPDATE)
	elseif var0_13 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_13.id == ActivityConst.FEAST_PT_ACT then
			arg0_13.viewComponent:emit(FeastScene.ON_ACT_UPDATE)
		end
	elseif var0_13 == GAME.SUBMIT_TASK_DONE then
		arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13, function()
			local var0_15 = var2_13

			getProxy(FeastProxy):HandleTaskStories(var0_15)
		end)
	elseif var0_13 == GAME.ACT_NEW_PT_DONE then
		arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards, function()
			return
		end)
	end
end

function var0_0.DisplayAwards(arg0_17)
	local var0_17 = arg0_17.caches[1]
	local var1_17 = var0_17[1]
	local var2_17 = var0_17[2]
	local var3_17 = {}

	if var2_17 > 0 then
		table.insert(var3_17, function(arg0_18)
			if not arg0_17.viewComponent then
				return
			end

			onDelayTick(arg0_18, var2_17, 1)
		end)
	end

	table.insert(var3_17, function(arg0_19)
		if not arg0_17.viewComponent then
			return
		end

		arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17, arg0_19)
	end)
	seriesAsync(var3_17, function()
		table.remove(arg0_17.caches, 1)

		if #arg0_17.caches > 0 then
			arg0_17:DisplayAwards()
		end
	end)
end

return var0_0
