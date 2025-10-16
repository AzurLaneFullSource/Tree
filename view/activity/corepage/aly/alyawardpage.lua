local var0_0 = class("ALYAwardPage", import("..CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.table_Top = {
		arg0_1.AD:Find("tabs/top_1"),
		arg0_1.AD:Find("tabs/top_2"),
		arg0_1.AD:Find("tabs/top_3"),
		arg0_1.AD:Find("tabs/top_4")
	}
	arg0_1.btn = arg0_1.AD:Find("btn")
	arg0_1.furmiturebtn = arg0_1.btn:Find("furmiturebtn")
	arg0_1.commemoratebtn = arg0_1.btn:Find("commemoratebtn")
	arg0_1.equipmentbtn = arg0_1.btn:Find("equipmentbtn")

	arg0_1.furmiturebtn:Find("left/Title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_1.commemoratebtn:Find("left/Title"):GetComponent(typeof(Image)):SetNativeSize()
	arg0_1.equipmentbtn:Find("left/Title"):GetComponent(typeof(Image)):SetNativeSize()

	arg0_1.boxTF = arg0_1._tf:Find("Box")
	arg0_1.boxBG = arg0_1.boxTF:Find("BG")
	arg0_1.panel = arg0_1.boxTF:Find("Panel")
	arg0_1.infoTF = arg0_1.panel:Find("Info")
	arg0_1.boxCloseBtn = arg0_1.infoTF:Find("CloseBtn")
	arg0_1.Title = arg0_1.infoTF:Find("Title")

	setText(arg0_1.Title, i18n("brs_reward_tip_1"))

	arg0_1.boxIconTF = arg0_1.infoTF:Find("Icon/Mask/IconTpl")
	arg0_1.boxNameText = arg0_1.infoTF:Find("NameText")
	arg0_1.boxNumTF = arg0_1.infoTF:Find("Num")
	arg0_1.boxNumTip = arg0_1.boxNumTF:Find("Text")
	arg0_1.boxNumText = arg0_1.boxNumTF:Find("NumText")
	arg0_1.boxDescText = arg0_1.infoTF:Find("DescText")
	arg0_1.boxSrcText = arg0_1.infoTF:Find("SrcText")
	arg0_1.boxSrcContent = arg0_1.panel:Find("Content")
	arg0_1.boxSrcTpl = arg0_1.boxSrcContent:Find("SrcTpl")

	onButton(arg0_1, arg0_1.boxBG, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.boxCloseBtn, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
end

function var0_0.BuildDatas(arg0_4)
	local var0_4 = pg.activity_limit_item_guide.get_id_list_by_activity[arg0_4.activity.id]

	assert(var0_4, "activity_limit_item_guide not exist activity id: " .. arg0_4.activity.id)

	arg0_4.dataList = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var1_4 = {
			id = iter1_4
		}

		var1_4.config = arg0_4.guideConfig[var1_4.id]
		var1_4.count = arg0_4.activity:getKVPList(1, var1_4.id)

		if var1_4.config.count_storage == 1 then
			var1_4.count = Drop.New({
				type = var1_4.config.type,
				id = var1_4.config.drop_id
			}):getOwnedCount()
		end

		table.insert(arg0_4.dataList, var1_4)
	end
end

function var0_0.OnDataSetting(arg0_5)
	arg0_5.guideConfig = pg.activity_limit_item_guide

	arg0_5:BuildDatas()
end

function var0_0.OnFirstFlush(arg0_6)
	arg0_6:InitData()

	local var0_6 = arg0_6.activity:getConfig("config_client")

	onButton(arg0_6, arg0_6.furmiturebtn, function()
		arg0_6:DoSkip(var0_6.furniture_theme_link[1], var0_6.furniture_theme_link[2])
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.commemoratebtn, function()
		arg0_6:DoSkip(var0_6.medal_link[1], var0_6.medal_link[2])
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.equipmentbtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
			drop_type = var0_6.equipskin_box_link.drop_type,
			drop_id = var0_6.equipskin_box_link.drop_id,
			count = count,
			skipable_list = var0_6.equipskin_box_link.list
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_10)
	triggerToggle(arg0_10.table_Top[arg0_10.pageIndex or 1], true)
end

function var0_0.ResetTop(arg0_11)
	for iter0_11 = 1, #arg0_11.table_Top do
		setText(arg0_11.AD:Find("tabs/top_" .. iter0_11 .. "/Label"), i18n("yumia_award_" .. iter0_11))
		setTextColor(arg0_11.AD:Find("tabs/top_" .. iter0_11 .. "/Label"), Color.NewHex("cfcfcf"))
	end
end

function var0_0.InitData(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.table_Top) do
		onToggle(arg0_12, iter1_12, function(arg0_13)
			if arg0_13 then
				arg0_12.pageIndex = iter0_12

				onDelayTick(function()
					arg0_12:DataList(iter0_12)
				end, 0.08)
				arg0_12:ResetTop()
				setTextColor(arg0_12.AD:Find("tabs/top_" .. iter0_12 .. "/Label"), Color.NewHex("0a2e31"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.DataList(arg0_15, arg1_15)
	arg0_15.showDataList = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.dataList) do
		if arg0_15.guideConfig[iter1_15.id].type == 3 and arg1_15 == 1 then
			table.insert(arg0_15.showDataList, iter1_15)
		elseif arg0_15.guideConfig[iter1_15.id].type == 5 and arg1_15 == 2 then
			table.insert(arg0_15.showDataList, iter1_15)
		elseif arg0_15.guideConfig[iter1_15.id].type == 9 and arg1_15 == 3 then
			table.insert(arg0_15.showDataList, iter1_15)
		elseif arg0_15.guideConfig[iter1_15.id].type == 21 and arg1_15 == 4 then
			table.insert(arg0_15.showDataList, iter1_15)
		end
	end

	table.sort(arg0_15.showDataList, CompareFuncs({
		function(arg0_16)
			return arg0_16.count < arg0_16.config.count and 0 or 1
		end,
		function(arg0_17)
			return arg0_17.config.order
		end,
		function(arg0_18)
			return arg0_18.id
		end
	}))
	arg0_15:ShowCharaPage()
end

function var0_0.ShowCharaPage(arg0_19)
	arg0_19.award = arg0_19.AD:Find("tpl")
	arg0_19.count = arg0_19.AD:Find("item_list/content")
	arg0_19.tabsList = UIItemList.New(arg0_19.count, arg0_19.award)

	arg0_19.tabsList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			arg0_19:OnUpdateItem(arg1_20, arg2_20)
		end
	end)
	arg0_19.tabsList:align(#arg0_19.showDataList)
end

function var0_0.OnUpdateItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.showDataList[arg1_21 + 1]
	local var1_21 = arg2_21:Find("icon_mask/icon")
	local var2_21 = {
		type = var0_21.config.type,
		id = var0_21.config.drop_id
	}

	updateDrop(var1_21, var2_21)
	onButton(arg0_21, var1_21, function()
		local var0_22 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_21.config.type,
			drop_id = var0_21.config.drop_id,
			count = var0_21.count,
			count_limit = var0_21.config.count,
			skipable_list = var0_21.config.link_params
		}

		arg0_21:updateBoxPanel(var0_22)
		arg0_21:showBoxPanel(true)
	end, SFX_PANEL)
	changeToScrollText(arg2_21:Find("name_mask/name"), Drop.New({
		type = var0_21.config.type,
		id = var0_21.config.drop_id
	}):getName())
	setText(arg2_21:Find("owner/title"), i18n("collect_page_got"))
	setText(arg2_21:Find("owner/Text"), var0_21.count)
	setText(arg2_21:Find("owner/number"), "/" .. var0_21.config.count)

	GetOrAddComponent(arg2_21:Find("owner"), typeof(CanvasGroup)).alpha = var0_21.count == var0_21.config.count and 0.5 or 1

	setActive(arg2_21:Find("got"), var0_21.count == var0_21.config.count)
end

function var0_0.updateBoxPanel(arg0_23, arg1_23)
	local var0_23 = Drop.New({
		type = arg1_23.drop_type,
		id = arg1_23.drop_id
	})

	updateDrop(arg0_23.boxIconTF, var0_23)

	local var1_23 = var0_23.cfg

	changeToScrollText(arg0_23.boxNameText, var1_23.name)
	setText(arg0_23.boxDescText, SwitchSpecialChar(var0_23.desc))
	setText(arg0_23.boxNumTip, i18n("word_got") .. "：")

	if arg1_23.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL then
		setText(arg0_23.boxNumText, "<color=#FCFCE8>" .. arg1_23.count .. "</color>")
	elseif arg1_23.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT then
		setText(arg0_23.boxNumText, "<color=#FCFCE8>" .. arg1_23.count .. "</color>/" .. (arg1_23.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0_23.boxSrcContent, arg0_23.boxSrcTpl, #arg1_23.skipable_list, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = arg1_23.skipable_list[arg1_24 + 1]
			local var1_24 = var0_24[1]
			local var2_24 = var0_24[2]
			local var3_24 = var0_24[3]

			changeToScrollText(arg2_24:Find("SrcText"), var3_24)

			local var4_24 = arg2_24:Find("GoBtn")

			setText(var4_24:Find("go"), i18n("brs_reward_tip_2"))
			onButton(arg0_23, var4_24, function()
				arg0_23:DoSkip(var1_24, var2_24)
				arg0_23:showBoxPanel(false)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.DoSkip(arg0_26, arg1_26, arg2_26)
	if arg1_26 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2_26[1], arg2_26[2] or {})
	elseif arg1_26 == Msgbox4LinkCollectGuide.SKIP_TYPE_ACTIVITY then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2_26
		})
	end
end

function var0_0.showBoxPanel(arg0_27, arg1_27)
	setActive(arg0_27.boxTF, arg1_27)

	if arg1_27 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_27.boxTF)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27.boxTF, arg0_27._tf)
	end
end

function var0_0.OnDestroy(arg0_28)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28.boxTF, arg0_28._tf)
	var0_0.super.OnDestroy(arg0_28)
end

return var0_0
