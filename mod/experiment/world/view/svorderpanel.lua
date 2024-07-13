local var0_0 = class("SVOrderPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SVOrderPanel"
end

function var0_0.getBGM(arg0_2)
	return "echo-loop"
end

function var0_0.OnLoaded(arg0_3)
	return
end

function var0_0.OnInit(arg0_4)
	local var0_4 = arg0_4._tf
	local var1_4 = var0_4:Find("adapt/order_list")

	arg0_4.btnRedeploy = var1_4:Find("redeploy")
	arg0_4.btnExpansion = var1_4:Find("expansion")
	arg0_4.btnMaintenance = var1_4:Find("maintenance")
	arg0_4.btnFOV = var1_4:Find("fov")
	arg0_4.btnSubmarine = var1_4:Find("submarine")
	arg0_4.btnHelp = var0_4:Find("adapt/help")

	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("world_instruction_help_1")
		})
	end, SFX_PANEL)

	arg0_4.btnBack = var0_4:Find("adapt/back")

	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:Hide()
	end, SFX_CANCEL)

	arg0_4.rtRing = var0_4:Find("bg/ring")
	arg0_4.wsCompass = WSCompass.New()
	arg0_4.wsCompass.tf = var0_4:Find("bg/ring/compass")
	arg0_4.wsCompass.pool = arg0_4.contextData.wsPool

	arg0_4.wsCompass:Setup(true)

	arg0_4.rtMsgbox = var0_4:Find("Msgbox")

	setText(arg0_4.rtMsgbox:Find("window/top/bg/infomation/title"), i18n("title_info"))
	setActive(arg0_4.rtMsgbox, false)
	onButton(arg0_4, arg0_4.rtMsgbox:Find("bg"), function()
		arg0_4:HideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.rtMsgbox:Find("window/top/btnBack"), function()
		arg0_4:HideMsgbox()
	end, SFX_CANCEL)

	arg0_4.rtMsgStamina = arg0_4.rtMsgbox:Find("window/top/bg/stamina")

	setText(arg0_4.rtMsgStamina:Find("name"), i18n("world_ap"))

	arg0_4.rtMsgBase = arg0_4.rtMsgbox:Find("window/msg_panel/base")
	arg0_4.rtMsgExtra = arg0_4.rtMsgbox:Find("window/msg_panel/extra")
	arg0_4.rtMsgBtns = arg0_4.rtMsgbox:Find("window/button_container")

	setText(arg0_4.rtMsgBtns:Find("btn_setting/pic"), i18n("msgbox_text_save"))
	setText(arg0_4.rtMsgBtns:Find("btn_confirm/pic"), i18n("text_confirm"))
	setText(arg0_4.rtMsgBtns:Find("btn_cancel/pic"), i18n("text_cancel"))
	onButton(arg0_4, arg0_4.rtMsgBtns:Find("btn_cancel"), function()
		arg0_4:HideMsgbox()
	end, SFX_CANCEL)
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:ClearBtnTimers()
	arg0_10.wsCompass:Dispose()
end

function var0_0.Show(arg0_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, false)
	var0_0.super.Show(arg0_11)
end

function var0_0.Hide(arg0_12)
	if isActive(arg0_12.rtMsgbox) then
		arg0_12:HideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)
	arg0_12:ClearComppass()
	arg0_12:ClearBtnTimers()
	var0_0.super.Hide(arg0_12)
end

function var0_0.Setup(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13:Update(arg1_13, arg2_13)
	arg0_13.wsCompass:SetAnchorEulerAngles(arg3_13)
end

function var0_0.Update(arg0_14, arg1_14, arg2_14)
	if arg0_14.entrance ~= arg1_14 or arg0_14.map ~= arg2_14 or arg0_14.gid ~= arg2_14.gid then
		arg0_14.entrance = arg1_14
		arg0_14.map = arg2_14
		arg0_14.gid = arg2_14.gid
	end

	arg0_14:UpdateCompassMarks()
	arg0_14:UpdateOrderBtn()
end

function var0_0.SetButton(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15:Find("type_lock")
	local var1_15 = arg1_15:Find("type_unable")
	local var2_15 = arg1_15:Find("type_enable")
	local var3_15 = nowWorld():IsSystemOpen(arg2_15.system)

	setActive(var0_15, not var3_15)
	setActive(var1_15, not isActive(var0_15) and (arg2_15.isLock or arg2_15.timeStamp and arg2_15.timeStamp > pg.TimeMgr.GetInstance():GetServerTime()))
	setActive(var2_15, not isActive(var0_15) and not isActive(var1_15))

	if isActive(var0_15) then
		onButton(arg0_15, var0_15, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_all_1"))
		end, SFX_CONFIRM)
	end

	if isActive(var1_15) then
		setActive(var1_15:Find("cost"), arg2_15.isLock)
		setActive(var1_15:Find("time"), not arg2_15.isLock)

		if arg2_15.isLock then
			setText(var1_15:Find("cost/Text"), arg2_15.cost)
			onButton(arg0_15, var1_15, arg2_15.lockFunc, SFX_CONFIRM)
		else
			arg0_15.timers[var1_15] = Timer.New(function()
				local var0_17 = arg2_15.timeStamp - pg.TimeMgr.GetInstance():GetServerTime()

				if var0_17 < 0 then
					arg0_15:UpdateOrderBtn()
				else
					setText(var1_15:Find("time/Text"), string.format("%d:%02d:%02d", math.floor(var0_17 / 3600), math.floor(var0_17 % 3600 / 60), var0_17 % 60))
				end
			end, 1, -1)

			arg0_15.timers[var1_15].func()
			arg0_15.timers[var1_15]:Start()
			onButton(arg0_15, var1_15, arg2_15.timeFunc, SFX_CONFIRM)
		end
	end

	if isActive(var2_15) then
		setText(var2_15:Find("cost/Text"), arg2_15.cost)
		onButton(arg0_15, var2_15, arg2_15.enableFunc, SFX_CONFIRM)
	end
end

function var0_0.UpdateOrderBtn(arg0_18)
	arg0_18:ClearBtnTimers()

	arg0_18.timers = {}

	local var0_18 = nowWorld()
	local var1_18 = arg0_18.map:GetConfig("instruction_available")
	local var2_18 = checkExist(arg0_18.map, {
		"GetPort"
	})
	local var3_18 = var0_18:GetRealm()
	local var4_18 = var0_18:IsSystemOpen(WorldConst.SystemOrderRedeploy) and var3_18 == checkExist(var2_18, {
		"GetRealm"
	}) and checkExist(var2_18, {
		"IsOpen",
		{
			var3_18,
			var0_18:GetProgress()
		}
	}) and var0_18:BuildFormationIds()
	local var5_18 = {
		system = WorldConst.SystemOrderRedeploy,
		isLock = not var4_18,
		lockFunc = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))
		end,
		cost = var0_18:CalcOrderCost(WorldConst.OpReqRedeploy),
		enableFunc = function(arg0_20, arg1_20)
			arg0_18:Hide()
			arg0_18:emit(WorldScene.SceneOp, "OpRedeploy")
		end
	}

	arg0_18:SetButton(arg0_18.btnRedeploy, var5_18)
	arg0_18:SetButton(arg0_18.btnExpansion, var5_18)
	setActive(arg0_18.btnRedeploy, var4_18 ~= WorldConst.FleetExpansion)
	setActive(arg0_18.btnExpansion, var4_18 == WorldConst.FleetExpansion)
	arg0_18:SetButton(arg0_18.btnSubmarine, {
		system = WorldConst.SystemOrderSubmarine,
		isLock = var1_18[1] == 0 or not var0_18:CanCallSubmarineSupport() or var0_18:IsSubmarineSupporting() and var0_18:GetSubAidFlag(),
		lockFunc = function()
			if var1_18[1] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			elseif not var0_18:CanCallSubmarineSupport() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_4"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_3"))
			end
		end,
		cost = var0_18:CalcOrderCost(WorldConst.OpReqSub),
		enableFunc = function()
			arg0_18:ShowMsgbox(WorldConst.OpReqSub)
		end
	})
	arg0_18:SetButton(arg0_18.btnFOV, {
		system = WorldConst.SystemOrderFOV,
		isLock = var1_18[2] == 0 or arg0_18.map.visionFlag,
		lockFunc = function()
			if var1_18[2] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_detect_2"))
			end
		end,
		cost = var0_18:CalcOrderCost(WorldConst.OpReqVision),
		enableFunc = function()
			arg0_18:ShowMsgbox(WorldConst.OpReqVision)
		end
	})

	local var6_18 = pg.TimeMgr.GetInstance()
	local var7_18 = pg.gameset.world_instruction_maintenance.description[2]
	local var8_18 = var0_18:GetReqCDTime(WorldConst.OpReqMaintenance) + var7_18

	arg0_18:SetButton(arg0_18.btnMaintenance, {
		system = WorldConst.SystemOrderMaintenance,
		isLock = var1_18[3] == 0,
		lockFunc = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
		end,
		timeStamp = var8_18,
		timeFunc = function(arg0_26)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_supply_2", var6_18:DescCDTime(var8_18 - pg.TimeMgr.GetInstance():GetServerTime())))
		end,
		cost = var0_18:CalcOrderCost(WorldConst.OpReqMaintenance),
		enableFunc = function()
			arg0_18:ShowMsgbox(WorldConst.OpReqMaintenance)
		end
	})
end

function var0_0.ClearBtnTimers(arg0_28)
	if arg0_28.timers then
		for iter0_28, iter1_28 in pairs(arg0_28.timers) do
			iter1_28:Stop()
		end
	end

	arg0_28.timers = nil
end

function var0_0.UpdateCompassMarks(arg0_29)
	arg0_29.wsCompass:ClearMarks()
	arg0_29.wsCompass:Update(arg0_29.entrance, arg0_29.map)
end

function var0_0.ClearComppass(arg0_30)
	arg0_30.wsCompass.map = nil

	arg0_30.wsCompass:RemoveCellsListener()
end

function var0_0.ShowMsgbox(arg0_31, arg1_31)
	local var0_31 = nowWorld()
	local var1_31 = var0_31.staminaMgr:GetTotalStamina()

	setText(arg0_31.rtMsgStamina:Find("Text"), var1_31)

	local var2_31 = var0_31:CalcOrderCost(arg1_31)
	local var3_31 = ""
	local var4_31 = ""
	local var5_31

	if arg1_31 == WorldConst.OpReqMaintenance then
		var3_31 = i18n("world_instruction_morale_1", setColorStr(var2_31, COLOR_GREEN), setColorStr(var1_31, var2_31 <= var1_31 and COLOR_GREEN or COLOR_RED))
		var4_31 = i18n("world_instruction_morale_4")

		function var5_31()
			arg0_31:emit(WorldScene.SceneOp, "OpReqMaintenance", arg0_31.map:GetFleet().id)
		end
	elseif arg1_31 == WorldConst.OpReqSub then
		var3_31 = i18n(var0_31:IsSubmarineSupporting() and "world_instruction_submarine_7" or "world_instruction_submarine_2", setColorStr(var2_31, COLOR_GREEN), setColorStr(var1_31, var2_31 <= var1_31 and COLOR_GREEN or COLOR_RED))
		var4_31 = i18n("world_instruction_submarine_8")

		function var5_31()
			arg0_31:emit(WorldScene.SceneOp, "OpReqSub")
		end
	elseif arg1_31 == WorldConst.OpReqVision then
		var3_31 = i18n("world_instruction_detect_1", setColorStr(var2_31, COLOR_GREEN), setColorStr(var1_31, var2_31 <= var1_31 and COLOR_GREEN or COLOR_RED))
		var4_31 = i18n("world_instruction_submarine_8")

		function var5_31()
			arg0_31:emit(WorldScene.SceneOp, "OpReqVision")
		end
	else
		assert(false, "req error")
	end

	setText(arg0_31.rtMsgBase:Find("content"), var3_31)
	setText(arg0_31.rtMsgBase:Find("other"), var4_31)
	onButton(arg0_31, arg0_31.rtMsgBtns:Find("btn_confirm"), function()
		arg0_31:Hide()

		if var0_31.staminaMgr:GetTotalStamina() < var2_31 then
			var0_31.staminaMgr:Show()
		else
			var5_31()
		end
	end, SFX_CONFIRM)
	setActive(arg0_31.rtMsgExtra, arg1_31 == WorldConst.OpReqSub)

	if arg1_31 == WorldConst.OpReqSub then
		setText(arg0_31.rtMsgExtra:Find("content/text_1"), i18n("world_instruction_submarine_9"))

		local var6_31 = arg0_31.rtMsgExtra:Find("content/toggle_area/toggle")
		local var7_31 = PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1

		triggerToggle(var6_31, var7_31)
		onToggle(arg0_31, var6_31, function(arg0_36)
			var7_31 = arg0_36

			arg0_31:DisplayAutoSetting(true)
		end, SFX_PANEL)

		local var8_31 = pg.gameset.world_instruction_submarine.description[1]
		local var9_31 = math.clamp(PlayerPrefs.GetInt("world_sub_call_line", 0), 0, var8_31)
		local var10_31 = arg0_31.rtMsgExtra:Find("content/counter")

		setText(var10_31:Find("number/Text"), var9_31)
		pressPersistTrigger(var10_31:Find("minus"), 0.5, function(arg0_37)
			if var9_31 == 0 then
				arg0_37()

				return
			end

			var9_31 = math.clamp(var9_31 - 1, 0, var8_31)

			setText(var10_31:Find("number/Text"), var9_31)
			arg0_31:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		pressPersistTrigger(var10_31:Find("plus"), 0.5, function(arg0_38)
			if var9_31 == var8_31 then
				arg0_38()

				return
			end

			var9_31 = math.clamp(var9_31 + 1, 0, var8_31)

			setText(var10_31:Find("number/Text"), var9_31)
			arg0_31:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		onButton(arg0_31, arg0_31.rtMsgBtns:Find("btn_setting"), function()
			isSetting = false

			PlayerPrefs.SetInt("world_sub_auto_call", var7_31 and 1 or 0)
			PlayerPrefs.SetInt("world_sub_call_line", var9_31)
			arg0_31:DisplayAutoSetting(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_11"))
		end, SFX_PANEL)
	end

	arg0_31:DisplayAutoSetting(false)
	setActive(arg0_31.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_31.rtMsgbox)
end

function var0_0.HideMsgbox(arg0_40)
	setActive(arg0_40.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_40.rtMsgbox, arg0_40._tf)
end

function var0_0.DisplayAutoSetting(arg0_41, arg1_41)
	setActive(arg0_41.rtMsgBtns:Find("btn_confirm"), not arg1_41)
	setActive(arg0_41.rtMsgBtns:Find("btn_setting"), arg1_41)
end

return var0_0
