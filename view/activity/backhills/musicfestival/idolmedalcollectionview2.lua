local var0_0 = class("IdolMedalCollectionView2", import("view.base.BaseUI"))

function var0_0.GetContainerPositions(arg0_1)
	return {
		32.4,
		132.7
	}
end

function var0_0.GetActivityID(arg0_2)
	return ActivityConst.MUSIC_FESTIVAL_MEDALCOLLECTION_2020
end

function var0_0.getUIName(arg0_3)
	return "IdolMedalCollectionUI2"
end

function var0_0.init(arg0_4)
	arg0_4:initData()
	arg0_4:findUI()
	arg0_4:addListener()
end

function var0_0.didEnter(arg0_5)
	arg0_5:checkAward()
	arg0_5:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf)
end

function var0_0.willExit(arg0_6)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf)
end

function var0_0.initData(arg0_7)
	arg0_7.activityProxy = getProxy(ActivityProxy)
	arg0_7.activityData = arg0_7.activityProxy:getActivityById(arg0_7:GetActivityID())
	arg0_7.allIDList = arg0_7.activityData:GetPicturePuzzleIds()
	arg0_7.activatableIDList = arg0_7.activityData.data1_list
	arg0_7.activeIDList = arg0_7.activityData.data2_list
end

local var1_0 = {}

function var0_0.findUI(arg0_8)
	arg0_8.bg = arg0_8:findTF("BG")

	local var0_8 = arg0_8:findTF("NotchAdapt")

	arg0_8.backBtn = arg0_8:findTF("BackBtn", var0_8)
	arg0_8.progressText = arg0_8:findTF("ProgressText", var0_8)
	arg0_8.helpBtn = arg0_8:findTF("HelpBtn", var0_8)
	arg0_8.top = var0_8

	local var1_8 = arg0_8:findTF("MedalContainer")

	arg0_8.medalContainer = var1_8
	arg0_8.buttonNext = arg0_8:findTF("ButtonNext", var1_8)
	arg0_8.buttonNextLocked = arg0_8:findTF("ButtonNextLocked", var1_8)
	arg0_8.buttonPrev = arg0_8:findTF("ButtonPrev", var1_8)
	arg0_8.buttonShare = arg0_8:findTF("ButtonShare", var1_8)
	arg0_8.buttonReset = arg0_8:findTF("ButtonReset", var1_8)
	arg0_8.pageCollection = var1_8:Find("PageCollection")
	arg0_8.pageModified = var1_8:Find("PageModified")
	arg0_8.OverlayPanel = var1_8:Find("Overlay")
	arg0_8.pages = {
		arg0_8.pageCollection,
		arg0_8.pageModified
	}
	arg0_8.pageIndex = 1
	arg0_8.medalItemList = {}

	for iter0_8 = 1, #arg0_8.allIDList do
		table.insert(arg0_8.medalItemList, arg0_8:findTF("Images/Medal" .. iter0_8, arg0_8.pageCollection))
	end

	arg0_8.medalTextList = {}

	for iter1_8 = 1, #arg0_8.allIDList do
		table.insert(arg0_8.medalTextList, arg0_8:findTF("Texts/Medal" .. iter1_8, arg0_8.pageCollection))
	end

	arg0_8.selectPanel = var1_8:Find("SelectPanel")
	arg0_8.selectPanelContainer = arg0_8.selectPanel:Find("Scroll/Container")
	arg0_8.allItems = {}
	arg0_8.selectedPositionsInPanels = {}
	arg0_8.listStayInPanel = {}
	arg0_8.listShowOnPanel = {}
	arg0_8.overlayingImage = nil

	for iter2_8 = 0, arg0_8.selectPanelContainer.childCount - 1 do
		local var2_8 = arg0_8.selectPanelContainer:GetChild(iter2_8)

		arg0_8.selectedPositionsInPanels[var2_8] = var2_8.anchoredPosition

		table.insert(arg0_8.listStayInPanel, var2_8)
		table.insert(arg0_8.allItems, var2_8)
	end

	for iter3_8, iter4_8 in pairs(var1_0) do
		local var3_8 = arg0_8.allItems[iter3_8]

		setParent(var3_8, arg0_8.pageModified)
		table.removebyvalue(arg0_8.listStayInPanel, var3_8)
		table.insert(arg0_8.listShowOnPanel, var3_8)
		setAnchoredPosition(var3_8, iter4_8)
	end

	setText(arg0_8.pageModified:Find("TextTip"), i18n("collect_idol_tip"))
	arg0_8:AddLeanTween(function()
		return LeanTween.alphaText(rtf(arg0_8.pageModified:Find("TextTip")), 1, 2):setFrom(0):setLoopPingPong()
	end)
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_collection.tip
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.bg, function()
		arg0_10:SwitchSelectedImage(nil)
	end)
	onButton(arg0_10, arg0_10.selectPanelContainer, function()
		arg0_10:SwitchSelectedImage(nil)
	end)
	onButton(arg0_10, arg0_10.buttonNext, function()
		arg0_10:SwitchPage(1)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.buttonNextLocked, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("hand_account_tip"))
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.buttonPrev, function()
		arg0_10:SwitchPage(-1)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.buttonReset, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("hand_account_resetting_tip"),
			onYes = function()
				arg0_10:ResetPanel()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.buttonShare, function()
		setAnchoredPosition(arg0_10.medalContainer, {
			x = arg0_10:GetContainerPositions()[1]
		})
		setActive(arg0_10.selectPanel, false)
		setActive(arg0_10.buttonNext, false)
		setActive(arg0_10.buttonNextLocked, false)
		setActive(arg0_10.buttonPrev, false)
		setActive(arg0_10.buttonShare, false)
		setActive(arg0_10.buttonReset, false)
		setActive(arg0_10.top, false)
		setActive(arg0_10.pageModified:Find("TextTip"), false)

		local var0_20 = arg0_10.lastSelectedImage

		arg0_10:SwitchSelectedImage(nil)
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePoraisMedals)
		setActive(arg0_10.top, true)
		setActive(arg0_10.pageModified:Find("TextTip"), true)
		arg0_10:SwitchSelectedImage(var0_20)
		arg0_10:UpdateView()
	end, SFX_PANEL)

	local var0_10 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	for iter0_10, iter1_10 in ipairs(arg0_10.allItems) do
		local var1_10 = arg0_10.selectedPositionsInPanels[iter1_10]

		setActive(iter1_10:Find("Selected"), false)

		local var2_10 = GetOrAddComponent(iter1_10, "EventTriggerListener")

		local function var3_10()
			if not arg0_10.overlayingImage then
				return
			end

			local var0_21 = arg0_10.overlayingImage

			arg0_10.overlayingImage = nil

			for iter0_21, iter1_21 in ipairs(arg0_10.listStayInPanel) do
				if iter1_21 == var0_21 then
					setParent(var0_21, arg0_10.selectPanelContainer)
					setAnchoredPosition(var0_21, arg0_10.selectedPositionsInPanels[var0_21])

					return
				end
			end

			for iter2_21, iter3_21 in ipairs(arg0_10.listShowOnPanel) do
				if iter3_21 == var0_21 then
					setParent(var0_21, arg0_10.pageModified)
					var0_21:SetAsLastSibling()

					return
				end
			end
		end

		local var4_10

		var2_10:AddPointClickFunc(function(arg0_22, arg1_22)
			if var4_10 then
				return
			end

			if arg0_10.lastSelectedImage == iter1_10 then
				arg0_10:SwitchSelectedImage(nil)
			else
				arg0_10:SwitchSelectedImage(iter1_10)
				iter1_10:SetAsLastSibling()
			end
		end)
		var2_10:AddBeginDragFunc(function(arg0_23, arg1_23)
			var4_10 = arg1_23.position

			var3_10()
			setParent(iter1_10, arg0_10.OverlayPanel)

			arg0_10.overlayingImage = iter1_10

			arg0_10:SwitchSelectedImage(iter1_10)
		end)
		var2_10:AddDragFunc(function(arg0_24, arg1_24)
			local var0_24 = LuaHelper.ScreenToLocal(rtf(arg0_10.OverlayPanel), arg1_24.position, var0_10)

			setAnchoredPosition(iter1_10, var0_24)
		end)
		var2_10:AddDragEndFunc(function(arg0_25, arg1_25)
			local var0_25 = arg1_25.position
			local var1_25 = var4_10 and var4_10:Sub(var0_25):SqrMagnitude() < 1

			var4_10 = nil

			if var1_25 then
				var3_10()

				return
			end

			local var2_25 = LuaHelper.ScreenToLocal(rtf(arg0_10.pageModified), arg1_25.position, var0_10)

			if not rtf(arg0_10.pageModified).rect:Contains(var2_25) then
				setParent(iter1_10, arg0_10.selectPanelContainer)
				table.removebyvalue(arg0_10.listStayInPanel, iter1_10)
				table.removebyvalue(arg0_10.listShowOnPanel, iter1_10)
				table.insert(arg0_10.listStayInPanel, iter1_10)

				var1_0[iter0_10] = nil

				setAnchoredPosition(iter1_10, var1_10)
				iter1_10:SetAsLastSibling()
			else
				setParent(iter1_10, arg0_10.pageModified)
				table.removebyvalue(arg0_10.listStayInPanel, iter1_10)
				table.removebyvalue(arg0_10.listShowOnPanel, iter1_10)
				table.insert(arg0_10.listShowOnPanel, iter1_10)

				var1_0[iter0_10] = var2_25

				setAnchoredPosition(iter1_10, var2_25)
				iter1_10:SetAsLastSibling()
			end

			arg0_10.overlayingImage = nil
		end)
	end
end

function var0_0.SwitchSelectedImage(arg0_26, arg1_26)
	if arg0_26.lastSelectedImage == arg1_26 then
		return
	end

	if arg0_26.lastSelectedImage then
		setActive(arg0_26.lastSelectedImage:Find("Selected"), false)
	end

	arg0_26.lastSelectedImage = arg1_26

	if arg1_26 then
		setActive(arg1_26:Find("Selected"), true)
	end
end

function var0_0.ResetPanel(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.listShowOnPanel) do
		table.insert(arg0_27.listStayInPanel, iter1_27)
		setParent(iter1_27, arg0_27.selectPanelContainer)

		local var0_27 = arg0_27.selectedPositionsInPanels[iter1_27] or Vector2.zero

		setAnchoredPosition(iter1_27, var0_27)
	end

	table.clean(arg0_27.listShowOnPanel)
	table.clear(var1_0)
end

function var0_0.UpdateView(arg0_28)
	if arg0_28.pageIndex == 1 then
		arg0_28:updateMedalContainerView()
	end

	for iter0_28 = 1, #arg0_28.pages do
		setActive(arg0_28.pages[iter0_28], iter0_28 == arg0_28.pageIndex)
	end

	setAnchoredPosition(arg0_28.medalContainer, {
		x = arg0_28:GetContainerPositions()[arg0_28.pageIndex]
	})
	setActive(arg0_28.selectPanel, arg0_28.pageIndex == 2)

	local var0_28 = #arg0_28.activeIDList == #arg0_28.allIDList and arg0_28.activityData.data1 == 1

	setActive(arg0_28.buttonNext, var0_28 and arg0_28.pageIndex == 1)
	setActive(arg0_28.buttonNextLocked, not var0_28 and arg0_28.pageIndex == 1)
	setActive(arg0_28.buttonPrev, arg0_28.pageIndex == 2)
	setActive(arg0_28.buttonShare, arg0_28.pageIndex == 2)
	setActive(arg0_28.buttonReset, arg0_28.pageIndex == 2)
	setText(arg0_28.progressText, setColorStr(tostring(#arg0_28.activeIDList), COLOR_RED) .. "/" .. #arg0_28.allIDList)
end

function var0_0.updateMedalContainerView(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.allIDList) do
		arg0_29:updateMedalView(arg0_29.allIDList, iter1_29)
	end
end

function var0_0.updateMedalView(arg0_30, arg1_30, arg2_30)
	local var0_30 = table.indexof(arg1_30, arg2_30, 1)
	local var1_30 = table.contains(arg0_30.activeIDList, arg2_30)
	local var2_30 = table.contains(arg0_30.activatableIDList, arg2_30) and not var1_30
	local var3_30 = not var1_30 and not var2_30
	local var4_30 = arg0_30.medalItemList[var0_30]
	local var5_30 = arg0_30.medalTextList[var0_30]
	local var6_30 = arg0_30:findTF("Activable", var5_30)
	local var7_30 = arg0_30:findTF("DisActive", var5_30)

	setImageAlpha(var4_30, var1_30 and 1 or 0)
	setActive(var6_30, var2_30)
	setActive(var7_30, var3_30)
	onButton(arg0_30, var4_30, function()
		if not var2_30 then
			return
		end

		pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
			id = arg2_30,
			actId = arg0_30.activityData.id
		})
	end, SFX_PANEL)

	local var8_30 = ""

	setText(var7_30, var8_30)
end

function var0_0.updateAfterSubmit(arg0_32)
	return
end

function var0_0.UpdateActivity(arg0_33)
	arg0_33:initData()
	arg0_33:checkAward()
	arg0_33:UpdateView()
end

function var0_0.SwitchPage(arg0_34, arg1_34)
	arg0_34.pageIndex = math.clamp(arg0_34.pageIndex + arg1_34, 1, #arg0_34.pages)

	arg0_34:UpdateView()
end

function var0_0.checkAward(arg0_35)
	if #arg0_35.activeIDList == #arg0_35.allIDList and arg0_35.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_35.activityData.id
		})
	end
end

return var0_0
