local var0_0 = class("CarWashPovControlSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.ON_STICK_MOVE_BEGIN = "CarWashPovControlSystem.ON_STICK_MOVE_BEGIN"
var0_0.ON_STICK_MOVE = "CarWashPovControlSystem.ON_STICK_MOVE"
var0_0.ON_STICK_MOVE_END = "CarWashPovControlSystem.ON_STICK_MOVE_END"
var0_0.ON_STICK_VIEW = "CarWashPovControlSystem.ON_STICK_VIEW"
var0_0.SWITCH_CAMERA = "CarWashPovControlSystem.SWITCH_CAMERA"
var0_0.MOVE_SPEED = 2
var0_0.MOVE_STICK_RANGE = 200
var0_0.VIEW_STICK_RATIO = 0.03
var0_0.FP_CAMERA = "FP Camera"
var0_0.INSIDE_CAR_CAMERA = "InsideCarCamera"

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
			arg0_2:SwitchCameraByName(var0_0.INSIDE_CAR_CAMERA)
		end
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function()
		setActive(arg0_2.mainCameraTF, false)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function()
		setActive(arg0_2.mainCameraTF, true)
	end)
end

function var0_0.OnUpdate(arg0_11, arg1_11)
	arg0_11:UpdatePlayerMove()
end

function var0_0.OnDispose(arg0_12)
	arg0_12:ResetMoveStick()

	arg0_12.compPovAim = nil
	arg0_12.povCamera = nil
	arg0_12.currentCamera = nil
	arg0_12.currentCameraTF = nil
	arg0_12.currentCameraName = nil
	arg0_12.cameras = nil
	arg0_12.cameraNames = nil
	arg0_12.cameraRoot = nil
	arg0_12.characterController = nil
	arg0_12.player = nil
end

function var0_0.InitSceneRefs(arg0_13)
	arg0_13.mainCameraTF = arg0_13:GetMainCameraTF()
	arg0_13.player = GameObject.Find("Player").transform
	arg0_13.characterController = arg0_13.player:GetComponent(typeof(UnityEngine.CharacterController))

	assert(arg0_13.characterController, "CarWash Player CharacterController not found")
	arg0_13:InitCameras()
end

function var0_0.InitCameras(arg0_14)
	arg0_14.cameraRoot = arg0_14:GetCameraRoot()

	assert(arg0_14.cameraRoot, "CarWash camera root not found")

	arg0_14.cameras = {}
	arg0_14.cameraNames = {}

	for iter0_14 = 0, arg0_14.cameraRoot.childCount - 1 do
		local var0_14 = arg0_14.cameraRoot:GetChild(iter0_14)

		arg0_14.cameras[var0_14.name] = {
			tf = var0_14,
			virtualCamera = var0_14:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
			freeLook = var0_14:GetComponent(typeof(Cinemachine.CinemachineFreeLook))
		}

		table.insert(arg0_14.cameraNames, var0_14.name)
	end
end

function var0_0.GetCameraInfo(arg0_15, arg1_15)
	if not arg0_15.cameras then
		return nil
	end

	return arg0_15.cameras[arg1_15]
end

function var0_0.GetCameraNames(arg0_16)
	return arg0_16.cameraNames or {}
end

function var0_0.GetCurrentCameraName(arg0_17)
	return arg0_17.currentCameraName
end

function var0_0.GetCurrentCamera(arg0_18)
	return arg0_18.currentCamera
end

function var0_0.GetCurrentCameraTF(arg0_19)
	return arg0_19.currentCameraTF
end

function var0_0.SwitchCameraByName(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetCameraInfo(arg1_20)

	assert(var0_20, "CarWash camera not found: " .. tostring(arg1_20))

	for iter0_20, iter1_20 in pairs(arg0_20.cameras) do
		setActive(iter1_20.tf, iter1_20 == var0_20)
	end

	arg0_20.currentCameraName = arg1_20
	arg0_20.currentCameraTF = var0_20.tf
	arg0_20.currentCamera = var0_20.virtualCamera or var0_20.freeLook
	arg0_20.povCamera = var0_20.virtualCamera
	arg0_20.compPovAim = arg0_20.povCamera and arg0_20.povCamera:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim) or nil

	return arg0_20.currentCamera
end

function var0_0.StartMove(arg0_21, arg1_21)
	if not arg1_21 then
		return
	end

	arg0_21.moveStickOrigin = arg1_21.position
	arg0_21.moveStickPosition = arg0_21.moveStickOrigin
	arg0_21.isMoveStickDragging = true
end

function var0_0.ResetMoveStick(arg0_22)
	arg0_22.moveStickOrigin = nil
	arg0_22.moveStickPosition = nil
	arg0_22.isMoveStickDragging = false
end

function var0_0.UpdateMoveStick(arg0_23, arg1_23)
	if not arg0_23.isMoveStickDragging then
		return
	end

	if not arg1_23 then
		return
	end

	arg0_23.moveStickPosition = arg0_23.moveStickPosition + arg1_23
end

function var0_0.UpdateViewStick(arg0_24, arg1_24)
	if not arg0_24.compPovAim then
		return
	end

	if not arg1_24 then
		return
	end

	arg1_24 = arg1_24 * (var0_0.VIEW_STICK_RATIO * 1080 / Screen.height)

	arg0_24:SetAxisInput("m_HorizontalAxis", arg1_24.x)
	arg0_24:SetAxisInput("m_VerticalAxis", arg1_24.y)
end

function var0_0.SetAxisInput(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.compPovAim[arg1_25]

	var0_25.m_InputAxisValue = arg2_25
	arg0_25.compPovAim[arg1_25] = var0_25
end

function var0_0.UpdatePlayerMove(arg0_26)
	if not arg0_26.isMoveStickDragging then
		return
	end

	local var0_26 = Vector2.ClampMagnitude(arg0_26.moveStickPosition - arg0_26.moveStickOrigin, var0_0.MOVE_STICK_RANGE)
	local var1_26 = var0_26 / var0_0.MOVE_STICK_RANGE

	arg0_26.moveStickPosition = arg0_26.moveStickOrigin + var0_26

	local var2_26 = Vector3.New(var1_26.x, 0, var1_26.y)

	if var2_26:SqrMagnitude() <= 0 then
		return
	end

	local var3_26 = arg0_26.mainCameraTF:TransformDirection(var2_26)

	var3_26.y = 0

	local var4_26 = var3_26:Normalize()

	var4_26:Mul(var0_0.MOVE_SPEED)
	arg0_26.characterController:SimpleMove(var4_26)
end

return var0_0
