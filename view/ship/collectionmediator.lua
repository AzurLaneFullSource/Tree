local var0_0 = class("CollectionMediator", import("..base.ContextMediator"))

var0_0.EVENT_OBTAIN_SKIP = "CollectionMediator:EVENT_OBTAIN_SKIP"
var0_0.EVENT_OPEN_FULL_SCREEN_PIC_VIEW = "CollectionMediator:EVENT_OPEN_FULL_SCREEN_PIC_VIEW"

function var0_0.register(arg0_1)
	arg0_1.collectionProxy = getProxy(CollectionProxy)

	arg0_1.viewComponent:setShipGroups(arg0_1.collectionProxy:getGroups())
	arg0_1.viewComponent:setAwards(arg0_1.collectionProxy:getAwards())
	arg0_1.viewComponent:setCollectionRate(arg0_1.collectionProxy:getCollectionRate())
	arg0_1.viewComponent:setLinkCollectionCount(arg0_1.collectionProxy:getLinkCollectionCount())

	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getRawData())

	local var1_1 = getProxy(BayProxy)

	arg0_1.viewComponent:setProposeList(var1_1:getProposeGroupList())
	arg0_1:bind(CollectionScene.GET_AWARD, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.COLLECT_GET_AWARD, {
			id = arg1_2,
			index = arg2_2
		})
	end)
	arg0_1:bind(CollectionScene.SHOW_DETAIL, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIP_PROFILE, {
			showTrans = arg1_3,
			groupId = arg2_3
		})
	end)
	arg0_1:bind(CollectionScene.ACTIVITY_OP, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_4)
	end)
	arg0_1:bind(CollectionScene.BEGIN_STAGE, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, arg1_5)
	end)
	arg0_1:bind(CollectionScene.ON_INDEX, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)
	arg0_1:bind(var0_0.EVENT_OPEN_FULL_SCREEN_PIC_VIEW, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			mediator = GalleryFullScreenMediator,
			viewComponent = GalleryFullScreenLayer,
			data = {
				picID = arg1_7
			}
		}))
	end)
	arg0_1.viewComponent:updateCollectNotices(arg0_1.collectionProxy:hasFinish())
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		CollectionProxy.AWARDS_UPDATE,
		GAME.COLLECT_GET_AWARD_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		var0_0.EVENT_OBTAIN_SKIP
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == CollectionProxy.AWARDS_UPDATE then
		arg0_9.viewComponent:setAwards(var1_9)
	elseif var0_9 == GAME.COLLECT_GET_AWARD_DONE then
		arg0_9.viewComponent:sortDisplay()
		arg0_9.viewComponent:updateCollectNotices(arg0_9.collectionProxy:hasFinish())
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.items)
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:setPlayer(var1_9)
	elseif var0_9 == GAME.BEGIN_STAGE_DONE then
		arg0_9:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_9)
	elseif var0_9 == var0_0.EVENT_OBTAIN_SKIP then
		arg0_9.viewComponent:skipIn(var1_9.toggle, var1_9.displayGroupId)
	end
end

return var0_0
