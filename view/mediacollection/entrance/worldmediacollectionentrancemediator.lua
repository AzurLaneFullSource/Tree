﻿local var0_0 = class("WorldMediaCollectionEntranceMediator", import("view.base.ContextMediator"))

var0_0.OPEN_RECALL = "WorldMediaCollectionEntranceMediator:OPEN_RECALL"
var0_0.OPEN_CRYPTOLALIA = "WorldMediaCollectionEntranceMediator:OPEN_CRYPTOLALIA"
var0_0.OPEN_ARCHIVE = "WorldMediaCollectionEntranceMediator:OPEN_ARCHIVE"
var0_0.OPEN_RECORD = "WorldMediaCollectionEntranceMediator:OPEN_RECORD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CRYPTOLALIA, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA)
	end)
	arg0_1:bind(var0_0.OPEN_RECALL, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY
		})
	end)
	arg0_1:bind(var0_0.OPEN_ARCHIVE, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_RECORD
		})
	end)
	arg0_1:bind(var0_0.OPEN_RECORD, function(arg0_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_FILE
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()
end

return var0_0