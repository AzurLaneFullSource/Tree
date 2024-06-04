local var0 = class("FeastMediator", import("view.backYard.CourtYardMediator"))

var0.SET_UP = "FeastMediator:SET_UP"
var0.MAKE_TICKET = "FeastMediator:MAKE_TICKET"
var0.GIVE_TICKET = "FeastMediator:GIVE_TICKET"
var0.GIVE_GIFT = "FeastMediator:GIVE_GIFT"
var0.EVENT_PT_OPERATION = "FeastMediator:EVENT_PT_OPERATION"
var0.ON_SUBMIT = "FeastMediator:ON_SUBMIT"
var0.ON_GO = "FeastMediator:ON_GO"
var0.ON_SUBMIT_ONE_KEY = "FeastMediator:ON_SUBMIT_ONE_KEY"
var0.ON_SHIP_ENTER_FEAST = "FeastMediator:ON_SHIP_ENTER_FEAST"

function var0.register(arg0)
	arg0.caches = {}

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0:bind(var0.SET_UP, function(arg0, arg1)
		local var0 = arg0:GenCourtYardData(arg1)

		_courtyard = CourtYardBridge.New(var0)
	end)
	arg0:bind(var0.MAKE_TICKET, function(arg0, arg1)
		arg0:sendNotification(GAME.FEAST_OP, {
			activityId = var0.id,
			cmd = FeastDorm.OP_MAKE_TICKET,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.GIVE_TICKET, function(arg0, arg1)
		arg0:sendNotification(GAME.FEAST_OP, {
			activityId = var0.id,
			cmd = FeastDorm.OP_GIVE_TICKET,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.GIVE_GIFT, function(arg0, arg1)
		arg0:sendNotification(GAME.FEAST_OP, {
			activityId = var0.id,
			cmd = FeastDorm.OP_GIVE_GIFT,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.EVENT_PT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, arg1)
	end)
	arg0:bind(var0.ON_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.ON_GO, function(arg0, arg1)
		arg0:HandleTaskGo(arg1)
	end)
	arg0:bind(var0.ON_SUBMIT_ONE_KEY, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1
		})
	end)
	arg0:bind(var0.ON_SHIP_ENTER_FEAST, function(arg0, arg1)
		if _courtyard then
			_courtyard:GetController():ShipEnterFeast(arg1)
		end
	end)
	arg0:sendNotification(GAME.FEAST_OP, {
		activityId = var0.id,
		cmd = FeastDorm.OP_ENTER
	})
end

function var0.HandleTaskGo(arg0, arg1)
	if arg1:IsActRoutineType() and arg1:getConfig("sub_type") == 430 then
		-- block empty
	elseif arg1:IsActRoutineType() and arg1:getConfig("sub_type") == 431 then
		arg0.viewComponent:emit(FeastScene.GO_INTERACTION)
	elseif arg1:IsActType() and (arg1:getConfig("sub_type") == 432 or arg1:getConfig("sub_type") == 433) then
		arg0.viewComponent:emit(FeastScene.GO_INVITATION)
	elseif arg1:IsActType() and arg1:getConfig("sub_type") == 417 then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 56)
	else
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == CourtYardEvent._QUIT then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0 == CourtYardEvent._INITED then
		arg0.viewComponent:OnCourtYardLoaded()
	elseif var0 == CourtYardEvent._FEAST_INTERACTION then
		local var3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if not var3 or var3:isEnd() then
			return
		end

		local var4 = var1.groupId
		local var5 = var1.special

		arg0:sendNotification(GAME.FEAST_OP, {
			activityId = var3.id,
			cmd = FeastDorm.OP_INTERACTION,
			arg1 = var4,
			arg2 = var5
		})
	elseif var0 == GAME.FEAST_OP_DONE then
		local var6 = 0
		local var7 = true

		if var1.cmd == FeastDorm.OP_INTERACTION then
			_courtyard:GetController():UpdateBubble(var1.groupId, var1.value)

			if var1.chat and var1.chat ~= "" then
				_courtyard:GetController():UpdateChatBubble(var1.groupId, var1.chat)
			end

			var6 = CourtYardConst.FEAST_EFFECT_TIME
		elseif var1.cmd == FeastDorm.OP_GIVE_TICKET then
			local var8 = getProxy(FeastProxy):getRawData():GetFeastShip(var1.groupId)

			_courtyard:GetController():AddShipWithSpecialPosition(var8)
			arg0.viewComponent:emit(FeastScene.ON_GOT_TICKET, var1.awards)

			local var9 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(var1.groupId)

			var7 = false
		elseif var1.cmd == FeastDorm.OP_RANDOM_SHIPS then
			_courtyard:GetController():ExitAllShip()

			local var10 = {}

			for iter0, iter1 in ipairs(var1.ships or {}) do
				table.insert(var10, function(arg0)
					_courtyard:GetController():AddShip(iter1)
					onNextTick(arg0)
				end)
			end

			seriesAsync(var10)
		elseif var1.cmd == FeastDorm.OP_GIVE_GIFT then
			arg0.viewComponent:emit(FeastScene.ON_GOT_GIFT, var1.awards)

			local var11 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(var1.groupId)

			var7 = false
		elseif var1.cmd == FeastDorm.OP_MAKE_TICKET then
			arg0.viewComponent:emit(FeastScene.ON_MAKE_TICKET, var1.groupId)
		end

		if #var1.awards > 0 and var7 then
			local var12 = var1.cmd == FeastDorm.OP_INTERACTION and #arg0.caches == 0 and var6 or 0

			table.insert(arg0.caches, {
				var1.awards,
				var12
			})

			if #arg0.caches == 1 then
				arg0:DisplayAwards()
			end
		end
	elseif var0 == TaskProxy.TASK_ADDED or var0 == TaskProxy.TASK_UPDATED or var0 == TaskProxy.TASK_REMOVED then
		arg0.viewComponent:emit(FeastScene.ON_TASK_UPDATE)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == ActivityConst.FEAST_PT_ACT then
			arg0.viewComponent:emit(FeastScene.ON_ACT_UPDATE)
		end
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			local var0 = var2

			getProxy(FeastProxy):HandleTaskStories(var0)
		end)
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
			return
		end)
	end
end

function var0.DisplayAwards(arg0)
	local var0 = arg0.caches[1]
	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = {}

	if var2 > 0 then
		table.insert(var3, function(arg0)
			if not arg0.viewComponent then
				return
			end

			onDelayTick(arg0, var2, 1)
		end)
	end

	table.insert(var3, function(arg0)
		if not arg0.viewComponent then
			return
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, arg0)
	end)
	seriesAsync(var3, function()
		table.remove(arg0.caches, 1)

		if #arg0.caches > 0 then
			arg0:DisplayAwards()
		end
	end)
end

return var0
