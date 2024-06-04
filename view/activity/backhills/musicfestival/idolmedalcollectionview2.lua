local var0 = class("IdolMedalCollectionView2", import("view.base.BaseUI"))

function var0.GetContainerPositions(arg0)
	return {
		32.4,
		132.7
	}
end

function var0.GetActivityID(arg0)
	return ActivityConst.MUSIC_FESTIVAL_MEDALCOLLECTION_2020
end

function var0.getUIName(arg0)
	return "IdolMedalCollectionUI2"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:checkAward()
	arg0:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(arg0:GetActivityID())
	arg0.allIDList = arg0.activityData:GetPicturePuzzleIds()
	arg0.activatableIDList = arg0.activityData.data1_list
	arg0.activeIDList = arg0.activityData.data2_list
end

local var1 = {}

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = arg0:findTF("NotchAdapt")

	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.progressText = arg0:findTF("ProgressText", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)
	arg0.top = var0

	local var1 = arg0:findTF("MedalContainer")

	arg0.medalContainer = var1
	arg0.buttonNext = arg0:findTF("ButtonNext", var1)
	arg0.buttonNextLocked = arg0:findTF("ButtonNextLocked", var1)
	arg0.buttonPrev = arg0:findTF("ButtonPrev", var1)
	arg0.buttonShare = arg0:findTF("ButtonShare", var1)
	arg0.buttonReset = arg0:findTF("ButtonReset", var1)
	arg0.pageCollection = var1:Find("PageCollection")
	arg0.pageModified = var1:Find("PageModified")
	arg0.OverlayPanel = var1:Find("Overlay")
	arg0.pages = {
		arg0.pageCollection,
		arg0.pageModified
	}
	arg0.pageIndex = 1
	arg0.medalItemList = {}

	for iter0 = 1, #arg0.allIDList do
		table.insert(arg0.medalItemList, arg0:findTF("Images/Medal" .. iter0, arg0.pageCollection))
	end

	arg0.medalTextList = {}

	for iter1 = 1, #arg0.allIDList do
		table.insert(arg0.medalTextList, arg0:findTF("Texts/Medal" .. iter1, arg0.pageCollection))
	end

	arg0.selectPanel = var1:Find("SelectPanel")
	arg0.selectPanelContainer = arg0.selectPanel:Find("Scroll/Container")
	arg0.allItems = {}
	arg0.selectedPositionsInPanels = {}
	arg0.listStayInPanel = {}
	arg0.listShowOnPanel = {}
	arg0.overlayingImage = nil

	for iter2 = 0, arg0.selectPanelContainer.childCount - 1 do
		local var2 = arg0.selectPanelContainer:GetChild(iter2)

		arg0.selectedPositionsInPanels[var2] = var2.anchoredPosition

		table.insert(arg0.listStayInPanel, var2)
		table.insert(arg0.allItems, var2)
	end

	for iter3, iter4 in pairs(var1) do
		local var3 = arg0.allItems[iter3]

		setParent(var3, arg0.pageModified)
		table.removebyvalue(arg0.listStayInPanel, var3)
		table.insert(arg0.listShowOnPanel, var3)
		setAnchoredPosition(var3, iter4)
	end

	setText(arg0.pageModified:Find("TextTip"), i18n("collect_idol_tip"))
	arg0:AddLeanTween(function()
		return LeanTween.alphaText(rtf(arg0.pageModified:Find("TextTip")), 1, 2):setFrom(0):setLoopPingPong()
	end)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_collection.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bg, function()
		arg0:SwitchSelectedImage(nil)
	end)
	onButton(arg0, arg0.selectPanelContainer, function()
		arg0:SwitchSelectedImage(nil)
	end)
	onButton(arg0, arg0.buttonNext, function()
		arg0:SwitchPage(1)
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonNextLocked, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("hand_account_tip"))
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonPrev, function()
		arg0:SwitchPage(-1)
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonReset, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("hand_account_resetting_tip"),
			onYes = function()
				arg0:ResetPanel()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonShare, function()
		setAnchoredPosition(arg0.medalContainer, {
			x = arg0:GetContainerPositions()[1]
		})
		setActive(arg0.selectPanel, false)
		setActive(arg0.buttonNext, false)
		setActive(arg0.buttonNextLocked, false)
		setActive(arg0.buttonPrev, false)
		setActive(arg0.buttonShare, false)
		setActive(arg0.buttonReset, false)
		setActive(arg0.top, false)
		setActive(arg0.pageModified:Find("TextTip"), false)

		local var0 = arg0.lastSelectedImage

		arg0:SwitchSelectedImage(nil)
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePoraisMedals)
		setActive(arg0.top, true)
		setActive(arg0.pageModified:Find("TextTip"), true)
		arg0:SwitchSelectedImage(var0)
		arg0:UpdateView()
	end, SFX_PANEL)

	local var0 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	for iter0, iter1 in ipairs(arg0.allItems) do
		local var1 = arg0.selectedPositionsInPanels[iter1]

		setActive(iter1:Find("Selected"), false)

		local var2 = GetOrAddComponent(iter1, "EventTriggerListener")

		local function var3()
			if not arg0.overlayingImage then
				return
			end

			local var0 = arg0.overlayingImage

			arg0.overlayingImage = nil

			for iter0, iter1 in ipairs(arg0.listStayInPanel) do
				if iter1 == var0 then
					setParent(var0, arg0.selectPanelContainer)
					setAnchoredPosition(var0, arg0.selectedPositionsInPanels[var0])

					return
				end
			end

			for iter2, iter3 in ipairs(arg0.listShowOnPanel) do
				if iter3 == var0 then
					setParent(var0, arg0.pageModified)
					var0:SetAsLastSibling()

					return
				end
			end
		end

		local var4

		var2:AddPointClickFunc(function(arg0, arg1)
			if var4 then
				return
			end

			if arg0.lastSelectedImage == iter1 then
				arg0:SwitchSelectedImage(nil)
			else
				arg0:SwitchSelectedImage(iter1)
				iter1:SetAsLastSibling()
			end
		end)
		var2:AddBeginDragFunc(function(arg0, arg1)
			var4 = arg1.position

			var3()
			setParent(iter1, arg0.OverlayPanel)

			arg0.overlayingImage = iter1

			arg0:SwitchSelectedImage(iter1)
		end)
		var2:AddDragFunc(function(arg0, arg1)
			local var0 = LuaHelper.ScreenToLocal(rtf(arg0.OverlayPanel), arg1.position, var0)

			setAnchoredPosition(iter1, var0)
		end)
		var2:AddDragEndFunc(function(arg0, arg1)
			local var0 = arg1.position
			local var1 = var4 and var4:Sub(var0):SqrMagnitude() < 1

			var4 = nil

			if var1 then
				var3()

				return
			end

			local var2 = LuaHelper.ScreenToLocal(rtf(arg0.pageModified), arg1.position, var0)

			if not rtf(arg0.pageModified).rect:Contains(var2) then
				setParent(iter1, arg0.selectPanelContainer)
				table.removebyvalue(arg0.listStayInPanel, iter1)
				table.removebyvalue(arg0.listShowOnPanel, iter1)
				table.insert(arg0.listStayInPanel, iter1)

				var1[iter0] = nil

				setAnchoredPosition(iter1, var1)
				iter1:SetAsLastSibling()
			else
				setParent(iter1, arg0.pageModified)
				table.removebyvalue(arg0.listStayInPanel, iter1)
				table.removebyvalue(arg0.listShowOnPanel, iter1)
				table.insert(arg0.listShowOnPanel, iter1)

				var1[iter0] = var2

				setAnchoredPosition(iter1, var2)
				iter1:SetAsLastSibling()
			end

			arg0.overlayingImage = nil
		end)
	end
end

function var0.SwitchSelectedImage(arg0, arg1)
	if arg0.lastSelectedImage == arg1 then
		return
	end

	if arg0.lastSelectedImage then
		setActive(arg0.lastSelectedImage:Find("Selected"), false)
	end

	arg0.lastSelectedImage = arg1

	if arg1 then
		setActive(arg1:Find("Selected"), true)
	end
end

function var0.ResetPanel(arg0)
	for iter0, iter1 in ipairs(arg0.listShowOnPanel) do
		table.insert(arg0.listStayInPanel, iter1)
		setParent(iter1, arg0.selectPanelContainer)

		local var0 = arg0.selectedPositionsInPanels[iter1] or Vector2.zero

		setAnchoredPosition(iter1, var0)
	end

	table.clean(arg0.listShowOnPanel)
	table.clear(var1)
end

function var0.UpdateView(arg0)
	if arg0.pageIndex == 1 then
		arg0:updateMedalContainerView()
	end

	for iter0 = 1, #arg0.pages do
		setActive(arg0.pages[iter0], iter0 == arg0.pageIndex)
	end

	setAnchoredPosition(arg0.medalContainer, {
		x = arg0:GetContainerPositions()[arg0.pageIndex]
	})
	setActive(arg0.selectPanel, arg0.pageIndex == 2)

	local var0 = #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 == 1

	setActive(arg0.buttonNext, var0 and arg0.pageIndex == 1)
	setActive(arg0.buttonNextLocked, not var0 and arg0.pageIndex == 1)
	setActive(arg0.buttonPrev, arg0.pageIndex == 2)
	setActive(arg0.buttonShare, arg0.pageIndex == 2)
	setActive(arg0.buttonReset, arg0.pageIndex == 2)
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), COLOR_RED) .. "/" .. #arg0.allIDList)
end

function var0.updateMedalContainerView(arg0)
	for iter0, iter1 in ipairs(arg0.allIDList) do
		arg0:updateMedalView(arg0.allIDList, iter1)
	end
end

function var0.updateMedalView(arg0, arg1, arg2)
	local var0 = table.indexof(arg1, arg2, 1)
	local var1 = table.contains(arg0.activeIDList, arg2)
	local var2 = table.contains(arg0.activatableIDList, arg2) and not var1
	local var3 = not var1 and not var2
	local var4 = arg0.medalItemList[var0]
	local var5 = arg0.medalTextList[var0]
	local var6 = arg0:findTF("Activable", var5)
	local var7 = arg0:findTF("DisActive", var5)

	setImageAlpha(var4, var1 and 1 or 0)
	setActive(var6, var2)
	setActive(var7, var3)
	onButton(arg0, var4, function()
		if not var2 then
			return
		end

		pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
			id = arg2,
			actId = arg0.activityData.id
		})
	end, SFX_PANEL)

	local var8 = ""

	setText(var7, var8)
end

function var0.updateAfterSubmit(arg0)
	return
end

function var0.UpdateActivity(arg0)
	arg0:initData()
	arg0:checkAward()
	arg0:UpdateView()
end

function var0.SwitchPage(arg0, arg1)
	arg0.pageIndex = math.clamp(arg0.pageIndex + arg1, 1, #arg0.pages)

	arg0:UpdateView()
end

function var0.checkAward(arg0)
	if #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0.activityData.id
		})
	end
end

return var0
