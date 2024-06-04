local var0 = class("MainOverDueEquipmentSequence", import(".MainSublayerSequence"))

function var0.Execute(arg0, arg1)
	local var0 = getProxy(EquipmentProxy):getTimeLimitShipList()

	if #var0 > 0 then
		arg0:ShowMsgBox({
			item2Row = true,
			itemList = var0,
			content = i18n("time_limit_equip_destroy_on_ship"),
			onYes = arg1,
			onNo = arg1
		})
	else
		arg1()
	end
end

function var0.ShowMsgBox(arg0, arg1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_ITEM_BOX,
		items = arg1.itemList,
		content = arg1.content,
		item2Row = arg1.item2Row,
		itemFunc = function(arg0)
			arg0:ShowItemBox(arg0, function()
				arg0:ShowMsgBox(arg1)
			end)
		end,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.ShowItemBox(arg0, arg1, arg2)
	if arg1.type == DROP_TYPE_EQUIP then
		arg0:AddSubLayers(Context.New({
			mediator = EquipmentInfoMediator,
			viewComponent = EquipmentInfoLayer,
			data = {
				equipmentId = arg1:getConfig("id"),
				type = EquipmentInfoMediator.TYPE_DISPLAY,
				onRemoved = arg2,
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	elseif arg1.type == DROP_TYPE_SPWEAPON then
		arg0:AddSubLayers(Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = {
				spWeaponConfigId = arg1:getConfig("id"),
				type = SpWeaponInfoLayer.TYPE_DISPLAY,
				onRemoved = arg2,
				LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
			}
		}))
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = arg1,
			onNo = arg2,
			onYes = arg2,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0
