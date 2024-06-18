local var0_0 = class("EducateContextMediator", import("view.base.ContextMediator"))

function var0_0.onRegister(arg0_1)
	var0_0.super.onRegister(arg0_1)
	arg0_1:bind(EducateBaseUI.EDUCATE_GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_CHANGE_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_ON_AWARD, function(arg0_5, arg1_5)
		if #arg1_5.items <= 0 then
			return
		end

		if #EducateHelper.FilterDropByTypes(arg1_5.items, {
			EducateConst.DROP_TYPE_ATTR,
			EducateConst.DROP_TYPE_RES,
			EducateConst.DROP_TYPE_ITEM,
			EducateConst.DROP_TYPE_BUFF,
			EducateConst.DROP_TYPE_POLAROID
		}) <= 0 then
			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = EducateAwardInfoMediator,
			viewComponent = EducateAwardInfoLayer,
			data = arg1_5
		}))
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_ON_ITEM, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EducateMsgBoxLayer,
			mediator = EducateMsgBoxMediator,
			data = setmetatable({
				type = EducateMsgBoxLayer.TYPE_SINGLE_ITEM
			}, {
				__index = arg1_6
			})
		}))
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_ON_MSG_TIP, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EducateMsgBoxLayer,
			mediator = EducateMsgBoxMediator,
			data = setmetatable({
				type = EducateMsgBoxLayer.TYPE_NORMAL
			}, {
				__index = arg1_7
			})
		}))
	end)
	arg0_1:bind(EducateBaseUI.EDUCATE_ON_UNLOCK_TIP, function(arg0_8, arg1_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EducateUnlockTipLayer,
			mediator = EducateContextMediator,
			data = arg1_8
		}))
	end)
end

return var0_0
