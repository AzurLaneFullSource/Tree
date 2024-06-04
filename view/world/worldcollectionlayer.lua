local var0 = class("WorldCollectionLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldCollectionUI"
end

function var0.init(arg0)
	arg0.top = arg0._tf:Find("top")
	arg0.backBtn = arg0.top:Find("back_btn")
	arg0.topToggles = arg0.top:Find("toggles")
	arg0.rtMain = arg0._tf:Find("main")
	arg0.entranceContainer = arg0.rtMain:Find("list_bg/map_list/content")
	arg0.btnGetAll = arg0.rtMain:Find("list_bg/btn_get_all")
	arg0.scrollEntrance = GetComponent(arg0.entranceContainer, "LScrollRect")

	function arg0.scrollEntrance.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = tf(arg1)
		local var1 = arg0.achEntranceList[arg0]

		arg0.entranceOjbecDic[arg0] = var0

		setText(var0:Find("icon/deco_id"), var1.config.serial_number)
		setText(var0:Find("icon/name"), var1:GetBaseMap():GetName())
		setActive(var0:Find("icon/tip"), nowWorld():AnyUnachievedAchievement(var1))
		onButton(arg0, var0, function()
			arg0:UpdateAchievement(arg0)
		end, SFX_PANEL)

		local var2 = var0:Find("icon")

		setAnchoredPosition(var2, {
			y = (1 - arg0 % 2 * 2) * math.abs(var2.anchoredPosition.y)
		})
		setActive(var2:Find("select"), arg0.selectedIndex == arg0)
		setText(var2:Find("select/gomap/Text"), i18n("world_target_goto"))
		onButton(arg0, var2:Find("select/gomap"), function()
			arg0:emit(WorldCollectionMediator.ON_MAP, var1)
			arg0:closeView()
		end, SFX_PANEL)
	end

	function arg0.scrollEntrance.onReturnItem(arg0, arg1)
		if arg0.exited then
			return
		end

		arg0.entranceOjbecDic[arg0 + 1] = nil

		removeOnButton(arg1)
	end

	arg0.scrollEntrance.onValueChanged:AddListener(function(arg0)
		arg0:UpdateJumpBtn()
	end)

	arg0.entrancePanel = arg0.rtMain:Find("map")
	arg0.entranceTitle = arg0.entrancePanel:Find("target_rect/title")
	arg0.targetContainer = arg0.entrancePanel:Find("target_rect/target_list/content")
	arg0.targetItemList = UIItemList.New(arg0.targetContainer, arg0.targetContainer:Find("item"))

	arg0.targetItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 > #arg0.achEntranceList[arg0.selectedIndex].config.normal_target
			local var1 = arg2:Find("bg")

			setActive(var1:Find("normal"), not var0)
			setActive(var1:Find("hidden"), var0)

			local var2 = arg0.targetList[arg1]
			local var3 = var2:IsAchieved()
			local var4 = not var0 or var3 or arg0.showHiddenDesc

			setText(var1:Find("desc"), var4 and var2.config.target_desc or "???")
			setText(var1:Find("progress"), var4 and var2:GetProgress() .. "/" .. var2:GetMaxProgress() or "")
			setActive(var1:Find("finish_mark/Image"), var3)

			local var5 = arg2:Find("pop")
			local var6 = var2:GetTriggers()
			local var7 = var4 and #var6 > 1

			if var7 then
				local var8 = var5
				local var9 = var5:Find("Text")
				local var10 = var8.childCount

				local function var11(arg0, arg1)
					local var0 = var6[arg0]

					setText(arg1, var0:GetDesc())
					setTextColor(arg1, var0:IsAchieved() and Color.New(0.368627450980392, 0.607843137254902, 1) or Color.New(0.474509803921569, 0.474509803921569, 0.474509803921569))
					setActive(arg1, true)
				end

				for iter0 = #var6, var10 - 1 do
					setActive(var8:GetChild(iter0), false)
				end

				for iter1 = var10, #var6 - 1 do
					cloneTplTo(var9, var8)
				end

				for iter2 = 0, #var6 - 1 do
					var11(iter2 + 1, var8:GetChild(iter2))
				end
			end

			triggerToggle(arg2, false)
			setToggleEnabled(arg2, var7)
			setActive(var1:Find("arrow"), var7)
		end
	end)

	arg0.achAwardRect = arg0.entrancePanel:Find("award_rect")
	arg0.achAchieveBtn = arg0.achAwardRect:Find("btn_achieve")
	arg0.overviewBtn = arg0.entrancePanel:Find("btn_overview")
	arg0.subviewAchAward = WorldAchAwardSubview.New(arg0._tf, arg0.event)

	arg0:bind(WorldAchAwardSubview.ShowDrop, function(arg0, arg1)
		arg0:emit(var0.ON_DROP, arg1)
	end)
end

function var0.onBackPressed(arg0)
	if arg0.subviewAchAward:isShowing() then
		arg0.subviewAchAward:ActionInvoke("Hide")
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.topToggles:Find("all"), function(arg0)
		if arg0 then
			arg0:UpdateEntranceFilter(false)
		end
	end, SFX_PANEL)
	setText(arg0.topToggles:Find("all/Text"), i18n("world_target_filter_tip1"))
	setText(arg0.topToggles:Find("all/Image/Text"), i18n("world_target_filter_tip1"))
	onToggle(arg0, arg0.topToggles:Find("unfinish"), function(arg0)
		if arg0 then
			arg0:UpdateEntranceFilter(true)
		end
	end, SFX_PANEL)
	setText(arg0.topToggles:Find("unfinish/Text"), i18n("world_target_filter_tip2"))
	setText(arg0.topToggles:Find("unfinish/Image/Text"), i18n("world_target_filter_tip2"))
	onButton(arg0, arg0.rtMain:Find("list_bg/jump_icon_left"), function()
		arg0:ScrollAndSelectEntrance(arg0:GetAwardIndex(false))
	end, SFX_PANEL)
	onButton(arg0, arg0.rtMain:Find("list_bg/jump_icon_right"), function()
		arg0:ScrollAndSelectEntrance(arg0:GetAwardIndex(true))
	end, SFX_PANEL)
	onButton(arg0, arg0.btnGetAll, function()
		local var0, var1 = nowWorld():GetFinishAchievements(arg0.achEntranceList)

		if #var0 > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_target_get_all"),
				onYes = function()
					arg0:emit(WorldCollectionMediator.ON_ACHIEVE_STAR, var0)
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("without any award")
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.achAchieveBtn, function()
		local var0, var1 = nowWorld():AnyUnachievedAchievement(arg0.entrance)

		if var0 then
			arg0:emit(WorldCollectionMediator.ON_ACHIEVE_STAR, {
				{
					id = arg0.entrance.id,
					star_list = {
						var1.star
					}
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.entrancePanel:Find("page_left"), function()
		arg0:ScrollAndSelectEntrance(arg0.selectedIndex - 1)
	end, SFX_PANEL)
	onButton(arg0, arg0.entrancePanel:Find("page_right"), function()
		arg0:ScrollAndSelectEntrance(arg0.selectedIndex + 1)
	end, SFX_PANEL)
	onButton(arg0, arg0.overviewBtn, function()
		arg0:emit(WorldCollectionMediator.ON_ACHIEVE_OVERVIEW)
	end, SFX_PANEL)
	triggerToggle(arg0.topToggles:Find("all"), true)
end

function var0.willExit(arg0)
	arg0.subviewAchAward:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.SetAchievementList(arg0, arg1)
	arg0.baseEntranceList = arg1
end

function var0.BuildEntranceScrollPos(arg0)
	arg0.entrancePos = {}
	arg0.entranceIndexDic = {}

	for iter0, iter1 in ipairs(arg0.achEntranceList) do
		table.insert(arg0.entrancePos, arg0.scrollEntrance:HeadIndexToValue(iter0 - 1))

		arg0.entranceIndexDic[iter1.id] = iter0

		if nowWorld():AnyUnachievedAchievement(iter1) then
			table.insert(arg0.achAwardIndexList, iter0)
		end
	end
end

function var0.UpdateEntranceFilter(arg0, arg1)
	if arg1 then
		arg0.achEntranceList = underscore.filter(arg0.baseEntranceList, function(arg0)
			local var0, var1, var2 = nowWorld():CountAchievements(arg0)

			return var2 > var0 + var1
		end)
	else
		arg0.achEntranceList = underscore.rest(arg0.baseEntranceList, 1)
	end

	arg0:UpdateGetAllAwardBtn()

	arg0.achAwardIndexList = {}
	arg0.entranceOjbecDic = {}

	arg0.scrollEntrance:SetTotalCount(#arg0.achEntranceList)
	arg0:BuildEntranceScrollPos()

	arg0.contextData.entranceId = defaultValue(arg0.contextData.entranceId, 0)

	local var0 = defaultValue(arg0.entranceIndexDic[arg0.contextData.entranceId], 1)

	arg0:ScrollAndSelectEntrance(var0)
end

function var0.UpdateGetAllAwardBtn(arg0)
	local var0, var1 = nowWorld():GetFinishAchievements(arg0.achEntranceList)
	local var2 = pg.gameset.world_target_obtain.key_value

	setActive(arg0.btnGetAll, var2 <= #var0)
end

function var0.FlushEntranceItem(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg0.entranceIndexDic[iter1.id]

		if not nowWorld():AnyUnachievedAchievement(arg0.achEntranceList[var0]) then
			if arg0.entranceOjbecDic[var0] then
				setActive(arg0.entranceOjbecDic[var0]:Find("icon/tip"), false)
			end

			table.removebyvalue(arg0.achAwardIndexList, var0)
		end
	end

	arg0:UpdateGetAllAwardBtn()
end

function var0.UpdateAchievement(arg0, arg1, arg2)
	if arg2 or arg0.selectedIndex ~= arg1 then
		arg1, arg0.selectedIndex = arg0.selectedIndex, arg1

		for iter0, iter1 in ipairs({
			arg1,
			arg0.selectedIndex
		}) do
			local var0 = arg0.entranceOjbecDic[iter1]

			if var0 then
				setActive(var0:Find("icon/select"), arg0.selectedIndex == iter1)
			end
		end

		arg0.entrance = arg0.achEntranceList[arg0.selectedIndex]

		arg0:FlushAchievement()
	end
end

function var0.GetAwardIndex(arg0, arg1)
	local var0 = arg0.entrancePos[#arg0.achEntranceList] - 1

	if arg1 then
		local var1 = arg0.scrollEntrance.value + var0

		for iter0 = 1, #arg0.achAwardIndexList do
			if var1 < arg0.entrancePos[arg0.achAwardIndexList[iter0]] then
				return arg0.achAwardIndexList[iter0]
			end
		end

		return nil
	else
		local var2 = arg0.scrollEntrance.value

		for iter1 = #arg0.achAwardIndexList, 1, -1 do
			if var2 > arg0.entrancePos[arg0.achAwardIndexList[iter1]] then
				return arg0.achAwardIndexList[iter1]
			end
		end

		return nil
	end
end

function var0.ScrollAndSelectEntrance(arg0, arg1)
	arg0:UpdateAchievement(arg1, true)

	local var0 = arg0.entrancePos[#arg0.achEntranceList] - 1

	arg0.scrollEntrance:ScrollTo(math.clamp(arg0.entrancePos[arg1] - var0 / 2, 0, 1))
end

function var0.UpdateJumpBtn(arg0)
	setActive(arg0.rtMain:Find("list_bg/jump_icon_left"), arg0:GetAwardIndex(false))
	setActive(arg0.rtMain:Find("list_bg/jump_icon_right"), arg0:GetAwardIndex(true))
end

function var0.FlushAchievement(arg0)
	arg0:UpdateJumpBtn()

	local var0 = nowWorld()

	arg0.showHiddenDesc = var0:IsNormalAchievementAchieved(arg0.entrance)
	arg0.targetList = var0:GetAchievements(arg0.entrance)

	arg0.targetItemList:align(#arg0.targetList)

	local var1 = arg0.entrance:GetBaseMap()

	GetImageSpriteFromAtlasAsync("world/targeticon/" .. var1.config.entrance_mapicon, "", arg0.entranceTitle)
	setText(arg0.entranceTitle:Find("name"), var1:GetName(arg0.entrance))
	setText(arg0.entranceTitle:Find("deco_id"), arg0.entrance.config.serial_number)

	local var2, var3, var4 = var0:CountAchievements(arg0.entrance)

	setText(arg0.entranceTitle:Find("progress_text"), var2 + var3 .. "/" .. var4)

	local var5, var6 = var0:AnyUnachievedAchievement(arg0.entrance)
	local var7 = arg0.achAwardRect:Find("award")

	if var6 then
		setActive(arg0.achAwardRect:Find("get_mask"), var5)
		setActive(arg0.achAwardRect:Find("got_mask"), false)
	else
		local var8 = arg0.entrance:GetAchievementAwards()

		var6 = var8[#var8]

		setActive(arg0.achAwardRect:Find("get_mask"), false)
		setActive(arg0.achAwardRect:Find("got_mask"), true)
	end

	updateDrop(var7, var6.drop)
	onButton(arg0, var7, function()
		arg0:showAchAwardPanel(arg0.entrance)
	end, SFX_PANEL)
	setText(arg0.achAwardRect:Find("star_count/Text"), var2 + var3 .. "/" .. var6.star)
	setActive(arg0.achAchieveBtn, var5)
	setActive(arg0.entrancePanel:Find("page_left"), arg0.selectedIndex > 1)
	setActive(arg0.entrancePanel:Find("page_right"), arg0.selectedIndex < #arg0.achEntranceList)
end

function var0.flushAchieveUpdate(arg0, arg1)
	arg0:FlushEntranceItem(arg1)
	arg0:FlushAchievement()
end

function var0.showAchAwardPanel(arg0, arg1)
	arg0.subviewAchAward:Load()
	arg0.subviewAchAward:ActionInvoke("Setup", arg1)
	arg0.subviewAchAward:ActionInvoke("Show")
end

return var0
