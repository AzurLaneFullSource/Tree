local var0_0 = class("PipeMapControl")
local var1_0
local var2_0 = "left"
local var3_0 = "right"
local var4_0 = "top"
local var5_0 = "bottom"
local var6_0 = 0
local var7_0 = 0
local var8_0 = 1
local var9_0 = 2
local var10_0 = 1
local var11_0 = 2

var0_0.CLICK_MAP_ITEM = "click map item"

local function var12_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._itemTf = arg0_1
			arg0_2._index = arg1_1
			arg0_2._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
			arg0_2._canvasGroup = GetComponent(arg0_2._itemTf, typeof(CanvasGroup))
			arg0_2._animTf = findTF(arg0_2._itemTf, "anim")
			arg0_2._imgTf = findTF(arg0_2._animTf, "img")
			arg0_2._imgFullTf = findTF(arg0_2._animTf, "imgFull")
			arg0_2._animator = GetComponent(findTF(arg0_2._itemTf, "anim"), typeof(Animator))
			arg0_2._eventCallback = arg2_1
			arg0_2._freeze = false
			arg0_2._dftEvent = GetComponent(arg0_2._animTf, typeof(DftAniEvent))
			arg0_2._clickTf = findTF(arg0_2._animTf, "click")
			arg0_2._eventTriggerListener = GetOrAddComponent(arg0_2._clickTf, typeof(EventTriggerListener))

			arg0_2._eventTriggerListener:AddPointDownFunc(function()
				if not arg0_2._data and arg0_2._eventCallback then
					arg0_2._eventCallback(var0_0.CLICK_MAP_ITEM, arg0_2)
				end
			end)
		end,
		setData = function(arg0_4, arg1_4)
			arg0_4._data = arg1_4

			if arg0_4._data then
				arg0_4._animationFlag = false

				arg0_4:loadImg(arg0_4._data.img, arg0_4._data.img_full)
				arg0_4:setItemVisible(true)
				arg0_4:setAlpha(1)
			else
				arg0_4:setItemVisible(false)
			end
		end,
		getData = function(arg0_5)
			return arg0_5._data
		end,
		setTempData = function(arg0_6, arg1_6)
			if arg0_6._data then
				warning("已经存在格子数据，无需设置预览数据")

				return
			end

			arg0_6._tempData = arg1_6

			arg0_6:loadImg(arg0_6._tempData.img, arg0_6._tempData.img_full)
			arg0_6:setItemVisible(true)
			arg0_6:setAlpha(0.5)
		end,
		getTempData = function(arg0_7)
			return arg0_7._tempData
		end,
		loadImg = function(arg0_8, arg1_8, arg2_8)
			setImageSprite(arg0_8._imgTf, var1_0.GetSprite(arg1_8))
			setImageSprite(arg0_8._imgFullTf, var1_0.GetSprite(arg2_8))
		end,
		setItemVisible = function(arg0_9, arg1_9)
			setActive(arg0_9._imgTf, arg1_9)
			setActive(arg0_9._imgFullTf, arg1_9)
		end,
		changeTempToReal = function(arg0_10)
			if arg0_10._tempData then
				arg0_10:setData(arg0_10._tempData)

				arg0_10._tempData = nil
			end
		end,
		setTriggerName = function(arg0_11, arg1_11)
			if arg0_11._animationFlag then
				return
			end

			arg0_11._animationFlag = true

			if arg0_11.animTriggerName then
				arg0_11._animator:ResetTrigger(arg0_11.animTriggerName)
			end

			arg0_11.animTriggerName = arg1_11
		end,
		playAnim = function(arg0_12, arg1_12)
			arg0_12._success = true

			if arg0_12.animTriggerName then
				arg0_12._animator:SetTrigger(arg0_12.animTriggerName)

				if arg1_12 then
					arg0_12._dftEvent:SetEndEvent(function()
						arg1_12()
						arg0_12._dftEvent:SetEndEvent(nil)
					end)
				end
			end
		end,
		getAnimationFlag = function(arg0_14)
			return arg0_14._animationFlag
		end,
		setVisible = function(arg0_15, arg1_15)
			setActive(arg0_15._itemTf, arg1_15)
		end,
		freeze = function(arg0_16, arg1_16)
			arg0_16._freeze = arg1_16

			arg0_16:setVisible(not arg0_16._freeze)
		end,
		getFreeze = function(arg0_17)
			return arg0_17._freeze
		end,
		getSuccess = function(arg0_18)
			return arg0_18._success
		end,
		setSelect = function(arg0_19, arg1_19)
			arg0_19:setTempData(arg1_19)
		end,
		setAlpha = function(arg0_20, arg1_20)
			arg0_20._canvasGroup.alpha = arg1_20
		end,
		setPosition = function(arg0_21, arg1_21)
			arg0_21._itemTf.anchoredPosition = arg1_21
		end,
		getIndex = function(arg0_22)
			return arg0_22._index
		end,
		clear = function(arg0_23)
			arg0_23._data = nil
			arg0_23._tempData = nil
			arg0_23._success = false

			arg0_23:setItemVisible(false)
			arg0_23:setAlpha(1)
		end,
		getScreenPos = function(arg0_24, arg1_24)
			if not arg0_24._screenPos then
				arg0_24:updateScreenPos()
			end

			return arg0_24._screenPos
		end,
		updateScreenPos = function(arg0_25)
			arg0_25._screenPos = arg0_25._uiCamera:WorldToScreenPoint(arg0_25._itemTf.position)
		end,
		getDirect = function(arg0_26)
			return arg0_26._data.direct
		end,
		dispose = function(arg0_27)
			ClearEventTrigger(arg0_27._eventTriggerListener)
		end
	}

	var0_1:ctor()

	return var0_1
end

function var0_0.Ctor(arg0_28, arg1_28, arg2_28)
	var1_0 = PipeGameVo
	arg0_28._mapTf = arg1_28
	arg0_28._eventCallback = arg2_28
	arg0_28._mapItems = {}

	function arg0_28.mapItemCallback(arg0_29, arg1_29)
		if var0_0.CLICK_MAP_ITEM == arg0_29 then
			if arg0_28._dragTempItem then
				arg0_28._dragTempItem:clear()

				arg0_28._dragTempItem = nil
			end

			arg0_28._eventCallback(PipeGameEvent.STOP_RECT_DRAG)

			if not arg0_28._clickTempItem then
				arg0_28._clickTempItem = arg1_29

				arg0_28._eventCallback(PipeGameEvent.SET_TOP_RECT)
			elseif arg0_28._clickTempItem ~= arg1_29 then
				arg0_28._clickTempItem:clear()

				arg0_28._clickTempItem = arg1_29

				arg0_28._eventCallback(PipeGameEvent.SET_TOP_RECT)
			elseif arg0_28._clickTempItem:getTempData() then
				arg0_28._clickTempItem:changeTempToReal()

				arg0_28._clickTempItem = nil

				arg0_28._eventCallback(PipeGameEvent.REMOVE_RECT_TOP)

				if arg0_28:checkFull() then
					arg0_28:startOverAniamtion()
				end
			end
		end
	end
end

function var0_0.setClickTempItem(arg0_30, arg1_30)
	if arg0_30._clickTempItem and not arg0_30._clickTempItem:getTempData() then
		arg0_30._clickTempItem:setTempData(arg1_30)
	end
end

function var0_0.start(arg0_31)
	arg0_31._overFlag = false
	arg0_31._clickTempItem = nil
	arg0_31._gameRoundData = PipeGameVo.GetRoundData()
	arg0_31._mapBound = arg0_31._gameRoundData.map_bound
	arg0_31._mapSpacing = arg0_31._gameRoundData.item_spacing
	arg0_31._inputIndex = arg0_31._gameRoundData.input_index
	arg0_31._randomId = arg0_31._gameRoundData.random_id
	arg0_31._randomItemData = PipeGameConst.map_random_data[arg0_31._randomId]
	findTF(arg0_31._mapTf, "bg").sizeDelta = Vector2(arg0_31._mapSpacing[1] * arg0_31._mapBound[1], arg0_31._mapSpacing[2] * arg0_31._mapBound[2])
	arg0_31._maxItem = arg0_31._mapBound[1] * arg0_31._mapBound[2]

	for iter0_31 = 1, arg0_31._maxItem do
		local var0_31

		if iter0_31 > #arg0_31._mapItems then
			local var1_31 = PipeGameVo.GetTplItemFromPool(PipeGameConst.tpl_map_item, arg0_31._mapTf)
			local var2_31 = arg0_31:getItemPosByIndex(iter0_31, arg0_31._mapBound[1], arg0_31._mapSpacing)

			var0_31 = var12_0(var1_31, iter0_31, arg0_31.mapItemCallback)

			var0_31:setPosition(var2_31)
			table.insert(arg0_31._mapItems, var0_31)
		else
			var0_31 = arg0_31._mapItems[iter0_31]
		end

		var0_31:freeze(false)
		var0_31:clear()
		var0_31:setData(arg0_31:getRandomItemByIndex(iter0_31))
	end

	for iter1_31 = arg0_31._maxItem + 1, #arg0_31._mapItems do
		arg0_31._mapItems[iter1_31]:freeze(true)
	end
end

function var0_0.getRandomItemByIndex(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg0_32._randomItemData.list) do
		if iter1_32[1] == arg1_32 then
			if type(iter1_32[2]) == "number" then
				return PipeGameConst.map_item_data[iter1_32[2]]
			elseif type(iter1_32[2]) == "table" then
				local var0_32 = math.random(1, #iter1_32[2])
				local var1_32 = iter1_32[2][var0_32]

				return PipeGameConst.map_item_data[var1_32]
			end
		end
	end

	return nil
end

function var0_0.step(arg0_33, arg1_33)
	if var1_0.draging then
		if arg0_33._clickTempItem then
			arg0_33._clickTempItem:clear()

			arg0_33._clickTempItem = nil
		end

		local var0_33 = var1_0.dragScreenPos
		local var1_33 = arg0_33:getItemByScreenPos(var0_33)

		if var1_33 and not var1_33:getData() then
			if arg0_33._dragTempItem ~= var1_33 then
				if arg0_33._dragTempItem then
					arg0_33._dragTempItem:clear()
				end

				arg0_33._dragTempItem = var1_33

				local var2_33 = var1_0.dragItem

				arg0_33._dragTempItem:setTempData(var2_33)
			end
		else
			if arg0_33._dragTempItem then
				arg0_33._dragTempItem:clear()
			end

			arg0_33._dragTempItem = nil
		end

		arg0_33._draging = var1_0.draging
	else
		if arg0_33._draging and arg0_33._dragTempItem then
			arg0_33._dragTempItem:changeTempToReal()

			arg0_33._dragTempItem = nil

			arg0_33._eventCallback(PipeGameEvent.REMOVE_RECT_TOP)

			if arg0_33:checkFull() then
				arg0_33:startOverAniamtion()
			end
		end

		arg0_33._draging = var1_0.draging
	end

	if var1_0.gameDragTime <= 0 then
		arg0_33:startOverAniamtion()
	end
end

function var0_0.startOverAniamtion(arg0_34)
	if arg0_34._overFlag then
		return
	end

	arg0_34._eventCallback(PipeGameEvent.START_SETTLEMENT)

	arg0_34._overFlag = true
	arg0_34._animationRound = 1

	local var0_34 = {}
	local var1_34 = arg0_34:getItemByIndex(arg0_34._inputIndex)

	if var1_34:getData() and (var1_34:getDirect()[2] == 0 or var1_34:getDirect()[2] == 1) then
		var1_34:setTriggerName(var4_0)
		table.insert(var0_34, var1_34)
		arg0_34:playOverAniamtion(var0_34, function()
			arg0_34._eventCallback(PipeGameEvent.PALY_ANIMATION_COMPLETE)
		end)
	else
		arg0_34._eventCallback(PipeGameEvent.PALY_ANIMATION_COMPLETE)
	end
end

function var0_0.getSuccessCount(arg0_36)
	local var0_36 = 0

	for iter0_36 = 1, #arg0_36._mapItems do
		local var1_36 = arg0_36._mapItems[iter0_36]

		if var1_36:getSuccess() and not var1_36:getFreeze() then
			var0_36 = var0_36 + 1
		end
	end

	return var0_36
end

function var0_0.checkFull(arg0_37)
	local var0_37 = 0

	for iter0_37 = 1, #arg0_37._mapItems do
		if not arg0_37._mapItems[iter0_37]:getFreeze() and not arg0_37._mapItems[iter0_37]:getData() then
			var0_37 = var0_37 + 1
		end
	end

	return var0_37 == 0
end

function var0_0.playOverAniamtion(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = {}
	local var1_38 = 0
	local var2_38 = #arg1_38
	local var3_38 = arg3_38 and arg3_38 + 1 or 1

	local function var4_38()
		var1_38 = var1_38 + 1

		if var1_38 == var2_38 then
			if #var0_38 == 0 and arg2_38 then
				arg2_38()
			else
				arg0_38:playOverAniamtion(var0_38, arg2_38, var3_38)
			end
		end
	end

	for iter0_38, iter1_38 in ipairs(arg1_38) do
		local var5_38 = arg0_38:getItemsByDirect(iter1_38, var3_38)

		arg0_38:setItemsTriggerName(iter1_38, var5_38)

		for iter2_38, iter3_38 in ipairs(var5_38) do
			if not table.contains(var0_38, iter3_38) then
				table.insert(var0_38, iter3_38)
			end
		end

		iter1_38:playAnim(var4_38)
	end
end

function var0_0.setItemsTriggerName(arg0_40, arg1_40, arg2_40)
	for iter0_40, iter1_40 in ipairs(arg2_40) do
		local var0_40 = arg1_40:getIndex()
		local var1_40 = iter1_40:getIndex()
		local var2_40

		if var1_40 < var0_40 then
			if var1_40 == var0_40 - 1 then
				var2_40 = var3_0
			else
				var2_40 = var5_0
			end
		elseif var0_40 < var1_40 then
			if var1_40 == var0_40 + 1 then
				var2_40 = var2_0
			else
				var2_40 = var4_0
			end
		end

		if var2_40 then
			iter1_40:setTriggerName(var2_40)
		end
	end
end

function var0_0.getItemsByDirect(arg0_41, arg1_41, arg2_41)
	local var0_41 = {}
	local var1_41 = arg0_41._mapBound[1]
	local var2_41 = arg1_41:getDirect()
	local var3_41 = arg1_41:getIndex()

	if var2_41[1] == var6_0 or var2_41[1] == var11_0 then
		table.insert(var0_41, var3_41 + 1)
	end

	if var2_41[1] == var6_0 or var2_41[1] == var10_0 then
		table.insert(var0_41, var3_41 - 1)
	end

	if var2_41[2] == var7_0 or var2_41[2] == var8_0 then
		table.insert(var0_41, var3_41 - arg0_41._mapBound[1])
	end

	if var2_41[2] == var7_0 or var2_41[2] == var9_0 then
		table.insert(var0_41, var3_41 + arg0_41._mapBound[1])
	end

	for iter0_41 = #var0_41, 1, -1 do
		local var4_41 = arg0_41:getItemByIndex(var0_41[iter0_41])

		if var4_41 and var4_41:getData() then
			if not arg0_41:checkItemSuccess(var3_41, var4_41:getIndex(), var2_41, var4_41:getDirect()) then
				table.remove(var0_41, iter0_41)
			end
		else
			table.remove(var0_41, iter0_41)
		end
	end

	local var5_41 = {}

	for iter1_41, iter2_41 in ipairs(var0_41) do
		local var6_41 = arg0_41:getItemByIndex(iter2_41)

		if var6_41 and not var6_41:getAnimationFlag() then
			table.insert(var5_41, var6_41)
		end
	end

	return var5_41
end

function var0_0.checkItemSuccess(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = false
	local var1_42 = arg0_42._mapBound[1]
	local var2_42 = arg3_42[1]
	local var3_42 = arg3_42[2]
	local var4_42 = arg4_42[1]
	local var5_42 = arg4_42[2]

	if arg2_42 - arg1_42 == 1 then
		if (var2_42 == var6_0 or var2_42 == var11_0) and (var4_42 == var6_0 or var4_42 == var10_0) then
			if (arg1_42 - 1) % var1_42 == var1_42 - 1 then
				var0_42 = false
			else
				var0_42 = true
			end
		end
	elseif arg1_42 - arg2_42 == 1 then
		if (var2_42 == var6_0 or var2_42 == var10_0) and (var4_42 == var6_0 or var4_42 == var11_0) then
			if (arg1_42 - 1) % var1_42 == 0 then
				var0_42 = false
			else
				var0_42 = true
			end
		end
	elseif arg2_42 - arg1_42 == var1_42 then
		if (var3_42 == var7_0 or var3_42 == var9_0) and (var5_42 == var7_0 or var5_42 == var8_0) then
			var0_42 = true
		end
	elseif arg1_42 - arg2_42 == var1_42 and (var3_42 == var7_0 or var3_42 == var8_0) and (var5_42 == var7_0 or var5_42 == var9_0) then
		var0_42 = true
	end

	return var0_42
end

function var0_0.getItemByIndex(arg0_43, arg1_43)
	return arg0_43._mapItems[arg1_43]
end

function var0_0.getItemByScreenPos(arg0_44, arg1_44)
	local var0_44 = arg0_44:getScreentScaleRate()

	for iter0_44 = 1, #arg0_44._mapItems do
		local var1_44 = arg0_44._mapItems[iter0_44]
		local var2_44 = var1_44:getScreenPos()

		if arg1_44.x > var2_44.x and arg1_44.x < var2_44.x + arg0_44._mapSpacing[1] / var0_44.x and arg1_44.y < var2_44.y and arg1_44.y > var2_44.y - arg0_44._mapSpacing[2] / var0_44.y then
			return var1_44
		end
	end

	return nil
end

function var0_0.getScreentScaleRate(arg0_45)
	local var0_45 = UnityEngine.Screen.width
	local var1_45 = UnityEngine.Screen.height
	local var2_45 = tf(GameObject.Find("UICamera/Canvas"))
	local var3_45 = var2_45.sizeDelta.x
	local var4_45 = var2_45.sizeDelta.y

	return Vector2(var3_45 / var0_45, var4_45 / var1_45)
end

function var0_0.getItemPosByIndex(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = (arg1_46 - 1) % arg2_46
	local var1_46 = math.floor((arg1_46 - 1) / arg2_46)

	return Vector2(var0_46 * arg3_46[1], -var1_46 * arg3_46[2])
end

function var0_0.stop(arg0_47)
	return
end

function var0_0.clear(arg0_48)
	if arg0_48._dragTempItem then
		arg0_48._dragTempItem:clear()

		arg0_48._dragTempItem = nil
	end
end

function var0_0.dispose(arg0_49)
	return
end

return var0_0
