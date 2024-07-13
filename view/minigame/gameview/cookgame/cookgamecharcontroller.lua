local var0_0 = class("CookGameCharController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneContainer = arg1_1
	arg0_1._scene = findTF(arg0_1._sceneContainer, "scene")
	arg0_1._tpl = findTF(arg1_1, "scene_background/charTpl")
	arg0_1._cakeTpl = findTF(arg1_1, "scene_background/cakeTpl")

	setActive(arg0_1._cakeTpl, false)
	setActive(arg0_1._tpl, false)

	arg0_1._gameData = arg2_1
	arg0_1._event = arg3_1
	arg0_1.playerChar = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)

	arg0_1.playerChar:isPlayer(true)

	arg0_1.partnerChar = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)

	arg0_1.partnerChar:isPartner(true)

	arg0_1.partnerPet = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)

	arg0_1.partnerPet:isPartner(true)

	arg0_1.enemy1Char = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)
	arg0_1.enemy2Char = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)
	arg0_1.enemyPet = CookGameChar.New(tf(instantiate(arg0_1._tpl)), arg0_1._gameData, arg0_1._event)

	arg0_1.playerChar:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.player_char])
	arg0_1.partnerChar:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.parter_char])
	arg0_1.partnerPet:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.parter_pet])
	arg0_1.enemy1Char:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy1_char])
	arg0_1.enemy2Char:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy2_char])
	arg0_1.enemyPet:setParent(arg0_1._sceneContainer, CookGameConst.char_instiate_data[CookGameConst.enemy_pet])
	arg0_1.enemy1Char:isPartner(false)
	arg0_1.enemy2Char:isPartner(false)
	arg0_1.enemyPet:isPartner(false)

	arg0_1.chars = {
		arg0_1.playerChar,
		arg0_1.partnerChar,
		arg0_1.enemy1Char,
		arg0_1.enemy2Char,
		arg0_1.partnerPet,
		arg0_1.enemyPet
	}
	arg0_1._playerBox = findTF(arg0_1._sceneContainer, "scene_background/playerBox")

	if not arg0_1.uiCam then
		arg0_1.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0_1._playerCollider = findTF(arg0_1._playerBox, "collider")
	arg0_1._playerColliderEvenet = GetComponent(arg0_1._playerCollider, typeof(EventTriggerListener))

	arg0_1._playerColliderEvenet:AddPointDownFunc(function(arg0_2, arg1_2)
		local var0_2 = arg0_1.uiCam:ScreenToWorldPoint(arg1_2.pressPosition)
		local var1_2 = arg0_1._scene:InverseTransformPoint(var0_2)

		arg0_1.playerChar:clearCake()
		arg0_1.playerChar:clearJudge()
		arg0_1.playerChar:setTargetPos(var1_2, nil)
	end)

	arg0_1.playerCakes = {}

	for iter0_1 = 1, arg0_1._gameData.cake_num do
		local var0_1 = iter0_1
		local var1_1 = findTF(arg0_1._playerBox, "table/cake/" .. iter0_1)
		local var2_1 = findTF(var1_1, "pos")
		local var3_1 = GetComponent(findTF(var1_1, "collider"), typeof(EventTriggerListener))

		var3_1:AddPointDownFunc(function(arg0_3, arg1_3)
			arg0_1:onPickupCake(arg0_1.playerChar, var0_1, arg0_1.playerCakes, true)
		end)
		table.insert(arg0_1.playerCakes, {
			tf = var1_1,
			pos = var2_1,
			id = var0_1,
			event = var3_1
		})
	end

	arg0_1.enemyCakes = {}
	arg0_1._enemyBox = findTF(arg0_1._sceneContainer, "scene_background/enemyBox")

	for iter1_1 = 1, arg0_1._gameData.cake_num do
		local var4_1 = iter1_1
		local var5_1 = findTF(arg0_1._enemyBox, "table/cake/" .. iter1_1)
		local var6_1 = findTF(var5_1, "pos")

		table.insert(arg0_1.enemyCakes, {
			tf = var5_1,
			pos = var6_1,
			id = var4_1,
			event = arg3_1
		})
	end

	arg0_1.acCakes = {}
end

function var0_0.changeSpeed(arg0_4, arg1_4)
	for iter0_4 = 1, #arg0_4.chars do
		arg0_4.chars[iter0_4]:changeSpeed(arg1_4)
	end
end

function var0_0.onPickupCake(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	if arg1_5:isActiving() then
		return
	end

	for iter0_5 = 1, #arg3_5 do
		local var0_5 = arg3_5[iter0_5]
		local var1_5 = var0_5.tf

		if var0_5.id == arg2_5 then
			local var2_5 = findTF(var0_5.tf, "pos")

			var0_5.cakePos = arg0_5._scene:InverseTransformPoint(var2_5.position)

			arg1_5:setCake(var0_5)

			if arg4_5 then
				setActive(findTF(var1_5, "select"), true)
			end
		else
			setActive(findTF(var1_5, "select"), false)
		end
	end
end

function var0_0.readyStart(arg0_6)
	arg0_6.playerChar:setData(arg0_6:createCharData(arg0_6._gameData.playerChar))
	arg0_6.partnerChar:setData(arg0_6:createCharData(arg0_6._gameData.partnerChar))

	if arg0_6._gameData.partnerPet then
		arg0_6.partnerPet:setData(arg0_6:createCharData(arg0_6._gameData.partnerPet))
	else
		arg0_6.partnerPet:setData(nil)
	end

	arg0_6.enemy1Char:setData(arg0_6:createCharData(arg0_6._gameData.enemy1Char))
	arg0_6.enemy2Char:setData(arg0_6:createCharData(arg0_6._gameData.enemy2Char))

	if arg0_6._gameData.enemyPet then
		arg0_6.enemyPet:setData(arg0_6:createCharData(arg0_6._gameData.enemyPet))
	else
		arg0_6.enemyPet:setData(nil)
	end

	arg0_6.playerChar:readyStart()
	arg0_6.partnerChar:readyStart()
	arg0_6.partnerPet:readyStart()
	arg0_6.enemy1Char:readyStart()
	arg0_6.enemy2Char:readyStart()
	arg0_6.enemyPet:readyStart()

	arg0_6.sceneTfs = nil
end

function var0_0.start(arg0_7)
	return
end

function var0_0.step(arg0_8, arg1_8)
	for iter0_8 = 1, #arg0_8.chars do
		local var0_8 = arg0_8.chars[iter0_8]

		if var0_8:getCharActive() then
			local var1_8 = var0_8:getTargetPos()
			local var2_8 = var0_8:getVelocity()

			if var1_8 then
				local var3_8 = var0_8:getPos()

				if not var2_8 then
					if math.abs(var1_8.y - var3_8.y) ~= 0 then
						local var4_8 = math.atan(math.abs(var1_8.y - var3_8.y) / math.abs(var1_8.x - var3_8.x))
						local var5_8 = var1_8.x > var3_8.x and 1 or -1
						local var6_8 = var1_8.y > var3_8.y and 1 or -1
						local var7_8 = math.cos(var4_8) * var5_8
						local var8_8 = math.sin(var4_8) * var6_8

						var0_8:setVelocity(var7_8, var8_8, var4_8)
					else
						var0_8:stopMove()
					end
				end
			elseif var0_8:getJudgeData() then
				var0_8:setTargetPos(var0_8:getJudgeData().targetPos)
			elseif var0_8:getCake() then
				var0_8:setTargetPos(var0_8:getCake().cakePos)
			end

			var0_8:step(arg1_8)
		end
	end

	if not arg0_8.sceneTfs then
		arg0_8.sceneTfs = {}

		local var9_8 = {}
		local var10_8 = arg0_8._scene.childCount

		arg0_8.judgeNum = 0

		for iter1_8 = 0, var10_8 - 1 do
			local var11_8 = arg0_8._scene:GetChild(iter1_8)

			if string.match(var11_8.name, "judge") then
				arg0_8.judgeNum = arg0_8.judgeNum + 1

				table.insert(var9_8, var11_8)
			else
				table.insert(arg0_8.sceneTfs, {
					tf = var11_8,
					offset = arg0_8:getTfOffset(var11_8.name)
				})
			end
		end

		table.sort(var9_8, function(arg0_9, arg1_9)
			if arg0_9.anchoredPosition.y > arg1_9.anchoredPosition.y then
				return true
			else
				return false
			end
		end)
	end

	table.sort(arg0_8.sceneTfs, function(arg0_10, arg1_10)
		local var0_10 = arg0_10.tf.anchoredPosition
		local var1_10 = arg0_10.offset and arg0_10.offset or Vector2(0, 0)
		local var2_10 = arg1_10.tf.anchoredPosition
		local var3_10 = arg1_10.offset and arg1_10.offset or Vector2(0, 0)

		if var0_10.y + var1_10.y > var2_10.y + var3_10.y then
			return true
		else
			return false
		end
	end)

	for iter2_8 = 1, #arg0_8.sceneTfs do
		arg0_8.sceneTfs[iter2_8].tf:SetSiblingIndex(iter2_8 - 1 + arg0_8.judgeNum)
	end

	if not arg0_8._judges then
		arg0_8._judges = arg0_8._gameData.judges
	end

	local var12_8 = arg0_8:getFillterWanted({
		arg0_8.partnerChar
	})
	local var13_8 = arg0_8:getFillterWanted({
		arg0_8.playerChar,
		arg0_8.partnerPet
	})
	local var14_8 = arg0_8:getFillterWanted({
		arg0_8.playerChar,
		arg0_8.partnerPet
	})
	local var15_8 = arg0_8:getFillterWanted({
		arg0_8.enemy2Char,
		arg0_8.enemyPet
	})
	local var16_8 = arg0_8:getFillterWanted({
		arg0_8.enemy1Char,
		arg0_8.enemyPet
	})
	local var17_8 = arg0_8:getFillterWanted({
		arg0_8.enemy1Char,
		arg0_8.enemy2Char
	})

	if CookGameConst.player_use_ai then
		arg0_8:setCharAction(arg0_8.playerChar, var13_8, arg0_8.playerCakes)
	end

	arg0_8:setCharAction(arg0_8.partnerChar, var12_8, arg0_8.playerCakes)
	arg0_8:setCharAction(arg0_8.partnerPet, var14_8, arg0_8.playerCakes)

	if arg0_8._gameData.gameTime and arg0_8._gameData.gameTime > 0 then
		arg0_8:setCharAction(arg0_8.enemy1Char, var15_8, arg0_8.enemyCakes)
		arg0_8:setCharAction(arg0_8.enemy2Char, var16_8, arg0_8.enemyCakes)
		arg0_8:setCharAction(arg0_8.enemyPet, var17_8, arg0_8.enemyCakes)
	end

	for iter3_8 = #arg0_8.acCakes, 1, -1 do
		local var18_8 = arg0_8.acCakes[iter3_8].tf
		local var19_8 = arg0_8.acCakes[iter3_8].tf.anchoredPosition
		local var20_8 = arg0_8.acCakes[iter3_8].targetPos
		local var21_8 = math.atan(math.abs(var20_8.y - var19_8.y) / math.abs(var20_8.x - var19_8.x))
		local var22_8 = var20_8.x > var19_8.x and 1 or -1
		local var23_8 = var20_8.y > var19_8.y and 1 or -1
		local var24_8 = math.cos(var21_8) * var22_8 * 600 * arg1_8
		local var25_8 = math.sin(var21_8) * var23_8 * 600 * arg1_8
		local var26_8 = Vector2(var19_8.x + var24_8, var19_8.y + var25_8)
		local var27_8 = arg0_8.acCakes[iter3_8].tf.anchoredPosition

		if var19_8.x < var20_8.x and var26_8.x < var20_8.x then
			var27_8.x = var26_8.x
		elseif var19_8.x > var20_8.x and var26_8.x > var20_8.x then
			var27_8.x = var26_8.x
		else
			var27_8.x = var20_8.x
		end

		if var19_8.y < var20_8.y and var26_8.y < var20_8.y then
			var27_8.y = var26_8.y
		elseif var19_8.y > var20_8.y and var26_8.y > var20_8.y then
			var27_8.y = var26_8.y
		else
			var27_8.y = var20_8.y
		end

		arg0_8.acCakes[iter3_8].tf.anchoredPosition = var27_8

		if math.abs(var27_8.y - var20_8.y) < 3 and math.abs(var27_8.x - var20_8.x) < 3 then
			local var28_8 = table.remove(arg0_8.acCakes, iter3_8)

			if var28_8.callback then
				var28_8.callback()
			end

			Destroy(var28_8.tf)

			local var29_8
		end
	end
end

function var0_0.getTfOffset(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11.chars do
		if arg0_11.chars[iter0_11]:getTf().name == arg1_11 then
			return arg0_11.chars[iter0_11]:getOffset()
		end
	end

	return Vector2(0, 0)
end

function var0_0.getFillterWanted(arg0_12, arg1_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		if iter1_12:getCharActive() then
			local var1_12 = iter1_12:getJudge()

			for iter2_12 = 1, #arg0_12._judges do
				local var2_12 = arg0_12._judges[iter2_12]

				if (not var1_12 or var2_12 ~= var1_12) and not var2_12:isInServe() and not var2_12:isInTrigger() and var2_12:getWantedCake() then
					table.insert(var0_12, var2_12:getWantedCake())
				end
			end
		end
	end

	return var0_12
end

function var0_0.setCharAction(arg0_13, arg1_13, arg2_13, arg3_13)
	if not arg1_13:getCharActive() then
		return
	end

	if arg1_13:isActiving() then
		return
	end

	local var0_13 = arg1_13:getCakeIds()
	local var1_13 = arg1_13:isFullCakes()

	if #var0_13 > 0 then
		if arg1_13:getCake() then
			return
		elseif arg1_13:getJudge() then
			local var2_13 = arg1_13:getJudge()

			if var2_13:isInTrigger() and var2_13:isInServe() then
				arg1_13:clearJudge()
				arg1_13:stopMove()
			end

			return
		elseif not var1_13 and arg1_13:getPickupFull() then
			local var3_13 = arg2_13[math.random(1, #arg2_13)]

			arg0_13:onPickupCake(arg1_13, var3_13, arg3_13, false)

			return
		end

		local var4_13 = {}

		for iter0_13 = 1, #arg0_13._judges do
			local var5_13 = arg0_13._judges[iter0_13]

			if not var5_13:isInTrigger() and not var5_13:isInServe() then
				if table.contains(var0_13, var5_13:getWantedCake()) then
					table.insert(var4_13, var5_13)
				elseif arg1_13:getId() == 7 then
					table.insert(var4_13, var5_13)
				end
			end
		end

		if #var4_13 == 0 then
			if not arg1_13:getCake() then
				local var6_13 = arg2_13[math.random(1, #arg2_13)]

				arg0_13:onPickupCake(arg1_13, var6_13, arg3_13, false)
			end
		else
			local var7_13 = var4_13[math.random(1, #var4_13)]

			arg0_13:setJudgeAction(var7_13, arg1_13, function()
				return
			end)
		end
	elseif not arg1_13:getCake() then
		if arg1_13:getDoubleAble() and #var0_13 == 0 then
			arg1_13:setPickupFull(true)
		end

		if arg2_13 == nil then
			return
		end

		local var8_13 = arg2_13[math.random(1, #arg2_13)]

		arg0_13:onPickupCake(arg1_13, var8_13, arg3_13, false)
	end
end

function var0_0.createCharData(arg0_15, arg1_15)
	if not arg0_15.charDic then
		arg0_15.charDic = {}
	end

	if arg0_15.charDic[arg1_15] then
		return Clone(arg0_15.charDic[arg1_15])
	end

	local var0_15 = arg0_15:getBattleData(arg1_15)
	local var1_15 = {}
	local var2_15 = {}
	local var3_15 = var0_15.double_able
	local var4_15 = var0_15.speed_able
	local var5_15 = arg0_15._gameData.cake_num
	local var6_15 = var0_15.name

	if var3_15 then
		for iter0_15 = 0, var5_15 do
			for iter1_15 = 0, var5_15 do
				local var7_15

				if iter0_15 == 0 and iter1_15 == 0 or iter0_15 ~= 0 then
					var7_15 = var6_15 .. "_L" .. iter0_15 .. "_R" .. iter1_15
				end

				if var7_15 then
					local var8_15 = ResourceMgr.Inst:getAssetSync(arg0_15._gameData.char_path .. "/" .. var6_15, var7_15, typeof(RuntimeAnimatorController), false, false)

					table.insert(var2_15, {
						runtimeAnimator = var8_15,
						name = var7_15
					})
				end
			end
		end
	elseif var4_15 then
		for iter2_15 = 0, var5_15 do
			for iter3_15 = 0, arg0_15._gameData.speed_num do
				local var9_15 = var6_15 .. "_L" .. iter2_15 .. "_" .. iter3_15
				local var10_15 = ResourceMgr.Inst:getAssetSync(arg0_15._gameData.char_path .. "/" .. var6_15, var9_15, typeof(RuntimeAnimatorController), false, false)

				table.insert(var2_15, {
					runtimeAnimator = var10_15,
					name = var9_15
				})
			end
		end
	else
		for iter4_15 = 0, var5_15 do
			local var11_15 = var6_15 .. "_L" .. iter4_15
			local var12_15 = ResourceMgr.Inst:getAssetSync(arg0_15._gameData.char_path .. "/" .. var6_15, var11_15, typeof(RuntimeAnimatorController), false, false)

			table.insert(var2_15, {
				runtimeAnimator = var12_15,
				name = var11_15
			})
		end
	end

	var1_15.battleData = var0_15
	var1_15.animDatas = var2_15
	arg0_15.charDic[arg1_15] = var1_15

	return Clone(arg0_15.charDic[arg1_15])
end

function var0_0.createAcCake(arg0_16, arg1_16)
	if not arg0_16.acCakes then
		arg0_16.acCakes = {}
	end

	local var0_16 = arg1_16.cakeId
	local var1_16 = arg1_16.startPos
	local var2_16 = arg1_16.targetPos
	local var3_16 = arg1_16.callback
	local var4_16 = tf(instantiate(arg0_16._cakeTpl))

	GetSpriteFromAtlasAsync(arg0_16._gameData.path, "cake_" .. var0_16, function(arg0_17)
		setImageSprite(findTF(var4_16, "img"), arg0_17, true)
	end)
	SetParent(var4_16, arg0_16._scene)
	setActive(var4_16, true)

	var4_16.anchoredPosition = var1_16

	local var5_16 = {
		tf = var4_16,
		targetPos = var2_16,
		callback = var3_16
	}

	table.insert(arg0_16.acCakes, var5_16)
end

function var0_0.clearAcCake(arg0_18)
	if arg0_18.acCakes then
		for iter0_18 = 1, #arg0_18.acCakes do
			local var0_18 = arg0_18.acCakes[iter0_18].tf

			Destroy(var0_18)
		end
	end

	arg0_18.acCakes = {}
end

function var0_0.getBattleData(arg0_19, arg1_19)
	for iter0_19 = 1, #CookGameConst.char_battle_data do
		if CookGameConst.char_battle_data[iter0_19].id == arg1_19 then
			return Clone(CookGameConst.char_battle_data[iter0_19])
		end
	end

	return nil
end

function var0_0.setJudgeAction(arg0_20, arg1_20, arg2_20, arg3_20)
	arg2_20 = arg2_20 or arg0_20.playerChar

	if #arg2_20:getCakeIds() > 0 then
		local var0_20 = arg1_20:getTf()
		local var1_20 = arg1_20:getIndex()
		local var2_20 = arg2_20:getPos()
		local var3_20 = arg1_20:getPos()
		local var4_20

		if var2_20.x < var3_20.x then
			local var5_20 = arg1_20:getLeftTf()

			var4_20 = arg0_20._scene:InverseTransformPoint(var5_20.position)
		else
			local var6_20 = arg1_20:getRightTf()

			var4_20 = arg0_20._scene:InverseTransformPoint(var6_20.position)
		end

		local var7_20 = {
			judge = arg1_20,
			judgeIndex = var1_20,
			targetPos = var4_20,
			tf = var0_20,
			acPos = var2_20
		}

		arg2_20:setJudge(var7_20)

		if arg3_20 then
			arg3_20(true)
		end
	elseif arg3_20 then
		arg3_20(false)
	end
end

function var0_0.clear(arg0_21)
	arg0_21.playerChar:clear()
	arg0_21.partnerChar:clear()
	arg0_21.enemy1Char:clear()
	arg0_21.enemy2Char:clear()
	arg0_21:clearAcCake()
end

function var0_0.destroy(arg0_22)
	return
end

return var0_0
