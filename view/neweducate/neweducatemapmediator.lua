local var0_0 = class("NewEducateMapMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_SITE_NORMAL = "NewEducateMapMediator.ON_SITE_NORMAL"
var0_0.ON_SITE_EVENT = "NewEducateMapMediator.ON_SITE_EVENT"
var0_0.ON_SITE_SHIP = "NewEducateMapMediator.ON_SITE_SHIP"
var0_0.ON_SHOPPING = "NewEducateMapMediator.ON_SHOPPING"
var0_0.ON_REFRESH_SHOP = "NewEducateMapMediator.ON_REFRESH_SHOP"
var0_0.ON_UPGRADE_NORMAL = "NewEducateMapMediator.ON_UPGRADE_NORMAL"
var0_0.ON_SHIP_UPGRADE_LEVEL = "NewEducateMapMediator.ON_SHIP_UPGRADE_LEVEL"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SITE_NORMAL, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_NORMAL, {
			id = arg0_1.contextData.char.id,
			normalId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_SITE_EVENT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_EVENT, {
			id = arg0_1.contextData.char.id,
			eventId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_SITE_SHIP, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_SHIP, {
			id = arg0_1.contextData.char.id,
			shipId = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SHOPPING, {
			id = arg0_1.contextData.char.id,
			goodId = arg1_5,
			num = arg2_5 or 1
		})
	end)
	arg0_1:bind(var0_0.ON_REFRESH_SHOP, function(arg0_6)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_SHOP, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_NORMAL, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_NORMAL_SITE, {
			id = arg0_1.contextData.char.id,
			normalId = arg1_7,
			callback = arg2_7
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		NewEducateProxy.RESOURCE_UPDATED,
		NewEducateProxy.ATTR_UPDATED,
		NewEducateProxy.PERSONALITY_UPDATED,
		NewEducateProxy.TALENT_UPDATED,
		NewEducateProxy.STATUS_UPDATED,
		NewEducateProxy.TAROT_UPDATED,
		GAME.NEW_EDUCATE_NODE_START,
		GAME.NEW_EDUCATE_NEXT_NODE,
		GAME.NEW_EDUCATE_SHOPPING_DONE,
		GAME.NEW_EDUCATE_REFRESH_SHOP_DONE,
		GAME.NEW_EDUCATE_REFRESH_DONE,
		GAME.NEW_EDUCATE_MAP_NORMAL_DONE,
		GAME.NEW_EDUCATE_MAP_EVENT_DONE,
		GAME.NEW_EDUCATE_MAP_SHIP_DONE,
		GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM,
		var0_0.ON_SHIP_UPGRADE_LEVEL
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == NewEducateProxy.RESOURCE_UPDATED then
		arg0_9.viewComponent:OnResUpdate()
	elseif var0_9 == NewEducateProxy.ATTR_UPDATED then
		arg0_9.viewComponent:OnAttrUpdate()
	elseif var0_9 == NewEducateProxy.PERSONALITY_UPDATED then
		arg0_9.viewComponent:OnPersonalityUpdate(var1_9.number, var1_9.oldTag)
	elseif var0_9 == NewEducateProxy.TALENT_UPDATED then
		arg0_9.viewComponent:OnTalentUpdate()
	elseif var0_9 == NewEducateProxy.STATUS_UPDATED then
		arg0_9.viewComponent:OnStatusUpdate()
	elseif var0_9 == NewEducateProxy.TAROT_UPDATED then
		arg0_9.viewComponent:OnTarotUpdate()
	elseif var0_9 == GAME.NEW_EDUCATE_NODE_START then
		arg0_9.viewComponent:OnNodeStart(var1_9.node)
	elseif var0_9 == GAME.NEW_EDUCATE_NEXT_NODE then
		arg0_9.viewComponent:OnNextNode(var1_9)
	elseif var0_9 == GAME.NEW_EDUCATE_SHOPPING_DONE then
		seriesAsync({
			function(arg0_10)
				if not var1_9.isUpgradeEntry then
					arg0_9.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
						items = var1_9.drops,
						removeFunc = arg0_10
					})
				else
					arg0_10()
				end
			end
		}, function()
			arg0_9.viewComponent:OnShoppingDone()
		end)
	elseif var0_9 == GAME.NEW_EDUCATE_REFRESH_SHOP_DONE then
		arg0_9.viewComponent:OnRefreshShopDone()
	elseif var0_9 == GAME.NEW_EDUCATE_REFRESH_DONE then
		arg0_9.viewComponent:emit(NewEducateBaseUI.GO_SCENE, SCENE.NEW_EDUCATE, {
			id = var1_9.id
		})
	elseif var0_9 == GAME.NEW_EDUCATE_MAP_NORMAL_DONE then
		arg0_9:StartNodeWithCheckDrops(var1_9)
	elseif var0_9 == GAME.NEW_EDUCATE_MAP_EVENT_DONE then
		arg0_9:StartNodeWithCheckDrops(var1_9)
	elseif var0_9 == GAME.NEW_EDUCATE_MAP_SHIP_DONE then
		arg0_9:StartNodeWithCheckDrops(var1_9)
	elseif var0_9 == var0_0.ON_SHIP_UPGRADE_LEVEL then
		arg0_9.viewComponent:UpdateShipLv()
	elseif var0_9 == GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM then
		arg0_9:CheckPriorityState()
	end
end

function var0_0.StartNodeWithCheckDrops(arg0_12, arg1_12)
	if #arg1_12.drops == 0 then
		arg0_12.viewComponent:OnNodeStart(arg1_12.node)
	else
		arg0_12.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			items = arg1_12.drops,
			removeFunc = function()
				arg0_12.viewComponent:OnNodeStart(arg1_12.node)
			end
		})
	end
end

return var0_0
