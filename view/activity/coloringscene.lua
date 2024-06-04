local var0 = class("ColoringScene", import("view.base.BaseUI"))
local var1 = 387
local var2 = 467
local var3 = 812.5
local var4 = 1200
local var5 = Vector2(49, -436.12)

function var0.getUIName(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0 then
		local var1 = AcessWithinNull(var0:getConfig("config_client"), "ui")

		if var1 then
			return var1
		end
	end

	local var2 = var0 and var0.id or 0

	assert(false, "Not Set PixelDraw Activity config_client ID: " .. var2)
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.setColorItems(arg0, arg1)
	arg0.colorItems = arg1
end

function var0.setColorGroups(arg0, arg1)
	arg0.colorGroups = arg1
end

function var0.init(arg0)
	arg0.topPanel = arg0:findTF("top")
	arg0.btnBack = arg0:findTF("top/btnBack")
	arg0.title = arg0:findTF("center/title_bar/text")
	arg0.bg = arg0:findTF("center/board/container/bg")
	arg0.painting = arg0:findTF("center/painting")
	arg0.paintingCompleted = arg0:findTF("center/painting_completed")
	arg0.zoom = arg0.bg:GetComponent("Zoom")
	arg0.zoom.maxZoom = 3
	arg0.cells = arg0:findTF("cells", arg0.bg)
	arg0.cell = arg0:findTF("cell", arg0.bg)
	arg0.lines = arg0:findTF("lines", arg0.bg)
	arg0.line = arg0:findTF("line", arg0.bg)
	arg0.btnHelp = arg0:findTF("top/btnHelp")
	arg0.btnShare = arg0:findTF("top/btnShare")
	arg0.colorgroupfront = arg0:findTF("center/colorgroupfront")
	arg0.scrollColor = arg0:findTF("color_bar/scroll")
	arg0.barExtra = arg0:findTF("color_bar/extra")
	arg0.toggleEraser = arg0:findTF("eraser", arg0.barExtra)
	arg0.btnEraserAll = arg0:findTF("eraser_all", arg0.barExtra)
	arg0.arrowDown = arg0:findTF("arrow", arg0.barExtra)

	setActive(arg0.cell, false)
	setActive(arg0.line, false)
	setActive(arg0.barExtra, false)
end

function var0.DidMediatorRegisterDone(arg0)
	local var0 = arg0.colorGroups[1]:getConfig("color_id_list")

	arg0.colorPlates = CustomIndexLayer.Clone2Full(arg0:findTF("content", arg0.scrollColor), #var0)

	local var1 = #arg0.colorGroups

	arg0.coloringUIGroupName = "ColoringUIGroupSize" .. var1

	PoolMgr.GetInstance():GetUI(arg0.coloringUIGroupName, false, function(arg0)
		setParent(arg0, arg0:findTF("center"))
		setAnchoredPosition(arg0, var5)
		tf(arg0):SetSiblingIndex(1)
		setActive(arg0, true)

		arg0.colorgroupbehind = tf(arg0)
		arg0.paintsgroup = {}

		for iter0 = arg0.colorgroupbehind.childCount - 1, 0, -1 do
			local var0 = arg0.colorgroupbehind:GetChild(iter0)

			table.insert(arg0.paintsgroup, var0)
		end
	end)

	local var2 = not COLORING_ACTIVITY_CUSTOMIZED_BANNED and _.any(arg0.colorGroups, function(arg0)
		return arg0:canBeCustomised()
	end)

	setActive(arg0.btnShare, var2)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		if arg0.exited then
			return
		end

		arg0:uiExitAnimating()
		arg0:emit(var0.ON_BACK, nil, 0.3)
	end, SOUND_BACK)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("coloring_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btnShare, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeColoring)
	end, SFX_PANEL)
	onNextTick(function()
		if arg0.exited then
			return
		end

		arg0:uiStartAnimating()
	end)
	arg0:initColoring()
	arg0:updatePage()
end

function var0.uiStartAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	arg0.topPanel.anchoredPosition = Vector2(0, arg0.topPanel.rect.height)

	shiftPanel(arg0.topPanel, nil, 0, var1, var0, true, true, nil)
end

function var0.uiExitAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0.topPanel, nil, arg0.topPanel.rect.height, var1, var0, true, true, nil)
end

function var0.initColoring(arg0)
	onButton(arg0, arg0.btnEraserAll, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("coloring_erase_all_warning"),
			onYes = function()
				local var0 = arg0.colorGroups[arg0.selectedIndex]

				if var0:canBeCustomised() then
					arg0:emit(ColoringMediator.EVENT_COLORING_CLEAR, {
						activityId = arg0.activity.id,
						id = var0.id
					})
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.arrowDown, function()
		arg0.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 0
	end, SFX_PANEL)

	local var0 = 1

	for iter0 = 1, #arg0.colorGroups do
		if arg0.colorGroups[iter0]:getState() == ColorGroup.StateColoring then
			var0 = iter0

			break
		end
	end

	local var1 = Mathf.Min(var0, #arg0.paintsgroup)

	arg0:initInteractive()

	arg0.selectedIndex = 0
	arg0.selectedColorIndex = 0

	triggerButton(arg0.paintsgroup[var1])
end

function var0.initInteractive(arg0)
	for iter0, iter1 in pairs(arg0.paintsgroup) do
		local var0 = iter0
		local var1 = arg0.colorGroups[var0]

		onButton(arg0, iter1, function()
			local var0 = var1:getState()

			if arg0.selectedIndex ~= var0 and var0 ~= ColorGroup.StateLock then
				local var1 = arg0.paintsgroup[arg0.selectedIndex]

				if var1 then
					var1:SetParent(arg0.colorgroupbehind)
				end

				arg0.selectedIndex = var0

				iter1:SetParent(arg0.colorgroupfront)
				arg0:SelectColoBar(0)
				arg0:updateSelectedColoring()
			elseif var0 == ColorGroup.StateLock then
				pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_lock"))
			end

			arg0:updatePage()
		end, SFX_PANEL)
	end

	for iter2 = 0, #arg0.colorPlates - 1 do
		local var2 = arg0.colorPlates[iter2 + 1]

		onButton(arg0, var2, function()
			arg0:SelectColoBar(iter2 + 1)

			local var0 = arg0.colorGroups[arg0.selectedIndex]

			if var0:getState() == ColorGroup.StateColoring and not var0:canBeCustomised() then
				local var1 = var0:getConfig("color_id_list")[arg0.selectedColorIndex]
				local var2 = arg0.colorItems[var1] or 0

				if var2 ~= 0 then
					local var3 = arg0:SearchValidDiagonalColoringCells(var0, arg0.selectedColorIndex, var2)

					if var3 and #var3 > 0 then
						arg0:emit(ColoringMediator.EVENT_COLORING_CELL, {
							activityId = arg0.activity.id,
							id = var0.id,
							cells = var3
						})
					end
				elseif not var0:isAllFill(arg0.selectedColorIndex) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_color_not_enough"))
				end
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.toggleEraser, function()
		arg0:SelectColoBar(0)
	end, SFX_PANEL)
end

function var0.SelectColoBar(arg0, arg1)
	if arg0.selectedColorIndex ~= 0 and arg0.selectedColorIndex ~= arg1 then
		local var0 = arg0.colorPlates[arg0.selectedColorIndex]
		local var1 = arg0:findTF("icon", var0)
		local var2 = var1.sizeDelta

		var2.x = var1
		var1.sizeDelta = var2
	end

	arg0.selectedColorIndex = arg1

	if arg0.selectedColorIndex ~= 0 then
		local var3 = arg0.colorPlates[arg0.selectedColorIndex]
		local var4 = arg0:findTF("icon", var3)
		local var5 = var4.sizeDelta

		var5.x = var2
		var4.sizeDelta = var5
	end
end

function var0.updatePage(arg0)
	for iter0, iter1 in ipairs(arg0.paintsgroup) do
		local var0 = arg0.colorGroups[iter0]:getState()

		setActive(iter1:Find("lock"), var0 == ColorGroup.StateLock)
		setActive(iter1:Find("get"), var0 == ColorGroup.StateAchieved)
	end

	local var1 = #arg0.paintsgroup
	local var2 = 0

	for iter2 = var1, 1, -1 do
		if iter2 ~= arg0.selectedIndex then
			arg0.paintsgroup[iter2]:SetSiblingIndex(var2)

			var2 = var2 + 1
		end
	end

	if getProxy(ColoringProxy):IsALLAchieve() and not IsNil(arg0.paintingCompleted) then
		setActive(arg0.painting, false)
		setActive(arg0.paintingCompleted, true)
	end

	arg0:TryPlayStory()
end

function var0.updateSelectedColoring(arg0)
	local var0 = arg0.colorGroups[arg0.selectedIndex]
	local var1 = var0:getConfig("color_id_list")

	for iter0 = 1, #arg0.colorPlates do
		local var2 = arg0.colorPlates[iter0]

		setText(var2:Find("icon/x/nums"), arg0.colorItems[var1[iter0]] or 0)
	end

	local var3 = var0:getConfig("name")

	setText(arg0.title, var3)
	setActive(arg0.title.parent, var3 ~= nil)
	setActive(arg0.barExtra, var0:canBeCustomised())

	local var4 = arg0.scrollColor.sizeDelta

	var4.y = var0:canBeCustomised() and var3 or var4
	arg0.scrollColor.sizeDelta = var4
	arg0.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	setActive(arg0.scrollColor, false)
	setActive(arg0.scrollColor, true)

	arg0.cellSize = arg0:calcCellSize()

	arg0:updateCells()
	arg0:updateLines()
	getProxy(ColoringProxy):SetViewedPage(arg0.selectedIndex or 1)
end

function var0.updateCells(arg0)
	local var0 = arg0.colorGroups[arg0.selectedIndex]
	local var1, var2 = unpack(var0:getConfig("theme"))

	for iter0 = 0, var1 do
		for iter1 = 0, var2 do
			arg0:updateCell(iter0, iter1)
		end
	end

	local var3 = arg0.bg:GetComponent("EventTriggerListener")

	var3:RemovePointClickFunc()
	var3:RemoveBeginDragFunc()
	var3:RemoveDragFunc()
	var3:RemoveDragEndFunc()

	local var4 = false

	var3:AddPointClickFunc(function(arg0, arg1)
		if not var0:canBeCustomised() then
			return
		end

		if var4 then
			return
		end

		local var0 = LuaHelper.ScreenToLocal(arg0.bg, arg1.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1 = math.floor(-var0.y / arg0.cellSize.y)
		local var2 = math.floor(var0.x / arg0.cellSize.x)

		if var0:getState() == ColorGroup.StateColoring then
			local function var3()
				arg0:emit(ColoringMediator.EVENT_COLORING_CELL, {
					activityId = arg0.activity.id,
					id = var0.id,
					cells = arg0:searchColoringCells(var0, var1, var2, arg0.selectedColorIndex)
				})
			end

			if not var0:canBeCustomised() then
				return
			elseif arg0.selectedColorIndex == 0 and not var0:hasFill(var1, var2) then
				return
			end

			var3()
		end
	end)
	var3:AddBeginDragFunc(function()
		var4 = false
	end)

	local var5 = Vector2.New(arg0.bg.rect.width / UnityEngine.Screen.width, arg0.bg.rect.height / UnityEngine.Screen.height)

	var3:AddDragFunc(function(arg0, arg1)
		var4 = true

		if not IsUnityEditor then
			arg0.zoom.enabled = Input.touchCount == 2
		end

		if IsUnityEditor or not arg0.zoom.enabled then
			local var0 = arg0.bg.anchoredPosition

			var0.x = var0.x + arg1.delta.x * var5.x
			var0.x = math.clamp(var0.x, -arg0.bg.rect.width * (arg0.bg.localScale.x - 1), 0)
			var0.y = var0.y + arg1.delta.y * var5.y
			var0.y = math.clamp(var0.y, 0, arg0.bg.rect.height * (arg0.bg.localScale.y - 1))
			arg0.bg.anchoredPosition = var0
		end
	end)
	var3:AddDragEndFunc(function()
		var4 = false
	end)
end

function var0.updateCell(arg0, arg1, arg2)
	local var0 = arg0.colorGroups[arg0.selectedIndex]
	local var1 = var0:getCell(arg1, arg2)
	local var2 = var0:getFill(arg1, arg2)
	local var3 = var0:getState()

	if var3 == ColorGroup.StateFinish or var3 == ColorGroup.StateAchieved then
		var2 = var1
	end

	local var4 = arg1 .. "_" .. arg2
	local var5 = arg0.cells:Find(var4)

	if var1 or var2 then
		var5 = var5 or cloneTplTo(arg0.cell, arg0.cells, var4)
		var5.sizeDelta = arg0.cellSize
		var5.anchoredPosition = Vector2((var2 or var1).column * arg0.cellSize.x, -((var2 or var1).row * arg0.cellSize.y))

		local var6 = var5:Find("image")
		local var7 = var5:Find("text")

		if var2 then
			setImageColor(var6, var0.colors[var2.type])
		else
			setText(var7, string.char(string.byte("A") + var1.type - 1))
		end

		setActive(var6, var2)
		setActive(var7, not var2)
		setActive(var5, true)
	elseif var5 then
		setActive(var5, false)
	end
end

function var0.calcCellSize(arg0)
	local var0 = arg0.colorGroups[arg0.selectedIndex]
	local var1, var2 = unpack(var0:getConfig("theme"))
	local var3 = arg0.bg.rect

	return (Vector2.New(var3.width / var2, var3.height / var1))
end

function var0.updateLines(arg0)
	local var0 = arg0.colorGroups[arg0.selectedIndex]
	local var1, var2 = unpack(var0:getConfig("theme"))

	for iter0 = 1, var2 - 1 do
		local var3 = "column_" .. iter0
		local var4 = arg0.lines:Find(var3) or cloneTplTo(arg0.line, arg0.lines, var3)

		var4.sizeDelta = Vector2.New(1, arg0.lines.rect.height)
		var4.anchoredPosition = Vector2.New(iter0 * arg0.cellSize.x - 0.5, 0)
	end

	for iter1 = 1, var1 - 1 do
		local var5 = "row_" .. iter1
		local var6 = arg0.lines:Find(var5) or cloneTplTo(arg0.line, arg0.lines, var5)

		var6.sizeDelta = Vector2.New(arg0.lines.rect.width, 1)
		var6.anchoredPosition = Vector2.New(0, -(iter1 * arg0.cellSize.y - 0.5))
	end
end

function var0.searchColoringCells(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		row = arg2,
		column = arg3,
		color = arg4
	}

	if arg1:canBeCustomised() then
		return {
			var0
		}
	else
		local var1 = arg1:getConfig("color_id_list")[arg4]
		local var2 = arg0.colorItems[var1]
		local var3 = {}
		local var4 = {}
		local var5 = {
			var0
		}
		local var6 = {
			{
				row = -1,
				column = 0
			},
			{
				row = 1,
				column = 0
			},
			{
				row = 0,
				column = -1
			},
			{
				row = 0,
				column = 1
			},
			{
				row = -1,
				column = -1
			},
			{
				row = -1,
				column = 1
			},
			{
				row = 1,
				column = -1
			},
			{
				row = 1,
				column = 1
			}
		}

		while #var5 > 0 and var2 > 0 do
			local var7 = table.remove(var5, 1)

			if not arg1:hasFill(var7.row, var7.column) and var7.color == arg4 then
				table.insert(var3, var7)

				var2 = var2 - 1

				_.each(var6, function(arg0)
					local var0 = arg1:getCell(arg0.row + var7.row, arg0.column + var7.column)

					if var0 and not (_.any(var5, function(arg0)
						return arg0.row == var0.row and arg0.column == var0.column
					end) or _.any(var4, function(arg0)
						return arg0.row == var0.row and arg0.column == var0.column
					end)) then
						table.insert(var5, {
							row = var0.row,
							column = var0.column,
							color = var0.type
						})
					end
				end)
			end

			table.insert(var4, var7)
		end

		return var3
	end
end

function var0.SearchValidDiagonalColoringCells(arg0, arg1, arg2, arg3)
	assert(arg1)

	local var0 = {}

	if arg1:getState() ~= ColorGroup.StateColoring or arg1:canBeCustomised() or arg3 == 0 then
		return var0
	else
		local var1, var2 = arg1:GetAABB()
		local var3 = var2.x - var1.x
		local var4 = var2.y - var1.y

		;(function()
			local var0 = var3 + var4

			for iter0 = 0, var0 do
				for iter1 = 0, iter0 do
					local var1 = iter0 - iter1
					local var2 = iter1

					if var1 <= var3 and var2 <= var4 then
						local var3 = var2 + var1.y
						local var4 = var1 + var1.x
						local var5 = arg1:getCell(var3, var4)

						if var5 and var5.type == arg2 and not arg1:getFill(var3, var4) then
							table.insert(var0, {
								row = var3,
								column = var4,
								color = arg2
							})

							if #var0 >= arg3 then
								return
							end
						end
					end
				end
			end
		end)()

		return var0
	end
end

function var0.TryPlayStory(arg0)
	local var0 = {}
	local var1 = arg0.selectedIndex

	table.SerialIpairsAsync(var0, function(arg0, arg1, arg2)
		if arg0 <= var1 and arg1 then
			pg.NewStoryMgr.GetInstance():Play(arg1, arg2)
		else
			arg2()
		end
	end)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0.btnBack)
end

function var0.willExit(arg0)
	PoolMgr.GetInstance():ReturnUI(arg0.coloringUIGroupName, arg0.colorgroupbehind)
end

return var0
