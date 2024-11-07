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
	arg0_2.chatTr = arg0_2:findTF("chat")
	arg0_2.chatTxt = arg0_2.chatTr:GetComponent(typeof(Text))
	arg0_2.changeSkinBtn = MainChangeSkinBtn.New(arg0_2.changeBtn, arg0_2.event)
	arg0_2.systemTimeUtil = LocalSystemTimeUtil.New()
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
	arg0_3:bind(MainWordView.SET_CONTENT, function(arg0_8, arg1_8, arg2_8)
		arg0_3:SetChatTxt(arg2_8)
	end)
	arg0_3:bind(MainWordView.START_ANIMATION, function(arg0_9, arg1_9, arg2_9)
		arg0_3:RemoveChatTimer()
		arg0_3:AddChatTimer(arg1_9 + arg2_9)
	end)
	arg0_3:bind(MainWordView.STOP_ANIMATION, function(arg0_10, arg1_10, arg2_10)
		arg0_3:RemoveChatTimer()
		arg0_3:SetChatTxt("")
	end)
	arg0_3.changeSkinBtn:Flush()
end

function var0_0.RemoveChatTimer(arg0_11)
	if arg0_11.chatTimer then
		arg0_11.chatTimer:Stop()

		arg0_11.chatTimer = nil
	end
end

function var0_0.AddChatTimer(arg0_12, arg1_12)
	arg0_12.chatTimer = Timer.New(function()
		arg0_12:SetChatTxt("")
	end, arg1_12, 1)

	arg0_12.chatTimer:Start()
end

function var0_0.SetChatTxt(arg0_14, arg1_14)
	setActive(arg0_14.chatTr, arg1_14 and arg1_14 ~= "")

	arg0_14.chatTxt.text = arg1_14 or ""
end

function var0_0.OnRemoveLayer(arg0_15, arg1_15)
	if arg1_15.mediator == CommissionInfoMediator or arg1_15.mediator == NotificationMediator then
		arg0_15:Exit()
	end
end

function var0_0.Exit(arg0_16, arg1_16)
	arg0_16:RemoveChatTimer()
	arg0_16:TrackingSwitchShip()
	arg0_16.dftAniEvent:SetEndEvent(nil)
	arg0_16.dftAniEvent:SetEndEvent(function()
		arg0_16:emit(NewMainScene.EXIT_SILENT_VIEW)

		if arg1_16 then
			arg1_16()
		end
	end)
	arg0_16.animationPlayer:Play("anim_silentview_out")
end

function var0_0.Tracking(arg0_18, arg1_18)
	local var0_18 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_18 = arg0_18.enterTime
	local var2_18 = arg0_18.changeSkinCount
	local var3_18 = arg1_18

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildExitSilentView(var1_18, var0_18, var3_18))
end

function var0_0.TrackingSwitchShip(arg0_19)
	if not getProxy(PlayerProxy) then
		return
	end

	local var0_19 = getProxy(PlayerProxy):getRawData()

	if not var0_19 then
		return
	end

	local var1_19 = var0_19:GetFlagShip()
	local var2_19 = var1_19.skinId

	if isa(var1_19, VirtualEducateCharShip) then
		var2_19 = 0
	end

	local var3_19 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_19 = var3_19 - arg0_19.paintingTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildSwitchPainting(var2_19, var4_19))

	arg0_19.paintingTime = var3_19
end

function var0_0.Show(arg0_20)
	var0_0.super.Show(arg0_20)
	arg0_20:FlushTips()
	arg0_20:FlushBattery()
	arg0_20:FlushTime()
	arg0_20:FlushDate()
	arg0_20:AddTimer()
	arg0_20:SetChatTxt("")

	arg0_20.changeSkinCount = 0
	arg0_20.enterTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_20.paintingTime = arg0_20.enterTime
end

function var0_0.Reset(arg0_21)
	var0_0.super.Reset(arg0_21)

	arg0_21.exited = false
end

function var0_0.AddTimer(arg0_22)
	arg0_22:RemoveTimer()

	arg0_22.timer = Timer.New(function()
		arg0_22:FlushTips()
		arg0_22:FlushBattery()
	end, 30, -1)

	arg0_22.timer:Start()
end

function var0_0.RemoveTimer(arg0_24)
	if arg0_24.timer then
		arg0_24.timer:Stop()

		arg0_24.timer = nil
	end
end

function var0_0.FlushTips(arg0_25)
	local var0_25 = {}

	arg0_25:CollectTips(var0_25)

	local var1_25 = {}

	arg0_25.tips:make(function(arg0_26, arg1_26, arg2_26)
		if UIItemList.EventUpdate == arg0_26 then
			local var0_26 = var0_25[arg1_26 + 1]
			local var1_26 = GetSpriteFromAtlas("ui/MainUI_atlas", "noti_" .. var0_26.type)

			arg2_26:Find("icon"):GetComponent(typeof(Image)).sprite = var1_26

			setText(arg2_26:Find("num"), var0_26.count)
			setText(arg2_26:Find("Text"), i18n("main_silent_tip_" .. var0_26.type))
			onButton(arg0_25, arg2_26, function()
				arg0_25:PlayTipOutAnimation(arg2_26, function()
					arg0_25:Skip(var0_26.type)
				end)
			end, SFX_PANEL)
			arg0_25:InsertAnimation(var1_25, arg2_26)
		end
	end)
	arg0_25.tips:align(#var0_25)
	seriesAsync(var1_25, function()
		return
	end)
end

function var0_0.PlayTipOutAnimation(arg0_30, arg1_30, arg2_30)
	arg0_30.cg.blocksRaycasts = false

	local var0_30 = arg1_30:GetComponent(typeof(Animation))
	local var1_30 = arg1_30:GetComponent(typeof(DftAniEvent))

	var1_30:SetEndEvent(nil)
	var1_30:SetEndEvent(function()
		arg0_30.cg.blocksRaycasts = true

		var1_30:SetEndEvent(nil)
		arg2_30()
	end)
	var0_30:Play("anim_silentview_tip_out")
end

function var0_0.InsertAnimation(arg0_32, arg1_32, arg2_32)
	if table.contains(arg0_32.playedList, arg2_32) then
		return
	end

	local var0_32 = GetOrAddComponent(arg2_32, typeof(CanvasGroup))

	var0_32.alpha = 0

	table.insert(arg1_32, function(arg0_33)
		if arg0_32.exited then
			return
		end

		var0_32.alpha = 1

		arg2_32:GetComponent(typeof(Animation)):Play("anim_silentview_tip_in")
		onDelayTick(arg0_33, 0.066)
	end)
	table.insert(arg0_32.playedList, arg2_32)
end

function var0_0.Skip(arg0_34, arg1_34)
	arg0_34:Tracking(var6_0)
	arg0_34:Exit(function()
		if arg1_34 == var1_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1_34 == var2_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT)
		elseif arg1_34 == var3_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
		elseif arg1_34 == var4_0 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
				warp = NavalAcademyScene.WARP_TO_TACTIC
			})
		end
	end)
end

function var0_0.CollectTips(arg0_36, arg1_36)
	arg0_36:CollectEventTips(arg1_36)
	arg0_36:CollectBuildTips(arg1_36)
	arg0_36:CollectTechTips(arg1_36)
	arg0_36:CollectStudentTips(arg1_36)
end

function var0_0.CollectEventTips(arg0_37, arg1_37)
	local var0_37 = getProxy(EventProxy):countByState(EventInfo.StateFinish)

	if var0_37 > 0 then
		table.insert(arg1_37, {
			count = var0_37,
			type = var1_0
		})
	end
end

function var0_0.CollectBuildTips(arg0_38, arg1_38)
	local var0_38 = getProxy(BuildShipProxy):getFinishCount()

	if var0_38 > 0 then
		table.insert(arg1_38, {
			count = var0_38,
			type = var2_0
		})
	end
end

function var0_0.CollectTechTips(arg0_39, arg1_39)
	local var0_39 = getProxy(TechnologyProxy):getPlanningTechnologys()
	local var1_39 = 0

	for iter0_39, iter1_39 in pairs(var0_39) do
		if iter1_39:isCompleted() then
			var1_39 = var1_39 + 1
		end
	end

	if var1_39 > 0 then
		table.insert(arg1_39, {
			count = var1_39,
			type = var3_0
		})
	end
end

function var0_0.CollectStudentTips(arg0_40, arg1_40)
	local var0_40 = getProxy(NavalAcademyProxy):RawGetStudentList()
	local var1_40 = 0

	for iter0_40, iter1_40 in pairs(var0_40) do
		if iter1_40:IsFinish() then
			var1_40 = var1_40 + 1
		end
	end

	if var1_40 > 0 then
		table.insert(arg1_40, {
			count = var1_40,
			type = var4_0
		})
	end
end

function var0_0.FlushBattery(arg0_41)
	local var0_41 = SystemInfo.batteryLevel

	if var0_41 < 0 then
		var0_41 = 1
	end

	local var1_41 = math.floor(var0_41 * 100)

	arg0_41.batteryTxt.text = var1_41 .. "%"

	local var2_41 = 1 / #arg0_41.electric

	for iter0_41, iter1_41 in ipairs(arg0_41.electric) do
		local var3_41 = var1_41 < (iter0_41 - 1) * var2_41

		setActive(iter1_41, not var3_41)
	end
end

function var0_0.FlushTime(arg0_42)
	arg0_42.systemTimeUtil:SetUp(function(arg0_43, arg1_43, arg2_43)
		if SettingsMainScenePanel.IsEnable24HourSystem() then
			arg0_42.timeEnTxt.color = Color.New(1, 1, 1, 0)
		else
			arg0_42.timeEnTxt.color = Color.New(1, 1, 1, 1)
			arg0_43 = arg0_43 > 12 and arg0_43 - 12 or arg0_43
		end

		if arg0_43 < 10 then
			arg0_43 = "0" .. arg0_43
		end

		arg0_42.timeTxt.text = arg0_43 .. ":" .. arg1_43
		arg0_42.timeEnTxt.text = arg2_43
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

function var0_0.FlushDate(arg0_44)
	local var0_44 = os.date("%Y/%m/%d")
	local var1_44 = string.split(var0_44, "/")
	local var2_44 = var1_44[1]
	local var3_44 = tonumber(var1_44[2])
	local var4_44 = var1_44[3]
	local var5_44 = pg.TimeMgr.GetInstance():GetServerWeek()
	local var6_44 = {
		var7_0[var5_44],
		var8_0[var3_44],
		var4_44,
		var2_44
	}

	arg0_44.dateTxt.text = table.concat(var6_44, " / ")
end

function var0_0.OnDestroy(arg0_45)
	arg0_45:RemoveChatTimer()

	arg0_45.exited = true

	arg0_45.dftAniEvent:SetEndEvent(nil)
	arg0_45:RemoveTimer()
	arg0_45.changeSkinBtn:Dispose()

	arg0_45.changeSkinBtn = nil

	arg0_45.systemTimeUtil:Dispose()

	arg0_45.systemTimeUtil = nil
end

return var0_0
