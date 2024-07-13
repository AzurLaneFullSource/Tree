local var0_0 = class("MetaCharacterRepairMediator", import("...base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.REPAIR_META_CHARACTER_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.REPAIR_META_CHARACTER_DONE then
		arg0_3.viewComponent:checkSpecialEffect()
		arg0_3.viewComponent:updateData()
		arg0_3.viewComponent:doRepairProgressPanelAni()
		arg0_3.viewComponent:updateAttrItem(arg0_3.viewComponent.attrTFList[arg0_3.viewComponent.curAttrName], arg0_3.viewComponent.curAttrName)
		arg0_3.viewComponent:updateRepairBtn()
		arg0_3.viewComponent:updateDetailPanel()
	end
end

return var0_0
