local var0_0 = class("MainOverDueEquipmentSequence", import(".MainSublayerSequence"))

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(EquipmentProxy):getTimeLimitShipList()

	if #var0_1 > 0 then
		arg0_1:ShowMsgBox({
			item2Row = true,
			itemList = var0_1,
			content = i18n("time_limit_equip_destroy_on_ship"),
			onYes = arg1_1,
			onNo = arg1_1
		})
	else
		arg1_1()
	end
end

function var0_0.ShowMsgBox(arg0_2, arg1_2)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_ITEM_BOX,
		items = arg1_2.itemList,
		content = arg1_2.content,
		item2Row = arg1_2.item2Row,
		itemFunc = function(arg0_3)
			arg0_2:ShowItemBox(arg0_3, function()
				arg0_2:ShowMsgBox(arg1_2)
			end)
		end,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.ShowItemBox(arg0_5, arg1_5, arg2_5)
	if arg1_5.type == DROP_TYPE_EQUIP then
		arg0_5:AddSubLayers(Context.New({
			mediator = EquipmentInfoMediator,
			viewComponent = EquipmentInfoLayer,
			data = {
				equipmentId = arg1_5:getConfig("id"),
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				onRemoved = arg2_5,
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	elseif arg1_5.type == DROP_TYPE_SPWEAPON then
		arg0_5:AddSubLayers(Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = {
				spWeaponConfigId = arg1_5:getConfig("id"),
				type = SpWeaponInfoLayer.TYPE_DISPLAY,
				onRemoved = arg2_5,
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = arg1_5,
			onNo = arg2_5,
			onYes = arg2_5,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0_0
