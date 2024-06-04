local var0 = class("WSMapRight", import("...BaseEntity"))

var0.Fields = {
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
var0.Listeners = {
	onUpdateFleetBuff = "OnUpdateFleetBuff",
	onClearLog = "OnClearLog",
	onUpdateFleetLocation = "OnUpdateFleetLocation",
	onUpdateInfoBtnTip = "OnUpdateInfoBtnTip",
	onUpdateFleetDefeat = "OnUpdateFleetDefeat",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onAppendLog = "OnAppendLog"
}

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.wsCompass:Dispose()
	arg0:RemoveFleetListener(arg0.fleet)
	arg0:RemoveMapListener()

	if arg0.taskProxy then
		arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateInfoBtnTip)

		arg0.taskProxy = nil
	end

	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtCompassPanel = var0:Find("compass_panel")
	arg0.btnOrder = arg0.rtCompassPanel:Find("btn_order")
	arg0.btnScan = arg0.rtCompassPanel:Find("btn_scan")
	arg0.btnDefeat = arg0.rtCompassPanel:Find("btn_defeat")
	arg0.btnDetail = arg0.rtCompassPanel:Find("btn_detail")
	arg0.toggleSkipPrecombat = var0:Find("btn_list/lock_fleet")

	onToggle(arg0, arg0.toggleSkipPrecombat, function(arg0)
		PlayerPrefs.SetInt("world_skip_precombat", arg0 and 1 or 0)
	end, SFX_PANEL)

	arg0.toggleAutoFight = var0:Find("btn_list/auto_fight")
	arg0.toggleAutoSwitch = var0:Find("btn_list/auto_switch")
	arg0.btnInventory = var0:Find("btn_list/dock/inventory_button")
	arg0.btnInformation = var0:Find("btn_list/dock/information_button")
	arg0.btnTransport = var0:Find("btn_list/dock/transport_button")
	arg0.btnHelp = var0:Find("btn_list/dock/help_button")
	arg0.btnPort = var0:Find("btn_list/dock/port_button")

	setActive(arg0.btnPort, false)

	arg0.btnExit = var0:Find("btn_list/dock/exit_button")

	setActive(arg0.btnExit, false)

	arg0.wsCompass = WSCompass.New()
	arg0.wsCompass.tf = arg0.rtCompassPanel:Find("ring/compass")
	arg0.wsCompass.pool = arg0.wsPool

	arg0.wsCompass:Setup()

	arg0.rtTipWord = var0:Find("tip_word")
	arg0.taskProxy = nowWorld():GetTaskProxy()

	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateInfoBtnTip)
end

function var0.Update(arg0, arg1, arg2)
	if arg0.entrance ~= arg1 or arg0.map ~= arg2 or arg0.gid ~= arg2.gid then
		arg0:RemoveMapListener()

		arg0.entrance = arg1
		arg0.map = arg2
		arg0.gid = arg2.gid

		arg0:AddMapListener()
		arg0:OnUpdateSelectedFleet()
		arg0:UpdateCompass()
		arg0:UpdateBtns()
		arg0:OnUpdateEventTips()
	end
end

function var0.AddMapListener(arg0)
	if arg0.map then
		arg0.map:AddListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
	end
end

function var0.RemoveMapListener(arg0)
	if arg0.map then
		arg0.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
	end
end

function var0.AddFleetListener(arg0, arg1)
	if arg1 then
		arg1:AddListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdateFleetLocation)
		arg1:AddListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBuff)
		arg1:AddListener(WorldMapFleet.EventUpdateDefeat, arg0.onUpdateFleetDefeat)
	end
end

function var0.RemoveFleetListener(arg0, arg1)
	if arg1 then
		arg1:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdateFleetLocation)
		arg1:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBuff)
		arg1:RemoveListener(WorldMapFleet.EventUpdateDefeat, arg0.onUpdateFleetDefeat)
	end
end

function var0.OnUpdateSelectedFleet(arg0, arg1)
	local var0 = arg0.map:GetFleet()

	if not arg1 or arg0.fleet ~= var0 then
		arg0:RemoveFleetListener(arg0.fleet)

		arg0.fleet = var0

		arg0:AddFleetListener(arg0.fleet)
		arg0:UpdateCompassRotation(var0)
		arg0:OnUpdateFleetLocation()
		arg0:OnUpdateFleetBuff()
		arg0:OnUpdateFleetDefeat()
	end
end

function var0.OnUpdateFleetLocation(arg0)
	if not arg0.map.active then
		return
	end

	arg0:UpdateCompassMarks()
end

function var0.OnUpdateFleetBuff(arg0)
	setActive(arg0.wsCompass.tf, #arg0.fleet:GetBuffsByTrap(WorldBuff.TrapCompassInterference) == 0)
end

function var0.OnUpdateFleetDefeat(arg0)
	setText(arg0.btnDefeat:Find("Text"), math.min(arg0.fleet:getDefeatCount(), 99))
end

function var0.UpdateCompass(arg0)
	local var0 = arg0.map:GetFleet()

	arg0:UpdateCompassMarks()
	arg0:UpdateCompassRotation(var0)
end

function var0.UpdateCompossView(arg0, arg1, arg2)
	local var0 = arg0.map

	arg0.wsCompass:UpdateByViewer(var0, arg1, arg2)
end

function var0.UpdateCompassRotation(arg0, arg1)
	arg0.wsCompass:UpdateCompassRotation(arg1)
end

function var0.UpdateCompassMarks(arg0)
	arg0.wsCompass:ClearMarks()
	arg0.wsCompass:Update(arg0.entrance, arg0.map)
end

function var0.OnUpdateEventTips(arg0)
	local var0, var1 = arg0.map:GetEventTipWord()

	if arg0.tipEventPri ~= var1 then
		setActive(arg0.rtTipWord, false)

		arg0.tipEventPri = var1
	end

	setActive(arg0.rtTipWord, var1 > 0)

	if var1 > 0 then
		setText(arg0.rtTipWord:Find("Text"), var0)
	end
end

function var0.UpdateBtns(arg0)
	local var0 = arg0.map:GetPort()

	setActive(arg0.btnPort, var0 and not var0:IsTempPort())
	setActive(arg0.btnExit, arg0.map:canExit())
end

function var0.OnUpdateInfoBtnTip(arg0)
	local var0 = _.any(arg0.taskProxy:getTaskVOs(), function(arg0)
		return arg0:getState() == WorldTask.STATE_FINISHED
	end)

	setActive(arg0.btnInformation:Find("tip"), var0)
end

function var0.OnUpdateHelpBtnTip(arg0, arg1)
	local var0 = nowWorld():GetProgress()

	setActive(arg0.btnHelp:Find("imge/tip"), WorldConst.IsWorldHelpNew(var0, arg1))
end

return var0
