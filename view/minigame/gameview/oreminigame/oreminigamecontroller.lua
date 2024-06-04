local var0 = class("OreMiniGameController")

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg1

	arg0:InitTimer()
	arg0:InitGameUI(arg2)
	arg0:InitControl()
	arg0:AddListener()
end

local function var1(arg0, arg1)
	local var0 = arg0:GetComponentsInChildren(typeof(Animator), true)

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].speed = arg1
	end
end

function var0.InitTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:OnTimer(OreGameConfig.TIME_INTERVAL)
	end, OreGameConfig.TIME_INTERVAL, -1)

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if IsUnityEditor and Input.GetKeyDown(KeyCode.Space) then
		arg0:OnCarryBtnClick()
	end
end

function var0.InitGameUI(arg0, arg1)
	arg0.uiMgr = pg.UIMgr.GetInstance()
	arg0.rtViewport = arg1:Find("Viewport")
	arg0.rtCharacter = arg0.rtViewport:Find("MainContent/character")
	arg0.bgManjuu = arg0.rtViewport:Find("MainContent/bg_back/Manjuu_SW")
	arg0.rtController = arg1:Find("Controller")
	arg0.rtTop = arg1:Find("Controller/top")
	arg0.TimeTextM = arg0.rtTop:Find("title/TIME/Text_M")
	arg0.TimeTextS = arg0.rtTop:Find("title/TIME/Text_S")
	arg0.pointText = arg0.rtTop:Find("title/SCORE/Text")
	arg0.rtBottom = arg1:Find("Controller/bottom")
	arg0.rtPointer = arg0.rtBottom:Find("capacity/pointer")
	arg0.rtJoyStick = arg0.rtBottom:Find("handle_stick")

	onButton(arg0.binder, arg0.rtBottom:Find("btn_carry"), function()
		arg0:OnCarryBtnClick()
	end)
end

function var0.InitControl(arg0)
	arg0.collisionMgr = OreCollisionMgr.New(arg0.binder)
	arg0.akashiControl = OreAkashiControl.New(arg0.binder, arg0.rtCharacter:Find("Akashi"), arg0.collisionMgr)
	arg0.enemiesControl = OreEnemiesControl.New(arg0.binder, arg0.rtCharacter:Find("Enemies"), arg0.collisionMgr)
	arg0.minersControl = OreMinersControl.New(arg0.binder, arg0.rtCharacter:Find("Miners"), arg0.collisionMgr)
	arg0.oreGroupControl = OreGroupControl.New(arg0.binder, arg0.rtViewport:Find("MainContent/ore_group"), arg0.collisionMgr)
	arg0.containerControl = OreContainerControl.New(arg0.binder, arg0.rtViewport:Find("MainContent/container"))
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_DO_CARRY, function(arg0, arg1)
		arg0.weight = arg0.weight + arg1.weight

		arg0:UpdateWeightUI()
	end)
	arg0.binder:bind(OreGameConfig.EVENT_DELIVER, function(arg0, arg1)
		arg0.point = arg0.point + arg1.point
		arg0.weight = 0

		arg0:UpdatePointUI()
		arg0:UpdateWeightUI()
		arg0.bgManjuu:GetComponent(typeof(Animator)):Play("Happy")
	end)
	arg0.binder:bind(OreGameConfig.EVENT_AKASHI_HIT, function(arg0, arg1)
		arg0.weight = 0

		arg0:UpdateWeightUI()
		arg0.bgManjuu:GetComponent(typeof(Animator)):Play("Shock")
	end)
end

function var0.OnCarryBtnClick(arg0)
	arg0.binder:emit(OreGameConfig.EVENT_CHECK_CARRY, {
		weight = arg0.weight
	})
end

function var0.UpdateTimeUI(arg0)
	if arg0.timeCount < 60 then
		setText(arg0.TimeTextM, "00")
	else
		setText(arg0.TimeTextM, string.format("%02d", arg0.timeCount / 60))
	end

	setText(arg0.TimeTextS, string.format("%02d", arg0.timeCount % 60))
end

function var0.UpdateWeightUI(arg0)
	local var0 = 90

	if arg0.weight == 0 then
		setLocalEulerAngles(arg0.rtPointer, Vector3(0, 0, 90))

		return
	end

	if arg0.weight == OreGameConfig.MAX_WEIGHT then
		setLocalEulerAngles(arg0.rtPointer, Vector3(0, 0, -90))

		return
	end

	local var1 = OreGameConfig.CAPACITY

	if arg0.weight <= var1.WOOD_BOX then
		var0 = 90 - arg0.weight * 40 / var1.WOOD_BOX
	elseif arg0.weight <= var1.IRON_BOX then
		var0 = 37 - (arg0.weight - var1.WOOD_BOX) * 60 / (var1.IRON_BOX - var1.WOOD_BOX)
	else
		var0 = -37 - (arg0.weight - var1.IRON_BOX) * 40 / (var1.CART - var1.IRON_BOX)
	end

	setLocalEulerAngles(arg0.rtPointer, Vector3(0, 0, var0))
end

function var0.UpdatePointUI(arg0)
	setText(arg0.pointText, arg0.point)
end

function var0.ResetGame(arg0)
	arg0.timeCount = OreGameConfig.PLAY_TIME
	arg0.point = 0
	arg0.weight = 0

	arg0.akashiControl:Reset()
	arg0.minersControl:Reset()
	arg0.oreGroupControl:Reset()
	arg0.collisionMgr:Reset()
	arg0.enemiesControl:Reset()
	arg0.containerControl:Reset()
	arg0:UpdatePointUI()
	arg0:UpdateWeightUI()
	arg0:UpdateTimeUI()
end

function var0.StartGame(arg0)
	arg0.isStart = true

	arg0:ResetGame()
	arg0:StartTimer()
end

function var0.EndGame(arg0)
	arg0.isStart = false

	arg0:PauseGame()
	arg0.binder:openUI("result")
end

function var0.StartTimer(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
		arg0.uiMgr:AttachStickOb(arg0.rtJoyStick)
	end

	var1(arg0.rtViewport, 1)
end

function var0.StopTimer(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
		arg0.uiMgr:ClearStick()
	end

	var1(arg0.rtViewport, 0)
end

function var0.PauseGame(arg0)
	arg0.isPause = true

	arg0:StopTimer()
end

function var0.ResumeGame(arg0)
	arg0.isPause = false

	arg0:StartTimer()
end

function var0.OnTimer(arg0, arg1)
	arg0.timeCount = arg0.timeCount - arg1

	arg0:UpdateTimeUI()

	if arg0.timeCount <= 0 then
		arg0:EndGame()
	end

	arg0.akashiControl:OnTimer(arg1)
	arg0.minersControl:OnTimer(arg1)
	arg0.oreGroupControl:OnTimer(arg1)
	arg0.collisionMgr:OnTimer(arg1)
	arg0.enemiesControl:OnTimer(arg1)
	arg0.containerControl:OnTimer(arg1)
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0.timer.running then
		arg0.timer:Stop()

		arg0.timer = nil

		arg0.uiMgr:ClearStick()
	end
end

return var0
