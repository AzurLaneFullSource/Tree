local var0_0 = class("NewEducateContextMediator", import("view.base.ContextMediator"))

function var0_0.onRegister(arg0_1)
	var0_0.super.onRegister(arg0_1)
	arg0_1:bind(NewEducateBaseUI.GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(NewEducateBaseUI.CHANGE_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(NewEducateBaseUI.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_1:bind(NewEducateBaseUI.ON_DROP, function(arg0_5, arg1_5)
		if #arg1_5.items == 0 then
			existCall(arg1_5.removeFunc)

			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = NewEducateDropMediator,
			viewComponent = NewEducateDropLayer,
			data = arg1_5
		}))
	end)
	arg0_1:bind(NewEducateBaseUI.ON_ITEM, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NewEducateMsgBoxLayer,
			mediator = NewEducateMsgBoxMediator,
			data = setmetatable({
				type = NewEducateMsgBoxLayer.TYPE.ITEM
			}, {
				__index = arg1_6
			})
		}))
	end)
	arg0_1:bind(NewEducateBaseUI.ON_BOX, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NewEducateMsgBoxLayer,
			mediator = NewEducateMsgBoxMediator,
			data = setmetatable({
				type = NewEducateMsgBoxLayer.TYPE.BOX
			}, {
				__index = arg1_7
			})
		}))
	end)
	arg0_1:bind(NewEducateBaseUI.ON_SHOP, function(arg0_8, arg1_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NewEducateMsgBoxLayer,
			mediator = NewEducateMsgBoxMediator,
			data = setmetatable({
				type = NewEducateMsgBoxLayer.TYPE.SHOP
			}, {
				__index = arg1_8
			})
		}))
	end)
	arg0_1:bind(NewEducateBaseUI.ON_PRIORITY_STATE, function(arg0_9, arg1_9)
		arg0_1:CheckPriorityState(arg1_9)
	end)

	arg0_1.contextData.char = getProxy(NewEducateProxy):GetCurChar()
end

function var0_0.CheckPriorityState(arg0_10, arg1_10)
	local var0_10 = arg0_10.contextData.char:GetFSM()

	if not var0_10:CheckPriorityStystem() then
		arg0_10:sendNotification(GAME.NEW_EDUCATE_CHECK_FSM)

		return
	end

	local var1_10 = var0_10:GetPriorityState()

	switch(var1_10:GetSystemNo(), {
		[NewEducatePriorityFSM.SYSTEM.CHOOSE] = function()
			arg0_10:PriorityChooseHandler(arg1_10)
		end,
		[NewEducatePriorityFSM.SYSTEM.UPGRADE_ENTRY] = function()
			arg0_10:PriorityUpEntryHandler(arg1_10)
		end,
		[NewEducatePriorityFSM.SYSTEM.REPLACE_TAROT] = function()
			arg0_10:PriorityReplaceTarotHandler(arg1_10)
		end
	}, function()
		assert(false, "不合法PriorityFSM状态")
	end)
end

function var0_0.PriorityChooseHandler(arg0_15, arg1_15)
	arg0_15:addSubLayers(Context.New({
		viewComponent = NewEducateChooseLayer,
		mediator = NewEducateChooseMediator,
		data = {
			onExit = function()
				arg0_15:CheckPriorityState()
			end
		}
	}))
end

function var0_0.PriorityUpEntryHandler(arg0_17, arg1_17)
	arg0_17:addSubLayers(Context.New({
		viewComponent = NewEducateTarotEntryLayer,
		mediator = NewEducateTarotEntryMediator,
		data = {
			type = arg1_17 and arg1_17.type or NewEducateTarotEntryLayer.TYPE.DROP,
			onExit = function()
				arg0_17:CheckPriorityState()
			end
		}
	}))
end

function var0_0.PriorityReplaceTarotHandler(arg0_19, arg1_19)
	arg0_19:addSubLayers(Context.New({
		viewComponent = NewEducateReplaceTarotLayer,
		mediator = NewEducateReplaceTarotMediator,
		data = {
			onExit = function()
				arg0_19:CheckPriorityState()
			end
		}
	}))
end

return var0_0
