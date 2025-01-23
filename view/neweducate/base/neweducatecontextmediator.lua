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

	arg0_1.contextData.char = getProxy(NewEducateProxy):GetCurChar()
end

return var0_0
