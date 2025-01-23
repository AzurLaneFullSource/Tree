local var0_0 = class("NewEducateSiteHandler")

var0_0.TPL_TYPE = {
	TEXT = 2,
	DROP = 4,
	CONDITION = 1,
	ARROWS = 5,
	OPTION = 3
}
var0_0.TEXT_WORLD_TYPE = {
	RIGHT = 2,
	ASIDE = 0,
	LEFT = 1
}

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.windowTF = arg0_1._tf:Find("window")
	arg0_1.titleTF = arg0_1.windowTF:Find("title/Text")
	arg0_1.closeBtn = arg0_1.windowTF:Find("close_btn")

	setActive(arg0_1.closeBtn, false)

	arg0_1.endOptionsTF = arg0_1.windowTF:Find("end_options")
	arg0_1.endBtn = arg0_1.endOptionsTF:Find("end_btn")

	setScrollText(arg0_1.endBtn:Find("mask/Text"), i18n("child2_site_exit"))
	setActive(arg0_1.endOptionsTF, false)

	arg0_1.againBtn = arg0_1.endOptionsTF:Find("again_btn")

	setScrollText(arg0_1.againBtn:Find("mask/Text"), i18n("child2_site_again"))

	arg0_1.closeBtn2 = arg0_1._tf:Find("close")

	setActive(arg0_1.closeBtn2, false)

	arg0_1.scrollrect = arg0_1.windowTF:Find("content/view")
	arg0_1.contentTF = arg0_1.scrollrect:Find("mask/content")
	arg0_1.optionsTF = arg0_1.windowTF:Find("content/options")
	arg0_1.optionUIList = UIItemList.New(arg0_1.optionsTF, arg0_1.optionsTF:Find("tpl"))

	arg0_1.optionUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateOption(arg1_2, arg2_2)
		end
	end)

	arg0_1.tpls = {
		[var0_0.TPL_TYPE.CONDITION] = arg0_1._tf:Find("window/tpls/tpl_condition"),
		[var0_0.TPL_TYPE.TEXT] = arg0_1._tf:Find("window/tpls/tpl_text"),
		[var0_0.TPL_TYPE.OPTION] = arg0_1._tf:Find("window/tpls/tpl_option"),
		[var0_0.TPL_TYPE.DROP] = arg0_1._tf:Find("window/tpls/tpl_drop"),
		[var0_0.TPL_TYPE.ARROWS] = arg0_1._tf:Find("window/tpls/tpl_arrows")
	}
	arg0_1.imageColorTFs = {
		arg0_1.windowTF:Find("title"),
		arg0_1.windowTF:Find("line"),
		arg0_1.tpls[var0_0.TPL_TYPE.TEXT]:Find("name_container/left/Image"),
		arg0_1.tpls[var0_0.TPL_TYPE.TEXT]:Find("name_container/right/Image")
	}
	arg0_1.textColorTFs = {
		arg0_1.tpls[var0_0.TPL_TYPE.TEXT]:Find("name_container/left"),
		arg0_1.tpls[var0_0.TPL_TYPE.TEXT]:Find("name_container/right"),
		arg0_1.tpls[var0_0.TPL_TYPE.OPTION]:Find("text"),
		arg0_1.tpls[var0_0.TPL_TYPE.DROP]:Find("tpl/content/value")
	}
	arg0_1.charName = getProxy(NewEducateProxy):GetCurChar():getConfig("name")
	arg0_1.playerName = getProxy(PlayerProxy):getRawData():GetName()
	arg0_1.passNodeIds = {}
	arg0_1.optionIds = {}
	arg0_1.dropRecords = {}
	arg0_1.speed = NewEducateConst.TYPEWRITE_SPEED
end

function var0_0.SetSite(arg0_3, arg1_3)
	setActive(arg0_3._go, true)

	arg0_3.siteId = arg1_3

	local var0_3 = pg.child2_site_display[arg1_3]

	arg0_3.siteType = var0_3.type

	local var1_3, var2_3 = NewEducateHelper.GetSiteColors(arg0_3.siteId)

	underscore.each(arg0_3.imageColorTFs, function(arg0_4)
		setImageColor(arg0_4, var1_3)
	end)
	underscore.each(arg0_3.textColorTFs, function(arg0_5)
		setTextColor(arg0_5, var2_3)
	end)
	setText(arg0_3.titleTF, var0_3.title)

	local var3_3 = getProxy(NewEducateProxy):GetCurChar()

	switch(arg0_3.siteType, {
		[NewEducateConst.SITE_TYPE.WORK] = function()
			existCall(arg0_3.onNormal)
			setActive(arg0_3._tf, false)

			local var0_6 = var3_3:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.WORK)
			local var1_6 = pg.child2_site_normal[var0_6]

			arg0_3:AddConditions(var3_3, var1_6)
			arg0_3:AddEnterOption(var1_6.title)
		end,
		[NewEducateConst.SITE_TYPE.TRAVEL] = function()
			existCall(arg0_3.onNormal)
			setActive(arg0_3._tf, false)

			local var0_7 = var3_3:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.TRAVEL)
			local var1_7 = pg.child2_site_normal[var0_7]

			arg0_3:AddConditions(var3_3, var1_7)
			arg0_3:AddEnterOption(var1_7.title)
		end,
		[NewEducateConst.SITE_TYPE.SHIP] = function()
			return
		end,
		[NewEducateConst.SITE_TYPE.EVENT] = function()
			setText(arg0_3.titleTF, pg.child2_site_event_group[var0_3.param].event_title)
		end
	})
end

function var0_0.AddConditions(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10:GetConditionIdsFromComplex(arg2_10.special_args)

	if not var0_10 or #var0_10 == 0 then
		return
	end

	local var1_10 = cloneTplTo(arg0_10.tpls[var0_0.TPL_TYPE.CONDITION], arg0_10.contentTF, arg0_10.siteId .. "Conditions")
	local var2_10 = underscore.detect(var0_10, function(arg0_11)
		return pg.child2_condition[arg0_11].type == NewEducateConst.CONDITION_TYPE.NORMAL_SITE_CNT
	end)

	if var2_10 and not arg1_10:IsMatchCondition(var2_10) then
		local var3_10 = pg.child2_condition[var2_10].param
		local var4_10 = var3_10[3] - arg1_10:GetNormalCnt(arg2_10.id)

		if var3_10[1] == ">" then
			var4_10 = var4_10 + 1
		end

		setText(var1_10:Find("count"), i18n("child2_unlock_site_cnt", var4_10))
	end

	setActive(var1_10:Find("count"), var2_10)

	local var5_10 = underscore.detect(var0_10, function(arg0_12)
		return pg.child2_condition[arg0_12].type == NewEducateConst.CONDITION_TYPE.ROUND
	end)

	if var5_10 and not arg1_10:IsMatchCondition(var5_10) then
		local var6_10 = pg.child2_condition[var5_10].param
		local var7_10 = var6_10[2] - arg1_10:GetRoundData().round

		if var6_10[1] == ">" then
			var7_10 = var7_10 + 1
		end

		setText(var1_10:Find("round"), i18n("child2_unlock_site_round", var7_10))
	end

	setActive(var1_10:Find("round"), var5_10)

	local var8_10 = underscore.select(var0_10, function(arg0_13)
		local var0_13 = pg.child2_condition[arg0_13]

		return var0_13.type == NewEducateConst.CONDITION_TYPE.DROP and var0_13.param[1] == NewEducateConst.DROP_TYPE.ATTR and not arg1_10:IsMatchCondition(arg0_13)
	end) or {}

	if #var8_10 > 0 then
		setText(var1_10:Find("attrs/text"), i18n("child2_unlock_site_attr"))

		local var9_10 = var1_10:Find("attrs/content")
		local var10_10 = UIItemList.New(var9_10, var9_10:Find("tpl"))

		var10_10:make(function(arg0_14, arg1_14, arg2_14)
			if arg0_14 == UIItemList.EventUpdate then
				local var0_14 = pg.child2_condition[var8_10[arg1_14 + 1]].param
				local var1_14 = var0_14[2]
				local var2_14 = pg.child2_attr[var1_14]
				local var3_14 = var0_14[4]

				LoadImageSpriteAsync("neweducateicon/" .. var2_14.icon, arg2_14:Find("icon_bg/icon"))
				setText(arg2_14:Find("name"), var2_14.name)

				local var4_14 = arg1_10:GetAttr(var1_14)

				setText(arg2_14:Find("value"), (var4_14 < var3_14 and setColorStr(var4_14, "#a9a9b0") or var4_14) .. "/" .. var3_14)
			end
		end)
		var10_10:align(#var8_10)
	end

	setActive(var1_10:Find("attrs"), #var8_10 > 0)
end

function var0_0.AddEnterOption(arg0_15, arg1_15)
	local var0_15 = cloneTplTo(arg0_15.tpls[var0_0.TPL_TYPE.OPTION], arg0_15.contentTF, arg0_15.siteId .. "_EnterOption")

	setText(var0_15:Find("name_container/name"), arg0_15.charName)
	setText(var0_15:Find("text"), ">>" .. arg1_15)
end

function var0_0.AddEnterText(arg0_16, arg1_16, arg2_16)
	local var0_16 = cloneTplTo(arg0_16.tpls[var0_0.TPL_TYPE.TEXT], arg0_16.contentTF, arg0_16.siteId .. "_EnterText")

	setActive(var0_16:Find("name_container"), true)
	setActive(var0_16:Find("name_container/left"), true)
	setActive(var0_16:Find("name_container/right"), false)
	setText(var0_16:Find("name_container/left"), arg1_16)
	setText(var0_16:Find("text"), arg2_16)
end

function var0_0.Play(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg0_17.callName then
		arg0_17.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
	end

	local function var0_17(...)
		existCall(arg2_17(...))
		scrollTo(arg0_17.scrollrect, 0, 0)
	end

	table.insert(arg0_17.passNodeIds, arg1_17)

	local var1_17 = pg.child2_node[arg1_17]

	switch(var1_17.type, {
		[NewEducateNodePanel.NODE_TYPE.EVENT_TEXT] = function()
			arg0_17:AddText(var1_17, var0_17)
		end,
		[NewEducateNodePanel.NODE_TYPE.EVENT_OPTION] = function()
			arg0_17:AddOption(var1_17, var0_17)
		end,
		[NewEducateNodePanel.NODE_TYPE.DROP] = function()
			arg0_17:AddDrops(arg1_17, arg3_17, var0_17)
		end
	})
end

function var0_0._GetText(arg0_22, arg1_22)
	local var0_22 = pg.child2_word[arg1_22].word

	return string.gsub(var0_22, "$1", arg0_22.callName)
end

function var0_0.UpdateOption(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.optionIds[arg1_23 + 1]

	arg2_23.name = var0_23

	local var1_23 = pg.child2_node[var0_23]

	setScrollText(arg2_23:Find("mask/name"), arg0_23:_GetText(var1_23.text))

	local var2_23 = var1_23.performance_param

	setActive(arg2_23:Find("bg"), var2_23 ~= "")

	if var2_23 ~= "" then
		LoadImageSpriteAtlasAsync("ui/neweducatenodeui_atlas", "option_bg" .. var2_23, arg2_23:Find("bg"))
	end

	local var3_23 = false
	local var4_23 = getProxy(NewEducateProxy):GetCurChar()

	if #var1_23.option_condition > 0 then
		var3_23 = not var4_23:IsMatchComplex(var1_23.option_condition)
	end

	setActive(arg2_23:Find("cost"), #var1_23.option_cost > 0)

	local var5_23 = NewEducateHelper.Config2Drops(var1_23.option_cost)

	if #var5_23 > 0 then
		local var6_23 = UIItemList.New(arg2_23:Find("cost"), arg2_23:Find("cost/tpl"))

		var6_23:make(function(arg0_24, arg1_24, arg2_24)
			if arg0_24 == UIItemList.EventUpdate then
				local var0_24 = var5_23[arg1_24 + 1]
				local var1_24 = NewEducateHelper.GetDropConfig(var0_24).icon

				LoadImageSpriteAsync("neweducateicon/" .. var1_24, arg2_24:Find("Image"))
				setText(arg2_24:Find("Text"), "-" .. var0_24.number)
			end
		end)
		var6_23:align(#var5_23)

		local var7_23 = underscore.map(var5_23, function(arg0_25)
			arg0_25.operator = ">="

			return arg0_25
		end)

		var3_23 = var3_23 or not var4_23:IsMatchs(var7_23)
	end

	setImageColor(arg2_23, Color.NewHex(var3_23 and "C8CAD5" or "FFFFFF"))
	setTextColor(arg2_23:Find("mask/name"), Color.NewHex(var3_23 and "717171" or "393A3C"))

	if not var3_23 then
		onButton(arg0_23, arg2_23, function()
			existCall(arg0_23.callback(var0_23, var5_23))
		end, SFX_PANEL)
	else
		removeOnButton(arg2_23)
	end
end

function var0_0.AddText(arg0_27, arg1_27, arg2_27)
	arg0_27.speed = NewEducateConst.TYPEWRITE_SPEED

	local var0_27 = cloneTplTo(arg0_27.tpls[var0_0.TPL_TYPE.TEXT], arg0_27.contentTF, arg1_27.id)
	local var1_27 = arg1_27.name ~= 0

	setActive(var0_27:Find("name_container"), var1_27)

	local var2_27 = false

	if var1_27 then
		local var3_27 = pg.child2_word[arg1_27.name]
		local var4_27 = arg0_27:_GetText(var3_27.id)

		if var3_27.char_type == NewEducateConst.WORD_TYPE.SITE_LEFT then
			setActive(var0_27:Find("name_container/left"), true)
			setActive(var0_27:Find("name_container/right"), false)
			setText(var0_27:Find("name_container/left"), var4_27)
		elseif var3_27.char_type == NewEducateConst.WORD_TYPE.SITE_RIGHT then
			var2_27 = true

			setActive(var0_27:Find("name_container/left"), false)
			setActive(var0_27:Find("name_container/right"), true)
			setText(var0_27:Find("name_container/right"), var4_27)
		end
	end

	local var5_27 = arg0_27:_GetText(arg1_27.text)

	if var2_27 and GetPerceptualSize(var5_27) < 22 then
		var0_27:Find("text"):GetComponent(typeof(Text)).alignment = TextAnchor.UpperRight
	end

	setText(var0_27:Find("text"), var5_27)

	local var6_27 = GetComponent(var0_27:Find("text"), typeof(Typewriter))

	function var6_27.endFunc()
		if arg1_27.next_type == NewEducateNodePanel.NEXT_TYPE.OPTION then
			arg0_27.optionIds = arg0_27:FilterOptions(arg1_27.next)
			arg0_27.callback = arg2_27

			arg0_27.optionUIList:align(#arg0_27.optionIds)
		else
			arg0_27.optionUIList:align(#arg0_27.optionIds)
			existCall(arg2_27)
		end

		arg0_27:StopAutoScroll()
		scrollTo(arg0_27.scrollrect, 0, 0)
	end

	var6_27:setSpeed(arg0_27.speed)
	var6_27:Play()

	if arg0_27.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
		onButton(arg0_27, arg0_27.windowTF, function()
			removeOnButton(arg0_27.windowTF)

			arg0_27.speed = NewEducateConst.TYPEWRITE_SPEED_UP

			var6_27:setSpeed(arg0_27.speed)
		end)
	end

	arg0_27:StartAutoScroll()
end

function var0_0.FilterOptions(arg0_30, arg1_30)
	local var0_30 = getProxy(NewEducateProxy):GetCurChar()

	return underscore.select(arg1_30, function(arg0_31)
		local var0_31 = pg.child2_node[arg0_31]

		if var0_31.option_condition_show == 0 then
			return true
		end

		local var1_31 = false

		if #var0_31.option_condition > 0 then
			var1_31 = not var0_30:IsMatchComplex(var0_31.option_condition)
		end

		return not var1_31
	end)
end

function var0_0.AddOption(arg0_32, arg1_32, arg2_32)
	local var0_32 = cloneTplTo(arg0_32.tpls[var0_0.TPL_TYPE.OPTION], arg0_32.contentTF, arg1_32.id)
	local var1_32 = pg.child2_word[arg1_32.text].char_type

	if var1_32 == NewEducateConst.WORD_TYPE.CHILD then
		setActive(var0_32:Find("name_container"), true)
		setText(var0_32:Find("name_container/name"), arg0_32.charName)
	elseif var1_32 == NewEducateConst.WORD_TYPE.PLAYER then
		setActive(var0_32:Find("name_container"), true)
		setText(var0_32:Find("name_container/name"), arg0_32.playerName)
	else
		setActive(var0_32:Find("name_container"), false)
	end

	setText(var0_32:Find("text"), ">>" .. arg0_32:_GetText(arg1_32.text))

	if arg1_32.next_type == NewEducateNodePanel.NEXT_TYPE.OPTION then
		arg0_32.optionIds = arg1_32.next
		arg0_32.callback = arg2_32

		arg0_32.optionUIList:align(#arg0_32.optionIds)
	else
		arg0_32.optionIds = {}

		arg0_32.optionUIList:align(#arg0_32.optionIds)
		existCall(arg2_32)
	end
end

function var0_0.AddDrops(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = cloneTplTo(arg0_33.tpls[var0_0.TPL_TYPE.DROP], arg0_33.contentTF, arg1_33)

	setActive(var0_33:Find("tpl"), false)

	local var1_33 = {}

	for iter0_33, iter1_33 in ipairs(arg2_33) do
		table.insert(var1_33, function(arg0_34)
			local var0_34 = cloneTplTo(var0_33:Find("tpl"), var0_33, iter1_33.type .. "_" .. iter1_33.id)

			arg0_33:UpdateDropText(iter1_33, var0_34, arg0_34)
		end)
	end

	seriesAsync(var1_33, function()
		local var0_35 = underscore.reduce(arg2_33, 0, function(arg0_36, arg1_36)
			return arg0_36 + (NewEducateHelper.IsPersonalDrop(arg1_36) and arg1_36.number or 0)
		end)

		if var0_35 ~= 0 then
			arg0_33:CheckPersonalChange(var0_35)
		end

		existCall(arg3_33)
	end)
end

function var0_0.UpdateDropText(arg0_37, arg1_37, arg2_37, arg3_37)
	arg0_37.speed = NewEducateConst.TYPEWRITE_SPEED

	local var0_37 = NewEducateHelper.GetDropConfig(arg1_37)

	if NewEducateHelper.IsPersonalDrop(arg1_37) then
		local var1_37 = arg1_37.number > 0 and i18n("child2_personal_tag2") or i18n("child2_personal_tag1")

		setText(arg2_37:Find("content/value"), var1_37 .. "+" .. math.abs(arg1_37.number))
	elseif arg1_37.type == NewEducateConst.DROP_TYPE.ATTR or arg1_37.type == NewEducateConst.DROP_TYPE.RES then
		local var2_37 = arg1_37.number > 0 and "child2_site_drop_add" or "child2_site_drop_reduce"
		local var3_37 = getProxy(NewEducateProxy):GetCurChar():GetOwnCnt(arg1_37)
		local var4_37 = var3_37 - arg1_37.number + (arg1_37.overflow or 0)
		local var5_37 = math.abs(arg1_37.number - (arg1_37.overflow or 0))

		setText(arg2_37:Find("content/value"), i18n(var2_37, var0_37.name, var4_37, var3_37, var5_37))
	else
		setText(arg2_37:Find("content/value"), i18n("child2_site_drop_item", var0_37.name))
	end

	setActive(arg2_37:Find("content/benefit"), false)

	local var6_37 = GetComponent(arg2_37:Find("content/value"), typeof(Typewriter))

	function var6_37.endFunc()
		onDelayTick(function()
			existCall(arg3_37)
		end, 0.5)
	end

	var6_37:setSpeed(arg0_37.speed)

	if not isActive(arg0_37._tf) then
		existCall(arg3_37)
	else
		var6_37:Play()

		if arg0_37.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
			onButton(arg0_37, arg0_37.windowTF, function()
				removeOnButton(arg0_37.windowTF)

				arg0_37.speed = NewEducateConst.TYPEWRITE_SPEED_UP

				var6_37:setSpeed(arg0_37.speed)
			end)
		end

		scrollTo(arg0_37.scrollrect, 0, 0)
	end
end

function var0_0.CheckPersonalChange(arg0_41, arg1_41)
	arg0_41.speed = NewEducateConst.TYPEWRITE_SPEED

	local var0_41 = getProxy(NewEducateProxy):GetCurChar()
	local var1_41 = var0_41:GetPersonalityTag()

	if var0_41:GetPersonalityTag(var0_41:GetPersonality() - arg1_41) ~= var1_41 then
		local var2_41 = cloneTplTo(arg0_41.tpls[var0_0.TPL_TYPE.DROP], arg0_41.contentTF, "personal_change"):Find("tpl")
		local var3_41 = arg1_41 > 0 and i18n("child2_personal_tag2") or i18n("child2_personal_tag1")

		setText(var2_41:Find("content/value"), i18n("child2_personal_change") .. ">>" .. var3_41)
		setActive(var2_41:Find("content/benefit"), false)

		local var4_41 = GetComponent(var2_41:Find("content/value"), typeof(Typewriter))

		function var4_41.endFunc()
			return
		end

		var4_41:setSpeed(arg0_41.speed)
		var4_41:Play()

		if arg0_41.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
			onButton(arg0_41, arg0_41.windowTF, function()
				removeOnButton(arg0_41.windowTF)

				arg0_41.speed = NewEducateConst.TYPEWRITE_SPEED_UP

				var4_41:setSpeed(arg0_41.speed)
			end)
		end

		scrollTo(arg0_41.scrollrect, 0, 0)
	end
end

function var0_0.AddFavorUpgrade(arg0_44)
	arg0_44.speed = NewEducateConst.TYPEWRITE_SPEED

	local var0_44 = cloneTplTo(arg0_44.tpls[var0_0.TPL_TYPE.DROP], arg0_44.contentTF, "favor_drop"):Find("tpl")
	local var1_44 = pg.child2_site_display[arg0_44.siteId]
	local var2_44 = pg.child2_site_character[var1_44.param].level + 1

	setText(var0_44:Find("content/value"), i18n("child2_ship_upgrade_favor", var1_44.name, var2_44))
	setActive(var0_44:Find("content/benefit"), false)

	local var3_44 = GetComponent(var0_44:Find("content/value"), typeof(Typewriter))

	function var3_44.endFunc()
		return
	end

	var3_44:setSpeed(arg0_44.speed)
	var3_44:Play()

	if arg0_44.speed ~= NewEducateConst.TYPEWRITE_SPEED_UP then
		onButton(arg0_44, arg0_44.windowTF, function()
			removeOnButton(arg0_44.windowTF)

			arg0_44.speed = NewEducateConst.TYPEWRITE_SPEED_UP

			var3_44:setSpeed(arg0_44.speed)
		end)
	end

	scrollTo(arg0_44.scrollrect, 0, 0)
	pg.m02:sendNotification(NewEducateMapMediator.ON_SHIP_UPGRADE_LEVEL)
end

function var0_0.Reset(arg0_47)
	setActive(arg0_47._go, false)
	setActive(arg0_47.endOptionsTF, false)
	setActive(arg0_47.closeBtn, false)
	setActive(arg0_47.closeBtn2, false)
	removeAllChildren(arg0_47.contentTF)
	arg0_47:StopAutoScroll()

	arg0_47.dropRecords = {}
	arg0_47.passNodeIds = {}
	arg0_47.optionIds = {}
	arg0_47.callback = nil
	arg0_47.siteId = 0
	arg0_47.speed = NewEducateConst.TYPEWRITE_SPEED

	removeOnButton(arg0_47.windowTF)
end

function var0_0.BindEndBtn(arg0_48, arg1_48, arg2_48, arg3_48)
	onButton(arg0_48, arg0_48.endBtn, function()
		existCall(arg1_48)
	end, SFX_PANEL)
	onButton(arg0_48, arg0_48.closeBtn, function()
		existCall(arg1_48)
	end, SFX_PANEL)
	onButton(arg0_48, arg0_48.closeBtn2, function()
		existCall(arg1_48)
	end, SFX_PANEL)

	arg0_48.onSiteEnd = arg2_48
	arg0_48.onNormal = arg3_48
end

function var0_0.AddDropRecords(arg0_52, arg1_52)
	arg0_52.dropRecords = table.mergeArray(arg0_52.dropRecords, arg1_52)
end

function var0_0.OnEventEnd(arg0_53)
	setActive(arg0_53._tf, true)
	existCall(arg0_53.onSiteEnd)
	arg0_53:UpdateAgainBtn()
	setActive(arg0_53.endOptionsTF, true)
	setActive(arg0_53.closeBtn, true)
	setActive(arg0_53.closeBtn2, true)

	if pg.child2_site_display[arg0_53.siteId].type == NewEducateConst.SITE_TYPE.SHIP then
		arg0_53:AddFavorUpgrade()
	end
end

function var0_0.UpdateAgainBtn(arg0_54)
	local var0_54 = pg.child2_site_display[arg0_54.siteId].type
	local var1_54 = var0_54 == NewEducateConst.SITE_TYPE.WORK or var0_54 == NewEducateConst.SITE_TYPE.TRAVEL

	setActive(arg0_54.againBtn, var1_54)

	if var1_54 then
		local var2_54 = getProxy(NewEducateProxy):GetCurChar()
		local var3_54 = var0_54 == NewEducateConst.SITE_TYPE.WORK and NewEducateConst.SITE_NORMAL_TYPE.WORK or NewEducateConst.SITE_NORMAL_TYPE.TRAVEL
		local var4_54 = var2_54:GetNormalIdByType(var3_54)
		local var5_54 = NewEducateHelper.Config2Drop(pg.child2_site_normal[var4_54].cost)
		local var6_54 = NewEducateHelper.GetDropConfig(var5_54).icon

		LoadImageSpriteAsync("neweducateicon/" .. var6_54, arg0_54.againBtn:Find("cost/Image"))
		setText(arg0_54.againBtn:Find("cost/Text"), "-" .. var5_54.number)

		var5_54.operator = ">="

		local var7_54 = not var2_54:IsMatch(var5_54)

		setImageColor(arg0_54.againBtn, Color.NewHex(var7_54 and "C8CAD5" or "FFFFFF"))
		setTextColor(arg0_54.againBtn:Find("mask/Text"), Color.NewHex(var7_54 and "717171" or "393A3C"))

		if not var7_54 then
			onButton(arg0_54, arg0_54.againBtn, function()
				pg.m02:sendNotification(GAME.NEW_EDUCATE_MAP_NORMAL, {
					id = var2_54.id,
					normalId = var4_54
				})
				existCall(arg0_54.onNormal)
			end, SFX_PANEL)
		else
			removeOnButton(arg0_54.againBtn)
		end
	end
end

function var0_0.StartAutoScroll(arg0_56)
	arg0_56.timer = Timer.New(function()
		scrollTo(arg0_56.scrollrect, 0, 0)
	end, 0.4, -1)

	arg0_56.timer:Start()
end

function var0_0.StopAutoScroll(arg0_58)
	if arg0_58.timer then
		arg0_58.timer:Stop()

		arg0_58.timer = nil
	end
end

function var0_0.UpdateCallName(arg0_59)
	arg0_59.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
end

function var0_0.Destroy(arg0_60)
	pg.DelegateInfo.Dispose(arg0_60)
end

return var0_0
