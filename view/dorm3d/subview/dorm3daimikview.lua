local var0_0 = class("Dorm3dAimIKView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.TIP_WAIT_TIME = 5
var0_0.BIND_DRAG_AREA = "Dorm3dAimIKView.BindDragArea"
var0_0.SHOW_OR_HIDE = "Dorm3dAimIKView.ShowOrHide"

function var0_0.Init(arg0_1)
	arg0_1.tipTF = arg0_1._tf:Find("Tips")
	arg0_1.layer = arg0_1._tf:Find("ControlLayer")
	arg0_1.controller = arg0_1.layer:GetComponent(typeof(SlideController))

	arg0_1:InitDragEvent()
	arg0_1:InitHint()
	arg0_1:Hide()
	arg0_1:bind(var0_0.BIND_DRAG_AREA, function(arg0_2, arg1_2)
		arg1_2.dragArea = arg0_1.layer
	end)
	arg0_1:bind(var0_0.SHOW_OR_HIDE, function(arg0_3, arg1_3)
		if arg1_3 then
			arg0_1:Show()
		else
			arg0_1:Hide()
		end
	end)
end

function var0_0.InitDragEvent(arg0_4)
	arg0_4.controller:AddBeginDragFunc(function(arg0_5, arg1_5)
		setActive(arg0_4.tipTF, false)
		arg0_4.timer:Stop()
		arg0_4:emit(AimIKSystem.ON_BEGIN_DRAG, arg0_5, arg1_5)
	end)
	arg0_4.controller:AddDragFunc(function(arg0_6, arg1_6)
		arg0_4:emit(AimIKSystem.ON_DRAG, arg0_6, arg1_6)
	end)
	arg0_4.controller:AddDragEndFunc(function(arg0_7, arg1_7)
		arg0_4.timer:Start()
		arg0_4:emit(AimIKSystem.ON_END_DRAG, arg0_7, arg1_7)
	end)
end

function var0_0.InitHint(arg0_8)
	arg0_8.time = var0_0.TIP_WAIT_TIME
	arg0_8.timer = Timer.New(function()
		if arg0_8.time <= 0 then
			arg0_8.time = var0_0.TIP_WAIT_TIME

			if isActive(arg0_8.tipTF) == false then
				setActive(arg0_8.tipTF, true)
				arg0_8:FlushHint()
			end
		else
			arg0_8.time = arg0_8.time - 0.1
		end
	end, 0.1, -1)
end

function var0_0.FlushHint(arg0_10)
	local var0_10 = {}

	arg0_10:emit(AimIKSystem.GET_TIP_SHOW_INFO, var0_10)

	local var1_10 = var0_10[1]

	UIItemList.StaticAlign(arg0_10.tipTF, arg0_10.tipTF:GetChild(0), #var1_10, function(arg0_11, arg1_11, arg2_11)
		if arg0_11 ~= UIItemList.EventUpdate then
			return
		end

		arg1_11 = arg1_11 + 1

		setLocalPosition(arg2_11, LuaHelper.ScreenToLocal(arg0_10.tipTF, var1_10[arg1_11].pos, pg.UIMgr.GetInstance().uiCameraComp))
	end)
end

function var0_0.Show(arg0_12)
	var0_0.super.Show(arg0_12)
	arg0_12.timer:Start()
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	arg0_13.timer:Stop()
end

return var0_0
