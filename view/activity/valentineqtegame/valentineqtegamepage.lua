local var0 = class("ValentineQteGamePage")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1

	arg0:Init()
end

function var0.Init(arg0)
	arg0.root = findTF(arg0._tf, "root")
	arg0.slideWay = findTF(arg0._tf, "slideway")
	arg0.slider = findTF(arg0._tf, "slider")
	arg0.goodArea = findTF(arg0._tf, "good")
	arg0.greatArea = findTF(arg0._tf, "great")
	arg0.perfectArea = findTF(arg0._tf, "perfect")
	arg0.scoreTxt = findTF(arg0._tf, "score/Text"):GetComponent(typeof(Text))
	arg0.comboTxt = findTF(arg0._tf, "score/combo"):GetComponent(typeof(Text))
	arg0.refrigerator = findTF(arg0._tf, "bg/refrigerator"):GetComponent(typeof(SpineAnimUI))
	arg0.char = findTF(arg0._tf, "bg/char"):GetComponent(typeof(SpineAnimUI))
	arg0.backBtn = findTF(arg0._tf, "back")
	arg0.puaseBtn = findTF(arg0._tf, "pause")
	arg0.timeTxt = findTF(arg0._tf, "time/Text"):GetComponent(typeof(Text))
	arg0.lineTr = findTF(arg0._tf, "slideway/line")

	setActive(arg0.lineTr, false)

	arg0.itemContainer = findTF(arg0._tf, "items")
	arg0.effectContainer = findTF(arg0._tf, "effects")
	arg0.finger = findTF(arg0._tf, "finger")
	arg0.gearTr = findTF(arg0._tf, "gear"):GetComponent(typeof(Image))
	arg0.gearTrPos = arg0.gearTr.transform.localPosition.y
	arg0.gearSps = {
		[ValentineQteGameConst.OP_SCORE_GEAR_PERFECT] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Perfect"),
		[ValentineQteGameConst.OP_SCORE_GEAR_GREAT] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Great"),
		[ValentineQteGameConst.OP_SCORE_GEAR_GOOD] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Good"),
		[ValentineQteGameConst.OP_SCORE_GEAR_MISS] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Miss")
	}
	arg0.msgBox = ValentineQteGameMsgBox.New(arg0._tf:Find("msgbox"))
	arg0.itemPoolMgr = ValentineQteGamePoolMgr.New(arg0._tf:Find("root/item"), 2, 4)
	arg0.resultWindow = ValentineQteGameResultWindow.New(arg0._tf:Find("result_panel"))
	arg0.countDownWindow = findTF(arg0._tf, "countdown")
	arg0.countDown1 = findTF(arg0._tf, "countdown/1")
	arg0.countDown2 = findTF(arg0._tf, "countdown/2")
	arg0.countDown3 = findTF(arg0._tf, "countdown/3")
	arg0.effectPools = {}
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0.onComplete = arg1
	arg0.onExist = arg2
	arg0.isClick = not arg3

	arg0:Show()
end

function var0.Show(arg0)
	arg0:UpdateFinger()
	parallelAsync({
		function(arg0)
			arg0:CountDown(arg0)
		end,
		function(arg0)
			seriesAsync({
				function(arg0)
					arg0:LoadEffects(arg0)
				end,
				function(arg0)
					arg0:InitGame(arg0)
				end,
				function(arg0)
					arg0:Reset(arg0)
				end
			}, arg0)
		end
	}, function()
		arg0:StartGame()
	end)
end

function var0.CountDown(arg0, arg1)
	local function var0(arg0)
		setActive(arg0.countDown1, arg0 == 3)
		setActive(arg0.countDown2, arg0 == 2)
		setActive(arg0.countDown3, arg0 == 1)
	end

	setActive(arg0.countDownWindow, true)

	local var1 = 1

	arg0.countDownTimer = Timer.New(function()
		var1 = var1 + 1

		var0(var1)

		if var1 == 4 then
			setActive(arg0.countDownWindow, false)
			arg1()
		end
	end, 1, 3)

	arg0.countDownTimer:Start()
	var0(var1)
end

function var0.LoadEffects(arg0, arg1)
	parallelAsync({
		function(arg0)
			LoadAndInstantiateAsync("ui", "chufang_Prefect", function(arg0)
				SetParent(arg0, arg0.root)

				local var0 = ValentineQteGamePoolMgr.New(arg0, 1, 2)

				arg0.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_PERFECT] = var0

				arg0()
			end)
		end,
		function(arg0)
			LoadAndInstantiateAsync("ui", "chufang_Great", function(arg0)
				SetParent(arg0, arg0.root)

				local var0 = ValentineQteGamePoolMgr.New(arg0, 1, 2)

				arg0.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_GREAT] = var0

				arg0()
			end)
		end,
		function(arg0)
			LoadAndInstantiateAsync("ui", "chufang_Good", function(arg0)
				SetParent(arg0, arg0.root)

				local var0 = ValentineQteGamePoolMgr.New(arg0, 1, 2)

				arg0.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_GOOD] = var0

				arg0()
			end)
		end,
		function(arg0)
			LoadAndInstantiateAsync("ui", "chufang_Miss", function(arg0)
				SetParent(arg0, arg0.root)

				local var0 = ValentineQteGamePoolMgr.New(arg0, 1, 2)

				arg0.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_MISS] = var0

				arg0()
			end)
		end,
		function(arg0)
			LoadAndInstantiateAsync("ui", "chufang_shiqu", function(arg0)
				SetParent(arg0, arg0.root)

				local var0 = ValentineQteGamePoolMgr.New(arg0, 1, 2)

				arg0.pickPool = var0

				arg0()
			end)
		end
	}, arg1)
end

function var0.InitGame(arg0, arg1)
	arg0.slideWay.sizeDelta = Vector2(ValentineQteGameConst.SLIDEWAY_WIDTH, arg0.slideWay.sizeDelta.y)
	arg0.slider.sizeDelta = Vector2(ValentineQteGameConst.SLIDER_WIDTH, arg0.slider.sizeDelta.y)
	arg0.goodArea.sizeDelta = Vector2(ValentineQteGameConst.GOOD_WIDTH, arg0.goodArea.sizeDelta.y)
	arg0.greatArea.sizeDelta = Vector2(ValentineQteGameConst.GREAT_WIDTH, arg0.greatArea.sizeDelta.y)
	arg0.perfectArea.sizeDelta = Vector2(ValentineQteGameConst.PERFECT_WIDTH, arg0.perfectArea.sizeDelta.y)
	arg0.scoreTxt.text = 0
	arg0.comboTxt.text = 0
	arg0.slideWay.localPosition = Vector3(0, arg0.slideWay.localPosition.y, 0)
	arg0.goodArea.localPosition = Vector3(0, arg0.goodArea.localPosition.y, 0)
	arg0.greatArea.localPosition = Vector3(0, arg0.greatArea.localPosition.y, 0)
	arg0.perfectArea.localPosition = Vector3(0, arg0.perfectArea.localPosition.y, 0)

	local var0 = arg0.slider.sizeDelta.x * 0.5

	arg0.missMinPosX, arg0.missMaxPosX = arg0:CalcGearArea(arg0.slideWay, var0)
	arg0.goodMinPosX, arg0.goodMaxPosX = arg0:CalcGearArea(arg0.goodArea, var0)
	arg0.greatMinPosX, arg0.greatMaxPosX = arg0:CalcGearArea(arg0.greatArea, var0)
	arg0.prefectMinPosX, arg0.prefectMaxPosX = arg0:CalcGearArea(arg0.perfectArea, var0)
	arg0.slider.localPosition = Vector3(arg0.missMinPosX, arg0.slideWay.localPosition.y, 0)
	arg0.itemGenMinArea = Vector2(arg0.missMinPosX - var0 + 40, arg0.goodMinPosX - var0 - 40)
	arg0.itemGenMaxArea = Vector2(arg0.goodMaxPosX + var0 + 40, arg0.missMaxPosX + var0 - 40)

	if ValentineQteGameConst.DEBUG then
		arg0:InitDebugView()
	end

	arg1()
end

function var0.Reset(arg0, arg1)
	arg0.speedX = ValentineQteGameConst.INIT_SPEED
	arg0.time = ValentineQteGameConst.GMAE_TIME
	arg0.comboCnt = 0
	arg0.score = 0
	arg0.opCdTime = 0
	arg0.elapseTimes = {}
	arg0.accelerated = 0
	arg0.items = {}
	arg0.genItemTime = 0
	arg0.gearShowTime = 0
	arg0.timers = {}
	arg0.startFlag = false
	arg0.statistics = {
		Score = 0,
		Combo = 0,
		Great = 0,
		Perfect = 0,
		Good = 0,
		Miss = 0
	}

	arg1()
end

function var0.InitDebugView(arg0)
	arg0:CreateDebugLinePos("missMinPosX")
	arg0:CreateDebugLinePos("missMaxPosX")
	arg0:CreateDebugLinePos("goodMinPosX")
	arg0:CreateDebugLinePos("goodMaxPosX")
	arg0:CreateDebugLinePos("greatMinPosX")
	arg0:CreateDebugLinePos("greatMaxPosX")
	arg0:CreateDebugLinePos("prefectMinPosX")
	arg0:CreateDebugLinePos("prefectMaxPosX")
	arg0:CreateDebugArea("itemGenMinArea")
	arg0:CreateDebugArea("itemGenMaxArea")
end

function var0.CreateDebugArea(arg0, arg1)
	local var0 = cloneTplTo(arg0.lineTr, arg0.lineTr.parent, arg1 .. "01")

	var0.localPosition = Vector3(arg0[arg1].x, var0.localPosition.y, 0)

	setActive(var0, true)

	local var1 = cloneTplTo(arg0.lineTr, arg0.lineTr.parent, arg1 .. "02")

	var1.localPosition = Vector3(arg0[arg1].y, var1.localPosition.y, 0)

	setActive(var1, true)
end

function var0.CreateDebugLinePos(arg0, arg1)
	local var0 = cloneTplTo(arg0.lineTr, arg0.lineTr.parent, arg1)

	var0.localPosition = Vector3(arg0[arg1], var0.localPosition.y, 0)

	setActive(var0, true)
end

function var0.CalcGearArea(arg0, arg1, arg2)
	local var0 = -arg1.sizeDelta.x * 0.5 + arg2
	local var1 = arg1.sizeDelta.x * 0.5 - arg2

	return var0, var1
end

function var0.StartGame(arg0)
	arg0.startFlag = true

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.UpdateGame, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
	arg0.char:SetAction("1", 0)
	onButton(arg0, arg0.puaseBtn, function()
		if not arg0.puaseGameFlag then
			arg0:PuaseGame()
			arg0.msgBox:Show({
				noNo = true,
				content = ValentineQteGameMsgBox.PAUSE_TXT,
				onYes = function()
					arg0:ResumeGame()
				end,
				onNo = function()
					arg0:ResumeGame()
				end
			})
		else
			arg0:ResumeGame()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:PuaseGame()
		arg0.msgBox:Show({
			content = ValentineQteGameMsgBox.EXIT_TXT,
			onYes = function()
				arg0:EndGame(true)
			end,
			onNo = function()
				arg0:ResumeGame()
			end
		})
	end, SFX_PANEL)

	arg0.dragDelegate = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragDelegate:AddPointDownFunc(function()
		arg0.isClick = true

		if arg0.opCdTime <= 0 and not arg0.puaseGameFlag then
			arg0:Snap()

			arg0.opCdTime = ValentineQteGameConst.OP_INTERVAL
		end

		arg0:UpdateFinger()
	end)
end

function var0.UpdateFinger(arg0)
	setActive(arg0.finger, not arg0.isClick)
end

function var0.UpdateGame(arg0)
	if arg0.puaseGameFlag then
		return
	end

	arg0:HideGear()
	arg0:CheckDisapperItems()
	arg0:UpdateSlider()
	arg0:UpdateSpeed()
	arg0:UpdateTime()
	arg0:UpdateOpCdTime()
	arg0:CheckAndGenItem()
	arg0:CheckInteraction()
end

function var0.CheckInteraction(arg0)
	local function var0()
		return arg0.time <= ValentineQteGameConst.OPEN_DOOR_TIME
	end

	if not arg0.isInteraction and var0() then
		arg0.isInteraction = true

		arg0.refrigerator:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.refrigerator:SetActionCallBack(nil)
				arg0.refrigerator:SetAction("3", 0)
			end
		end)
		arg0.refrigerator:SetAction("2", 0)
	end
end

function var0.HideGear(arg0)
	if arg0.gearShowTime <= 0 then
		return
	end

	if arg0.gearShowTime - arg0.time >= ValentineQteGameConst.GEAR_SHOW_TIME then
		arg0.gearShowTime = 0

		setActive(arg0.gearTr.gameObject, false)
	end
end

function var0.CheckDisapperItems(arg0)
	for iter0 = #arg0.items, 1, -1 do
		local var0 = arg0.items[iter0]

		if var0:ShouldDisapper(arg0.time) then
			var0:Destroy()
			arg0.itemPoolMgr:Enqueue(var0._go)
			table.remove(arg0.items, iter0)
		end
	end
end

function var0.CheckAndGenItem(arg0)
	if #arg0.items >= ValentineQteGameConst.MAX_ITEM_COUNT then
		return
	end

	local var0 = false

	if arg0.genItemTime == 0 and arg0.time <= ValentineQteGameConst.GMAE_TIME - ValentineQteGameConst.GEN_ITEM_FIRST_TIME or arg0.genItemTime > 0 and arg0.genItemTime - arg0.time > ValentineQteGameConst.GEN_ITEM_INTERVAL then
		var0 = true
	end

	if var0 then
		arg0:RandomItemPosition(0)
	end
end

function var0.IsVaildItemPos(arg0, arg1)
	local var0 = arg0.slider.sizeDelta.x + 80

	for iter0, iter1 in ipairs(arg0.items) do
		if not iter1:IsSufficientLength(arg1, var0) then
			return false
		end
	end

	return true
end

function var0.RandomItemPosition(arg0, arg1)
	if arg1 > 10 then
		return
	end

	local var0 = math.random(1, 2) % 2 == 0 and arg0.itemGenMinArea or arg0.itemGenMaxArea
	local var1 = math.random(var0.x, var0.y)

	if arg0:IsVaildItemPos(var1) then
		arg0.genItemTime = arg0.time

		local var2 = arg0.itemPoolMgr:Dequeue()

		SetParent(var2, arg0.itemContainer)

		local var3 = ValentineQteGameItem.New(var2, Vector2(var1, arg0.slider.localPosition.y), arg0.time)

		table.insert(arg0.items, var3)
	else
		arg0:RandomItemPosition(arg1 + 1)
	end
end

function var0.UpdateSlider(arg0)
	local var0 = arg0.slider.localPosition

	if var0.x == arg0.missMinPosX or var0.x == arg0.missMaxPosX then
		arg0.speedX = -arg0.speedX
	end

	local var1 = math.clamp(var0.x + arg0.speedX * Time.deltaTime, arg0.missMinPosX, arg0.missMaxPosX)

	arg0.slider.localPosition = Vector3(var1, var0.y, 0)
end

function var0.UpdateTime(arg0)
	arg0.time = arg0.time - Time.deltaTime

	if arg0.time <= 0 then
		arg0:EndGame(true)
	end

	arg0:UpdateTimeText(arg0.time)
end

function var0.UpdateSpeed(arg0)
	local var0 = math.floor(math.ceil(ValentineQteGameConst.GMAE_TIME - arg0.time) / 5)

	if var0 > 0 and not arg0.elapseTimes[var0] and arg0.accelerated + ValentineQteGameConst.INIT_SPEED < ValentineQteGameConst.MAX_SPEED then
		arg0.elapseTimes[var0] = true
		arg0.accelerated = arg0.accelerated + ValentineQteGameConst.SPEED_UP

		if arg0.speedX < 0 then
			arg0.speedX = arg0.speedX - arg0.accelerated
		else
			arg0.speedX = arg0.speedX + arg0.accelerated
		end
	end
end

function var0.UpdateOpCdTime(arg0)
	if arg0.opCdTime > 0 then
		arg0.opCdTime = math.max(0, arg0.opCdTime - Time.deltaTime)
	end
end

function var0.Snap(arg0)
	local var0 = arg0.slider.localPosition.x
	local var1 = arg0:GetScoreGear(var0)
	local var2 = {}
	local var3 = false

	if var1 == ValentineQteGameConst.OP_SCORE_GEAR_GREAT then
		arg0.comboCnt = arg0.comboCnt + 1
		arg0.statistics.Great = arg0.statistics.Great + 1
	elseif var1 == ValentineQteGameConst.OP_SCORE_GEAR_PERFECT then
		arg0.comboCnt = arg0.comboCnt + 1
		arg0.statistics.Perfect = arg0.statistics.Perfect + 1
	elseif arg0:CanPickItem(var0, var2) then
		arg0.comboCnt = arg0.comboCnt + 1
		var1 = ValentineQteGameConst.OP_SCORE_GEAR_PERFECT
		arg0.statistics.Perfect = arg0.statistics.Perfect + 1

		arg0:PickItems(var2)

		var3 = true
	elseif var1 == ValentineQteGameConst.OP_SCORE_GEAR_MISS then
		arg0.comboCnt = 0
		arg0.statistics.Miss = arg0.statistics.Miss + 1
	elseif var1 == ValentineQteGameConst.OP_SCORE_GEAR_GOOD then
		arg0.comboCnt = 0
		arg0.statistics.Good = arg0.statistics.Good + 1
	end

	local var4 = arg0:GetScore(var1, arg0.comboCnt)

	arg0.score = arg0.score + var4

	arg0:UpdateScoreText(arg0.score)
	arg0:UpdateComboText(arg0.comboCnt)

	if arg0.comboCnt > arg0.statistics.Combo then
		arg0.statistics.Combo = arg0.comboCnt
	end

	arg0:UpdateGear(var1, var3)
end

function var0.UpdateGear(arg0, arg1, arg2)
	if LeanTween.isTweening(arg0.gearTr.gameObject) then
		LeanTween.cancel(arg0.gearTr.gameObject)
	end

	arg0.gearTr.sprite = arg0.gearSps[arg1]

	arg0.gearTr:SetNativeSize()

	arg0.gearShowTime = arg0.time

	setActive(arg0.gearTr.gameObject, true)

	if arg2 then
		setActive(arg0.gearTr.gameObject, false)
		arg0:GenEffect(ValentineQteGameConst.OP_SCORE_GEAR_GREAT)
		arg0:PlaySound(ValentineQteGameConst.SOUND_PICK_ITEM)
	else
		arg0:GenEffect(arg1)
		arg0:GearAnim()
		arg0:PlaySound(ValentineQteGameConst.GEAR_SOUND[arg1])
	end
end

function var0.PlaySound(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)
end

function var0.GearAnim(arg0)
	arg0.gearTr.gameObject.transform.localPosition = Vector3(arg0.gearTr.gameObject.transform.localPosition.x, arg0.gearTrPos, 0)

	LeanTween.value(arg0.gearTr.gameObject, arg0.gearTrPos, arg0.gearTrPos + 50, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.gearTr.gameObject.transform.localPosition = Vector3(arg0.gearTr.gameObject.transform.localPosition.x, arg0, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0.gearTr.gameObject, false)
	end))
end

function var0.GenEffect(arg0, arg1)
	local var0 = arg0.effectPools[arg1]
	local var1 = var0:Dequeue()

	SetParent(var1, arg0.effectContainer)

	var1.transform.localPosition = Vector3(arg0.slider.localPosition.x, arg0.slider.localPosition.y, -100)

	local var2 = Timer.New(function()
		var0:Enqueue(var1)
	end, 2, 1)

	var2:Start()
	table.insert(arg0.timers, var2)
end

function var0.CanPickItem(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.items) do
		if iter1:IsOverlap(arg0.slider) then
			table.insert(arg2, iter1)
		end
	end

	return #arg2 > 0
end

function var0.PickItems(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:PlayPickAnim(iter1, function()
			iter1:Destroy()
			arg0.itemPoolMgr:Enqueue(iter1._tf)
		end)
		table.removebyvalue(arg0.items, iter1)
	end
end

function var0.PlayPickAnim(arg0, arg1, arg2)
	local var0 = arg1._tf.localPosition.y

	LeanTween.value(arg1._go, var0, var0 + 70, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg1._tf.localPosition = Vector3(arg1._tf.localPosition.x, arg0, 0)
	end)):setOnComplete(System.Action(function()
		local var0 = arg0.pickPool:Dequeue()

		SetParent(var0, arg0.effectContainer)

		var0.transform.localPosition = Vector3(arg1._tf.localPosition.x, arg1._tf.localPosition.y, -100)

		local var1 = Timer.New(function()
			arg0.pickPool:Enqueue(var0)
		end, 2, 1)

		var1:Start()
		table.insert(arg0.timers, var1)
		arg2()
	end))
end

function var0.UpdateTimeText(arg0, arg1)
	local var0 = math.ceil(arg1)

	if var0 <= 0 then
		arg0.timeTxt.text = "0"
	else
		arg0.timeTxt.text = math.max(0, var0)
	end
end

function var0.UpdateScoreText(arg0, arg1)
	arg0.scoreTxt.text = arg1
end

function var0.UpdateComboText(arg0, arg1)
	arg0.comboTxt.text = arg1
end

function var0.GetScoreGear(arg0, arg1)
	if arg1 >= arg0.prefectMinPosX and arg1 <= arg0.prefectMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_PERFECT
	end

	if arg1 >= arg0.greatMinPosX and arg1 <= arg0.greatMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_GREAT
	end

	if arg1 >= arg0.goodMinPosX and arg1 <= arg0.goodMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_GOOD
	end

	return ValentineQteGameConst.OP_SCORE_GEAR_MISS
end

function var0.GetScore(arg0, arg1, arg2)
	local var0 = ValentineQteGameConst.OP_SCORE[arg1]
	local var1 = ValentineQteGameConst.BASE_OP_SCORE * var0
	local var2 = 0

	for iter0, iter1 in ipairs(ValentineQteGameConst.COMBO_EXTRA_SCORE_RATIO) do
		local var3 = iter1[1]
		local var4 = iter1[2]
		local var5 = iter1[3]

		if var3 <= arg2 and arg2 <= var4 then
			var2 = var5

			break
		end
	end

	return var1 + ValentineQteGameConst.BASE_OP_SCORE * var2 * 0.01
end

function var0.PuaseGame(arg0)
	arg0.puaseGameFlag = true

	arg0.char:Pause()
end

function var0.ResumeGame(arg0)
	arg0.puaseGameFlag = false

	arg0.char:Resume()
end

function var0.EndGame(arg0, arg1)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	ClearEventTrigger(arg0.dragDelegate)
	removeOnButton(arg0.puaseBtn)

	if arg1 then
		arg0.statistics.Score = arg0.score

		arg0.resultWindow:Show(arg0.statistics, function()
			arg0:Destroy()
		end)
	end

	if arg0.onComplete and arg1 then
		arg0.onComplete()
	end

	arg0.onComplete = nil
end

function var0.ExitGame(arg0)
	arg0:EndGame(false)

	if arg0.onExist then
		arg0.onExist()

		arg0.onExist = nil
	end
end

function var0.onBackPressed(arg0)
	if arg0.startFlag and not arg0.puaseGameFlag then
		triggerButton(arg0.puaseBtn)

		return true
	end

	if isActive(arg0.msgBox._tf) then
		triggerButton(arg0.msgBox.cancelBtn)

		return true
	end

	return false
end

function var0.Destroy(arg0)
	if arg0.countDownTimer then
		arg0.countDownTimer:Stop()

		arg0.countDownTimer = nil
	end

	if LeanTween.isTweening(arg0.gearTr.gameObject) then
		LeanTween.cancel(arg0.gearTr.gameObject)
	end

	for iter0, iter1 in ipairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil

	for iter2, iter3 in pairs(arg0.effectPools) do
		iter3:Destroy()
	end

	arg0.effectPools = nil

	arg0.refrigerator:SetActionCallBack(nil)

	if arg0.msgBox then
		arg0.msgBox:Destroy()

		arg0.msgBox = nil
	end

	if arg0.resultWindow then
		arg0.resultWindow:Destroy()

		arg0.resultWindow = nil
	end

	arg0:ExitGame()
	pg.DelegateInfo.Dispose(arg0)

	if arg0.itemPoolMgr then
		arg0.itemPoolMgr:Destroy()

		arg0.itemPoolMgr = nil
	end

	arg0.gearSps = nil
end

return var0
