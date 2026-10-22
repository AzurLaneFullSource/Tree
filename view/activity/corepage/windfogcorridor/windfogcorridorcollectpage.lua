local var0_0 = class("WindFogCorridorCollectPage", import("view.activity.CorePage.DOA.DOACoreActivityCollectPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.btnList = arg0_1.bg:Find("btn_list")
	arg0_1.itemPanel = arg0_1.bg:Find("item_panel")
	arg0_1.togglesTF = arg0_1.itemPanel:Find("toggles")
	arg0_1.content = arg0_1.itemPanel:Find("item_list/content")
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1.content:Find("tpl"))
	arg0_1.msgBox = WindFogCorridorCollectMsgBox.New(arg0_1._tf, arg0_1.event)
end

function var0_0.GetTogglesDropTypes(arg0_2)
	return {
		DROP_TYPE_SHIP,
		{
			DROP_TYPE_FURNITURE,
			DROP_TYPE_RESOURCE,
			DROP_TYPE_ICON_FRAME,
			DROP_TYPE_COMMANDER_CAT,
			DROP_TYPE_EQUIP
		},
		{
			DROP_TYPE_EQUIPMENT_SKIN
		}
	}
end

function var0_0.IsShowingPopWindow(arg0_3)
	return arg0_3.msgBox and arg0_3.msgBox:isShowing() or false
end

function var0_0.ClosePopWindow(arg0_4)
	if arg0_4.msgBox and arg0_4.msgBox:isShowing() then
		arg0_4.msgBox:Hide()
	end
end

function var0_0.OnUpdateItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.showDataList[arg1_5 + 1]
	local var1_5 = arg2_5:Find("icon_mask/icon")
	local var2_5 = {
		type = var0_5.config.type,
		id = var0_5.config.drop_id
	}

	updateDrop(var1_5, var2_5)
	onButton(arg0_5, var1_5, function()
		arg0_5:OnClickItem(var0_5)
	end, SFX_PANEL)
	changeToScrollText(arg2_5:Find("name_mask/mask/name"), Drop.New({
		type = var0_5.config.type,
		id = var0_5.config.drop_id
	}):getName())

	local var3_5 = var0_5.count > 0 and var0_5.count >= var0_5.config.count
	local var4_5 = GetOrAddComponent(arg2_5:Find("owner"), typeof(CanvasGroup))

	if var2_5.type == 4 then
		local var5_5 = Ship.getGroupIdByConfigId(var0_5.config.drop_id)

		var0_5.count = #getProxy(BayProxy):findShipsByGroup(var5_5)
		var3_5 = var0_5.count >= 1
	end

	arg0_5:RefreshCountText(var0_5, arg2_5)

	var4_5.alpha = var3_5 and 0.5 or 1

	setActive(arg2_5:Find("got"), var3_5)
	setActive(arg2_5:Find("new"), var0_5.config.is_new == "1")
end

return var0_0
