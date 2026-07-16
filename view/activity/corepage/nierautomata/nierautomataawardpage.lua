local var0_0 = class("NieRAutomataAwardPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.table_Top = {
		arg0_1.AD:Find("tabs/top_1"),
		arg0_1.AD:Find("tabs/top_2"),
		arg0_1.AD:Find("tabs/top_3"),
		arg0_1.AD:Find("tabs/top_4")
	}
	arg0_1.table_local = {
		"nier_award_char",
		"nier_award_furniture",
		"nier_award_equip_skin",
		"nier_award_sp_equip"
	}
	arg0_1.bg_1 = arg0_1.AD:Find("bg_1")
	arg0_1.bg_2 = arg0_1.AD:Find("bg_2")
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
	arg0_1.boxOpen = false

	onButton(arg0_1, arg0_1.boxBG, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.boxCloseBtn, function()
		arg0_1:showBoxPanel(false)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_1.boxTF)
end

function var0_0.OnDataSetting(arg0_4)
	arg0_4.guideConfig = pg.activity_limit_item_guide

	arg0_4:BuildDatas()
end

function var0_0.BuildDatas(arg0_5)
	local var0_5 = pg.activity_limit_item_guide.get_id_list_by_activity[arg0_5.activity.id]

	assert(var0_5, "activity_limit_item_guide not exist activity id: " .. arg0_5.activity.id)

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

function var0_0.OnFirstFlush(arg0_6)
	arg0_6:InitData()
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7:UpdateView()
end

function var0_0.InitData(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.table_Top) do
		setText(iter1_8:Find("on/Text"), i18n(arg0_8.table_local[iter0_8]))
		setText(iter1_8:Find("off/Text"), i18n(arg0_8.table_local[iter0_8]))
		onToggle(arg0_8, iter1_8, function(arg0_9)
			if arg0_9 then
				arg0_8.pageIndex = iter0_8

				SetActive(arg0_8.bg_1, iter0_8 == 1)
				SetActive(arg0_8.bg_2, iter0_8 ~= 1)
				arg0_8:DataList(iter0_8)
				setActive(arg0_8.table_Top[iter0_8]:Find("off"), false)
			else
				setActive(arg0_8.table_Top[iter0_8]:Find("off"), true)
			end
		end, SFX_PANEL)
	end
end

function var0_0.UpdateView(arg0_10)
	for iter0_10 = 1, #arg0_10.table_Top do
		setText(arg0_10.table_Top[iter0_10]:Find("on/label"), arg0_10:OnGetCount(iter0_10) .. "/" .. arg0_10:OnCount(iter0_10))
		setText(arg0_10.table_Top[iter0_10]:Find("off/label"), arg0_10:OnGetCount(iter0_10) .. "/" .. arg0_10:OnCount(iter0_10))
	end

	local var0_10 = arg0_10.pageIndex or 1

	triggerToggle(arg0_10.table_Top[var0_10], true)
end

function var0_0.DataList(arg0_11, arg1_11)
	arg0_11.showDataList = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.dataList) do
		if arg0_11.guideConfig[iter1_11.id].type == 4 and arg1_11 == 1 then
			table.insert(arg0_11.showDataList, iter1_11)
		elseif arg0_11.guideConfig[iter1_11.id].type == 5 and arg1_11 == 2 then
			table.insert(arg0_11.showDataList, iter1_11)
		elseif arg0_11.guideConfig[iter1_11.id].type == 9 and arg1_11 == 3 then
			table.insert(arg0_11.showDataList, iter1_11)
		elseif arg0_11.guideConfig[iter1_11.id].type == 21 and arg1_11 == 4 then
			table.insert(arg0_11.showDataList, iter1_11)
		end
	end

	table.sort(arg0_11.showDataList, CompareFuncs({
		function(arg0_12)
			return arg0_12.config.order
		end,
		function(arg0_13)
			return arg0_13.id
		end
	}))

	if arg1_11 == 1 then
		arg0_11:ShowSitePage()
	elseif arg1_11 == 2 or arg1_11 == 3 or arg1_11 == 4 then
		arg0_11:ShowCharaPage()
	end
end

function var0_0.OnCount(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.dataList) do
		if arg0_14.guideConfig[iter1_14.id].type == 4 and arg1_14 == 1 then
			table.insert(var0_14, iter1_14)
		elseif arg0_14.guideConfig[iter1_14.id].type == 5 and arg1_14 == 2 then
			table.insert(var0_14, iter1_14)
		elseif arg0_14.guideConfig[iter1_14.id].type == 9 and arg1_14 == 3 then
			table.insert(var0_14, iter1_14)
		elseif arg0_14.guideConfig[iter1_14.id].type == 21 and arg1_14 == 4 then
			table.insert(var0_14, iter1_14)
		end
	end

	return #var0_14
end

function var0_0.OnGetCount(arg0_15, arg1_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in ipairs(arg0_15.dataList) do
		if arg0_15.guideConfig[iter1_15.id].type == 4 and arg1_15 == 1 then
			local var1_15 = Drop.New({
				type = iter1_15.config.type,
				id = iter1_15.config.drop_id
			}).id
			local var2_15 = pg.ship_data_template[var1_15].group_type

			if tobool(getProxy(CollectionProxy):getShipGroup(var2_15)) then
				var0_15 = var0_15 + 1
			end
		elseif arg0_15.guideConfig[iter1_15.id].type == 5 and arg1_15 == 2 then
			if iter1_15.count == iter1_15.config.count then
				var0_15 = var0_15 + 1
			end
		elseif arg0_15.guideConfig[iter1_15.id].type == 9 and arg1_15 == 3 then
			if iter1_15.count == iter1_15.config.count then
				var0_15 = var0_15 + 1
			end
		elseif arg0_15.guideConfig[iter1_15.id].type == 21 and arg1_15 == 4 and iter1_15.count == iter1_15.config.count then
			var0_15 = var0_15 + 1
		end
	end

	return var0_15
end

function var0_0.ShowSitePage(arg0_16)
	local var0_16 = arg0_16.showDataList[1].config.drop_id
	local var1_16 = arg0_16.bg_1:Find("Role_left")
	local var2_16 = var1_16:Find("lock_bg")
	local var3_16 = var1_16:Find("name")
	local var4_16 = var1_16:Find("get")
	local var5_16 = var4_16:Find("Text")
	local var6_16 = var1_16:Find("notget")
	local var7_16 = var6_16:Find("Text")

	setText(var5_16, i18n("word_got"))
	setText(var7_16, i18n("word_not_get"))

	local var8_16 = Drop.New({
		type = arg0_16.showDataList[1].config.type,
		id = arg0_16.showDataList[1].config.drop_id
	})
	local var9_16 = var8_16:getName()
	local var10_16 = var8_16.id
	local var11_16 = pg.ship_data_template[var10_16].group_type
	local var12_16 = tobool(getProxy(CollectionProxy):getShipGroup(var11_16))

	SetActive(var2_16, not var12_16)
	SetActive(var4_16, var12_16)
	SetActive(var6_16, not var12_16)

	local var13_16 = arg0_16.bg_1:Find("Role_right")
	local var14_16 = var13_16:Find("lock_bg")
	local var15_16 = var13_16:Find("name")
	local var16_16 = var13_16:Find("get")
	local var17_16 = var16_16:Find("Text")
	local var18_16 = var13_16:Find("notget")
	local var19_16 = var18_16:Find("Text")

	setText(var17_16, i18n("word_got"))
	setText(var19_16, i18n("word_not_get"))

	local var20_16 = arg0_16.showDataList[2].config.drop_id
	local var21_16 = Drop.New({
		type = arg0_16.showDataList[2].config.type,
		id = arg0_16.showDataList[2].config.drop_id
	})
	local var22_16 = var21_16:getName()
	local var23_16 = var21_16.id
	local var24_16 = pg.ship_data_template[var23_16].group_type
	local var25_16 = tobool(getProxy(CollectionProxy):getShipGroup(var24_16))

	SetActive(var18_16, not var25_16)
	SetActive(var16_16, var25_16)
	SetActive(var14_16, not var25_16)
end

function var0_0.ShowCharaPage(arg0_17)
	arg0_17.award = arg0_17.bg_2:Find("tpl")
	arg0_17.count = arg0_17.bg_2:Find("count")
	arg0_17.tabsList = UIItemList.New(arg0_17.count, arg0_17.award)

	arg0_17.tabsList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg0_17:OnUpdateItem(arg1_18, arg2_18, data)
		end
	end)
	arg0_17.tabsList:align(#arg0_17.showDataList)
end

function var0_0.OnUpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.showDataList[arg1_19 + 1]
	local var1_19 = arg2_19:Find("icon_mask/icon")
	local var2_19 = {
		type = var0_19.config.type,
		id = var0_19.config.drop_id
	}

	updateDrop(var1_19, var2_19)
	onButton(arg0_19, var1_19, function()
		local var0_20 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_19.config.type,
			drop_id = var0_19.config.drop_id,
			count = var0_19.count,
			count_limit = var0_19.config.count,
			skipable_list = var0_19.config.link_params
		}

		arg0_19:updateBoxPanel(var0_20)
		arg0_19:showBoxPanel(true)
	end, SFX_PANEL)
	changeToScrollText(arg2_19:Find("name_mask/name"), Drop.New({
		type = var0_19.config.type,
		id = var0_19.config.drop_id
	}):getName())
	setText(arg2_19:Find("owner/number"), var0_19.count .. "/" .. var0_19.config.count)

	GetOrAddComponent(arg2_19:Find("owner"), typeof(CanvasGroup)).alpha = var0_19.count == var0_19.config.count and 0.5 or 1

	setActive(arg2_19:Find("got"), var0_19.count == var0_19.config.count)
end

function var0_0.updateBoxPanel(arg0_21, arg1_21)
	local var0_21 = Drop.New({
		type = arg1_21.drop_type,
		id = arg1_21.drop_id
	})

	updateDrop(arg0_21.boxIconTF, var0_21)

	local var1_21 = var0_21.cfg

	changeToScrollText(arg0_21.boxNameText, var1_21.name)
	setText(arg0_21.boxDescText, SwitchSpecialChar(var0_21.desc))
	setText(arg0_21.boxNumTip, i18n("word_got"))

	if arg1_21.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL then
		setText(arg0_21.boxNumText, arg1_21.count)
	elseif arg1_21.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT then
		setText(arg0_21.boxNumText, arg1_21.count .. "/" .. (arg1_21.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0_21.boxSrcContent, arg0_21.boxSrcTpl, #arg1_21.skipable_list, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg1_21.skipable_list[arg1_22 + 1]
			local var1_22 = var0_22[1]
			local var2_22 = var0_22[2]
			local var3_22 = var0_22[3]

			changeToScrollText(arg2_22:Find("SrcText"), var3_22)

			local var4_22 = arg2_22:Find("GoBtn")

			setText(var4_22:Find("go"), i18n("brs_reward_tip_2"))
			onButton(arg0_21, var4_22, function()
				if var1_22 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2_22[1], var2_22[2] or {})
				elseif var1_22 == Msgbox4LinkCollectGuide.SKIP_TYPE_ACTIVITY then
					arg0_21:emit(ActivityMediator.SELECT_ACTIVITY, var2_22)
				end

				arg0_21:showBoxPanel(false)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.showBoxPanel(arg0_24, arg1_24)
	arg0_24.boxOpen = arg1_24

	setActive(arg0_24.boxTF, arg1_24)
end

function var0_0.IsShowingPopWindow(arg0_25)
	return arg0_25.boxOpen == true
end

function var0_0.ClosePopWindow(arg0_26)
	if arg0_26.boxOpen then
		arg0_26:showBoxPanel(false)
	end
end

function var0_0.OnDestroy(arg0_27)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27.boxTF)
	var0_0.super.OnDestroy(arg0_27)
end

return var0_0
