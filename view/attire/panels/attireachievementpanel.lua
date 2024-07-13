local var0_0 = class("AttireAchievementPanel", import("...base.BaseSubView"))

local function var1_0(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		arg0_2._go = arg0_1
		arg0_2.info = findTF(arg0_2._go, "info")
		arg0_2.empty = findTF(arg0_2._go, "empty")
		arg0_2.icon = findTF(arg0_2._go, "info/icon")
		arg0_2.selected = findTF(arg0_2._go, "info/selected")
		arg0_2.nameTxt = findTF(arg0_2._go, "info/label/Text")
		arg0_2.tags = {
			findTF(arg0_2._go, "info/tags/new"),
			findTF(arg0_2._go, "info/tags/e")
		}
		arg0_2.print5 = findTF(arg0_2._go, "prints/line5")
		arg0_2.print6 = findTF(arg0_2._go, "prints/line6")
	end

	function var0_1.Update(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_3.trophy = arg1_3

		if arg0_3.trophy then
			LoadImageSpriteAsync("medal/" .. arg1_3:getConfig("icon"), arg0_3.icon, true)
			setText(arg0_3.nameTxt, arg1_3:getConfig("name"))
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

	var1_1(var0_1)

	return var0_1
end

local function var2_0(arg0_5)
	local var0_5 = {}

	local function var1_5(arg0_6)
		arg0_6._tf = arg0_5
		arg0_6.uiList = UIItemList.New(arg0_6._tf:Find("list"), arg0_6._tf:Find("list/tpl"))
	end

	function var0_5.Update(arg0_7, arg1_7)
		arg0_7.uiList:make(function(arg0_8, arg1_8, arg2_8)
			if arg0_8 == UIItemList.EventUpdate then
				local var0_8 = arg1_7[arg1_8 + 1]
				local var1_8 = Trophy.New({
					id = var0_8
				})
				local var2_8 = findTF(arg2_8, "icon")

				LoadImageSpriteAsync("medal/s_" .. var1_8:getConfig("icon"), var2_8, true)
			end
		end)
		arg0_7.uiList:align(#arg1_7)
	end

	function var0_5.Dispose(arg0_9)
		return
	end

	var1_5(var0_5)

	return var0_5
end

function var0_0.getUIName(arg0_10)
	return "AttireAchievementUI"
end

function var0_0.OnInit(arg0_11)
	arg0_11.listPanel = arg0_11:findTF("list_panel")
	arg0_11.scolrect = arg0_11:findTF("scrollrect", arg0_11.listPanel):GetComponent("LScrollRect")
	arg0_11.totalCount = arg0_11:findTF("total_count/Text"):GetComponent(typeof(Text))
	arg0_11.selectedTxt = arg0_11.listPanel:Find("selected_bg/Text"):GetComponent(typeof(Text))
	arg0_11.toggle = arg0_11.listPanel:Find("toggle")

	function arg0_11.scolrect.onInitItem(arg0_12)
		arg0_11:OnInitItem(arg0_12)
	end

	function arg0_11.scolrect.onUpdateItem(arg0_13, arg1_13)
		arg0_11:OnUpdateItem(arg0_13, arg1_13)
	end

	arg0_11.confirmBtn = arg0_11:findTF("list_panel/confirm")

	onButton(arg0_11, arg0_11.confirmBtn, function()
		if #arg0_11.contextData.selectedMedalList == 0 and #arg0_11.playerVO.displayTrophyList == 0 then
			return
		end

		if #arg0_11.contextData.selectedMedalList == #arg0_11.playerVO.displayTrophyList and _.all(arg0_11.contextData.selectedMedalList, function(arg0_15)
			return table.contains(arg0_11.playerVO.displayTrophyList, arg0_15)
		end) then
			return
		end

		arg0_11.event:emit(AttireMediator.ON_CHANGE_MEDAL_DISPLAY, arg0_11.contextData.selectedMedalList)
	end, SFX_PANEL)

	arg0_11.descPanel = var2_0(arg0_11:findTF("desc_panel"))
	arg0_11.selectMaxLevel = true

	onToggle(arg0_11, arg0_11.toggle, function(arg0_16)
		arg0_11.selectMaxLevel = arg0_16

		arg0_11:Filter()
	end)

	arg0_11.cards = {}
	arg0_11.emptyPage = BaseEmptyListPage.New(arg0_11.listPanel, arg0_11.event)
end

function var0_0.UpdateselectedTxt(arg0_17)
	local var0_17 = arg0_17.contextData.selectedMedalList or {}

	arg0_17.selectedTxt.text = #var0_17 .. "/5"
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	local var0_18 = var1_0(arg1_18)

	arg0_18.cards[arg1_18] = var0_18

	onButton(arg0_18, var0_18._go, function()
		if not var0_18.trophy then
			return
		end

		local var0_19 = arg0_18.contextData.selectedMedalList or {}

		if #var0_19 < 5 and not table.contains(var0_19, var0_18.trophy.id) then
			table.insert(var0_19, var0_18.trophy.id)
			var0_18:UpdateSelected(true)
		else
			for iter0_19, iter1_19 in ipairs(var0_19) do
				if iter1_19 == var0_18.trophy.id then
					table.remove(var0_19, iter0_19)
					var0_18:UpdateSelected(false)

					break
				end
			end
		end

		arg0_18.contextData.selectedMedalList = var0_19

		arg0_18.descPanel:Update(arg0_18.contextData.selectedMedalList)
		arg0_18:UpdateselectedTxt()
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.cards[arg2_20]

	if not var0_20 then
		arg0_20:OnInitItem(arg2_20)

		var0_20 = arg0_20.cards[arg2_20]
	end

	local var1_20 = arg0_20.displayVOs[arg1_20 + 1]
	local var2_20 = arg1_20 < arg0_20.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount

	if var1_20 then
		local var3_20 = table.contains(arg0_20.contextData.selectedMedalList, var1_20.id)

		var0_20:Update(var1_20, var3_20, var2_20)
	else
		var0_20:Update(var1_20, false, var2_20)
	end
end

function var0_0.Update(arg0_21, arg1_21, arg2_21)
	arg0_21.playerVO = arg2_21
	arg0_21.trophys = arg1_21.trophys
	arg0_21.contextData.selectedMedalList = Clone(arg0_21.playerVO.displayTrophyList) or {}

	arg0_21.descPanel:Update(arg0_21.contextData.selectedMedalList)
	arg0_21:UpdateselectedTxt()
	arg0_21:Filter()

	arg0_21.totalCount.text = arg0_21:getTotalCnt()

	local var0_21 = arg0_21:getTotalCnt()

	if var0_21 <= 0 then
		arg0_21.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0_21.emptyPage:ExecuteAction("SetEmptyText", i18n("decoration_medal_placeholder"))
		arg0_21.emptyPage:ExecuteAction("SetPosY", {
			x = 0,
			y = 22
		})
		setActive(arg0_21:findTF("scrollrect", arg0_21.listPanel), false)
	elseif var0_21 > 0 and arg0_21.emptyPage:GetLoaded() then
		arg0_21.emptyPage:ExecuteAction("ShowOrHide", false)
		setActive(arg0_21:findTF("scrollrect", arg0_21.listPanel), true)
	end
end

function var0_0.getTotalCnt(arg0_22)
	local var0_22 = 0

	for iter0_22, iter1_22 in pairs(arg0_22.trophys) do
		if iter1_22:isClaimed() and not iter1_22:isHide() then
			var0_22 = var0_22 + 1
		end
	end

	return var0_22
end

function var0_0.Filter(arg0_23)
	arg0_23.displayVOs = {}

	local function var0_23(arg0_24)
		local var0_24 = arg0_23.trophys[arg0_24:getConfig("next")]

		return var0_24 and var0_24:isClaimed() and not var0_24:isHide()
	end

	for iter0_23, iter1_23 in pairs(arg0_23.trophys) do
		if iter1_23:isClaimed() and not iter1_23:isHide() and (not arg0_23.selectMaxLevel or arg0_23.selectMaxLevel and not var0_23(iter1_23)) then
			table.insert(arg0_23.displayVOs, iter1_23)
		end
	end

	table.sort(arg0_23.displayVOs, function(arg0_25, arg1_25)
		return arg0_25.id < arg1_25.id
	end)

	local var1_23 = arg0_23.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount
	local var2_23 = var1_23 - #arg0_23.displayVOs % var1_23

	if var2_23 == var1_23 then
		var2_23 = 0
	end

	local var3_23 = var1_23 * arg0_23:GetColumn()

	if var3_23 > #arg0_23.displayVOs then
		var2_23 = var3_23 - #arg0_23.displayVOs
	end

	for iter2_23 = 1, var2_23 do
		table.insert(arg0_23.displayVOs, false)
	end

	arg0_23.scolrect:SetTotalCount(#arg0_23.displayVOs, -1)
end

function var0_0.GetColumn(arg0_26)
	return 2
end

function var0_0.OnDestroy(arg0_27)
	arg0_27.descPanel:Dispose()

	if arg0_27.emptyPage then
		arg0_27.emptyPage:Destroy()

		arg0_27.emptyPage = nil
	end
end

return var0_0
