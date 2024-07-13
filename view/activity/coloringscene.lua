local var0_0 = class("ColoringScene", import("view.base.BaseUI"))
local var1_0 = 387
local var2_0 = 467
local var3_0 = 812.5
local var4_0 = 1200
local var5_0 = Vector2(49, -436.12)

function var0_0.getUIName(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0_1 then
		local var1_1 = AcessWithinNull(var0_1:getConfig("config_client"), "ui")

		if var1_1 then
			return var1_1
		end
	end

	local var2_1 = var0_1 and var0_1.id or 0

	assert(false, "Not Set PixelDraw Activity config_client ID: " .. var2_1)
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.setColorItems(arg0_3, arg1_3)
	arg0_3.colorItems = arg1_3
end

function var0_0.setColorGroups(arg0_4, arg1_4)
	arg0_4.colorGroups = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.topPanel = arg0_5:findTF("top")
	arg0_5.btnBack = arg0_5:findTF("top/btnBack")
	arg0_5.title = arg0_5:findTF("center/title_bar/text")
	arg0_5.bg = arg0_5:findTF("center/board/container/bg")
	arg0_5.painting = arg0_5:findTF("center/painting")
	arg0_5.paintingCompleted = arg0_5:findTF("center/painting_completed")
	arg0_5.zoom = arg0_5.bg:GetComponent("Zoom")
	arg0_5.zoom.maxZoom = 3
	arg0_5.cells = arg0_5:findTF("cells", arg0_5.bg)
	arg0_5.cell = arg0_5:findTF("cell", arg0_5.bg)
	arg0_5.lines = arg0_5:findTF("lines", arg0_5.bg)
	arg0_5.line = arg0_5:findTF("line", arg0_5.bg)
	arg0_5.btnHelp = arg0_5:findTF("top/btnHelp")
	arg0_5.btnShare = arg0_5:findTF("top/btnShare")
	arg0_5.colorgroupfront = arg0_5:findTF("center/colorgroupfront")
	arg0_5.scrollColor = arg0_5:findTF("color_bar/scroll")
	arg0_5.barExtra = arg0_5:findTF("color_bar/extra")
	arg0_5.toggleEraser = arg0_5:findTF("eraser", arg0_5.barExtra)
	arg0_5.btnEraserAll = arg0_5:findTF("eraser_all", arg0_5.barExtra)
	arg0_5.arrowDown = arg0_5:findTF("arrow", arg0_5.barExtra)

	setActive(arg0_5.cell, false)
	setActive(arg0_5.line, false)
	setActive(arg0_5.barExtra, false)
end

function var0_0.DidMediatorRegisterDone(arg0_6)
	local var0_6 = arg0_6.colorGroups[1]:getConfig("color_id_list")

	arg0_6.colorPlates = CustomIndexLayer.Clone2Full(arg0_6:findTF("content", arg0_6.scrollColor), #var0_6)

	local var1_6 = #arg0_6.colorGroups

	arg0_6.coloringUIGroupName = "ColoringUIGroupSize" .. var1_6

	PoolMgr.GetInstance():GetUI(arg0_6.coloringUIGroupName, false, function(arg0_7)
		setParent(arg0_7, arg0_6:findTF("center"))
		setAnchoredPosition(arg0_7, var5_0)
		tf(arg0_7):SetSiblingIndex(1)
		setActive(arg0_7, true)

		arg0_6.colorgroupbehind = tf(arg0_7)
		arg0_6.paintsgroup = {}

		for iter0_7 = arg0_6.colorgroupbehind.childCount - 1, 0, -1 do
			local var0_7 = arg0_6.colorgroupbehind:GetChild(iter0_7)

			table.insert(arg0_6.paintsgroup, var0_7)
		end
	end)

	local var2_6 = not COLORING_ACTIVITY_CUSTOMIZED_BANNED and _.any(arg0_6.colorGroups, function(arg0_8)
		return arg0_8:canBeCustomised()
	end)

	setActive(arg0_6.btnShare, var2_6)
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.btnBack, function()
		if arg0_9.exited then
			return
		end

		arg0_9:uiExitAnimating()
		arg0_9:emit(var0_0.ON_BACK, nil, 0.3)
	end, SOUND_BACK)
	onButton(arg0_9, arg0_9.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("coloring_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.btnShare, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeColoring)
	end, SFX_PANEL)
	onNextTick(function()
		if arg0_9.exited then
			return
		end

		arg0_9:uiStartAnimating()
	end)
	arg0_9:initColoring()
	arg0_9:updatePage()
end

function var0_0.uiStartAnimating(arg0_14)
	local var0_14 = 0
	local var1_14 = 0.3

	arg0_14.topPanel.anchoredPosition = Vector2(0, arg0_14.topPanel.rect.height)

	shiftPanel(arg0_14.topPanel, nil, 0, var1_14, var0_14, true, true, nil)
end

function var0_0.uiExitAnimating(arg0_15)
	local var0_15 = 0
	local var1_15 = 0.3

	shiftPanel(arg0_15.topPanel, nil, arg0_15.topPanel.rect.height, var1_15, var0_15, true, true, nil)
end

function var0_0.initColoring(arg0_16)
	onButton(arg0_16, arg0_16.btnEraserAll, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("coloring_erase_all_warning"),
			onYes = function()
				local var0_18 = arg0_16.colorGroups[arg0_16.selectedIndex]

				if var0_18:canBeCustomised() then
					arg0_16:emit(ColoringMediator.EVENT_COLORING_CLEAR, {
						activityId = arg0_16.activity.id,
						id = var0_18.id
					})
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.arrowDown, function()
		arg0_16.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 0
	end, SFX_PANEL)

	local var0_16 = 1

	for iter0_16 = 1, #arg0_16.colorGroups do
		if arg0_16.colorGroups[iter0_16]:getState() == ColorGroup.StateColoring then
			var0_16 = iter0_16

			break
		end
	end

	local var1_16 = Mathf.Min(var0_16, #arg0_16.paintsgroup)

	arg0_16:initInteractive()

	arg0_16.selectedIndex = 0
	arg0_16.selectedColorIndex = 0

	triggerButton(arg0_16.paintsgroup[var1_16])
end

function var0_0.initInteractive(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.paintsgroup) do
		local var0_20 = iter0_20
		local var1_20 = arg0_20.colorGroups[var0_20]

		onButton(arg0_20, iter1_20, function()
			local var0_21 = var1_20:getState()

			if arg0_20.selectedIndex ~= var0_20 and var0_21 ~= ColorGroup.StateLock then
				local var1_21 = arg0_20.paintsgroup[arg0_20.selectedIndex]

				if var1_21 then
					var1_21:SetParent(arg0_20.colorgroupbehind)
				end

				arg0_20.selectedIndex = var0_20

				iter1_20:SetParent(arg0_20.colorgroupfront)
				arg0_20:SelectColoBar(0)
				arg0_20:updateSelectedColoring()
			elseif var0_21 == ColorGroup.StateLock then
				pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_lock"))
			end

			arg0_20:updatePage()
		end, SFX_PANEL)
	end

	for iter2_20 = 0, #arg0_20.colorPlates - 1 do
		local var2_20 = arg0_20.colorPlates[iter2_20 + 1]

		onButton(arg0_20, var2_20, function()
			arg0_20:SelectColoBar(iter2_20 + 1)

			local var0_22 = arg0_20.colorGroups[arg0_20.selectedIndex]

			if var0_22:getState() == ColorGroup.StateColoring and not var0_22:canBeCustomised() then
				local var1_22 = var0_22:getConfig("color_id_list")[arg0_20.selectedColorIndex]
				local var2_22 = arg0_20.colorItems[var1_22] or 0

				if var2_22 ~= 0 then
					local var3_22 = arg0_20:SearchValidDiagonalColoringCells(var0_22, arg0_20.selectedColorIndex, var2_22)

					if var3_22 and #var3_22 > 0 then
						arg0_20:emit(ColoringMediator.EVENT_COLORING_CELL, {
							activityId = arg0_20.activity.id,
							id = var0_22.id,
							cells = var3_22
						})
					end
				elseif not var0_22:isAllFill(arg0_20.selectedColorIndex) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_color_not_enough"))
				end
			end
		end, SFX_PANEL)
	end

	onButton(arg0_20, arg0_20.toggleEraser, function()
		arg0_20:SelectColoBar(0)
	end, SFX_PANEL)
end

function var0_0.SelectColoBar(arg0_24, arg1_24)
	if arg0_24.selectedColorIndex ~= 0 and arg0_24.selectedColorIndex ~= arg1_24 then
		local var0_24 = arg0_24.colorPlates[arg0_24.selectedColorIndex]
		local var1_24 = arg0_24:findTF("icon", var0_24)
		local var2_24 = var1_24.sizeDelta

		var2_24.x = var1_0
		var1_24.sizeDelta = var2_24
	end

	arg0_24.selectedColorIndex = arg1_24

	if arg0_24.selectedColorIndex ~= 0 then
		local var3_24 = arg0_24.colorPlates[arg0_24.selectedColorIndex]
		local var4_24 = arg0_24:findTF("icon", var3_24)
		local var5_24 = var4_24.sizeDelta

		var5_24.x = var2_0
		var4_24.sizeDelta = var5_24
	end
end

function var0_0.updatePage(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.paintsgroup) do
		local var0_25 = arg0_25.colorGroups[iter0_25]:getState()

		setActive(iter1_25:Find("lock"), var0_25 == ColorGroup.StateLock)
		setActive(iter1_25:Find("get"), var0_25 == ColorGroup.StateAchieved)
	end

	local var1_25 = #arg0_25.paintsgroup
	local var2_25 = 0

	for iter2_25 = var1_25, 1, -1 do
		if iter2_25 ~= arg0_25.selectedIndex then
			arg0_25.paintsgroup[iter2_25]:SetSiblingIndex(var2_25)

			var2_25 = var2_25 + 1
		end
	end

	if getProxy(ColoringProxy):IsALLAchieve() and not IsNil(arg0_25.paintingCompleted) then
		setActive(arg0_25.painting, false)
		setActive(arg0_25.paintingCompleted, true)
	end

	arg0_25:TryPlayStory()
end

function var0_0.updateSelectedColoring(arg0_26)
	local var0_26 = arg0_26.colorGroups[arg0_26.selectedIndex]
	local var1_26 = var0_26:getConfig("color_id_list")

	for iter0_26 = 1, #arg0_26.colorPlates do
		local var2_26 = arg0_26.colorPlates[iter0_26]

		setText(var2_26:Find("icon/x/nums"), arg0_26.colorItems[var1_26[iter0_26]] or 0)
	end

	local var3_26 = var0_26:getConfig("name")

	setText(arg0_26.title, var3_26)
	setActive(arg0_26.title.parent, var3_26 ~= nil)
	setActive(arg0_26.barExtra, var0_26:canBeCustomised())

	local var4_26 = arg0_26.scrollColor.sizeDelta

	var4_26.y = var0_26:canBeCustomised() and var3_0 or var4_0
	arg0_26.scrollColor.sizeDelta = var4_26
	arg0_26.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	setActive(arg0_26.scrollColor, false)
	setActive(arg0_26.scrollColor, true)

	arg0_26.cellSize = arg0_26:calcCellSize()

	arg0_26:updateCells()
	arg0_26:updateLines()
	getProxy(ColoringProxy):SetViewedPage(arg0_26.selectedIndex or 1)
end

function var0_0.updateCells(arg0_27)
	local var0_27 = arg0_27.colorGroups[arg0_27.selectedIndex]
	local var1_27, var2_27 = unpack(var0_27:getConfig("theme"))

	for iter0_27 = 0, var1_27 do
		for iter1_27 = 0, var2_27 do
			arg0_27:updateCell(iter0_27, iter1_27)
		end
	end

	local var3_27 = arg0_27.bg:GetComponent("EventTriggerListener")

	var3_27:RemovePointClickFunc()
	var3_27:RemoveBeginDragFunc()
	var3_27:RemoveDragFunc()
	var3_27:RemoveDragEndFunc()

	local var4_27 = false

	var3_27:AddPointClickFunc(function(arg0_28, arg1_28)
		if not var0_27:canBeCustomised() then
			return
		end

		if var4_27 then
			return
		end

		local var0_28 = LuaHelper.ScreenToLocal(arg0_27.bg, arg1_28.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		local var1_28 = math.floor(-var0_28.y / arg0_27.cellSize.y)
		local var2_28 = math.floor(var0_28.x / arg0_27.cellSize.x)

		if var0_27:getState() == ColorGroup.StateColoring then
			local function var3_28()
				arg0_27:emit(ColoringMediator.EVENT_COLORING_CELL, {
					activityId = arg0_27.activity.id,
					id = var0_27.id,
					cells = arg0_27:searchColoringCells(var0_27, var1_28, var2_28, arg0_27.selectedColorIndex)
				})
			end

			if not var0_27:canBeCustomised() then
				return
			elseif arg0_27.selectedColorIndex == 0 and not var0_27:hasFill(var1_28, var2_28) then
				return
			end

			var3_28()
		end
	end)
	var3_27:AddBeginDragFunc(function()
		var4_27 = false
	end)

	local var5_27 = Vector2.New(arg0_27.bg.rect.width / UnityEngine.Screen.width, arg0_27.bg.rect.height / UnityEngine.Screen.height)

	var3_27:AddDragFunc(function(arg0_31, arg1_31)
		var4_27 = true

		if not IsUnityEditor then
			arg0_27.zoom.enabled = Input.touchCount == 2
		end

		if IsUnityEditor or not arg0_27.zoom.enabled then
			local var0_31 = arg0_27.bg.anchoredPosition

			var0_31.x = var0_31.x + arg1_31.delta.x * var5_27.x
			var0_31.x = math.clamp(var0_31.x, -arg0_27.bg.rect.width * (arg0_27.bg.localScale.x - 1), 0)
			var0_31.y = var0_31.y + arg1_31.delta.y * var5_27.y
			var0_31.y = math.clamp(var0_31.y, 0, arg0_27.bg.rect.height * (arg0_27.bg.localScale.y - 1))
			arg0_27.bg.anchoredPosition = var0_31
		end
	end)
	var3_27:AddDragEndFunc(function()
		var4_27 = false
	end)
end

function var0_0.updateCell(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.colorGroups[arg0_33.selectedIndex]
	local var1_33 = var0_33:getCell(arg1_33, arg2_33)
	local var2_33 = var0_33:getFill(arg1_33, arg2_33)
	local var3_33 = var0_33:getState()

	if var3_33 == ColorGroup.StateFinish or var3_33 == ColorGroup.StateAchieved then
		var2_33 = var1_33
	end

	local var4_33 = arg1_33 .. "_" .. arg2_33
	local var5_33 = arg0_33.cells:Find(var4_33)

	if var1_33 or var2_33 then
		var5_33 = var5_33 or cloneTplTo(arg0_33.cell, arg0_33.cells, var4_33)
		var5_33.sizeDelta = arg0_33.cellSize
		var5_33.anchoredPosition = Vector2((var2_33 or var1_33).column * arg0_33.cellSize.x, -((var2_33 or var1_33).row * arg0_33.cellSize.y))

		local var6_33 = var5_33:Find("image")
		local var7_33 = var5_33:Find("text")

		if var2_33 then
			setImageColor(var6_33, var0_33.colors[var2_33.type])
		else
			setText(var7_33, string.char(string.byte("A") + var1_33.type - 1))
		end

		setActive(var6_33, var2_33)
		setActive(var7_33, not var2_33)
		setActive(var5_33, true)
	elseif var5_33 then
		setActive(var5_33, false)
	end
end

function var0_0.calcCellSize(arg0_34)
	local var0_34 = arg0_34.colorGroups[arg0_34.selectedIndex]
	local var1_34, var2_34 = unpack(var0_34:getConfig("theme"))
	local var3_34 = arg0_34.bg.rect

	return (Vector2.New(var3_34.width / var2_34, var3_34.height / var1_34))
end

function var0_0.updateLines(arg0_35)
	local var0_35 = arg0_35.colorGroups[arg0_35.selectedIndex]
	local var1_35, var2_35 = unpack(var0_35:getConfig("theme"))

	for iter0_35 = 1, var2_35 - 1 do
		local var3_35 = "column_" .. iter0_35
		local var4_35 = arg0_35.lines:Find(var3_35) or cloneTplTo(arg0_35.line, arg0_35.lines, var3_35)

		var4_35.sizeDelta = Vector2.New(1, arg0_35.lines.rect.height)
		var4_35.anchoredPosition = Vector2.New(iter0_35 * arg0_35.cellSize.x - 0.5, 0)
	end

	for iter1_35 = 1, var1_35 - 1 do
		local var5_35 = "row_" .. iter1_35
		local var6_35 = arg0_35.lines:Find(var5_35) or cloneTplTo(arg0_35.line, arg0_35.lines, var5_35)

		var6_35.sizeDelta = Vector2.New(arg0_35.lines.rect.width, 1)
		var6_35.anchoredPosition = Vector2.New(0, -(iter1_35 * arg0_35.cellSize.y - 0.5))
	end
end

function var0_0.searchColoringCells(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = {
		row = arg2_36,
		column = arg3_36,
		color = arg4_36
	}

	if arg1_36:canBeCustomised() then
		return {
			var0_36
		}
	else
		local var1_36 = arg1_36:getConfig("color_id_list")[arg4_36]
		local var2_36 = arg0_36.colorItems[var1_36]
		local var3_36 = {}
		local var4_36 = {}
		local var5_36 = {
			var0_36
		}
		local var6_36 = {
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

		while #var5_36 > 0 and var2_36 > 0 do
			local var7_36 = table.remove(var5_36, 1)

			if not arg1_36:hasFill(var7_36.row, var7_36.column) and var7_36.color == arg4_36 then
				table.insert(var3_36, var7_36)

				var2_36 = var2_36 - 1

				_.each(var6_36, function(arg0_37)
					local var0_37 = arg1_36:getCell(arg0_37.row + var7_36.row, arg0_37.column + var7_36.column)

					if var0_37 and not (_.any(var5_36, function(arg0_38)
						return arg0_38.row == var0_37.row and arg0_38.column == var0_37.column
					end) or _.any(var4_36, function(arg0_39)
						return arg0_39.row == var0_37.row and arg0_39.column == var0_37.column
					end)) then
						table.insert(var5_36, {
							row = var0_37.row,
							column = var0_37.column,
							color = var0_37.type
						})
					end
				end)
			end

			table.insert(var4_36, var7_36)
		end

		return var3_36
	end
end

function var0_0.SearchValidDiagonalColoringCells(arg0_40, arg1_40, arg2_40, arg3_40)
	assert(arg1_40)

	local var0_40 = {}

	if arg1_40:getState() ~= ColorGroup.StateColoring or arg1_40:canBeCustomised() or arg3_40 == 0 then
		return var0_40
	else
		local var1_40, var2_40 = arg1_40:GetAABB()
		local var3_40 = var2_40.x - var1_40.x
		local var4_40 = var2_40.y - var1_40.y

		;(function()
			local var0_41 = var3_40 + var4_40

			for iter0_41 = 0, var0_41 do
				for iter1_41 = 0, iter0_41 do
					local var1_41 = iter0_41 - iter1_41
					local var2_41 = iter1_41

					if var1_41 <= var3_40 and var2_41 <= var4_40 then
						local var3_41 = var2_41 + var1_40.y
						local var4_41 = var1_41 + var1_40.x
						local var5_41 = arg1_40:getCell(var3_41, var4_41)

						if var5_41 and var5_41.type == arg2_40 and not arg1_40:getFill(var3_41, var4_41) then
							table.insert(var0_40, {
								row = var3_41,
								column = var4_41,
								color = arg2_40
							})

							if #var0_40 >= arg3_40 then
								return
							end
						end
					end
				end
			end
		end)()

		return var0_40
	end
end

function var0_0.TryPlayStory(arg0_42)
	local var0_42 = {}
	local var1_42 = arg0_42.selectedIndex

	table.SerialIpairsAsync(var0_42, function(arg0_43, arg1_43, arg2_43)
		if arg0_43 <= var1_42 and arg1_43 then
			pg.NewStoryMgr.GetInstance():Play(arg1_43, arg2_43)
		else
			arg2_43()
		end
	end)
end

function var0_0.onBackPressed(arg0_44)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_44.btnBack)
end

function var0_0.willExit(arg0_45)
	PoolMgr.GetInstance():ReturnUI(arg0_45.coloringUIGroupName, arg0_45.colorgroupbehind)
end

return var0_0
