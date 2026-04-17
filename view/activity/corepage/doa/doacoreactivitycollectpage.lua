local var0_0 = class("DOACoreActivityCollectPage", import("view.activity.CorePage.templatePage.CoreAwardTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.btnList = arg0_1.bg:Find("btn_list")
	arg0_1.itemPanel = arg0_1.bg:Find("item_panel")
	arg0_1.togglesTF = arg0_1.itemPanel:Find("toggles")
	arg0_1.content = arg0_1.itemPanel:Find("item_list/content")
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1.content:Find("tpl"))
	arg0_1.msgBox = DOACoreActivityMsgBox.New(arg0_1._tf, arg0_1.event)
end

function var0_0.GetTogglesDropTypes(arg0_2)
	return {
		DROP_TYPE_EQUIP,
		DROP_TYPE_SPWEAPON
	}
end

function var0_0.OnClickItem(arg0_3, arg1_3)
	arg0_3.msgBox:ExecuteAction("Show", {
		drop_type = arg1_3.config.type,
		drop_id = arg1_3.config.drop_id,
		count = arg1_3.count,
		count_limit = arg1_3.config.count,
		skipable_list = arg1_3.config.link_params
	})
end

function var0_0.AddSpecialBtnListener(arg0_4)
	local var0_4 = arg0_4.activity:getConfig("config_client")

	arg0_4.furnitureThemeBtn = arg0_4.btnList:Find("furniture_theme")

	if arg0_4.furnitureThemeBtn and var0_4.furniture_theme_link then
		onButton(arg0_4, arg0_4.furnitureThemeBtn, function()
			local var0_5 = var0_4.furniture_theme_link
			local var1_5 = var0_5[1]
			local var2_5 = var0_5[2]
			local var3_5 = var0_5[3]

			arg0_4:DoSkip(var1_5, var2_5)
		end, SFX_PANEL)
	end

	arg0_4.medalBtn = arg0_4.btnList:Find("medal")

	if arg0_4.medalBtn and var0_4.medal_link then
		onButton(arg0_4, arg0_4.medalBtn, function()
			local var0_6 = var0_4.medal_link
			local var1_6 = var0_6[1]
			local var2_6 = var0_6[2]
			local var3_6 = var0_6[3]

			arg0_4:DoSkip(var1_6, var2_6)
		end, SFX_PANEL)
	end

	arg0_4.equipSkinBoxBtn = arg0_4.btnList:Find("equip_skin_box")

	if arg0_4.equipSkinBoxBtn and var0_4.equipskin_box_link then
		local var1_4 = Drop.New({
			type = var0_4.equipskin_box_link.drop_type,
			id = var0_4.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0_4, arg0_4.equipSkinBoxBtn, function()
			arg0_4.msgBox:ExecuteAction("Show", {
				drop_type = var0_4.equipskin_box_link.drop_type,
				drop_id = var0_4.equipskin_box_link.drop_id,
				count = var1_4,
				skipable_list = var0_4.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

function var0_0.OnHideFlush(arg0_8)
	if arg0_8.msgBox:isShowing() then
		arg0_8.msgBox:Hide()
	end
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9.msgBox then
		arg0_9.msgBox:Hide()
		arg0_9.msgBox:Destroy()

		arg0_9.msgBox = nil
	end
end

return var0_0
