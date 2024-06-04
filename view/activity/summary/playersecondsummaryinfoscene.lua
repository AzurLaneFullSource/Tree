local var0 = class("PlayerSecondSummaryInfoScene", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "PlayerSecondSummaryUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activityVO = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.palyerVO = arg1
end

function var0.setSummaryInfo(arg0, arg1)
	arg0.summaryInfoVO = arg1
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("bg/back_btn")
	arg0.pageContainer = arg0:findTF("bg/main/pages")
	arg0.pageFootContainer = arg0:findTF("bg/main/foots")

	GetOrAddComponent(arg0.pageFootContainer, typeof(CanvasGroup))
	setCanvasGroupAlpha(arg0.pageFootContainer, 0)
end

function var0.didEnter(arg0)
	if arg0.summaryInfoVO then
		arg0:initSummaryInfo()
	else
		arg0:emit(PlayerSummaryInfoMediator.GET_PLAYER_SUMMARY_INFO)
	end

	onButton(arg0, arg0.backBtn, function()
		if arg0:inAnim() then
			return
		end

		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.inAnim(arg0)
	return arg0.inAniming or arg0.currPage and arg0.pages[arg0.currPage]:inAnim()
end

function var0.initSummaryInfo(arg0)
	arg0.loadingPage = SecondSummaryPage1.New(arg0:findTF("page1", arg0.pageContainer))

	arg0.loadingPage:Init(arg0.summaryInfoVO)

	arg0.pages = {}

	local function var0(arg0, arg1, arg2)
		setActive(arg0, false)

		local var0 = arg1.New(arg0)

		table.insert(arg0.pages, var0)
		var0:Init(arg2)
	end

	var0(arg0.pageContainer:Find("page2"), SecondSummaryPage2, arg0.summaryInfoVO)
	var0(arg0.pageContainer:Find("page3"), SecondSummaryPage3, arg0.summaryInfoVO)
	var0(arg0.pageContainer:Find("page6"), SecondSummaryPage6, arg0.summaryInfoVO)

	local var1 = arg0.pageContainer:Find("page4")

	setActive(var1, false)

	local var2 = 0

	if #arg0.summaryInfoVO.medalList > 0 then
		var2 = math.floor((#arg0.summaryInfoVO.medalList - 1) / SecondSummaryPage4.PerPageCount) + 1
	end

	for iter0 = 1, var2 do
		var0(cloneTplTo(var1, arg0.pageContainer, "page4_1_" .. iter0), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeFurniture,
			samePage = iter0,
			activityVO = arg0.activityVO
		}, {
			__index = arg0.summaryInfoVO
		}))
	end

	local var3 = 0

	if #arg0.summaryInfoVO.iconFrameList > 0 then
		var3 = math.floor((#arg0.summaryInfoVO.iconFrameList - 1) / SecondSummaryPage4.PerPageCount) + 1
	end

	for iter1 = 1, var3 do
		var0(cloneTplTo(var1, arg0.pageContainer, "page4_2_" .. iter1), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeIconFrame,
			samePage = iter1,
			activityVO = arg0.activityVO
		}, {
			__index = arg0.summaryInfoVO
		}))
	end

	var0(arg0.pageContainer:Find("page5"), SecondSummaryPage5, arg0.summaryInfoVO)
	onButton(arg0, arg0:findTF("page5/share", arg0.pageContainer), function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSecondSummary)
	end, SFX_CONFIRM)
	seriesAsync({
		function(arg0)
			arg0.inAniming = true

			arg0.loadingPage:Show(arg0)
		end,
		function(arg0)
			arg0.inAniming = false

			arg0.loadingPage:Hide()
			arg0()
		end
	}, function()
		arg0:registerDrag()
		arg0:registerFootEvent(1)
	end)
end

function var0.registerFootEvent(arg0, arg1)
	local var0 = UIItemList.New(arg0.pageFootContainer, arg0.pageFootContainer:Find("dot"))

	var0:make(function(arg0, arg1, arg2)
		local var0 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.pages[var0]:Show()

					arg0.currPage = var0
				else
					arg0.pages[var0]:Hide()
				end
			end)
		end
	end)
	var0:align(#arg0.pages)
	setCanvasGroupAlpha(arg0.pageFootContainer, 1)
	triggerToggle(arg0.pageFootContainer:GetChild(arg1 - 1), true)
end

function var0.registerDrag(arg0)
	arg0:addVerticalDrag(arg0:findTF("bg"), function()
		arg0:updatePageFoot(arg0.currPage - 1)
	end, function()
		arg0:updatePageFoot(arg0.currPage + 1)
	end)
end

function var0.updatePageFoot(arg0, arg1)
	if arg0:inAnim() or not arg0.pages[arg1] then
		return
	end

	triggerToggle(arg0.pageFootContainer:GetChild(arg1 - 1), true)
end

function var0.addVerticalDrag(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3 = 50

	var0:AddBeginDragFunc(function(arg0, arg1)
		var2 = 0
		var1 = arg1.position
	end)
	var0:AddDragFunc(function(arg0, arg1)
		var2 = arg1.position.x - var1.x
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if var2 < -var3 then
			if arg3 then
				arg3()
			end
		elseif var2 > var3 and arg2 then
			arg2()
		end
	end)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Dispose()
	end

	arg0.pages = nil
	arg0.currPage = nil
end

return var0
