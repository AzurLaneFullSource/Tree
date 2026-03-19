local var0_0 = class("NewEducateTarotEntryMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_UPGRADE_ENTRY = "NewEducateTarotEntryMediator.ON_UPGRADE_ENTRY"
var0_0.ON_GIVE_UP_ENTRY_UP = "NewEducateTarotEntryMediator.ON_GIVE_UP_ENTRY_UP"
var0_0.ON_SHOPPING = "NewEducateTarotEntryMediator.ON_SHOPPING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_UPGRADE_ENTRY, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_ENTRY, {
			id = arg0_1.contextData.char.id,
			entryId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_GIVE_UP_ENTRY_UP, function(arg0_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GIVE_UP_ENTRY_UP, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_SHOPPING, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SHOPPING, {
			isUpgradeEntry = true,
			num = 1,
			id = arg0_1.contextData.char.id,
			goodId = arg1_4,
			callback = arg2_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.NEW_EDUCATE_GIVE_UP_ENTRY_UP_DONE,
		GAME.NEW_EDUCATE_UPGRADE_ENTRY_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.NEW_EDUCATE_GIVE_UP_ENTRY_UP_DONE then
		arg0_6.viewComponent:closeView()
	elseif var0_6 == GAME.NEW_EDUCATE_UPGRADE_ENTRY_DONE then
		arg0_6.viewComponent:OnUpgradeDone(var1_6)
	end
end

return var0_0
