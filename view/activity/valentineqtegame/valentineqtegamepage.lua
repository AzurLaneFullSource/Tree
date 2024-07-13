local var0_0 = class("ValentineQteGamePage")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.root = findTF(arg0_2._tf, "root")
	arg0_2.slideWay = findTF(arg0_2._tf, "slideway")
	arg0_2.slider = findTF(arg0_2._tf, "slider")
	arg0_2.goodArea = findTF(arg0_2._tf, "good")
	arg0_2.greatArea = findTF(arg0_2._tf, "great")
	arg0_2.perfectArea = findTF(arg0_2._tf, "perfect")
	arg0_2.scoreTxt = findTF(arg0_2._tf, "score/Text"):GetComponent(typeof(Text))
	arg0_2.comboTxt = findTF(arg0_2._tf, "score/combo"):GetComponent(typeof(Text))
	arg0_2.refrigerator = findTF(arg0_2._tf, "bg/refrigerator"):GetComponent(typeof(SpineAnimUI))
	arg0_2.char = findTF(arg0_2._tf, "bg/char"):GetComponent(typeof(SpineAnimUI))
	arg0_2.backBtn = findTF(arg0_2._tf, "back")
	arg0_2.puaseBtn = findTF(arg0_2._tf, "pause")
	arg0_2.timeTxt = findTF(arg0_2._tf, "time/Text"):GetComponent(typeof(Text))
	arg0_2.lineTr = findTF(arg0_2._tf, "slideway/line")

	setActive(arg0_2.lineTr, false)

	arg0_2.itemContainer = findTF(arg0_2._tf, "items")
	arg0_2.effectContainer = findTF(arg0_2._tf, "effects")
	arg0_2.finger = findTF(arg0_2._tf, "finger")
	arg0_2.gearTr = findTF(arg0_2._tf, "gear"):GetComponent(typeof(Image))
	arg0_2.gearTrPos = arg0_2.gearTr.transform.localPosition.y
	arg0_2.gearSps = {
		[ValentineQteGameConst.OP_SCORE_GEAR_PERFECT] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Perfect"),
		[ValentineQteGameConst.OP_SCORE_GEAR_GREAT] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Great"),
		[ValentineQteGameConst.OP_SCORE_GEAR_GOOD] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Good"),
		[ValentineQteGameConst.OP_SCORE_GEAR_MISS] = GetSpriteFromAtlas("ui/valentineqtegame_atlas", "Miss")
	}
	arg0_2.msgBox = ValentineQteGameMsgBox.New(arg0_2._tf:Find("msgbox"))
	arg0_2.itemPoolMgr = ValentineQteGamePoolMgr.New(arg0_2._tf:Find("root/item"), 2, 4)
	arg0_2.resultWindow = ValentineQteGameResultWindow.New(arg0_2._tf:Find("result_panel"))
	arg0_2.countDownWindow = findTF(arg0_2._tf, "countdown")
	arg0_2.countDown1 = findTF(arg0_2._tf, "countdown/1")
	arg0_2.countDown2 = findTF(arg0_2._tf, "countdown/2")
	arg0_2.countDown3 = findTF(arg0_2._tf, "countdown/3")
	arg0_2.effectPools = {}
end

function var0_0.SetUp(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3.onComplete = arg1_3
	arg0_3.onExist = arg2_3
	arg0_3.isClick = not arg3_3

	arg0_3:Show()
end

function var0_0.Show(arg0_4)
	arg0_4:UpdateFinger()
	parallelAsync({
		function(arg0_5)
			arg0_4:CountDown(arg0_5)
		end,
		function(arg0_6)
			seriesAsync({
				function(arg0_7)
					arg0_4:LoadEffects(arg0_7)
				end,
				function(arg0_8)
					arg0_4:InitGame(arg0_8)
				end,
				function(arg0_9)
					arg0_4:Reset(arg0_9)
				end
			}, arg0_6)
		end
	}, function()
		arg0_4:StartGame()
	end)
end

function var0_0.CountDown(arg0_11, arg1_11)
	local function var0_11(arg0_12)
		setActive(arg0_11.countDown1, arg0_12 == 3)
		setActive(arg0_11.countDown2, arg0_12 == 2)
		setActive(arg0_11.countDown3, arg0_12 == 1)
	end

	setActive(arg0_11.countDownWindow, true)

	local var1_11 = 1

	arg0_11.countDownTimer = Timer.New(function()
		var1_11 = var1_11 + 1

		var0_11(var1_11)

		if var1_11 == 4 then
			setActive(arg0_11.countDownWindow, false)
			arg1_11()
		end
	end, 1, 3)

	arg0_11.countDownTimer:Start()
	var0_11(var1_11)
end

function var0_0.LoadEffects(arg0_14, arg1_14)
	parallelAsync({
		function(arg0_15)
			LoadAndInstantiateAsync("ui", "chufang_Prefect", function(arg0_16)
				SetParent(arg0_16, arg0_14.root)

				local var0_16 = ValentineQteGamePoolMgr.New(arg0_16, 1, 2)

				arg0_14.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_PERFECT] = var0_16

				arg0_15()
			end)
		end,
		function(arg0_17)
			LoadAndInstantiateAsync("ui", "chufang_Great", function(arg0_18)
				SetParent(arg0_18, arg0_14.root)

				local var0_18 = ValentineQteGamePoolMgr.New(arg0_18, 1, 2)

				arg0_14.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_GREAT] = var0_18

				arg0_17()
			end)
		end,
		function(arg0_19)
			LoadAndInstantiateAsync("ui", "chufang_Good", function(arg0_20)
				SetParent(arg0_20, arg0_14.root)

				local var0_20 = ValentineQteGamePoolMgr.New(arg0_20, 1, 2)

				arg0_14.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_GOOD] = var0_20

				arg0_19()
			end)
		end,
		function(arg0_21)
			LoadAndInstantiateAsync("ui", "chufang_Miss", function(arg0_22)
				SetParent(arg0_22, arg0_14.root)

				local var0_22 = ValentineQteGamePoolMgr.New(arg0_22, 1, 2)

				arg0_14.effectPools[ValentineQteGameConst.OP_SCORE_GEAR_MISS] = var0_22

				arg0_21()
			end)
		end,
		function(arg0_23)
			LoadAndInstantiateAsync("ui", "chufang_shiqu", function(arg0_24)
				SetParent(arg0_24, arg0_14.root)

				local var0_24 = ValentineQteGamePoolMgr.New(arg0_24, 1, 2)

				arg0_14.pickPool = var0_24

				arg0_23()
			end)
		end
	}, arg1_14)
end

function var0_0.InitGame(arg0_25, arg1_25)
	arg0_25.slideWay.sizeDelta = Vector2(ValentineQteGameConst.SLIDEWAY_WIDTH, arg0_25.slideWay.sizeDelta.y)
	arg0_25.slider.sizeDelta = Vector2(ValentineQteGameConst.SLIDER_WIDTH, arg0_25.slider.sizeDelta.y)
	arg0_25.goodArea.sizeDelta = Vector2(ValentineQteGameConst.GOOD_WIDTH, arg0_25.goodArea.sizeDelta.y)
	arg0_25.greatArea.sizeDelta = Vector2(ValentineQteGameConst.GREAT_WIDTH, arg0_25.greatArea.sizeDelta.y)
	arg0_25.perfectArea.sizeDelta = Vector2(ValentineQteGameConst.PERFECT_WIDTH, arg0_25.perfectArea.sizeDelta.y)
	arg0_25.scoreTxt.text = 0
	arg0_25.comboTxt.text = 0
	arg0_25.slideWay.localPosition = Vector3(0, arg0_25.slideWay.localPosition.y, 0)
	arg0_25.goodArea.localPosition = Vector3(0, arg0_25.goodArea.localPosition.y, 0)
	arg0_25.greatArea.localPosition = Vector3(0, arg0_25.greatArea.localPosition.y, 0)
	arg0_25.perfectArea.localPosition = Vector3(0, arg0_25.perfectArea.localPosition.y, 0)

	local var0_25 = arg0_25.slider.sizeDelta.x * 0.5

	arg0_25.missMinPosX, arg0_25.missMaxPosX = arg0_25:CalcGearArea(arg0_25.slideWay, var0_25)
	arg0_25.goodMinPosX, arg0_25.goodMaxPosX = arg0_25:CalcGearArea(arg0_25.goodArea, var0_25)
	arg0_25.greatMinPosX, arg0_25.greatMaxPosX = arg0_25:CalcGearArea(arg0_25.greatArea, var0_25)
	arg0_25.prefectMinPosX, arg0_25.prefectMaxPosX = arg0_25:CalcGearArea(arg0_25.perfectArea, var0_25)
	arg0_25.slider.localPosition = Vector3(arg0_25.missMinPosX, arg0_25.slideWay.localPosition.y, 0)
	arg0_25.itemGenMinArea = Vector2(arg0_25.missMinPosX - var0_25 + 40, arg0_25.goodMinPosX - var0_25 - 40)
	arg0_25.itemGenMaxArea = Vector2(arg0_25.goodMaxPosX + var0_25 + 40, arg0_25.missMaxPosX + var0_25 - 40)

	if ValentineQteGameConst.DEBUG then
		arg0_25:InitDebugView()
	end

	arg1_25()
end

function var0_0.Reset(arg0_26, arg1_26)
	arg0_26.speedX = ValentineQteGameConst.INIT_SPEED
	arg0_26.time = ValentineQteGameConst.GMAE_TIME
	arg0_26.comboCnt = 0
	arg0_26.score = 0
	arg0_26.opCdTime = 0
	arg0_26.elapseTimes = {}
	arg0_26.accelerated = 0
	arg0_26.items = {}
	arg0_26.genItemTime = 0
	arg0_26.gearShowTime = 0
	arg0_26.timers = {}
	arg0_26.startFlag = false
	arg0_26.statistics = {
		Score = 0,
		Combo = 0,
		Great = 0,
		Perfect = 0,
		Good = 0,
		Miss = 0
	}

	arg1_26()
end

function var0_0.InitDebugView(arg0_27)
	arg0_27:CreateDebugLinePos("missMinPosX")
	arg0_27:CreateDebugLinePos("missMaxPosX")
	arg0_27:CreateDebugLinePos("goodMinPosX")
	arg0_27:CreateDebugLinePos("goodMaxPosX")
	arg0_27:CreateDebugLinePos("greatMinPosX")
	arg0_27:CreateDebugLinePos("greatMaxPosX")
	arg0_27:CreateDebugLinePos("prefectMinPosX")
	arg0_27:CreateDebugLinePos("prefectMaxPosX")
	arg0_27:CreateDebugArea("itemGenMinArea")
	arg0_27:CreateDebugArea("itemGenMaxArea")
end

function var0_0.CreateDebugArea(arg0_28, arg1_28)
	local var0_28 = cloneTplTo(arg0_28.lineTr, arg0_28.lineTr.parent, arg1_28 .. "01")

	var0_28.localPosition = Vector3(arg0_28[arg1_28].x, var0_28.localPosition.y, 0)

	setActive(var0_28, true)

	local var1_28 = cloneTplTo(arg0_28.lineTr, arg0_28.lineTr.parent, arg1_28 .. "02")

	var1_28.localPosition = Vector3(arg0_28[arg1_28].y, var1_28.localPosition.y, 0)

	setActive(var1_28, true)
end

function var0_0.CreateDebugLinePos(arg0_29, arg1_29)
	local var0_29 = cloneTplTo(arg0_29.lineTr, arg0_29.lineTr.parent, arg1_29)

	var0_29.localPosition = Vector3(arg0_29[arg1_29], var0_29.localPosition.y, 0)

	setActive(var0_29, true)
end

function var0_0.CalcGearArea(arg0_30, arg1_30, arg2_30)
	local var0_30 = -arg1_30.sizeDelta.x * 0.5 + arg2_30
	local var1_30 = arg1_30.sizeDelta.x * 0.5 - arg2_30

	return var0_30, var1_30
end

function var0_0.StartGame(arg0_31)
	arg0_31.startFlag = true

	if not arg0_31.handle then
		arg0_31.handle = UpdateBeat:CreateListener(arg0_31.UpdateGame, arg0_31)
	end

	UpdateBeat:AddListener(arg0_31.handle)
	arg0_31.char:SetAction("1", 0)
	onButton(arg0_31, arg0_31.puaseBtn, function()
		if not arg0_31.puaseGameFlag then
			arg0_31:PuaseGame()
			arg0_31.msgBox:Show({
				noNo = true,
				content = ValentineQteGameMsgBox.PAUSE_TXT,
				onYes = function()
					arg0_31:ResumeGame()
				end,
				onNo = function()
					arg0_31:ResumeGame()
				end
			})
		else
			arg0_31:ResumeGame()
		end
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.backBtn, function()
		arg0_31:PuaseGame()
		arg0_31.msgBox:Show({
			content = ValentineQteGameMsgBox.EXIT_TXT,
			onYes = function()
				arg0_31:EndGame(true)
			end,
			onNo = function()
				arg0_31:ResumeGame()
			end
		})
	end, SFX_PANEL)

	arg0_31.dragDelegate = GetOrAddComponent(arg0_31._tf, "EventTriggerListener")

	arg0_31.dragDelegate:AddPointDownFunc(function()
		arg0_31.isClick = true

		if arg0_31.opCdTime <= 0 and not arg0_31.puaseGameFlag then
			arg0_31:Snap()

			arg0_31.opCdTime = ValentineQteGameConst.OP_INTERVAL
		end

		arg0_31:UpdateFinger()
	end)
end

function var0_0.UpdateFinger(arg0_39)
	setActive(arg0_39.finger, not arg0_39.isClick)
end

function var0_0.UpdateGame(arg0_40)
	if arg0_40.puaseGameFlag then
		return
	end

	arg0_40:HideGear()
	arg0_40:CheckDisapperItems()
	arg0_40:UpdateSlider()
	arg0_40:UpdateSpeed()
	arg0_40:UpdateTime()
	arg0_40:UpdateOpCdTime()
	arg0_40:CheckAndGenItem()
	arg0_40:CheckInteraction()
end

function var0_0.CheckInteraction(arg0_41)
	local function var0_41()
		return arg0_41.time <= ValentineQteGameConst.OPEN_DOOR_TIME
	end

	if not arg0_41.isInteraction and var0_41() then
		arg0_41.isInteraction = true

		arg0_41.refrigerator:SetActionCallBack(function(arg0_43)
			if arg0_43 == "finish" then
				arg0_41.refrigerator:SetActionCallBack(nil)
				arg0_41.refrigerator:SetAction("3", 0)
			end
		end)
		arg0_41.refrigerator:SetAction("2", 0)
	end
end

function var0_0.HideGear(arg0_44)
	if arg0_44.gearShowTime <= 0 then
		return
	end

	if arg0_44.gearShowTime - arg0_44.time >= ValentineQteGameConst.GEAR_SHOW_TIME then
		arg0_44.gearShowTime = 0

		setActive(arg0_44.gearTr.gameObject, false)
	end
end

function var0_0.CheckDisapperItems(arg0_45)
	for iter0_45 = #arg0_45.items, 1, -1 do
		local var0_45 = arg0_45.items[iter0_45]

		if var0_45:ShouldDisapper(arg0_45.time) then
			var0_45:Destroy()
			arg0_45.itemPoolMgr:Enqueue(var0_45._go)
			table.remove(arg0_45.items, iter0_45)
		end
	end
end

function var0_0.CheckAndGenItem(arg0_46)
	if #arg0_46.items >= ValentineQteGameConst.MAX_ITEM_COUNT then
		return
	end

	local var0_46 = false

	if arg0_46.genItemTime == 0 and arg0_46.time <= ValentineQteGameConst.GMAE_TIME - ValentineQteGameConst.GEN_ITEM_FIRST_TIME or arg0_46.genItemTime > 0 and arg0_46.genItemTime - arg0_46.time > ValentineQteGameConst.GEN_ITEM_INTERVAL then
		var0_46 = true
	end

	if var0_46 then
		arg0_46:RandomItemPosition(0)
	end
end

function var0_0.IsVaildItemPos(arg0_47, arg1_47)
	local var0_47 = arg0_47.slider.sizeDelta.x + 80

	for iter0_47, iter1_47 in ipairs(arg0_47.items) do
		if not iter1_47:IsSufficientLength(arg1_47, var0_47) then
			return false
		end
	end

	return true
end

function var0_0.RandomItemPosition(arg0_48, arg1_48)
	if arg1_48 > 10 then
		return
	end

	local var0_48 = math.random(1, 2) % 2 == 0 and arg0_48.itemGenMinArea or arg0_48.itemGenMaxArea
	local var1_48 = math.random(var0_48.x, var0_48.y)

	if arg0_48:IsVaildItemPos(var1_48) then
		arg0_48.genItemTime = arg0_48.time

		local var2_48 = arg0_48.itemPoolMgr:Dequeue()

		SetParent(var2_48, arg0_48.itemContainer)

		local var3_48 = ValentineQteGameItem.New(var2_48, Vector2(var1_48, arg0_48.slider.localPosition.y), arg0_48.time)

		table.insert(arg0_48.items, var3_48)
	else
		arg0_48:RandomItemPosition(arg1_48 + 1)
	end
end

function var0_0.UpdateSlider(arg0_49)
	local var0_49 = arg0_49.slider.localPosition

	if var0_49.x == arg0_49.missMinPosX or var0_49.x == arg0_49.missMaxPosX then
		arg0_49.speedX = -arg0_49.speedX
	end

	local var1_49 = math.clamp(var0_49.x + arg0_49.speedX * Time.deltaTime, arg0_49.missMinPosX, arg0_49.missMaxPosX)

	arg0_49.slider.localPosition = Vector3(var1_49, var0_49.y, 0)
end

function var0_0.UpdateTime(arg0_50)
	arg0_50.time = arg0_50.time - Time.deltaTime

	if arg0_50.time <= 0 then
		arg0_50:EndGame(true)
	end

	arg0_50:UpdateTimeText(arg0_50.time)
end

function var0_0.UpdateSpeed(arg0_51)
	local var0_51 = math.floor(math.ceil(ValentineQteGameConst.GMAE_TIME - arg0_51.time) / 5)

	if var0_51 > 0 and not arg0_51.elapseTimes[var0_51] and arg0_51.accelerated + ValentineQteGameConst.INIT_SPEED < ValentineQteGameConst.MAX_SPEED then
		arg0_51.elapseTimes[var0_51] = true
		arg0_51.accelerated = arg0_51.accelerated + ValentineQteGameConst.SPEED_UP

		if arg0_51.speedX < 0 then
			arg0_51.speedX = arg0_51.speedX - arg0_51.accelerated
		else
			arg0_51.speedX = arg0_51.speedX + arg0_51.accelerated
		end
	end
end

function var0_0.UpdateOpCdTime(arg0_52)
	if arg0_52.opCdTime > 0 then
		arg0_52.opCdTime = math.max(0, arg0_52.opCdTime - Time.deltaTime)
	end
end

function var0_0.Snap(arg0_53)
	local var0_53 = arg0_53.slider.localPosition.x
	local var1_53 = arg0_53:GetScoreGear(var0_53)
	local var2_53 = {}
	local var3_53 = false

	if var1_53 == ValentineQteGameConst.OP_SCORE_GEAR_GREAT then
		arg0_53.comboCnt = arg0_53.comboCnt + 1
		arg0_53.statistics.Great = arg0_53.statistics.Great + 1
	elseif var1_53 == ValentineQteGameConst.OP_SCORE_GEAR_PERFECT then
		arg0_53.comboCnt = arg0_53.comboCnt + 1
		arg0_53.statistics.Perfect = arg0_53.statistics.Perfect + 1
	elseif arg0_53:CanPickItem(var0_53, var2_53) then
		arg0_53.comboCnt = arg0_53.comboCnt + 1
		var1_53 = ValentineQteGameConst.OP_SCORE_GEAR_PERFECT
		arg0_53.statistics.Perfect = arg0_53.statistics.Perfect + 1

		arg0_53:PickItems(var2_53)

		var3_53 = true
	elseif var1_53 == ValentineQteGameConst.OP_SCORE_GEAR_MISS then
		arg0_53.comboCnt = 0
		arg0_53.statistics.Miss = arg0_53.statistics.Miss + 1
	elseif var1_53 == ValentineQteGameConst.OP_SCORE_GEAR_GOOD then
		arg0_53.comboCnt = 0
		arg0_53.statistics.Good = arg0_53.statistics.Good + 1
	end

	local var4_53 = arg0_53:GetScore(var1_53, arg0_53.comboCnt)

	arg0_53.score = arg0_53.score + var4_53

	arg0_53:UpdateScoreText(arg0_53.score)
	arg0_53:UpdateComboText(arg0_53.comboCnt)

	if arg0_53.comboCnt > arg0_53.statistics.Combo then
		arg0_53.statistics.Combo = arg0_53.comboCnt
	end

	arg0_53:UpdateGear(var1_53, var3_53)
end

function var0_0.UpdateGear(arg0_54, arg1_54, arg2_54)
	if LeanTween.isTweening(arg0_54.gearTr.gameObject) then
		LeanTween.cancel(arg0_54.gearTr.gameObject)
	end

	arg0_54.gearTr.sprite = arg0_54.gearSps[arg1_54]

	arg0_54.gearTr:SetNativeSize()

	arg0_54.gearShowTime = arg0_54.time

	setActive(arg0_54.gearTr.gameObject, true)

	if arg2_54 then
		setActive(arg0_54.gearTr.gameObject, false)
		arg0_54:GenEffect(ValentineQteGameConst.OP_SCORE_GEAR_GREAT)
		arg0_54:PlaySound(ValentineQteGameConst.SOUND_PICK_ITEM)
	else
		arg0_54:GenEffect(arg1_54)
		arg0_54:GearAnim()
		arg0_54:PlaySound(ValentineQteGameConst.GEAR_SOUND[arg1_54])
	end
end

function var0_0.PlaySound(arg0_55, arg1_55)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_55)
end

function var0_0.GearAnim(arg0_56)
	arg0_56.gearTr.gameObject.transform.localPosition = Vector3(arg0_56.gearTr.gameObject.transform.localPosition.x, arg0_56.gearTrPos, 0)

	LeanTween.value(arg0_56.gearTr.gameObject, arg0_56.gearTrPos, arg0_56.gearTrPos + 50, 0.3):setOnUpdate(System.Action_float(function(arg0_57)
		arg0_56.gearTr.gameObject.transform.localPosition = Vector3(arg0_56.gearTr.gameObject.transform.localPosition.x, arg0_57, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_56.gearTr.gameObject, false)
	end))
end

function var0_0.GenEffect(arg0_59, arg1_59)
	local var0_59 = arg0_59.effectPools[arg1_59]
	local var1_59 = var0_59:Dequeue()

	SetParent(var1_59, arg0_59.effectContainer)

	var1_59.transform.localPosition = Vector3(arg0_59.slider.localPosition.x, arg0_59.slider.localPosition.y, -100)

	local var2_59 = Timer.New(function()
		var0_59:Enqueue(var1_59)
	end, 2, 1)

	var2_59:Start()
	table.insert(arg0_59.timers, var2_59)
end

function var0_0.CanPickItem(arg0_61, arg1_61, arg2_61)
	for iter0_61, iter1_61 in ipairs(arg0_61.items) do
		if iter1_61:IsOverlap(arg0_61.slider) then
			table.insert(arg2_61, iter1_61)
		end
	end

	return #arg2_61 > 0
end

function var0_0.PickItems(arg0_62, arg1_62)
	for iter0_62, iter1_62 in ipairs(arg1_62) do
		arg0_62:PlayPickAnim(iter1_62, function()
			iter1_62:Destroy()
			arg0_62.itemPoolMgr:Enqueue(iter1_62._tf)
		end)
		table.removebyvalue(arg0_62.items, iter1_62)
	end
end

function var0_0.PlayPickAnim(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg1_64._tf.localPosition.y

	LeanTween.value(arg1_64._go, var0_64, var0_64 + 70, 0.3):setOnUpdate(System.Action_float(function(arg0_65)
		arg1_64._tf.localPosition = Vector3(arg1_64._tf.localPosition.x, arg0_65, 0)
	end)):setOnComplete(System.Action(function()
		local var0_66 = arg0_64.pickPool:Dequeue()

		SetParent(var0_66, arg0_64.effectContainer)

		var0_66.transform.localPosition = Vector3(arg1_64._tf.localPosition.x, arg1_64._tf.localPosition.y, -100)

		local var1_66 = Timer.New(function()
			arg0_64.pickPool:Enqueue(var0_66)
		end, 2, 1)

		var1_66:Start()
		table.insert(arg0_64.timers, var1_66)
		arg2_64()
	end))
end

function var0_0.UpdateTimeText(arg0_68, arg1_68)
	local var0_68 = math.ceil(arg1_68)

	if var0_68 <= 0 then
		arg0_68.timeTxt.text = "0"
	else
		arg0_68.timeTxt.text = math.max(0, var0_68)
	end
end

function var0_0.UpdateScoreText(arg0_69, arg1_69)
	arg0_69.scoreTxt.text = arg1_69
end

function var0_0.UpdateComboText(arg0_70, arg1_70)
	arg0_70.comboTxt.text = arg1_70
end

function var0_0.GetScoreGear(arg0_71, arg1_71)
	if arg1_71 >= arg0_71.prefectMinPosX and arg1_71 <= arg0_71.prefectMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_PERFECT
	end

	if arg1_71 >= arg0_71.greatMinPosX and arg1_71 <= arg0_71.greatMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_GREAT
	end

	if arg1_71 >= arg0_71.goodMinPosX and arg1_71 <= arg0_71.goodMaxPosX then
		return ValentineQteGameConst.OP_SCORE_GEAR_GOOD
	end

	return ValentineQteGameConst.OP_SCORE_GEAR_MISS
end

function var0_0.GetScore(arg0_72, arg1_72, arg2_72)
	local var0_72 = ValentineQteGameConst.OP_SCORE[arg1_72]
	local var1_72 = ValentineQteGameConst.BASE_OP_SCORE * var0_72
	local var2_72 = 0

	for iter0_72, iter1_72 in ipairs(ValentineQteGameConst.COMBO_EXTRA_SCORE_RATIO) do
		local var3_72 = iter1_72[1]
		local var4_72 = iter1_72[2]
		local var5_72 = iter1_72[3]

		if var3_72 <= arg2_72 and arg2_72 <= var4_72 then
			var2_72 = var5_72

			break
		end
	end

	return var1_72 + ValentineQteGameConst.BASE_OP_SCORE * var2_72 * 0.01
end

function var0_0.PuaseGame(arg0_73)
	arg0_73.puaseGameFlag = true

	arg0_73.char:Pause()
end

function var0_0.ResumeGame(arg0_74)
	arg0_74.puaseGameFlag = false

	arg0_74.char:Resume()
end

function var0_0.EndGame(arg0_75, arg1_75)
	if arg0_75.handle then
		UpdateBeat:RemoveListener(arg0_75.handle)
	end

	ClearEventTrigger(arg0_75.dragDelegate)
	removeOnButton(arg0_75.puaseBtn)

	if arg1_75 then
		arg0_75.statistics.Score = arg0_75.score

		arg0_75.resultWindow:Show(arg0_75.statistics, function()
			arg0_75:Destroy()
		end)
	end

	if arg0_75.onComplete and arg1_75 then
		arg0_75.onComplete()
	end

	arg0_75.onComplete = nil
end

function var0_0.ExitGame(arg0_77)
	arg0_77:EndGame(false)

	if arg0_77.onExist then
		arg0_77.onExist()

		arg0_77.onExist = nil
	end
end

function var0_0.onBackPressed(arg0_78)
	if arg0_78.startFlag and not arg0_78.puaseGameFlag then
		triggerButton(arg0_78.puaseBtn)

		return true
	end

	if isActive(arg0_78.msgBox._tf) then
		triggerButton(arg0_78.msgBox.cancelBtn)

		return true
	end

	return false
end

function var0_0.Destroy(arg0_79)
	if arg0_79.countDownTimer then
		arg0_79.countDownTimer:Stop()

		arg0_79.countDownTimer = nil
	end

	if LeanTween.isTweening(arg0_79.gearTr.gameObject) then
		LeanTween.cancel(arg0_79.gearTr.gameObject)
	end

	for iter0_79, iter1_79 in ipairs(arg0_79.timers) do
		iter1_79:Stop()
	end

	arg0_79.timers = nil

	for iter2_79, iter3_79 in pairs(arg0_79.effectPools) do
		iter3_79:Destroy()
	end

	arg0_79.effectPools = nil

	arg0_79.refrigerator:SetActionCallBack(nil)

	if arg0_79.msgBox then
		arg0_79.msgBox:Destroy()

		arg0_79.msgBox = nil
	end

	if arg0_79.resultWindow then
		arg0_79.resultWindow:Destroy()

		arg0_79.resultWindow = nil
	end

	arg0_79:ExitGame()
	pg.DelegateInfo.Dispose(arg0_79)

	if arg0_79.itemPoolMgr then
		arg0_79.itemPoolMgr:Destroy()

		arg0_79.itemPoolMgr = nil
	end

	arg0_79.gearSps = nil
end

return var0_0
