local var0 = class("BeachGuardGameUI")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._event = arg3
	arg0._gameData = arg2
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.asset = arg0._gameData.asset
	arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))

	onButton(arg0._event, findTF(arg0.gameUI, "ad/topRight/btnStop"), function()
		arg0._event:emit(BeachGuardGameView.OPEN_PAUSE_UI)
		arg0._event:emit(BeachGuardGameView.PAUSE_GAME, true)
	end)
	onButton(arg0._event, findTF(arg0.gameUI, "ad/btnLeave"), function()
		arg0._event:emit(BeachGuardGameView.OPEN_LEVEL_UI)
		arg0._event:emit(BeachGuardGameView.PAUSE_GAME, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "ad/top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "ad/top/score")
	arg0.bottom = findTF(arg0.gameUI, "bottom")
	arg0.goods = findTF(arg0.gameUI, "bottom/goods")
	arg0.goodsNum = findTF(arg0.gameUI, "bottom/goods/num")
	arg0.goodsAdd = findTF(arg0.gameUI, "bottom/goods/add")
	arg0.charContent = findTF(arg0.gameUI, "bottom/charContainer/content")
	arg0.cardTpl = findTF(arg0.gameUI, "bottom/cardTpl")
	arg0.dragChar = findTF(arg0.gameUI, "bottom/dragChar")

	setActive(arg0.dragChar, false)

	arg0.cards = {}
	arg0.cardPool = {}
	arg0.dragData = {}
	arg0.recycleFlag = false
	arg0.btnRecycle = findTF(arg0.gameUI, "bottom/recycles")

	onButton(arg0._event, arg0.btnRecycle, function()
		arg0.recycleFlag = true

		setActive(arg0.btnRecycle, false)
		setActive(arg0.btnMask, true)
		arg0._event:emit(BeachGuardGameView.RECYCLES_CHAR, true)
	end)

	arg0.enemyComming = findTF(arg0.gameUI, "enemyComming")
	arg0.btnMask = findTF(arg0.gameUI, "bottom/recycleMask")

	onButton(arg0._event, arg0.btnMask, function()
		arg0:cancelRecycle()
	end)

	arg0.enemyProgress = findTF(arg0.gameUI, "ad/enemyProgress")
	arg0.bossRate = findTF(arg0.gameUI, "ad/bossRate")
end

function var0.cancelRecycle(arg0)
	arg0.recycleFlag = false

	setActive(arg0.btnRecycle, true)
	setActive(arg0.btnMask, false)
	arg0._event:emit(BeachGuardGameView.RECYCLES_CHAR, false)
end

function var0.show(arg0, arg1)
	arg0.recycleFlag = false

	setActive(arg0.btnRecycle, true)
	setActive(arg0.btnMask, false)
	setActive(arg0.gameUI, arg1)
end

function var0.firstUpdate(arg0, arg1)
	local var0 = arg1.chapter
	local var1 = BeachGuardConst.chapter_data[var0]

	arg0.enemyTime = BeachGuardConst.chapater_enemy[var0].time

	if not arg0.enemyTime or arg0.enemyTime == 0 then
		setActive(arg0.enemyProgress, false)
		setActive(arg0.bossRate, false)
	else
		setActive(arg0.enemyProgress, true)
		setActive(arg0.bossRate, true)
	end

	arg0.bossRateNum = BeachGuardConst.chapater_enemy[var0].boss_rate

	if not arg0.bossRateNum or arg0.bossRateNum == 0 then
		setActive(arg0.bossRate, false)
	else
		setActive(arg0.bossRate, true)
		setSlider(arg0.bossRate, 0, 1, arg0.bossRateNum)
	end

	setActive(arg0.enemyComming, false)

	arg0.showCards = var1.show_card
	arg0.runningData = arg1
	arg0.recycleFlag = false

	setActive(arg0.btnRecycle, true)
	setActive(arg0.btnMask, false)
	setActive(arg0.goodsAdd, false)
	arg0:resetChaCard()
	arg0:createCharCard()
	arg0:update()
end

function var0.update(arg0)
	local var0 = arg0.runningData.goodsNum
	local var1 = arg0.runningData.sceneChars

	for iter0 = 1, #arg0.cards do
		local var2 = arg0.cards[iter0].config
		local var3 = arg0.cards[iter0].tf
		local var4 = var2.cost
		local var5 = var2.once
		local var6 = var2.char_id
		local var7 = GetComponent(var3, typeof(CanvasGroup))

		if var0 < var4 then
			var7.blocksRaycasts = false
			var7.interactable = false

			setActive(findTF(var3, "mask"), true)
		elseif var5 and table.contains(var1, var6) then
			var7.blocksRaycasts = false
			var7.interactable = false

			setActive(findTF(var3, "mask"), true)
		else
			var7.blocksRaycasts = true
			var7.interactable = true

			setActive(findTF(var3, "mask"), false)
		end
	end

	setText(arg0.scoreTf, arg0.runningData.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.runningData.gameTime))

	if arg0.enemyTime and arg0.enemyTime > 0 then
		local var8 = (arg0.enemyTime - arg0.runningData.gameStepTime) / arg0.enemyTime

		setSlider(arg0.enemyProgress, 0, 1, var8)
	end

	setText(arg0.goodsNum, var0)
end

function var0.updateGoods(arg0, arg1, arg2)
	if arg1 and arg1 > 0 then
		setActive(arg0.goodsAdd, false)
		setText(findTF(arg0.goodsAdd, "text"), "+" .. tostring(arg1))
		setActive(arg0.goodsAdd, true)
	end
end

function var0.createCharCard(arg0)
	for iter0 = 1, #arg0.showCards do
		local var0 = iter0
		local var1 = BeachGuardConst.char_card[arg0.showCards[iter0]]
		local var2 = arg0:getCardFromPool(var1.id)
		local var3

		if not var2 then
			var3 = tf(instantiate(arg0.cardTpl))

			SetParent(var3, arg0.charContent)

			var2 = {
				tf = var3,
				config = var1
			}
		else
			var3 = var2.tf
		end

		table.insert(arg0.cards, var2)
		setActive(var3, true)

		local var4 = GetComponent(findTF(var3, "icon"), typeof(Image))

		var4.sprite = BeachGuardAsset.getCardQIcon(var1.icon)

		var4:SetNativeSize()

		local var5 = GetOrAddComponent(var3, typeof(EventTriggerListener))

		ClearEventTrigger(var5)
		var5:AddBeginDragFunc(function(arg0, arg1)
			if arg0.recycleFlag then
				return
			end

			setActive(arg0.dragChar, true)

			local var0 = GetComponent(findTF(arg0.dragChar, "icon"), typeof(Image))

			var0.sprite = BeachGuardAsset.getCardIcon(var1.icon)

			var0:SetNativeSize()

			arg0.dragData = {
				flag = true,
				config = var1
			}

			arg0._event:emit(BeachGuardGameView.DRAG_CHAR, arg0.dragData)
		end)
		var5:AddDragFunc(function(arg0, arg1)
			if arg0.recycleFlag then
				return
			end

			local var0 = arg1.position

			var0.y = var0.y

			local var1 = arg0._uiCamera:ScreenToWorldPoint(var0)

			arg0.dragChar.anchoredPosition = arg0.bottom:InverseTransformPoint(var1)

			if not arg0.dragData.pos then
				arg0.dragData.pos = Vector3(0, 0)
			end

			arg0.dragData.pos.x = var1.x
			arg0.dragData.pos.y = var1.y
			arg0.dragData.pos.z = var1.z
		end)
		var5:AddDragEndFunc(function(arg0, arg1)
			if arg0.recycleFlag then
				return
			end

			setActive(arg0.dragChar, false)

			arg0.dragData.flag = false
			arg0.dragData.pos = nil

			arg0._event:emit(BeachGuardGameView.DRAG_CHAR, arg0.dragData)
		end)
		setText(findTF(var3, "cost"), tostring(var1.cost))
	end
end

function var0.getCardFromPool(arg0, arg1)
	for iter0 = #arg0.cardPool, 1, -1 do
		if arg0.cardPool[iter0].config.id == arg1 then
			return table.remove(arg0.cardPool, iter0)
		end
	end

	return nil
end

function var0.resetChaCard(arg0)
	for iter0 = 1, #arg0.cards do
		local var0 = arg0.cards[iter0].tf

		setActive(findTF(var0, "mask"), false)

		GetComponent(findTF(var0, "icon"), typeof(Image)).sprite = nil

		setText(findTF(var0, "cost"), "0")
		setActive(var0, false)

		local var1 = GetOrAddComponent(var0, typeof(EventTriggerListener))

		ClearEventTrigger(var1)
	end

	for iter1 = #arg0.cards, 1, -1 do
		local var2 = table.remove(arg0.cards, iter1)

		table.insert(arg0.cardPool, var2)
	end
end

function var0.setEnemyComming(arg0)
	setActive(arg0.enemyComming, false)
	setActive(arg0.enemyComming, true)
end

function var0.setDragCallback(arg0, arg1)
	return
end

return var0
