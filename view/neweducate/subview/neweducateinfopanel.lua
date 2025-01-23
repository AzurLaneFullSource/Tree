local var0_0 = class("NewEducateInfoPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateInfoPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.foldPanelTF = arg0_2._tf:Find("fold_panel")
	arg0_2.showBtn = arg0_2.foldPanelTF:Find("show_btn")
	arg0_2.showPanelTF = arg0_2._tf:Find("show_panel")
	arg0_2.showAnim = arg0_2.showPanelTF:GetComponent(typeof(Animation))
	arg0_2.showAnimEvent = arg0_2.showPanelTF:GetComponent(typeof(DftAniEvent))

	arg0_2.showAnimEvent:SetEndEvent(function()
		setActive(arg0_2.showPanelTF, false)
	end)

	arg0_2.blurBg = arg0_2.showPanelTF:Find("content")
	arg0_2.foldBtn = arg0_2.showPanelTF:Find("fold_btn")
	arg0_2.contnetTF = arg0_2.showPanelTF:Find("content")

	setText(arg0_2.contnetTF:Find("personality_title/Text"), i18n("child2_personality_title"))

	arg0_2.personalityTF = arg0_2.contnetTF:Find("personality")
	arg0_2.personalityValueTF = arg0_2.personalityTF:Find("slider/handle/Image/bubble/Text")

	setText(arg0_2.contnetTF:Find("attr_title/Text"), i18n("child2_attr_title"))

	local var0_2 = arg0_2.contnetTF:Find("attrs/content")

	arg0_2.gradientBgTF = arg0_2.contnetTF:Find("attrs/bg_gradient")
	arg0_2.attrUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	setText(arg0_2.contnetTF:Find("talent_title/Text"), i18n("child2_talent_title"))

	local var1_2 = arg0_2.contnetTF:Find("talents/content")

	arg0_2.talentUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	setText(arg0_2.contnetTF:Find("status_title/Text"), i18n("child2_status_title"))

	local var2_2 = arg0_2.contnetTF:Find("status/content/content")

	arg0_2.statusUIList = UIItemList.New(var2_2, var2_2:Find("tpl"))
	arg0_2.attrIds = arg0_2.contextData.char:GetAttrIds()
	arg0_2.talentRoundIds = arg0_2.contextData.char:GetRoundData():GetTalentRoundIds()
end

function var0_0.OnInit(arg0_4)
	local var0_4 = "neweducateicon/" .. arg0_4.contextData.char:getConfig("child2_data_personality_icon")[1]

	LoadImageSpriteAsync(var0_4, arg0_4.personalityTF:Find("slider/handle/Image"), true)
	onButton(arg0_4, arg0_4.showBtn, function()
		arg0_4:ShowPanel()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.foldBtn, function()
		arg0_4:HidePanel()
	end, SFX_PANEL)
	arg0_4.attrUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			local var0_7 = arg0_4.attrIds[arg1_7 + 1]
			local var1_7 = pg.child2_attr[var0_7]

			LoadImageSpriteAsync("neweducateicon/" .. var1_7.icon, arg2_7:Find("icon_bg/icon"))
			setScrollText(arg2_7:Find("name_mask/name"), var1_7.name)
		elseif arg0_7 == UIItemList.EventUpdate then
			arg0_4:OnUpdateAttrItem(arg1_7, arg2_7)
		end
	end)
	arg0_4.talentUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_4:OnUpdateTalentItem(arg1_8, arg2_8)
		end
	end)
	arg0_4.statusUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_4:OnUpdateStatusItem(arg1_9, arg2_9)
		end
	end)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_4._tf, {
		pbList = {
			arg0_4.blurBg
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = arg0_4.contextData.weight or LayerWeightConst.BASE_LAYER - 1
	})
	setActive(arg0_4.foldPanelTF, true)
	setActive(arg0_4.showPanelTF, false)

	if arg0_4.contextData.hide then
		arg0_4:HidePanel()
	elseif arg0_4.contextData.isMainEnter then
		onDelayTick(function()
			arg0_4:ShowPanel()
		end, 0.396)
	else
		arg0_4:ShowPanel()
	end

	arg0_4:Flush()
end

function var0_0.IsShowPanel(arg0_11)
	return isActive(arg0_11.showPanelTF)
end

function var0_0.ShowPanel(arg0_12)
	setActive(arg0_12.foldPanelTF, false)
	setActive(arg0_12.showPanelTF, true)
end

function var0_0.HidePanel(arg0_13, arg1_13)
	setActive(arg0_13.foldPanelTF, true)

	if not arg1_13 then
		arg0_13.showAnim:Play("anim_educate_archive_show_out")
	else
		setActive(arg0_13.showPanelTF, false)
	end

	eachChild(arg0_13.talentUIList.container, function(arg0_14)
		triggerToggle(arg0_14:Find("unlock"), false)
	end)
	eachChild(arg0_13.statusUIList.container, function(arg0_15)
		triggerToggle(arg0_15, false)
	end)
end

function var0_0.OnUpdateAttrItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.attrIds[arg1_16 + 1]
	local var1_16 = pg.child2_attr[var0_16]
	local var2_16 = arg0_16.contextData.char:GetAttr(var0_16)
	local var3_16, var4_16 = var0_0.GetArrtInfo(var1_16.rank, var2_16)

	setText(arg2_16:Find("rank/Text"), var3_16)
	setText(arg2_16:Find("value"), var4_16)

	local var5_16 = EducateConst.GRADE_2_COLOR[var3_16][1]
	local var6_16 = EducateConst.GRADE_2_COLOR[var3_16][2]
	local var7_16 = arg0_16.gradientBgTF:GetChild(arg1_16)

	setImageColor(var7_16, Color.NewHex(var5_16))
	setImageColor(arg2_16:Find("rank"), Color.NewHex(var6_16))
end

function var0_0.OnUpdateTalentItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.talents[arg1_17 + 1]

	setActive(arg2_17:Find("unlock"), var0_17)
	setActive(arg2_17:Find("lock"), not var0_17)

	if var0_17 then
		LoadImageSpriteAsync("neweducateicon/" .. var0_17:getConfig("item_icon_little"), arg2_17:Find("unlock/icon"))
		setText(arg2_17:Find("unlock/name"), shortenString(var0_17:getConfig("name"), 5))
		setText(arg2_17:Find("unlock/info/content/name"), var0_17:getConfig("name"))
		setText(arg2_17:Find("unlock/info/content/desc"), var0_17:getConfig("desc"))
	end

	local var1_17 = arg0_17.talentRoundIds[arg1_17 + 1]

	onButton(arg0_17, arg2_17:Find("lock"), function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_talent_unlock_tip", var1_17))
	end, SFX_PANEL)
	onScroll(arg0_17, arg0_17.contnetTF:Find("status"), function(arg0_19)
		eachChild(arg0_17.statusUIList.container, function(arg0_20)
			triggerToggle(arg0_20, false)
		end)
	end)
end

function var0_0.OnUpdateStatusItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.status[arg1_21 + 1]

	if arg2_21.name ~= tostring(var0_21.id) then
		arg2_21.name = var0_21.id

		LoadImageSpriteAsync("neweducateicon/" .. var0_21:getConfig("item_icon"), arg2_21:Find("icon"))
	end

	local var1_21 = var0_21:getConfig("during_time")
	local var2_21 = var0_21:GetEndRound() - arg0_21.contextData.char:GetRoundData().round
	local var3_21 = var1_21 == -1 and i18n("child2_status_time2") or i18n("child2_status_time1", var2_21)

	setText(arg2_21:Find("time/Text"), var3_21)
	setText(arg2_21:Find("info/content/name"), var0_21:getConfig("name"))
	setText(arg2_21:Find("info/content/desc"), var0_21:getConfig("desc"))
end

function var0_0.Flush(arg0_22)
	arg0_22:FlushAttrs()
	arg0_22:FlushTalents()
	arg0_22:FlushStatus()
end

function var0_0.FlushAttrs(arg0_23)
	local var0_23 = arg0_23.contextData.char:GetPersonalityMiddle()
	local var1_23 = arg0_23.contextData.char:GetPersonalityTag()
	local var2_23 = arg0_23.contextData.char:GetPersonality()

	setSlider(arg0_23.personalityTF:Find("slider"), -var0_23, var0_23, var2_23 - var0_23)
	setText(arg0_23.personalityValueTF, math.abs(var2_23 - var0_23))

	local var3_23 = var1_23 == "tag1" and "26b1f3" or "ff6767"

	setTextColor(arg0_23.personalityValueTF, Color.NewHex(var3_23))
	arg0_23.attrUIList:align(#arg0_23.attrIds)
end

function var0_0.FlushTalents(arg0_24)
	arg0_24.talents = arg0_24.contextData.char:GetTalentList()

	arg0_24.talentUIList:align(#arg0_24.talentRoundIds)
end

function var0_0.FlushStatus(arg0_25)
	arg0_25.status = arg0_25.contextData.char:GetStatusList()

	arg0_25.statusUIList:align(#arg0_25.status)
end

function var0_0.OnDestroy(arg0_26)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_26._tf)
end

function var0_0.GetArrtInfo(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27) do
		if arg1_27 >= iter1_27[1][1] and arg1_27 < iter1_27[1][2] then
			return iter1_27[2], arg1_27 .. "/" .. iter1_27[1][2]
		end
	end

	return arg0_27[#arg0_27][2], arg1_27 .. "/" .. arg0_27[#arg0_27][1][2]
end

return var0_0
