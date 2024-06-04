local var0 = class("MetaCharacterRepairMediator", import("...base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.REPAIR_META_CHARACTER_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.REPAIR_META_CHARACTER_DONE then
		arg0.viewComponent:checkSpecialEffect()
		arg0.viewComponent:updateData()
		arg0.viewComponent:doRepairProgressPanelAni()
		arg0.viewComponent:updateAttrItem(arg0.viewComponent.attrTFList[arg0.viewComponent.curAttrName], arg0.viewComponent.curAttrName)
		arg0.viewComponent:updateRepairBtn()
		arg0.viewComponent:updateDetailPanel()
	end
end

return var0
