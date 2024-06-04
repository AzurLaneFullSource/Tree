local var0 = class("PipeRectControll")
local var1
local var2 = 140
local var3 = 4
local var4 = Vector2(0, 90)

local function var5(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0._rectItem = arg0
			arg0._dragContent = arg1
			arg0._rectImg = findTF(arg0._rectItem, "img")
			arg0._rectSelect = findTF(arg0._rectItem, "select")
			arg0._rectParent = arg0._rectItem.parent
			arg0._eventCallback = arg2
			arg0._eventTrigger = GetOrAddComponent(arg0._rectItem, typeof(EventTriggerListener))
			arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
			arg0._dragPos = Vector2(0, 0)
			arg0._draging = false

			arg0._eventTrigger:AddBeginDragFunc(function(arg0, arg1, arg2)
				if var1.startSettlement then
					return
				end

				if arg0._index == 1 and not arg0:isTweening() then
					arg0._screenScaleRate = arg0:getScreentScaleRate()
					arg0._draging = true
					var1.draging = true
					var1.dragItem = arg0._itemData
					var1.dragScreenPos = arg1.position
					arg0._startDragPos = arg1.position
					arg0._startTfPos = arg0._rectImg.anchoredPosition

					local var0 = arg0._uiCamera:ScreenToWorldPoint(arg1.position)
					local var1 = arg0._rectImg:InverseTransformPoint(var0)

					var1.x = var1.x - var2 / 2
					var1.y = var1.y + var4.y
					arg0._startOffsetPos = var1

					setParent(arg0._rectImg, arg0._dragContent, false)
				end
			end)
			arg0._eventTrigger:AddDragFunc(function(arg0, arg1, arg2)
				if not arg0._draging then
					return
				end

				if var1.startSettlement then
					arg0:stopDrag()

					return
				end

				var1.dragScreenPos = Vector2(arg1.position.x, arg1.position.y + var4.y)
				arg0._dragPos.x = arg0._startOffsetPos.x + (arg1.position.x - arg0._startDragPos.x) * arg0._screenScaleRate.x
				arg0._dragPos.y = arg0._startOffsetPos.y + (arg1.position.y - arg0._startDragPos.y) * arg0._screenScaleRate.y
				arg0._rectImg.anchoredPosition = arg0._dragPos
			end)
			arg0._eventTrigger:AddDragEndFunc(function(arg0, arg1, arg2)
				if var1.startSettlement then
					return
				end

				if arg0._index == 1 then
					arg0:stopDrag()
				end
			end)
			arg0:setActive(false)
		end,
		stopDrag = function(arg0)
			if arg0._draging then
				arg0._draging = false
				var1.draging = false
				var1.dragItem = nil
				var1.dragScreenPos = nil

				SetParent(arg0._rectImg, arg0._rectItem, false)

				if arg0._startTfPos then
					arg0._rectImg.anchoredPosition = Vector2(0, 0)
				end
			end
		end,
		getScreentScaleRate = function(arg0)
			local var0 = UnityEngine.Screen.width
			local var1 = UnityEngine.Screen.height
			local var2 = tf(GameObject.Find("UICamera/Canvas"))
			local var3 = var2.sizeDelta.x
			local var4 = var2.sizeDelta.y

			return Vector2(var3 / var0, var4 / var1)
		end,
		setItem = function(arg0, arg1)
			arg0._itemData = arg1

			if arg0._itemData then
				arg0:setImg(arg0._itemData.img)
				arg0:setActive(true)
			else
				arg0:setActive(false)
			end
		end,
		isTweening = function(arg0)
			return LeanTween.isTweening(go(arg0._rectItem))
		end,
		getItem = function(arg0)
			return arg0._itemData
		end,
		setActive = function(arg0, arg1)
			setActive(arg0._rectItem, arg1)
		end,
		setIndex = function(arg0, arg1, arg2)
			if not arg2 then
				arg0:setPostionByIndex(arg1)
			else
				arg0:fadeTo(arg1)
			end

			arg0._index = arg1

			setActive(arg0._rectSelect, arg1 == 1)
		end,
		setImg = function(arg0, arg1)
			setImageSprite(arg0._rectImg, var1.GetSprite(arg1))
		end,
		fadeTo = function(arg0, arg1)
			arg0:clearTween()

			local var0 = arg0._rectItem.anchoredPosition.x
			local var1 = arg0:getIndexPosition(arg1).x
			local var2 = Vector2(0, arg0._rectItem.anchoredPosition.y)

			LeanTween.value(go(arg0._rectItem), var0, var1, 0.1):setOnUpdate(System.Action_float(function(arg0)
				var2.x = arg0
				arg0._rectItem.anchoredPosition = var2
			end)):setOnComplete(System.Action(function()
				return
			end))
		end,
		getIndexPosition = function(arg0, arg1)
			return Vector2(-(arg1 - 1) * var2, 0)
		end,
		setPostionByIndex = function(arg0, arg1)
			local var0 = arg0:getIndexPosition(arg1)

			arg0._rectItem.anchoredPosition = var0
		end,
		getIndex = function(arg0)
			return arg0._index
		end,
		isDraging = function(arg0)
			return arg0._draging
		end,
		getDragScreenPos = function(arg0)
			return arg0._dragScreenPos
		end,
		clearTween = function(arg0)
			if LeanTween.isTweening(go(arg0._rectItem)) then
				LeanTween.cancel(go(arg0._rectItem))
			end
		end,
		setVisible = function(arg0, arg1)
			setActive(arg0._rectItem, arg1)
		end,
		clear = function(arg0)
			arg0._index = nil
			arg0._itemData = nil

			arg0:clearTween()
			arg0:setVisible(false)
		end,
		dispose = function(arg0)
			ClearEventTrigger(arg0._eventTrigger)
		end
	}

	var0:ctor()

	return var0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	var1 = PipeGameVo
	arg0._rectTf = arg1
	arg0._dragPos = arg2
	arg0._content = findTF(arg0._rectTf, "pos")
	arg0._event = arg3
	arg0.rectItems = {}

	local function var0()
		arg0:onRectEventCall()
	end

	for iter0 = 1, var3 do
		local var1 = PipeGameVo.GetTplItemFromPool(PipeGameConst.tpl_rect_item, arg0._content)
		local var2 = var5(var1, arg0._dragPos, var0)

		table.insert(arg0.rectItems, var2)
	end
end

function var0.start(arg0)
	arg0.rectDatas = arg0:getRandomRectDatas()

	arg0:fillRectItem()
end

function var0.step(arg0, arg1)
	return
end

function var0.stop(arg0)
	return
end

function var0.clear(arg0)
	arg0.rectDatas = {}

	for iter0 = 1, #arg0.rectItems do
		arg0.rectItems[iter0]:clear()
	end

	arg0._draging = false
end

function var0.fillRectItem(arg0)
	if #arg0.rectDatas >= 0 then
		for iter0 = 1, #arg0.rectItems do
			local var0 = arg0.rectItems[iter0]

			var0:setIndex(iter0)

			if var0:getItem() == nil then
				local var1 = table.remove(arg0.rectDatas, 1)

				var0:setItem(PipeGameConst.map_item_data[var1])
			end
		end
	end
end

function var0.onRectEventCall(arg0, arg1, arg2)
	return
end

function var0.stopTopDrag(arg0)
	arg0.rectItems[1]:stopDrag()
end

function var0.getTopData(arg0)
	return arg0.rectItems[1]:getItem()
end

function var0.removeTopRectData(arg0)
	local var0 = table.remove(arg0.rectItems, 1)

	table.insert(arg0.rectItems, var0)
	var0:setPostionByIndex(var3 + 1, false)

	local var1 = table.remove(arg0.rectDatas, 1)

	var0:setItem(PipeGameConst.map_item_data[var1])

	for iter0 = 1, #arg0.rectItems do
		arg0.rectItems[iter0]:setIndex(iter0, true)
	end
end

function var0.getRandomRectDatas(arg0)
	local var0 = {}
	local var1 = var1.GetRoundData().id
	local var2
	local var3 = PipeGameConst.map_rect_data[var1].list
	local var4 = PipeGameConst.map_rect_list[var3[math.random(1, #var3)]]

	for iter0, iter1 in ipairs(var4) do
		local var5 = iter1[1]
		local var6 = iter1[2]

		for iter2 = 1, var6 do
			table.insert(var0, var5)
		end
	end

	return arg0:shuffleArray(var0)
end

function var0.shuffleArray(arg0, arg1)
	for iter0 = #arg1, 2, -1 do
		local var0 = math.random(iter0)

		arg1[iter0], arg1[var0] = arg1[var0], arg1[iter0]
	end

	return arg1
end

function var0.dispose(arg0)
	for iter0 = 1, #arg0.rectItems do
		arg0.rectItems[iter0]:dispose()
	end
end

return var0
