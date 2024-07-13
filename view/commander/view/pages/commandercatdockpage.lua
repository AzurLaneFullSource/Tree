local var0_0 = class("CommanderCatDockPage", import("view.base.BaseSubView"))

var0_0.ON_SORT = "CommanderCatDockPage:ON_SORT"

function var0_0.getUIName(arg0_1)
	return "CommanderCatDockui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:Find("frame"):GetComponent("LScrollRect")
	arg0_2.reserveBtn = arg0_2._tf:Find("box/reserve_btn")
	arg0_2.reserveTxt = arg0_2.reserveBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.reserveTip = arg0_2.reserveBtn:Find("free")
	arg0_2.homeBtn = arg0_2._tf:Find("box/home")
	arg0_2.homeTxt = arg0_2.homeBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.homeTip = arg0_2.homeBtn:Find("tip")
	arg0_2.boxesBtn = arg0_2._tf:Find("box/boxes_btn")
	arg0_2.boxesTxt = arg0_2.boxesBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.boxesTip = arg0_2.boxesBtn:Find("tip")
	arg0_2.capacityTxt = arg0_2._tf:Find("box/capcity/Text"):GetComponent(typeof(Text))
	arg0_2.sortBtn = arg0_2._tf:Find("top/sort_btn")
	arg0_2.sortIdTxt = arg0_2.sortBtn:Find("id")
	arg0_2.sortLvTxt = arg0_2.sortBtn:Find("Level")
	arg0_2.sortRarityTxt = arg0_2.sortBtn:Find("Rarity")
	arg0_2.ascBtn = arg0_2._tf:Find("top/asc_btn")
	arg0_2.ascTr = arg0_2.ascBtn:Find("asc")
	arg0_2.descTr = arg0_2.ascBtn:Find("desc")
	arg0_2.selectedTr = arg0_2._tf:Find("bottom")
	arg0_2.btnsTr = arg0_2._tf:Find("box")
	arg0_2.selectedNumTxt = arg0_2._tf:Find("bottom/value/Text"):GetComponent(typeof(Text))
	arg0_2.selectedBtn = arg0_2._tf:Find("bottom/select_btn")
	arg0_2.cancelBtn = arg0_2._tf:Find("bottom/cancel_btn")
	arg0_2.reservePanel = CommanderReservePage.New(arg0_2._tf.parent, arg0_2.event, arg0_2.contextData)
	arg0_2.boxesPanel = CommanderBoxesPage.New(arg0_2._tf.parent, arg0_2.event, arg0_2.contextData)
	arg0_2.indexPanel = CommanderIndexPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.catterySettlementPage = CatterySettlementPage.New(arg0_2._tf, arg0_2.event)
end

function var0_0.RegisterEvent(arg0_3)
	arg0_3:bind(var0_0.ON_SORT, function(arg0_4)
		arg0_3:OnSort()
	end)
	arg0_3:bind(CommanderCatScene.EVENT_NEXT_ONE, function(arg0_5, arg1_5)
		arg0_3:OnNextOn(arg1_5, 1)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREV_ONE, function(arg0_6, arg1_6)
		arg0_3:OnNextOn(arg1_6, -1)
	end)
	arg0_3:bind(CommanderCatScene.MSG_UPDATE, function(arg0_7)
		arg0_3:UpdateCommanders(true)
		arg0_3:UpdateCapacity()
	end)
	arg0_3:bind(CommanderCatScene.MSG_HOME_TIP, function(arg0_8)
		arg0_3:UpdateHome()
	end)
	arg0_3:bind(CommanderCatScene.MSG_BUILD, function()
		arg0_3:UpdateBoxes()
	end)
	arg0_3:bind(CommanderCatScene.MSG_RESERVE_BOX, function()
		arg0_3:UpdateReserve()
	end)
	arg0_3:bind(CommanderCatScene.EVENT_FOLD, function(arg0_11, arg1_11)
		if arg1_11 then
			LeanTween.moveX(rtf(arg0_3._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0_3._tf), -423, 0.5)
		end
	end)
end

function var0_0.OnNextOn(arg0_12, arg1_12, arg2_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(arg0_12.displays) do
		if iter1_12.id == arg1_12 then
			var0_12 = iter0_12

			break
		end
	end

	local var1_12 = var0_12 + arg2_12

	if var1_12 <= 0 or var1_12 > #arg0_12.displays then
		return
	end

	local var2_12 = false
	local var3_12 = arg0_12.displays[var1_12]

	for iter2_12, iter3_12 in pairs(arg0_12.cards) do
		if iter3_12.commanderVO and iter3_12.commanderVO.id == var3_12.id then
			var2_12 = true

			triggerButton(iter3_12.infoTF)

			break
		end
	end

	if not var2_12 then
		arg0_12:emit(CommanderCatScene.EVENT_SELECTED, var3_12)
	end
end

function var0_0.OnSort(arg0_13)
	local var0_13 = arg0_13.sortData.asc

	arg0_13.sortData = arg0_13.indexPanel.data
	arg0_13.sortData.asc = var0_13

	arg0_13:UpdateSortTxt()
	arg0_13:UpdateCommanders(false)
	setActive(arg0_13.ascTr, arg0_13.sortData.asc)
	setActive(arg0_13.descTr, not arg0_13.sortData.asc)
end

function var0_0.UpdateSortTxt(arg0_14)
	setActive(arg0_14.sortIdTxt, arg0_14.sortData.sortData == "id")
	setActive(arg0_14.sortLvTxt, arg0_14.sortData.sortData == "Level")
	setActive(arg0_14.sortRarityTxt, arg0_14.sortData.sortData == "Rarity")
end

function var0_0.OnInit(arg0_15)
	arg0_15.onCommander = arg0_15.contextData.onCommander or function(arg0_16, arg1_16, arg2_16, arg3_16)
		return true
	end
	arg0_15.onSelected = arg0_15.contextData.onSelected or function(arg0_17, arg1_17)
		arg1_17()
	end
	arg0_15.onQuit = arg0_15.contextData.onQuit or function(arg0_18)
		return
	end

	arg0_15:RegisterEvent()

	arg0_15.sortData = arg0_15.contextData.sortData or {
		asc = false,
		sortData = "Level",
		nationData = {},
		rarityData = {}
	}

	function arg0_15.scrollRect.onInitItem(arg0_19)
		arg0_15:OnInitItem(arg0_19)
	end

	function arg0_15.scrollRect.onUpdateItem(arg0_20, arg1_20)
		arg0_15:OnUpdateItem(arg0_20, arg1_20)
	end

	onButton(arg0_15, arg0_15.reserveBtn, function()
		arg0_15.reservePanel:ExecuteAction("Update")
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.boxesBtn, function()
		arg0_15.boxesPanel:ExecuteAction("Update")
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.ascBtn, function()
		arg0_15.sortData.asc = not arg0_15.sortData.asc

		setActive(arg0_15.ascTr, arg0_15.sortData.asc)
		setActive(arg0_15.descTr, not arg0_15.sortData.asc)
		arg0_15:UpdateCommanders(false)
	end, SFX_PANEL)
	setActive(arg0_15.ascTr, arg0_15.sortData.asc)
	setActive(arg0_15.descTr, not arg0_15.sortData.asc)
	onButton(arg0_15, arg0_15.sortBtn, function()
		arg0_15.indexPanel:ExecuteAction("Show", arg0_15.sortData)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.selectedBtn, function()
		local var0_25 = arg0_15.contextData.minCount or 1

		if var0_25 > #arg0_15.selectedList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_select_min_cnt", var0_25))

			return
		end

		arg0_15.onSelected(arg0_15.selectedList, function()
			arg0_15:emit(CommanderCatScene.EVENT_BACK)
		end)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.cancelBtn, function()
		arg0_15:emit(CommanderCatScene.EVENT_BACK)
	end, SFX_PANEL)

	if not LOCK_CATTERY then
		onButton(arg0_15, arg0_15.homeBtn, function()
			arg0_15:emit(CommanderCatMediator.OPEN_HOME)
		end, SFX_PANEL)
	else
		setActive(arg0_15.homeBtn, false)
	end

	arg0_15:Flush()
end

function var0_0.Flush(arg0_29)
	arg0_29.cards = {}
	arg0_29.selectedList = arg0_29.contextData.selectedIds or {}
	arg0_29.previewCommander = arg0_29.contextData.activeCommander
	arg0_29.previewCommanderId = arg0_29.previewCommander and arg0_29.previewCommander.id
	arg0_29.selectedId = arg0_29.previewCommanderId or arg0_29.contextData.selectedId

	arg0_29:UpdateCommanders(true)
	arg0_29:UpdateBoxes()
	arg0_29:UpdateReserve()
	arg0_29:UpdateCapacity()
	arg0_29:UpdateHome()
	arg0_29:TryPlayStory()
	arg0_29:DisplayCatterySettlement()
	arg0_29:UpdateStyle()
	arg0_29:UpdateSortTxt()
end

function var0_0.Show(arg0_30)
	setActive(arg0_30._tf, true)
	CommanderCatUtil.SetActive(arg0_30._tf, true)
end

function var0_0.Hide(arg0_31)
	CommanderCatUtil.SetActive(arg0_31._tf, false)
end

function var0_0.UpdateStyle(arg0_32)
	setActive(arg0_32.selectedTr, arg0_32.contextData.mode == CommanderCatScene.MODE_SELECT)
	setActive(arg0_32.btnsTr, arg0_32.contextData.mode == CommanderCatScene.MODE_VIEW)

	if arg0_32.contextData.mode == CommanderCatScene.MODE_SELECT then
		arg0_32:UpdateSelectedTxt()
	end
end

function var0_0.TryPlayStory(arg0_33)
	if arg0_33.contextData.fromMain then
		pg.SystemGuideMgr.GetInstance():PlayCommander()
	end
end

function var0_0.DisplayCatterySettlement(arg0_34)
	local var0_34 = getProxy(CommanderProxy):GetCommanderHome()
	local var1_34 = arg0_34.contextData.fromMediatorName == NewMainMediator.__cname
	local var2_34 = pg.NewStoryMgr.GetInstance():IsRunning() or pg.NewGuideMgr.GetInstance():IsBusy()

	if var0_34 and var0_34:ShouldSettleCattery() and var1_34 and not var2_34 then
		local var3_34 = Clone(var0_34)

		arg0_34.catterySettlementPage:ExecuteAction("Show", var3_34)
	end

	pg.m02:sendNotification(GAME.OPEN_OR_CLOSE_CATTERY, {
		open = true
	})
end

function var0_0.UpdateHome(arg0_35)
	local var0_35 = getProxy(CommanderProxy)

	setActive(arg0_35.homeTip, var0_35:AnyCatteryExistOP() or var0_35:AnyCatteryCanUse())

	local var1_35 = var0_35:GetCommanderHome()
	local var2_35 = ""

	if var1_35 then
		var2_35 = var1_35:GetExistCommanderCattertCnt() .. "/" .. var1_35:GetMaxCatteryCnt()
	end

	arg0_35.homeTxt.text = var2_35
end

function var0_0.UpdateCapacity(arg0_36)
	local var0_36 = getProxy(PlayerProxy):getRawData()
	local var1_36 = table.getCount(getProxy(CommanderProxy):getRawData())

	arg0_36.capacityTxt.text = var1_36 .. "/" .. var0_36.commanderBagMax
end

function var0_0.UpdateReserve(arg0_37)
	local var0_37 = getProxy(CommanderProxy):getBoxUseCnt()

	arg0_37.reserveTxt.text = CommanderConst.MAX_GETBOX_CNT - var0_37 .. "/" .. CommanderConst.MAX_GETBOX_CNT

	setActive(arg0_37.reserveTip, var0_37 == 0)
end

function var0_0.UpdateBoxes(arg0_38)
	local var0_38 = getProxy(CommanderProxy):getBoxes()
	local var1_38 = _.select(var0_38, function(arg0_39)
		return arg0_39:getState() == CommanderBox.STATE_FINISHED
	end)

	arg0_38.boxesTxt.text = #var1_38 .. "/" .. #var0_38

	setActive(arg0_38.boxesTip, getProxy(CommanderProxy):ShouldTipBox())
end

function var0_0.OnInitItem(arg0_40, arg1_40)
	local var0_40 = arg0_40:NewCard(arg1_40)

	onButton(arg0_40, var0_40.infoTF, function()
		if not var0_40.commanderVO then
			return
		end

		if arg0_40.contextData.mode == CommanderCatScene.MODE_SELECT then
			local var0_41 = #arg0_40.selectedList

			arg0_40:OnCheckBefore(var0_40.commanderVO)
			arg0_40:Check(var0_40.commanderVO)
			arg0_40:OnCheckAfter(var0_40.commanderVO, var0_41 > #arg0_40.selectedList)
		else
			arg0_40.selectedList = {}

			for iter0_41, iter1_41 in pairs(arg0_40.cards) do
				iter1_41:UpdateSelected(arg0_40.selectedList)
			end

			table.insert(arg0_40.selectedList, var0_40.commanderVO.id)
			var0_40:UpdateSelected(arg0_40.selectedList, not defaultValue(arg0_40.sortData.displayCustomName, true))

			arg0_40.selectedId = var0_40.commanderVO.id

			arg0_40:emit(CommanderCatScene.EVENT_SELECTED, var0_40.commanderVO, true)
		end
	end, SFX_PANEL)
	onButton(arg0_40, var0_40.quitTF, function()
		if not var0_40.commanderVO then
			return
		end

		if var0_40.commanderVO.id == 0 then
			arg0_40.onQuit(function()
				arg0_40:emit(CommanderCatScene.EVENT_BACK)
			end)
		end
	end, SFX_PANEL)

	arg0_40.cards[arg1_40] = var0_40
end

function var0_0.OnCheckBefore(arg0_44, arg1_44)
	if arg0_44.previewCommander and arg0_44.contextData.maxCount > 1 then
		arg0_44:emit(CommanderCatScene.EVENT_SELECTED, arg0_44.previewCommander, true)
	else
		arg0_44:emit(CommanderCatScene.EVENT_SELECTED, arg1_44, true)

		if arg0_44.previewCommander then
			arg0_44:emit(CommanderCatScene.EVENT_PREVIEW_ADDITION, arg0_44.previewCommander, true)
		else
			arg0_44:emit(CommanderCatScene.EVENT_PREVIEW_ADDITION, arg1_44, true)
		end
	end
end

function var0_0.OnCheckAfter(arg0_45, arg1_45, arg2_45)
	if arg0_45.previewCommander and arg0_45.contextData.maxCount > 1 then
		arg0_45:emit(CommanderCatScene.EVENT_PREVIEW_PLAY, arg0_45.selectedList, arg2_45)
	end
end

function var0_0.Check(arg0_46, arg1_46)
	local var0_46 = arg0_46.contextData.maxCount or table.getCount(arg0_46.commanderList)

	if table.contains(arg0_46.selectedList, arg1_46.id) and var0_46 == 1 then
		arg0_46:UpdateSelected()

		return
	elseif table.contains(arg0_46.selectedList, arg1_46.id) then
		local var1_46 = table.indexof(arg0_46.selectedList, arg1_46.id)

		table.remove(arg0_46.selectedList, var1_46)
		arg0_46:UpdateSelected()

		return
	end

	local function var2_46()
		for iter0_47, iter1_47 in ipairs(arg0_46.selectedList) do
			if iter1_47 == arg1_46.id then
				table.remove(arg0_46.selectedList, iter0_47)

				break
			end
		end
	end

	local var3_46, var4_46 = arg0_46.onCommander(arg1_46, function()
		var2_46()
		arg0_46:UpdateSelected()
	end, function()
		var2_46()
		arg0_46:UpdateCommanders(true)

		for iter0_49, iter1_49 in ipairs(arg0_46.commanderList or {}) do
			if iter1_49.id == arg1_46.id then
				arg0_46:Check(iter1_49)
			end
		end

		arg0_46:UpdateSelected()
	end, arg0_46)

	if not var3_46 then
		if var4_46 then
			pg.TipsMgr.GetInstance():ShowTips(var4_46)
		end

		return
	end

	if var0_46 == 1 then
		table.remove(arg0_46.selectedList, #arg0_46.selectedList)
	elseif var0_46 <= #arg0_46.selectedList then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_select_max"))
		arg0_46:UpdateSelected()

		return
	end

	table.insert(arg0_46.selectedList, arg1_46.id)
	arg0_46:UpdateSelected()
end

function var0_0.UpdateSelected(arg0_50)
	for iter0_50, iter1_50 in pairs(arg0_50.cards) do
		iter1_50:UpdateSelected(arg0_50.selectedList)
	end

	arg0_50:UpdateSelectedTxt()
end

function var0_0.UpdateSelectedTxt(arg0_51)
	local var0_51 = arg0_51.contextData.maxCount or table.getCount(arg0_51.commanderList)

	arg0_51.selectedNumTxt.text = #arg0_51.selectedList .. "/" .. var0_51
end

function var0_0.NewCard(arg0_52, arg1_52)
	if arg0_52.contextData.mode == CommanderCatScene.MODE_VIEW or arg0_52.contextData.maxCount == 1 then
		return CommanderCatCard.New(arg1_52, CommanderCatCard.MARK_TYPE_CIRCLE)
	else
		return CommanderCatCard.New(arg1_52, CommanderCatCard.MARK_TYPE_TICK)
	end
end

function var0_0.OnUpdateItem(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53.cards[arg2_53]

	if not var0_53 then
		var0_53 = arg0_53:NewCard(arg2_53)
		arg0_53.cards[arg2_53] = var0_53
	end

	local var1_53 = arg0_53.displays[arg1_53 + 1]

	var0_53:Update(var1_53, arg0_53.selectedList, not defaultValue(arg0_53.sortData.displayCustomName, true))

	if var1_53 and arg0_53.selectedId and arg0_53.selectedId == var1_53.id and arg0_53.shouldTrigger then
		arg0_53.shouldTrigger = false

		triggerButton(var0_53.infoTF)
	end
end

local function var1_0(arg0_54, arg1_54, arg2_54)
	local var0_54 = false
	local var1_54 = false
	local var2_54 = arg0_54:getConfig("nationality")

	if table.getCount(arg1_54) == 0 or arg1_54[var2_54] or arg1_54[CommanderIndexPage.NATION_OTHER] and CommanderIndexPage.IsOtherNation(var2_54) then
		var0_54 = true
	end

	if table.getCount(arg2_54) == 0 or arg2_54[arg0_54:getRarity()] then
		var1_54 = true
	end

	return var0_54 and var1_54
end

local function var2_0(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55)
	local function var0_55()
		if arg3_55 == "id" then
			return (arg2_55 and {
				arg0_55.id < arg1_55.id
			} or {
				arg0_55.id > arg1_55.id
			})[1]
		else
			local var0_56 = arg0_55["get" .. arg3_55](arg0_55)
			local var1_56 = arg1_55["get" .. arg3_55](arg1_55)

			if var0_56 == var1_56 then
				return (arg2_55 and {
					arg0_55.configId < arg1_55.configId
				} or {
					arg0_55.configId > arg1_55.configId
				})[1]
			else
				return (arg2_55 and {
					var0_56 < var1_56
				} or {
					var1_56 < var0_56
				})[1]
			end
		end
	end

	local function var1_55()
		local var0_57 = arg4_55 == arg0_55.id and 1 or 0
		local var1_57 = arg4_55 == arg1_55.id and 1 or 0

		if var0_57 == var1_57 then
			return var0_55()
		else
			return var1_57 < var0_57
		end
	end

	local var2_55 = arg0_55.inFleet and 1 or 0
	local var3_55 = arg1_55.inFleet and 1 or 0

	if var2_55 == var3_55 then
		return var1_55()
	else
		return var3_55 < var2_55
	end
end

function var0_0.UpdateCommanders(arg0_58, arg1_58)
	local var0_58 = (arg1_58 or not arg0_58.commanderList) and CommanderCatUtil.GetCommanderList(arg0_58.contextData) or arg0_58.commanderList

	arg0_58.shouldTrigger = true
	arg0_58.displays = {}

	local var1_58 = {}
	local var2_58 = {}

	for iter0_58, iter1_58 in pairs(arg0_58.sortData.nationData or {}) do
		var1_58[iter1_58] = true
	end

	for iter2_58, iter3_58 in ipairs(arg0_58.sortData.rarityData or {}) do
		var2_58[iter3_58] = true
	end

	for iter4_58, iter5_58 in pairs(var0_58) do
		if var1_0(iter5_58, var1_58, var2_58) then
			table.insert(arg0_58.displays, iter5_58)
		end
	end

	table.sort(arg0_58.displays, function(arg0_59, arg1_59)
		return var2_0(arg0_59, arg1_59, arg0_58.sortData.asc, arg0_58.sortData.sortData, arg0_58.previewCommanderId)
	end)

	if not arg0_58.selectedId and #arg0_58.displays > 0 then
		arg0_58.selectedId = arg0_58.displays[1].id
	elseif #arg0_58.displays > 0 and _.all(arg0_58.displays, function(arg0_60)
		return arg0_60.id ~= arg0_58.selectedId
	end) and arg0_58.previewCommander then
		arg0_58:OnCheckBefore(arg0_58.previewCommander)
		arg0_58:OnCheckAfter(arg0_58.previewCommander)
	end

	if arg0_58.previewCommanderId and arg0_58.contextData.maxCount == 1 then
		table.insert(arg0_58.displays, 1, {
			id = 0
		})
	end

	local var3_58, var4_58 = arg0_58:FillList()

	arg0_58.scrollRect:SetTotalCount(var3_58, var4_58)

	arg0_58.commanderList = var0_58
end

function var0_0.FillList(arg0_61)
	if arg0_61.contextData.mode == CommanderCatScene.MODE_VIEW then
		local var0_61 = #arg0_61.displays % 4 > 0 and 4 - #arg0_61.displays % 4 or 0
		local var1_61 = #arg0_61.displays + var0_61
		local var2_61

		if arg0_61.selectedId then
			local var3_61 = 0

			for iter0_61, iter1_61 in ipairs(arg0_61.displays) do
				if iter1_61.id == arg0_61.selectedId then
					var3_61 = iter0_61

					break
				end
			end

			var2_61 = math.floor(var3_61 / 4) / (#arg0_61.displays / 4)
		end

		return math.max(12, var1_61), var2_61 or arg0_61.contextData.scrollValue or 0
	elseif arg0_61.contextData.mode == CommanderCatScene.MODE_SELECT then
		return #arg0_61.displays, arg0_61.contextData.scrollValue or 0
	end
end

function var0_0.CanBack(arg0_62)
	if arg0_62.boxesPanel and arg0_62.boxesPanel:GetLoaded() and arg0_62.boxesPanel.CanBack and not arg0_62.boxesPanel:CanBack() then
		return false
	end

	if arg0_62.reservePanel and arg0_62.reservePanel:GetLoaded() and arg0_62.reservePanel:isShowing() then
		arg0_62.reservePanel:Hide()

		return false
	end

	if arg0_62.boxesPanel and arg0_62.boxesPanel:GetLoaded() and arg0_62.boxesPanel:isShowing() then
		arg0_62.boxesPanel:Hide()

		return false
	end

	if arg0_62.indexPanel and arg0_62.indexPanel:GetLoaded() and arg0_62.indexPanel:isShowing() then
		arg0_62.indexPanel:Hide()

		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_63)
	for iter0_63, iter1_63 in pairs(arg0_63.cards) do
		iter1_63:Dispose()
	end

	if arg0_63.reservePanel then
		arg0_63.reservePanel:Destroy()

		arg0_63.reservePanel = nil
	end

	if arg0_63.boxesPanel then
		arg0_63.boxesPanel:Destroy()

		arg0_63.boxesPanel = nil
	end

	if arg0_63.indexPanel then
		arg0_63.indexPanel:Destroy()

		arg0_63.indexPanel = nil
	end

	if arg0_63.catterySettlementPage then
		arg0_63.catterySettlementPage:Destroy()

		arg0_63.catterySettlementPage = nil
	end

	arg0_63.contextData.scrollValue = math.min(arg0_63.scrollRect.value, 1)
end

return var0_0
