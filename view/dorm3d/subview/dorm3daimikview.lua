local var0_0 = class("Dorm3dAimIKView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.TIP_WAIT_TIME = 5
var0_0.BIND_DRAG_AREA = "Dorm3dAimIKView.BindDragArea"
var0_0.SHOW_OR_HIDE = "Dorm3dAimIKView.ShowOrHide"

function var0_0.Init(arg0_1)
	arg0_1.controlTF = arg0_1._tf:Find("AimIKControl")
	arg0_1.uiTF = arg0_1._tf:Find("UI/aimik")

	assert(not IsNil(arg0_1.controlTF) and not IsNil(arg0_1.uiTF), "AimIKControl or UI/aimik missing")

	arg0_1.tipTF = arg0_1.controlTF:Find("Tips")
	arg0_1.layer = arg0_1.controlTF:Find("ControlLayer")
	arg0_1.controller = arg0_1.layer:GetComponent(typeof(SlideController))
	arg0_1.backTF = arg0_1.uiTF:Find("btn_back")

	assert(not IsNil(arg0_1.backTF), "UI/aimik/btn_back missing")
	onButton(arg0_1, arg0_1.backTF, function()
		arg0_1:emit(AimIKSystem.EXIT_TOUCH_AIMIK_STATUS)
	end, SFX_CANCEL)
	arg0_1:InitDragEvent()
	arg0_1:InitHint()
	arg0_1:Hide()
	arg0_1:bind(var0_0.BIND_DRAG_AREA, function(arg0_3, arg1_3)
		arg1_3.dragArea = arg0_1.layer
	end)
	arg0_1:bind(var0_0.SHOW_OR_HIDE, function(arg0_4, arg1_4, arg2_4)
		if arg1_4 then
			arg0_1:Show(arg2_4)
		else
			arg0_1:Hide()
		end
	end)
end

function var0_0.InitDragEvent(arg0_5)
	arg0_5.controller:AddBeginDragFunc(function(arg0_6, arg1_6)
		if not arg0_5.showing or not arg1_6 then
			return
		end

		setActive(arg0_5.tipTF, false)
		arg0_5.timer:Stop()
		arg0_5:emit(AimIKSystem.ON_BEGIN_DRAG, arg0_6, arg1_6)
	end)
	arg0_5.controller:AddDragFunc(function(arg0_7, arg1_7)
		if not arg0_5.showing or not arg1_7 then
			return
		end

		arg0_5:emit(AimIKSystem.ON_DRAG, arg0_7, arg1_7)
	end)
	arg0_5.controller:AddDragEndFunc(function(arg0_8, arg1_8)
		if arg0_5.showing then
			arg0_5.timer:Start()
		end

		arg0_5:emit(AimIKSystem.ON_END_DRAG, arg0_8, arg1_8)
	end)
end

function var0_0.InitHint(arg0_9)
	arg0_9.time = var0_0.TIP_WAIT_TIME
	arg0_9.timer = Timer.New(function()
		if arg0_9.time <= 0 then
			arg0_9.time = var0_0.TIP_WAIT_TIME

			if isActive(arg0_9.tipTF) == false then
				setActive(arg0_9.tipTF, true)
				arg0_9:FlushHint()
			end
		else
			arg0_9.time = arg0_9.time - 0.1
		end
	end, 0.1, -1)
end

function var0_0.FlushHint(arg0_11)
	local var0_11 = {}

	arg0_11:emit(AimIKSystem.GET_TIP_SHOW_INFO, var0_11)

	local var1_11 = var0_11[1] or {}

	UIItemList.StaticAlign(arg0_11.tipTF, arg0_11.tipTF:GetChild(0), #var1_11, function(arg0_12, arg1_12, arg2_12)
		if arg0_12 ~= UIItemList.EventUpdate then
			return
		end

		arg1_12 = arg1_12 + 1

		setLocalPosition(arg2_12, LuaHelper.ScreenToLocal(arg0_11.tipTF, var1_11[arg1_12].pos, pg.UIMgr.GetInstance().uiCameraComp))
	end)
end

function var0_0.Show(arg0_13, arg1_13)
	arg0_13.showing = true

	setActive(arg0_13.backTF, tobool(arg1_13))
	setActive(arg0_13.controlTF, true)
	setActive(arg0_13.uiTF, tobool(arg1_13))
	arg0_13.timer:Start()
end

function var0_0.Hide(arg0_14)
	arg0_14.showing = false

	setActive(arg0_14.tipTF, false)
	setActive(arg0_14.controlTF, false)
	setActive(arg0_14.uiTF, false)
	arg0_14.timer:Stop()

	arg0_14.time = var0_0.TIP_WAIT_TIME
end

function var0_0.Dispose(arg0_15)
	arg0_15:Hide()
	var0_0.super.Dispose(arg0_15)
end

return var0_0
