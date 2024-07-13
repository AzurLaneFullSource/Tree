local var0_0 = class("PipeRectControll")
local var1_0
local var2_0 = 140
local var3_0 = 4
local var4_0 = Vector2(0, 90)

local function var5_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._rectItem = arg0_1
			arg0_2._dragContent = arg1_1
			arg0_2._rectImg = findTF(arg0_2._rectItem, "img")
			arg0_2._rectSelect = findTF(arg0_2._rectItem, "select")
			arg0_2._rectParent = arg0_2._rectItem.parent
			arg0_2._eventCallback = arg2_1
			arg0_2._eventTrigger = GetOrAddComponent(arg0_2._rectItem, typeof(EventTriggerListener))
			arg0_2._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
			arg0_2._dragPos = Vector2(0, 0)
			arg0_2._draging = false

			arg0_2._eventTrigger:AddBeginDragFunc(function(arg0_3, arg1_3, arg2_3)
				if var1_0.startSettlement then
					return
				end

				if arg0_2._index == 1 and not arg0_2:isTweening() then
					arg0_2._screenScaleRate = arg0_2:getScreentScaleRate()
					arg0_2._draging = true
					var1_0.draging = true
					var1_0.dragItem = arg0_2._itemData
					var1_0.dragScreenPos = arg1_3.position
					arg0_2._startDragPos = arg1_3.position
					arg0_2._startTfPos = arg0_2._rectImg.anchoredPosition

					local var0_3 = arg0_2._uiCamera:ScreenToWorldPoint(arg1_3.position)
					local var1_3 = arg0_2._rectImg:InverseTransformPoint(var0_3)

					var1_3.x = var1_3.x - var2_0 / 2
					var1_3.y = var1_3.y + var4_0.y
					arg0_2._startOffsetPos = var1_3

					setParent(arg0_2._rectImg, arg0_2._dragContent, false)
				end
			end)
			arg0_2._eventTrigger:AddDragFunc(function(arg0_4, arg1_4, arg2_4)
				if not arg0_2._draging then
					return
				end

				if var1_0.startSettlement then
					arg0_2:stopDrag()

					return
				end

				var1_0.dragScreenPos = Vector2(arg1_4.position.x, arg1_4.position.y + var4_0.y)
				arg0_2._dragPos.x = arg0_2._startOffsetPos.x + (arg1_4.position.x - arg0_2._startDragPos.x) * arg0_2._screenScaleRate.x
				arg0_2._dragPos.y = arg0_2._startOffsetPos.y + (arg1_4.position.y - arg0_2._startDragPos.y) * arg0_2._screenScaleRate.y
				arg0_2._rectImg.anchoredPosition = arg0_2._dragPos
			end)
			arg0_2._eventTrigger:AddDragEndFunc(function(arg0_5, arg1_5, arg2_5)
				if var1_0.startSettlement then
					return
				end

				if arg0_2._index == 1 then
					arg0_2:stopDrag()
				end
			end)
			arg0_2:setActive(false)
		end,
		stopDrag = function(arg0_6)
			if arg0_6._draging then
				arg0_6._draging = false
				var1_0.draging = false
				var1_0.dragItem = nil
				var1_0.dragScreenPos = nil

				SetParent(arg0_6._rectImg, arg0_6._rectItem, false)

				if arg0_6._startTfPos then
					arg0_6._rectImg.anchoredPosition = Vector2(0, 0)
				end
			end
		end,
		getScreentScaleRate = function(arg0_7)
			local var0_7 = UnityEngine.Screen.width
			local var1_7 = UnityEngine.Screen.height
			local var2_7 = tf(GameObject.Find("UICamera/Canvas"))
			local var3_7 = var2_7.sizeDelta.x
			local var4_7 = var2_7.sizeDelta.y

			return Vector2(var3_7 / var0_7, var4_7 / var1_7)
		end,
		setItem = function(arg0_8, arg1_8)
			arg0_8._itemData = arg1_8

			if arg0_8._itemData then
				arg0_8:setImg(arg0_8._itemData.img)
				arg0_8:setActive(true)
			else
				arg0_8:setActive(false)
			end
		end,
		isTweening = function(arg0_9)
			return LeanTween.isTweening(go(arg0_9._rectItem))
		end,
		getItem = function(arg0_10)
			return arg0_10._itemData
		end,
		setActive = function(arg0_11, arg1_11)
			setActive(arg0_11._rectItem, arg1_11)
		end,
		setIndex = function(arg0_12, arg1_12, arg2_12)
			if not arg2_12 then
				arg0_12:setPostionByIndex(arg1_12)
			else
				arg0_12:fadeTo(arg1_12)
			end

			arg0_12._index = arg1_12

			setActive(arg0_12._rectSelect, arg1_12 == 1)
		end,
		setImg = function(arg0_13, arg1_13)
			setImageSprite(arg0_13._rectImg, var1_0.GetSprite(arg1_13))
		end,
		fadeTo = function(arg0_14, arg1_14)
			arg0_14:clearTween()

			local var0_14 = arg0_14._rectItem.anchoredPosition.x
			local var1_14 = arg0_14:getIndexPosition(arg1_14).x
			local var2_14 = Vector2(0, arg0_14._rectItem.anchoredPosition.y)

			LeanTween.value(go(arg0_14._rectItem), var0_14, var1_14, 0.1):setOnUpdate(System.Action_float(function(arg0_15)
				var2_14.x = arg0_15
				arg0_14._rectItem.anchoredPosition = var2_14
			end)):setOnComplete(System.Action(function()
				return
			end))
		end,
		getIndexPosition = function(arg0_17, arg1_17)
			return Vector2(-(arg1_17 - 1) * var2_0, 0)
		end,
		setPostionByIndex = function(arg0_18, arg1_18)
			local var0_18 = arg0_18:getIndexPosition(arg1_18)

			arg0_18._rectItem.anchoredPosition = var0_18
		end,
		getIndex = function(arg0_19)
			return arg0_19._index
		end,
		isDraging = function(arg0_20)
			return arg0_20._draging
		end,
		getDragScreenPos = function(arg0_21)
			return arg0_21._dragScreenPos
		end,
		clearTween = function(arg0_22)
			if LeanTween.isTweening(go(arg0_22._rectItem)) then
				LeanTween.cancel(go(arg0_22._rectItem))
			end
		end,
		setVisible = function(arg0_23, arg1_23)
			setActive(arg0_23._rectItem, arg1_23)
		end,
		clear = function(arg0_24)
			arg0_24._index = nil
			arg0_24._itemData = nil

			arg0_24:clearTween()
			arg0_24:setVisible(false)
		end,
		dispose = function(arg0_25)
			ClearEventTrigger(arg0_25._eventTrigger)
		end
	}

	var0_1:ctor()

	return var0_1
end

function var0_0.Ctor(arg0_26, arg1_26, arg2_26, arg3_26)
	var1_0 = PipeGameVo
	arg0_26._rectTf = arg1_26
	arg0_26._dragPos = arg2_26
	arg0_26._content = findTF(arg0_26._rectTf, "pos")
	arg0_26._event = arg3_26
	arg0_26.rectItems = {}

	local function var0_26()
		arg0_26:onRectEventCall()
	end

	for iter0_26 = 1, var3_0 do
		local var1_26 = PipeGameVo.GetTplItemFromPool(PipeGameConst.tpl_rect_item, arg0_26._content)
		local var2_26 = var5_0(var1_26, arg0_26._dragPos, var0_26)

		table.insert(arg0_26.rectItems, var2_26)
	end
end

function var0_0.start(arg0_28)
	arg0_28.rectDatas = arg0_28:getRandomRectDatas()

	arg0_28:fillRectItem()
end

function var0_0.step(arg0_29, arg1_29)
	return
end

function var0_0.stop(arg0_30)
	return
end

function var0_0.clear(arg0_31)
	arg0_31.rectDatas = {}

	for iter0_31 = 1, #arg0_31.rectItems do
		arg0_31.rectItems[iter0_31]:clear()
	end

	arg0_31._draging = false
end

function var0_0.fillRectItem(arg0_32)
	if #arg0_32.rectDatas >= 0 then
		for iter0_32 = 1, #arg0_32.rectItems do
			local var0_32 = arg0_32.rectItems[iter0_32]

			var0_32:setIndex(iter0_32)

			if var0_32:getItem() == nil then
				local var1_32 = table.remove(arg0_32.rectDatas, 1)

				var0_32:setItem(PipeGameConst.map_item_data[var1_32])
			end
		end
	end
end

function var0_0.onRectEventCall(arg0_33, arg1_33, arg2_33)
	return
end

function var0_0.stopTopDrag(arg0_34)
	arg0_34.rectItems[1]:stopDrag()
end

function var0_0.getTopData(arg0_35)
	return arg0_35.rectItems[1]:getItem()
end

function var0_0.removeTopRectData(arg0_36)
	local var0_36 = table.remove(arg0_36.rectItems, 1)

	table.insert(arg0_36.rectItems, var0_36)
	var0_36:setPostionByIndex(var3_0 + 1, false)

	local var1_36 = table.remove(arg0_36.rectDatas, 1)

	var0_36:setItem(PipeGameConst.map_item_data[var1_36])

	for iter0_36 = 1, #arg0_36.rectItems do
		arg0_36.rectItems[iter0_36]:setIndex(iter0_36, true)
	end
end

function var0_0.getRandomRectDatas(arg0_37)
	local var0_37 = {}
	local var1_37 = var1_0.GetRoundData().id
	local var2_37
	local var3_37 = PipeGameConst.map_rect_data[var1_37].list
	local var4_37 = PipeGameConst.map_rect_list[var3_37[math.random(1, #var3_37)]]

	for iter0_37, iter1_37 in ipairs(var4_37) do
		local var5_37 = iter1_37[1]
		local var6_37 = iter1_37[2]

		for iter2_37 = 1, var6_37 do
			table.insert(var0_37, var5_37)
		end
	end

	return arg0_37:shuffleArray(var0_37)
end

function var0_0.shuffleArray(arg0_38, arg1_38)
	for iter0_38 = #arg1_38, 2, -1 do
		local var0_38 = math.random(iter0_38)

		arg1_38[iter0_38], arg1_38[var0_38] = arg1_38[var0_38], arg1_38[iter0_38]
	end

	return arg1_38
end

function var0_0.dispose(arg0_39)
	for iter0_39 = 1, #arg0_39.rectItems do
		arg0_39.rectItems[iter0_39]:dispose()
	end
end

return var0_0
