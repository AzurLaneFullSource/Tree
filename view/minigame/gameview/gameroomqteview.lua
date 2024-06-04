local var0 = class("GameRoomQTEView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "GameRoomQTEUI"
end

function var0.init(arg0)
	arg0.STATE_BEGIN = 1
	arg0.STATE_COUNT = 2
	arg0.STATE_CLICK = 3
	arg0.STATE_SHOW = 4
	arg0.STATE_END = 5
	arg0.gameState = -1
	arg0.typeNum = 3
	arg0.idNum = 3
	arg0.limitNum = 5
	arg0.TYPE_A = 1
	arg0.TYPE_B = 2
	arg0.TYPE_C = 3
	arg0.ITEM_ID_1 = 1
	arg0.ITEM_ID_2 = 2
	arg0.ITEM_ID_3 = 3
	arg0.startUI = arg0:findTF("start_ui")
	arg0.startBtn = arg0:findTF("start_btn", arg0.startUI)
	arg0.ruleBtn = arg0:findTF("rule_btn", arg0.startUI)
	arg0.qBtn = arg0:findTF("q_btn", arg0.startUI)
	arg0.countUI = arg0:findTF("count_ui")
	arg0.countNumTxt = arg0:findTF("num", arg0.countUI)
	arg0.endUI = arg0:findTF("end_ui")
	arg0.endExitBtn = arg0:findTF("exit_btn", arg0.endUI)
	arg0.endBestTxt = arg0:findTF("rope/paper/best_txt", arg0.endUI)
	arg0.endScoreTxt = arg0:findTF("rope/paper/score_txt", arg0.endUI)
	arg0.endComboTxt = arg0:findTF("rope/paper/combo_txt", arg0.endUI)
	arg0.endMissTxt = arg0:findTF("rope/paper/miss_txt", arg0.endUI)
	arg0.endHitTxt = arg0:findTF("rope/paper/hit_txt", arg0.endUI)
	arg0.endUIEvent = arg0:findTF("rope", arg0.endUI):GetComponent("DftAniEvent")
	arg0.content = arg0:findTF("content")
	arg0.res = arg0:findTF("res")
	arg0.gameBg = arg0:findTF("game_bg", arg0.content)
	arg0.xgmPos = arg0:findTF("xiongguimao_pos", arg0.content)
	arg0.guinuPos = arg0:findTF("guinu_pos", arg0.content)
	arg0.bucketA = arg0:findTF("content/bucket_A")
	arg0.bucketASpine = arg0.bucketA:GetComponent("SpineAnimUI")
	arg0.bucketAGraphic = arg0.bucketA:GetComponent("SkeletonGraphic")
	arg0.bucketB = arg0:findTF("content/bucket_B")
	arg0.bucketBSpine = arg0.bucketB:GetComponent("SpineAnimUI")
	arg0.bucketBGraphic = arg0.bucketB:GetComponent("SkeletonGraphic")
	arg0.bucketC = arg0:findTF("content/bucket_C")
	arg0.msHand = arg0:findTF("ani", arg0.bucketC)
	arg0.msHandAnimator = arg0.msHand:GetComponent("Animator")
	arg0.msHandSlot = arg0:findTF("slot", arg0.msHand)
	arg0.msHandEvent = arg0.msHand:GetComponent("DftAniEvent")
	arg0.msBlockList = {}

	arg0.msHandEvent:SetEndEvent(function()
		arg0:msClearHold()
		setActive(arg0.msHand, false)
	end)

	arg0.xgmAnimLength = {
		idle = 1,
		attack = 1
	}
	arg0.xgmAnimTargetLength = {
		idle = 1,
		attack = 0.5
	}
	arg0.guinuAnimLength = {
		attack = 1,
		normal = 4.667
	}
	arg0.guinuAnimTargetLength = {
		attack = 1,
		normal = 4.667
	}
	arg0.bucketAAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	arg0.bucketAAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	arg0.bucketBAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	arg0.bucketBAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	arg0.cut1 = arg0:findTF("cut_1", arg0.bucketB)
	arg0.cut2 = arg0:findTF("cut_2", arg0.bucketB)
	arg0.cut3 = arg0:findTF("cut_3", arg0.bucketB)
	arg0.cut1Animator = arg0.cut1:GetComponent("Animator")
	arg0.cut2Animator = arg0.cut2:GetComponent("Animator")
	arg0.cut3Animator = arg0.cut3:GetComponent("Animator")
	arg0.cut1Event = arg0.cut1:GetComponent("DftAniEvent")
	arg0.cut2Event = arg0.cut2:GetComponent("DftAniEvent")
	arg0.cut3Event = arg0.cut3:GetComponent("DftAniEvent")

	arg0.cut1Event:SetEndEvent(function()
		setActive(arg0.cut1, false)
	end)
	arg0.cut2Event:SetEndEvent(function()
		setActive(arg0.cut2, false)
	end)
	arg0.cut3Event:SetEndEvent(function()
		setActive(arg0.cut3, false)
	end)

	arg0.keyUI = arg0:findTF("key_ui", arg0.content)
	arg0.keyBar = arg0:findTF("key_bar", arg0.keyUI)
	arg0.aBtn = arg0:findTF("A_btn", arg0.keyUI)
	arg0.bBtn = arg0:findTF("B_btn", arg0.keyUI)
	arg0.cBtn = arg0:findTF("C_btn", arg0.keyUI)
	arg0.comboAni = arg0:findTF("combo_bar/center", arg0.content):GetComponent("Animator")
	arg0.comboTxt = arg0:findTF("combo_bar/center/combo_txt", arg0.content)
	arg0.comboAni.enabled = false
	arg0.scoreTxt = arg0:findTF("score_bar/txt", arg0.content)
	arg0.remainTxt = arg0:findTF("remain_time_bar/txt", arg0.content)
	arg0.roundTxt = arg0:findTF("round_time_bar/txt", arg0.keyUI)
	arg0.firePos = arg0:findTF("content/pos/fire_pos").anchoredPosition
	arg0.hitPos = arg0:findTF("content/pos/hit_pos").anchoredPosition
	arg0.aPos = arg0:findTF("content/pos/a_pos").anchoredPosition
	arg0.bPos = arg0:findTF("content/pos/b_pos").anchoredPosition
	arg0.cPos = arg0:findTF("content/pos/c_pos").anchoredPosition
	arg0.missPos = arg0:findTF("content/pos/miss_pos").anchoredPosition
	arg0.backBtn = arg0:findTF("back_btn", arg0.content)
	arg0.autoLoader = AutoLoader.New()

	arg0.autoLoader:LoadSprite("ui/minigameui/qtegameuiasync_atlas", "background", arg0.gameBg, false)
end

function var0.didEnter(arg0)
	arg0:initGame()
	onButton(arg0, arg0.backBtn, function()
		arg0:SendSuccess(arg0.score)
		arg0:setGameState(arg0.STATE_BEGIN)
	end, SFX_PANEL)
	onButton(arg0, arg0.qBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end

	onButton(arg0, arg0.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
	onButton(arg0, arg0.startBtn, function()
		setButtonEnabled(arg0.startBtn, false)
		parallelAsync({
			function(arg0)
				arg0:loadXGM(arg0)
			end,
			function(arg0)
				arg0:loadGuinu(arg0)
			end
		}, function()
			arg0:setGameState(arg0.STATE_COUNT)
		end)
	end, SFX_PANEL)

	if QTEGAME_DEBUG then
		onButton(arg0, arg0.xgm, function()
			arg0:setGameState(arg0.STATE_SHOW)
		end)
	end

	onButton(arg0, arg0.endExitBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	arg0.endUIEvent:SetEndEvent(function()
		arg0:SendSuccess(arg0.score)
		setActive(arg0.endExitBtn, true)
	end)

	local function var0(arg0)
		if arg0.gameState == arg0.STATE_CLICK and arg0.curShowBlock then
			arg0.curShowBlock:select(arg0)

			arg0.curShowBlock = arg0.curShowBlock.nextBlock

			if arg0.curShowBlock == nil then
				arg0:managedTween(LeanTween.delayedCall, function()
					arg0:setGameState(arg0.STATE_SHOW)
				end, 0.2, nil)
			end
		end
	end

	onButton(arg0, arg0.aBtn, function()
		var0(arg0.TYPE_A)
	end, SFX_PANEL)
	onButton(arg0, arg0.bBtn, function()
		var0(arg0.TYPE_B)
	end, SFX_PANEL)
	onButton(arg0, arg0.cBtn, function()
		var0(arg0.TYPE_C)
	end, SFX_PANEL)
	arg0:setGameState(arg0.STATE_BEGIN)
	arg0:checkHelp()
end

function var0.initGame(arg0)
	arg0.curShowBlock = nil
	arg0.randomBlockList = nil
	arg0.scorePerHit = arg0:GetMGData():GetSimpleValue("scorePerHit")
	arg0.comboRange = arg0:GetMGData():GetSimpleValue("comboRange")
	arg0.comboAddScore = arg0:GetMGData():GetSimpleValue("comboAddScore")
	arg0.targetCombo = arg0:GetMGData():GetSimpleValue("targetCombo")
	arg0.targetComboScore = arg0:GetMGData():GetSimpleValue("targetComboScore")
	arg0.usingBlockList = {}
	arg0.blockUniId = 0

	arg0:resetGame()
	arg0.bucketASpine:SetActionCallBack(function(arg0)
		if arg0 == "FINISH" then
			arg0:setBucketAAction("idle")
		end
	end)
	arg0.bucketBSpine:SetActionCallBack(function(arg0)
		if arg0 == "FINISH" then
			arg0:setBucketBAction("idle")
		end
	end)
end

function var0.resetGame(arg0)
	arg0:setXgmAction("idle")
	arg0:setGuinuAction("normal")
	arg0:setBucketAAction("idle")
	arg0:setBucketBAction("idle")
	setActive(arg0.msHand, false)

	arg0.score = 0
	arg0.bestComboNum = 0
	arg0.comboNum = 0
	arg0.missNum = 0
	arg0.hitNum = 0
	arg0.remainTime = arg0:GetMGData():GetSimpleValue("gameTime")
	arg0.roundTime = arg0:GetMGData():GetSimpleValue("roundTime")

	setText(arg0.comboTxt, 0)
	setText(arg0.scoreTxt, 0)
	setText(arg0.remainTxt, arg0.remainTime .. "S")
	setText(arg0.roundTxt, arg0.roundTime)
	arg0:clearTimer()
	arg0:hideRandomList()
	arg0:clearUsingBlock()
	arg0:cleanManagedTween()
end

function var0.setGameState(arg0, arg1)
	if arg1 == arg0.gameState then
		return
	end

	arg0.gameState = arg1

	local function var0(arg0)
		local var0 = {
			arg0.startUI,
			arg0.content,
			arg0.endUI,
			arg0.countUI,
			arg0.keyUI,
			arg0.keyBar
		}

		for iter0, iter1 in pairs(var0) do
			local var1 = table.indexof(arg0, iter1) and true

			setActive(iter1, var1)
		end

		if isActive(arg0.endUI) then
			pg.UIMgr.GetInstance():BlurPanel(arg0.endUI)
		else
			pg.UIMgr.GetInstance():UnblurPanel(arg0.endUI, arg0._tf)
		end
	end

	if arg0.gameState == arg0.STATE_BEGIN then
		arg0:openCoinLayer(true)
		setButtonEnabled(arg0.startBtn, true)
		var0({
			arg0.startUI
		})
		arg0:resetGame()
	elseif arg0.gameState == arg0.STATE_COUNT then
		arg0:openCoinLayer(false)
		var0({
			arg0.countUI,
			arg0.content
		})

		local var1 = Time.realtimeSinceStartup

		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:startGameTimer()
			arg0:setGameState(arg0.STATE_CLICK)
		end, 3, nil):setOnUpdate(System.Action_float(function(arg0)
			setText(arg0.countNumTxt, math.ceil(3 - (Time.realtimeSinceStartup - var1)))
		end))
	elseif arg0.gameState == arg0.STATE_CLICK then
		var0({
			arg0.content,
			arg0.keyUI,
			arg0.keyBar
		})

		arg0.randomBlockList, arg0.curShowBlock, arg0.firstShowBlock = arg0:getRandomList()

		arg0:startRoundTimer()
	elseif arg0.gameState == arg0.STATE_SHOW then
		var0({
			arg0.content
		})
		arg0:hideRandomList()
		arg0:playArchiveAnim(arg0.randomBlockList, arg0:getUserResult())
	elseif arg0.gameState == arg0.STATE_END then
		var0({
			arg0.content,
			arg0.endUI
		})
		setActive(arg0.endExitBtn, false)

		local var2 = 0
		local var3 = arg0:GetMGData():GetRuntimeData("elements")

		if var3 and #var3 > 0 then
			var2 = var3[1]
		end

		if var2 < arg0.score then
			var2 = arg0.score

			arg0:StoreDataToServer({
				var2
			})
		end

		setText(arg0.endBestTxt, var2)
		setText(arg0.endScoreTxt, arg0.score)
		setText(arg0.endComboTxt, arg0.bestComboNum)
		setText(arg0.endMissTxt, arg0.missNum)
		setText(arg0.endHitTxt, arg0.hitNum)
		arg0:clearTimer()
	end
end

function var0.fireBlocks(arg0)
	local var0 = arg0.opIndex
	local var1 = arg0.arBlockList[var0].type
	local var2 = arg0.arBlockList[var0].id
	local var3 = arg0.opList[var0]
	local var4 = arg0:getBlock(var1, var2)
	local var5 = var4.tf

	arg0:addUsingBlock(var4)

	local var6

	if var3 then
		if var1 == arg0.TYPE_A then
			var6 = arg0.aPos
		elseif var1 == arg0.TYPE_B then
			var6 = arg0.bPos
		elseif var1 == arg0.TYPE_C then
			var6 = arg0.cPos
		end
	else
		var6 = arg0.missPos
	end

	var5.anchoredPosition = arg0.firePos

	arg0:hitFly(var5, 0.5, arg0.hitPos, function()
		var5.anchoredPosition = arg0.hitPos

		if var3 then
			local var0 = 0.4
			local var1 = arg0.parabolaMove

			if var1 == arg0.TYPE_A then
				var0 = 0.3
				var1 = arg0.parabolaMove_center

				arg0:setBucketAAction("attack")
			elseif var1 == arg0.TYPE_B then
				arg0:managedTween(LeanTween.delayedCall, function()
					arg0:setBucketBAction("attack")
				end, 0.2, nil)
			elseif var1 == arg0.TYPE_C then
				var0 = 0.3
				var1 = arg0.parabolaMove_center

				setActive(arg0.msHand, true)
				arg0.msHandAnimator:Play("mingshi_hand", -1, 0)
			end

			var1(arg0, var5, var0, var6, function()
				if var1 == arg0.TYPE_A then
					arg0:removeUsingBlock(var4)
					arg0:showBucketAEffect()
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_hitcake")
				elseif var1 == arg0.TYPE_B then
					setActive(arg0["cut" .. var2], true)
					arg0["cut" .. var2 .. "Animator"]:Play("cut_fruit", -1, 0)
					arg0:removeUsingBlock(var4)
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_sword")
				elseif var1 == arg0.TYPE_C then
					arg0:msClearHold()
					arg0:msHoldBlock(var4)
				end

				arg0:checkEnd(var0)
			end)
		else
			arg0:hitFly(var5, 0.6, var6, function()
				arg0:removeUsingBlock(var4)
				arg0:checkEnd(var0)
			end)
		end

		pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_hitwood")
		arg0:countScore(var3)
	end)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:setGuinuAction("attack")
	end, 0.2, nil)
end

function var0.getRandomList(arg0)
	if not arg0.allList then
		arg0.allList = {}

		for iter0 = 1, arg0.typeNum do
			for iter1 = 1, arg0.idNum do
				arg0.allList[#arg0.allList + 1] = {
					type = iter0,
					id = iter1
				}
			end
		end
	end

	local var0 = Clone(arg0.allList)
	local var1 = {}

	for iter2 = 1, arg0.limitNum do
		var1[#var1 + 1] = table.remove(var0, math.random(1, #var0))
	end

	local var2
	local var3
	local var4

	for iter3, iter4 in ipairs(var1) do
		local var5 = arg0:getShowBlock(iter4.type, iter4.id)

		if var2 then
			var2.nextBlock = var5
		end

		if iter3 >= arg0.limitNum then
			var5.nextBlock = nil
		end

		if iter3 == 1 then
			var3 = var5
			var4 = var5
		end

		var5:showOrHide(true)

		var2 = var5
	end

	return var1, var3, var4
end

function var0.hideRandomList(arg0)
	local var0 = arg0.firstShowBlock

	while var0 do
		var0:showOrHide(false)

		var0 = var0.nextBlock
	end
end

function var0.countScore(arg0, arg1)
	if arg1 then
		local var0

		for iter0, iter1 in ipairs(arg0.comboRange) do
			if iter1 > arg0.comboNum then
				var0 = iter0 - 1

				break
			elseif iter0 == #arg0.comboRange then
				var0 = #arg0.comboRange
			end
		end

		local var1 = arg0.comboAddScore[var0] or 0

		arg0.comboNum = arg0.comboNum + 1

		local var2 = table.indexof(arg0.targetCombo, arg0.comboNum)
		local var3 = arg0.targetComboScore[var2] or 0

		arg0.score = arg0.score + arg0.scorePerHit + var1 + var3
		arg0.hitNum = arg0.hitNum + 1
		arg0.comboAni.enabled = true

		arg0.comboAni:Play("combo_shake", -1, 0)
	else
		arg0.comboNum = 0
		arg0.missNum = arg0.missNum + 1
	end

	if arg0.comboNum > arg0.bestComboNum then
		arg0.bestComboNum = arg0.comboNum
	end

	setText(arg0.comboTxt, arg0.comboNum < 0 and 0 or arg0.comboNum)
	setText(arg0.scoreTxt, arg0.score)
end

function var0.getUserResult(arg0)
	local var0 = {}
	local var1 = arg0.firstShowBlock

	while var1 do
		var0[#var0 + 1] = var1:isRight()
		var1 = var1.nextBlock
	end

	return var0
end

function var0.playArchiveAnim(arg0, arg1, arg2)
	arg0.arBlockList = arg1
	arg0.opList = arg2
	arg0.opIndex = 1

	arg0:setXgmAction("attack")
end

function var0.checkPlayFinished(arg0)
	if arg0.opIndex >= #arg0.opList and arg0.remainTime > 0 then
		arg0:setGameState(arg0.STATE_CLICK)
	end
end

function var0.checkEnd(arg0, arg1)
	if arg1 >= #arg0.opList and arg0.remainTime <= 0 then
		arg0:setGameState(arg0.STATE_END)
	end
end

function var0.parabolaMove(arg0, arg1, arg2, arg3, arg4)
	arg0:managedTween(LeanTween.rotate, nil, arg1, 135, arg2)
	arg0:managedTween(LeanTween.moveX, nil, arg1, arg3.x, arg2):setEase(LeanTweenType.linear)
	arg0:managedTween(LeanTween.moveY, function()
		if arg4 then
			arg4()
		end
	end, arg1, arg3.y, arg2):setEase(LeanTweenType.easeInQuad)
end

function var0.parabolaMove_center(arg0, arg1, arg2, arg3, arg4)
	arg0:managedTween(LeanTween.rotate, nil, arg1, 135, arg2)
	arg0:managedTween(LeanTween.moveX, nil, arg1, arg3.x, arg2):setEase(LeanTweenType.easeOutQuad)
	arg0:managedTween(LeanTween.moveY, function()
		if arg4 then
			arg4()
		end
	end, arg1, arg3.y, arg2):setEase(LeanTweenType.linear)
end

function var0.hitFly(arg0, arg1, arg2, arg3, arg4)
	arg0:managedTween(LeanTween.rotate, nil, arg1, 135, arg2)
	arg0:managedTween(LeanTween.moveX, nil, arg1, arg3.x, arg2):setEase(LeanTweenType.linear)
	arg0:managedTween(LeanTween.moveY, function()
		if arg4 then
			arg4()
		end
	end, arg1, arg3.y, arg2):setEase(LeanTweenType.easeOutQuad)
end

function var0.loadXGM(arg0, arg1)
	if arg0.xgm then
		arg1()
	else
		arg0.autoLoader:LoadPrefab("ui/minigameui/qtegameuiasync_atlas", "xiongguimao", function(arg0)
			arg0.xgm = tf(arg0)
			arg0.xgmSpine = arg0.xgm:GetComponent("SpineAnimUI")
			arg0.xgmSklGraphic = arg0.xgm:GetComponent("SkeletonGraphic")

			setParent(arg0.xgm, arg0.xgmPos, false)
			arg0:initXGM()
			arg1()
		end)
	end
end

function var0.initXGM(arg0)
	arg0.xgmSpine:SetActionCallBack(function(arg0)
		if arg0 == "FIRE" then
			arg0:fireBlocks()
		elseif arg0 == "FINISH" then
			if arg0.opIndex < #arg0.opList then
				arg0.opIndex = arg0.opIndex + 1

				arg0:setXgmAction("attack")
			else
				arg0:setXgmAction("idle")
				arg0:checkPlayFinished()
			end
		end
	end)
end

function var0.loadGuinu(arg0, arg1)
	if arg0.guinu then
		arg1()
	else
		arg0.autoLoader:GetSpine("guinu_2", function(arg0)
			arg0.guinu = tf(arg0)
			arg0.guinuSpine = arg0.guinu:GetComponent("SpineAnimUI")
			arg0.guinuSklGraphic = arg0.guinu:GetComponent("SkeletonGraphic")

			setParent(arg0.guinu, arg0.guinuPos, false)
			arg0:initGuinu()
			arg1()
		end)
	end
end

function var0.initGuinu(arg0)
	arg0.guinu.localScale = Vector3.one

	arg0:setGuinuAction("normal")
	arg0.guinuSpine:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0:setGuinuAction("normal")
		end
	end)
end

function var0.setXgmAction(arg0, arg1)
	if not arg0.xgm then
		return
	end

	local var0 = arg0.xgmAnimLength[arg1] / arg0.xgmAnimTargetLength[arg1]

	arg0.xgmSklGraphic.timeScale = var0

	arg0.xgmSpine:SetAction(arg1, 0)
end

function var0.setGuinuAction(arg0, arg1)
	if not arg0.guinu then
		return
	end

	local var0 = arg0.guinuAnimLength[arg1] / arg0.guinuAnimTargetLength[arg1]

	arg0.guinuSklGraphic.timeScale = var0

	arg0.guinuSpine:SetAction(arg1, 0)
end

function var0.setBucketAAction(arg0, arg1)
	local var0 = arg0.bucketAAnimLength[arg1] / arg0.bucketAAnimTargetLength[arg1]

	arg0.bucketAGraphic.timeScale = var0

	arg0.bucketASpine:SetAction(arg1, 0)
end

function var0.setBucketBAction(arg0, arg1)
	local var0 = arg0.bucketBAnimLength[arg1] / arg0.bucketBAnimTargetLength[arg1]

	arg0.bucketBGraphic.timeScale = var0

	arg0.bucketBSpine:SetAction(arg1, 0)
end

function var0.showBucketAEffect(arg0)
	arg0.aEffectList = arg0.aEffectList or {}
	arg0.aEffectUsingList = arg0.aEffectUsingList or {}

	local function var0()
		local var0 = table.remove(arg0.aEffectList, #arg0.aEffectList)

		arg0.aEffectUsingList[#arg0.aEffectUsingList + 1] = var0

		setParent(var0, arg0.bucketA, false)

		var0.localScale = Vector3.one

		setActive(var0, true)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:recycleBucketAEffect(var0)
		end, 2, nil)
	end

	if #arg0.aEffectList == 0 then
		arg0.autoLoader:LoadPrefab("effect/xinnianyouxi_baozha", nil, function(arg0)
			arg0.aEffectList[#arg0.aEffectList + 1] = tf(arg0)

			var0()
		end)
	else
		var0()
	end
end

function var0.recycleBucketAEffect(arg0, arg1)
	for iter0 = #arg0.aEffectUsingList, 1, -1 do
		if arg0.aEffectUsingList[iter0] == arg1 then
			setActive(arg1, false)

			arg0.aEffectList[#arg0.aEffectList + 1] = table.remove(arg0.aEffectUsingList, iter0)
		end
	end
end

function var0.getBlock(arg0, arg1, arg2)
	local var0 = arg1 .. "-" .. arg2

	if not arg0.blockPool then
		arg0.blockPool = {}
		arg0.blockSource = {}

		for iter0 = 1, 3 do
			for iter1 = 1, 3 do
				local var1 = iter0 .. "-" .. iter1
				local var2 = arg0:findTF("res/item" .. var1)

				arg0.blockPool[var1] = {}
				arg0.blockPool[var1][#arg0.blockPool[var1] + 1] = var2
				arg0.blockSource[var1] = var2
			end
		end
	end

	local var3

	if #arg0.blockPool[var0] > 0 then
		var3 = table.remove(arg0.blockPool[var0], #arg0.blockPool[var0])

		var3:SetParent(arg0.content, false)
	else
		var3 = cloneTplTo(arg0.blockSource[var0], arg0.content)
	end

	setActive(var3, true)

	arg0.blockUniId = arg0.blockUniId + 1

	return {
		uid = arg0.blockUniId,
		key = var0,
		tf = var3
	}
end

function var0.recycleBlock(arg0, arg1)
	local var0 = arg1.tf
	local var1 = arg0.blockPool[arg1.key]

	var1[#var1 + 1] = var0

	var0:SetParent(arg0.res, false)
	setActive(var0, false)
end

function var0.msHoldBlock(arg0, arg1)
	setParent(arg1.tf, arg0.msHandSlot, false)

	arg1.tf.localPosition = Vector2.zero
	arg0.msBlockList[#arg0.msBlockList + 1] = arg1
end

function var0.msClearHold(arg0)
	for iter0 = #arg0.msBlockList, 1, -1 do
		arg0:removeUsingBlock(table.remove(arg0.msBlockList, iter0))
	end
end

function var0.addUsingBlock(arg0, arg1)
	arg0.usingBlockList[#arg0.usingBlockList + 1] = arg1
end

function var0.removeUsingBlock(arg0, arg1)
	for iter0 = #arg0.usingBlockList, 1, -1 do
		if arg0.usingBlockList[iter0].uid == arg1.uid then
			arg0:recycleBlock(arg0.usingBlockList[iter0])
			table.remove(arg0.usingBlockList, iter0)
		end
	end
end

function var0.clearUsingBlock(arg0)
	for iter0 = #arg0.usingBlockList, 1, -1 do
		arg0:recycleBlock(arg0.usingBlockList[iter0])
		table.remove(arg0.usingBlockList, iter0)
	end
end

function var0.getShowBlock(arg0, arg1, arg2)
	local var0 = arg1 .. "-" .. arg2
	local var1 = "item" .. var0

	arg0.showBlockDic = arg0.showBlockDic or {}

	local var2

	if arg0.showBlockDic[var0] then
		var2 = arg0.showBlockDic[var0]
	else
		var2 = {
			type = arg1,
			id = arg2,
			goName = var1,
			tf = arg0:findTF(var1, arg0.keyBar)
		}
		var2.wrongTag = arg0:findTF("wrong", var2.tf)
		var2.rightTag = arg0:findTF("right", var2.tf)
		var2.nextBlock = nil
		var2.userChoose = nil

		function var2.init(arg0)
			setActive(arg0.wrongTag, false)
			setActive(arg0.rightTag, false)

			arg0.userChoose = nil

			arg0.tf:SetAsLastSibling()
		end

		function var2.select(arg0, arg1)
			arg0.userChoose = arg1

			setActive(arg0.wrongTag, not arg0:isRight())
			setActive(arg0.rightTag, arg0:isRight())
		end

		function var2.showOrHide(arg0, arg1)
			setActive(arg0.tf, arg1)
		end

		function var2.isRight(arg0)
			return arg0.userChoose == arg0.type
		end
	end

	var2:init()

	return var2
end

function var0.startGameTimer(arg0)
	arg0.remainTime = arg0:GetMGData():GetSimpleValue("gameTime")

	setText(arg0.remainTxt, arg0.remainTime .. "S")

	local function var0()
		arg0.remainTime = arg0.remainTime - 1

		setText(arg0.remainTxt, arg0.remainTime .. "S")

		if arg0.remainTime <= 0 then
			arg0.remainTime = 0

			arg0.remainTimer:Stop()
		end
	end

	if arg0.remainTimer then
		arg0.remainTimer:Reset(var0, 1, -1)
	else
		arg0.remainTimer = Timer.New(var0, 1, -1)
	end

	arg0.remainTimer:Start()
end

function var0.startRoundTimer(arg0)
	arg0.roundTime = arg0:GetMGData():GetSimpleValue("roundTime")

	setText(arg0.roundTxt, arg0.roundTime)

	local function var0()
		arg0.roundTime = arg0.roundTime - 1

		setText(arg0.roundTxt, arg0.roundTime)

		if arg0.roundTime <= 0 then
			arg0.roundTimer:Stop()

			if not QTEGAME_DEBUG then
				arg0:setGameState(arg0.STATE_SHOW)
			end
		end
	end

	if arg0.roundTimer then
		arg0.roundTimer:Reset(var0, 1, -1)
	else
		arg0.roundTimer = Timer.New(var0, 1, -1)
	end

	arg0.roundTimer:Start()
end

function var0.clearTimer(arg0)
	if arg0.remainTimer then
		arg0.remainTimer:Stop()

		arg0.remainTimer = nil
	end

	if arg0.roundTimer then
		arg0.roundTimer:Stop()

		arg0.roundTimer = nil
	end
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	local var0 = arg1.argList

	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE and var0[1] == 0 then
		arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0:GetMGData():GetSimpleValue("shrineGameId"),
			1
		})
	end
end

function var0.checkHelp(arg0)
	if PlayerPrefs.GetInt("QTEGameGuide", 0) == 0 then
		triggerButton(arg0.ruleBtn)
		PlayerPrefs.SetInt("QTEGameGuide", 1)
		PlayerPrefs.Save()
	end
end

function var0.willExit(arg0)
	arg0:clearTimer()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.endUI, arg0._tf)

	arg0.xgm = nil
	arg0.xgmSpine = nil
	arg0.xgmSklGraphic = nil
	arg0.guinu = nil
	arg0.guinuSpine = nil
	arg0.guinuSklGraphic = nil

	arg0.autoLoader:Clear()
end

return var0
