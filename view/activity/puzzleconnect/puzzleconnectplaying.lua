local var0_0 = class("PuzzleConnectPlaying")
local var1_0 = {
	7,
	5
}
local var2_0 = {
	2,
	5
}

var0_0.game_state_puzzle = 1
var0_0.game_state_connect = 2

local var3_0 = 7

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._ad = findTF(arg0_1._tf, "ad")

	setActive(arg0_1._tf, true)

	arg0_1._gridContent = findTF(arg0_1._tf, "ad/map")
	arg0_1._listContent = findTF(arg0_1._tf, "ad/list/content")
	arg0_1._dragContent = findTF(arg0_1._tf, "ad/dragContent")
	arg0_1._arrowIn = findTF(arg0_1._tf, "ad/arrow/in")
	arg0_1._arrowOut = findTF(arg0_1._tf, "ad/arrow/out")
	arg0_1.gridTpl = findTF(arg0_1._tf, "ad/gridTpl")

	setActive(arg0_1.gridTpl, false)

	arg0_1.itemTpl = findTF(arg0_1._tf, "ad/itemTpl")

	setActive(arg0_1.itemTpl, false)

	arg0_1._iconTpl = findTF(arg0_1._tf, "ad/iconTpl")

	setActive(arg0_1._iconTpl, false)

	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_1._screenRate = arg0_1:getScreentScaleRate()
	arg0_1._grids = {}

	local var0_1 = var1_0[1] * var1_0[2]
	local var1_1 = var1_0[1]

	for iter0_1 = 0, var0_1 - 1 do
		local var2_1 = iter0_1 % var1_1 + 1
		local var3_1 = math.floor(iter0_1 / var1_1) + 1

		table.insert(arg0_1._grids, arg0_1:createGrid(var2_1, var3_1))
	end

	arg0_1._items = {}
	arg0_1._moveItem = arg0_1:createItem(0, 0)

	arg0_1._moveItem:setContent(arg0_1._dragContent)
	arg0_1._moveItem:setActive(false)
	arg0_1._moveItem:setMoveItem(true)

	arg0_1._rangeOffset = Vector2(PuzzleConnectConst.item_bound[1] / 2 + PuzzleConnectConst.item_spacing / 2, PuzzleConnectConst.item_bound[2] / 2 + PuzzleConnectConst.item_spacing / 2)
	arg0_1._boundData = Vector2(PuzzleConnectConst.item_bound[1] + PuzzleConnectConst.item_spacing, PuzzleConnectConst.item_bound[2] + PuzzleConnectConst.item_spacing)
end

function var0_0.addCallback(arg0_2, arg1_2, arg2_2)
	arg0_2._puzzleCallback = arg1_2
	arg0_2._connectCallback = arg2_2
end

function var0_0.setData(arg0_3, arg1_3, arg2_3)
	arg0_3:clear()

	arg0_3._data = arg1_3
	arg0_3._state = arg2_3
	arg0_3._arrowData = arg1_3.arrow_in_out
	arg0_3._mapId = arg1_3.map
	arg0_3._itemId = arg1_3.item
	arg0_3._lineInOut = arg1_3.line_in_out
	arg0_3._mapData = Clone(PuzzleConnectConst.map_data[arg0_3._mapId])
	arg0_3._itemData = Clone(arg1_3.item)
	arg0_3._gridCount = 0

	local var0_3 = findTF(arg0_3._tf, "ad/bg/lineTip/text")
	local var1_3 = findTF(arg0_3._tf, "ad/bg/lineTip")

	if arg0_3._state == var0_0.game_state_connect then
		setText(var0_3, i18n("tolovegame_puzzle_line_tip"))

		var1_3.anchoredPosition = Vector2(84, 454)
	else
		setText(var0_3, i18n("tolovegame_puzzle_puzzle_tip"))

		var1_3.anchoredPosition = Vector2(156, 454)
	end

	arg0_3._arrowIn.anchoredPosition = Vector2((arg0_3._arrowData[1][2] - 1) * arg0_3._boundData.x, -(arg0_3._arrowData[1][1] - 1) * arg0_3._boundData.y)
	findTF(arg0_3._arrowIn, "ad").localEulerAngles = Vector3(0, 0, arg0_3._arrowData[1][3])
	arg0_3._arrowOut.anchoredPosition = Vector2((arg0_3._arrowData[2][2] - 1) * arg0_3._boundData.x, -(arg0_3._arrowData[2][1] - 1) * arg0_3._boundData.y)
	findTF(arg0_3._arrowOut, "ad").localEulerAngles = Vector3(0, 0, arg0_3._arrowData[2][3])

	arg0_3:updateGrids()

	local var2_3 = #arg0_3._itemData > #arg0_3._items and #arg0_3._itemData or #arg0_3._items

	for iter0_3 = 1, var2_3 do
		local var3_3

		if iter0_3 > #arg0_3._items then
			var3_3 = arg0_3:createItem()

			table.insert(arg0_3._items, var3_3)
		else
			var3_3 = arg0_3._items[iter0_3]
		end

		if iter0_3 > #arg0_3._itemData then
			var3_3:setActive(false)
		else
			var3_3:setData(arg0_3._itemData[iter0_3])
			var3_3:setActive(true)
		end
	end

	arg0_3:updateStateUI()
end

function var0_0.updateGrids(arg0_4)
	local var0_4 = arg0_4._lineInOut[1]
	local var1_4 = arg0_4._lineInOut[2]

	for iter0_4 = 1, #arg0_4._grids do
		local var2_4 = arg0_4._grids[iter0_4]:getPoint()
		local var3_4 = arg0_4._mapData[var2_4.v][var2_4.h]

		if var3_4 and var3_4 > 0 then
			arg0_4._gridCount = arg0_4._gridCount + 1
		end

		arg0_4._grids[iter0_4]:setIndex(var3_4, arg0_4._state)

		if var0_4[1] == var2_4.v and var0_4[2] == var2_4.h then
			arg0_4._grids[iter0_4]:setStart(true)
		elseif var1_4[1] == var2_4.v and var1_4[2] == var2_4.h then
			arg0_4._grids[iter0_4]:setEnd(true)
		end

		if arg0_4._grids[iter0_4]:getStart() then
			if arg0_4._state == var0_0.game_state_connect then
				arg0_4._grids[iter0_4]:setLine({
					v = arg0_4._arrowData[1][1],
					h = arg0_4._arrowData[1][2]
				}, nil)
			end
		else
			arg0_4._grids[iter0_4]:clearLine()
		end
	end
end

function var0_0.updateStateUI(arg0_5)
	if arg0_5._state == PuzzleConnectPlaying.game_state_connect then
		setActive(findTF(arg0_5._ad, "bg/puzzle"), false)
		setActive(findTF(arg0_5._ad, "bg/connect"), true)
		setActive(findTF(arg0_5._ad, "list"), false)
		setActive(findTF(arg0_5._ad, "dragContent"), false)
		setActive(arg0_5._arrowIn, true)
		setActive(arg0_5._arrowOut, true)

		arg0_5._ad.anchoredPosition = Vector2(255, 0)
	elseif arg0_5._state == PuzzleConnectPlaying.game_state_puzzle then
		setActive(findTF(arg0_5._ad, "bg/puzzle"), true)
		setActive(findTF(arg0_5._ad, "bg/connect"), false)
		setActive(findTF(arg0_5._ad, "list"), true)
		setActive(findTF(arg0_5._ad, "dragContent"), true)
		setActive(arg0_5._arrowIn, false)
		setActive(arg0_5._arrowOut, false)

		arg0_5._ad.anchoredPosition = Vector2(0, 0)
	end
end

function var0_0.createItem(arg0_6)
	local var0_6 = tf(instantiate(arg0_6.itemTpl))
	local var1_6 = PuzzleConnectItem.New(var0_6, arg0_6._iconTpl)

	var1_6:setActive(true)
	var1_6:setContent(arg0_6._listContent)

	local var2_6 = var1_6:getEventTrigger()

	var2_6:AddBeginDragFunc(function(arg0_7, arg1_7)
		arg0_6:onDragBeginFunc(var1_6, arg0_7, arg1_7)
	end)
	var2_6:AddDragEndFunc(function(arg0_8, arg1_8)
		arg0_6:onDragEndFunc(var1_6, arg0_8, arg1_8)
	end)
	var2_6:AddDragFunc(function(arg0_9, arg1_9)
		arg0_6:onDragFunc(var1_6, arg0_9, arg1_9)
	end)

	return var1_6
end

function var0_0.createGrid(arg0_10, arg1_10, arg2_10)
	local var0_10 = tf(instantiate(arg0_10.gridTpl))
	local var1_10 = PuzzleConnectGrid.New(var0_10, arg1_10, arg2_10, arg0_10._iconTpl)

	var1_10:setContent(arg0_10._gridContent)
	var1_10:setActive(true)

	local var2_10 = var1_10:getEventTrigger()

	var2_10:AddBeginDragFunc(function(arg0_11, arg1_11)
		local var0_11, var1_11, var2_11 = var1_10:getFillItem()

		if var0_11 then
			arg0_10:clearFillItem(var0_11, var2_11)
			var0_11:changeCount(1)
			arg0_10:onDragBeginFunc(var0_11, arg0_11, arg1_11, var1_11)
		end
	end)
	var2_10:AddDragEndFunc(function(arg0_12, arg1_12)
		arg0_10:onDragEndFunc(nil, arg0_12, arg1_12)
	end)
	var2_10:AddDragFunc(function(arg0_13, arg1_13)
		arg0_10:onDragFunc(nil, arg0_13, arg1_13)
	end)

	local var3_10 = var1_10:getLineTrigger()

	var3_10:AddPointDownFunc(function()
		arg0_10:onGridDown(var1_10)
		arg0_10:onGridEnter(var1_10)
	end)
	var3_10:AddPointEnterFunc(function()
		arg0_10:onGridEnter(var1_10)
	end)
	var3_10:AddPointUpFunc(function()
		arg0_10:onGridUp(var1_10)
	end)

	return var1_10
end

function var0_0.onGridDown(arg0_17, arg1_17)
	arg0_17._gridPointStart = true

	if arg1_17:getStart() then
		if arg0_17._lineGrids and #arg0_17._lineGrids > 0 then
			for iter0_17, iter1_17 in ipairs(arg0_17._lineGrids) do
				iter1_17:clearLine()
			end
		end

		arg0_17._lineGrids = {}

		table.insert(arg0_17._lineGrids, arg1_17)
		arg1_17:setLine({
			v = arg0_17._arrowData[1][1],
			h = arg0_17._arrowData[1][2]
		}, nil)
	elseif arg0_17._lineGrids and #arg0_17._lineGrids > 0 and table.contains(arg0_17._lineGrids, arg1_17) then
		for iter2_17 = #arg0_17._lineGrids, 1, -1 do
			if arg0_17._lineGrids[iter2_17] ~= arg1_17 then
				arg0_17._lineGrids[iter2_17]:clearLine()
				table.remove(arg0_17._lineGrids, iter2_17)
			elseif arg0_17._lineGrids[iter2_17] == arg1_17 then
				arg0_17._lineGrids[iter2_17]:clearLine()

				if iter2_17 > 1 then
					arg1_17:setLine(arg0_17._lineGrids[iter2_17 - 1]:getPoint(), nil)

					break
				end

				if iter2_17 == 1 then
					arg1_17:setLine({
						v = arg0_17._arrowData[1][1],
						h = arg0_17._arrowData[1][2]
					}, nil)
				end

				break
			end
		end
	end
end

function var0_0.onGridEnter(arg0_18, arg1_18)
	if not arg0_18._gridPointStart then
		return
	end

	if not arg0_18._lineGrids or #arg0_18._lineGrids == 0 then
		return
	end

	if table.contains(arg0_18._lineGrids, arg1_18) then
		if arg0_18._lineGrids[#arg0_18._lineGrids] ~= arg1_18 then
			for iter0_18 = #arg0_18._lineGrids, 1, -1 do
				if arg0_18._lineGrids[iter0_18] ~= arg1_18 then
					arg0_18._lineGrids[iter0_18]:clearLine()
					table.remove(arg0_18._lineGrids, iter0_18)
				elseif arg0_18._lineGrids[iter0_18] == arg1_18 then
					arg0_18._lineGrids[iter0_18]:clearLine()

					if iter0_18 > 1 then
						arg1_18:setLine(arg0_18._lineGrids[iter0_18 - 1]:getPoint(), nil)

						break
					end

					if iter0_18 == 1 then
						arg1_18:setLine({
							v = arg0_18._arrowData[1][1],
							h = arg0_18._arrowData[1][2]
						}, nil)
					end

					break
				end
			end
		end

		return
	end

	local var0_18 = arg0_18._lineGrids[#arg0_18._lineGrids]

	if not arg0_18:checkGridLineAble(arg1_18, var0_18) then
		return
	end

	table.insert(arg0_18._lineGrids, arg1_18)

	if #arg0_18._lineGrids > 1 then
		local var1_18 = arg0_18._lineGrids[#arg0_18._lineGrids - 1]
		local var2_18 = arg0_18._lineGrids[#arg0_18._lineGrids]

		var1_18:setLine(nil, var2_18:getPoint())
		var2_18:setLine(var1_18:getPoint(), nil)
	end
end

function var0_0.onGridUp(arg0_19, arg1_19)
	arg0_19._gridPointStart = false

	if not arg0_19._lineGrids then
		return
	end

	if arg0_19:checkLineComplete() and arg0_19._connectCallback then
		arg0_19._connectCallback()
	end

	if #arg0_19._lineGrids == arg0_19._gridCount then
		for iter0_19 = 1, #arg0_19._grids do
			if arg0_19._grids[iter0_19]:getStart() then
				arg0_19._grids[iter0_19]:clearLine()

				if arg0_19._state == var0_0.game_state_connect then
					arg0_19._grids[iter0_19]:setLine({
						v = arg0_19._arrowData[1][1],
						h = arg0_19._arrowData[1][2]
					}, nil)
				end
			else
				arg0_19._grids[iter0_19]:clearLine()
			end
		end

		arg0_19._lineGrids = {}
	end
end

function var0_0.checkGridLineAble(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20:getPoint()
	local var1_20 = arg2_20:getPoint()

	if math.abs(var0_20.h - var1_20.h) > 1 then
		return false
	end

	if math.abs(var0_20.v - var1_20.v) > 1 then
		return false
	end

	return true
end

function var0_0.checkLineComplete(arg0_21)
	if arg0_21._lineGrids and #arg0_21._lineGrids == arg0_21._gridCount and arg0_21._lineGrids[1]:getStart() and arg0_21._lineGrids[#arg0_21._lineGrids]:getEnd() then
		return true
	end

	return false
end

function var0_0.clearFillItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg1_22:getId()

	for iter0_22, iter1_22 in ipairs(arg0_22._grids) do
		local var1_22, var2_22, var3_22 = iter1_22:getFillItem()

		if var1_22 and var0_22 == var1_22:getId() and arg2_22 == var3_22 then
			iter1_22:clearFillItem()
		end
	end
end

function var0_0.onDragBeginFunc(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	if arg0_23._state ~= var0_0.game_state_puzzle then
		return
	end

	if not arg1_23 then
		return
	end

	if arg1_23:getCount() == 0 then
		return
	end

	if arg0_23._dragItem then
		return
	end

	arg0_23._dragItem = arg1_23

	arg0_23._dragItem:setDraging(true)

	local var0_23
	local var1_23

	if not arg4_23 then
		var0_23 = arg0_23._uiCamera:ScreenToWorldPoint(arg3_23.position)
		var1_23 = arg3_23.position
	else
		var0_23 = arg0_23._dragItem:getItemIconWorld(arg4_23)
		var1_23 = arg0_23._uiCamera:WorldToScreenPoint(var0_23)
	end

	local var2_23 = arg0_23._dragContent:InverseTransformPoint(var0_23)
	local var3_23 = arg0_23._listContent:InverseTransformPoint(var0_23)
	local var4_23 = arg1_23:getPosition()

	arg0_23._dragItemStartPosition = var1_23
	arg0_23._dragItemContentPosition = var2_23
	arg0_23._dragItemOffsetPosition = Vector2(var3_23.x - var4_23.x, var3_23.y - var4_23.y)

	arg0_23._moveItem:setData(arg0_23._dragItem:getData())
	arg0_23._moveItem:setActive(true)

	arg0_23._movePosition = Vector2(0, 0)

	arg0_23:updateMovePosition()
end

function var0_0.getFillId(arg0_24)
	if not arg0_24._fillId then
		arg0_24._fillId = 1
	end

	arg0_24._fillId = arg0_24._fillId + 1

	return arg0_24._fillId
end

function var0_0.onDragEndFunc(arg0_25, arg1_25, arg2_25, arg3_25)
	if arg0_25._dragItem then
		if arg0_25._fillAll then
			arg0_25._dragItem:changeCount(-1)

			local var0_25 = arg0_25:getFillId()

			for iter0_25, iter1_25 in ipairs(arg0_25._prepareGrids) do
				iter1_25:setFillItem(arg0_25._dragItem, iter0_25, var0_25)
			end
		end

		arg0_25._dragItem:setDraging(false)

		arg0_25._dragItem = nil

		arg0_25._moveItem:setActive(false)
		arg0_25:clearGridPrepare()
	end

	local var1_25 = true

	for iter2_25, iter3_25 in ipairs(arg0_25._grids) do
		if var1_25 and iter3_25:getMapIndex() > 0 and not iter3_25:getComplete() then
			var1_25 = false
		end
	end

	if var1_25 and arg0_25._puzzleCallback then
		arg0_25._puzzleCallback()
	end
end

function var0_0.onDragFunc(arg0_26, arg1_26, arg2_26, arg3_26)
	if arg0_26._state ~= var0_0.game_state_puzzle then
		return
	end

	if not arg0_26._dragItem then
		return
	end

	arg0_26:updateMovePosition(arg3_26.position)
	arg0_26:checkMoveItemPuzzle()
end

function var0_0.checkMoveItemPuzzle(arg0_27)
	if not arg0_27._gridOffsetX then
		arg0_27._gridOffsetX = PuzzleConnectConst.item_bound[1] / 2
	end

	local var0_27 = arg0_27._moveItem:getPuzzleWorldPos()
	local var1_27 = arg0_27._moveItem:getColor()

	arg0_27:clearGridPrepare()

	local var2_27 = 0
	local var3_27 = 0

	arg0_27._prepareGrids = {}

	for iter0_27 = 1, #var0_27 do
		local var4_27 = arg0_27._gridContent:InverseTransformPoint(var0_27[iter0_27])

		for iter1_27, iter2_27 in ipairs(arg0_27._grids) do
			if not iter2_27:getPrepare() then
				local var5_27 = iter2_27:getPosition()
				local var6_27 = Vector2(math.abs(var4_27.x + arg0_27._gridOffsetX - var5_27.x), math.abs(var4_27.y - var5_27.y))
				local var7_27 = false

				if var6_27.x <= arg0_27._rangeOffset.x and var6_27.y <= arg0_27._rangeOffset.y then
					var7_27 = true
				end

				if var7_27 then
					if not iter2_27:getFill() then
						if iter2_27:getUnlock() then
							var2_27 = var2_27 + 1
						end

						var3_27 = var3_27 + 1
					end

					if not iter2_27:getFill() then
						iter2_27:setPrepare(var1_27)
						table.insert(arg0_27._prepareGrids, iter2_27)
					end

					break
				end
			end
		end
	end

	if var2_27 == #var0_27 then
		arg0_27._fillSuccess = true
	else
		arg0_27._fillSuccess = false
	end

	if var3_27 == #var0_27 then
		arg0_27._fillAll = true
	else
		arg0_27._fillAll = false
	end

	for iter3_27 = 1, #arg0_27._prepareGrids do
		if arg0_27._fillSuccess then
			arg0_27._prepareGrids[iter3_27]:setPrepareAlpha(PuzzleConnectConst.color_green)
		else
			arg0_27._prepareGrids[iter3_27]:setPrepareAlpha(PuzzleConnectConst.color_red)
		end
	end
end

function var0_0.clearGridPrepare(arg0_28)
	arg0_28._prepareGrids = {}
	arg0_28._fillSuccess = false
	arg0_28._fillAll = false

	for iter0_28, iter1_28 in ipairs(arg0_28._grids) do
		iter1_28:clearPrepare()
	end
end

function var0_0.updateMovePosition(arg0_29, arg1_29)
	if arg1_29 then
		arg0_29._movePosition.x = -arg0_29._dragItemOffsetPosition.x + arg0_29._dragItemContentPosition.x + (arg1_29.x - arg0_29._dragItemStartPosition.x) * arg0_29._screenRate.x
		arg0_29._movePosition.y = -arg0_29._dragItemOffsetPosition.y + arg0_29._dragItemContentPosition.y + (arg1_29.y - arg0_29._dragItemStartPosition.y) * arg0_29._screenRate.y
	else
		arg0_29._movePosition.x = arg0_29._dragItemContentPosition.x
		arg0_29._movePosition.y = arg0_29._dragItemContentPosition.y
	end

	arg0_29._moveItem:setPosition(arg0_29._movePosition)
end

function var0_0.reset(arg0_30)
	if arg0_30._state == PuzzleConnectPlaying.game_state_puzzle then
		arg0_30:setData(arg0_30._data, arg0_30._state)
	else
		for iter0_30 = 1, #arg0_30._grids do
			if arg0_30._grids[iter0_30]:getStart() then
				arg0_30._grids[iter0_30]:clearLine()

				if arg0_30._state == var0_0.game_state_connect then
					arg0_30._grids[iter0_30]:setLine({
						v = arg0_30._arrowData[1][1],
						h = arg0_30._arrowData[1][2]
					}, nil)
				end
			else
				arg0_30._grids[iter0_30]:clearLine()
			end
		end

		arg0_30._lineGrids = {}
	end
end

function var0_0.getPointStr(arg0_31, arg1_31)
	return "(" .. arg1_31.x .. ":" .. arg1_31.y .. ")"
end

function var0_0.getScreentScaleRate(arg0_32)
	local var0_32 = UnityEngine.Screen.width
	local var1_32 = UnityEngine.Screen.height
	local var2_32 = tf(GameObject.Find("UICamera/Canvas"))
	local var3_32 = var2_32.sizeDelta.x
	local var4_32 = var2_32.sizeDelta.y

	return Vector2(var3_32 / var0_32, var4_32 / var1_32)
end

function var0_0.clear(arg0_33)
	arg0_33._dragGrid = nil

	if arg0_33._prepareGrids then
		arg0_33._prepareGrids = {}
	end

	if arg0_33._moveItem then
		arg0_33._moveItem:setActive(false)
	end

	if arg0_33._dragItem then
		arg0_33._dragItem:setDraging(false)

		arg0_33._dragItem = nil
	end
end

function var0_0.dispose(arg0_34)
	return
end

return var0_0
