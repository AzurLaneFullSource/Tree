local var0_0 = class("AwardInfoMediator", import("..base.ContextMediator"))

var0_0.ON_DROP = "AwardInfoMediator:ON_DROP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DROP, function(arg0_2, arg1_2, arg2_2)
		if arg1_2.type == DROP_TYPE_EQUIP then
			arg0_1:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = arg1_2:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = arg2_2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		elseif arg1_2.type == DROP_TYPE_SPWEAPON then
			arg0_1:addSubLayers(Context.New({
				mediator = SpWeaponInfoMediator,
				viewComponent = SpWeaponInfoLayer,
				data = {
					spWeaponConfigId = arg1_2:getConfig("id"),
					type = SpWeaponInfoLayer.TYPE_DISPLAY,
					onRemoved = arg2_2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1_2,
				onNo = arg2_2,
				onYes = arg2_2,
				weight = LayerWeightConst.THIRD_LAYER
			})
		end
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.STORY_BEGIN,
		GAME.STORY_END,
		GAME.STORY_NEXT
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.STORY_BEGIN or var0_4 == GAME.STORY_NEXT then
		arg0_4.viewComponent:ShowOrHideSpriteMask(false)
	elseif var0_4 == GAME.STORY_END then
		arg0_4.viewComponent:ShowOrHideSpriteMask(true)
	end
end

return var0_0
