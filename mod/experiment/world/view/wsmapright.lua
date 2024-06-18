local var0_0 = class("WSMapRight", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	btnInventory = "userdata",
	btnPort = "userdata",
	btnHelp = "userdata",
	rtTipWord = "userdata",
	btnDetail = "userdata",
	gid = "number",
	btnScan = "userdata",
	toggleSkipPrecombat = "userdata",
	fleet = "table",
	btnInformation = "userdata",
	btnDefeat = "userdata",
	toggleAutoSwitch = "userdata",
	entrance = "table",
	btnTransport = "userdata",
	btnExit = "userdata",
	btnOrder = "userdata",
	tipEventPri = "number",
	world = "table",
	transform = "userdata",
	wsCompass = "table",
	toggleAutoFight = "userdata",
	taskProxy = "table",
	rtCompassPanel = "userdata",
	wsTimer = "table",
	wsPool = "table"
}
var0_0.Listeners = {
	onUpdateFleetBuff = "OnUpdateFleetBuff",
	onClearLog = "OnClearLog",
	onUpdateFleetLocation = "OnUpdateFleetLocation",
	onUpdateInfoBtnTip = "OnUpdateInfoBtnTip",
	onUpdateFleetDefeat = "OnUpdateFleetDefeat",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onAppendLog = "OnAppendLog"
}

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	arg0_2.wsCompass:Dispose()
	arg0_2:RemoveFleetListener(arg0_2.fleet)
	arg0_2:RemoveMapListener()

	if arg0_2.taskProxy then
		arg0_2.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0_2.onUpdateInfoBtnTip)

		arg0_2.taskProxy = nil
	end

	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	arg0_3.rtCompassPanel = var0_3:Find("compass_panel")
	arg0_3.btnOrder = arg0_3.rtCompassPanel:Find("btn_order")
	arg0_3.btnScan = arg0_3.rtCompassPanel:Find("btn_scan")
	arg0_3.btnDefeat = arg0_3.rtCompassPanel:Find("btn_defeat")
	arg0_3.btnDetail = arg0_3.rtCompassPanel:Find("btn_detail")
	arg0_3.toggleSkipPrecombat = var0_3:Find("btn_list/lock_fleet")

	onToggle(arg0_3, arg0_3.toggleSkipPrecombat, function(arg0_4)
		PlayerPrefs.SetInt("world_skip_precombat", arg0_4 and 1 or 0)
	end, SFX_PANEL)

	arg0_3.toggleAutoFight = var0_3:Find("btn_list/auto_fight")
	arg0_3.toggleAutoSwitch = var0_3:Find("btn_list/auto_switch")
	arg0_3.btnInventory = var0_3:Find("btn_list/dock/inventory_button")
	arg0_3.btnInformation = var0_3:Find("btn_list/dock/information_button")
	arg0_3.btnTransport = var0_3:Find("btn_list/dock/transport_button")
	arg0_3.btnHelp = var0_3:Find("btn_list/dock/help_button")
	arg0_3.btnPort = var0_3:Find("btn_list/dock/port_button")

	setActive(arg0_3.btnPort, false)

	arg0_3.btnExit = var0_3:Find("btn_list/dock/exit_button")

	setActive(arg0_3.btnExit, false)

	arg0_3.wsCompass = WSCompass.New()
	arg0_3.wsCompass.tf = arg0_3.rtCompassPanel:Find("ring/compass")
	arg0_3.wsCompass.pool = arg0_3.wsPool

	arg0_3.wsCompass:Setup()

	arg0_3.rtTipWord = var0_3:Find("tip_word")
	arg0_3.taskProxy = nowWorld():GetTaskProxy()

	arg0_3.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0_3.onUpdateInfoBtnTip)
end

function var0_0.Update(arg0_5, arg1_5, arg2_5)
	if arg0_5.entrance ~= arg1_5 or arg0_5.map ~= arg2_5 or arg0_5.gid ~= arg2_5.gid then
		arg0_5:RemoveMapListener()

		arg0_5.entrance = arg1_5
		arg0_5.map = arg2_5
		arg0_5.gid = arg2_5.gid

		arg0_5:AddMapListener()
		arg0_5:OnUpdateSelectedFleet()
		arg0_5:UpdateCompass()
		arg0_5:UpdateBtns()
		arg0_5:OnUpdateEventTips()
	end
end

function var0_0.AddMapListener(arg0_6)
	if arg0_6.map then
		arg0_6.map:AddListener(WorldMap.EventUpdateFIndex, arg0_6.onUpdateSelectedFleet)
	end
end

function var0_0.RemoveMapListener(arg0_7)
	if arg0_7.map then
		arg0_7.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0_7.onUpdateSelectedFleet)
	end
end

function var0_0.AddFleetListener(arg0_8, arg1_8)
	if arg1_8 then
		arg1_8:AddListener(WorldMapFleet.EventUpdateLocation, arg0_8.onUpdateFleetLocation)
		arg1_8:AddListener(WorldMapFleet.EventUpdateBuff, arg0_8.onUpdateFleetBuff)
		arg1_8:AddListener(WorldMapFleet.EventUpdateDefeat, arg0_8.onUpdateFleetDefeat)
	end
end

function var0_0.RemoveFleetListener(arg0_9, arg1_9)
	if arg1_9 then
		arg1_9:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0_9.onUpdateFleetLocation)
		arg1_9:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0_9.onUpdateFleetBuff)
		arg1_9:RemoveListener(WorldMapFleet.EventUpdateDefeat, arg0_9.onUpdateFleetDefeat)
	end
end

function var0_0.OnUpdateSelectedFleet(arg0_10, arg1_10)
	local var0_10 = arg0_10.map:GetFleet()

	if not arg1_10 or arg0_10.fleet ~= var0_10 then
		arg0_10:RemoveFleetListener(arg0_10.fleet)

		arg0_10.fleet = var0_10

		arg0_10:AddFleetListener(arg0_10.fleet)
		arg0_10:UpdateCompassRotation(var0_10)
		arg0_10:OnUpdateFleetLocation()
		arg0_10:OnUpdateFleetBuff()
		arg0_10:OnUpdateFleetDefeat()
	end
end

function var0_0.OnUpdateFleetLocation(arg0_11)
	if not arg0_11.map.active then
		return
	end

	arg0_11:UpdateCompassMarks()
end

function var0_0.OnUpdateFleetBuff(arg0_12)
	setActive(arg0_12.wsCompass.tf, #arg0_12.fleet:GetBuffsByTrap(WorldBuff.TrapCompassInterference) == 0)
end

function var0_0.OnUpdateFleetDefeat(arg0_13)
	setText(arg0_13.btnDefeat:Find("Text"), math.min(arg0_13.fleet:getDefeatCount(), 99))
end

function var0_0.UpdateCompass(arg0_14)
	local var0_14 = arg0_14.map:GetFleet()

	arg0_14:UpdateCompassMarks()
	arg0_14:UpdateCompassRotation(var0_14)
end

function var0_0.UpdateCompossView(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.map

	arg0_15.wsCompass:UpdateByViewer(var0_15, arg1_15, arg2_15)
end

function var0_0.UpdateCompassRotation(arg0_16, arg1_16)
	arg0_16.wsCompass:UpdateCompassRotation(arg1_16)
end

function var0_0.UpdateCompassMarks(arg0_17)
	arg0_17.wsCompass:ClearMarks()
	arg0_17.wsCompass:Update(arg0_17.entrance, arg0_17.map)
end

function var0_0.OnUpdateEventTips(arg0_18)
	local var0_18, var1_18 = arg0_18.map:GetEventTipWord()

	if arg0_18.tipEventPri ~= var1_18 then
		setActive(arg0_18.rtTipWord, false)

		arg0_18.tipEventPri = var1_18
	end

	setActive(arg0_18.rtTipWord, var1_18 > 0)

	if var1_18 > 0 then
		setText(arg0_18.rtTipWord:Find("Text"), var0_18)
	end
end

function var0_0.UpdateBtns(arg0_19)
	local var0_19 = arg0_19.map:GetPort()

	setActive(arg0_19.btnPort, var0_19 and not var0_19:IsTempPort())
	setActive(arg0_19.btnExit, arg0_19.map:canExit())
end

function var0_0.OnUpdateInfoBtnTip(arg0_20)
	local var0_20 = _.any(arg0_20.taskProxy:getTaskVOs(), function(arg0_21)
		return arg0_21:getState() == WorldTask.STATE_FINISHED
	end)

	setActive(arg0_20.btnInformation:Find("tip"), var0_20)
end

function var0_0.OnUpdateHelpBtnTip(arg0_22, arg1_22)
	local var0_22 = nowWorld():GetProgress()

	setActive(arg0_22.btnHelp:Find("imge/tip"), WorldConst.IsWorldHelpNew(var0_22, arg1_22))
end

return var0_0
