local var0_0 = class("PlayerSecondSummaryInfoScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PlayerSecondSummaryUI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activityVO = arg1_2
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.palyerVO = arg1_3
end

function var0_0.setSummaryInfo(arg0_4, arg1_4)
	arg0_4.summaryInfoVO = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.backBtn = arg0_5:findTF("bg/back_btn")
	arg0_5.pageContainer = arg0_5:findTF("bg/main/pages")
	arg0_5.pageFootContainer = arg0_5:findTF("bg/main/foots")

	GetOrAddComponent(arg0_5.pageFootContainer, typeof(CanvasGroup))
	setCanvasGroupAlpha(arg0_5.pageFootContainer, 0)
end

function var0_0.didEnter(arg0_6)
	if arg0_6.summaryInfoVO then
		arg0_6:initSummaryInfo()
	else
		arg0_6:emit(PlayerSummaryInfoMediator.GET_PLAYER_SUMMARY_INFO)
	end

	onButton(arg0_6, arg0_6.backBtn, function()
		if arg0_6:inAnim() then
			return
		end

		arg0_6:closeView()
	end, SFX_CANCEL)
end

function var0_0.inAnim(arg0_8)
	return arg0_8.inAniming or arg0_8.currPage and arg0_8.pages[arg0_8.currPage]:inAnim()
end

function var0_0.initSummaryInfo(arg0_9)
	arg0_9.loadingPage = SecondSummaryPage1.New(arg0_9:findTF("page1", arg0_9.pageContainer))

	arg0_9.loadingPage:Init(arg0_9.summaryInfoVO)

	arg0_9.pages = {}

	local function var0_9(arg0_10, arg1_10, arg2_10)
		setActive(arg0_10, false)

		local var0_10 = arg1_10.New(arg0_10)

		table.insert(arg0_9.pages, var0_10)
		var0_10:Init(arg2_10)
	end

	var0_9(arg0_9.pageContainer:Find("page2"), SecondSummaryPage2, arg0_9.summaryInfoVO)
	var0_9(arg0_9.pageContainer:Find("page3"), SecondSummaryPage3, arg0_9.summaryInfoVO)
	var0_9(arg0_9.pageContainer:Find("page6"), SecondSummaryPage6, arg0_9.summaryInfoVO)

	local var1_9 = arg0_9.pageContainer:Find("page4")

	setActive(var1_9, false)

	local var2_9 = 0

	if #arg0_9.summaryInfoVO.medalList > 0 then
		var2_9 = math.floor((#arg0_9.summaryInfoVO.medalList - 1) / SecondSummaryPage4.PerPageCount) + 1
	end

	for iter0_9 = 1, var2_9 do
		var0_9(cloneTplTo(var1_9, arg0_9.pageContainer, "page4_1_" .. iter0_9), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeFurniture,
			samePage = iter0_9,
			activityVO = arg0_9.activityVO
		}, {
			__index = arg0_9.summaryInfoVO
		}))
	end

	local var3_9 = 0

	if #arg0_9.summaryInfoVO.iconFrameList > 0 then
		var3_9 = math.floor((#arg0_9.summaryInfoVO.iconFrameList - 1) / SecondSummaryPage4.PerPageCount) + 1
	end

	for iter1_9 = 1, var3_9 do
		var0_9(cloneTplTo(var1_9, arg0_9.pageContainer, "page4_2_" .. iter1_9), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeIconFrame,
			samePage = iter1_9,
			activityVO = arg0_9.activityVO
		}, {
			__index = arg0_9.summaryInfoVO
		}))
	end

	var0_9(arg0_9.pageContainer:Find("page5"), SecondSummaryPage5, arg0_9.summaryInfoVO)
	onButton(arg0_9, arg0_9:findTF("page5/share", arg0_9.pageContainer), function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSecondSummary)
	end, SFX_CONFIRM)
	seriesAsync({
		function(arg0_12)
			arg0_9.inAniming = true

			arg0_9.loadingPage:Show(arg0_12)
		end,
		function(arg0_13)
			arg0_9.inAniming = false

			arg0_9.loadingPage:Hide()
			arg0_13()
		end
	}, function()
		arg0_9:registerDrag()
		arg0_9:registerFootEvent(1)
	end)
end

function var0_0.registerFootEvent(arg0_15, arg1_15)
	local var0_15 = UIItemList.New(arg0_15.pageFootContainer, arg0_15.pageFootContainer:Find("dot"))

	var0_15:make(function(arg0_16, arg1_16, arg2_16)
		local var0_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			onToggle(arg0_15, arg2_16, function(arg0_17)
				if arg0_17 then
					arg0_15.pages[var0_16]:Show()

					arg0_15.currPage = var0_16
				else
					arg0_15.pages[var0_16]:Hide()
				end
			end)
		end
	end)
	var0_15:align(#arg0_15.pages)
	setCanvasGroupAlpha(arg0_15.pageFootContainer, 1)
	triggerToggle(arg0_15.pageFootContainer:GetChild(arg1_15 - 1), true)
end

function var0_0.registerDrag(arg0_18)
	arg0_18:addVerticalDrag(arg0_18:findTF("bg"), function()
		arg0_18:updatePageFoot(arg0_18.currPage - 1)
	end, function()
		arg0_18:updatePageFoot(arg0_18.currPage + 1)
	end)
end

function var0_0.updatePageFoot(arg0_21, arg1_21)
	if arg0_21:inAnim() or not arg0_21.pages[arg1_21] then
		return
	end

	triggerToggle(arg0_21.pageFootContainer:GetChild(arg1_21 - 1), true)
end

function var0_0.addVerticalDrag(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = GetOrAddComponent(arg1_22, "EventTriggerListener")
	local var1_22
	local var2_22 = 0
	local var3_22 = 50

	var0_22:AddBeginDragFunc(function(arg0_23, arg1_23)
		var2_22 = 0
		var1_22 = arg1_23.position
	end)
	var0_22:AddDragFunc(function(arg0_24, arg1_24)
		var2_22 = arg1_24.position.x - var1_22.x
	end)
	var0_22:AddDragEndFunc(function(arg0_25, arg1_25)
		if var2_22 < -var3_22 then
			if arg3_22 then
				arg3_22()
			end
		elseif var2_22 > var3_22 and arg2_22 then
			arg2_22()
		end
	end)
end

function var0_0.willExit(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.pages) do
		iter1_26:Dispose()
	end

	arg0_26.pages = nil
	arg0_26.currPage = nil
end

return var0_0
