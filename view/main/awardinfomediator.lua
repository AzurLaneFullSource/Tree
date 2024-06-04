local var0 = class("AwardInfoMediator", import("..base.ContextMediator"))

var0.ON_DROP = "AwardInfoMediator:ON_DROP"

function var0.register(arg0)
	arg0:bind(var0.ON_DROP, function(arg0, arg1, arg2)
		if arg1.type == DROP_TYPE_EQUIP then
			arg0:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = arg1:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = arg2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		elseif arg1.type == DROP_TYPE_SPWEAPON then
			arg0:addSubLayers(Context.New({
				mediator = SpWeaponInfoMediator,
				viewComponent = SpWeaponInfoLayer,
				data = {
					spWeaponConfigId = arg1:getConfig("id"),
					type = SpWeaponInfoLayer.TYPE_DISPLAY,
					onRemoved = arg2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1,
				onNo = arg2,
				onYes = arg2,
				weight = LayerWeightConst.THIRD_LAYER
			})
		end
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.STORY_BEGIN,
		GAME.STORY_END,
		GAME.STORY_NEXT
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.STORY_BEGIN or var0 == GAME.STORY_NEXT then
		arg0.viewComponent:ShowOrHideSpriteMask(false)
	elseif var0 == GAME.STORY_END then
		arg0.viewComponent:ShowOrHideSpriteMask(true)
	end
end

return var0
