local var0_0 = class("PlayerSummaryInfoScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PlayerSummaryUI"
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
	arg0_5.pageFootContainer = arg0_5:findTF("bg/main/page_foot")
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

		arg0_6:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
end

function var0_0.inAnim(arg0_8)
	if _.any(arg0_8.pages or {}, function(arg0_9)
		return arg0_9:inAnim()
	end) then
		return true
	end

	return false
end

function var0_0.initSummaryInfo(arg0_10)
	arg0_10.loadingPage = SummaryPageLoading.New(arg0_10.pageContainer:Find("loading"))
	arg0_10.pages = {
		SummaryPage1.New(arg0_10:findTF("page1", arg0_10.pageContainer)),
		SummaryPage2.New(arg0_10:findTF("page2", arg0_10.pageContainer)),
		SummaryPage3.New(arg0_10:findTF("page3", arg0_10.pageContainer)),
		SummaryPage4.New(arg0_10:findTF("page4", arg0_10.pageContainer)),
		SummaryPage4.New(arg0_10:findTF("page4_1", arg0_10.pageContainer)),
		SummaryPage4.New(arg0_10:findTF("page4_2", arg0_10.pageContainer)),
		SummaryPage5.New(arg0_10:findTF("page5", arg0_10.pageContainer))
	}

	local var0_10 = arg0_10.summaryInfoVO.isProPose and 3 or 2

	table.remove(arg0_10.pages, var0_10):Hide()

	local var1_10 = {
		function(arg0_11)
			arg0_10.loadingPage:Init(arg0_10.summaryInfoVO)
			arg0_11()
		end,
		function(arg0_12)
			arg0_10.loadingPage:Show(arg0_12)
		end,
		function(arg0_13)
			arg0_10.loadingPage:Hide(arg0_13)
		end,
		function(arg0_14)
			for iter0_14, iter1_14 in ipairs(arg0_10.pages) do
				iter1_14:Init(arg0_10.summaryInfoVO)
			end

			arg0_14()
		end,
		function(arg0_15)
			arg0_10:registerFootEvent()
			arg0_15()
		end,
		function(arg0_16)
			arg0_10:updatePageFoot(1)
			arg0_16()
		end,
		function(arg0_17)
			arg0_10:registerDrag()
			arg0_17()
		end
	}

	setActive(arg0_10.pageFootContainer, false)
	seriesAsync(var1_10, function()
		setActive(arg0_10.pageFootContainer, true)
	end)
end

function var0_0.registerFootEvent(arg0_19)
	arg0_19.footTFs = {}

	for iter0_19 = 1, #arg0_19.pages do
		local var0_19 = arg0_19.pageFootContainer:Find("dot_" .. iter0_19)

		table.insert(arg0_19.footTFs, var0_19)

		local function var1_19(arg0_20)
			if arg0_20 then
				arg0_19.pages[iter0_19]:Show()

				arg0_19.currPage = iter0_19
			else
				arg0_19.pages[arg0_19.currPage]:Hide()
			end
		end

		onToggle(arg0_19, var0_19, var1_19)
	end
end

function var0_0.registerDrag(arg0_21)
	arg0_21:addVerticalDrag(arg0_21:findTF("bg"), function()
		arg0_21:updatePageFoot(arg0_21.currPage + 1)
	end, function()
		arg0_21:updatePageFoot(arg0_21.currPage - 1)
	end)
end

function var0_0.updatePageFoot(arg0_24, arg1_24)
	if arg0_24:inAnim() then
		return
	end

	if not arg0_24.footTFs[arg1_24] then
		return
	end

	triggerToggle(arg0_24.footTFs[arg1_24], true)
end

function var0_0.addVerticalDrag(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = GetOrAddComponent(arg1_25, "EventTriggerListener")
	local var1_25
	local var2_25 = 0
	local var3_25 = 50

	var0_25:AddBeginDragFunc(function()
		var2_25 = 0
		var1_25 = nil
	end)
	var0_25:AddDragFunc(function(arg0_27, arg1_27)
		local var0_27 = arg1_27.position

		if not var1_25 then
			var1_25 = var0_27
		end

		var2_25 = var0_27.y - var1_25.y
	end)
	var0_25:AddDragEndFunc(function(arg0_28, arg1_28)
		if var2_25 < -var3_25 then
			if arg3_25 then
				arg3_25()
			end
		elseif var2_25 > var3_25 and arg2_25 then
			arg2_25()
		end
	end)
end

function var0_0.willExit(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.pages) do
		iter1_29:Dispose()
	end

	arg0_29.pages = nil

	arg0_29.loadingPage:Dispose()

	arg0_29.loadingPage = nil
end

return var0_0
