local var0_0 = class("BeachGuardGameUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg3_1
	arg0_1._gameData = arg2_1
	arg0_1.gameUI = findTF(arg0_1._tf, "ui/gameUI")
	arg0_1.asset = arg0_1._gameData.asset
	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))

	onButton(arg0_1._event, findTF(arg0_1.gameUI, "ad/topRight/btnStop"), function()
		arg0_1._event:emit(BeachGuardGameView.OPEN_PAUSE_UI)
		arg0_1._event:emit(BeachGuardGameView.PAUSE_GAME, true)
	end)
	onButton(arg0_1._event, findTF(arg0_1.gameUI, "ad/btnLeave"), function()
		arg0_1._event:emit(BeachGuardGameView.OPEN_LEVEL_UI)
		arg0_1._event:emit(BeachGuardGameView.PAUSE_GAME, true)
	end)

	arg0_1.gameTimeS = findTF(arg0_1.gameUI, "ad/top/time/s")
	arg0_1.scoreTf = findTF(arg0_1.gameUI, "ad/top/score")
	arg0_1.bottom = findTF(arg0_1.gameUI, "bottom")
	arg0_1.goods = findTF(arg0_1.gameUI, "bottom/goods")
	arg0_1.goodsNum = findTF(arg0_1.gameUI, "bottom/goods/num")
	arg0_1.goodsAdd = findTF(arg0_1.gameUI, "bottom/goods/add")
	arg0_1.charContent = findTF(arg0_1.gameUI, "bottom/charContainer/content")
	arg0_1.cardTpl = findTF(arg0_1.gameUI, "bottom/cardTpl")
	arg0_1.dragChar = findTF(arg0_1.gameUI, "bottom/dragChar")

	setActive(arg0_1.dragChar, false)

	arg0_1.cards = {}
	arg0_1.cardPool = {}
	arg0_1.dragData = {}
	arg0_1.recycleFlag = false
	arg0_1.btnRecycle = findTF(arg0_1.gameUI, "bottom/recycles")

	onButton(arg0_1._event, arg0_1.btnRecycle, function()
		arg0_1.recycleFlag = true

		setActive(arg0_1.btnRecycle, false)
		setActive(arg0_1.btnMask, true)
		arg0_1._event:emit(BeachGuardGameView.RECYCLES_CHAR, true)
	end)

	arg0_1.enemyComming = findTF(arg0_1.gameUI, "enemyComming")
	arg0_1.btnMask = findTF(arg0_1.gameUI, "bottom/recycleMask")

	onButton(arg0_1._event, arg0_1.btnMask, function()
		arg0_1:cancelRecycle()
	end)

	arg0_1.enemyProgress = findTF(arg0_1.gameUI, "ad/enemyProgress")
	arg0_1.bossRate = findTF(arg0_1.gameUI, "ad/bossRate")
end

function var0_0.cancelRecycle(arg0_6)
	arg0_6.recycleFlag = false

	setActive(arg0_6.btnRecycle, true)
	setActive(arg0_6.btnMask, false)
	arg0_6._event:emit(BeachGuardGameView.RECYCLES_CHAR, false)
end

function var0_0.show(arg0_7, arg1_7)
	arg0_7.recycleFlag = false

	setActive(arg0_7.btnRecycle, true)
	setActive(arg0_7.btnMask, false)
	setActive(arg0_7.gameUI, arg1_7)
end

function var0_0.firstUpdate(arg0_8, arg1_8)
	local var0_8 = arg1_8.chapter
	local var1_8 = BeachGuardConst.chapter_data[var0_8]

	arg0_8.enemyTime = BeachGuardConst.chapater_enemy[var0_8].time

	if not arg0_8.enemyTime or arg0_8.enemyTime == 0 then
		setActive(arg0_8.enemyProgress, false)
		setActive(arg0_8.bossRate, false)
	else
		setActive(arg0_8.enemyProgress, true)
		setActive(arg0_8.bossRate, true)
	end

	arg0_8.bossRateNum = BeachGuardConst.chapater_enemy[var0_8].boss_rate

	if not arg0_8.bossRateNum or arg0_8.bossRateNum == 0 then
		setActive(arg0_8.bossRate, false)
	else
		setActive(arg0_8.bossRate, true)
		setSlider(arg0_8.bossRate, 0, 1, arg0_8.bossRateNum)
	end

	setActive(arg0_8.enemyComming, false)

	arg0_8.showCards = var1_8.show_card
	arg0_8.runningData = arg1_8
	arg0_8.recycleFlag = false

	setActive(arg0_8.btnRecycle, true)
	setActive(arg0_8.btnMask, false)
	setActive(arg0_8.goodsAdd, false)
	arg0_8:resetChaCard()
	arg0_8:createCharCard()
	arg0_8:update()
end

function var0_0.update(arg0_9)
	local var0_9 = arg0_9.runningData.goodsNum
	local var1_9 = arg0_9.runningData.sceneChars

	for iter0_9 = 1, #arg0_9.cards do
		local var2_9 = arg0_9.cards[iter0_9].config
		local var3_9 = arg0_9.cards[iter0_9].tf
		local var4_9 = var2_9.cost
		local var5_9 = var2_9.once
		local var6_9 = var2_9.char_id
		local var7_9 = GetComponent(var3_9, typeof(CanvasGroup))

		if var0_9 < var4_9 then
			var7_9.blocksRaycasts = false
			var7_9.interactable = false

			setActive(findTF(var3_9, "mask"), true)
		elseif var5_9 and table.contains(var1_9, var6_9) then
			var7_9.blocksRaycasts = false
			var7_9.interactable = false

			setActive(findTF(var3_9, "mask"), true)
		else
			var7_9.blocksRaycasts = true
			var7_9.interactable = true

			setActive(findTF(var3_9, "mask"), false)
		end
	end

	setText(arg0_9.scoreTf, arg0_9.runningData.scoreNum)
	setText(arg0_9.gameTimeS, math.ceil(arg0_9.runningData.gameTime))

	if arg0_9.enemyTime and arg0_9.enemyTime > 0 then
		local var8_9 = (arg0_9.enemyTime - arg0_9.runningData.gameStepTime) / arg0_9.enemyTime

		setSlider(arg0_9.enemyProgress, 0, 1, var8_9)
	end

	setText(arg0_9.goodsNum, var0_9)
end

function var0_0.updateGoods(arg0_10, arg1_10, arg2_10)
	if arg1_10 and arg1_10 > 0 then
		setActive(arg0_10.goodsAdd, false)
		setText(findTF(arg0_10.goodsAdd, "text"), "+" .. tostring(arg1_10))
		setActive(arg0_10.goodsAdd, true)
	end
end

function var0_0.createCharCard(arg0_11)
	for iter0_11 = 1, #arg0_11.showCards do
		local var0_11 = iter0_11
		local var1_11 = BeachGuardConst.char_card[arg0_11.showCards[iter0_11]]
		local var2_11 = arg0_11:getCardFromPool(var1_11.id)
		local var3_11

		if not var2_11 then
			var3_11 = tf(instantiate(arg0_11.cardTpl))

			SetParent(var3_11, arg0_11.charContent)

			var2_11 = {
				tf = var3_11,
				config = var1_11
			}
		else
			var3_11 = var2_11.tf
		end

		table.insert(arg0_11.cards, var2_11)
		setActive(var3_11, true)

		local var4_11 = GetComponent(findTF(var3_11, "icon"), typeof(Image))

		var4_11.sprite = BeachGuardAsset.getCardQIcon(var1_11.icon)

		var4_11:SetNativeSize()

		local var5_11 = GetOrAddComponent(var3_11, typeof(EventTriggerListener))

		ClearEventTrigger(var5_11)
		var5_11:AddBeginDragFunc(function(arg0_12, arg1_12)
			if arg0_11.recycleFlag then
				return
			end

			setActive(arg0_11.dragChar, true)

			local var0_12 = GetComponent(findTF(arg0_11.dragChar, "icon"), typeof(Image))

			var0_12.sprite = BeachGuardAsset.getCardIcon(var1_11.icon)

			var0_12:SetNativeSize()

			arg0_11.dragData = {
				flag = true,
				config = var1_11
			}

			arg0_11._event:emit(BeachGuardGameView.DRAG_CHAR, arg0_11.dragData)
		end)
		var5_11:AddDragFunc(function(arg0_13, arg1_13)
			if arg0_11.recycleFlag then
				return
			end

			local var0_13 = arg1_13.position

			var0_13.y = var0_13.y

			local var1_13 = arg0_11._uiCamera:ScreenToWorldPoint(var0_13)

			arg0_11.dragChar.anchoredPosition = arg0_11.bottom:InverseTransformPoint(var1_13)

			if not arg0_11.dragData.pos then
				arg0_11.dragData.pos = Vector3(0, 0)
			end

			arg0_11.dragData.pos.x = var1_13.x
			arg0_11.dragData.pos.y = var1_13.y
			arg0_11.dragData.pos.z = var1_13.z
		end)
		var5_11:AddDragEndFunc(function(arg0_14, arg1_14)
			if arg0_11.recycleFlag then
				return
			end

			setActive(arg0_11.dragChar, false)

			arg0_11.dragData.flag = false
			arg0_11.dragData.pos = nil

			arg0_11._event:emit(BeachGuardGameView.DRAG_CHAR, arg0_11.dragData)
		end)
		setText(findTF(var3_11, "cost"), tostring(var1_11.cost))
	end
end

function var0_0.getCardFromPool(arg0_15, arg1_15)
	for iter0_15 = #arg0_15.cardPool, 1, -1 do
		if arg0_15.cardPool[iter0_15].config.id == arg1_15 then
			return table.remove(arg0_15.cardPool, iter0_15)
		end
	end

	return nil
end

function var0_0.resetChaCard(arg0_16)
	for iter0_16 = 1, #arg0_16.cards do
		local var0_16 = arg0_16.cards[iter0_16].tf

		setActive(findTF(var0_16, "mask"), false)

		GetComponent(findTF(var0_16, "icon"), typeof(Image)).sprite = nil

		setText(findTF(var0_16, "cost"), "0")
		setActive(var0_16, false)

		local var1_16 = GetOrAddComponent(var0_16, typeof(EventTriggerListener))

		ClearEventTrigger(var1_16)
	end

	for iter1_16 = #arg0_16.cards, 1, -1 do
		local var2_16 = table.remove(arg0_16.cards, iter1_16)

		table.insert(arg0_16.cardPool, var2_16)
	end
end

function var0_0.setEnemyComming(arg0_17)
	setActive(arg0_17.enemyComming, false)
	setActive(arg0_17.enemyComming, true)
end

function var0_0.setDragCallback(arg0_18, arg1_18)
	return
end

return var0_0
