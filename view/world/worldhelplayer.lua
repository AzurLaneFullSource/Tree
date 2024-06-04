local var0 = class("WorldHelpLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldHelpUI"
end

function var0.init(arg0)
	arg0.rtTitle = arg0._tf:Find("title")
	arg0.btnBack = arg0.rtTitle:Find("btn_back")

	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.groupList = UIItemList.New(arg0.rtTitle:Find("toggles"), arg0.rtTitle:Find("toggles/toggle"))

	arg0.groupList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.titles[arg1]

			setText(arg2:Find("Text"), pg.world_help_data[var0].name)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					if arg0.curGroupId ~= var0 then
						arg0:toggleAnim(arg2, true)
						arg0:setCurGroup(var0)
					end
				else
					arg0:toggleAnim(arg2, false)
				end
			end, SFX_PANEL)
		end
	end)

	arg0.rtMain = arg0._tf:Find("main")
	arg0.rtScroll = arg0.rtMain:Find("Scroll")

	onButton(arg0, arg0.rtMain:Find("left"), function()
		if LeanTween.isTweening(go(arg0.rtScroll)) then
			return
		end

		if arg0.curPageIndex > 1 then
			local var0 = {}

			table.insert(var0, function(arg0)
				arg0:pageAnim(false, arg0)
			end)
			table.insert(var0, function(arg0)
				arg0:setCurPage(arg0.curPageIndex - 1)
				arg0()
			end)
			table.insert(var0, function(arg0)
				arg0:pageAnim(true, arg0)
			end)
			seriesAsync(var0, function()
				return
			end)
		end
	end)
	onButton(arg0, arg0.rtMain:Find("right"), function()
		if LeanTween.isTweening(go(arg0.rtScroll)) then
			return
		end

		if arg0.curPageIndex < #arg0.pageList then
			local var0 = {}

			table.insert(var0, function(arg0)
				arg0:pageAnim(false, arg0)
			end)
			table.insert(var0, function(arg0)
				arg0:setCurPage(arg0.curPageIndex + 1)
				arg0()
			end)
			table.insert(var0, function(arg0)
				arg0:pageAnim(true, arg0)
			end)
			seriesAsync(var0, function()
				return
			end)
		end
	end)
end

function var0.setCurGroup(arg0, arg1)
	local var0 = {}

	if arg0.curGroupId then
		table.insert(var0, function(arg0)
			arg0:pageAnim(false, arg0)
		end)
	end

	arg0.curGroupId = arg1

	table.insert(var0, function(arg0)
		local var0 = pg.world_help_data[arg0.curGroupId]

		arg0.pageList = {}

		local var1 = nowWorld():GetProgress()

		for iter0, iter1 in ipairs(var0.stage_help) do
			if var1 >= iter1[1] then
				table.insert(arg0.pageList, {
					id = iter0,
					path = iter1[2]
				})
			end
		end

		if #arg0.pageList > 0 then
			arg0:setCurPage(1)
		end

		arg0()
	end)
	seriesAsync(var0, function()
		arg0:pageAnim(true)
	end)
end

function var0.setCurPage(arg0, arg1)
	arg0.curPageIndex = arg1

	setText(arg0.rtMain:Find("page/Text"), arg0.curPageIndex .. "/" .. #arg0.pageList)

	local var0 = arg0.rtScroll:Find("Card")

	setImageAlpha(var0:Find("Image"), 0)
	GetSpriteFromAtlasAsync(arg0.pageList[arg1].path, "", function(arg0)
		if arg0.curPageIndex == arg1 then
			setImageSprite(var0:Find("Image"), arg0)
			setImageAlpha(var0:Find("Image"), 1)
		end
	end)
end

function var0.getPageIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.pageList) do
		if iter1.id == arg1 then
			return iter0
		end
	end

	return 1
end

function var0.pageAnim(arg0, arg1, arg2)
	LeanTween.cancel(go(arg0.rtScroll))

	local var0 = GetOrAddComponent(arg0.rtScroll, "CanvasGroup")

	var0.alpha = arg1 and 0 or 1

	LeanTween.alphaCanvas(var0, arg1 and 1 or 0, 0.3):setOnComplete(System.Action(function()
		return existCall(arg2)
	end))
end

function var0.toggleAnim(arg0, arg1, arg2)
	LeanTween.cancel(arg1.gameObject)

	local var0 = GetComponent(arg1, typeof(LayoutElement))

	if arg2 then
		LeanTween.value(arg1.gameObject, var0.preferredWidth, 238, 0.15):setOnUpdate(System.Action_float(function(arg0)
			var0.preferredWidth = arg0
		end)):setOnComplete(System.Action(function()
			setActive(arg1:Find("selected"), arg2)
		end))
	else
		setActive(arg1:Find("selected"), arg2)
		LeanTween.value(arg1.gameObject, var0.preferredWidth, 176, 0.15):setOnUpdate(System.Action_float(function(arg0)
			var0.preferredWidth = arg0
		end))
	end
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)

	local var0

	arg0.titles = {}

	local var1 = nowWorld():GetProgress()

	for iter0, iter1 in ipairs(pg.world_help_data.all) do
		if var1 >= pg.world_help_data[iter1].stage then
			table.insert(arg0.titles, iter1)

			if arg0.contextData.titleId == iter1 then
				var0 = #arg0.titles
			end
		end
	end

	arg0.groupList:align(#arg0.titles)
	setActive(arg0.rtScroll, #arg0.titles > 0)

	if #arg0.titles > 0 then
		if var0 then
			triggerToggle(arg0.groupList.container:GetChild(var0 - 1), true)
			arg0:setCurPage(arg0:getPageIndex(arg0.contextData.pageId))
		else
			triggerToggle(arg0.groupList.container:GetChild(0), true)
		end
	end
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.rtScroll))
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
