local var0_0 = class("DALAwardPage", import("view.activity.CorePage.BRS.HeiYanAwardPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.furmiturebtn = arg0_1.AD:Find("btn/furmiturebtn")
	arg0_1.commemoratebtn = arg0_1.AD:Find("btn/commemoratebtn")
	arg0_1.equipmentbtn = arg0_1.AD:Find("btn/equipmentbtn")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2:InitData()

	local var0_2 = arg0_2.activity:getConfig("config_client")

	onButton(arg0_2, arg0_2.furmiturebtn, function()
		arg0_2:DoSkip(var0_2.furniture_theme_link[1], var0_2.furniture_theme_link[2])
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.commemoratebtn, function()
		arg0_2:DoSkip(var0_2.medal_link[1], var0_2.medal_link[2])
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.equipmentbtn, function()
		local var0_5 = Drop.New({
			type = var0_2.equipskin_box_link.drop_type,
			id = var0_2.equipskin_box_link.drop_id
		}):getOwnedCount()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
			drop_type = var0_2.equipskin_box_link.drop_type,
			drop_id = var0_2.equipskin_box_link.drop_id,
			count = var0_5,
			skipable_list = var0_2.equipskin_box_link.list
		})
	end, SFX_PANEL)
end

function var0_0.InitData(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.table_Top) do
		onToggle(arg0_6, iter1_6, function(arg0_7)
			if arg0_7 then
				arg0_6.pageIndex = iter0_6

				SetActive(arg0_6.bg_1, false)
				SetActive(arg0_6.bg_2, true)
				arg0_6:DataList(iter0_6 + 1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.DataList(arg0_8, arg1_8)
	arg0_8.showDataList = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.dataList) do
		if arg0_8.guideConfig[iter1_8.id].type == 3 and arg1_8 == 2 then
			table.insert(arg0_8.showDataList, iter1_8)
		elseif arg0_8.guideConfig[iter1_8.id].type == 21 and arg1_8 == 3 then
			table.insert(arg0_8.showDataList, iter1_8)
		end
	end

	table.sort(arg0_8.showDataList, CompareFuncs({
		function(arg0_9)
			return arg0_9.config.order
		end,
		function(arg0_10)
			return arg0_10.id
		end
	}))
	arg0_8:ShowCharaPage()
end

function var0_0.OnAnimation(arg0_11, arg1_11)
	return
end

function var0_0.OnUpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.showDataList[arg1_12 + 1]
	local var1_12 = arg2_12:Find("icon_mask/icon")
	local var2_12 = {
		type = var0_12.config.type,
		id = var0_12.config.drop_id
	}

	updateDrop(var1_12, var2_12)
	onButton(arg0_12, var1_12, function()
		local var0_13 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_12.config.type,
			drop_id = var0_12.config.drop_id,
			count = var0_12.count,
			count_limit = var0_12.config.count,
			skipable_list = var0_12.config.link_params
		}

		arg0_12:selectBoxbg(var0_13)
		arg0_12:updateBoxPanel(var0_13)
		arg0_12:showBoxPanel(true)
	end, SFX_PANEL)
	changeToScrollText(arg2_12:Find("name_mask/name"), Drop.New({
		type = var0_12.config.type,
		id = var0_12.config.drop_id
	}):getName())
	setText(arg2_12:Find("owner/number"), var0_12.count .. "/" .. var0_12.config.count)

	GetOrAddComponent(arg2_12:Find("owner"), typeof(CanvasGroup)).alpha = var0_12.count == var0_12.config.count and 0.5 or 1

	setActive(arg2_12:Find("got"), var0_12.count == var0_12.config.count)
end

function var0_0.UpdateView(arg0_14)
	for iter0_14 = 1, #arg0_14.table_Top do
		if iter0_14 == 1 then
			setText(arg0_14.table_Top[iter0_14]:Find("type_image/name"), i18n("yumia_award_1"))
			setText(arg0_14.table_Top[iter0_14]:Find("on/name"), i18n("yumia_award_1"))
			setText(arg0_14.table_Top[iter0_14]:Find("on/name2"), i18n("dal_AwardPage_name_1"))
		elseif iter0_14 == 2 then
			setText(arg0_14.table_Top[iter0_14]:Find("type_image/name"), i18n("yumia_award_4"))
			setText(arg0_14.table_Top[iter0_14]:Find("on/name"), i18n("yumia_award_4"))
			setText(arg0_14.table_Top[iter0_14]:Find("on/name2"), i18n("dal_AwardPage_name_2"))
		end
	end

	triggerToggle(arg0_14.table_Top[arg0_14.pageIndex or 1], true)
end

function var0_0.selectBoxbg(arg0_15, arg1_15)
	if table.getCount(arg1_15.skipable_list) > 1 then
		setImageSprite(arg0_15.boxTF:Find("Panel/BG"), LoadSprite("ui/DALAwardPage_atlas", "box_bg2"), true)
	elseif table.getCount(arg1_15.skipable_list) == 1 then
		setImageSprite(arg0_15.boxTF:Find("Panel/BG"), LoadSprite("ui/DALAwardPage_atlas", "box_bg1"), true)
	end
end

function var0_0.RefreshCountText(arg0_16, arg1_16, arg2_16)
	setText(arg2_16:Find("owner/number"), arg1_16.count .. "/" .. arg1_16.config.count)
end

function var0_0.showBoxPanel(arg0_17, arg1_17)
	setActive(arg0_17.boxTF, arg1_17)

	if arg1_17 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_17.boxTF)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17.boxTF, arg0_17._tf)
	end
end

function var0_0.DoSkip(arg0_18, arg1_18, arg2_18)
	if arg1_18 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2_18[1], arg2_18[2] or {})
	elseif arg1_18 == Msgbox4LinkCollectGuide.SKIP_TYPE_ACTIVITY then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2_18
		})
	end
end

function var0_0.OnDestroy(arg0_19)
	arg0_19:showBoxPanel(false)
end

return var0_0
