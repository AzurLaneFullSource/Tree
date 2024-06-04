local var0 = class("MainSilentView", import("view.base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 1
local var6 = 2

function var0.getUIName(arg0)
	return "MainSilentViewUI"
end

function var0.OnLoaded(arg0)
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.animationPlayer = arg0._tf:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
	arg0.timeTxt = arg0:findTF("adapt/en/time"):GetComponent(typeof(Text))
	arg0.timeEnTxt = arg0:findTF("adapt/en"):GetComponent(typeof(Text))
	arg0.batteryTxt = arg0:findTF("adapt/battery/Text"):GetComponent(typeof(Text))
	arg0.electric = {
		arg0:findTF("adapt/battery/kwh/1"),
		arg0:findTF("adapt/battery/kwh/2"),
		arg0:findTF("adapt/battery/kwh/3")
	}
	arg0.dateTxt = arg0:findTF("adapt/date"):GetComponent(typeof(Text))
	arg0.changeBtn = arg0:findTF("change")
	arg0.tips = UIItemList.New(arg0:findTF("tips"), arg0:findTF("tips/tpl"))
	arg0.changeSkinBtn = MainChangeSkinBtn.New(arg0.changeBtn, arg0.event)
	arg0.systemTimeUtil = SystemTimeUtil.New()
	arg0.playedList = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.changeBtn, function()
		arg0:TrackingSwitchShip()

		arg0.changeSkinCount = arg0.changeSkinCount + 1

		arg0.changeSkinBtn:OnClick()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Tracking(var5)
		arg0:Exit()
	end, SFX_PANEL)
	arg0:bind(GAME.ZERO_HOUR_OP_DONE, function()
		arg0:FlushDate()
	end)
	arg0:bind(GAME.REMOVE_LAYERS, function(arg0, arg1)
		arg0:OnRemoveLayer(arg1.context)
	end)
	arg0.changeSkinBtn:Flush()
end

function var0.OnRemoveLayer(arg0, arg1)
	if arg1.mediator == CommissionInfoMediator or arg1.mediator == NotificationMediator then
		arg0:Exit()
	end
end

function var0.Exit(arg0, arg1)
	arg0:TrackingSwitchShip()
	arg0.dftAniEvent:SetEndEvent(nil)
	arg0.dftAniEvent:SetEndEvent(function()
		arg0:emit(NewMainScene.EXIT_SILENT_VIEW)

		if arg1 then
			arg1()
		end
	end)
	arg0.animationPlayer:Play("anim_silentview_out")
end

function var0.Tracking(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = arg0.enterTime
	local var2 = arg0.changeSkinCount
	local var3 = arg1

	TrackConst.TrackingExitSilentView(var1, var0, var3)
end

function var0.TrackingSwitchShip(arg0)
	if not getProxy(PlayerProxy) then
		return
	end

	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 then
		return
	end

	local var1 = var0:GetFlagShip()
	local var2 = var1.skinId

	if isa(var1, VirtualEducateCharShip) then
		var2 = 0
	end

	local var3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4 = var3 - arg0.paintingTime

	TrackConst.TrackingSwitchPainting(var2, var4)

	arg0.paintingTime = var3
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:FlushTips()
	arg0:FlushBattery()
	arg0:FlushTime()
	arg0:FlushDate()
	arg0:AddTimer()

	arg0.changeSkinCount = 0
	arg0.enterTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0.paintingTime = arg0.enterTime
end

function var0.Reset(arg0)
	var0.super.Reset(arg0)

	arg0.exited = false
end

function var0.AddTimer(arg0)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		arg0:FlushTips()
		arg0:FlushBattery()
	end, 30, -1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.FlushTips(arg0)
	local var0 = {}

	arg0:CollectTips(var0)

	local var1 = {}

	arg0.tips:make(function(arg0, arg1, arg2)
		if UIItemList.EventUpdate == arg0 then
			local var0 = var0[arg1 + 1]
			local var1 = GetSpriteFromAtlas("ui/MainUI_atlas", "noti_" .. var0.type)

			arg2:Find("icon"):GetComponent(typeof(Image)).sprite = var1

			setText(arg2:Find("num"), var0.count)
			setText(arg2:Find("Text"), i18n("main_silent_tip_" .. var0.type))
			onButton(arg0, arg2, function()
				arg0:PlayTipOutAnimation(arg2, function()
					arg0:Skip(var0.type)
				end)
			end, SFX_PANEL)
			arg0:InsertAnimation(var1, arg2)
		end
	end)
	arg0.tips:align(#var0)
	seriesAsync(var1, function()
		return
	end)
end

function var0.PlayTipOutAnimation(arg0, arg1, arg2)
	arg0.cg.blocksRaycasts = false

	local var0 = arg1:GetComponent(typeof(Animation))
	local var1 = arg1:GetComponent(typeof(DftAniEvent))

	var1:SetEndEvent(nil)
	var1:SetEndEvent(function()
		arg0.cg.blocksRaycasts = true

		var1:SetEndEvent(nil)
		arg2()
	end)
	var0:Play("anim_silentview_tip_out")
end

function var0.InsertAnimation(arg0, arg1, arg2)
	if table.contains(arg0.playedList, arg2) then
		return
	end

	local var0 = GetOrAddComponent(arg2, typeof(CanvasGroup))

	var0.alpha = 0

	table.insert(arg1, function(arg0)
		if arg0.exited then
			return
		end

		var0.alpha = 1

		arg2:GetComponent(typeof(Animation)):Play("anim_silentview_tip_in")
		onDelayTick(arg0, 0.066)
	end)
	table.insert(arg0.playedList, arg2)
end

function var0.Skip(arg0, arg1)
	arg0:Tracking(var6)
	arg0:Exit(function()
		if arg1 == var1 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1 == var2 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT)
		elseif arg1 == var3 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
		elseif arg1 == var4 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
				warp = NavalAcademyScene.WARP_TO_TACTIC
			})
		end
	end)
end

function var0.CollectTips(arg0, arg1)
	arg0:CollectEventTips(arg1)
	arg0:CollectBuildTips(arg1)
	arg0:CollectTechTips(arg1)
	arg0:CollectStudentTips(arg1)
end

function var0.CollectEventTips(arg0, arg1)
	local var0 = getProxy(EventProxy):countByState(EventInfo.StateFinish)

	if var0 > 0 then
		table.insert(arg1, {
			count = var0,
			type = var1
		})
	end
end

function var0.CollectBuildTips(arg0, arg1)
	local var0 = getProxy(BuildShipProxy):getFinishCount()

	if var0 > 0 then
		table.insert(arg1, {
			count = var0,
			type = var2
		})
	end
end

function var0.CollectTechTips(arg0, arg1)
	local var0 = getProxy(TechnologyProxy):getPlanningTechnologys()
	local var1 = 0

	for iter0, iter1 in pairs(var0) do
		if iter1:isCompleted() then
			var1 = var1 + 1
		end
	end

	if var1 > 0 then
		table.insert(arg1, {
			count = var1,
			type = var3
		})
	end
end

function var0.CollectStudentTips(arg0, arg1)
	local var0 = getProxy(NavalAcademyProxy):RawGetStudentList()
	local var1 = 0

	for iter0, iter1 in pairs(var0) do
		if iter1:IsFinish() then
			var1 = var1 + 1
		end
	end

	if var1 > 0 then
		table.insert(arg1, {
			count = var1,
			type = var4
		})
	end
end

function var0.FlushBattery(arg0)
	local var0 = SystemInfo.batteryLevel

	if var0 < 0 then
		var0 = 1
	end

	local var1 = math.floor(var0 * 100)

	arg0.batteryTxt.text = var1 .. "%"

	local var2 = 1 / #arg0.electric

	for iter0, iter1 in ipairs(arg0.electric) do
		local var3 = var1 < (iter0 - 1) * var2

		setActive(iter1, not var3)
	end
end

function var0.FlushTime(arg0)
	arg0.systemTimeUtil:SetUp(function(arg0, arg1, arg2)
		local var0 = arg0 > 12 and arg0 - 12 or arg0

		if var0 < 10 then
			var0 = "0" .. var0
		end

		arg0.timeTxt.text = var0 .. ":" .. arg1
		arg0.timeEnTxt.text = arg2
	end)
end

local var7 = {
	"MONDAY",
	"TUESDAY",
	"WEDNESDAY",
	"THURSDAY",
	"FRIDAY",
	"SATURDAY",
	"SUNDAY"
}
local var8 = {
	"JAN",
	"FEB",
	"MAR",
	"APR",
	"MAY",
	"JUN",
	"JUL",
	"AUG",
	"SEP",
	"OCT",
	"NOV",
	"DEC"
}

function var0.FlushDate(arg0)
	local var0 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true)
	local var1 = string.split(var0, "/")
	local var2 = var1[1]
	local var3 = tonumber(var1[2])
	local var4 = var1[3]
	local var5 = pg.TimeMgr.GetInstance():GetServerWeek()
	local var6 = {
		var7[var5],
		var8[var3],
		var4,
		var2
	}

	arg0.dateTxt.text = table.concat(var6, " / ")
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	arg0.dftAniEvent:SetEndEvent(nil)
	arg0:RemoveTimer()
	arg0.changeSkinBtn:Dispose()

	arg0.changeSkinBtn = nil

	arg0.systemTimeUtil:Dispose()

	arg0.systemTimeUtil = nil
end

return var0
