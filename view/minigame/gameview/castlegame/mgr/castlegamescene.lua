local var0_0 = class("CastleGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.tplContent = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl")
	arg0_1.floorTpl = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl/floorTpl")
	arg0_1.charTpl = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl/charTpl")
	arg0_1.carriageTpl = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl/carriageTpl")
	arg0_1.bubbleTpl = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl/bubbleTpl")
	arg0_1.scoreTpl = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl/scoreTpl")
	arg0_1.contentBack = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene_background/content")
	arg0_1.contentMid = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/content")
	arg0_1.contentTop = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene_front/content")
	arg0_1.contentEF = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/effect_front")

	local var0_1 = CastleGameVo.GetRotationPosByWH(0, -1)

	arg0_1.gameFloor = CastleGameFloor.New(arg0_1.floorTpl, arg0_1._event)
	arg0_1.gameChar = CastleGameChar.New(arg0_1.charTpl, arg0_1._event)
	arg0_1.gameItem = CastleGameItem.New(arg0_1.tplContent, arg0_1._event)
	arg0_1.gameRemind = CastleGameRemind.New(arg0_1.tplContent, arg0_1._event)
	arg0_1.gameScore = CastleGameScore.New(arg0_1.scoreTpl, arg0_1._event)

	arg0_1.gameFloor:setContent(arg0_1:getContent(var2_0))
	arg0_1.gameChar:setContent(arg0_1:getContent(var3_0))
	arg0_1.gameItem:setContent(arg0_1:getContent(var3_0))
	arg0_1.gameRemind:setContent(arg0_1:getContent(var4_0))
	arg0_1.gameScore:setContent(arg0_1:getContent(var3_0))
	arg0_1.gameFloor:setFloorFallCallback(function(arg0_2)
		arg0_1:addRemindItems(arg0_2)
	end)

	local var1_1 = arg0_1.gameFloor:getOutLandPoint()

	arg0_1.gameChar:setOutLandPoint(var1_1)

	arg0_1.floorItems = {}

	arg0_1:insertFloorItem(arg0_1.gameFloor:getFloors())

	arg0_1.items = {}

	table.insert(arg0_1.items, arg0_1.gameChar:getChar())
	arg0_1.gameItem:setItemRemindCallback(function(arg0_3)
		arg0_1:addRemindItems(arg0_3)
	end)
	arg0_1.gameItem:setItemChange(function(arg0_4, arg1_4)
		arg0_1:itemChange(arg0_4, arg1_4)
	end)
	arg0_1.gameItem:setFloorBroken(function(arg0_5, arg1_5)
		for iter0_5, iter1_5 in ipairs(arg0_5) do
			arg0_1.gameFloor:setBroken(iter1_5, arg1_5)
		end
	end)
	arg0_1.gameScore:setItemChange(function(arg0_6, arg1_6)
		arg0_1:itemChange(arg0_6, arg1_6)
	end)
	arg0_1.gameItem:setBubbleBroken(function(arg0_7)
		if arg0_7 and arg0_7.char then
			arg0_1:returnPlayerBubble(arg0_7, arg0_7.char)
		end
	end)
	arg0_1:sortItems(arg0_1.floorItems)
end

function var0_0.addRemindItems(arg0_8, arg1_8)
	for iter0_8 = 1, #arg1_8 do
		local var0_8 = arg1_8[iter0_8]
		local var1_8 = var0_8.w
		local var2_8 = var0_8.h
		local var3_8 = var0_8.type and var0_8.type or CastleGameRemind.remind_type_1

		arg0_8.gameRemind:addRemind(var1_8, var2_8, var3_8)
	end
end

function var0_0.itemChange(arg0_9, arg1_9, arg2_9)
	if arg2_9 then
		if table.contains(arg0_9.items, arg1_9) then
			return
		end

		table.insert(arg0_9.items, arg1_9)
	else
		for iter0_9 = 1, #arg0_9.items do
			if arg0_9.items[iter0_9] == arg1_9 then
				table.remove(arg0_9.items, iter0_9)

				return
			end
		end
	end
end

function var0_0.start(arg0_10)
	arg0_10:prepareScene()
	arg0_10.gameFloor:start()
	arg0_10.gameChar:start()
	arg0_10.gameItem:start()
	arg0_10.gameRemind:start()
	arg0_10.gameScore:start()
end

function var0_0.step(arg0_11)
	arg0_11.gameFloor:step()
	arg0_11.gameChar:step()
	arg0_11.gameItem:step()
	arg0_11.gameRemind:step()
	arg0_11.gameScore:step()
	arg0_11:sortItems(arg0_11.items)
	arg0_11:updateActiveFloor()
	arg0_11:checkPlayerInFloor()
	arg0_11:checkPlayerInBubble()
	arg0_11:checkPlayerCarriage()
	arg0_11:checkPlayerInScore()
end

function var0_0.clear(arg0_12)
	arg0_12.gameFloor:clear()
	arg0_12.gameChar:clear()
	arg0_12.gameItem:clear()
	arg0_12.gameRemind:clear()
end

function var0_0.stop(arg0_13)
	return
end

function var0_0.resume(arg0_14)
	return
end

function var0_0.dispose(arg0_15)
	return
end

function var0_0.prepareScene(arg0_16)
	arg0_16:showContainer(true)
	arg0_16:sortItems(arg0_16.floorItems)
	arg0_16.gameChar:setContent(arg0_16:getContent(var3_0))
	CastleGameVo.PointFootLine(Vector2(0, 0), Vector2(0, 100), Vector2(100, 0))
end

function var0_0.updateActiveFloor(arg0_17)
	local var0_17 = arg0_17.gameFloor:getActiveIndexs()

	arg0_17.gameItem:setFloorIndexs(var0_17)

	local var1_17 = arg0_17.gameFloor:getFloors()

	arg0_17.gameScore:setFloor(var1_17)
end

function var0_0.checkPlayerInScore(arg0_18)
	if arg0_18.gameChar:getActionAble() then
		local var0_18 = arg0_18.gameChar:getChar()
		local var1_18 = var0_18.tf.anchoredPosition
		local var2_18 = arg0_18.gameScore:getScores()

		for iter0_18 = 1, #var2_18 do
			local var3_18 = var2_18[iter0_18]

			if var3_18.ready == 0 then
				local var4_18 = var3_18.tf.anchoredPosition
				local var5_18 = var3_18.bmin
				local var6_18 = var3_18.bmax
				local var7_18 = Vector2(var4_18.x + var5_18.x, var4_18.y + var5_18.y)
				local var8_18 = Vector2(var4_18.x + var6_18.x, var4_18.y + var6_18.y)

				if var1_18.x >= var7_18.x and var1_18.y >= var7_18.y and var1_18.x <= var8_18.x and var1_18.y <= var8_18.y then
					arg0_18:setPlayerScore(var3_18, var0_18)

					return
				end
			end
		end
	end
end

function var0_0.checkPlayerInBubble(arg0_19)
	if arg0_19.gameChar:getActionAble() then
		local var0_19 = arg0_19.gameChar:getChar()
		local var1_19 = var0_19.tf.anchoredPosition
		local var2_19 = arg0_19.gameItem:getBubbles()

		for iter0_19 = 1, #var2_19 do
			local var3_19 = var2_19[iter0_19]

			if var3_19.ready == 0 and not var3_19.broken and isActive(var3_19.tf) and var3_19.hit then
				local var4_19 = var3_19.tf.anchoredPosition
				local var5_19 = var3_19.bmin
				local var6_19 = var3_19.bmax
				local var7_19 = Vector2(var4_19.x + var5_19.x, var4_19.y + var5_19.y)
				local var8_19 = Vector2(var4_19.x + var6_19.x, var4_19.y + var6_19.y)

				if var1_19.x >= var7_19.x and var1_19.y >= var7_19.y and var1_19.x <= var8_19.x and var1_19.y <= var8_19.y then
					arg0_19:setPlayerBubble(var3_19, var0_19)

					return
				end
			end
		end
	end
end

function var0_0.checkPlayerBoom(arg0_20)
	if arg0_20.gameChar:getActionAble() then
		local var0_20 = arg0_20.gameChar:getChar().tf.anchoredPosition
		local var1_20 = arg0_20.gameItem:getBooms()
		local var2_20 = false

		for iter0_20 = 1, #var1_20 do
			local var3_20 = var1_20[iter0_20]

			if var3_20.ready and var3_20.ready == 0 and not var3_20.broken and var3_20.brokenTime < 1 then
				local var4_20 = var3_20.boundPoints

				if not var2_20 then
					local var5_20 = CastleGameVo.PointInTriangle(var0_20, var4_20[1], var4_20[2], var4_20[3])
					local var6_20 = CastleGameVo.PointInTriangle(var0_20, var4_20[3], var4_20[4], var4_20[1])

					if var5_20 then
						var2_20 = true
					elseif var6_20 then
						var2_20 = true
					end
				end

				if var2_20 then
					arg0_20.gameChar:setPlayerFail()

					return
				end
			end
		end
	end
end

function var0_0.checkPlayerCarriage(arg0_21)
	if arg0_21.gameChar:getActionAble() then
		local var0_21 = arg0_21.gameChar:getChar().tf.anchoredPosition
		local var1_21 = arg0_21.gameItem:getCarriages()

		for iter0_21 = 1, #var1_21 do
			local var2_21 = var1_21[iter0_21]
			local var3_21 = var2_21.bmin
			local var4_21 = var2_21.bmax
			local var5_21 = var2_21.tf.anchoredPosition
			local var6_21 = Vector2(var5_21.x + var3_21.x, var5_21.y + var3_21.y)
			local var7_21 = Vector2(var5_21.x + var4_21.x, var5_21.y + var4_21.y)

			if var0_21.x >= var6_21.x and var0_21.y >= var6_21.y and var0_21.x <= var7_21.x and var0_21.y <= var7_21.y then
				arg0_21.gameChar:setPlayerFail()

				return
			end
		end
	end
end

function var0_0.setPlayerScore(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.gameChar:getChar()

	arg0_22.gameChar:setScore(arg1_22)
	arg0_22.gameScore:hitScore(arg1_22)
	arg0_22._event:emit(CastleGameView.ADD_SCORE, {
		num = arg1_22.data.score,
		pos = var0_22.tf.position,
		id = arg1_22.id
	})
end

function var0_0.returnPlayerBubble(arg0_23, arg1_23, arg2_23)
	arg0_23.gameChar:setContent(arg0_23.contentTop)
	arg0_23.gameChar:setInBubble(false)

	arg1_23.char = nil
end

function var0_0.setPlayerBubble(arg0_24, arg1_24, arg2_24)
	arg0_24.gameChar:setInBubble(true)
	arg0_24.gameChar:setContent(arg1_24.pos, Vector3(0, 0, 0))

	arg1_24.char = arg2_24

	arg0_24.gameItem:playerInBubble(arg1_24, arg2_24)
end

function var0_0.checkPlayerInFloor(arg0_25)
	if arg0_25.gameChar:getActionAble() then
		local var0_25 = arg0_25.gameChar:getChar()
		local var1_25 = var0_25.tf.anchoredPosition
		local var2_25 = arg0_25.gameFloor:getFloors()
		local var3_25 = false

		for iter0_25 = 1, #var2_25 do
			local var4_25 = var2_25[iter0_25]
			local var5_25 = var4_25.bound

			if not var3_25 then
				local var6_25 = CastleGameVo.PointInTriangle(var1_25, var5_25[1], var5_25[2], var5_25[3])
				local var7_25 = CastleGameVo.PointInTriangle(var1_25, var5_25[3], var5_25[4], var5_25[1])

				if var6_25 then
					var3_25 = true
				elseif var7_25 then
					var3_25 = true
				end
			end

			if var3_25 then
				var0_25.floor = var2_25[iter0_25]

				if var4_25.fall == true then
					arg0_25:setCharFall()
				end

				return
			end
		end
	end
end

function var0_0.setCharFall(arg0_26)
	arg0_26.gameChar:setInGround(false)
end

function var0_0.insertFloorItem(arg0_27, arg1_27)
	for iter0_27 = 1, #arg1_27 do
		table.insert(arg0_27.floorItems, arg1_27[iter0_27])
	end
end

function var0_0.getContent(arg0_28, arg1_28)
	local var0_28

	if arg1_28 == var1_0 then
		var0_28 = arg0_28.contentBack
	elseif arg1_28 == var2_0 then
		var0_28 = arg0_28.contentMid
	elseif arg1_28 == var3_0 then
		var0_28 = arg0_28.contentTop
	elseif arg1_28 == var4_0 then
		var0_28 = arg0_28.contentEF
	end

	return var0_28
end

function var0_0.sortItems(arg0_29, arg1_29)
	table.sort(arg1_29, function(arg0_30, arg1_30)
		local var0_30 = arg0_30.tf.anchoredPosition
		local var1_30 = arg1_30.tf.anchoredPosition

		if var0_30.y > var1_30.y then
			return false
		elseif var0_30.y < var1_30.y then
			return true
		end

		if var0_30.x > var1_30.x then
			return false
		elseif var0_30.x < var1_30.x then
			return true
		end

		return false
	end)

	for iter0_29 = 1, #arg1_29 do
		arg1_29[iter0_29].tf:SetSiblingIndex(0)
	end
end

function var0_0.compareByPosition(arg0_31, arg1_31, arg2_31)
	return
end

function var0_0.compareWithPosBound(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg2_32[1]
	local var1_32 = arg2_32[4]

	return CastleGameVo.PointLeftLine(arg1_32, var0_32, var1_32)
end

function var0_0.showContainer(arg0_33, arg1_33)
	setActive(arg0_33.sceneMask, arg1_33)
end

function var0_0.press(arg0_34, arg1_34)
	arg0_34.gameFloor:press(arg1_34)
	arg0_34:sortItems(arg0_34.floorItems)
end

return var0_0
