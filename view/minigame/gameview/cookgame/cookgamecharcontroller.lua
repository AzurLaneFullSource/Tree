local var0 = class("CookGameCharController")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._sceneContainer = arg1
	arg0._scene = findTF(arg0._sceneContainer, "scene")
	arg0._tpl = findTF(arg1, "scene_background/charTpl")
	arg0._cakeTpl = findTF(arg1, "scene_background/cakeTpl")

	setActive(arg0._cakeTpl, false)
	setActive(arg0._tpl, false)

	arg0._gameData = arg2
	arg0._event = arg3
	arg0.playerChar = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)

	arg0.playerChar:isPlayer(true)

	arg0.partnerChar = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)

	arg0.partnerChar:isPartner(true)

	arg0.partnerPet = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)

	arg0.partnerPet:isPartner(true)

	arg0.enemy1Char = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)
	arg0.enemy2Char = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)
	arg0.enemyPet = CookGameChar.New(tf(instantiate(arg0._tpl)), arg0._gameData, arg0._event)

	arg0.playerChar:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.player_char])
	arg0.partnerChar:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.parter_char])
	arg0.partnerPet:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.parter_pet])
	arg0.enemy1Char:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy1_char])
	arg0.enemy2Char:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy2_char])
	arg0.enemyPet:setParent(arg0._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy_pet])
	arg0.enemy1Char:isPartner(false)
	arg0.enemy2Char:isPartner(false)
	arg0.enemyPet:isPartner(false)

	arg0.chars = {
		arg0.playerChar,
		arg0.partnerChar,
		arg0.enemy1Char,
		arg0.enemy2Char,
		arg0.partnerPet,
		arg0.enemyPet
	}
	arg0._playerBox = findTF(arg0._sceneContainer, "scene_background/playerBox")

	if not arg0.uiCam then
		arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0._playerCollider = findTF(arg0._playerBox, "collider")
	arg0._playerColliderEvenet = GetComponent(arg0._playerCollider, typeof(EventTriggerListener))

	arg0._playerColliderEvenet:AddPointDownFunc(function(arg0, arg1)
		local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.pressPosition)
		local var1 = arg0._scene:InverseTransformPoint(var0)

		arg0.playerChar:clearCake()
		arg0.playerChar:clearJudge()
		arg0.playerChar:setTargetPos(var1, nil)
	end)

	arg0.playerCakes = {}

	for iter0 = 1, arg0._gameData.cake_num do
		local var0 = iter0
		local var1 = findTF(arg0._playerBox, "table/cake/" .. iter0)
		local var2 = findTF(var1, "pos")
		local var3 = GetComponent(findTF(var1, "collider"), typeof(EventTriggerListener))

		var3:AddPointDownFunc(function(arg0, arg1)
			arg0:onPickupCake(arg0.playerChar, var0, arg0.playerCakes, true)
		end)
		table.insert(arg0.playerCakes, {
			tf = var1,
			pos = var2,
			id = var0,
			event = var3
		})
	end

	arg0.enemyCakes = {}
	arg0._enemyBox = findTF(arg0._sceneContainer, "scene_background/enemyBox")

	for iter1 = 1, arg0._gameData.cake_num do
		local var4 = iter1
		local var5 = findTF(arg0._enemyBox, "table/cake/" .. iter1)
		local var6 = findTF(var5, "pos")

		table.insert(arg0.enemyCakes, {
			tf = var5,
			pos = var6,
			id = var4,
			event = arg3
		})
	end

	arg0.acCakes = {}
end

function var0.changeSpeed(arg0, arg1)
	for iter0 = 1, #arg0.chars do
		arg0.chars[iter0]:changeSpeed(arg1)
	end
end

function var0.onPickupCake(arg0, arg1, arg2, arg3, arg4)
	if arg1:isActiving() then
		return
	end

	for iter0 = 1, #arg3 do
		local var0 = arg3[iter0]
		local var1 = var0.tf

		if var0.id == arg2 then
			local var2 = findTF(var0.tf, "pos")

			var0.cakePos = arg0._scene:InverseTransformPoint(var2.position)

			arg1:setCake(var0)

			if arg4 then
				setActive(findTF(var1, "select"), true)
			end
		else
			setActive(findTF(var1, "select"), false)
		end
	end
end

function var0.readyStart(arg0)
	arg0.playerChar:setData(arg0:createCharData(arg0._gameData.playerChar))
	arg0.partnerChar:setData(arg0:createCharData(arg0._gameData.partnerChar))

	if arg0._gameData.partnerPet then
		arg0.partnerPet:setData(arg0:createCharData(arg0._gameData.partnerPet))
	else
		arg0.partnerPet:setData(nil)
	end

	arg0.enemy1Char:setData(arg0:createCharData(arg0._gameData.enemy1Char))
	arg0.enemy2Char:setData(arg0:createCharData(arg0._gameData.enemy2Char))

	if arg0._gameData.enemyPet then
		arg0.enemyPet:setData(arg0:createCharData(arg0._gameData.enemyPet))
	else
		arg0.enemyPet:setData(nil)
	end

	arg0.playerChar:readyStart()
	arg0.partnerChar:readyStart()
	arg0.partnerPet:readyStart()
	arg0.enemy1Char:readyStart()
	arg0.enemy2Char:readyStart()
	arg0.enemyPet:readyStart()

	arg0.sceneTfs = nil
end

function var0.start(arg0)
	return
end

function var0.step(arg0, arg1)
	for iter0 = 1, #arg0.chars do
		local var0 = arg0.chars[iter0]

		if var0:getCharActive() then
			local var1 = var0:getTargetPos()
			local var2 = var0:getVelocity()

			if var1 then
				local var3 = var0:getPos()

				if not var2 then
					if math.abs(var1.y - var3.y) ~= 0 then
						local var4 = math.atan(math.abs(var1.y - var3.y) / math.abs(var1.x - var3.x))
						local var5 = var1.x > var3.x and 1 or -1
						local var6 = var1.y > var3.y and 1 or -1
						local var7 = math.cos(var4) * var5
						local var8 = math.sin(var4) * var6

						var0:setVelocity(var7, var8, var4)
					else
						var0:stopMove()
					end
				end
			elseif var0:getJudgeData() then
				var0:setTargetPos(var0:getJudgeData().targetPos)
			elseif var0:getCake() then
				var0:setTargetPos(var0:getCake().cakePos)
			end

			var0:step(arg1)
		end
	end

	if not arg0.sceneTfs then
		arg0.sceneTfs = {}

		local var9 = {}
		local var10 = arg0._scene.childCount

		arg0.judgeNum = 0

		for iter1 = 0, var10 - 1 do
			local var11 = arg0._scene:GetChild(iter1)

			if string.match(var11.name, "judge") then
				arg0.judgeNum = arg0.judgeNum + 1

				table.insert(var9, var11)
			else
				table.insert(arg0.sceneTfs, {
					tf = var11,
					offset = arg0:getTfOffset(var11.name)
				})
			end
		end

		table.sort(var9, function(arg0, arg1)
			if arg0.anchoredPosition.y > arg1.anchoredPosition.y then
				return true
			else
				return false
			end
		end)
	end

	table.sort(arg0.sceneTfs, function(arg0, arg1)
		local var0 = arg0.tf.anchoredPosition
		local var1 = arg0.offset and arg0.offset or Vector2(0, 0)
		local var2 = arg1.tf.anchoredPosition
		local var3 = arg1.offset and arg1.offset or Vector2(0, 0)

		if var0.y + var1.y > var2.y + var3.y then
			return true
		else
			return false
		end
	end)

	for iter2 = 1, #arg0.sceneTfs do
		arg0.sceneTfs[iter2].tf:SetSiblingIndex(iter2 - 1 + arg0.judgeNum)
	end

	if not arg0._judges then
		arg0._judges = arg0._gameData.judges
	end

	local var12 = arg0:getFillterWanted({
		arg0.partnerChar
	})
	local var13 = arg0:getFillterWanted({
		arg0.playerChar,
		arg0.partnerPet
	})
	local var14 = arg0:getFillterWanted({
		arg0.playerChar,
		arg0.partnerPet
	})
	local var15 = arg0:getFillterWanted({
		arg0.enemy2Char,
		arg0.enemyPet
	})
	local var16 = arg0:getFillterWanted({
		arg0.enemy1Char,
		arg0.enemyPet
	})
	local var17 = arg0:getFillterWanted({
		arg0.enemy1Char,
		arg0.enemy2Char
	})

	if CookGameConst.player_use_ai then
		arg0:setCharAction(arg0.playerChar, var13, arg0.playerCakes)
	end

	arg0:setCharAction(arg0.partnerChar, var12, arg0.playerCakes)
	arg0:setCharAction(arg0.partnerPet, var14, arg0.playerCakes)

	if arg0._gameData.gameTime and arg0._gameData.gameTime > 0 then
		arg0:setCharAction(arg0.enemy1Char, var15, arg0.enemyCakes)
		arg0:setCharAction(arg0.enemy2Char, var16, arg0.enemyCakes)
		arg0:setCharAction(arg0.enemyPet, var17, arg0.enemyCakes)
	end

	for iter3 = #arg0.acCakes, 1, -1 do
		local var18 = arg0.acCakes[iter3].tf
		local var19 = arg0.acCakes[iter3].tf.anchoredPosition
		local var20 = arg0.acCakes[iter3].targetPos
		local var21 = math.atan(math.abs(var20.y - var19.y) / math.abs(var20.x - var19.x))
		local var22 = var20.x > var19.x and 1 or -1
		local var23 = var20.y > var19.y and 1 or -1
		local var24 = math.cos(var21) * var22 * 600 * arg1
		local var25 = math.sin(var21) * var23 * 600 * arg1
		local var26 = Vector2(var19.x + var24, var19.y + var25)
		local var27 = arg0.acCakes[iter3].tf.anchoredPosition

		if var19.x < var20.x and var26.x < var20.x then
			var27.x = var26.x
		elseif var19.x > var20.x and var26.x > var20.x then
			var27.x = var26.x
		else
			var27.x = var20.x
		end

		if var19.y < var20.y and var26.y < var20.y then
			var27.y = var26.y
		elseif var19.y > var20.y and var26.y > var20.y then
			var27.y = var26.y
		else
			var27.y = var20.y
		end

		arg0.acCakes[iter3].tf.anchoredPosition = var27

		if math.abs(var27.y - var20.y) < 3 and math.abs(var27.x - var20.x) < 3 then
			local var28 = table.remove(arg0.acCakes, iter3)

			if var28.callback then
				var28.callback()
			end

			Destroy(var28.tf)

			local var29
		end
	end
end

function var0.getTfOffset(arg0, arg1)
	for iter0 = 1, #arg0.chars do
		if arg0.chars[iter0]:getTf().name == arg1 then
			return arg0.chars[iter0]:getOffset()
		end
	end

	return Vector2(0, 0)
end

function var0.getFillterWanted(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if iter1:getCharActive() then
			local var1 = iter1:getJudge()

			for iter2 = 1, #arg0._judges do
				local var2 = arg0._judges[iter2]

				if (not var1 or var2 ~= var1) and not var2:isInServe() and not var2:isInTrigger() and var2:getWantedCake() then
					table.insert(var0, var2:getWantedCake())
				end
			end
		end
	end

	return var0
end

function var0.setCharAction(arg0, arg1, arg2, arg3)
	if not arg1:getCharActive() then
		return
	end

	if arg1:isActiving() then
		return
	end

	local var0 = arg1:getCakeIds()
	local var1 = arg1:isFullCakes()

	if #var0 > 0 then
		if arg1:getCake() then
			return
		elseif arg1:getJudge() then
			local var2 = arg1:getJudge()

			if var2:isInTrigger() and var2:isInServe() then
				arg1:clearJudge()
				arg1:stopMove()
			end

			return
		elseif not var1 and arg1:getPickupFull() then
			local var3 = arg2[math.random(1, #arg2)]

			arg0:onPickupCake(arg1, var3, arg3, false)

			return
		end

		local var4 = {}

		for iter0 = 1, #arg0._judges do
			local var5 = arg0._judges[iter0]

			if not var5:isInTrigger() and not var5:isInServe() then
				if table.contains(var0, var5:getWantedCake()) then
					table.insert(var4, var5)
				elseif arg1:getId() == 7 then
					table.insert(var4, var5)
				end
			end
		end

		if #var4 == 0 then
			if not arg1:getCake() then
				local var6 = arg2[math.random(1, #arg2)]

				arg0:onPickupCake(arg1, var6, arg3, false)
			end
		else
			local var7 = var4[math.random(1, #var4)]

			arg0:setJudgeAction(var7, arg1, function()
				return
			end)
		end
	elseif not arg1:getCake() then
		if arg1:getDoubleAble() and #var0 == 0 then
			arg1:setPickupFull(true)
		end

		if arg2 == nil then
			return
		end

		local var8 = arg2[math.random(1, #arg2)]

		arg0:onPickupCake(arg1, var8, arg3, false)
	end
end

function var0.createCharData(arg0, arg1)
	if not arg0.charDic then
		arg0.charDic = {}
	end

	if arg0.charDic[arg1] then
		return Clone(arg0.charDic[arg1])
	end

	local var0 = arg0:getBattleData(arg1)
	local var1 = {}
	local var2 = {}
	local var3 = var0.double_able
	local var4 = var0.speed_able
	local var5 = arg0._gameData.cake_num
	local var6 = var0.name

	if var3 then
		for iter0 = 0, var5 do
			for iter1 = 0, var5 do
				local var7

				if iter0 == 0 and iter1 == 0 or iter0 ~= 0 then
					var7 = var6 .. "_L" .. iter0 .. "_R" .. iter1
				end

				if var7 then
					local var8 = ResourceMgr.Inst:getAssetSync(arg0._gameData.char_path .. "/" .. var6, var7, typeof(RuntimeAnimatorController), false, false)

					table.insert(var2, {
						runtimeAnimator = var8,
						name = var7
					})
				end
			end
		end
	elseif var4 then
		for iter2 = 0, var5 do
			for iter3 = 0, arg0._gameData.speed_num do
				local var9 = var6 .. "_L" .. iter2 .. "_" .. iter3
				local var10 = ResourceMgr.Inst:getAssetSync(arg0._gameData.char_path .. "/" .. var6, var9, typeof(RuntimeAnimatorController), false, false)

				table.insert(var2, {
					runtimeAnimator = var10,
					name = var9
				})
			end
		end
	else
		for iter4 = 0, var5 do
			local var11 = var6 .. "_L" .. iter4
			local var12 = ResourceMgr.Inst:getAssetSync(arg0._gameData.char_path .. "/" .. var6, var11, typeof(RuntimeAnimatorController), false, false)

			table.insert(var2, {
				runtimeAnimator = var12,
				name = var11
			})
		end
	end

	var1.battleData = var0
	var1.animDatas = var2
	arg0.charDic[arg1] = var1

	return Clone(arg0.charDic[arg1])
end

function var0.createAcCake(arg0, arg1)
	if not arg0.acCakes then
		arg0.acCakes = {}
	end

	local var0 = arg1.cakeId
	local var1 = arg1.startPos
	local var2 = arg1.targetPos
	local var3 = arg1.callback
	local var4 = tf(instantiate(arg0._cakeTpl))

	GetSpriteFromAtlasAsync(arg0._gameData.path, "cake_" .. var0, function(arg0)
		setImageSprite(findTF(var4, "img"), arg0, true)
	end)
	SetParent(var4, arg0._scene)
	setActive(var4, true)

	var4.anchoredPosition = var1

	local var5 = {
		tf = var4,
		targetPos = var2,
		callback = var3
	}

	table.insert(arg0.acCakes, var5)
end

function var0.clearAcCake(arg0)
	if arg0.acCakes then
		for iter0 = 1, #arg0.acCakes do
			local var0 = arg0.acCakes[iter0].tf

			Destroy(var0)
		end
	end

	arg0.acCakes = {}
end

function var0.getBattleData(arg0, arg1)
	for iter0 = 1, #CookGameConst.char_battle_data do
		if CookGameConst.char_battle_data[iter0].id == arg1 then
			return Clone(CookGameConst.char_battle_data[iter0])
		end
	end

	return nil
end

function var0.setJudgeAction(arg0, arg1, arg2, arg3)
	arg2 = arg2 or arg0.playerChar

	if #arg2:getCakeIds() > 0 then
		local var0 = arg1:getTf()
		local var1 = arg1:getIndex()
		local var2 = arg2:getPos()
		local var3 = arg1:getPos()
		local var4

		if var2.x < var3.x then
			local var5 = arg1:getLeftTf()

			var4 = arg0._scene:InverseTransformPoint(var5.position)
		else
			local var6 = arg1:getRightTf()

			var4 = arg0._scene:InverseTransformPoint(var6.position)
		end

		local var7 = {
			judge = arg1,
			judgeIndex = var1,
			targetPos = var4,
			tf = var0,
			acPos = var2
		}

		arg2:setJudge(var7)

		if arg3 then
			arg3(true)
		end
	elseif arg3 then
		arg3(false)
	end
end

function var0.clear(arg0)
	arg0.playerChar:clear()
	arg0.partnerChar:clear()
	arg0.enemy1Char:clear()
	arg0.enemy2Char:clear()
	arg0:clearAcCake()
end

function var0.destroy(arg0)
	return
end

return var0
