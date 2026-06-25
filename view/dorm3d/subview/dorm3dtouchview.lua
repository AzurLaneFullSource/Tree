local var0_0 = class("Dorm3dTouchView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1.rtIKUI = arg0_1._tf:Find("UI/ik")
	arg0_1.rtTouchGamePanel = arg0_1._tf:Find("ExtraScreen/TouchGame")

	setActive(arg0_1.rtIKUI:Find("btn_back_heartbeat"), false)
	setActive(arg0_1.rtTouchGamePanel, false)
	onButton(arg0_1, arg0_1.rtIKUI:Find("btn_back"), function()
		local var0_2 = {}

		arg0_1:emit(RoomIKSystem.CONSUME_IK_SPECIAL_CALL, var0_2)

		if not var0_2.consumed then
			arg0_1:emit(RoomTouchSystem.EXIT_TOUCH_MODE)
		end
	end, SFX_DORM_BACK)
	onButton(arg0_1, arg0_1.rtIKUI:Find("btn_back_heartbeat"), function()
		arg0_1:emit(RoomTouchSystem.EXIT_HEARTBEAT_MODE)
	end, SFX_DORM_BACK)
	arg0_1:bind(RoomTouchSystem.UPDATE_TOUCH_PANEL, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:UpdateTouchPanel(arg1_4, arg2_4, arg3_4)
	end)
	arg0_1:bind(RoomTouchSystem.UPDATE_TOUCH_COUNT, function(arg0_5, arg1_5)
		arg0_1:UpdateTouchCount(arg1_5)
	end)
	arg0_1:bind(RoomTouchSystem.UPDATE_TOUCH_LEVEL, function(arg0_6, arg1_6)
		arg0_1:UpdateTouchLevel(arg1_6)
	end)
	arg0_1:bind(RoomTouchSystem.UPDATE_TOUCH_DISPLAY, function(arg0_7, arg1_7, arg2_7)
		arg0_1:UpdateTouchLevel(arg1_7)
		arg0_1:UpdateTouchCount(arg2_7)
	end)
end

function var0_0.UpdateTouchPanel(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg1_8 then
		setActive(arg0_8.rtTouchGamePanel, true)
		quickPlayAnimation(arg0_8.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_8.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
		existCall(arg3_8)
	elseif arg2_8 then
		quickPlayAnimation(arg0_8.rtTouchGamePanel, "anim_dorm3d_touch_out")
		onDelayTick(function()
			setActive(arg0_8.rtTouchGamePanel, false)
			existCall(arg3_8)
		end, 0.5)
	else
		setActive(arg0_8.rtTouchGamePanel, false)
		existCall(arg3_8)
	end
end

function var0_0.UpdateTouchLevel(arg0_10, arg1_10)
	arg0_10.touchLevel = arg1_10

	setActive(arg0_10.rtTouchGamePanel:Find("effect_bg"), arg1_10 == 2)
	setActive(arg0_10.rtTouchGamePanel:Find("slider/icon/beating"), arg1_10 == 2)

	if arg1_10 == 1 then
		setActive(arg0_10.rtIKUI:Find("btn_back"), true)
		setActive(arg0_10.rtIKUI:Find("btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_10.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_10.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg1_10 == 2 then
		setActive(arg0_10.rtIKUI:Find("btn_back"), false)
		setActive(arg0_10.rtIKUI:Find("btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_10.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_10.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_11, arg1_11)
	local var0_11 = arg1_11

	if arg0_11.touchLevel and arg0_11.touchLevel > 1 then
		var0_11 = arg1_11 >= 200 and 100 or arg1_11 % 100
	end

	setSlider(arg0_11.rtTouchGamePanel:Find("slider"), 0, 100, var0_11)
end

return var0_0
