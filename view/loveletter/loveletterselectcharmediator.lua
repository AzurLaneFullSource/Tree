local var0_0 = class("LoveLetterSelectCharMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(LoveLetterSelectCharLayer.SELECT_CHAR, function(arg0_2, arg1_2)
		if arg0_1.contextData.isRepair then
			arg0_1:addSubLayers(Context.New({
				viewComponent = LoveLetterSelectCharConfirmLayer,
				mediator = LoveLetterSelectCharConfirmMediator,
				data = {
					isRepair = true,
					groupId = arg1_2,
					itemVO = arg0_1.contextData.itemVO
				}
			}))
		else
			if getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId):GetTargetGroupId() == arg1_2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("loveactivity_ui_18"))

				return
			end

			arg0_1:addSubLayers(Context.New({
				viewComponent = LoveLetterSelectCharConfirmLayer,
				mediator = LoveLetterSelectCharConfirmMediator,
				data = {
					groupId = arg1_2,
					actId = arg0_1.contextData.actId
				}
			}))
		end
	end)
	arg0_1:bind(LoveLetterSelectCharLayer.ON_INDEX, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_3
		}))
	end)

	local var0_1 = getProxy(CollectionProxy)

	arg0_1.viewComponent:setShipGroups(var0_1:getGroups())

	local var1_1 = getProxy(BayProxy)

	arg0_1.viewComponent:setProposeList(var1_1:getProposeGroupList())
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_5, arg1_5)
			if arg1_5:getBody() == arg0_5.contextData.actId then
				arg0_5.viewComponent:closeView()
			end
		end,
		[GAME.USE_ITEM_DONE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:closeView()
		end
	}
end

return var0_0
