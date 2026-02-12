local var0_0 = class("LoveLetterGiftLevelDisplayMediator", import("view.base.ContextMediator"))

var0_0.ON_GO_COLLECTION = "LoveLetterGiftLevelDisplayMediator.ON_GO_COLLECTION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GO_COLLECTION, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_ALBUM,
			albumType = WorldMediaCollectionAlbumGroupLayer.ALBUM_TYPE_LOVE_LETTER
		})
	end)
	arg0_1.viewComponent:SetLoveLetter(arg0_1.contextData.groupId)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {}
end

return var0_0
