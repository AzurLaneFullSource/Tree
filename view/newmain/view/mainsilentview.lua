local var0_0 = class("MainSilentView", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 1
local var6_0 = 2

function var0_0.getUIName(arg0_1)
	return "MainSilentViewUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cg = arg0_2._tf:GetComponent(typeof(CanvasGroup))
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.timeTxt = arg0_2:findTF("adapt/en/time"):GetComponent(typeof(Text))
	arg0_2.timeEnTxt = arg0_2:findTF("adapt/en"):GetComponent(typeof(Text))
	arg0_2.batteryTxt = arg0_2:findTF("adapt/battery/Text"):GetComponent(typeof(Text))
	arg0_2.electric = {
		arg0_2:findTF("adapt/battery/kwh/1"),
		arg0_2:findTF("adapt/battery/kwh/2"),
		arg0_2:findTF("adapt/battery/kwh/3")
	}
	arg0_2.dateTxt = arg0_2:findTF("adapt/date"):GetComponent(typeof(Text))
	arg0_2.changeBtn = arg0_2:findTF("change")
	arg0_2.tips = UIItemList.New(arg0_2:findTF("tips"), arg0_2:findTF("tips/tpl"))
	arg0_2.changeSkinBtn = MainChangeSkinBtn.New(arg0_2.changeBtn, arg0_2.event)
	arg0_2.systemTimeUtil = SystemTimeUtil.New()
	arg0_2.playedList = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.changeBtn, function()
		arg0_3:TrackingSwitchShip()

		arg0_3.changeSkinCount = arg0_3.changeSkinCount + 1

		arg0_3.changeSkinBtn:OnClick()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Tracking(var5_0)
		arg0_3:Exit()
	end, SFX_PANEL)
	arg0_3:bind(GAME.ZERO_HOUR_OP_DONE, function()
		arg0_3:FlushDate()
	end)
	arg0_3:bind(GAME.REMOVE_LAYERS, function(arg0_7, arg1_7)
		arg0_3:OnRemoveLayer(arg1_7.context)
	end)
	arg0_3.changeSkinBtn:Flush()
end

function var0_0.OnRemoveLayer(arg0_8, arg1_8)
	if arg1_8.mediator == CommissionInfoMediator or arg1_8.mediator == NotificationMediator then
		arg0_8:Exit()
	end
end

function var0_0.Exit(arg0_9, arg1_9)
	arg0_9:TrackingSwitchShip()
	arg0_9.dftAniEvent:SetEndEvent(nil)
	arg0_9.dftAniEvent:SetEndEvent(function()
		arg0_9:emit(NewMainScene.EXIT_SILENT_VIEW)

		if arg1_9 then
			arg1_9()
		end
	end)
	arg0_9.animationPlayer:Play("anim_silentview_out")
end

function var0_0.Tracking(arg0_11, arg1_11)
	local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_11 = arg0_11.enterTime
	local var2_11 = arg0_11.changeSkinCount
	local var3_11 = arg1_11

	TrackConst.TrackingExitSilentView(var1_11, var0_11, var3_11)
end

function var0_0.TrackingSwitchShip(arg0_12)
	if not getProxy(PlayerProxy) then
		return
	end

	local var0_12 = getProxy(PlayerProxy):getRawData()

	if not var0_12 then
		return
	end

	local var1_12 = var0_12:GetFlagShip()
	local var2_12 = var1_12.skinId

	if isa(var1_12, VirtualEducateCharShip) then
		var2_12 = 0
	end

	local var3_12 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_12 = var3_12 - arg0_12.paintingTime

	TrackConst.TrackingSwitchPainting(var2_12, var4_12)

	arg0_12.paintingTime = var3_12
end

function var0_0.Show(arg0_13)
	var0_0.super.Show(arg0_13)
	arg0_13:FlushTips()
	arg0_13:FlushBattery()
	arg0_13:FlushTime()
	arg0_13:FlushDate()
	arg0_13:AddTimer()

	arg0_13.changeSkinCount = 0
	arg0_13.enterTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_13.paintingTime = arg0_13.enterTime
end

function var0_0.Reset(arg0_14)
	var0_0.super.Reset(arg0_14)

	arg0_14.exited = false
end

function var0_0.AddTimer(arg0_15)
	arg0_15:RemoveTimer()

	arg0_15.timer = Timer.New(function()
		arg0_15:FlushTips()
		arg0_15:FlushBattery()
	end, 30, -1)

	arg0_15.timer:Start()
end

function var0_0.RemoveTimer(arg0_17)
	if arg0_17.timer then
		arg0_17.timer:Stop()

		arg0_17.timer = nil
	end
end

function var0_0.FlushTips(arg0_18)
	local var0_18 = {}

	arg0_18:CollectTips(var0_18)

	local var1_18 = {}

	arg0_18.tips:make(function(arg0_19, arg1_19, arg2_19)
		if UIItemList.EventUpdate == arg0_19 then
			local var0_19 = var0_18[arg1_19 + 1]
			local var1_19 = GetSpriteFromAtlas("ui/MainUI_atlas", "noti_" .. var0_19.type)

			arg2_19:Find("icon"):GetComponent(typeof(Image)).sprite = var1_19

			setText(arg2_19:Find("num"), var0_19.count)
			setText(arg2_19:Find("Text"), i18n("main_silent_tip_" .. var0_19.type))
			onButton(arg0_18, arg2_19, function()
				arg0_18:PlayTipOutAnimation(arg2_19, function()
					arg0_18:Skip(var0_19.type)
				end)
			end, SFX_PANEL)
			arg0_18:InsertAnimation(var1_18, arg2_19)
		end
	end)
	arg0_18.tips:align(#var0_18)
	seriesAsync(var1_18, function()
		return
	end)
end

function var0_0.PlayTipOutAnimation(arg0_23, arg1_23, arg2_23)
	arg0_23.cg.blocksRaycasts = false

	local var0_23 = arg1_23:GetComponent(typeof(Animation))
	local var1_23 = arg1_23:GetComponent(typeof(DftAniEvent))

	var1_23:SetEndEvent(nil)
	var1_23:SetEndEvent(function()
		arg0_23.cg.blocksRaycasts = true

		var1_23:SetEndEvent(nil)
		arg2_23()
	end)
	var0_23:Play("anim_silentview_tip_out")
end

function var0_0.InsertAnimation(arg0_25, arg1_25, arg2_25)
	if table.contains(arg0_25.playedList, arg2_25) then
		return
	end

	local var0_25 = GetOrAddComponent(arg2_25, typeof(CanvasGroup))

	var0_25.alpha = 0

	table.insert(arg1_25, function(arg0_26)
		if arg0_25.exited then
			return
		end

		var0_25.alpha = 1

		arg2_25:GetComponent(typeof(Animation)):Play("anim_silentview_tip_in")
		onDelayTick(arg0_26, 0.066)
	end)
	table.insert(arg0_25.playedList, arg2_25)
end

function var0_0.Skip(arg0_27, arg1_27)
	arg0_27:Tracking(var6_0)
	arg0_27:Exit(function()
		if arg1_27 == var1_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1_27 == var2_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT)
		elseif arg1_27 == var3_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
		elseif arg1_27 == var4_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
				warp = NavalAcademyScene.WARP_TO_TACTIC
			})
		end
	end)
end

function var0_0.CollectTips(arg0_29, arg1_29)
	arg0_29:CollectEventTips(arg1_29)
	arg0_29:CollectBuildTips(arg1_29)
	arg0_29:CollectTechTips(arg1_29)
	arg0_29:CollectStudentTips(arg1_29)
end

function var0_0.CollectEventTips(arg0_30, arg1_30)
	local var0_30 = getProxy(EventProxy):countByState(EventInfo.StateFinish)

	if var0_30 > 0 then
		table.insert(arg1_30, {
			count = var0_30,
			type = var1_0
		})
	end
end

function var0_0.CollectBuildTips(arg0_31, arg1_31)
	local var0_31 = getProxy(BuildShipProxy):getFinishCount()

	if var0_31 > 0 then
		table.insert(arg1_31, {
			count = var0_31,
			type = var2_0
		})
	end
end

function var0_0.CollectTechTips(arg0_32, arg1_32)
	local var0_32 = getProxy(TechnologyProxy):getPlanningTechnologys()
	local var1_32 = 0

	for iter0_32, iter1_32 in pairs(var0_32) do
		if iter1_32:isCompleted() then
			var1_32 = var1_32 + 1
		end
	end

	if var1_32 > 0 then
		table.insert(arg1_32, {
			count = var1_32,
			type = var3_0
		})
	end
end

function var0_0.CollectStudentTips(arg0_33, arg1_33)
	local var0_33 = getProxy(NavalAcademyProxy):RawGetStudentList()
	local var1_33 = 0

	for iter0_33, iter1_33 in pairs(var0_33) do
		if iter1_33:IsFinish() then
			var1_33 = var1_33 + 1
		end
	end

	if var1_33 > 0 then
		table.insert(arg1_33, {
			count = var1_33,
			type = var4_0
		})
	end
end

function var0_0.FlushBattery(arg0_34)
	local var0_34 = SystemInfo.batteryLevel

	if var0_34 < 0 then
		var0_34 = 1
	end

	local var1_34 = math.floor(var0_34 * 100)

	arg0_34.batteryTxt.text = var1_34 .. "%"

	local var2_34 = 1 / #arg0_34.electric

	for iter0_34, iter1_34 in ipairs(arg0_34.electric) do
		local var3_34 = var1_34 < (iter0_34 - 1) * var2_34

		setActive(iter1_34, not var3_34)
	end
end

function var0_0.FlushTime(arg0_35)
	arg0_35.systemTimeUtil:SetUp(function(arg0_36, arg1_36, arg2_36)
		local var0_36 = arg0_36 > 12 and arg0_36 - 12 or arg0_36

		if var0_36 < 10 then
			var0_36 = "0" .. var0_36
		end

		arg0_35.timeTxt.text = var0_36 .. ":" .. arg1_36
		arg0_35.timeEnTxt.text = arg2_36
	end)
end

local var7_0 = {
	"MONDAY",
	"TUESDAY",
	"WEDNESDAY",
	"THURSDAY",
	"FRIDAY",
	"SATURDAY",
	"SUNDAY"
}
local var8_0 = {
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

function var0_0.FlushDate(arg0_37)
	local var0_37 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true)
	local var1_37 = string.split(var0_37, "/")
	local var2_37 = var1_37[1]
	local var3_37 = tonumber(var1_37[2])
	local var4_37 = var1_37[3]
	local var5_37 = pg.TimeMgr.GetInstance():GetServerWeek()
	local var6_37 = {
		var7_0[var5_37],
		var8_0[var3_37],
		var4_37,
		var2_37
	}

	arg0_37.dateTxt.text = table.concat(var6_37, " / ")
end

function var0_0.OnDestroy(arg0_38)
	arg0_38.exited = true

	arg0_38.dftAniEvent:SetEndEvent(nil)
	arg0_38:RemoveTimer()
	arg0_38.changeSkinBtn:Dispose()

	arg0_38.changeSkinBtn = nil

	arg0_38.systemTimeUtil:Dispose()

	arg0_38.systemTimeUtil = nil
end

return var0_0
