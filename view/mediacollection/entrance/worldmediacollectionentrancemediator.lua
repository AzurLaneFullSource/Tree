local var0_0 = class("WorldMediaCollectionEntranceMediator", import("view.base.ContextMediator"))

var0_0.OPEN_RECALL = "WorldMediaCollectionEntranceMediator:OPEN_RECALL"
var0_0.OPEN_NEWRECALL = "WorldMediaCollectionEntranceMediator:OPEN_NEWRECALL"
var0_0.OPEN_CRYPTOLALIA = "WorldMediaCollectionEntranceMediator:OPEN_CRYPTOLALIA"
var0_0.OPEN_ARCHIVE = "WorldMediaCollectionEntranceMediator:OPEN_ARCHIVE"
var0_0.OPEN_RECORD = "WorldMediaCollectionEntranceMediator:OPEN_RECORD"
var0_0.OPEN_ALBUM = "WorldMediaCollectionEntranceMediator:OPEN_ALBUM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CRYPTOLALIA, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA)
	end)
	arg0_1:bind(var0_0.OPEN_RECALL, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY
		})
	end)
	arg0_1:bind(var0_0.OPEN_NEWRECALL, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_SHIP
		})
	end)
	arg0_1:bind(var0_0.OPEN_ARCHIVE, function(arg0_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end)
	arg0_1:bind(var0_0.OPEN_RECORD, function(arg0_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_FILE
		})
	end)
	arg0_1:bind(var0_0.OPEN_ALBUM, function(arg0_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_ALBUM
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()
end

return var0_0
