local var0_0 = class("NewSkinTBMediator", import("..base.ContextMediator"))

var0_0.SET_SKIN = "NewSkinTBMediator:SET_SKIN"
var0_0.ON_EXIT = "NewSkinTBMediator:ON_EXIT"
var0_0.GO_SET_TB_SKIN = "NewSkinTBMediator:GO_SET_TB_SKIN"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SET_SKIN, function(arg0_2, arg1_2, arg2_2)
		for iter0_2, iter1_2 in ipairs(arg1_2) do
			arg0_1:sendNotification(GAME.SET_SHIP_SKIN, {
				shipId = iter1_2,
				skinId = arg0_1.contextData.skinId
			})
		end

		getProxy(SettingsProxy):SetFlagShip(arg2_2)

		if arg2_2 then
			local var0_2 = arg1_2[1]

			arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
				skinPage = true,
				characterId = var0_2
			})
		end

		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_1:bind(var0_0.GO_SET_TB_SKIN, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EDUCATE_DOCK, {
			OnSelected = function(arg0_4)
				arg0_1:sendNotification(GAME.CHANGE_EDUCATE, {
					id = arg0_4
				})
			end,
			tbSkinId = arg0_1.contextData.skinId
		})
	end)

	arg0_1.contextData.secId = NewEducateHelper.GetSecIdBySkinId(arg0_1.contextData.skinId)
	arg0_1.contextData.isClose = getProxy(PlayerProxy):getRawData():GetEducateCharacter() == arg0_1.contextData.secId

	arg0_1.viewComponent:setSkin(arg0_1.contextData.skinId)
end

function var0_0.onUIAvalible(arg0_5)
	return
end

function var0_0.listNotificationInterests(arg0_6)
	return {}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()
end

return var0_0
