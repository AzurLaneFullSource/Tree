local var0 = class("SVOrderPanel", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SVOrderPanel"
end

function var0.getBGM(arg0)
	return "echo-loop"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	local var0 = arg0._tf
	local var1 = var0:Find("adapt/order_list")

	arg0.btnRedeploy = var1:Find("redeploy")
	arg0.btnExpansion = var1:Find("expansion")
	arg0.btnMaintenance = var1:Find("maintenance")
	arg0.btnFOV = var1:Find("fov")
	arg0.btnSubmarine = var1:Find("submarine")
	arg0.btnHelp = var0:Find("adapt/help")

	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("world_instruction_help_1")
		})
	end, SFX_PANEL)

	arg0.btnBack = var0:Find("adapt/back")

	onButton(arg0, arg0.btnBack, function()
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.rtRing = var0:Find("bg/ring")
	arg0.wsCompass = WSCompass.New()
	arg0.wsCompass.tf = var0:Find("bg/ring/compass")
	arg0.wsCompass.pool = arg0.contextData.wsPool

	arg0.wsCompass:Setup(true)

	arg0.rtMsgbox = var0:Find("Msgbox")

	setText(arg0.rtMsgbox:Find("window/top/bg/infomation/title"), i18n("title_info"))
	setActive(arg0.rtMsgbox, false)
	onButton(arg0, arg0.rtMsgbox:Find("bg"), function()
		arg0:HideMsgbox()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtMsgbox:Find("window/top/btnBack"), function()
		arg0:HideMsgbox()
	end, SFX_CANCEL)

	arg0.rtMsgStamina = arg0.rtMsgbox:Find("window/top/bg/stamina")

	setText(arg0.rtMsgStamina:Find("name"), i18n("world_ap"))

	arg0.rtMsgBase = arg0.rtMsgbox:Find("window/msg_panel/base")
	arg0.rtMsgExtra = arg0.rtMsgbox:Find("window/msg_panel/extra")
	arg0.rtMsgBtns = arg0.rtMsgbox:Find("window/button_container")

	setText(arg0.rtMsgBtns:Find("btn_setting/pic"), i18n("msgbox_text_save"))
	setText(arg0.rtMsgBtns:Find("btn_confirm/pic"), i18n("text_confirm"))
	setText(arg0.rtMsgBtns:Find("btn_cancel/pic"), i18n("text_cancel"))
	onButton(arg0, arg0.rtMsgBtns:Find("btn_cancel"), function()
		arg0:HideMsgbox()
	end, SFX_CANCEL)
end

function var0.OnDestroy(arg0)
	arg0:ClearBtnTimers()
	arg0.wsCompass:Dispose()
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false)
	var0.super.Show(arg0)
end

function var0.Hide(arg0)
	if isActive(arg0.rtMsgbox) then
		arg0:HideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	arg0:ClearComppass()
	arg0:ClearBtnTimers()
	var0.super.Hide(arg0)
end

function var0.Setup(arg0, arg1, arg2, arg3)
	arg0:Update(arg1, arg2)
	arg0.wsCompass:SetAnchorEulerAngles(arg3)
end

function var0.Update(arg0, arg1, arg2)
	if arg0.entrance ~= arg1 or arg0.map ~= arg2 or arg0.gid ~= arg2.gid then
		arg0.entrance = arg1
		arg0.map = arg2
		arg0.gid = arg2.gid
	end

	arg0:UpdateCompassMarks()
	arg0:UpdateOrderBtn()
end

function var0.SetButton(arg0, arg1, arg2)
	local var0 = arg1:Find("type_lock")
	local var1 = arg1:Find("type_unable")
	local var2 = arg1:Find("type_enable")
	local var3 = nowWorld():IsSystemOpen(arg2.system)

	setActive(var0, not var3)
	setActive(var1, not isActive(var0) and (arg2.isLock or arg2.timeStamp and arg2.timeStamp > pg.TimeMgr.GetInstance():GetServerTime()))
	setActive(var2, not isActive(var0) and not isActive(var1))

	if isActive(var0) then
		onButton(arg0, var0, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_all_1"))
		end, SFX_CONFIRM)
	end

	if isActive(var1) then
		setActive(var1:Find("cost"), arg2.isLock)
		setActive(var1:Find("time"), not arg2.isLock)

		if arg2.isLock then
			setText(var1:Find("cost/Text"), arg2.cost)
			onButton(arg0, var1, arg2.lockFunc, SFX_CONFIRM)
		else
			arg0.timers[var1] = Timer.New(function()
				local var0 = arg2.timeStamp - pg.TimeMgr.GetInstance():GetServerTime()

				if var0 < 0 then
					arg0:UpdateOrderBtn()
				else
					setText(var1:Find("time/Text"), string.format("%d:%02d:%02d", math.floor(var0 / 3600), math.floor(var0 % 3600 / 60), var0 % 60))
				end
			end, 1, -1)

			arg0.timers[var1].func()
			arg0.timers[var1]:Start()
			onButton(arg0, var1, arg2.timeFunc, SFX_CONFIRM)
		end
	end

	if isActive(var2) then
		setText(var2:Find("cost/Text"), arg2.cost)
		onButton(arg0, var2, arg2.enableFunc, SFX_CONFIRM)
	end
end

function var0.UpdateOrderBtn(arg0)
	arg0:ClearBtnTimers()

	arg0.timers = {}

	local var0 = nowWorld()
	local var1 = arg0.map:GetConfig("instruction_available")
	local var2 = checkExist(arg0.map, {
		"GetPort"
	})
	local var3 = var0:GetRealm()
	local var4 = var0:IsSystemOpen(WorldConst.SystemOrderRedeploy) and var3 == checkExist(var2, {
		"GetRealm"
	}) and checkExist(var2, {
		"IsOpen",
		{
			var3,
			var0:GetProgress()
		}
	}) and var0:BuildFormationIds()
	local var5 = {
		system = WorldConst.SystemOrderRedeploy,
		isLock = not var4,
		lockFunc = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))
		end,
		cost = var0:CalcOrderCost(WorldConst.OpReqRedeploy),
		enableFunc = function(arg0, arg1)
			arg0:Hide()
			arg0:emit(WorldScene.SceneOp, "OpRedeploy")
		end
	}

	arg0:SetButton(arg0.btnRedeploy, var5)
	arg0:SetButton(arg0.btnExpansion, var5)
	setActive(arg0.btnRedeploy, var4 ~= WorldConst.FleetExpansion)
	setActive(arg0.btnExpansion, var4 == WorldConst.FleetExpansion)
	arg0:SetButton(arg0.btnSubmarine, {
		system = WorldConst.SystemOrderSubmarine,
		isLock = var1[1] == 0 or not var0:CanCallSubmarineSupport() or var0:IsSubmarineSupporting() and var0:GetSubAidFlag(),
		lockFunc = function()
			if var1[1] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			elseif not var0:CanCallSubmarineSupport() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_4"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_3"))
			end
		end,
		cost = var0:CalcOrderCost(WorldConst.OpReqSub),
		enableFunc = function()
			arg0:ShowMsgbox(WorldConst.OpReqSub)
		end
	})
	arg0:SetButton(arg0.btnFOV, {
		system = WorldConst.SystemOrderFOV,
		isLock = var1[2] == 0 or arg0.map.visionFlag,
		lockFunc = function()
			if var1[2] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_detect_2"))
			end
		end,
		cost = var0:CalcOrderCost(WorldConst.OpReqVision),
		enableFunc = function()
			arg0:ShowMsgbox(WorldConst.OpReqVision)
		end
	})

	local var6 = pg.TimeMgr.GetInstance()
	local var7 = pg.gameset.world_instruction_maintenance.description[2]
	local var8 = var0:GetReqCDTime(WorldConst.OpReqMaintenance) + var7

	arg0:SetButton(arg0.btnMaintenance, {
		system = WorldConst.SystemOrderMaintenance,
		isLock = var1[3] == 0,
		lockFunc = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
		end,
		timeStamp = var8,
		timeFunc = function(arg0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_supply_2", var6:DescCDTime(var8 - pg.TimeMgr.GetInstance():GetServerTime())))
		end,
		cost = var0:CalcOrderCost(WorldConst.OpReqMaintenance),
		enableFunc = function()
			arg0:ShowMsgbox(WorldConst.OpReqMaintenance)
		end
	})
end

function var0.ClearBtnTimers(arg0)
	if arg0.timers then
		for iter0, iter1 in pairs(arg0.timers) do
			iter1:Stop()
		end
	end

	arg0.timers = nil
end

function var0.UpdateCompassMarks(arg0)
	arg0.wsCompass:ClearMarks()
	arg0.wsCompass:Update(arg0.entrance, arg0.map)
end

function var0.ClearComppass(arg0)
	arg0.wsCompass.map = nil

	arg0.wsCompass:RemoveCellsListener()
end

function var0.ShowMsgbox(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0.staminaMgr:GetTotalStamina()

	setText(arg0.rtMsgStamina:Find("Text"), var1)

	local var2 = var0:CalcOrderCost(arg1)
	local var3 = ""
	local var4 = ""
	local var5

	if arg1 == WorldConst.OpReqMaintenance then
		var3 = i18n("world_instruction_morale_1", setColorStr(var2, COLOR_GREEN), setColorStr(var1, var2 <= var1 and COLOR_GREEN or COLOR_RED))
		var4 = i18n("world_instruction_morale_4")

		function var5()
			arg0:emit(WorldScene.SceneOp, "OpReqMaintenance", arg0.map:GetFleet().id)
		end
	elseif arg1 == WorldConst.OpReqSub then
		var3 = i18n(var0:IsSubmarineSupporting() and "world_instruction_submarine_7" or "world_instruction_submarine_2", setColorStr(var2, COLOR_GREEN), setColorStr(var1, var2 <= var1 and COLOR_GREEN or COLOR_RED))
		var4 = i18n("world_instruction_submarine_8")

		function var5()
			arg0:emit(WorldScene.SceneOp, "OpReqSub")
		end
	elseif arg1 == WorldConst.OpReqVision then
		var3 = i18n("world_instruction_detect_1", setColorStr(var2, COLOR_GREEN), setColorStr(var1, var2 <= var1 and COLOR_GREEN or COLOR_RED))
		var4 = i18n("world_instruction_submarine_8")

		function var5()
			arg0:emit(WorldScene.SceneOp, "OpReqVision")
		end
	else
		assert(false, "req error")
	end

	setText(arg0.rtMsgBase:Find("content"), var3)
	setText(arg0.rtMsgBase:Find("other"), var4)
	onButton(arg0, arg0.rtMsgBtns:Find("btn_confirm"), function()
		arg0:Hide()

		if var0.staminaMgr:GetTotalStamina() < var2 then
			var0.staminaMgr:Show()
		else
			var5()
		end
	end, SFX_CONFIRM)
	setActive(arg0.rtMsgExtra, arg1 == WorldConst.OpReqSub)

	if arg1 == WorldConst.OpReqSub then
		setText(arg0.rtMsgExtra:Find("content/text_1"), i18n("world_instruction_submarine_9"))

		local var6 = arg0.rtMsgExtra:Find("content/toggle_area/toggle")
		local var7 = PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1

		triggerToggle(var6, var7)
		onToggle(arg0, var6, function(arg0)
			var7 = arg0

			arg0:DisplayAutoSetting(true)
		end, SFX_PANEL)

		local var8 = pg.gameset.world_instruction_submarine.description[1]
		local var9 = math.clamp(PlayerPrefs.GetInt("world_sub_call_line", 0), 0, var8)
		local var10 = arg0.rtMsgExtra:Find("content/counter")

		setText(var10:Find("number/Text"), var9)
		pressPersistTrigger(var10:Find("minus"), 0.5, function(arg0)
			if var9 == 0 then
				arg0()

				return
			end

			var9 = math.clamp(var9 - 1, 0, var8)

			setText(var10:Find("number/Text"), var9)
			arg0:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		pressPersistTrigger(var10:Find("plus"), 0.5, function(arg0)
			if var9 == var8 then
				arg0()

				return
			end

			var9 = math.clamp(var9 + 1, 0, var8)

			setText(var10:Find("number/Text"), var9)
			arg0:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		onButton(arg0, arg0.rtMsgBtns:Find("btn_setting"), function()
			isSetting = false

			PlayerPrefs.SetInt("world_sub_auto_call", var7 and 1 or 0)
			PlayerPrefs.SetInt("world_sub_call_line", var9)
			arg0:DisplayAutoSetting(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_11"))
		end, SFX_PANEL)
	end

	arg0:DisplayAutoSetting(false)
	setActive(arg0.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtMsgbox)
end

function var0.HideMsgbox(arg0)
	setActive(arg0.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtMsgbox, arg0._tf)
end

function var0.DisplayAutoSetting(arg0, arg1)
	setActive(arg0.rtMsgBtns:Find("btn_confirm"), not arg1)
	setActive(arg0.rtMsgBtns:Find("btn_setting"), arg1)
end

return var0
