local var0_0 = class("OreMiniGameController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1

	arg0_1:InitTimer()
	arg0_1:InitGameUI(arg2_1)
	arg0_1:InitControl()
	arg0_1:AddListener()
end

local function var1_0(arg0_2, arg1_2)
	local var0_2 = arg0_2:GetComponentsInChildren(typeof(Animator), true)

	for iter0_2 = 0, var0_2.Length - 1 do
		var0_2[iter0_2].speed = arg1_2
	end
end

function var0_0.InitTimer(arg0_3)
	arg0_3.timer = Timer.New(function()
		arg0_3:OnTimer(OreGameConfig.TIME_INTERVAL)
	end, OreGameConfig.TIME_INTERVAL, -1)

	if not arg0_3.handle then
		arg0_3.handle = UpdateBeat:CreateListener(arg0_3.Update, arg0_3)
	end

	UpdateBeat:AddListener(arg0_3.handle)
end

function var0_0.Update(arg0_5)
	arg0_5:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_6)
	if IsUnityEditor and Input.GetKeyDown(KeyCode.Space) then
		arg0_6:OnCarryBtnClick()
	end
end

function var0_0.InitGameUI(arg0_7, arg1_7)
	arg0_7.uiMgr = pg.UIMgr.GetInstance()
	arg0_7.rtViewport = arg1_7:Find("Viewport")
	arg0_7.rtCharacter = arg0_7.rtViewport:Find("MainContent/character")
	arg0_7.bgManjuu = arg0_7.rtViewport:Find("MainContent/bg_back/Manjuu_SW")
	arg0_7.rtController = arg1_7:Find("Controller")
	arg0_7.rtTop = arg1_7:Find("Controller/top")
	arg0_7.TimeTextM = arg0_7.rtTop:Find("title/TIME/Text_M")
	arg0_7.TimeTextS = arg0_7.rtTop:Find("title/TIME/Text_S")
	arg0_7.pointText = arg0_7.rtTop:Find("title/SCORE/Text")
	arg0_7.rtBottom = arg1_7:Find("Controller/bottom")
	arg0_7.rtPointer = arg0_7.rtBottom:Find("capacity/pointer")
	arg0_7.rtJoyStick = arg0_7.rtBottom:Find("handle_stick")

	onButton(arg0_7.binder, arg0_7.rtBottom:Find("btn_carry"), function()
		arg0_7:OnCarryBtnClick()
	end)
end

function var0_0.InitControl(arg0_9)
	arg0_9.collisionMgr = OreCollisionMgr.New(arg0_9.binder)
	arg0_9.akashiControl = OreAkashiControl.New(arg0_9.binder, arg0_9.rtCharacter:Find("Akashi"), arg0_9.collisionMgr)
	arg0_9.enemiesControl = OreEnemiesControl.New(arg0_9.binder, arg0_9.rtCharacter:Find("Enemies"), arg0_9.collisionMgr)
	arg0_9.minersControl = OreMinersControl.New(arg0_9.binder, arg0_9.rtCharacter:Find("Miners"), arg0_9.collisionMgr)
	arg0_9.oreGroupControl = OreGroupControl.New(arg0_9.binder, arg0_9.rtViewport:Find("MainContent/ore_group"), arg0_9.collisionMgr)
	arg0_9.containerControl = OreContainerControl.New(arg0_9.binder, arg0_9.rtViewport:Find("MainContent/container"))
end

function var0_0.AddListener(arg0_10)
	arg0_10.binder:bind(OreGameConfig.EVENT_DO_CARRY, function(arg0_11, arg1_11)
		arg0_10.weight = arg0_10.weight + arg1_11.weight

		arg0_10:UpdateWeightUI()
	end)
	arg0_10.binder:bind(OreGameConfig.EVENT_DELIVER, function(arg0_12, arg1_12)
		arg0_10.point = arg0_10.point + arg1_12.point
		arg0_10.weight = 0

		arg0_10:UpdatePointUI()
		arg0_10:UpdateWeightUI()
		arg0_10.bgManjuu:GetComponent(typeof(Animator)):Play("Happy")
	end)
	arg0_10.binder:bind(OreGameConfig.EVENT_AKASHI_HIT, function(arg0_13, arg1_13)
		arg0_10.weight = 0

		arg0_10:UpdateWeightUI()
		arg0_10.bgManjuu:GetComponent(typeof(Animator)):Play("Shock")
	end)
end

function var0_0.OnCarryBtnClick(arg0_14)
	arg0_14.binder:emit(OreGameConfig.EVENT_CHECK_CARRY, {
		weight = arg0_14.weight
	})
end

function var0_0.UpdateTimeUI(arg0_15)
	if arg0_15.timeCount < 60 then
		setText(arg0_15.TimeTextM, "00")
	else
		setText(arg0_15.TimeTextM, string.format("%02d", arg0_15.timeCount / 60))
	end

	setText(arg0_15.TimeTextS, string.format("%02d", arg0_15.timeCount % 60))
end

function var0_0.UpdateWeightUI(arg0_16)
	local var0_16 = 90

	if arg0_16.weight == 0 then
		setLocalEulerAngles(arg0_16.rtPointer, Vector3(0, 0, 90))

		return
	end

	if arg0_16.weight == OreGameConfig.MAX_WEIGHT then
		setLocalEulerAngles(arg0_16.rtPointer, Vector3(0, 0, -90))

		return
	end

	local var1_16 = OreGameConfig.CAPACITY

	if arg0_16.weight <= var1_16.WOOD_BOX then
		var0_16 = 90 - arg0_16.weight * 40 / var1_16.WOOD_BOX
	elseif arg0_16.weight <= var1_16.IRON_BOX then
		var0_16 = 37 - (arg0_16.weight - var1_16.WOOD_BOX) * 60 / (var1_16.IRON_BOX - var1_16.WOOD_BOX)
	else
		var0_16 = -37 - (arg0_16.weight - var1_16.IRON_BOX) * 40 / (var1_16.CART - var1_16.IRON_BOX)
	end

	setLocalEulerAngles(arg0_16.rtPointer, Vector3(0, 0, var0_16))
end

function var0_0.UpdatePointUI(arg0_17)
	setText(arg0_17.pointText, arg0_17.point)
end

function var0_0.ResetGame(arg0_18)
	arg0_18.timeCount = OreGameConfig.PLAY_TIME
	arg0_18.point = 0
	arg0_18.weight = 0

	arg0_18.akashiControl:Reset()
	arg0_18.minersControl:Reset()
	arg0_18.oreGroupControl:Reset()
	arg0_18.collisionMgr:Reset()
	arg0_18.enemiesControl:Reset()
	arg0_18.containerControl:Reset()
	arg0_18:UpdatePointUI()
	arg0_18:UpdateWeightUI()
	arg0_18:UpdateTimeUI()
end

function var0_0.StartGame(arg0_19)
	arg0_19.isStart = true

	arg0_19:ResetGame()
	arg0_19:StartTimer()
end

function var0_0.EndGame(arg0_20)
	arg0_20.isStart = false

	arg0_20:PauseGame()
	arg0_20.binder:openUI("result")
end

function var0_0.StartTimer(arg0_21)
	if not arg0_21.timer.running then
		arg0_21.timer:Start()
		arg0_21.uiMgr:AttachStickOb(arg0_21.rtJoyStick)
	end

	var1_0(arg0_21.rtViewport, 1)
end

function var0_0.StopTimer(arg0_22)
	if arg0_22.timer.running then
		arg0_22.timer:Stop()
		arg0_22.uiMgr:ClearStick()
	end

	var1_0(arg0_22.rtViewport, 0)
end

function var0_0.PauseGame(arg0_23)
	arg0_23.isPause = true

	arg0_23:StopTimer()
end

function var0_0.ResumeGame(arg0_24)
	arg0_24.isPause = false

	arg0_24:StartTimer()
end

function var0_0.OnTimer(arg0_25, arg1_25)
	arg0_25.timeCount = arg0_25.timeCount - arg1_25

	arg0_25:UpdateTimeUI()

	if arg0_25.timeCount <= 0 then
		arg0_25:EndGame()
	end

	arg0_25.akashiControl:OnTimer(arg1_25)
	arg0_25.minersControl:OnTimer(arg1_25)
	arg0_25.oreGroupControl:OnTimer(arg1_25)
	arg0_25.collisionMgr:OnTimer(arg1_25)
	arg0_25.enemiesControl:OnTimer(arg1_25)
	arg0_25.containerControl:OnTimer(arg1_25)
end

function var0_0.willExit(arg0_26)
	if arg0_26.handle then
		UpdateBeat:RemoveListener(arg0_26.handle)
	end

	if arg0_26.timer.running then
		arg0_26.timer:Stop()

		arg0_26.timer = nil

		arg0_26.uiMgr:ClearStick()
	end
end

return var0_0
