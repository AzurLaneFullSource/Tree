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

	setText(arg0_2.contnetTF:Find("personality/personality_title/Text"), i18n("child2_personality_title"))

	arg0_2.personalityTF = arg0_2.contnetTF:Find("personality/personality")
	arg0_2.personalityValueTF = arg0_2.personalityTF:Find("slider/handle/Image/bubble/Text")

	setText(arg0_2.contnetTF:Find("attrs/attr_title/Text"), i18n("child2_attr_title"))

	local var0_2 = arg0_2.contnetTF:Find("attrs/attrs/content")

	arg0_2.gradientBgTF = arg0_2.contnetTF:Find("attrs/attrs/bg_gradient")
	arg0_2.attrUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	setText(arg0_2.contnetTF:Find("talent/talent_title/Text"), i18n("child2_talent_title"))

	local var1_2 = arg0_2.contnetTF:Find("talent/talents/content")

	arg0_2.talentUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))
	arg0_2.statusTF = arg0_2.contnetTF:Find("status")

	setText(arg0_2.statusTF:Find("status_title/Text"), i18n("child2_status_title"))

	local var2_2 = arg0_2.statusTF:Find("status/content/content")

	arg0_2.statusUIList = UIItemList.New(var2_2, var2_2:Find("tpl"))
	arg0_2.tarotTF = arg0_2.contnetTF:Find("tarot")

	setText(arg0_2.tarotTF:Find("title/Text"), i18n("child2_tarot_title"))

	arg0_2.tarotIconTF = arg0_2.tarotTF:Find("bg/icon")
	arg0_2.tarotNameTF = arg0_2.tarotTF:Find("bg/name")
	arg0_2.tarotEntryTF = arg0_2.tarotTF:Find("bg/entry")
	arg0_2.attrIds = arg0_2.contextData.char:GetAttrIds()
	arg0_2.talentRoundIds = arg0_2.contextData.char:GetRoundData():GetTalentRoundIds()
end

function var0_0.OnInit(arg0_4)
	local var0_4 = "neweducateicon/" .. arg0_4.contextData.char:getConfig("child2_data_personality_icon")[1]

	LoadImageSpriteAsync(var0_4, arg0_4.personalityTF:Find("slider/handle/Image"), true)

	local var1_4 = "neweducateicon/" .. arg0_4.contextData.char:getConfig("personality_bar_icon")

	LoadImageSpriteAsync(var1_4, arg0_4.personalityTF, true)
	onButton(arg0_4, arg0_4.showBtn, function()
		arg0_4:ShowPanel()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.foldBtn, function()
		arg0_4:HidePanel()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.tarotTF:Find("bg"), function()
		arg0_4:emit(NewEducateBaseUI.GO_SUBLAYER, Context.New({
			mediator = NewEducateTarotEntryMediator,
			viewComponent = NewEducateTarotEntryLayer,
			data = {
				inShop = arg0_4.inShop
			}
		}))
	end, SFX_PANEL)
	arg0_4.attrUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventInit then
			local var0_8 = arg0_4.attrIds[arg1_8 + 1]
			local var1_8 = pg.child2_attr[var0_8]

			LoadImageSpriteAsync("neweducateicon/" .. var1_8.icon, arg2_8:Find("icon_bg/icon"))
			setScrollText(arg2_8:Find("name_mask/name"), var1_8.name)
		elseif arg0_8 == UIItemList.EventUpdate then
			arg0_4:OnUpdateAttrItem(arg1_8, arg2_8)
		end
	end)
	arg0_4.talentUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_4:OnUpdateTalentItem(arg1_9, arg2_9)
		end
	end)
	arg0_4.statusUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_4:OnUpdateStatusItem(arg1_10, arg2_10)
		end
	end)
	arg0_4:OverlayPanel(arg0_4._tf, {
		groupDelta = -1,
		pbList = {
			arg0_4.blurBg
		}
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

	arg0_4.isTarotChar = arg0_4.contextData.char:GetPermanentData():IsTarotType()

	setActive(arg0_4.tarotTF, arg0_4.isTarotChar)
	setActive(arg0_4.statusTF, not arg0_4.isTarotChar)
	arg0_4:Flush()
end

function var0_0.IsShowPanel(arg0_12)
	return isActive(arg0_12.showPanelTF)
end

function var0_0.ShowPanel(arg0_13)
	setActive(arg0_13.foldPanelTF, false)
	setActive(arg0_13.showPanelTF, true)
end

function var0_0.HidePanel(arg0_14, arg1_14)
	setActive(arg0_14.foldPanelTF, true)

	if not arg1_14 then
		arg0_14.showAnim:Play("anim_educate_archive_show_out")
	else
		setActive(arg0_14.showPanelTF, false)
	end

	eachChild(arg0_14.talentUIList.container, function(arg0_15)
		triggerToggle(arg0_15:Find("unlock"), false)
	end)
	eachChild(arg0_14.statusUIList.container, function(arg0_16)
		triggerToggle(arg0_16, false)
	end)
end

function var0_0.OnUpdateAttrItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.attrIds[arg1_17 + 1]
	local var1_17 = pg.child2_attr[var0_17]
	local var2_17 = arg0_17.contextData.char:GetAttr(var0_17)
	local var3_17, var4_17 = var0_0.GetArrtInfo(var1_17.rank, var2_17)

	setText(arg2_17:Find("rank/Text"), var3_17)
	setText(arg2_17:Find("value"), var4_17)

	local var5_17 = EducateConst.GRADE_2_COLOR[var3_17][1]
	local var6_17 = EducateConst.GRADE_2_COLOR[var3_17][2]
	local var7_17 = arg0_17.gradientBgTF:GetChild(arg1_17)

	setImageColor(var7_17, Color.NewHex(var5_17))
	setImageColor(arg2_17:Find("rank"), Color.NewHex(var6_17))
	setToggleEnabled(arg2_17, arg0_17.isTarotChar)

	if arg0_17.isTarotChar then
		setText(arg2_17:Find("info/content/name"), var1_17.name)
		setText(arg2_17:Find("info/content/value"), var4_17)

		local var8_17, var9_17 = arg0_17.contextData.char:GetBenefitData():GetDisplayPctByDrop({
			type = NewEducateConst.DROP_TYPE.ATTR,
			id = var0_17
		})
		local var10_17 = i18n("child2_benefit_summary") .. var8_17 .. "%" .. "\n" .. i18n("child2_benefit_summary2") .. var9_17 .. "%"

		setText(arg2_17:Find("info/content/desc"), var10_17)
	end
end

function var0_0.OnUpdateTalentItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.talents[arg1_18 + 1]

	setActive(arg2_18:Find("unlock"), var0_18)
	setActive(arg2_18:Find("lock"), not var0_18)

	if var0_18 then
		LoadImageSpriteAsync("neweducateicon/" .. var0_18:getConfig("item_icon_little"), arg2_18:Find("unlock/icon"))
		setText(arg2_18:Find("unlock/name"), shortenString(var0_18:getConfig("name"), 5))
		setText(arg2_18:Find("unlock/info/content/name"), var0_18:getConfig("name"))
		setText(arg2_18:Find("unlock/info/content/desc"), var0_18:getConfig("desc"))
	end

	local var1_18 = arg0_18.talentRoundIds[arg1_18 + 1]

	onButton(arg0_18, arg2_18:Find("lock"), function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_talent_unlock_tip", var1_18))
	end, SFX_PANEL)
	onScroll(arg0_18, arg0_18.statusTF:Find("status"), function(arg0_20)
		eachChild(arg0_18.statusUIList.container, function(arg0_21)
			triggerToggle(arg0_21, false)
		end)
	end)
end

function var0_0.OnUpdateStatusItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.status[arg1_22 + 1]

	if arg2_22.name ~= tostring(var0_22.id) then
		arg2_22.name = var0_22.id

		LoadImageSpriteAsync("neweducateicon/" .. var0_22:getConfig("item_icon"), arg2_22:Find("icon"))
	end

	local var1_22 = var0_22:getConfig("during_time")
	local var2_22 = var0_22:GetEndRound() - arg0_22.contextData.char:GetRoundData().round
	local var3_22 = var1_22 == -1 and i18n("child2_status_time2") or i18n("child2_status_time1", var2_22)

	setText(arg2_22:Find("time/Text"), var3_22)
	setText(arg2_22:Find("info/content/name"), var0_22:getConfig("name"))
	setText(arg2_22:Find("info/content/desc"), var0_22:getConfig("desc"))
end

function var0_0.Flush(arg0_23)
	arg0_23:FlushAttrs()
	arg0_23:FlushTalents()
	arg0_23:FlushStatus()
	arg0_23:FlushTarot()
end

function var0_0.FlushAttrs(arg0_24)
	local var0_24 = arg0_24.contextData.char:GetPersonalityMiddle()
	local var1_24 = arg0_24.contextData.char:GetPersonalityTag()
	local var2_24 = arg0_24.contextData.char:GetPersonality()

	setSlider(arg0_24.personalityTF:Find("slider"), -var0_24, var0_24, var2_24 - var0_24)
	setText(arg0_24.personalityValueTF, math.abs(var2_24 - var0_24))

	local var3_24 = var1_24 == "tag1" and "26b1f3" or "ff6767"

	setTextColor(arg0_24.personalityValueTF, Color.NewHex(var3_24))
	arg0_24.attrUIList:align(#arg0_24.attrIds)
end

function var0_0.FlushTalents(arg0_25)
	arg0_25.talents = arg0_25.contextData.char:GetTalentList()

	arg0_25.talentUIList:align(#arg0_25.talentRoundIds)
end

function var0_0.FlushStatus(arg0_26)
	arg0_26.status = arg0_26.contextData.char:GetStatusList()

	arg0_26.statusUIList:align(#arg0_26.status)
end

function var0_0.FlushTarot(arg0_27)
	arg0_27.tarotId = arg0_27.contextData.char:GetTarotId()

	setActive(arg0_27.tarotIconTF, arg0_27.tarotId)

	if arg0_27.tarotId then
		LoadImageSpriteAsync("neweducateicon/" .. pg.child2_benefit_list[arg0_27.tarotId].item_icon_little, arg0_27.tarotIconTF)
	end

	setText(arg0_27.tarotNameTF, arg0_27.tarotId and pg.child2_benefit_list[arg0_27.tarotId].name or "EMPTY")

	arg0_27.entries = arg0_27.contextData.char:GetBenefitData():GetListByType(NewEducateBuff.TYPE.ENTRY)

	setText(arg0_27.tarotEntryTF, i18n("child2_entry_summary") .. #arg0_27.entries)
end

function var0_0.SetShopOpen(arg0_28, arg1_28)
	arg0_28.inShop = arg1_28
end

function var0_0.OnDestroy(arg0_29)
	arg0_29:UnOverlayPanel(arg0_29._tf)
end

function var0_0.GetArrtInfo(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(arg0_30) do
		if arg1_30 >= iter1_30[1][1] and arg1_30 < iter1_30[1][2] then
			return iter1_30[2], arg1_30 .. "/" .. iter1_30[1][2]
		end
	end

	return arg0_30[#arg0_30][2], arg1_30 .. "/" .. arg0_30[#arg0_30][1][2]
end

return var0_0
