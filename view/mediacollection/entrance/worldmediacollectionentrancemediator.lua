local var0 = class("WorldMediaCollectionEntranceMediator", import("view.base.ContextMediator"))

var0.OPEN_RECALL = "WorldMediaCollectionEntranceMediator:OPEN_RECALL"
var0.OPEN_CRYPTOLALIA = "WorldMediaCollectionEntranceMediator:OPEN_CRYPTOLALIA"
var0.OPEN_ARCHIVE = "WorldMediaCollectionEntranceMediator:OPEN_ARCHIVE"
var0.OPEN_RECORD = "WorldMediaCollectionEntranceMediator:OPEN_RECORD"

function var0.register(arg0)
	arg0:bind(var0.OPEN_CRYPTOLALIA, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA)
	end)
	arg0:bind(var0.OPEN_RECALL, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY
		})
	end)
	arg0:bind(var0.OPEN_ARCHIVE, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end)
	arg0:bind(var0.OPEN_RECORD, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_FILE
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
