local var0 = class("CommanderCatDockPage", import("view.base.BaseSubView"))

var0.ON_SORT = "CommanderCatDockPage:ON_SORT"

function var0.getUIName(arg0)
	return "CommanderCatDockui"
end

function var0.OnLoaded(arg0)
	arg0.scrollRect = arg0._tf:Find("frame"):GetComponent("LScrollRect")
	arg0.reserveBtn = arg0._tf:Find("box/reserve_btn")
	arg0.reserveTxt = arg0.reserveBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.reserveTip = arg0.reserveBtn:Find("free")
	arg0.homeBtn = arg0._tf:Find("box/home")
	arg0.homeTxt = arg0.homeBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.homeTip = arg0.homeBtn:Find("tip")
	arg0.boxesBtn = arg0._tf:Find("box/boxes_btn")
	arg0.boxesTxt = arg0.boxesBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.boxesTip = arg0.boxesBtn:Find("tip")
	arg0.capacityTxt = arg0._tf:Find("box/capcity/Text"):GetComponent(typeof(Text))
	arg0.sortBtn = arg0._tf:Find("top/sort_btn")
	arg0.sortIdTxt = arg0.sortBtn:Find("id")
	arg0.sortLvTxt = arg0.sortBtn:Find("Level")
	arg0.sortRarityTxt = arg0.sortBtn:Find("Rarity")
	arg0.ascBtn = arg0._tf:Find("top/asc_btn")
	arg0.ascTr = arg0.ascBtn:Find("asc")
	arg0.descTr = arg0.ascBtn:Find("desc")
	arg0.selectedTr = arg0._tf:Find("bottom")
	arg0.btnsTr = arg0._tf:Find("box")
	arg0.selectedNumTxt = arg0._tf:Find("bottom/value/Text"):GetComponent(typeof(Text))
	arg0.selectedBtn = arg0._tf:Find("bottom/select_btn")
	arg0.cancelBtn = arg0._tf:Find("bottom/cancel_btn")
	arg0.reservePanel = CommanderReservePage.New(arg0._tf.parent, arg0.event, arg0.contextData)
	arg0.boxesPanel = CommanderBoxesPage.New(arg0._tf.parent, arg0.event, arg0.contextData)
	arg0.indexPanel = CommanderIndexPage.New(arg0._tf, arg0.event)
	arg0.catterySettlementPage = CatterySettlementPage.New(arg0._tf, arg0.event)
end

function var0.RegisterEvent(arg0)
	arg0:bind(var0.ON_SORT, function(arg0)
		arg0:OnSort()
	end)
	arg0:bind(CommanderCatScene.EVENT_NEXT_ONE, function(arg0, arg1)
		arg0:OnNextOn(arg1, 1)
	end)
	arg0:bind(CommanderCatScene.EVENT_PREV_ONE, function(arg0, arg1)
		arg0:OnNextOn(arg1, -1)
	end)
	arg0:bind(CommanderCatScene.MSG_UPDATE, function(arg0)
		arg0:UpdateCommanders(true)
		arg0:UpdateCapacity()
	end)
	arg0:bind(CommanderCatScene.MSG_HOME_TIP, function(arg0)
		arg0:UpdateHome()
	end)
	arg0:bind(CommanderCatScene.MSG_BUILD, function()
		arg0:UpdateBoxes()
	end)
	arg0:bind(CommanderCatScene.MSG_RESERVE_BOX, function()
		arg0:UpdateReserve()
	end)
	arg0:bind(CommanderCatScene.EVENT_FOLD, function(arg0, arg1)
		if arg1 then
			LeanTween.moveX(rtf(arg0._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0._tf), -423, 0.5)
		end
	end)
end

function var0.OnNextOn(arg0, arg1, arg2)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1.id == arg1 then
			var0 = iter0

			break
		end
	end

	local var1 = var0 + arg2

	if var1 <= 0 or var1 > #arg0.displays then
		return
	end

	local var2 = false
	local var3 = arg0.displays[var1]

	for iter2, iter3 in pairs(arg0.cards) do
		if iter3.commanderVO and iter3.commanderVO.id == var3.id then
			var2 = true

			triggerButton(iter3.infoTF)

			break
		end
	end

	if not var2 then
		arg0:emit(CommanderCatScene.EVENT_SELECTED, var3)
	end
end

function var0.OnSort(arg0)
	local var0 = arg0.sortData.asc

	arg0.sortData = arg0.indexPanel.data
	arg0.sortData.asc = var0

	arg0:UpdateSortTxt()
	arg0:UpdateCommanders(false)
	setActive(arg0.ascTr, arg0.sortData.asc)
	setActive(arg0.descTr, not arg0.sortData.asc)
end

function var0.UpdateSortTxt(arg0)
	setActive(arg0.sortIdTxt, arg0.sortData.sortData == "id")
	setActive(arg0.sortLvTxt, arg0.sortData.sortData == "Level")
	setActive(arg0.sortRarityTxt, arg0.sortData.sortData == "Rarity")
end

function var0.OnInit(arg0)
	arg0.onCommander = arg0.contextData.onCommander or function(arg0, arg1, arg2, arg3)
		return true
	end
	arg0.onSelected = arg0.contextData.onSelected or function(arg0, arg1)
		arg1()
	end
	arg0.onQuit = arg0.contextData.onQuit or function(arg0)
		return
	end

	arg0:RegisterEvent()

	arg0.sortData = arg0.contextData.sortData or {
		asc = false,
		sortData = "Level",
		nationData = {},
		rarityData = {}
	}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	onButton(arg0, arg0.reserveBtn, function()
		arg0.reservePanel:ExecuteAction("Update")
	end, SFX_PANEL)
	onButton(arg0, arg0.boxesBtn, function()
		arg0.boxesPanel:ExecuteAction("Update")
	end, SFX_PANEL)
	onButton(arg0, arg0.ascBtn, function()
		arg0.sortData.asc = not arg0.sortData.asc

		setActive(arg0.ascTr, arg0.sortData.asc)
		setActive(arg0.descTr, not arg0.sortData.asc)
		arg0:UpdateCommanders(false)
	end, SFX_PANEL)
	setActive(arg0.ascTr, arg0.sortData.asc)
	setActive(arg0.descTr, not arg0.sortData.asc)
	onButton(arg0, arg0.sortBtn, function()
		arg0.indexPanel:ExecuteAction("Show", arg0.sortData)
	end, SFX_PANEL)
	onButton(arg0, arg0.selectedBtn, function()
		local var0 = arg0.contextData.minCount or 1

		if var0 > #arg0.selectedList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_select_min_cnt", var0))

			return
		end

		arg0.onSelected(arg0.selectedList, function()
			arg0:emit(CommanderCatScene.EVENT_BACK)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:emit(CommanderCatScene.EVENT_BACK)
	end, SFX_PANEL)

	if not LOCK_CATTERY then
		onButton(arg0, arg0.homeBtn, function()
			arg0:emit(CommanderCatMediator.OPEN_HOME)
		end, SFX_PANEL)
	else
		setActive(arg0.homeBtn, false)
	end

	arg0:Flush()
end

function var0.Flush(arg0)
	arg0.cards = {}
	arg0.selectedList = arg0.contextData.selectedIds or {}
	arg0.previewCommander = arg0.contextData.activeCommander
	arg0.previewCommanderId = arg0.previewCommander and arg0.previewCommander.id
	arg0.selectedId = arg0.previewCommanderId or arg0.contextData.selectedId

	arg0:UpdateCommanders(true)
	arg0:UpdateBoxes()
	arg0:UpdateReserve()
	arg0:UpdateCapacity()
	arg0:UpdateHome()
	arg0:TryPlayStory()
	arg0:DisplayCatterySettlement()
	arg0:UpdateStyle()
	arg0:UpdateSortTxt()
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	CommanderCatUtil.SetActive(arg0._tf, true)
end

function var0.Hide(arg0)
	CommanderCatUtil.SetActive(arg0._tf, false)
end

function var0.UpdateStyle(arg0)
	setActive(arg0.selectedTr, arg0.contextData.mode == CommanderCatScene.MODE_SELECT)
	setActive(arg0.btnsTr, arg0.contextData.mode == CommanderCatScene.MODE_VIEW)

	if arg0.contextData.mode == CommanderCatScene.MODE_SELECT then
		arg0:UpdateSelectedTxt()
	end
end

function var0.TryPlayStory(arg0)
	if arg0.contextData.fromMain then
		pg.SystemGuideMgr.GetInstance():PlayCommander()
	end
end

function var0.DisplayCatterySettlement(arg0)
	local var0 = getProxy(CommanderProxy):GetCommanderHome()
	local var1 = arg0.contextData.fromMediatorName == NewMainMediator.__cname
	local var2 = pg.NewStoryMgr.GetInstance():IsRunning() or pg.NewGuideMgr.GetInstance():IsBusy()

	if var0 and var0:ShouldSettleCattery() and var1 and not var2 then
		local var3 = Clone(var0)

		arg0.catterySettlementPage:ExecuteAction("Show", var3)
	end

	pg.m02:sendNotification(GAME.OPEN_OR_CLOSE_CATTERY, {
		open = true
	})
end

function var0.UpdateHome(arg0)
	local var0 = getProxy(CommanderProxy)

	setActive(arg0.homeTip, var0:AnyCatteryExistOP() or var0:AnyCatteryCanUse())

	local var1 = var0:GetCommanderHome()
	local var2 = ""

	if var1 then
		var2 = var1:GetExistCommanderCattertCnt() .. "/" .. var1:GetMaxCatteryCnt()
	end

	arg0.homeTxt.text = var2
end

function var0.UpdateCapacity(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = table.getCount(getProxy(CommanderProxy):getRawData())

	arg0.capacityTxt.text = var1 .. "/" .. var0.commanderBagMax
end

function var0.UpdateReserve(arg0)
	local var0 = getProxy(CommanderProxy):getBoxUseCnt()

	arg0.reserveTxt.text = CommanderConst.MAX_GETBOX_CNT - var0 .. "/" .. CommanderConst.MAX_GETBOX_CNT

	setActive(arg0.reserveTip, var0 == 0)
end

function var0.UpdateBoxes(arg0)
	local var0 = getProxy(CommanderProxy):getBoxes()
	local var1 = _.select(var0, function(arg0)
		return arg0:getState() == CommanderBox.STATE_FINISHED
	end)

	arg0.boxesTxt.text = #var1 .. "/" .. #var0

	setActive(arg0.boxesTip, getProxy(CommanderProxy):ShouldTipBox())
end

function var0.OnInitItem(arg0, arg1)
	local var0 = arg0:NewCard(arg1)

	onButton(arg0, var0.infoTF, function()
		if not var0.commanderVO then
			return
		end

		if arg0.contextData.mode == CommanderCatScene.MODE_SELECT then
			local var0 = #arg0.selectedList

			arg0:OnCheckBefore(var0.commanderVO)
			arg0:Check(var0.commanderVO)
			arg0:OnCheckAfter(var0.commanderVO, var0 > #arg0.selectedList)
		else
			arg0.selectedList = {}

			for iter0, iter1 in pairs(arg0.cards) do
				iter1:UpdateSelected(arg0.selectedList)
			end

			table.insert(arg0.selectedList, var0.commanderVO.id)
			var0:UpdateSelected(arg0.selectedList, not defaultValue(arg0.sortData.displayCustomName, true))

			arg0.selectedId = var0.commanderVO.id

			arg0:emit(CommanderCatScene.EVENT_SELECTED, var0.commanderVO, true)
		end
	end, SFX_PANEL)
	onButton(arg0, var0.quitTF, function()
		if not var0.commanderVO then
			return
		end

		if var0.commanderVO.id == 0 then
			arg0.onQuit(function()
				arg0:emit(CommanderCatScene.EVENT_BACK)
			end)
		end
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnCheckBefore(arg0, arg1)
	if arg0.previewCommander and arg0.contextData.maxCount > 1 then
		arg0:emit(CommanderCatScene.EVENT_SELECTED, arg0.previewCommander, true)
	else
		arg0:emit(CommanderCatScene.EVENT_SELECTED, arg1, true)

		if arg0.previewCommander then
			arg0:emit(CommanderCatScene.EVENT_PREVIEW_ADDITION, arg0.previewCommander, true)
		else
			arg0:emit(CommanderCatScene.EVENT_PREVIEW_ADDITION, arg1, true)
		end
	end
end

function var0.OnCheckAfter(arg0, arg1, arg2)
	if arg0.previewCommander and arg0.contextData.maxCount > 1 then
		arg0:emit(CommanderCatScene.EVENT_PREVIEW_PLAY, arg0.selectedList, arg2)
	end
end

function var0.Check(arg0, arg1)
	local var0 = arg0.contextData.maxCount or table.getCount(arg0.commanderList)

	if table.contains(arg0.selectedList, arg1.id) and var0 == 1 then
		arg0:UpdateSelected()

		return
	elseif table.contains(arg0.selectedList, arg1.id) then
		local var1 = table.indexof(arg0.selectedList, arg1.id)

		table.remove(arg0.selectedList, var1)
		arg0:UpdateSelected()

		return
	end

	local function var2()
		for iter0, iter1 in ipairs(arg0.selectedList) do
			if iter1 == arg1.id then
				table.remove(arg0.selectedList, iter0)

				break
			end
		end
	end

	local var3, var4 = arg0.onCommander(arg1, function()
		var2()
		arg0:UpdateSelected()
	end, function()
		var2()
		arg0:UpdateCommanders(true)

		for iter0, iter1 in ipairs(arg0.commanderList or {}) do
			if iter1.id == arg1.id then
				arg0:Check(iter1)
			end
		end

		arg0:UpdateSelected()
	end, arg0)

	if not var3 then
		if var4 then
			pg.TipsMgr.GetInstance():ShowTips(var4)
		end

		return
	end

	if var0 == 1 then
		table.remove(arg0.selectedList, #arg0.selectedList)
	elseif var0 <= #arg0.selectedList then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_select_max"))
		arg0:UpdateSelected()

		return
	end

	table.insert(arg0.selectedList, arg1.id)
	arg0:UpdateSelected()
end

function var0.UpdateSelected(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:UpdateSelected(arg0.selectedList)
	end

	arg0:UpdateSelectedTxt()
end

function var0.UpdateSelectedTxt(arg0)
	local var0 = arg0.contextData.maxCount or table.getCount(arg0.commanderList)

	arg0.selectedNumTxt.text = #arg0.selectedList .. "/" .. var0
end

function var0.NewCard(arg0, arg1)
	if arg0.contextData.mode == CommanderCatScene.MODE_VIEW or arg0.contextData.maxCount == 1 then
		return CommanderCatCard.New(arg1, CommanderCatCard.MARK_TYPE_CIRCLE)
	else
		return CommanderCatCard.New(arg1, CommanderCatCard.MARK_TYPE_TICK)
	end
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		var0 = arg0:NewCard(arg2)
		arg0.cards[arg2] = var0
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1, arg0.selectedList, not defaultValue(arg0.sortData.displayCustomName, true))

	if var1 and arg0.selectedId and arg0.selectedId == var1.id and arg0.shouldTrigger then
		arg0.shouldTrigger = false

		triggerButton(var0.infoTF)
	end
end

local function var1(arg0, arg1, arg2)
	local var0 = false
	local var1 = false
	local var2 = arg0:getConfig("nationality")

	if table.getCount(arg1) == 0 or arg1[var2] or arg1[CommanderIndexPage.NATION_OTHER] and CommanderIndexPage.IsOtherNation(var2) then
		var0 = true
	end

	if table.getCount(arg2) == 0 or arg2[arg0:getRarity()] then
		var1 = true
	end

	return var0 and var1
end

local function var2(arg0, arg1, arg2, arg3, arg4)
	local function var0()
		if arg3 == "id" then
			return (arg2 and {
				arg0.id < arg1.id
			} or {
				arg0.id > arg1.id
			})[1]
		else
			local var0 = arg0["get" .. arg3](arg0)
			local var1 = arg1["get" .. arg3](arg1)

			if var0 == var1 then
				return (arg2 and {
					arg0.configId < arg1.configId
				} or {
					arg0.configId > arg1.configId
				})[1]
			else
				return (arg2 and {
					var0 < var1
				} or {
					var1 < var0
				})[1]
			end
		end
	end

	local function var1()
		local var0 = arg4 == arg0.id and 1 or 0
		local var1 = arg4 == arg1.id and 1 or 0

		if var0 == var1 then
			return var0()
		else
			return var1 < var0
		end
	end

	local var2 = arg0.inFleet and 1 or 0
	local var3 = arg1.inFleet and 1 or 0

	if var2 == var3 then
		return var1()
	else
		return var3 < var2
	end
end

function var0.UpdateCommanders(arg0, arg1)
	local var0 = (arg1 or not arg0.commanderList) and CommanderCatUtil.GetCommanderList(arg0.contextData) or arg0.commanderList

	arg0.shouldTrigger = true
	arg0.displays = {}

	local var1 = {}
	local var2 = {}

	for iter0, iter1 in pairs(arg0.sortData.nationData or {}) do
		var1[iter1] = true
	end

	for iter2, iter3 in ipairs(arg0.sortData.rarityData or {}) do
		var2[iter3] = true
	end

	for iter4, iter5 in pairs(var0) do
		if var1(iter5, var1, var2) then
			table.insert(arg0.displays, iter5)
		end
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return var2(arg0, arg1, arg0.sortData.asc, arg0.sortData.sortData, arg0.previewCommanderId)
	end)

	if not arg0.selectedId and #arg0.displays > 0 then
		arg0.selectedId = arg0.displays[1].id
	elseif #arg0.displays > 0 and _.all(arg0.displays, function(arg0)
		return arg0.id ~= arg0.selectedId
	end) and arg0.previewCommander then
		arg0:OnCheckBefore(arg0.previewCommander)
		arg0:OnCheckAfter(arg0.previewCommander)
	end

	if arg0.previewCommanderId and arg0.contextData.maxCount == 1 then
		table.insert(arg0.displays, 1, {
			id = 0
		})
	end

	local var3, var4 = arg0:FillList()

	arg0.scrollRect:SetTotalCount(var3, var4)

	arg0.commanderList = var0
end

function var0.FillList(arg0)
	if arg0.contextData.mode == CommanderCatScene.MODE_VIEW then
		local var0 = #arg0.displays % 4 > 0 and 4 - #arg0.displays % 4 or 0
		local var1 = #arg0.displays + var0
		local var2

		if arg0.selectedId then
			local var3 = 0

			for iter0, iter1 in ipairs(arg0.displays) do
				if iter1.id == arg0.selectedId then
					var3 = iter0

					break
				end
			end

			var2 = math.floor(var3 / 4) / (#arg0.displays / 4)
		end

		return math.max(12, var1), var2 or arg0.contextData.scrollValue or 0
	elseif arg0.contextData.mode == CommanderCatScene.MODE_SELECT then
		return #arg0.displays, arg0.contextData.scrollValue or 0
	end
end

function var0.CanBack(arg0)
	if arg0.boxesPanel and arg0.boxesPanel:GetLoaded() and arg0.boxesPanel.CanBack and not arg0.boxesPanel:CanBack() then
		return false
	end

	if arg0.reservePanel and arg0.reservePanel:GetLoaded() and arg0.reservePanel:isShowing() then
		arg0.reservePanel:Hide()

		return false
	end

	if arg0.boxesPanel and arg0.boxesPanel:GetLoaded() and arg0.boxesPanel:isShowing() then
		arg0.boxesPanel:Hide()

		return false
	end

	if arg0.indexPanel and arg0.indexPanel:GetLoaded() and arg0.indexPanel:isShowing() then
		arg0.indexPanel:Hide()

		return false
	end

	return true
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	if arg0.reservePanel then
		arg0.reservePanel:Destroy()

		arg0.reservePanel = nil
	end

	if arg0.boxesPanel then
		arg0.boxesPanel:Destroy()

		arg0.boxesPanel = nil
	end

	if arg0.indexPanel then
		arg0.indexPanel:Destroy()

		arg0.indexPanel = nil
	end

	if arg0.catterySettlementPage then
		arg0.catterySettlementPage:Destroy()

		arg0.catterySettlementPage = nil
	end

	arg0.contextData.scrollValue = math.min(arg0.scrollRect.value, 1)
end

return var0
