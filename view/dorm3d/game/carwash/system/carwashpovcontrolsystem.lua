local var0_0 = class("CarWashPovControlSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.ON_STICK_MOVE_BEGIN = "CarWashPovControlSystem.ON_STICK_MOVE_BEGIN"
var0_0.ON_STICK_MOVE = "CarWashPovControlSystem.ON_STICK_MOVE"
var0_0.ON_STICK_MOVE_END = "CarWashPovControlSystem.ON_STICK_MOVE_END"
var0_0.ON_STICK_VIEW = "CarWashPovControlSystem.ON_STICK_VIEW"
var0_0.SWITCH_CAMERA = "CarWashPovControlSystem.SWITCH_CAMERA"
var0_0.MOVE_SPEED = 2
var0_0.MOVE_STICK_RANGE = 200
var0_0.VIEW_STICK_RATIO = 0.05
var0_0.FP_CAMERA = "FP Camera"

function var0_0.OnInit(arg0_1)
	arg0_1:InitSceneRefs()
	arg0_1:ResetMoveStick()
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.ON_STICK_MOVE_BEGIN, function(arg0_3, arg1_3)
		arg0_2:StartMove(arg1_3)
	end)
	arg0_2:Bind(var0_0.ON_STICK_MOVE, function(arg0_4, arg1_4)
		arg0_2:UpdateMoveStick(arg1_4)
	end)
	arg0_2:Bind(var0_0.ON_STICK_MOVE_END, function()
		arg0_2:ResetMoveStick()
	end)
	arg0_2:Bind(var0_0.ON_STICK_VIEW, function(arg0_6, arg1_6)
		arg0_2:UpdateViewStick(arg1_6)
	end)
	arg0_2:Bind(var0_0.SWITCH_CAMERA, function(arg0_7, arg1_7)
		arg0_2:SwitchCameraByName(arg1_7)
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_8, arg1_8)
		if arg1_8.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			arg0_2:SwitchCameraByName(var0_0.FP_CAMERA)
		elseif arg1_8.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			arg0_2:SwitchCameraByName(arg0_2.posConfig.phase2_camera)
		end
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_LADY_POS, function(arg0_9, arg1_9)
		arg0_2.posConfig = arg1_9.newValue
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function()
		setActive(arg0_2.mainCameraTF, false)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function()
		setActive(arg0_2.mainCameraTF, true)
	end)
end

function var0_0.OnUpdate(arg0_12, arg1_12)
	arg0_12:UpdatePlayerMove()
end

function var0_0.OnDispose(arg0_13)
	arg0_13:ResetMoveStick()

	arg0_13.compPovAim = nil
	arg0_13.povCamera = nil
	arg0_13.currentCamera = nil
	arg0_13.currentCameraTF = nil
	arg0_13.currentCameraName = nil
	arg0_13.posConfig = nil
	arg0_13.cameras = nil
	arg0_13.cameraNames = nil
	arg0_13.cameraRoot = nil
	arg0_13.characterController = nil
	arg0_13.player = nil
end

function var0_0.InitSceneRefs(arg0_14)
	arg0_14.mainCameraTF = arg0_14:GetMainCameraTF()
	arg0_14.player = GameObject.Find("Player").transform
	arg0_14.characterController = arg0_14.player:GetComponent(typeof(UnityEngine.CharacterController))

	assert(arg0_14.characterController, "CarWash Player CharacterController not found")
	arg0_14:InitCameras()
end

function var0_0.InitCameras(arg0_15)
	arg0_15.cameraRoot = arg0_15:GetCameraRoot()

	assert(arg0_15.cameraRoot, "CarWash camera root not found")

	arg0_15.cameras = {}
	arg0_15.cameraNames = {}

	for iter0_15 = 0, arg0_15.cameraRoot.childCount - 1 do
		local var0_15 = arg0_15.cameraRoot:GetChild(iter0_15)

		arg0_15.cameras[var0_15.name] = {
			tf = var0_15,
			virtualCamera = var0_15:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
			freeLook = var0_15:GetComponent(typeof(Cinemachine.CinemachineFreeLook))
		}

		table.insert(arg0_15.cameraNames, var0_15.name)
	end
end

function var0_0.GetCameraInfo(arg0_16, arg1_16)
	if not arg0_16.cameras then
		return nil
	end

	return arg0_16.cameras[arg1_16]
end

function var0_0.GetCameraNames(arg0_17)
	return arg0_17.cameraNames or {}
end

function var0_0.GetCurrentCameraName(arg0_18)
	return arg0_18.currentCameraName
end

function var0_0.GetCurrentCamera(arg0_19)
	return arg0_19.currentCamera
end

function var0_0.GetCurrentCameraTF(arg0_20)
	return arg0_20.currentCameraTF
end

function var0_0.SwitchCameraByName(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetCameraInfo(arg1_21)

	assert(var0_21, "CarWash camera not found: " .. tostring(arg1_21))

	for iter0_21, iter1_21 in pairs(arg0_21.cameras) do
		setActive(iter1_21.tf, iter1_21 == var0_21)
	end

	arg0_21.currentCameraName = arg1_21
	arg0_21.currentCameraTF = var0_21.tf
	arg0_21.currentCamera = var0_21.virtualCamera or var0_21.freeLook
	arg0_21.povCamera = var0_21.virtualCamera
	arg0_21.compPovAim = arg0_21.povCamera and arg0_21.povCamera:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim) or nil

	return arg0_21.currentCamera
end

function var0_0.StartMove(arg0_22, arg1_22)
	if not arg1_22 then
		return
	end

	arg0_22.moveStickOrigin = arg1_22.position
	arg0_22.moveStickPosition = arg0_22.moveStickOrigin
	arg0_22.isMoveStickDragging = true
end

function var0_0.ResetMoveStick(arg0_23)
	arg0_23.moveStickOrigin = nil
	arg0_23.moveStickPosition = nil
	arg0_23.isMoveStickDragging = false
end

function var0_0.UpdateMoveStick(arg0_24, arg1_24)
	if not arg0_24.isMoveStickDragging then
		return
	end

	if not arg1_24 then
		return
	end

	arg0_24.moveStickPosition = arg0_24.moveStickPosition + arg1_24
end

function var0_0.UpdateViewStick(arg0_25, arg1_25)
	if not arg0_25.compPovAim then
		return
	end

	if not arg1_25 then
		return
	end

	arg1_25 = arg1_25 * (var0_0.VIEW_STICK_RATIO * 1080 / Screen.height)

	arg0_25:SetAxisInput("m_HorizontalAxis", arg1_25.x)
	arg0_25:SetAxisInput("m_VerticalAxis", arg1_25.y)
end

function var0_0.SetAxisInput(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.compPovAim[arg1_26]

	var0_26.m_InputAxisValue = arg2_26
	arg0_26.compPovAim[arg1_26] = var0_26
end

function var0_0.UpdatePlayerMove(arg0_27)
	if not arg0_27.isMoveStickDragging then
		return
	end

	local var0_27 = Vector2.ClampMagnitude(arg0_27.moveStickPosition - arg0_27.moveStickOrigin, var0_0.MOVE_STICK_RANGE)
	local var1_27 = var0_27 / var0_0.MOVE_STICK_RANGE

	arg0_27.moveStickPosition = arg0_27.moveStickOrigin + var0_27

	local var2_27 = Vector3.New(var1_27.x, 0, var1_27.y)

	if var2_27:SqrMagnitude() <= 0 then
		return
	end

	local var3_27 = arg0_27.mainCameraTF:TransformDirection(var2_27)

	var3_27.y = 0

	local var4_27 = var3_27:Normalize()

	var4_27:Mul(var0_0.MOVE_SPEED)
	arg0_27.characterController:SimpleMove(var4_27)
end

return var0_0
