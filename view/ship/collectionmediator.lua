local var0 = class("CollectionMediator", import("..base.ContextMediator"))

var0.EVENT_OBTAIN_SKIP = "CollectionMediator:EVENT_OBTAIN_SKIP"
var0.EVENT_OPEN_FULL_SCREEN_PIC_VIEW = "CollectionMediator:EVENT_OPEN_FULL_SCREEN_PIC_VIEW"

function var0.register(arg0)
	arg0.collectionProxy = getProxy(CollectionProxy)

	arg0.viewComponent:setShipGroups(arg0.collectionProxy:getGroups())
	arg0.viewComponent:setAwards(arg0.collectionProxy:getAwards())
	arg0.viewComponent:setCollectionRate(arg0.collectionProxy:getCollectionRate())
	arg0.viewComponent:setLinkCollectionCount(arg0.collectionProxy:getLinkCollectionCount())

	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var0:getRawData())

	local var1 = getProxy(BayProxy)

	arg0.viewComponent:setProposeList(var1:getProposeGroupList())
	arg0:bind(CollectionScene.GET_AWARD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COLLECT_GET_AWARD, {
			id = arg1,
			index = arg2
		})
	end)
	arg0:bind(CollectionScene.SHOW_DETAIL, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIP_PROFILE, {
			showTrans = arg1,
			groupId = arg2
		})
	end)
	arg0:bind(CollectionScene.ACTIVITY_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:bind(CollectionScene.BEGIN_STAGE, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, arg1)
	end)
	arg0:bind(CollectionScene.ON_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.EVENT_OPEN_FULL_SCREEN_PIC_VIEW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = GalleryFullScreenMediator,
			viewComponent = GalleryFullScreenLayer,
			data = {
				picID = arg1
			}
		}))
	end)
	arg0.viewComponent:updateCollectNotices(arg0.collectionProxy:hasFinish())
end

function var0.listNotificationInterests(arg0)
	return {
		CollectionProxy.AWARDS_UPDATE,
		GAME.COLLECT_GET_AWARD_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		var0.EVENT_OBTAIN_SKIP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == CollectionProxy.AWARDS_UPDATE then
		arg0.viewComponent:setAwards(var1)
	elseif var0 == GAME.COLLECT_GET_AWARD_DONE then
		arg0.viewComponent:sortDisplay()
		arg0.viewComponent:updateCollectNotices(arg0.collectionProxy:hasFinish())
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.items)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == var0.EVENT_OBTAIN_SKIP then
		arg0.viewComponent:skipIn(var1.toggle, var1.displayGroupId)
	end
end

return var0
