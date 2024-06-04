local var0 = class("AttireAchievementPanel", import("...base.BaseSubView"))

local function var1(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0._go = arg0
		arg0.info = findTF(arg0._go, "info")
		arg0.empty = findTF(arg0._go, "empty")
		arg0.icon = findTF(arg0._go, "info/icon")
		arg0.selected = findTF(arg0._go, "info/selected")
		arg0.nameTxt = findTF(arg0._go, "info/label/Text")
		arg0.tags = {
			findTF(arg0._go, "info/tags/new"),
			findTF(arg0._go, "info/tags/e")
		}
		arg0.print5 = findTF(arg0._go, "prints/line5")
		arg0.print6 = findTF(arg0._go, "prints/line6")
	end

	function var0.Update(arg0, arg1, arg2, arg3)
		arg0.trophy = arg1

		if arg0.trophy then
			LoadImageSpriteAsync("medal/" .. arg1:getConfig("icon"), arg0.icon, true)
			setText(arg0.nameTxt, arg1:getConfig("name"))
			setActive(arg0.tags[1], arg1:isNew())
			arg0:UpdateSelected(arg2)
		end

		setActive(arg0.print5, not arg3)
		setActive(arg0.print6, not arg3)
		setActive(arg0.info, arg0.trophy)
		setActive(arg0.empty, not arg0.trophy)
	end

	function var0.UpdateSelected(arg0, arg1)
		setActive(arg0.selected, arg1)
		setActive(arg0.tags[2], arg1)
	end

	var1(var0)

	return var0
end

local function var2(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0._tf = arg0
		arg0.uiList = UIItemList.New(arg0._tf:Find("list"), arg0._tf:Find("list/tpl"))
	end

	function var0.Update(arg0, arg1)
		arg0.uiList:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = arg1[arg1 + 1]
				local var1 = Trophy.New({
					id = var0
				})
				local var2 = findTF(arg2, "icon")

				LoadImageSpriteAsync("medal/s_" .. var1:getConfig("icon"), var2, true)
			end
		end)
		arg0.uiList:align(#arg1)
	end

	function var0.Dispose(arg0)
		return
	end

	var1(var0)

	return var0
end

function var0.getUIName(arg0)
	return "AttireAchievementUI"
end

function var0.OnInit(arg0)
	arg0.listPanel = arg0:findTF("list_panel")
	arg0.scolrect = arg0:findTF("scrollrect", arg0.listPanel):GetComponent("LScrollRect")
	arg0.totalCount = arg0:findTF("total_count/Text"):GetComponent(typeof(Text))
	arg0.selectedTxt = arg0.listPanel:Find("selected_bg/Text"):GetComponent(typeof(Text))
	arg0.toggle = arg0.listPanel:Find("toggle")

	function arg0.scolrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scolrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0.confirmBtn = arg0:findTF("list_panel/confirm")

	onButton(arg0, arg0.confirmBtn, function()
		if #arg0.contextData.selectedMedalList == 0 and #arg0.playerVO.displayTrophyList == 0 then
			return
		end

		if #arg0.contextData.selectedMedalList == #arg0.playerVO.displayTrophyList and _.all(arg0.contextData.selectedMedalList, function(arg0)
			return table.contains(arg0.playerVO.displayTrophyList, arg0)
		end) then
			return
		end

		arg0.event:emit(AttireMediator.ON_CHANGE_MEDAL_DISPLAY, arg0.contextData.selectedMedalList)
	end, SFX_PANEL)

	arg0.descPanel = var2(arg0:findTF("desc_panel"))
	arg0.selectMaxLevel = true

	onToggle(arg0, arg0.toggle, function(arg0)
		arg0.selectMaxLevel = arg0

		arg0:Filter()
	end)

	arg0.cards = {}
	arg0.emptyPage = BaseEmptyListPage.New(arg0.listPanel, arg0.event)
end

function var0.UpdateselectedTxt(arg0)
	local var0 = arg0.contextData.selectedMedalList or {}

	arg0.selectedTxt.text = #var0 .. "/5"
end

function var0.OnInitItem(arg0, arg1)
	local var0 = var1(arg1)

	arg0.cards[arg1] = var0

	onButton(arg0, var0._go, function()
		if not var0.trophy then
			return
		end

		local var0 = arg0.contextData.selectedMedalList or {}

		if #var0 < 5 and not table.contains(var0, var0.trophy.id) then
			table.insert(var0, var0.trophy.id)
			var0:UpdateSelected(true)
		else
			for iter0, iter1 in ipairs(var0) do
				if iter1 == var0.trophy.id then
					table.remove(var0, iter0)
					var0:UpdateSelected(false)

					break
				end
			end
		end

		arg0.contextData.selectedMedalList = var0

		arg0.descPanel:Update(arg0.contextData.selectedMedalList)
		arg0:UpdateselectedTxt()
	end, SFX_PANEL)
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displayVOs[arg1 + 1]
	local var2 = arg1 < arg0.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount

	if var1 then
		local var3 = table.contains(arg0.contextData.selectedMedalList, var1.id)

		var0:Update(var1, var3, var2)
	else
		var0:Update(var1, false, var2)
	end
end

function var0.Update(arg0, arg1, arg2)
	arg0.playerVO = arg2
	arg0.trophys = arg1.trophys
	arg0.contextData.selectedMedalList = Clone(arg0.playerVO.displayTrophyList) or {}

	arg0.descPanel:Update(arg0.contextData.selectedMedalList)
	arg0:UpdateselectedTxt()
	arg0:Filter()

	arg0.totalCount.text = arg0:getTotalCnt()

	local var0 = arg0:getTotalCnt()

	if var0 <= 0 then
		arg0.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0.emptyPage:ExecuteAction("SetEmptyText", i18n("decoration_medal_placeholder"))
		arg0.emptyPage:ExecuteAction("SetPosY", {
			x = 0,
			y = 22
		})
		setActive(arg0:findTF("scrollrect", arg0.listPanel), false)
	elseif var0 > 0 and arg0.emptyPage:GetLoaded() then
		arg0.emptyPage:ExecuteAction("ShowOrHide", false)
		setActive(arg0:findTF("scrollrect", arg0.listPanel), true)
	end
end

function var0.getTotalCnt(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.trophys) do
		if iter1:isClaimed() and not iter1:isHide() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.Filter(arg0)
	arg0.displayVOs = {}

	local function var0(arg0)
		local var0 = arg0.trophys[arg0:getConfig("next")]

		return var0 and var0:isClaimed() and not var0:isHide()
	end

	for iter0, iter1 in pairs(arg0.trophys) do
		if iter1:isClaimed() and not iter1:isHide() and (not arg0.selectMaxLevel or arg0.selectMaxLevel and not var0(iter1)) then
			table.insert(arg0.displayVOs, iter1)
		end
	end

	table.sort(arg0.displayVOs, function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	local var1 = arg0.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount
	local var2 = var1 - #arg0.displayVOs % var1

	if var2 == var1 then
		var2 = 0
	end

	local var3 = var1 * arg0:GetColumn()

	if var3 > #arg0.displayVOs then
		var2 = var3 - #arg0.displayVOs
	end

	for iter2 = 1, var2 do
		table.insert(arg0.displayVOs, false)
	end

	arg0.scolrect:SetTotalCount(#arg0.displayVOs, -1)
end

function var0.GetColumn(arg0)
	return 2
end

function var0.OnDestroy(arg0)
	arg0.descPanel:Dispose()

	if arg0.emptyPage then
		arg0.emptyPage:Destroy()

		arg0.emptyPage = nil
	end
end

return var0
