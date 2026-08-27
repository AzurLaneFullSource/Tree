local var0_0 = class("CommissionInfoChapterAutoItem", import(".CommissionInfoItem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.timeContainer = arg0_1._tf:Find("frame/counter/time")
	arg0_1.timeText = arg0_1.timeContainer:Find("Text"):GetComponent(typeof(Text))
	arg0_1.expireContainer = arg0_1._tf:Find("frame/expire")
	arg0_1.expireText = arg0_1.expireContainer:Find("Text"):GetComponent(typeof(Text))
	arg0_1.lockTF = arg0_1._tf:Find("lock")

	setActive(arg0_1.lockTF, false)
	setText(arg0_1.lockTF:Find("Text"), i18n("commission_label_unlock_auto_tip"))
end

function var0_0.CanOpen(arg0_2)
	return ChapterAutoProxy.IsSystemOpen()
end

function var0_0.Init(arg0_3)
	setActive(arg0_3.foldFlag, false)
	var0_0.super.Init(arg0_3)

	local var0_3 = arg0_3:CanOpen()

	setActive(arg0_3.lockTF, not var0_3)

	arg0_3.detailPanel = ChapterAutoDetailPanel.New(arg0_3._tf, arg0_3.view.event)
end

function var0_0.OnFlush(arg0_4)
	arg0_4.list = {}

	local var0_4 = getProxy(ChapterAutoProxy)
	local var1_4 = getProxy(ChapterAutoProxy):GetWillExpireTicketCnt()

	arg0_4.expireText.text = i18n("auto_battle_book_expire_warning", var1_4)

	setActive(arg0_4.expireContainer, var1_4 > 0)

	arg0_4.finishedTime = var0_4:GetFinishAllCommissionTime()

	arg0_4:OnUpdateTime()

	if arg0_4.isShowTime then
		arg0_4:AddTimer()
	else
		arg0_4:RemoveTimer()
	end
end

function var0_0.OnUpdateTime(arg0_5)
	local var0_5, var1_5 = getProxy(ChapterAutoProxy):GetCntInfo()

	arg0_5.isLeisure = var1_5 == 0
	arg0_5.isFinishedAll = not arg0_5.isLeisure and var0_5 == var1_5
	arg0_5.isShowTime = not arg0_5.isLeisure and not arg0_5.isFinishedAll
	arg0_5.finishedCounter.text = var0_5 .. "/" .. var1_5
	arg0_5.ongoingCounter.text = ""
	arg0_5.leisureCounter.text = ""

	setActive(arg0_5.ongoingCounterContainer, false)
	setActive(arg0_5.finishedCounterContainer, not arg0_5.isLeisure)
	setActive(arg0_5.leisureCounterContainer, arg0_5.isLeisure)
	setActive(arg0_5.goBtn, arg0_5.isLeisure or var0_5 < var1_5)
	setActive(arg0_5.finishedBtn, arg0_5.isFinishedAll)

	if arg0_5.isShowTime then
		local var2_5 = pg.TimeMgr.GetInstance()
		local var3_5 = arg0_5.finishedTime - var2_5:GetServerTime()

		arg0_5.timeText.text = var3_5 > 0 and var2_5:DescCDTime(var3_5) or "00:00:00"
	end

	if arg0_5.isFinishedAll then
		arg0_5:RemoveTimer()
	end
end

function var0_0.UpdateListItem(arg0_6, arg1_6, arg2_6, arg3_6)
	return
end

function var0_0.AddTimer(arg0_7)
	arg0_7:RemoveTimer()
	setActive(arg0_7.timeContainer, true)

	arg0_7.timer = Timer.New(function()
		arg0_7:OnUpdateTime()
	end, 1, -1)

	arg0_7.timer:Start()
	arg0_7.timer.func()
end

function var0_0.RemoveTimer(arg0_9)
	setActive(arg0_9.timeContainer, false)

	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.GetList(arg0_10)
	return getProxy(ChapterAutoProxy):GetCommissionList()
end

function var0_0.OnSkip(arg0_11)
	local var0_11 = getProxy(ChapterProxy)

	if arg0_11.isLeisure then
		arg0_11:emit(CommissionInfoMediator.GO_BATTLE)
	else
		local var1_11 = var0_11:getChapterById(var0_11:GetAutoChapterId())

		arg0_11.detailPanel:ExecuteAction("Enter", var1_11)
	end
end

function var0_0.OnFinishAll(arg0_12)
	arg0_12:emit(CommissionInfoMediator.ON_END_CHAPTER_AUTO)
end

function var0_0.Dispose(arg0_13)
	var0_0.super.Dispose(arg0_13)
	arg0_13:RemoveTimer()

	if arg0_13.detailPanel then
		arg0_13.detailPanel:Destroy()

		arg0_13.detailPanel = nil
	end
end

return var0_0
