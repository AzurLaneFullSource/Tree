local var0_0 = class("EscapeManorCollectPage", import("view.activity.CorePage.DOA.DOACoreActivityCollectPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.btnList = arg0_1.bg:Find("btn_list")
	arg0_1.itemPanel = arg0_1.bg:Find("item_panel")
	arg0_1.togglesTF = arg0_1.itemPanel:Find("toggles")
	arg0_1.content = arg0_1.itemPanel:Find("item_list/content")
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1.content:Find("tpl"))
	arg0_1.msgBox = EscapeManorCollectMsgBox.New(arg0_1._tf, arg0_1.event)
end

function var0_0.AddSpecialBtnListener(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")

	arg0_2.furnitureThemeBtn = arg0_2.btnList:Find("furniture_theme")

	if arg0_2.furnitureThemeBtn and var0_2.furniture_theme_link then
		onButton(arg0_2, arg0_2.furnitureThemeBtn, function()
			local var0_3 = var0_2.furniture_theme_link
			local var1_3 = var0_3[1]
			local var2_3 = var0_3[2]
			local var3_3 = var0_3[3]

			arg0_2:DoSkip(var1_3, var2_3)
		end, SFX_PANEL)
	end

	arg0_2.equipSkinBoxBtn = arg0_2.btnList:Find("equip_skin_box")

	if arg0_2.equipSkinBoxBtn and var0_2.equipskin_box_link then
		local var1_2 = Drop.New({
			type = var0_2.equipskin_box_link.drop_type,
			id = var0_2.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0_2, arg0_2.equipSkinBoxBtn, function()
			arg0_2.msgBox:ExecuteAction("Show", {
				drop_type = var0_2.equipskin_box_link.drop_type,
				drop_id = var0_2.equipskin_box_link.drop_id,
				count = var1_2,
				skipable_list = var0_2.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

function var0_0.UpdatePage(arg0_5, arg1_5)
	arg0_5.curPage = arg1_5
	arg0_5.showDataList = Clone(arg0_5.dataList)

	table.sort(arg0_5.showDataList, CompareFuncs({
		function(arg0_6)
			return arg0_6.count < arg0_6.config.count and 0 or 1
		end,
		function(arg0_7)
			return arg0_7.config.order
		end,
		function(arg0_8)
			return arg0_8.id
		end
	}))
	arg0_5.itemList:align(#arg0_5.showDataList)
end

function var0_0.OnUpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.showDataList[arg1_9 + 1]
	local var1_9 = arg2_9:Find("icon_mask/icon")
	local var2_9 = {
		type = var0_9.config.type,
		id = var0_9.config.drop_id
	}

	updateDrop(var1_9, var2_9)
	onButton(arg0_9, var1_9, function()
		arg0_9:OnClickItem(var0_9)
	end, SFX_PANEL)
	changeToScrollText(arg2_9:Find("name_mask/name"), Drop.New({
		type = var0_9.config.type,
		id = var0_9.config.drop_id
	}):getName())
	arg0_9:RefreshCountText(var0_9, arg2_9)

	GetOrAddComponent(arg2_9:Find("owner"), typeof(CanvasGroup)).alpha = var0_9.count == var0_9.config.count and 0.5 or 1

	setActive(arg2_9:Find("new"), var0_9.config.is_new == "1")

	if var2_9.type == 4 then
		setActive(arg2_9:Find("got"), var0_9.count >= 1)
	else
		setActive(arg2_9:Find("got"), var0_9.count == var0_9.config.count)
	end
end

return var0_0
