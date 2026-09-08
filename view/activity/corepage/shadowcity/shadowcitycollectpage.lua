local var0_0 = class("ShadowCityCollectPage", import("view.activity.CorePage.DOA.DOACoreActivityCollectPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.btnList = arg0_1.bg:Find("btn_list")
	arg0_1.itemPanel = arg0_1.bg:Find("item_panel")
	arg0_1.togglesTF = arg0_1.itemPanel:Find("toggles")
	arg0_1.content = arg0_1.itemPanel:Find("item_list/content")
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1.content:Find("tpl"))
	arg0_1.msgBox = ShadowCityCollectMsgBox.New(arg0_1._tf, arg0_1.event)

	setText(arg0_1.btnList:Find("medal/title"), i18n("shadowcitycollectpage_title_1"))
	setText(arg0_1.btnList:Find("furniture_theme/title"), i18n("shadowcitycollectpage_title_2"))
	setText(arg0_1.btnList:Find("equip_skin_box/title"), i18n("shadowcitycollectpage_title_3"))
	setText(arg0_1.btnList:Find("medal/btn_go/text"), i18n("task_go"))
	setText(arg0_1.btnList:Find("furniture_theme/btn_go/text"), i18n("task_go"))
	setText(arg0_1.btnList:Find("equip_skin_box/btn_go/text"), i18n("task_go"))
	setText(arg0_1.itemPanel:Find("title"), i18n("shadowcitycollectpage_title_4"))
	setText(arg0_1.togglesTF:Find("ship/name"), i18n("shadowcitycollectpage_toggle_1"))
	setText(arg0_1.togglesTF:Find("furniture/name"), i18n("shadowcitycollectpage_toggle_2"))
	setText(arg0_1.togglesTF:Find("equip_skin/name"), i18n("shadowcitycollectpage_toggle_3"))
end

function var0_0.GetTogglesDropTypes(arg0_2)
	return {
		DROP_TYPE_SHIP,
		{
			DROP_TYPE_FURNITURE,
			DROP_TYPE_RESOURCE,
			DROP_TYPE_ICON_FRAME
		},
		DROP_TYPE_EQUIPMENT_SKIN
	}
end

function var0_0.UpdatePage(arg0_3, arg1_3)
	var0_0.super.UpdatePage(arg0_3, arg1_3)
	setActive(arg0_3.itemPanel:Find("full_scroll_bar"), not arg0_3.bg:Find("Scrollbar").gameObject.activeSelf)
end

function var0_0.OnUpdateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.showDataList[arg1_4 + 1]
	local var1_4 = arg2_4:Find("icon_mask/icon")
	local var2_4 = {
		type = var0_4.config.type,
		id = var0_4.config.drop_id
	}

	updateDrop(var1_4, var2_4)
	onButton(arg0_4, var1_4, function()
		arg0_4:OnClickItem(var0_4)
	end, SFX_PANEL)
	changeToScrollText(arg2_4:Find("name_mask/name"), Drop.New({
		type = var0_4.config.type,
		id = var0_4.config.drop_id
	}):getName())
	arg0_4:RefreshCountText(var0_4, arg2_4)

	GetOrAddComponent(arg2_4:Find("owner"), typeof(CanvasGroup)).alpha = var0_4.count == var0_4.config.count and 0.5 or 1

	setActive(arg2_4:Find("new"), var0_4.config.is_new == "1")

	if var2_4.type == 4 then
		setActive(arg2_4:Find("got"), var0_4.count >= 1)
	else
		setActive(arg2_4:Find("got"), var0_4.count == var0_4.config.count)
	end
end

function var0_0.IsShowingPopWindow(arg0_6)
	return arg0_6.msgBox and arg0_6.msgBox:isShowing() or false
end

function var0_0.ClosePopWindow(arg0_7)
	if arg0_7.msgBox and arg0_7.msgBox:isShowing() then
		arg0_7.msgBox:Hide()
	end
end

return var0_0
