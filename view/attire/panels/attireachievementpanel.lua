local var0_0 = class("AttireAchievementPanel", import("...base.BaseSubView"))

local function var1_0(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		arg0_2._go = arg0_1
		arg0_2._tf = arg0_2._go.transform
		arg0_2.info = arg0_2._tf:Find("info")
		arg0_2.empty = arg0_2._tf:Find("empty")
		arg0_2.icon = arg0_2._tf:Find("info/icon")
		arg0_2.now = arg0_2._tf:Find("info/now")
		arg0_2.selected = arg0_2._tf:Find("info/selected")
		arg0_2.nameTxt = arg0_2._tf:Find("info/label/Text")
		arg0_2.tags = {
			arg0_2._tf:Find("info/tags/new"),
			arg0_2._tf:Find("info/tags/e")
		}
		arg0_2.print5 = arg0_2._tf:Find("prints/line5")
		arg0_2.print6 = arg0_2._tf:Find("prints/line6")
	end

	function var0_1.Update(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_3.trophy = arg1_3

		if arg0_3.trophy then
			local var0_3 = arg0_3.trophy:isLoverLetter()

			setActive(arg0_3.icon, not var0_3)
			setActive(arg0_3.now, var0_3)

			if var0_3 then
				setLoveLetterMedal(arg0_3.now:Find("medal"), arg0_3.trophy)
				setText(arg0_3.nameTxt, arg1_3:getName())
			else
				LoadImageSpriteAsync("medal/" .. arg1_3:getConfig("icon"), arg0_3.icon, true)
				setText(arg0_3.nameTxt, arg1_3:getConfig("name"))
			end

			setActive(arg0_3.tags[1], arg1_3:isNew())
			arg0_3:UpdateSelected(arg2_3)
		end

		setActive(arg0_3.print5, not arg3_3)
		setActive(arg0_3.print6, not arg3_3)
		setActive(arg0_3.info, arg0_3.trophy)
		setActive(arg0_3.empty, not arg0_3.trophy)
	end

	function var0_1.UpdateSelected(arg0_4, arg1_4)
		setActive(arg0_4.selected, arg1_4)
		setActive(arg0_4.tags[2], arg1_4)
	end

	function var0_1.Dispose(arg0_5)
		if arg0_5.now:Find("medal").childCount > 0 then
			returnLoveLetterMedal(arg0_5.now:Find("medal"):GetChild(0))
		end
	end

	var1_1(var0_1)

	return var0_1
end

local function var2_0(arg0_6)
	local var0_6 = {}

	local function var1_6(arg0_7)
		arg0_7._tf = arg0_6
		arg0_7.uiList = UIItemList.New(arg0_7._tf:Find("list"), arg0_7._tf:Find("list/tpl"))
	end

	function var0_6.Update(arg0_8, arg1_8)
		arg0_8.uiList:make(function(arg0_9, arg1_9, arg2_9)
			if arg0_9 == UIItemList.EventUpdate then
				local var0_9 = arg1_8[arg1_9 + 1]
				local var1_9 = var0_9 > 1000000000 and LoveLetterTrophy.New({
					id = var0_9
				}) or Trophy.New({
					id = var0_9
				})
				local var2_9 = findTF(arg2_9, "icon")
				local var3_9 = arg2_9:Find("now")
				local var4_9 = var1_9:isLoverLetter()

				setActive(var2_9, not var4_9)
				setActive(var3_9, var4_9)

				if var4_9 then
					setLoveLetterMedal(var3_9:Find("medal"), var1_9)
				else
					LoadImageSpriteAsync("medal/s_" .. var1_9:getConfig("icon"), var2_9, true)
				end
			end
		end)
		arg0_8.uiList:align(#arg1_8)
	end

	function var0_6.Dispose(arg0_10)
		arg0_10.uiList:each(function(arg0_11, arg1_11)
			if arg1_11:Find("now/medal").childCount > 0 then
				returnLoveLetterMedal(arg1_11:Find("now/medal"):GetChild(0))
			end
		end)
	end

	var1_6(var0_6)

	return var0_6
end

function var0_0.getUIName(arg0_12)
	return "AttireAchievementUI"
end

function var0_0.OnInit(arg0_13)
	arg0_13.listPanel = arg0_13._tf:Find("list_panel")
	arg0_13.scolrect = arg0_13.listPanel:Find("scrollrect/content"):GetComponent("LScrollRect")
	arg0_13.totalCount = arg0_13._tf:Find("total_count/Text"):GetComponent(typeof(Text))
	arg0_13.selectedTxt = arg0_13.listPanel:Find("selected_bg/Text"):GetComponent(typeof(Text))
	arg0_13.toggle = arg0_13.listPanel:Find("toggle")

	function arg0_13.scolrect.onInitItem(arg0_14)
		arg0_13:OnInitItem(arg0_14)
	end

	function arg0_13.scolrect.onUpdateItem(arg0_15, arg1_15)
		arg0_13:OnUpdateItem(arg0_15, arg1_15)
	end

	arg0_13.confirmBtn = arg0_13._tf:Find("list_panel/confirm")

	onButton(arg0_13, arg0_13.confirmBtn, function()
		if #arg0_13.contextData.selectedMedalList == #arg0_13.playerVO.displayTrophyList and underscore.all(underscore.keys(arg0_13.contextData.selectedMedalList), function(arg0_17)
			return arg0_13.contextData.selectedMedalList[arg0_17] == arg0_13.playerVO.displayTrophyList[arg0_17]
		end) then
			return
		end

		arg0_13.event:emit(AttireMediator.ON_CHANGE_MEDAL_DISPLAY, arg0_13.contextData.selectedMedalList)
	end, SFX_PANEL)

	arg0_13.descPanel = var2_0(arg0_13._tf:Find("desc_panel"))
	arg0_13.selectMaxLevel = true

	onToggle(arg0_13, arg0_13.toggle, function(arg0_18)
		arg0_13.selectMaxLevel = arg0_18

		arg0_13:Filter()
	end)

	arg0_13.cards = {}
	arg0_13.emptyPage = BaseEmptyListPage.New(arg0_13.listPanel, arg0_13.event)
end

function var0_0.UpdateselectedTxt(arg0_19)
	local var0_19 = arg0_19.contextData.selectedMedalList or {}

	arg0_19.selectedTxt.text = #var0_19 .. "/5"
end

function var0_0.OnInitItem(arg0_20, arg1_20)
	local var0_20 = var1_0(arg1_20)

	arg0_20.cards[arg1_20] = var0_20

	onButton(arg0_20, var0_20._go, function()
		if not var0_20.trophy then
			return
		end

		local var0_21 = arg0_20.contextData.selectedMedalList or {}
		local var1_21 = var0_20.trophy.id

		if table.contains(var0_21, var1_21) then
			table.removebyvalue(var0_21, var1_21)
			var0_20:UpdateSelected(false)
		elseif #var0_21 >= 5 then
			return
		else
			table.insert(var0_21, var1_21)
			var0_20:UpdateSelected(true)
		end

		arg0_20.contextData.selectedMedalList = var0_21

		arg0_20.descPanel:Update(arg0_20.contextData.selectedMedalList)
		arg0_20:UpdateselectedTxt()
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22.displayVOs[arg1_22 + 1]
	local var2_22 = arg1_22 < arg0_22.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount

	if var1_22 then
		local var3_22 = table.contains(arg0_22.contextData.selectedMedalList, var1_22.id)

		var0_22:Update(var1_22, var3_22, var2_22)
	else
		var0_22:Update(var1_22, false, var2_22)
	end
end

function var0_0.Update(arg0_23, arg1_23, arg2_23)
	arg0_23.playerVO = arg2_23
	arg0_23.trophys = arg1_23.trophys

	for iter0_23, iter1_23 in ipairs(arg1_23.loveTrophys) do
		arg0_23.trophys[iter1_23.id] = iter1_23
	end

	arg0_23.contextData.selectedMedalList = Clone(arg0_23.playerVO.displayTrophyList) or {}

	arg0_23.descPanel:Update(arg0_23.contextData.selectedMedalList)
	arg0_23:UpdateselectedTxt()
	arg0_23:Filter()

	arg0_23.totalCount.text = arg0_23:getTotalCnt()

	local var0_23 = arg0_23:getTotalCnt()

	if var0_23 <= 0 then
		arg0_23.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0_23.emptyPage:ExecuteAction("SetEmptyText", i18n("decoration_medal_placeholder"))
		arg0_23.emptyPage:ExecuteAction("SetPosY", {
			x = 0,
			y = 22
		})
		setActive(arg0_23.listPanel:Find("scrollrect"), false)
	elseif var0_23 > 0 and arg0_23.emptyPage:GetLoaded() then
		arg0_23.emptyPage:ExecuteAction("ShowOrHide", false)
		setActive(arg0_23.listPanel:Find("scrollrect"), true)
	end
end

function var0_0.getTotalCnt(arg0_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in pairs(arg0_24.trophys) do
		if iter1_24:isClaimed() and not iter1_24:isHide() then
			var0_24 = var0_24 + 1
		end
	end

	return var0_24
end

function var0_0.Filter(arg0_25)
	arg0_25.displayVOs = {}

	local function var0_25(arg0_26)
		local var0_26 = arg0_25.trophys[arg0_26:getConfig("next")]

		return var0_26 and var0_26:isClaimed() and not var0_26:isHide()
	end

	for iter0_25, iter1_25 in pairs(arg0_25.trophys) do
		if iter1_25:isClaimed() and not iter1_25:isHide() and (not arg0_25.selectMaxLevel or not var0_25(iter1_25)) then
			table.insert(arg0_25.displayVOs, iter1_25)
		end
	end

	table.sort(arg0_25.displayVOs, CompareFuncs({
		function(arg0_27)
			return arg0_27.id
		end
	}))

	local var1_25 = arg0_25.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount
	local var2_25 = var1_25 - #arg0_25.displayVOs % var1_25

	if var2_25 == var1_25 then
		var2_25 = 0
	end

	local var3_25 = var1_25 * arg0_25:GetColumn()

	if var3_25 > #arg0_25.displayVOs then
		var2_25 = var3_25 - #arg0_25.displayVOs
	end

	for iter2_25 = 1, var2_25 do
		table.insert(arg0_25.displayVOs, false)
	end

	arg0_25.scolrect:SetTotalCount(#arg0_25.displayVOs, -1)
end

function var0_0.GetColumn(arg0_28)
	return 2
end

function var0_0.OnDestroy(arg0_29)
	arg0_29.descPanel:Dispose()

	if arg0_29.emptyPage then
		arg0_29.emptyPage:Destroy()

		arg0_29.emptyPage = nil
	end

	if arg0_29.cards then
		for iter0_29, iter1_29 in pairs(arg0_29.cards) do
			iter1_29:Dispose()
		end

		arg0_29.cards = nil
	end
end

return var0_0
