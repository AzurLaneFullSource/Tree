local var0_0 = class("WorldHelpLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldHelpUI"
end

function var0_0.init(arg0_2)
	arg0_2.rtTitle = arg0_2._tf:Find("title")
	arg0_2.btnBack = arg0_2.rtTitle:Find("btn_back")

	onButton(arg0_2, arg0_2.btnBack, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.groupList = UIItemList.New(arg0_2.rtTitle:Find("toggles"), arg0_2.rtTitle:Find("toggles/toggle"))

	arg0_2.groupList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.titles[arg1_4]

			setText(arg2_4:Find("Text"), pg.world_help_data[var0_4].name)
			onToggle(arg0_2, arg2_4, function(arg0_5)
				if arg0_5 then
					if arg0_2.curGroupId ~= var0_4 then
						arg0_2:toggleAnim(arg2_4, true)
						arg0_2:setCurGroup(var0_4)
					end
				else
					arg0_2:toggleAnim(arg2_4, false)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_2.rtMain = arg0_2._tf:Find("main")
	arg0_2.rtScroll = arg0_2.rtMain:Find("Scroll")

	onButton(arg0_2, arg0_2.rtMain:Find("left"), function()
		if LeanTween.isTweening(go(arg0_2.rtScroll)) then
			return
		end

		if arg0_2.curPageIndex > 1 then
			local var0_6 = {}

			table.insert(var0_6, function(arg0_7)
				arg0_2:pageAnim(false, arg0_7)
			end)
			table.insert(var0_6, function(arg0_8)
				arg0_2:setCurPage(arg0_2.curPageIndex - 1)
				arg0_8()
			end)
			table.insert(var0_6, function(arg0_9)
				arg0_2:pageAnim(true, arg0_9)
			end)
			seriesAsync(var0_6, function()
				return
			end)
		end
	end)
	onButton(arg0_2, arg0_2.rtMain:Find("right"), function()
		if LeanTween.isTweening(go(arg0_2.rtScroll)) then
			return
		end

		if arg0_2.curPageIndex < #arg0_2.pageList then
			local var0_11 = {}

			table.insert(var0_11, function(arg0_12)
				arg0_2:pageAnim(false, arg0_12)
			end)
			table.insert(var0_11, function(arg0_13)
				arg0_2:setCurPage(arg0_2.curPageIndex + 1)
				arg0_13()
			end)
			table.insert(var0_11, function(arg0_14)
				arg0_2:pageAnim(true, arg0_14)
			end)
			seriesAsync(var0_11, function()
				return
			end)
		end
	end)
end

function var0_0.setCurGroup(arg0_16, arg1_16)
	local var0_16 = {}

	if arg0_16.curGroupId then
		table.insert(var0_16, function(arg0_17)
			arg0_16:pageAnim(false, arg0_17)
		end)
	end

	arg0_16.curGroupId = arg1_16

	table.insert(var0_16, function(arg0_18)
		local var0_18 = pg.world_help_data[arg0_16.curGroupId]

		arg0_16.pageList = {}

		local var1_18 = nowWorld():GetProgress()

		for iter0_18, iter1_18 in ipairs(var0_18.stage_help) do
			if var1_18 >= iter1_18[1] then
				table.insert(arg0_16.pageList, {
					id = iter0_18,
					path = iter1_18[2]
				})
			end
		end

		if #arg0_16.pageList > 0 then
			arg0_16:setCurPage(1)
		end

		arg0_18()
	end)
	seriesAsync(var0_16, function()
		arg0_16:pageAnim(true)
	end)
end

function var0_0.setCurPage(arg0_20, arg1_20)
	arg0_20.curPageIndex = arg1_20

	setText(arg0_20.rtMain:Find("page/Text"), arg0_20.curPageIndex .. "/" .. #arg0_20.pageList)

	local var0_20 = arg0_20.rtScroll:Find("Card")

	setImageAlpha(var0_20:Find("Image"), 0)
	GetSpriteFromAtlasAsync(arg0_20.pageList[arg1_20].path, "", function(arg0_21)
		if arg0_20.curPageIndex == arg1_20 then
			setImageSprite(var0_20:Find("Image"), arg0_21)
			setImageAlpha(var0_20:Find("Image"), 1)
		end
	end)
end

function var0_0.getPageIndex(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.pageList) do
		if iter1_22.id == arg1_22 then
			return iter0_22
		end
	end

	return 1
end

function var0_0.pageAnim(arg0_23, arg1_23, arg2_23)
	LeanTween.cancel(go(arg0_23.rtScroll))

	local var0_23 = GetOrAddComponent(arg0_23.rtScroll, "CanvasGroup")

	var0_23.alpha = arg1_23 and 0 or 1

	LeanTween.alphaCanvas(var0_23, arg1_23 and 1 or 0, 0.3):setOnComplete(System.Action(function()
		return existCall(arg2_23)
	end))
end

function var0_0.toggleAnim(arg0_25, arg1_25, arg2_25)
	LeanTween.cancel(arg1_25.gameObject)

	local var0_25 = GetComponent(arg1_25, typeof(LayoutElement))

	if arg2_25 then
		LeanTween.value(arg1_25.gameObject, var0_25.preferredWidth, 238, 0.15):setOnUpdate(System.Action_float(function(arg0_26)
			var0_25.preferredWidth = arg0_26
		end)):setOnComplete(System.Action(function()
			setActive(arg1_25:Find("selected"), arg2_25)
		end))
	else
		setActive(arg1_25:Find("selected"), arg2_25)
		LeanTween.value(arg1_25.gameObject, var0_25.preferredWidth, 176, 0.15):setOnUpdate(System.Action_float(function(arg0_28)
			var0_25.preferredWidth = arg0_28
		end))
	end
end

function var0_0.didEnter(arg0_29)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_29._tf)

	local var0_29

	arg0_29.titles = {}

	local var1_29 = nowWorld():GetProgress()

	for iter0_29, iter1_29 in ipairs(pg.world_help_data.all) do
		if var1_29 >= pg.world_help_data[iter1_29].stage then
			table.insert(arg0_29.titles, iter1_29)

			if arg0_29.contextData.titleId == iter1_29 then
				var0_29 = #arg0_29.titles
			end
		end
	end

	arg0_29.groupList:align(#arg0_29.titles)
	setActive(arg0_29.rtScroll, #arg0_29.titles > 0)

	if #arg0_29.titles > 0 then
		if var0_29 then
			triggerToggle(arg0_29.groupList.container:GetChild(var0_29 - 1), true)
			arg0_29:setCurPage(arg0_29:getPageIndex(arg0_29.contextData.pageId))
		else
			triggerToggle(arg0_29.groupList.container:GetChild(0), true)
		end
	end
end

function var0_0.willExit(arg0_30)
	LeanTween.cancel(go(arg0_30.rtScroll))
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf)
end

return var0_0
