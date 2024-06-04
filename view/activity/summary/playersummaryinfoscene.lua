local var0 = class("PlayerSummaryInfoScene", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "PlayerSummaryUI"
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
	arg0.pageFootContainer = arg0:findTF("bg/main/page_foot")
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

		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
end

function var0.inAnim(arg0)
	if _.any(arg0.pages or {}, function(arg0)
		return arg0:inAnim()
	end) then
		return true
	end

	return false
end

function var0.initSummaryInfo(arg0)
	arg0.loadingPage = SummaryPageLoading.New(arg0.pageContainer:Find("loading"))
	arg0.pages = {
		SummaryPage1.New(arg0:findTF("page1", arg0.pageContainer)),
		SummaryPage2.New(arg0:findTF("page2", arg0.pageContainer)),
		SummaryPage3.New(arg0:findTF("page3", arg0.pageContainer)),
		SummaryPage4.New(arg0:findTF("page4", arg0.pageContainer)),
		SummaryPage4.New(arg0:findTF("page4_1", arg0.pageContainer)),
		SummaryPage4.New(arg0:findTF("page4_2", arg0.pageContainer)),
		SummaryPage5.New(arg0:findTF("page5", arg0.pageContainer))
	}

	local var0 = arg0.summaryInfoVO.isProPose and 3 or 2

	table.remove(arg0.pages, var0):Hide()

	local var1 = {
		function(arg0)
			arg0.loadingPage:Init(arg0.summaryInfoVO)
			arg0()
		end,
		function(arg0)
			arg0.loadingPage:Show(arg0)
		end,
		function(arg0)
			arg0.loadingPage:Hide(arg0)
		end,
		function(arg0)
			for iter0, iter1 in ipairs(arg0.pages) do
				iter1:Init(arg0.summaryInfoVO)
			end

			arg0()
		end,
		function(arg0)
			arg0:registerFootEvent()
			arg0()
		end,
		function(arg0)
			arg0:updatePageFoot(1)
			arg0()
		end,
		function(arg0)
			arg0:registerDrag()
			arg0()
		end
	}

	setActive(arg0.pageFootContainer, false)
	seriesAsync(var1, function()
		setActive(arg0.pageFootContainer, true)
	end)
end

function var0.registerFootEvent(arg0)
	arg0.footTFs = {}

	for iter0 = 1, #arg0.pages do
		local var0 = arg0.pageFootContainer:Find("dot_" .. iter0)

		table.insert(arg0.footTFs, var0)

		local function var1(arg0)
			if arg0 then
				arg0.pages[iter0]:Show()

				arg0.currPage = iter0
			else
				arg0.pages[arg0.currPage]:Hide()
			end
		end

		onToggle(arg0, var0, var1)
	end
end

function var0.registerDrag(arg0)
	arg0:addVerticalDrag(arg0:findTF("bg"), function()
		arg0:updatePageFoot(arg0.currPage + 1)
	end, function()
		arg0:updatePageFoot(arg0.currPage - 1)
	end)
end

function var0.updatePageFoot(arg0, arg1)
	if arg0:inAnim() then
		return
	end

	if not arg0.footTFs[arg1] then
		return
	end

	triggerToggle(arg0.footTFs[arg1], true)
end

function var0.addVerticalDrag(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3 = 50

	var0:AddBeginDragFunc(function()
		var2 = 0
		var1 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var1 then
			var1 = var0
		end

		var2 = var0.y - var1.y
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

	arg0.loadingPage:Dispose()

	arg0.loadingPage = nil
end

return var0
