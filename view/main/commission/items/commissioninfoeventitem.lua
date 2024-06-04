local var0 = class("CommissionInfoEventItem", import(".CommissionInfoItem"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.lockTF = arg0._tf:Find("lock")

	setActive(arg0.lockTF, false)
	setText(arg0.lockTF:Find("Text"), i18n("commission_label_unlock_event_tip"))
end

function var0.CanOpen(arg0)
	return getProxy(PlayerProxy):getData().level >= 12
end

function var0.Init(arg0)
	local var0 = arg0:CanOpen()

	setActive(arg0.lockTF, not var0)
	setGray(arg0.toggle, not var0, true)
	setActive(arg0.foldFlag, var0)
	setActive(arg0.goBtn, var0)

	arg0.ptBonus = EventPtBonus.New(arg0.toggle:Find("bonusPt"))

	var0.super.Init(arg0)
end

function var0.GetList(arg0)
	assert(arg0.list, "why ???")
	table.sort(arg0.list, function(arg0, arg1)
		return arg0.state > arg1.state
	end)

	return arg0.list, 4
end

function var0.OnFlush(arg0)
	local var0, var1, var2, var3 = getProxy(EventProxy):GetEventListForCommossionInfo()

	arg0.finishedCounter.text = var1
	arg0.ongoingCounter.text = var2
	arg0.leisureCounter.text = var3

	setActive(arg0.finishedCounterContainer, var1 > 0)
	setActive(arg0.ongoingCounterContainer, var2 > 0)
	setActive(arg0.leisureCounterContainer, var3 > 0)
	setActive(arg0.goBtn, var1 == 0)
	setActive(arg0.finishedBtn, var1 > 0)

	arg0.list = var0
end

function var0.UpdateList(arg0)
	var0.super.UpdateList(arg0)
	arg0:UpdateActList()
end

function var0.UpdateActList(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var0 and not var0:isEnd() then
		local var1 = getProxy(EventProxy):GetEventByActivityId(var0.id)

		if var1 then
			local var2 = cloneTplTo(arg0.uilist.item, arg0.uilist.container)

			var2:SetAsFirstSibling()
			arg0:UpdateEventInfo(var2, var1)
			setActive(var2:Find("unlock"), true)
			setActive(var2:Find("lock"), false)
			arg0:UpdateStyle(var2, true)
		end
	end
end

function var0.GetChapterByCount(arg0, arg1)
	local var0 = pg.chapter_template

	for iter0, iter1 in pairs(var0.all) do
		if var0[iter1].collection_team == arg1 then
			return var0[iter1]
		end
	end
end

function var0.UpdateListItem(arg0, arg1, arg2, arg3)
	local var0 = arg1 > getProxy(EventProxy).maxFleetNums

	if var0 then
		local var1 = arg0:GetChapterByCount(arg1)

		assert(var1, arg1)

		if getProxy(SettingsProxy):IsMellowStyle() then
			setText(arg3:Find("lock/Text"), i18n("commission_open_tip", var1.chapter_name))
		else
			setText(arg3:Find("lock/Text"), i18n("commission_no_open") .. "\n" .. i18n("commission_open_tip", var1.chapter_name))
		end
	else
		arg0:UpdateEventInfo(arg3, arg2)
	end

	setActive(arg3:Find("unlock"), not var0)
	setActive(arg3:Find("lock"), var0)
	arg0:UpdateStyle(arg3, false, arg2)
end

function var0.UpdateEventInfo(arg0, arg1, arg2)
	local var0 = arg2 and arg2.state or EventInfo.StateNone

	if var0 == EventInfo.StateNone then
		setText(arg1:Find("unlock/name_bg/Text"), i18n("commission_idle"))
		onButton(arg0, arg1:Find("unlock/leisure/go_btn"), function()
			arg0:OnSkip()
		end, SFX_PANEL)
		onButton(arg0, arg1, function()
			triggerButton(arg1:Find("unlock/leisure/go_btn"))
		end, SFX_PANEL)
	elseif var0 == EventInfo.StateFinish then
		setText(arg1:Find("unlock/name_bg/Text"), arg2.template.title)
		onButton(arg0, arg1:Find("unlock/finished/finish_btn"), function()
			arg0:emit(CommissionInfoMediator.FINISH_EVENT, arg2)
		end, SFX_PANEL)
		onButton(arg0, arg1, function()
			triggerButton(arg1:Find("unlock/finished/finish_btn"))
		end, SFX_PANEL)
	elseif var0 == EventInfo.StateActive then
		setText(arg1:Find("unlock/name_bg/Text"), arg2.template.title)

		local var1 = arg1:Find("unlock/ongoging/time"):GetComponent(typeof(Text))

		arg0:AddTimer(arg2, var1)
	end

	setActive(arg1:Find("unlock/leisure"), var0 == EventInfo.StateNone)
	setActive(arg1:Find("unlock/ongoging"), var0 == EventInfo.StateActive)
	setActive(arg1:Find("unlock/finished"), var0 == EventInfo.StateFinish)
end

function var0.AddTimer(arg0, arg1, arg2)
	arg0:RemoveTimer(arg1)

	local var0 = arg1.finishTime + 2

	arg0.timers[arg1.id] = Timer.New(function()
		local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			arg0.timers[arg1.id]:Stop()

			arg0.timers[arg1.id] = nil

			arg0:OnFlush()
			arg0:UpdateList()
		else
			arg2.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.timers[arg1.id]:Start()
	arg0.timers[arg1.id].func()
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.timers[arg1.id] then
		arg0.timers[arg1.id]:Stop()

		arg0.timers[arg1.id] = nil
	end
end

function var0.UpdateStyle(arg0, arg1, arg2, arg3)
	local var0 = arg3 and arg3.state or EventInfo.StateNone
	local var1 = "icon_1"
	local var2 = "icon_4"
	local var3 = "icon_3"

	if arg2 then
		var1, var2, var3 = "icon_5", "icon_6", "icon_6"
	end

	local function var4(arg0, arg1)
		local var0 = arg1:Find(string.format("unlock/%s/icon", arg0))
		local var1 = GetSpriteFromAtlas("ui/commissioninfoui_atlas", arg1)

		var0.localScale = arg2 and Vector3.one or Vector3(1.2, 1.2, 1.2)
		var0:GetComponent(typeof(Image)).sprite = var1

		var0:GetComponent(typeof(Image)):SetNativeSize()
	end

	var4("leisure", var1)
	var4("ongoging", var2)
	var4("finished", var3)

	local var5 = "event_ongoing"

	if arg2 then
		var5 = "event_bg_act"
	end

	if getProxy(SettingsProxy):IsMellowStyle() then
		var5 = "frame_unlock"
		arg1:Find("unlock/ongoging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/CommissionInfoUI4Mellow_atlas", var5)
		arg1:Find("unlock/finished"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/CommissionInfoUI4Mellow_atlas", var5)
	else
		arg1:Find("unlock/ongoging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", var5)
		arg1:Find("unlock/finished"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", var5)
	end

	local var6 = Color.New(0.996078431372549, 0.756862745098039, 0.972549019607843, 1)
	local var7 = arg2 and var6 or Color.New(0.603921568627451, 0.784313725490196, 0.96078431372549, 1)

	arg1:Find("unlock/ongoging/print"):GetComponent(typeof(Image)).color = var7
	arg1:Find("unlock/finished/print"):GetComponent(typeof(Image)).color = var7

	setActive(arg1:Find("unlock/act"), var0 == EventInfo.StateNone and arg2)
end

function var0.OnSkip(arg0)
	arg0:emit(CommissionInfoMediator.ON_ACTIVE_EVENT)
end

function var0.OnFinishAll(arg0)
	local var0 = {}
	local var1 = 0

	_.each(arg0.list, function(arg0)
		if arg0.state == EventInfo.StateFinish then
			table.insert(var0, function(arg0)
				arg0:emit(CommissionInfoMediator.FINISH_EVENT, arg0, var1, arg0)
			end)
		end
	end)

	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if var2 and not var2:isEnd() then
		local var3 = getProxy(EventProxy):GetEventByActivityId(var2.id)

		if var3 and var3.state == EventInfo.StateFinish then
			table.insert(var0, function(arg0)
				arg0:emit(CommissionInfoMediator.FINISH_EVENT, var3, var1, arg0)
			end)
		end
	end

	var1 = #var0

	seriesAsync(var0)
end

return var0
