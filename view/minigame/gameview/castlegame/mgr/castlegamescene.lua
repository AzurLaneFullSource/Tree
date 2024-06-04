local var0 = class("CastleGameScene")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0.sceneMask = findTF(arg0._tf, "sceneMask")
	arg0.tplContent = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl")
	arg0.floorTpl = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl/floorTpl")
	arg0.charTpl = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl/charTpl")
	arg0.carriageTpl = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl/carriageTpl")
	arg0.bubbleTpl = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl/bubbleTpl")
	arg0.scoreTpl = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl/scoreTpl")
	arg0.contentBack = findTF(arg0._tf, "sceneMask/sceneContainer/scene_background/content")
	arg0.contentMid = findTF(arg0._tf, "sceneMask/sceneContainer/scene/content")
	arg0.contentTop = findTF(arg0._tf, "sceneMask/sceneContainer/scene_front/content")
	arg0.contentEF = findTF(arg0._tf, "sceneMask/sceneContainer/scene/effect_front")

	local var0 = CastleGameVo.GetRotationPosByWH(0, -1)

	arg0.gameFloor = CastleGameFloor.New(arg0.floorTpl, arg0._event)
	arg0.gameChar = CastleGameChar.New(arg0.charTpl, arg0._event)
	arg0.gameItem = CastleGameItem.New(arg0.tplContent, arg0._event)
	arg0.gameRemind = CastleGameRemind.New(arg0.tplContent, arg0._event)
	arg0.gameScore = CastleGameScore.New(arg0.scoreTpl, arg0._event)

	arg0.gameFloor:setContent(arg0:getContent(var2))
	arg0.gameChar:setContent(arg0:getContent(var3))
	arg0.gameItem:setContent(arg0:getContent(var3))
	arg0.gameRemind:setContent(arg0:getContent(var4))
	arg0.gameScore:setContent(arg0:getContent(var3))
	arg0.gameFloor:setFloorFallCallback(function(arg0)
		arg0:addRemindItems(arg0)
	end)

	local var1 = arg0.gameFloor:getOutLandPoint()

	arg0.gameChar:setOutLandPoint(var1)

	arg0.floorItems = {}

	arg0:insertFloorItem(arg0.gameFloor:getFloors())

	arg0.items = {}

	table.insert(arg0.items, arg0.gameChar:getChar())
	arg0.gameItem:setItemRemindCallback(function(arg0)
		arg0:addRemindItems(arg0)
	end)
	arg0.gameItem:setItemChange(function(arg0, arg1)
		arg0:itemChange(arg0, arg1)
	end)
	arg0.gameItem:setFloorBroken(function(arg0, arg1)
		for iter0, iter1 in ipairs(arg0) do
			arg0.gameFloor:setBroken(iter1, arg1)
		end
	end)
	arg0.gameScore:setItemChange(function(arg0, arg1)
		arg0:itemChange(arg0, arg1)
	end)
	arg0.gameItem:setBubbleBroken(function(arg0)
		if arg0 and arg0.char then
			arg0:returnPlayerBubble(arg0, arg0.char)
		end
	end)
	arg0:sortItems(arg0.floorItems)
end

function var0.addRemindItems(arg0, arg1)
	for iter0 = 1, #arg1 do
		local var0 = arg1[iter0]
		local var1 = var0.w
		local var2 = var0.h
		local var3 = var0.type and var0.type or CastleGameRemind.remind_type_1

		arg0.gameRemind:addRemind(var1, var2, var3)
	end
end

function var0.itemChange(arg0, arg1, arg2)
	if arg2 then
		if table.contains(arg0.items, arg1) then
			return
		end

		table.insert(arg0.items, arg1)
	else
		for iter0 = 1, #arg0.items do
			if arg0.items[iter0] == arg1 then
				table.remove(arg0.items, iter0)

				return
			end
		end
	end
end

function var0.start(arg0)
	arg0:prepareScene()
	arg0.gameFloor:start()
	arg0.gameChar:start()
	arg0.gameItem:start()
	arg0.gameRemind:start()
	arg0.gameScore:start()
end

function var0.step(arg0)
	arg0.gameFloor:step()
	arg0.gameChar:step()
	arg0.gameItem:step()
	arg0.gameRemind:step()
	arg0.gameScore:step()
	arg0:sortItems(arg0.items)
	arg0:updateActiveFloor()
	arg0:checkPlayerInFloor()
	arg0:checkPlayerInBubble()
	arg0:checkPlayerCarriage()
	arg0:checkPlayerInScore()
end

function var0.clear(arg0)
	arg0.gameFloor:clear()
	arg0.gameChar:clear()
	arg0.gameItem:clear()
	arg0.gameRemind:clear()
end

function var0.stop(arg0)
	return
end

function var0.resume(arg0)
	return
end

function var0.dispose(arg0)
	return
end

function var0.prepareScene(arg0)
	arg0:showContainer(true)
	arg0:sortItems(arg0.floorItems)
	arg0.gameChar:setContent(arg0:getContent(var3))
	CastleGameVo.PointFootLine(Vector2(0, 0), Vector2(0, 100), Vector2(100, 0))
end

function var0.updateActiveFloor(arg0)
	local var0 = arg0.gameFloor:getActiveIndexs()

	arg0.gameItem:setFloorIndexs(var0)

	local var1 = arg0.gameFloor:getFloors()

	arg0.gameScore:setFloor(var1)
end

function var0.checkPlayerInScore(arg0)
	if arg0.gameChar:getActionAble() then
		local var0 = arg0.gameChar:getChar()
		local var1 = var0.tf.anchoredPosition
		local var2 = arg0.gameScore:getScores()

		for iter0 = 1, #var2 do
			local var3 = var2[iter0]

			if var3.ready == 0 then
				local var4 = var3.tf.anchoredPosition
				local var5 = var3.bmin
				local var6 = var3.bmax
				local var7 = Vector2(var4.x + var5.x, var4.y + var5.y)
				local var8 = Vector2(var4.x + var6.x, var4.y + var6.y)

				if var1.x >= var7.x and var1.y >= var7.y and var1.x <= var8.x and var1.y <= var8.y then
					arg0:setPlayerScore(var3, var0)

					return
				end
			end
		end
	end
end

function var0.checkPlayerInBubble(arg0)
	if arg0.gameChar:getActionAble() then
		local var0 = arg0.gameChar:getChar()
		local var1 = var0.tf.anchoredPosition
		local var2 = arg0.gameItem:getBubbles()

		for iter0 = 1, #var2 do
			local var3 = var2[iter0]

			if var3.ready == 0 and not var3.broken and isActive(var3.tf) and var3.hit then
				local var4 = var3.tf.anchoredPosition
				local var5 = var3.bmin
				local var6 = var3.bmax
				local var7 = Vector2(var4.x + var5.x, var4.y + var5.y)
				local var8 = Vector2(var4.x + var6.x, var4.y + var6.y)

				if var1.x >= var7.x and var1.y >= var7.y and var1.x <= var8.x and var1.y <= var8.y then
					arg0:setPlayerBubble(var3, var0)

					return
				end
			end
		end
	end
end

function var0.checkPlayerBoom(arg0)
	if arg0.gameChar:getActionAble() then
		local var0 = arg0.gameChar:getChar().tf.anchoredPosition
		local var1 = arg0.gameItem:getBooms()
		local var2 = false

		for iter0 = 1, #var1 do
			local var3 = var1[iter0]

			if var3.ready and var3.ready == 0 and not var3.broken and var3.brokenTime < 1 then
				local var4 = var3.boundPoints

				if not var2 then
					local var5 = CastleGameVo.PointInTriangle(var0, var4[1], var4[2], var4[3])
					local var6 = CastleGameVo.PointInTriangle(var0, var4[3], var4[4], var4[1])

					if var5 then
						var2 = true
					elseif var6 then
						var2 = true
					end
				end

				if var2 then
					arg0.gameChar:setPlayerFail()

					return
				end
			end
		end
	end
end

function var0.checkPlayerCarriage(arg0)
	if arg0.gameChar:getActionAble() then
		local var0 = arg0.gameChar:getChar().tf.anchoredPosition
		local var1 = arg0.gameItem:getCarriages()

		for iter0 = 1, #var1 do
			local var2 = var1[iter0]
			local var3 = var2.bmin
			local var4 = var2.bmax
			local var5 = var2.tf.anchoredPosition
			local var6 = Vector2(var5.x + var3.x, var5.y + var3.y)
			local var7 = Vector2(var5.x + var4.x, var5.y + var4.y)

			if var0.x >= var6.x and var0.y >= var6.y and var0.x <= var7.x and var0.y <= var7.y then
				arg0.gameChar:setPlayerFail()

				return
			end
		end
	end
end

function var0.setPlayerScore(arg0, arg1, arg2)
	local var0 = arg0.gameChar:getChar()

	arg0.gameChar:setScore(arg1)
	arg0.gameScore:hitScore(arg1)
	arg0._event:emit(CastleGameView.ADD_SCORE, {
		num = arg1.data.score,
		pos = var0.tf.position,
		id = arg1.id
	})
end

function var0.returnPlayerBubble(arg0, arg1, arg2)
	arg0.gameChar:setContent(arg0.contentTop)
	arg0.gameChar:setInBubble(false)

	arg1.char = nil
end

function var0.setPlayerBubble(arg0, arg1, arg2)
	arg0.gameChar:setInBubble(true)
	arg0.gameChar:setContent(arg1.pos, Vector3(0, 0, 0))

	arg1.char = arg2

	arg0.gameItem:playerInBubble(arg1, arg2)
end

function var0.checkPlayerInFloor(arg0)
	if arg0.gameChar:getActionAble() then
		local var0 = arg0.gameChar:getChar()
		local var1 = var0.tf.anchoredPosition
		local var2 = arg0.gameFloor:getFloors()
		local var3 = false

		for iter0 = 1, #var2 do
			local var4 = var2[iter0]
			local var5 = var4.bound

			if not var3 then
				local var6 = CastleGameVo.PointInTriangle(var1, var5[1], var5[2], var5[3])
				local var7 = CastleGameVo.PointInTriangle(var1, var5[3], var5[4], var5[1])

				if var6 then
					var3 = true
				elseif var7 then
					var3 = true
				end
			end

			if var3 then
				var0.floor = var2[iter0]

				if var4.fall == true then
					arg0:setCharFall()
				end

				return
			end
		end
	end
end

function var0.setCharFall(arg0)
	arg0.gameChar:setInGround(false)
end

function var0.insertFloorItem(arg0, arg1)
	for iter0 = 1, #arg1 do
		table.insert(arg0.floorItems, arg1[iter0])
	end
end

function var0.getContent(arg0, arg1)
	local var0

	if arg1 == var1 then
		var0 = arg0.contentBack
	elseif arg1 == var2 then
		var0 = arg0.contentMid
	elseif arg1 == var3 then
		var0 = arg0.contentTop
	elseif arg1 == var4 then
		var0 = arg0.contentEF
	end

	return var0
end

function var0.sortItems(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0.tf.anchoredPosition
		local var1 = arg1.tf.anchoredPosition

		if var0.y > var1.y then
			return false
		elseif var0.y < var1.y then
			return true
		end

		if var0.x > var1.x then
			return false
		elseif var0.x < var1.x then
			return true
		end

		return false
	end)

	for iter0 = 1, #arg1 do
		arg1[iter0].tf:SetSiblingIndex(0)
	end
end

function var0.compareByPosition(arg0, arg1, arg2)
	return
end

function var0.compareWithPosBound(arg0, arg1, arg2)
	local var0 = arg2[1]
	local var1 = arg2[4]

	return CastleGameVo.PointLeftLine(arg1, var0, var1)
end

function var0.showContainer(arg0, arg1)
	setActive(arg0.sceneMask, arg1)
end

function var0.press(arg0, arg1)
	arg0.gameFloor:press(arg1)
	arg0:sortItems(arg0.floorItems)
end

return var0
