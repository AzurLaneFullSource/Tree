local var0_0 = class("NewEducateMapMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_SITE_NORMAL = "NewEducateMapMediator.ON_SITE_NORMAL"
var0_0.ON_SITE_EVENT = "NewEducateMapMediator.ON_SITE_EVENT"
var0_0.ON_SITE_SHIP = "NewEducateMapMediator.ON_SITE_SHIP"
var0_0.ON_SHOPPING = "NewEducateMapMediator.ON_SHOPPING"
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
	arg0_1:bind(var0_0.ON_UPGRADE_NORMAL, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_NORMAL_SITE, {
			id = arg0_1.contextData.char.id,
			normalId = arg1_6,
			callback = arg2_6
		})
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		NewEducateProxy.RESOURCE_UPDATED,
		NewEducateProxy.ATTR_UPDATED,
		NewEducateProxy.PERSONALITY_UPDATED,
		NewEducateProxy.TALENT_UPDATED,
		NewEducateProxy.STATUS_UPDATED,
		GAME.NEW_EDUCATE_NODE_START,
		GAME.NEW_EDUCATE_NEXT_NODE,
		GAME.NEW_EDUCATE_SHOPPING_DONE,
		GAME.NEW_EDUCATE_REFRESH_DONE,
		GAME.NEW_EDUCATE_MAP_NORMAL_DONE,
		GAME.NEW_EDUCATE_MAP_EVENT_DONE,
		GAME.NEW_EDUCATE_MAP_SHIP_DONE,
		var0_0.ON_SHIP_UPGRADE_LEVEL
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == NewEducateProxy.RESOURCE_UPDATED then
		arg0_8.viewComponent:OnResUpdate()
	elseif var0_8 == NewEducateProxy.ATTR_UPDATED then
		arg0_8.viewComponent:OnAttrUpdate()
	elseif var0_8 == NewEducateProxy.PERSONALITY_UPDATED then
		arg0_8.viewComponent:OnPersonalityUpdate(var1_8.number, var1_8.oldTag)
	elseif var0_8 == NewEducateProxy.TALENT_UPDATED then
		arg0_8.viewComponent:OnTalentUpdate()
	elseif var0_8 == NewEducateProxy.STATUS_UPDATED then
		arg0_8.viewComponent:OnStatusUpdate()
	elseif var0_8 == GAME.NEW_EDUCATE_NODE_START then
		arg0_8.viewComponent:OnNodeStart(var1_8.node)
	elseif var0_8 == GAME.NEW_EDUCATE_NEXT_NODE then
		arg0_8.viewComponent:OnNextNode(var1_8)
	elseif var0_8 == GAME.NEW_EDUCATE_SHOPPING_DONE then
		arg0_8.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			items = var1_8.drops,
			removeFunc = function()
				arg0_8.viewComponent:OnShoppingDone()
			end
		})
	elseif var0_8 == GAME.NEW_EDUCATE_REFRESH_DONE then
		arg0_8.viewComponent:emit(NewEducateBaseUI.GO_SCENE, SCENE.NEW_EDUCATE, {
			id = var1_8.id
		})
	elseif var0_8 == GAME.NEW_EDUCATE_MAP_NORMAL_DONE then
		arg0_8:StartNodeWithCheckDrops(var1_8)
	elseif var0_8 == GAME.NEW_EDUCATE_MAP_EVENT_DONE then
		arg0_8:StartNodeWithCheckDrops(var1_8)
	elseif var0_8 == GAME.NEW_EDUCATE_MAP_SHIP_DONE then
		arg0_8:StartNodeWithCheckDrops(var1_8)
	elseif var0_8 == var0_0.ON_SHIP_UPGRADE_LEVEL then
		arg0_8.viewComponent:UpdateShipLv()
	end
end

function var0_0.StartNodeWithCheckDrops(arg0_10, arg1_10)
	if #arg1_10.drops == 0 then
		arg0_10.viewComponent:OnNodeStart(arg1_10.node)
	else
		arg0_10.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			items = arg1_10.drops,
			removeFunc = function()
				arg0_10.viewComponent:OnNodeStart(arg1_10.node)
			end
		})
	end
end

return var0_0
