local var0_0 = class("IslandMapContainer")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._parent = arg1_1
	arg0_1._event = arg2_1
	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_1._eventTriggers = {}
	arg0_1._scaleRate = 1
end

function var0_0.loadMap(arg0_2, arg1_2)
	arg0_2._mapId = arg1_2

	arg0_2:clear()
	arg0_2:updateMap()
	arg0_2:updatePart()
	arg0_2:updateDragBound()
end

function var0_0.updateMap(arg0_3)
	arg0_3._mapTf = findTF(arg0_3._parent, "island_map_1")

	arg0_3:addTfListenerMove(arg0_3._mapTf)
end

function var0_0.updatePart(arg0_4)
	arg0_4.partItems = {}

	local var0_4 = findTF(arg0_4._mapTf, "part")
	local var1_4 = var0_4.childCount

	for iter0_4 = 1, var1_4 do
		local var2_4 = var0_4:GetChild(iter0_4 - 1)

		GetComponent(findTF(var2_4, "click/img"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

		arg0_4:addTfListenerMove(var2_4, function()
			local var0_5 = arg0_4._uiCamera:WorldToScreenPoint(var2_4.position)

			arg0_4:focusIn(var0_5)
		end)
		table.insert(arg0_4.partItems, var2_4)
	end
end

function var0_0.updateDragBound(arg0_6)
	arg0_6._screenSize = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas").sizeDelta

	local var0_6 = math.abs(arg0_6._screenSize.x / 2 - arg0_6._mapTf.sizeDelta.x * arg0_6._scaleRate / 2)
	local var1_6 = math.abs(arg0_6._screenSize.y / 2 - arg0_6._mapTf.sizeDelta.y * arg0_6._scaleRate / 2)

	arg0_6._dragBounds = {
		{
			-var0_6,
			var0_6
		},
		{
			-var1_6,
			var1_6
		}
	}
end

function var0_0.addTfListenerMove(arg0_7, arg1_7, arg2_7)
	local var0_7 = GetOrAddComponent(arg1_7, typeof(EventTriggerListener))

	arg0_7._eventDownTime = 0
	arg0_7._eventDownPosition = nil

	var0_7:AddPointDownFunc(function(arg0_8, arg1_8)
		arg0_7._eventDownTime = Time.GetTimestamp()
		arg0_7._eventDownPosition = arg1_8.position
	end)
	var0_7:AddPointUpFunc(function(arg0_9, arg1_9)
		if Time.GetTimestamp() - arg0_7._eventDownTime < 0.25 and arg0_7._eventDownPosition and math.abs(arg1_9.position.x - arg0_7._eventDownPosition.x) < 25 and math.abs(arg1_9.position.y - arg0_7._eventDownPosition.y) < 25 then
			if arg2_7 then
				arg2_7(arg1_9)
			else
				arg0_7:focusIn(arg1_9.position)
			end
		end
	end)
	var0_7:AddBeginDragFunc(function(arg0_10, arg1_10)
		arg0_7.startPosition = arg1_10.position
	end)
	var0_7:AddDragFunc(function(arg0_11, arg1_11)
		if arg0_7.startPosition then
			local var0_11 = {
				arg1_11.position.x - arg0_7.startPosition.x,
				arg1_11.position.y - arg0_7.startPosition.y
			}

			arg0_7:moveMap(var0_11)

			arg0_7.startPosition = arg1_11.position
		end

		arg0_7._eventDownTime = 0
	end)
	var0_7:AddDragEndFunc(function(arg0_12, arg1_12)
		arg0_7.startPosition = nil
	end)
	table.insert(arg0_7._eventTriggers, var0_7)
end

function var0_0.checkPointPart(arg0_13, arg1_13)
	local var0_13 = arg0_13._uiCamera:ScreenToWorldPoint(arg1_13)
end

function var0_0.moveMap(arg0_14, arg1_14)
	if arg0_14._inMovingTime then
		return
	end

	if not arg1_14 then
		return
	end

	if not arg0_14._mapTf then
		return
	end

	local var0_14 = arg0_14._mapTf.anchoredPosition

	var0_14.x = var0_14.x + arg1_14[1] * arg0_14._scaleRate
	var0_14.y = var0_14.y + arg1_14[2] * arg0_14._scaleRate

	arg0_14:fixedV2Position(var0_14)

	arg0_14._mapTf.anchoredPosition = var0_14
end

function var0_0.setScale(arg0_15, arg1_15)
	if arg0_15._inMovingTime then
		return
	end

	arg0_15._inMovingTime = true

	LeanTween.scale(go(arg0_15._mapTf), Vector3(arg1_15, arg1_15, arg1_15), 0.4):setOnUpdate(System.Action_float(function(arg0_16)
		return
	end)):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0_15._scaleRate = arg1_15
		arg0_15._mapTf.localScale = Vector3(arg1_15, arg1_15, arg1_15)

		arg0_15:updateDragBound()

		local var0_17 = arg0_15._mapTf.anchoredPosition

		arg0_15:fixedV2Position(var0_17)

		arg0_15._mapTf.anchoredPosition = var0_17
		arg0_15._inMovingTime = false
	end))
end

function var0_0.scaleMap(arg0_18)
	return
end

function var0_0.fixedV2Position(arg0_19, arg1_19)
	arg1_19.x = math.max(arg0_19._dragBounds[1][1], arg1_19.x)
	arg1_19.x = math.min(arg0_19._dragBounds[1][2], arg1_19.x)
	arg1_19.y = math.max(arg0_19._dragBounds[2][1], arg1_19.y)
	arg1_19.y = math.min(arg0_19._dragBounds[2][2], arg1_19.y)
end

function var0_0.fixedV3Position(arg0_20, arg1_20)
	arg1_20.x = math.max(arg0_20._dragBounds[1][1], arg1_20.x)
	arg1_20.x = math.min(arg0_20._dragBounds[1][2], arg1_20.x)
	arg1_20.y = math.max(arg0_20._dragBounds[2][1], arg1_20.y)
	arg1_20.y = math.min(arg0_20._dragBounds[2][2], arg1_20.y)
end

function var0_0.focusIn(arg0_21, arg1_21)
	if arg0_21._inMovingTime then
		return
	end

	arg0_21._inMovingTime = true

	local var0_21 = arg0_21._mapTf.anchoredPosition
	local var1_21 = arg0_21:getScreenCenter()
	local var2_21 = Vector3(var0_21.x + (var1_21.x - arg1_21.x), var0_21.y + (var1_21.y - arg1_21.y), 0)

	arg0_21:setMoveTo(var2_21)
end

function var0_0.setMoveTo(arg0_22, arg1_22)
	if LeanTween.isTweening(go(arg0_22._mapTf)) then
		return
	end

	arg0_22:fixedV3Position(arg1_22)
	LeanTween.moveLocal(go(arg0_22._mapTf), arg1_22, 0.4):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0_22._inMovingTime = false
	end))
end

function var0_0.getScreenCenter(arg0_24)
	return Vector2(arg0_24._screenSize.x / 2, arg0_24._screenSize.y / 2)
end

function var0_0.clear(arg0_25)
	for iter0_25 = 1, #arg0_25._eventTriggers do
		ClearEventTrigger(arg0_25._eventTriggers[iter0_25])
	end

	arg0_25._eventTriggers = {}
end

function var0_0.dispose(arg0_26)
	arg0_26:clear()

	if LeanTween.isTweening(go(arg0_26._mapTf)) then
		LeanTween.cancel(go(arg0_26._mapTf))
	end
end

return var0_0
