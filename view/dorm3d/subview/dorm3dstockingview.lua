local var0_0 = class("Dorm3dStockingView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.TIP_WAIT_TIME = 5

function var0_0.Init(arg0_1)
	arg0_1.controlTF = arg0_1._tf:Find("StockingControl")
	arg0_1.uiTF = arg0_1._tf:Find("UI/stocking")
	arg0_1.tipTF = arg0_1.controlTF:Find("Tips")
	arg0_1.clickTF = arg0_1.controlTF:Find("ClickTips")

	onButton(arg0_1, arg0_1.uiTF:Find("btn_back"), function()
		arg0_1:emit(Dorm3dRoomTemplateScene.STOCKING_EVENT, "ExitStockingStatus")
	end, SFX_CANCEL)
	arg0_1:InitDragEvent()
	arg0_1:InitHint()
	arg0_1:Hide()
end

function var0_0.InitDragEvent(arg0_3)
	local var0_3 = arg0_3.controlTF:Find("ControlLayer"):GetComponent(typeof(SlideController))

	var0_3:AddBeginDragFunc(function(arg0_4, arg1_4)
		setActive(arg0_3.tipTF, false)
		arg0_3.timer:Stop()
		arg0_3:emit(Dorm3dRoomTemplateScene.STOCKING_EVENT, "OnBeginDrag", arg0_4, arg1_4)
	end)
	var0_3:AddDragFunc(function(arg0_5, arg1_5)
		arg0_3:emit(Dorm3dRoomTemplateScene.STOCKING_EVENT, "OnDrag", arg0_5, arg1_5)
	end)
	var0_3:AddDragEndFunc(function(arg0_6, arg1_6)
		arg0_3.timer:Start()
		arg0_3:emit(Dorm3dRoomTemplateScene.STOCKING_EVENT, "OnEndDrag", arg0_6, arg1_6)
	end)
end

function var0_0.InitHint(arg0_7)
	arg0_7.time = var0_0.TIP_WAIT_TIME
	arg0_7.timer = Timer.New(function()
		if arg0_7.time <= 0 then
			arg0_7.time = var0_0.TIP_WAIT_TIME

			setActive(arg0_7.tipTF, false)
			setActive(arg0_7.clickTF, false)
		else
			arg0_7.time = arg0_7.time - 0.1

			if isActive(arg0_7.tipTF) == false then
				setActive(arg0_7.tipTF, true)
				setActive(arg0_7.clickTF, true)
				arg0_7:FlushHint()
			end
		end
	end, 0.1, -1)
end

function var0_0.FlushHint(arg0_9)
	local var0_9, var1_9 = arg0_9.contextData.GetTipShowInfo()

	UIItemList.StaticAlign(arg0_9.tipTF, arg0_9.tipTF:GetChild(0), #var0_9, function(arg0_10, arg1_10, arg2_10)
		if arg0_10 ~= UIItemList.EventUpdate then
			return
		end

		arg1_10 = arg1_10 + 1

		setLocalPosition(arg2_10, LuaHelper.ScreenToLocal(arg0_9.tipTF, var0_9[arg1_10].pos, pg.UIMgr.GetInstance().uiCameraComp))

		local var0_10 = Mathf.Atan2(var0_9[arg1_10].dir.y, var0_9[arg1_10].dir.x) * Mathf.Rad2Deg

		setLocalRotation(arg2_10, Quaternion.Euler(0, 0, var0_10 - 90))
	end)
	UIItemList.StaticAlign(arg0_9.clickTF, arg0_9.clickTF:GetChild(0), #var1_9, function(arg0_11, arg1_11, arg2_11)
		if arg0_11 ~= UIItemList.EventUpdate then
			return
		end

		arg1_11 = arg1_11 + 1

		setLocalPosition(arg2_11, LuaHelper.ScreenToLocal(arg0_9.clickTF, var1_9[arg1_11].pos, pg.UIMgr.GetInstance().uiCameraComp))
	end)
end

function var0_0.Show(arg0_12)
	setActive(arg0_12.controlTF, true)
	setActive(arg0_12.uiTF, true)
	arg0_12.timer:Start()
end

function var0_0.Hide(arg0_13)
	setActive(arg0_13.controlTF, false)
	setActive(arg0_13.uiTF, false)
	arg0_13.timer:Stop()
end

return var0_0
