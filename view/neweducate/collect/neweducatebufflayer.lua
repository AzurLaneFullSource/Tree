local var0_0 = class("NewEducateBuffLayer", import("view.base.BaseUI"))
local var1_0 = {
	[NewEducateBuff.TYPE.TAROT] = i18n("child2_collect_tarot_progress"),
	[NewEducateBuff.TYPE.ENTRY] = i18n("child2_collect_entry_progress"),
	[NewEducateBuff.TYPE.TALENT] = i18n("child2_collect_talent_progress")
}
local var2_0 = {
	[NewEducateBuff.TYPE.TAROT] = i18n("child2_collect_tarot"),
	[NewEducateBuff.TYPE.ENTRY] = i18n("child2_collect_entry"),
	[NewEducateBuff.TYPE.TALENT] = i18n("child2_collect_talent")
}

function var0_0.getUIName(arg0_1)
	return "NewEducateBuffUI"
end

function var0_0.getGroupName(arg0_2)
	return "NewEducateBaseUI"
end

function var0_0.init(arg0_3)
	arg0_3.windowTF = arg0_3._tf:Find("window")
	arg0_3.nextBtn = arg0_3.windowTF:Find("next_btn")
	arg0_3.lastBtn = arg0_3.windowTF:Find("last_btn")
	arg0_3.togglesTF = arg0_3.windowTF:Find("toggles")

	local var0_3 = arg0_3.windowTF:Find("pages")

	arg0_3.pageTFs = {}
	arg0_3.pageTFs[NewEducateBuff.TYPE.TAROT] = var0_3:Find(tostring(NewEducateBuff.TYPE.TAROT))
	arg0_3.pageTFs[NewEducateBuff.TYPE.ENTRY] = var0_3:Find(tostring(NewEducateBuff.TYPE.ENTRY))
	arg0_3.pageTFs[NewEducateBuff.TYPE.TALENT] = var0_3:Find(tostring(NewEducateBuff.TYPE.TALENT))
	arg0_3.boxsTF = arg0_3._tf:Find("detail_boxs")
	arg0_3.animCom = arg0_3._tf:Find("window"):GetComponent(typeof(Animation))
end

function var0_0.didEnter(arg0_4)
	arg0_4:OverlayPanel(arg0_4._tf, {
		groupDelta = 2
	})
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_PANEL)
	eachChild(arg0_4.togglesTF, function(arg0_6)
		local var0_6 = tonumber(arg0_6.name)

		setText(arg0_6:Find("name"), var2_0[var0_6])
		onButton(arg0_4, arg0_6, function()
			arg0_4.animCom:Play("anim_NewEducateBuffUI_left_click")

			local var0_7 = tonumber(arg0_6.name)

			arg0_4:SwtichView(var0_7)
		end, SFX_PANEL)
	end)
	onButton(arg0_4, arg0_4.nextBtn, function()
		arg0_4.curPageIdx = arg0_4.curPageIdx + 1

		arg0_4.animCom:Play("anim_NewEducateBuffUI_left_click")
		arg0_4:UpdatePage()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.lastBtn, function()
		arg0_4.curPageIdx = arg0_4.curPageIdx - 1

		arg0_4.animCom:Play("anim_NewEducateBuffUI_left_click")
		arg0_4:UpdatePage()
	end, SFX_PANEL)
	eachChild(arg0_4.boxsTF, function(arg0_10)
		onButton(arg0_4, arg0_10, function()
			setActive(arg0_10, false)
		end, SFX_PANEL)
	end)
	arg0_4:InitData()
	arg0_4:UpdateToggles()
	arg0_4:SwtichView(tonumber(arg0_4.togglesTF:GetChild(0).name))
end

function var0_0.InitData(arg0_12)
	arg0_12.config = pg.child2_benefit_list
	arg0_12.allIdMap = {
		[NewEducateBuff.TYPE.TAROT] = arg0_12.contextData.permanentData:GetAllTarotIds(),
		[NewEducateBuff.TYPE.ENTRY] = arg0_12.contextData.permanentData:GetAllEntryIds(),
		[NewEducateBuff.TYPE.TALENT] = arg0_12.contextData.permanentData:GetAllTalentIds()
	}
	arg0_12.unlockIdMap = {
		[NewEducateBuff.TYPE.TAROT] = arg0_12.contextData.permanentData:GetActivatedTarotIds(),
		[NewEducateBuff.TYPE.ENTRY] = arg0_12.contextData.permanentData:GetActivatedEntryIds(),
		[NewEducateBuff.TYPE.TALENT] = arg0_12.contextData.permanentData:GetActivatedTalentIds()
	}
	arg0_12.pageAllCntMap = {}

	for iter0_12, iter1_12 in pairs(arg0_12.allIdMap) do
		local var0_12 = arg0_12.pageTFs[iter0_12]:Find("content").childCount

		arg0_12.pageAllCntMap[iter0_12] = math.ceil(#iter1_12 / var0_12)
	end
end

function var0_0.UpdateToggles(arg0_13)
	eachChild(arg0_13.togglesTF, function(arg0_14)
		local var0_14 = tonumber(arg0_14.name)

		setText(arg0_14:Find("value"), #arg0_13.unlockIdMap[var0_14] .. "/" .. #arg0_13.allIdMap[var0_14])
	end)

	for iter0_13, iter1_13 in pairs(arg0_13.pageTFs) do
		setText(iter1_13:Find("progress/Text"), var1_0[iter0_13])
		setText(iter1_13:Find("progress/cur"), #arg0_13.unlockIdMap[iter0_13])
		setText(iter1_13:Find("progress/all"), "/" .. #arg0_13.allIdMap[iter0_13])
	end
end

function var0_0.SwtichView(arg0_15, arg1_15)
	if not arg0_15.curType or arg0_15.curType ~= arg1_15 then
		arg0_15.curType = arg1_15

		arg0_15:UpdateView()
	end

	eachChild(arg0_15.togglesTF, function(arg0_16)
		setActive(arg0_16:Find("sel"), tonumber(arg0_16.name) == arg1_15)
	end)
	eachChild(arg0_15.windowTF:Find("pages"), function(arg0_17)
		setActive(arg0_17, tonumber(arg0_17.name) == arg1_15)
	end)
end

function var0_0.UpdateView(arg0_18)
	if arg0_18.reverse then
		arg0_18.reverse = nil
		arg0_18.curPageIdx = arg0_18.pageAllCntMap[arg0_18.curType]
	else
		arg0_18.curPageIdx = 1
	end

	arg0_18:UpdatePage()
end

function var0_0.GetNextType(arg0_19)
	return switch(arg0_19.curType, {
		[NewEducateBuff.TYPE.TAROT] = function()
			return NewEducateBuff.TYPE.ENTRY
		end,
		[NewEducateBuff.TYPE.ENTRY] = function()
			return NewEducateBuff.TYPE.TALENT
		end,
		[NewEducateBuff.TYPE.TALENT] = function()
			return nil
		end
	})
end

function var0_0.GetLastType(arg0_23)
	return switch(arg0_23.curType, {
		[NewEducateBuff.TYPE.TAROT] = function()
			return nil
		end,
		[NewEducateBuff.TYPE.ENTRY] = function()
			return NewEducateBuff.TYPE.TAROT
		end,
		[NewEducateBuff.TYPE.TALENT] = function()
			return NewEducateBuff.TYPE.ENTRY
		end
	})
end

function var0_0.UpdatePage(arg0_27)
	local var0_27 = arg0_27.pageTFs[arg0_27.curType]
	local var1_27 = arg0_27.pageAllCntMap[arg0_27.curType]

	if var1_27 < arg0_27.curPageIdx then
		local var2_27 = arg0_27:GetNextType()

		if var2_27 then
			arg0_27:SwtichView(var2_27)

			return
		end
	elseif arg0_27.curPageIdx < 1 then
		local var3_27 = arg0_27:GetLastType()

		if var3_27 then
			arg0_27.reverse = true

			arg0_27:SwtichView(var3_27)

			return
		end
	end

	local var4_27 = arg0_27.curType == NewEducateBuff.TYPE.TALENT and var1_27 <= arg0_27.curPageIdx

	setActive(arg0_27.nextBtn, not var4_27)

	local var5_27 = arg0_27.curType == NewEducateBuff.TYPE.TAROT and arg0_27.curPageIdx <= 1

	setActive(arg0_27.lastBtn, not var5_27)
	setText(var0_27:Find("pagination"), arg0_27.curPageIdx .. "/" .. var1_27)

	local var6_27 = var0_27:Find("content")
	local var7_27 = var6_27.childCount
	local var8_27 = (arg0_27.curPageIdx - 1) * var7_27

	for iter0_27 = 1, var7_27 do
		local var9_27 = var6_27:Find(tostring(iter0_27))
		local var10_27 = arg0_27.allIdMap[arg0_27.curType][var8_27 + iter0_27]

		if var10_27 then
			setActive(var9_27, true)
			arg0_27:UpdateItem(var10_27, var9_27)
		else
			setActive(var9_27, false)
		end
	end
end

function var0_0.UpdateItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = table.contains(arg0_28.unlockIdMap[arg0_28.curType], arg1_28)

	setActive(arg2_28:Find("lock"), not var0_28)
	setActive(arg2_28:Find("unlock"), var0_28)
	switch(arg0_28.curType, {
		[NewEducateBuff.TYPE.TAROT] = function()
			NewEducateTarotCard.StaticShow(arg2_28:Find("unlock"), arg1_28)
			setText(arg2_28:Find("lock/Text"), arg0_28.config[arg1_28].get)
			setText(arg2_28:Find("lock/name/Text"), arg0_28.config[arg1_28].name)
			onButton(arg0_28, arg2_28, function()
				if not var0_28 then
					return
				end

				arg0_28:ShowDetailBox(arg1_28)
			end, SFX_PANEL)
		end,
		[NewEducateBuff.TYPE.ENTRY] = function()
			NewEducateEntryCard.StaticShow(arg2_28:Find("unlock"), arg1_28)
			setText(arg2_28:Find("lock/Text"), arg0_28.config[arg1_28].get)
			setText(arg2_28:Find("lock/name"), arg0_28.config[arg1_28].name)
			onButton(arg0_28, arg2_28, function()
				if not var0_28 then
					return
				end

				arg0_28:ShowDetailBox(arg1_28)
			end, SFX_PANEL)
		end,
		[NewEducateBuff.TYPE.TALENT] = function()
			local var0_33 = arg0_28.config[arg1_28]

			LoadImageSpriteAsync("neweducateicon/" .. var0_33.item_icon, arg2_28:Find("unlock/icon"))
			setText(arg2_28:Find("lock/Text"), var0_33.get)
			setText(arg2_28:Find("name"), var0_33.name)
			LoadImageSpriteAtlasAsync("ui/neweducatebuffui_atlas", "rarity_" .. var0_33.rare, arg2_28:Find("unlock"))
			onButton(arg0_28, arg2_28, function()
				if not var0_28 then
					return
				end

				arg0_28:ShowDetailBox(arg1_28)
			end, SFX_PANEL)
		end
	})
end

function var0_0.ShowDetailBox(arg0_35, arg1_35, arg2_35)
	eachChild(arg0_35.boxsTF, function(arg0_36)
		setActive(arg0_36, arg0_35.curType == tonumber(arg0_36.name))
	end)

	local var0_35 = arg0_35.boxsTF:Find(tostring(arg0_35.curType))

	switch(arg0_35.curType, {
		[NewEducateBuff.TYPE.TAROT] = function()
			NewEducateTarotCard.StaticShow(var0_35:Find("bg/tarot"), arg1_35)
		end,
		[NewEducateBuff.TYPE.ENTRY] = function()
			NewEducateEntryCard.StaticShow(var0_35:Find("bg/entry/unlock"), arg1_35)
			setText(var0_35:Find("bg/entry/lv"), "LV." .. arg0_35.config[arg1_35].benefit_level)
			setActive(var0_35:Find("bg/entry/unlock"), true)
			setActive(var0_35:Find("bg/entry/lock"), false)
			setActive(var0_35:Find("bg/toggles"), false)
		end,
		[NewEducateBuff.TYPE.TALENT] = function()
			local var0_39 = arg0_35.config[arg1_35]
			local var1_39 = var0_35:Find("bg/talent")

			LoadImageSpriteAsync("neweducateicon/" .. var0_39.item_icon, var1_39:Find("rarity/icon"))
			setText(var1_39:Find("name"), var0_39.name)
			setText(var1_39:Find("level"), "LV." .. var0_39.benefit_level)
			setText(var1_39:Find("desc/Text"), var0_39.desc)
			LoadImageSpriteAtlasAsync("ui/neweducatebuffui_atlas", "rarity_" .. var0_39.rare, var1_39:Find("rarity"))
		end
	})
end

function var0_0.ShowEntryBox(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg0_40.entryGroup2Ids[arg2_40]

	table.sort(var0_40, CompareFuncs({
		function(arg0_41)
			return arg0_40.config[arg0_41].benefit_level
		end,
		function(arg0_42)
			return arg0_42
		end
	}))
	UIItemList.StaticAlign(arg1_40:Find("bg/toggles"), arg1_40:Find("bg/toggles"):GetChild(0), #var0_40, function(arg0_43, arg1_43, arg2_43)
		if arg0_43 == UIItemList.EventUpdate then
			local var0_43 = var0_40[arg1_43 + 1]
			local var1_43 = arg0_40.config[var0_43]
			local var2_43 = var1_43.benefit_level

			arg2_43.name = tostring(var0_43)

			setText(arg2_43:Find("sel/Text"), "LV." .. var2_43)
			setText(arg2_43:Find("unsel/Text"), "LV." .. var2_43)

			local var3_43 = table.contains(arg0_40.unlockEntryIds, var0_43)

			setActive(arg2_43:Find("sel/Image"), not var3_43)
			setActive(arg2_43:Find("unsel/Image"), not var3_43)
			setActive(arg2_43:Find("sel/Text"), var3_43)
			setActive(arg2_43:Find("unsel/Text"), var3_43)
			onToggle(arg0_40, arg2_43, function(arg0_44)
				NewEducateEntryCard.StaticShow(arg1_40:Find("bg/entry/unlock"), var0_43)
				setText(arg1_40:Find("bg/entry/lv"), "LV." .. var2_43)
				setActive(arg1_40:Find("bg/entry/unlock"), var3_43)
				setActive(arg1_40:Find("bg/entry/lock"), not var3_43)
				setText(arg1_40:Find("bg/entry/lock/Text"), var1_43.get)
				setText(arg1_40:Find("bg/entry/lock/name"), var1_43.name)
			end, SFX_PANEL)
		end
	end)
	triggerToggle(arg1_40:Find("bg/toggles"):Find(tostring(arg3_40)), true)
end

function var0_0.willExit(arg0_45)
	arg0_45:UnOverlayPanel(arg0_45._tf)
end

return var0_0
