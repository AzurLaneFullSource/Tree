local var0 = class("EducateContextMediator", import("view.base.ContextMediator"))

function var0.onRegister(arg0)
	var0.super.onRegister(arg0)
	arg0:bind(EducateBaseUI.EDUCATE_GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(EducateBaseUI.EDUCATE_CHANGE_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.CHANGE_SCENE, arg1, ...)
	end)
	arg0:bind(EducateBaseUI.EDUCATE_GO_SUBLAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, nil, arg2)
	end)
	arg0:bind(EducateBaseUI.EDUCATE_ON_AWARD, function(arg0, arg1)
		if #arg1.items <= 0 then
			return
		end

		if #EducateHelper.FilterDropByTypes(arg1.items, {
			EducateConst.DROP_TYPE_ATTR,
			EducateConst.DROP_TYPE_RES,
			EducateConst.DROP_TYPE_ITEM,
			EducateConst.DROP_TYPE_BUFF,
			EducateConst.DROP_TYPE_POLAROID
		}) <= 0 then
			return
		end

		arg0:addSubLayers(Context.New({
			mediator = EducateAwardInfoMediator,
			viewComponent = EducateAwardInfoLayer,
			data = arg1
		}))
	end)
	arg0:bind(EducateBaseUI.EDUCATE_ON_ITEM, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateMsgBoxLayer,
			mediator = EducateMsgBoxMediator,
			data = setmetatable({
				type = EducateMsgBoxLayer.TYPE_SINGLE_ITEM
			}, {
				__index = arg1
			})
		}))
	end)
	arg0:bind(EducateBaseUI.EDUCATE_ON_MSG_TIP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateMsgBoxLayer,
			mediator = EducateMsgBoxMediator,
			data = setmetatable({
				type = EducateMsgBoxLayer.TYPE_NORMAL
			}, {
				__index = arg1
			})
		}))
	end)
	arg0:bind(EducateBaseUI.EDUCATE_ON_UNLOCK_TIP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateUnlockTipLayer,
			mediator = EducateContextMediator,
			data = arg1
		}))
	end)
end

return var0
