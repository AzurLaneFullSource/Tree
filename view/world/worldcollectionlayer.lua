local var0_0 = class("WorldCollectionLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2._tf:Find("top")
	arg0_2.backBtn = arg0_2.top:Find("back_btn")
	arg0_2.topToggles = arg0_2.top:Find("toggles")
	arg0_2.rtMain = arg0_2._tf:Find("main")
	arg0_2.entranceContainer = arg0_2.rtMain:Find("list_bg/map_list/content")
	arg0_2.btnGetAll = arg0_2.rtMain:Find("list_bg/btn_get_all")
	arg0_2.scrollEntrance = GetComponent(arg0_2.entranceContainer, "LScrollRect")

	function arg0_2.scrollEntrance.onUpdateItem(arg0_3, arg1_3)
		arg0_3 = arg0_3 + 1

		local var0_3 = tf(arg1_3)
		local var1_3 = arg0_2.achEntranceList[arg0_3]

		arg0_2.entranceOjbecDic[arg0_3] = var0_3

		setText(var0_3:Find("icon/deco_id"), var1_3.config.serial_number)
		setText(var0_3:Find("icon/name"), var1_3:GetBaseMap():GetName())
		setActive(var0_3:Find("icon/tip"), nowWorld():AnyUnachievedAchievement(var1_3))
		onButton(arg0_2, var0_3, function()
			arg0_2:UpdateAchievement(arg0_3)
		end, SFX_PANEL)

		local var2_3 = var0_3:Find("icon")

		setAnchoredPosition(var2_3, {
			y = (1 - arg0_3 % 2 * 2) * math.abs(var2_3.anchoredPosition.y)
		})
		setActive(var2_3:Find("select"), arg0_2.selectedIndex == arg0_3)
		setText(var2_3:Find("select/gomap/Text"), i18n("world_target_goto"))
		onButton(arg0_2, var2_3:Find("select/gomap"), function()
			arg0_2:emit(WorldCollectionMediator.ON_MAP, var1_3)
			arg0_2:closeView()
		end, SFX_PANEL)
	end

	function arg0_2.scrollEntrance.onReturnItem(arg0_6, arg1_6)
		if arg0_2.exited then
			return
		end

		arg0_2.entranceOjbecDic[arg0_6 + 1] = nil

		removeOnButton(arg1_6)
	end

	arg0_2.scrollEntrance.onValueChanged:AddListener(function(arg0_7)
		arg0_2:UpdateJumpBtn()
	end)

	arg0_2.entrancePanel = arg0_2.rtMain:Find("map")
	arg0_2.entranceTitle = arg0_2.entrancePanel:Find("target_rect/title")
	arg0_2.targetContainer = arg0_2.entrancePanel:Find("target_rect/target_list/content")
	arg0_2.targetItemList = UIItemList.New(arg0_2.targetContainer, arg0_2.targetContainer:Find("item"))

	arg0_2.targetItemList:make(function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_8 > #arg0_2.achEntranceList[arg0_2.selectedIndex].config.normal_target
			local var1_8 = arg2_8:Find("bg")

			setActive(var1_8:Find("normal"), not var0_8)
			setActive(var1_8:Find("hidden"), var0_8)

			local var2_8 = arg0_2.targetList[arg1_8]
			local var3_8 = var2_8:IsAchieved()
			local var4_8 = not var0_8 or var3_8 or arg0_2.showHiddenDesc

			setText(var1_8:Find("desc"), var4_8 and var2_8.config.target_desc or "???")
			setText(var1_8:Find("progress"), var4_8 and var2_8:GetProgress() .. "/" .. var2_8:GetMaxProgress() or "")
			setActive(var1_8:Find("finish_mark/Image"), var3_8)

			local var5_8 = arg2_8:Find("pop")
			local var6_8 = var2_8:GetTriggers()
			local var7_8 = var4_8 and #var6_8 > 1

			if var7_8 then
				local var8_8 = var5_8
				local var9_8 = var5_8:Find("Text")
				local var10_8 = var8_8.childCount

				local function var11_8(arg0_9, arg1_9)
					local var0_9 = var6_8[arg0_9]

					setText(arg1_9, var0_9:GetDesc())
					setTextColor(arg1_9, var0_9:IsAchieved() and Color.New(0.368627450980392, 0.607843137254902, 1) or Color.New(0.474509803921569, 0.474509803921569, 0.474509803921569))
					setActive(arg1_9, true)
				end

				for iter0_8 = #var6_8, var10_8 - 1 do
					setActive(var8_8:GetChild(iter0_8), false)
				end

				for iter1_8 = var10_8, #var6_8 - 1 do
					cloneTplTo(var9_8, var8_8)
				end

				for iter2_8 = 0, #var6_8 - 1 do
					var11_8(iter2_8 + 1, var8_8:GetChild(iter2_8))
				end
			end

			triggerToggle(arg2_8, false)
			setToggleEnabled(arg2_8, var7_8)
			setActive(var1_8:Find("arrow"), var7_8)
		end
	end)

	arg0_2.achAwardRect = arg0_2.entrancePanel:Find("award_rect")
	arg0_2.achAchieveBtn = arg0_2.achAwardRect:Find("btn_achieve")
	arg0_2.overviewBtn = arg0_2.entrancePanel:Find("btn_overview")
	arg0_2.subviewAchAward = WorldAchAwardSubview.New(arg0_2._tf, arg0_2.event)

	arg0_2:bind(WorldAchAwardSubview.ShowDrop, function(arg0_10, arg1_10)
		arg0_2:emit(var0_0.ON_DROP, arg1_10)
	end)
end

function var0_0.onBackPressed(arg0_11)
	if arg0_11.subviewAchAward:isShowing() then
		arg0_11.subviewAchAward:ActionInvoke("Hide")
	else
		var0_0.super.onBackPressed(arg0_11)
	end
end

function var0_0.didEnter(arg0_12)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_12._tf)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:closeView()
	end, SFX_CANCEL)
	onToggle(arg0_12, arg0_12.topToggles:Find("all"), function(arg0_14)
		if arg0_14 then
			arg0_12:UpdateEntranceFilter(false)
		end
	end, SFX_PANEL)
	setText(arg0_12.topToggles:Find("all/Text"), i18n("world_target_filter_tip1"))
	setText(arg0_12.topToggles:Find("all/Image/Text"), i18n("world_target_filter_tip1"))
	onToggle(arg0_12, arg0_12.topToggles:Find("unfinish"), function(arg0_15)
		if arg0_15 then
			arg0_12:UpdateEntranceFilter(true)
		end
	end, SFX_PANEL)
	setText(arg0_12.topToggles:Find("unfinish/Text"), i18n("world_target_filter_tip2"))
	setText(arg0_12.topToggles:Find("unfinish/Image/Text"), i18n("world_target_filter_tip2"))
	onButton(arg0_12, arg0_12.rtMain:Find("list_bg/jump_icon_left"), function()
		arg0_12:ScrollAndSelectEntrance(arg0_12:GetAwardIndex(false))
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.rtMain:Find("list_bg/jump_icon_right"), function()
		arg0_12:ScrollAndSelectEntrance(arg0_12:GetAwardIndex(true))
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.btnGetAll, function()
		local var0_18, var1_18 = nowWorld():GetFinishAchievements(arg0_12.achEntranceList)

		if #var0_18 > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_target_get_all"),
				onYes = function()
					arg0_12:emit(WorldCollectionMediator.ON_ACHIEVE_STAR, var0_18)
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("without any award")
		end
	end, SFX_CONFIRM)
	onButton(arg0_12, arg0_12.achAchieveBtn, function()
		local var0_20, var1_20 = nowWorld():AnyUnachievedAchievement(arg0_12.entrance)

		if var0_20 then
			arg0_12:emit(WorldCollectionMediator.ON_ACHIEVE_STAR, {
				{
					id = arg0_12.entrance.id,
					star_list = {
						var1_20.star
					}
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.entrancePanel:Find("page_left"), function()
		arg0_12:ScrollAndSelectEntrance(arg0_12.selectedIndex - 1)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.entrancePanel:Find("page_right"), function()
		arg0_12:ScrollAndSelectEntrance(arg0_12.selectedIndex + 1)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.overviewBtn, function()
		arg0_12:emit(WorldCollectionMediator.ON_ACHIEVE_OVERVIEW)
	end, SFX_PANEL)
	triggerToggle(arg0_12.topToggles:Find("all"), true)
end

function var0_0.willExit(arg0_24)
	arg0_24.subviewAchAward:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf)
end

function var0_0.SetAchievementList(arg0_25, arg1_25)
	arg0_25.baseEntranceList = arg1_25
end

function var0_0.BuildEntranceScrollPos(arg0_26)
	arg0_26.entrancePos = {}
	arg0_26.entranceIndexDic = {}

	for iter0_26, iter1_26 in ipairs(arg0_26.achEntranceList) do
		table.insert(arg0_26.entrancePos, arg0_26.scrollEntrance:HeadIndexToValue(iter0_26 - 1))

		arg0_26.entranceIndexDic[iter1_26.id] = iter0_26

		if nowWorld():AnyUnachievedAchievement(iter1_26) then
			table.insert(arg0_26.achAwardIndexList, iter0_26)
		end
	end
end

function var0_0.UpdateEntranceFilter(arg0_27, arg1_27)
	if arg1_27 then
		arg0_27.achEntranceList = underscore.filter(arg0_27.baseEntranceList, function(arg0_28)
			local var0_28, var1_28, var2_28 = nowWorld():CountAchievements(arg0_28)

			return var2_28 > var0_28 + var1_28
		end)
	else
		arg0_27.achEntranceList = underscore.rest(arg0_27.baseEntranceList, 1)
	end

	arg0_27:UpdateGetAllAwardBtn()

	arg0_27.achAwardIndexList = {}
	arg0_27.entranceOjbecDic = {}

	arg0_27.scrollEntrance:SetTotalCount(#arg0_27.achEntranceList)
	arg0_27:BuildEntranceScrollPos()

	arg0_27.contextData.entranceId = defaultValue(arg0_27.contextData.entranceId, 0)

	local var0_27 = defaultValue(arg0_27.entranceIndexDic[arg0_27.contextData.entranceId], 1)

	arg0_27:ScrollAndSelectEntrance(var0_27)
end

function var0_0.UpdateGetAllAwardBtn(arg0_29)
	local var0_29, var1_29 = nowWorld():GetFinishAchievements(arg0_29.achEntranceList)
	local var2_29 = pg.gameset.world_target_obtain.key_value

	setActive(arg0_29.btnGetAll, var2_29 <= #var0_29)
end

function var0_0.FlushEntranceItem(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(arg1_30) do
		local var0_30 = arg0_30.entranceIndexDic[iter1_30.id]

		if not nowWorld():AnyUnachievedAchievement(arg0_30.achEntranceList[var0_30]) then
			if arg0_30.entranceOjbecDic[var0_30] then
				setActive(arg0_30.entranceOjbecDic[var0_30]:Find("icon/tip"), false)
			end

			table.removebyvalue(arg0_30.achAwardIndexList, var0_30)
		end
	end

	arg0_30:UpdateGetAllAwardBtn()
end

function var0_0.UpdateAchievement(arg0_31, arg1_31, arg2_31)
	if arg2_31 or arg0_31.selectedIndex ~= arg1_31 then
		arg1_31, arg0_31.selectedIndex = arg0_31.selectedIndex, arg1_31

		for iter0_31, iter1_31 in ipairs({
			arg1_31,
			arg0_31.selectedIndex
		}) do
			local var0_31 = arg0_31.entranceOjbecDic[iter1_31]

			if var0_31 then
				setActive(var0_31:Find("icon/select"), arg0_31.selectedIndex == iter1_31)
			end
		end

		arg0_31.entrance = arg0_31.achEntranceList[arg0_31.selectedIndex]

		arg0_31:FlushAchievement()
	end
end

function var0_0.GetAwardIndex(arg0_32, arg1_32)
	local var0_32 = arg0_32.entrancePos[#arg0_32.achEntranceList] - 1

	if arg1_32 then
		local var1_32 = arg0_32.scrollEntrance.value + var0_32

		for iter0_32 = 1, #arg0_32.achAwardIndexList do
			if var1_32 < arg0_32.entrancePos[arg0_32.achAwardIndexList[iter0_32]] then
				return arg0_32.achAwardIndexList[iter0_32]
			end
		end

		return nil
	else
		local var2_32 = arg0_32.scrollEntrance.value

		for iter1_32 = #arg0_32.achAwardIndexList, 1, -1 do
			if var2_32 > arg0_32.entrancePos[arg0_32.achAwardIndexList[iter1_32]] then
				return arg0_32.achAwardIndexList[iter1_32]
			end
		end

		return nil
	end
end

function var0_0.ScrollAndSelectEntrance(arg0_33, arg1_33)
	arg0_33:UpdateAchievement(arg1_33, true)

	local var0_33 = arg0_33.entrancePos[#arg0_33.achEntranceList] - 1

	arg0_33.scrollEntrance:ScrollTo(math.clamp(arg0_33.entrancePos[arg1_33] - var0_33 / 2, 0, 1))
end

function var0_0.UpdateJumpBtn(arg0_34)
	setActive(arg0_34.rtMain:Find("list_bg/jump_icon_left"), arg0_34:GetAwardIndex(false))
	setActive(arg0_34.rtMain:Find("list_bg/jump_icon_right"), arg0_34:GetAwardIndex(true))
end

function var0_0.FlushAchievement(arg0_35)
	arg0_35:UpdateJumpBtn()

	local var0_35 = nowWorld()

	arg0_35.showHiddenDesc = var0_35:IsNormalAchievementAchieved(arg0_35.entrance)
	arg0_35.targetList = var0_35:GetAchievements(arg0_35.entrance)

	arg0_35.targetItemList:align(#arg0_35.targetList)

	local var1_35 = arg0_35.entrance:GetBaseMap()

	GetImageSpriteFromAtlasAsync("world/targeticon/" .. var1_35.config.entrance_mapicon, "", arg0_35.entranceTitle)
	setText(arg0_35.entranceTitle:Find("name"), var1_35:GetName(arg0_35.entrance))
	setText(arg0_35.entranceTitle:Find("deco_id"), arg0_35.entrance.config.serial_number)

	local var2_35, var3_35, var4_35 = var0_35:CountAchievements(arg0_35.entrance)

	setText(arg0_35.entranceTitle:Find("progress_text"), var2_35 + var3_35 .. "/" .. var4_35)

	local var5_35, var6_35 = var0_35:AnyUnachievedAchievement(arg0_35.entrance)
	local var7_35 = arg0_35.achAwardRect:Find("award")

	if var6_35 then
		setActive(arg0_35.achAwardRect:Find("get_mask"), var5_35)
		setActive(arg0_35.achAwardRect:Find("got_mask"), false)
	else
		local var8_35 = arg0_35.entrance:GetAchievementAwards()

		var6_35 = var8_35[#var8_35]

		setActive(arg0_35.achAwardRect:Find("get_mask"), false)
		setActive(arg0_35.achAwardRect:Find("got_mask"), true)
	end

	updateDrop(var7_35, var6_35.drop)
	onButton(arg0_35, var7_35, function()
		arg0_35:showAchAwardPanel(arg0_35.entrance)
	end, SFX_PANEL)
	setText(arg0_35.achAwardRect:Find("star_count/Text"), var2_35 + var3_35 .. "/" .. var6_35.star)
	setActive(arg0_35.achAchieveBtn, var5_35)
	setActive(arg0_35.entrancePanel:Find("page_left"), arg0_35.selectedIndex > 1)
	setActive(arg0_35.entrancePanel:Find("page_right"), arg0_35.selectedIndex < #arg0_35.achEntranceList)
end

function var0_0.flushAchieveUpdate(arg0_37, arg1_37)
	arg0_37:FlushEntranceItem(arg1_37)
	arg0_37:FlushAchievement()
end

function var0_0.showAchAwardPanel(arg0_38, arg1_38)
	arg0_38.subviewAchAward:Load()
	arg0_38.subviewAchAward:ActionInvoke("Setup", arg1_38)
	arg0_38.subviewAchAward:ActionInvoke("Show")
end

return var0_0
