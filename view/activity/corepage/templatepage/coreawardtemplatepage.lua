local var0_0 = class("CoreAwardTemplatePage", import("view.activity.CorePage.CoreActivityPage"))

var0_0.DropType2Name = {
	[DROP_TYPE_EQUIP] = "equip",
	[DROP_TYPE_FURNITURE] = "furniture",
	[DROP_TYPE_EQUIPMENT_SKIN] = "equip_skin",
	[DROP_TYPE_SPWEAPON] = "special_weapon"
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
	arg0_1.itemPanel = arg0_1:findTF("item_panel", arg0_1.bg)
	arg0_1.togglesTF = arg0_1:findTF("toggles", arg0_1.itemPanel)
	arg0_1.content = arg0_1:findTF("item_list/content", arg0_1.itemPanel)
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1:findTF("tpl", arg0_1.content))

	setText(arg0_1:findTF("tpl/owner/title", arg0_1.content), i18n("collect_page_got"))

	arg0_1.boxTF = arg0_1:findTF("Box")
	arg0_1.boxBG = arg0_1:findTF("BG", arg0_1.boxTF)
	arg0_1.panel = arg0_1:findTF("Panel", arg0_1.boxTF)
	arg0_1.infoTF = arg0_1:findTF("Info", arg0_1.panel)
	arg0_1.boxCloseBtn = arg0_1:findTF("CloseBtn", arg0_1.infoTF)
	arg0_1.Title = arg0_1:findTF("Title", arg0_1.infoTF)
	arg0_1.boxIconTF = arg0_1:findTF("Icon/Mask/IconTpl", arg0_1.infoTF)
	arg0_1.boxNameText = arg0_1:findTF("NameText", arg0_1.infoTF)
	arg0_1.boxNumTF = arg0_1:findTF("Num", arg0_1.infoTF)
	arg0_1.boxNumTip = arg0_1:findTF("Text", arg0_1.boxNumTF)
	arg0_1.boxNumText = arg0_1:findTF("NumText", arg0_1.boxNumTF)
	arg0_1.boxDescText = arg0_1:findTF("DescText", arg0_1.infoTF)
	arg0_1.boxSrcText = arg0_1:findTF("SrcText", arg0_1.infoTF)
	arg0_1.boxSrcContent = arg0_1:findTF("Content", arg0_1.panel)
	arg0_1.boxSrcTpl = arg0_1:findTF("SrcTpl", arg0_1.boxSrcContent)

	onButton(arg0_1, arg0_1.boxBG, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.boxCloseBtn, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
end

function var0_0.OnDataSetting(arg0_4)
	arg0_4.guideConfig = pg.activity_limit_item_guide

	arg0_4:BuildDatas()
end

function var0_0.BuildDatas(arg0_5)
	local var0_5 = pg.activity_limit_item_guide.get_id_list_by_activity[arg0_5.activity.id] or {}

	arg0_5.dataList = {}

	for iter0_5, iter1_5 in ipairs(var0_5) do
		local var1_5 = {
			id = iter1_5
		}

		var1_5.config = arg0_5.guideConfig[var1_5.id]
		var1_5.count = arg0_5.activity:getKVPList(1, var1_5.id)

		if var1_5.config.count_storage == 1 then
			var1_5.count = Drop.New({
				type = var1_5.config.type,
				id = var1_5.config.drop_id
			}):getOwnedCount()
		end

		table.insert(arg0_5.dataList, var1_5)
	end
end

function var0_0.GetTogglesDropTypes(arg0_6)
	return {
		DROP_TYPE_EQUIP,
		DROP_TYPE_FURNITURE,
		DROP_TYPE_EQUIPMENT_SKIN,
		DROP_TYPE_SPWEAPON
	}
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7.itemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_7:OnUpdateItem(arg1_8, arg2_8)
		end
	end)
	arg0_7:AddTogglesListener()
	arg0_7:AddSpecialBtnListener()

	arg0_7.curPage = arg0_7.curPage or arg0_7:GetTogglesDropTypes()[1]

	triggerToggle(arg0_7.toggles[arg0_7.curPage], true)
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9:BuildDatas()
	arg0_9:UpdatePage(arg0_9.curPage)
end

function var0_0.AddTogglesListener(arg0_10)
	arg0_10.toggles = {}

	local var0_10 = arg0_10:GetTogglesDropTypes()

	assert(#var0_10 == arg0_10.togglesTF.childCount, "dropType数量与togglesTF子节点数不匹配")

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var1_10 = arg0_10:findTF(var0_0.DropType2Name[iter1_10], arg0_10.togglesTF)

		onToggle(arg0_10, var1_10, function(arg0_11)
			if arg0_11 then
				arg0_10:UpdatePage(iter1_10)
			end
		end, SFX_PANEL)

		arg0_10.toggles[iter1_10] = var1_10
	end
end

function var0_0.AddSpecialBtnListener(arg0_12)
	local var0_12 = arg0_12.activity:getConfig("config_client")

	arg0_12.furnitureThemeBtn = arg0_12:findTF("furniture_theme", arg0_12.btnList)

	if arg0_12.furnitureThemeBtn and var0_12.furniture_theme_link then
		onButton(arg0_12, arg0_12.furnitureThemeBtn, function()
			local var0_13 = var0_12.furniture_theme_link
			local var1_13 = var0_13[1]
			local var2_13 = var0_13[2]
			local var3_13 = var0_13[3]

			arg0_12:DoSkip(var1_13, var2_13)
		end, SFX_PANEL)
	end

	arg0_12.medalBtn = arg0_12:findTF("medal", arg0_12.btnList)

	if arg0_12.medalBtn and var0_12.medal_link then
		onButton(arg0_12, arg0_12.medalBtn, function()
			local var0_14 = var0_12.medal_link
			local var1_14 = var0_14[1]
			local var2_14 = var0_14[2]
			local var3_14 = var0_14[3]

			arg0_12:DoSkip(var1_14, var2_14)
		end, SFX_PANEL)
	end

	arg0_12.equipSkinBoxBtn = arg0_12:findTF("equip_skin_box", arg0_12.btnList)

	if arg0_12.equipSkinBoxBtn and var0_12.equipskin_box_link then
		local var1_12 = Drop.New({
			type = var0_12.equipskin_box_link.drop_type,
			id = var0_12.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0_12, arg0_12.equipSkinBoxBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
				show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
				drop_type = var0_12.equipskin_box_link.drop_type,
				drop_id = var0_12.equipskin_box_link.drop_id,
				count = var1_12,
				skipable_list = var0_12.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.showDataList[arg1_16 + 1]
	local var1_16 = arg0_16:findTF("icon_mask/icon", arg2_16)
	local var2_16 = {
		type = var0_16.config.type,
		id = var0_16.config.drop_id
	}

	updateDrop(var1_16, var2_16)
	onButton(arg0_16, var1_16, function()
		arg0_16:OnClickItem(var0_16)
	end, SFX_PANEL)
	changeToScrollText(arg0_16:findTF("name_mask/name", arg2_16), Drop.New({
		type = var0_16.config.type,
		id = var0_16.config.drop_id
	}):getName())
	arg0_16:RefreshCountText(var0_16, arg2_16)

	GetOrAddComponent(arg0_16:findTF("owner", arg2_16), typeof(CanvasGroup)).alpha = var0_16.count == var0_16.config.count and 0.5 or 1

	setActive(arg0_16:findTF("got", arg2_16), var0_16.count == var0_16.config.count)
	setActive(arg0_16:findTF("new", arg2_16), var0_16.config.is_new == "1")
end

function var0_0.RefreshCountText(arg0_18, arg1_18, arg2_18)
	setText(arg0_18:findTF("owner/number", arg2_18), arg1_18.count .. "/" .. arg1_18.config.count)
end

function var0_0.OnClickItem(arg0_19, arg1_19)
	local var0_19 = {
		type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
		show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
		drop_type = arg1_19.config.type,
		drop_id = arg1_19.config.drop_id,
		count = arg1_19.count,
		count_limit = arg1_19.config.count,
		skipable_list = arg1_19.config.link_params
	}

	arg0_19:updateBoxPanel(var0_19)
	arg0_19:showBoxPanel(true)
end

function var0_0.UpdatePage(arg0_20, arg1_20)
	arg0_20.curPage = arg1_20
	arg0_20.showDataList = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.dataList) do
		if arg0_20.guideConfig[iter1_20.id].type == arg1_20 then
			table.insert(arg0_20.showDataList, iter1_20)
		end
	end

	table.sort(arg0_20.showDataList, CompareFuncs({
		function(arg0_21)
			return arg0_21.count < arg0_21.config.count and 0 or 1
		end,
		function(arg0_22)
			return arg0_22.config.order
		end,
		function(arg0_23)
			return arg0_23.id
		end
	}))
	arg0_20.itemList:align(#arg0_20.showDataList)
end

function var0_0.updateBoxPanel(arg0_24, arg1_24)
	local var0_24 = Drop.New({
		type = arg1_24.drop_type,
		id = arg1_24.drop_id
	})

	updateDrop(arg0_24.boxIconTF, var0_24)

	local var1_24 = var0_24.cfg

	changeToScrollText(arg0_24.boxNameText, var1_24.name)
	setText(arg0_24.boxDescText, SwitchSpecialChar(var0_24.desc))
	setText(arg0_24.boxNumTip, i18n("collect_page_got"))

	if arg1_24.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL then
		setText(arg0_24.boxNumText, arg1_24.count)
	elseif arg1_24.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT then
		setText(arg0_24.boxNumText, string.format("%s<color=#735d54>/%s</color>", arg1_24.count, arg1_24.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0_24.boxSrcContent, arg0_24.boxSrcTpl, #arg1_24.skipable_list, function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = arg1_24.skipable_list[arg1_25 + 1]
			local var1_25 = var0_25[1]
			local var2_25 = var0_25[2]
			local var3_25 = var0_25[3]

			changeToScrollText(arg0_24:findTF("SrcText", arg2_25), var3_25)

			local var4_25 = arg0_24:findTF("GoBtn", arg2_25)

			setText(arg0_24:findTF("go", var4_25), i18n("brs_reward_tip_2"))
			onButton(arg0_24, var4_25, function()
				arg0_24:DoSkip(var1_25, var2_25)
				arg0_24:showBoxPanel(false)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.showBoxPanel(arg0_27, arg1_27)
	setActive(arg0_27.boxTF, arg1_27)

	if arg1_27 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_27.boxTF)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27.boxTF)
	end
end

function var0_0.DoSkip(arg0_28, arg1_28, arg2_28)
	if arg1_28 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2_28[1], arg2_28[2] or {})
	elseif arg1_28 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2_28
		})
	end
end

return var0_0
