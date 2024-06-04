local var0 = class("PipeMapControl")
local var1
local var2 = "left"
local var3 = "right"
local var4 = "top"
local var5 = "bottom"
local var6 = 0
local var7 = 0
local var8 = 1
local var9 = 2
local var10 = 1
local var11 = 2

var0.CLICK_MAP_ITEM = "click map item"

local function var12(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0._itemTf = arg0
			arg0._index = arg1
			arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
			arg0._canvasGroup = GetComponent(arg0._itemTf, typeof(CanvasGroup))
			arg0._animTf = findTF(arg0._itemTf, "anim")
			arg0._imgTf = findTF(arg0._animTf, "img")
			arg0._imgFullTf = findTF(arg0._animTf, "imgFull")
			arg0._animator = GetComponent(findTF(arg0._itemTf, "anim"), typeof(Animator))
			arg0._eventCallback = arg2
			arg0._freeze = false
			arg0._dftEvent = GetComponent(arg0._animTf, typeof(DftAniEvent))
			arg0._clickTf = findTF(arg0._animTf, "click")
			arg0._eventTriggerListener = GetOrAddComponent(arg0._clickTf, typeof(EventTriggerListener))

			arg0._eventTriggerListener:AddPointDownFunc(function()
				if not arg0._data and arg0._eventCallback then
					arg0._eventCallback(var0.CLICK_MAP_ITEM, arg0)
				end
			end)
		end,
		setData = function(arg0, arg1)
			arg0._data = arg1

			if arg0._data then
				arg0._animationFlag = false

				arg0:loadImg(arg0._data.img, arg0._data.img_full)
				arg0:setItemVisible(true)
				arg0:setAlpha(1)
			else
				arg0:setItemVisible(false)
			end
		end,
		getData = function(arg0)
			return arg0._data
		end,
		setTempData = function(arg0, arg1)
			if arg0._data then
				warning("已经存在格子数据，无需设置预览数据")

				return
			end

			arg0._tempData = arg1

			arg0:loadImg(arg0._tempData.img, arg0._tempData.img_full)
			arg0:setItemVisible(true)
			arg0:setAlpha(0.5)
		end,
		getTempData = function(arg0)
			return arg0._tempData
		end,
		loadImg = function(arg0, arg1, arg2)
			setImageSprite(arg0._imgTf, var1.GetSprite(arg1))
			setImageSprite(arg0._imgFullTf, var1.GetSprite(arg2))
		end,
		setItemVisible = function(arg0, arg1)
			setActive(arg0._imgTf, arg1)
			setActive(arg0._imgFullTf, arg1)
		end,
		changeTempToReal = function(arg0)
			if arg0._tempData then
				arg0:setData(arg0._tempData)

				arg0._tempData = nil
			end
		end,
		setTriggerName = function(arg0, arg1)
			if arg0._animationFlag then
				return
			end

			arg0._animationFlag = true

			if arg0.animTriggerName then
				arg0._animator:ResetTrigger(arg0.animTriggerName)
			end

			arg0.animTriggerName = arg1
		end,
		playAnim = function(arg0, arg1)
			arg0._success = true

			if arg0.animTriggerName then
				arg0._animator:SetTrigger(arg0.animTriggerName)

				if arg1 then
					arg0._dftEvent:SetEndEvent(function()
						arg1()
						arg0._dftEvent:SetEndEvent(nil)
					end)
				end
			end
		end,
		getAnimationFlag = function(arg0)
			return arg0._animationFlag
		end,
		setVisible = function(arg0, arg1)
			setActive(arg0._itemTf, arg1)
		end,
		freeze = function(arg0, arg1)
			arg0._freeze = arg1

			arg0:setVisible(not arg0._freeze)
		end,
		getFreeze = function(arg0)
			return arg0._freeze
		end,
		getSuccess = function(arg0)
			return arg0._success
		end,
		setSelect = function(arg0, arg1)
			arg0:setTempData(arg1)
		end,
		setAlpha = function(arg0, arg1)
			arg0._canvasGroup.alpha = arg1
		end,
		setPosition = function(arg0, arg1)
			arg0._itemTf.anchoredPosition = arg1
		end,
		getIndex = function(arg0)
			return arg0._index
		end,
		clear = function(arg0)
			arg0._data = nil
			arg0._tempData = nil
			arg0._success = false

			arg0:setItemVisible(false)
			arg0:setAlpha(1)
		end,
		getScreenPos = function(arg0, arg1)
			if not arg0._screenPos then
				arg0:updateScreenPos()
			end

			return arg0._screenPos
		end,
		updateScreenPos = function(arg0)
			arg0._screenPos = arg0._uiCamera:WorldToScreenPoint(arg0._itemTf.position)
		end,
		getDirect = function(arg0)
			return arg0._data.direct
		end,
		dispose = function(arg0)
			ClearEventTrigger(arg0._eventTriggerListener)
		end
	}

	var0:ctor()

	return var0
end

function var0.Ctor(arg0, arg1, arg2)
	var1 = PipeGameVo
	arg0._mapTf = arg1
	arg0._eventCallback = arg2
	arg0._mapItems = {}

	function arg0.mapItemCallback(arg0, arg1)
		if var0.CLICK_MAP_ITEM == arg0 then
			if arg0._dragTempItem then
				arg0._dragTempItem:clear()

				arg0._dragTempItem = nil
			end

			arg0._eventCallback(PipeGameEvent.STOP_RECT_DRAG)

			if not arg0._clickTempItem then
				arg0._clickTempItem = arg1

				arg0._eventCallback(PipeGameEvent.SET_TOP_RECT)
			elseif arg0._clickTempItem ~= arg1 then
				arg0._clickTempItem:clear()

				arg0._clickTempItem = arg1

				arg0._eventCallback(PipeGameEvent.SET_TOP_RECT)
			elseif arg0._clickTempItem:getTempData() then
				arg0._clickTempItem:changeTempToReal()

				arg0._clickTempItem = nil

				arg0._eventCallback(PipeGameEvent.REMOVE_RECT_TOP)

				if arg0:checkFull() then
					arg0:startOverAniamtion()
				end
			end
		end
	end
end

function var0.setClickTempItem(arg0, arg1)
	if arg0._clickTempItem and not arg0._clickTempItem:getTempData() then
		arg0._clickTempItem:setTempData(arg1)
	end
end

function var0.start(arg0)
	arg0._overFlag = false
	arg0._clickTempItem = nil
	arg0._gameRoundData = PipeGameVo.GetRoundData()
	arg0._mapBound = arg0._gameRoundData.map_bound
	arg0._mapSpacing = arg0._gameRoundData.item_spacing
	arg0._inputIndex = arg0._gameRoundData.input_index
	arg0._randomId = arg0._gameRoundData.random_id
	arg0._randomItemData = PipeGameConst.map_random_data[arg0._randomId]
	findTF(arg0._mapTf, "bg").sizeDelta = Vector2(arg0._mapSpacing[1] * arg0._mapBound[1], arg0._mapSpacing[2] * arg0._mapBound[2])
	arg0._maxItem = arg0._mapBound[1] * arg0._mapBound[2]

	for iter0 = 1, arg0._maxItem do
		local var0

		if iter0 > #arg0._mapItems then
			local var1 = PipeGameVo.GetTplItemFromPool(PipeGameConst.tpl_map_item, arg0._mapTf)
			local var2 = arg0:getItemPosByIndex(iter0, arg0._mapBound[1], arg0._mapSpacing)

			var0 = var12(var1, iter0, arg0.mapItemCallback)

			var0:setPosition(var2)
			table.insert(arg0._mapItems, var0)
		else
			var0 = arg0._mapItems[iter0]
		end

		var0:freeze(false)
		var0:clear()
		var0:setData(arg0:getRandomItemByIndex(iter0))
	end

	for iter1 = arg0._maxItem + 1, #arg0._mapItems do
		arg0._mapItems[iter1]:freeze(true)
	end
end

function var0.getRandomItemByIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._randomItemData.list) do
		if iter1[1] == arg1 then
			if type(iter1[2]) == "number" then
				return PipeGameConst.map_item_data[iter1[2]]
			elseif type(iter1[2]) == "table" then
				local var0 = math.random(1, #iter1[2])
				local var1 = iter1[2][var0]

				return PipeGameConst.map_item_data[var1]
			end
		end
	end

	return nil
end

function var0.step(arg0, arg1)
	if var1.draging then
		if arg0._clickTempItem then
			arg0._clickTempItem:clear()

			arg0._clickTempItem = nil
		end

		local var0 = var1.dragScreenPos
		local var1 = arg0:getItemByScreenPos(var0)

		if var1 and not var1:getData() then
			if arg0._dragTempItem ~= var1 then
				if arg0._dragTempItem then
					arg0._dragTempItem:clear()
				end

				arg0._dragTempItem = var1

				local var2 = var1.dragItem

				arg0._dragTempItem:setTempData(var2)
			end
		else
			if arg0._dragTempItem then
				arg0._dragTempItem:clear()
			end

			arg0._dragTempItem = nil
		end

		arg0._draging = var1.draging
	else
		if arg0._draging and arg0._dragTempItem then
			arg0._dragTempItem:changeTempToReal()

			arg0._dragTempItem = nil

			arg0._eventCallback(PipeGameEvent.REMOVE_RECT_TOP)

			if arg0:checkFull() then
				arg0:startOverAniamtion()
			end
		end

		arg0._draging = var1.draging
	end

	if var1.gameDragTime <= 0 then
		arg0:startOverAniamtion()
	end
end

function var0.startOverAniamtion(arg0)
	if arg0._overFlag then
		return
	end

	arg0._eventCallback(PipeGameEvent.START_SETTLEMENT)

	arg0._overFlag = true
	arg0._animationRound = 1

	local var0 = {}
	local var1 = arg0:getItemByIndex(arg0._inputIndex)

	if var1:getData() and (var1:getDirect()[2] == 0 or var1:getDirect()[2] == 1) then
		var1:setTriggerName(var4)
		table.insert(var0, var1)
		arg0:playOverAniamtion(var0, function()
			arg0._eventCallback(PipeGameEvent.PALY_ANIMATION_COMPLETE)
		end)
	else
		arg0._eventCallback(PipeGameEvent.PALY_ANIMATION_COMPLETE)
	end
end

function var0.getSuccessCount(arg0)
	local var0 = 0

	for iter0 = 1, #arg0._mapItems do
		local var1 = arg0._mapItems[iter0]

		if var1:getSuccess() and not var1:getFreeze() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.checkFull(arg0)
	local var0 = 0

	for iter0 = 1, #arg0._mapItems do
		if not arg0._mapItems[iter0]:getFreeze() and not arg0._mapItems[iter0]:getData() then
			var0 = var0 + 1
		end
	end

	return var0 == 0
end

function var0.playOverAniamtion(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = 0
	local var2 = #arg1
	local var3 = arg3 and arg3 + 1 or 1

	local function var4()
		var1 = var1 + 1

		if var1 == var2 then
			if #var0 == 0 and arg2 then
				arg2()
			else
				arg0:playOverAniamtion(var0, arg2, var3)
			end
		end
	end

	for iter0, iter1 in ipairs(arg1) do
		local var5 = arg0:getItemsByDirect(iter1, var3)

		arg0:setItemsTriggerName(iter1, var5)

		for iter2, iter3 in ipairs(var5) do
			if not table.contains(var0, iter3) then
				table.insert(var0, iter3)
			end
		end

		iter1:playAnim(var4)
	end
end

function var0.setItemsTriggerName(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = arg1:getIndex()
		local var1 = iter1:getIndex()
		local var2

		if var1 < var0 then
			if var1 == var0 - 1 then
				var2 = var3
			else
				var2 = var5
			end
		elseif var0 < var1 then
			if var1 == var0 + 1 then
				var2 = var2
			else
				var2 = var4
			end
		end

		if var2 then
			iter1:setTriggerName(var2)
		end
	end
end

function var0.getItemsByDirect(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg0._mapBound[1]
	local var2 = arg1:getDirect()
	local var3 = arg1:getIndex()

	if var2[1] == var6 or var2[1] == var11 then
		table.insert(var0, var3 + 1)
	end

	if var2[1] == var6 or var2[1] == var10 then
		table.insert(var0, var3 - 1)
	end

	if var2[2] == var7 or var2[2] == var8 then
		table.insert(var0, var3 - arg0._mapBound[1])
	end

	if var2[2] == var7 or var2[2] == var9 then
		table.insert(var0, var3 + arg0._mapBound[1])
	end

	for iter0 = #var0, 1, -1 do
		local var4 = arg0:getItemByIndex(var0[iter0])

		if var4 and var4:getData() then
			if not arg0:checkItemSuccess(var3, var4:getIndex(), var2, var4:getDirect()) then
				table.remove(var0, iter0)
			end
		else
			table.remove(var0, iter0)
		end
	end

	local var5 = {}

	for iter1, iter2 in ipairs(var0) do
		local var6 = arg0:getItemByIndex(iter2)

		if var6 and not var6:getAnimationFlag() then
			table.insert(var5, var6)
		end
	end

	return var5
end

function var0.checkItemSuccess(arg0, arg1, arg2, arg3, arg4)
	local var0 = false
	local var1 = arg0._mapBound[1]
	local var2 = arg3[1]
	local var3 = arg3[2]
	local var4 = arg4[1]
	local var5 = arg4[2]

	if arg2 - arg1 == 1 then
		if (var2 == var6 or var2 == var11) and (var4 == var6 or var4 == var10) then
			if (arg1 - 1) % var1 == var1 - 1 then
				var0 = false
			else
				var0 = true
			end
		end
	elseif arg1 - arg2 == 1 then
		if (var2 == var6 or var2 == var10) and (var4 == var6 or var4 == var11) then
			if (arg1 - 1) % var1 == 0 then
				var0 = false
			else
				var0 = true
			end
		end
	elseif arg2 - arg1 == var1 then
		if (var3 == var7 or var3 == var9) and (var5 == var7 or var5 == var8) then
			var0 = true
		end
	elseif arg1 - arg2 == var1 and (var3 == var7 or var3 == var8) and (var5 == var7 or var5 == var9) then
		var0 = true
	end

	return var0
end

function var0.getItemByIndex(arg0, arg1)
	return arg0._mapItems[arg1]
end

function var0.getItemByScreenPos(arg0, arg1)
	local var0 = arg0:getScreentScaleRate()

	for iter0 = 1, #arg0._mapItems do
		local var1 = arg0._mapItems[iter0]
		local var2 = var1:getScreenPos()

		if arg1.x > var2.x and arg1.x < var2.x + arg0._mapSpacing[1] / var0.x and arg1.y < var2.y and arg1.y > var2.y - arg0._mapSpacing[2] / var0.y then
			return var1
		end
	end

	return nil
end

function var0.getScreentScaleRate(arg0)
	local var0 = UnityEngine.Screen.width
	local var1 = UnityEngine.Screen.height
	local var2 = tf(GameObject.Find("UICamera/Canvas"))
	local var3 = var2.sizeDelta.x
	local var4 = var2.sizeDelta.y

	return Vector2(var3 / var0, var4 / var1)
end

function var0.getItemPosByIndex(arg0, arg1, arg2, arg3)
	local var0 = (arg1 - 1) % arg2
	local var1 = math.floor((arg1 - 1) / arg2)

	return Vector2(var0 * arg3[1], -var1 * arg3[2])
end

function var0.stop(arg0)
	return
end

function var0.clear(arg0)
	if arg0._dragTempItem then
		arg0._dragTempItem:clear()

		arg0._dragTempItem = nil
	end
end

function var0.dispose(arg0)
	return
end

return var0
