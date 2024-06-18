local var0_0 = class("CommissionInfoEventItem", import(".CommissionInfoItem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.lockTF = arg0_1._tf:Find("lock")

	setActive(arg0_1.lockTF, false)
	setText(arg0_1.lockTF:Find("Text"), i18n("commission_label_unlock_event_tip"))
end

function var0_0.CanOpen(arg0_2)
	return getProxy(PlayerProxy):getData().level >= 12
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3:CanOpen()

	setActive(arg0_3.lockTF, not var0_3)
	setGray(arg0_3.toggle, not var0_3, true)
	setActive(arg0_3.foldFlag, var0_3)
	setActive(arg0_3.goBtn, var0_3)

	arg0_3.ptBonus = EventPtBonus.New(arg0_3.toggle:Find("bonusPt"))

	var0_0.super.Init(arg0_3)
end

function var0_0.GetList(arg0_4)
	assert(arg0_4.list, "why ???")
	table.sort(arg0_4.list, function(arg0_5, arg1_5)
		return arg0_5.state > arg1_5.state
	end)

	return arg0_4.list, 4
end

function var0_0.OnFlush(arg0_6)
	local var0_6, var1_6, var2_6, var3_6 = getProxy(EventProxy):GetEventListForCommossionInfo()

	arg0_6.finishedCounter.text = var1_6
	arg0_6.ongoingCounter.text = var2_6
	arg0_6.leisureCounter.text = var3_6

	setActive(arg0_6.finishedCounterContainer, var1_6 > 0)
	setActive(arg0_6.ongoingCounterContainer, var2_6 > 0)
	setActive(arg0_6.leisureCounterContainer, var3_6 > 0)
	setActive(arg0_6.goBtn, var1_6 == 0)
	setActive(arg0_6.finishedBtn, var1_6 > 0)

	arg0_6.list = var0_6
end

function var0_0.UpdateList(arg0_7)
	var0_0.super.UpdateList(arg0_7)
	arg0_7:UpdateActList()
end

function var0_0.UpdateActList(arg0_8)
	local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var0_8 and not var0_8:isEnd() then
		local var1_8 = getProxy(EventProxy):GetEventByActivityId(var0_8.id)

		if var1_8 then
			local var2_8 = cloneTplTo(arg0_8.uilist.item, arg0_8.uilist.container)

			var2_8:SetAsFirstSibling()
			arg0_8:UpdateEventInfo(var2_8, var1_8)
			setActive(var2_8:Find("unlock"), true)
			setActive(var2_8:Find("lock"), false)
			arg0_8:UpdateStyle(var2_8, true)
		end
	end
end

function var0_0.GetChapterByCount(arg0_9, arg1_9)
	local var0_9 = pg.chapter_template

	for iter0_9, iter1_9 in pairs(var0_9.all) do
		if var0_9[iter1_9].collection_team == arg1_9 then
			return var0_9[iter1_9]
		end
	end
end

function var0_0.UpdateListItem(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg1_10 > getProxy(EventProxy).maxFleetNums

	if var0_10 then
		local var1_10 = arg0_10:GetChapterByCount(arg1_10)

		assert(var1_10, arg1_10)

		if getProxy(SettingsProxy):IsMellowStyle() then
			setText(arg3_10:Find("lock/Text"), i18n("commission_open_tip", var1_10.chapter_name))
		else
			setText(arg3_10:Find("lock/Text"), i18n("commission_no_open") .. "\n" .. i18n("commission_open_tip", var1_10.chapter_name))
		end
	else
		arg0_10:UpdateEventInfo(arg3_10, arg2_10)
	end

	setActive(arg3_10:Find("unlock"), not var0_10)
	setActive(arg3_10:Find("lock"), var0_10)
	arg0_10:UpdateStyle(arg3_10, false, arg2_10)
end

function var0_0.UpdateEventInfo(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11 and arg2_11.state or EventInfo.StateNone

	if var0_11 == EventInfo.StateNone then
		setText(arg1_11:Find("unlock/name_bg/Text"), i18n("commission_idle"))
		onButton(arg0_11, arg1_11:Find("unlock/leisure/go_btn"), function()
			arg0_11:OnSkip()
		end, SFX_PANEL)
		onButton(arg0_11, arg1_11, function()
			triggerButton(arg1_11:Find("unlock/leisure/go_btn"))
		end, SFX_PANEL)
	elseif var0_11 == EventInfo.StateFinish then
		setText(arg1_11:Find("unlock/name_bg/Text"), arg2_11.template.title)
		onButton(arg0_11, arg1_11:Find("unlock/finished/finish_btn"), function()
			arg0_11:emit(CommissionInfoMediator.FINISH_EVENT, arg2_11)
		end, SFX_PANEL)
		onButton(arg0_11, arg1_11, function()
			triggerButton(arg1_11:Find("unlock/finished/finish_btn"))
		end, SFX_PANEL)
	elseif var0_11 == EventInfo.StateActive then
		setText(arg1_11:Find("unlock/name_bg/Text"), arg2_11.template.title)

		local var1_11 = arg1_11:Find("unlock/ongoging/time"):GetComponent(typeof(Text))

		arg0_11:AddTimer(arg2_11, var1_11)
	end

	setActive(arg1_11:Find("unlock/leisure"), var0_11 == EventInfo.StateNone)
	setActive(arg1_11:Find("unlock/ongoging"), var0_11 == EventInfo.StateActive)
	setActive(arg1_11:Find("unlock/finished"), var0_11 == EventInfo.StateFinish)
end

function var0_0.AddTimer(arg0_16, arg1_16, arg2_16)
	arg0_16:RemoveTimer(arg1_16)

	local var0_16 = arg1_16.finishTime + 2

	arg0_16.timers[arg1_16.id] = Timer.New(function()
		local var0_17 = var0_16 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_17 <= 0 then
			arg0_16.timers[arg1_16.id]:Stop()

			arg0_16.timers[arg1_16.id] = nil

			arg0_16:OnFlush()
			arg0_16:UpdateList()
		else
			arg2_16.text = pg.TimeMgr.GetInstance():DescCDTime(var0_17)
		end
	end, 1, -1)

	arg0_16.timers[arg1_16.id]:Start()
	arg0_16.timers[arg1_16.id].func()
end

function var0_0.RemoveTimer(arg0_18, arg1_18)
	if arg0_18.timers[arg1_18.id] then
		arg0_18.timers[arg1_18.id]:Stop()

		arg0_18.timers[arg1_18.id] = nil
	end
end

function var0_0.UpdateStyle(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg3_19 and arg3_19.state or EventInfo.StateNone
	local var1_19 = "icon_1"
	local var2_19 = "icon_4"
	local var3_19 = "icon_3"

	if arg2_19 then
		var1_19, var2_19, var3_19 = "icon_5", "icon_6", "icon_6"
	end

	local function var4_19(arg0_20, arg1_20)
		local var0_20 = arg1_19:Find(string.format("unlock/%s/icon", arg0_20))
		local var1_20 = GetSpriteFromAtlas("ui/commissioninfoui_atlas", arg1_20)

		var0_20.localScale = arg2_19 and Vector3.one or Vector3(1.2, 1.2, 1.2)
		var0_20:GetComponent(typeof(Image)).sprite = var1_20

		var0_20:GetComponent(typeof(Image)):SetNativeSize()
	end

	var4_19("leisure", var1_19)
	var4_19("ongoging", var2_19)
	var4_19("finished", var3_19)

	local var5_19 = "event_ongoing"

	if arg2_19 then
		var5_19 = "event_bg_act"
	end

	if getProxy(SettingsProxy):IsMellowStyle() then
		var5_19 = "frame_unlock"
		arg1_19:Find("unlock/ongoging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/CommissionInfoUI4Mellow_atlas", var5_19)
		arg1_19:Find("unlock/finished"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/CommissionInfoUI4Mellow_atlas", var5_19)
	else
		arg1_19:Find("unlock/ongoging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", var5_19)
		arg1_19:Find("unlock/finished"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", var5_19)
	end

	local var6_19 = Color.New(0.996078431372549, 0.756862745098039, 0.972549019607843, 1)
	local var7_19 = arg2_19 and var6_19 or Color.New(0.603921568627451, 0.784313725490196, 0.96078431372549, 1)

	arg1_19:Find("unlock/ongoging/print"):GetComponent(typeof(Image)).color = var7_19
	arg1_19:Find("unlock/finished/print"):GetComponent(typeof(Image)).color = var7_19

	setActive(arg1_19:Find("unlock/act"), var0_19 == EventInfo.StateNone and arg2_19)
end

function var0_0.OnSkip(arg0_21)
	arg0_21:emit(CommissionInfoMediator.ON_ACTIVE_EVENT)
end

function var0_0.OnFinishAll(arg0_22)
	local var0_22 = {}
	local var1_22 = 0

	_.each(arg0_22.list, function(arg0_23)
		if arg0_23.state == EventInfo.StateFinish then
			table.insert(var0_22, function(arg0_24)
				arg0_22:emit(CommissionInfoMediator.FINISH_EVENT, arg0_23, var1_22, arg0_24)
			end)
		end
	end)

	local var2_22 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var2_22 and not var2_22:isEnd() then
		local var3_22 = getProxy(EventProxy):GetEventByActivityId(var2_22.id)

		if var3_22 and var3_22.state == EventInfo.StateFinish then
			table.insert(var0_22, function(arg0_25)
				arg0_22:emit(CommissionInfoMediator.FINISH_EVENT, var3_22, var1_22, arg0_25)
			end)
		end
	end

	var1_22 = #var0_22

	seriesAsync(var0_22)
end

return var0_0
