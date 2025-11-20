local var0_0 = class("BossRushDALCollabStageView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BossRushStageInfoUIDALCollab"
end

function var0_0.SetUp(arg0_2, arg1_2)
	arg0_2:RegisterEvent()
end

function var0_0.SetData(arg0_3, arg1_3)
	arg0_3._series = arg1_3

	local var0_3 = arg1_3:GetBossHpRate()

	arg0_3._barVct2.x = var0_3 * arg0_3._barL
	arg0_3._progressBar.sizeDelta = arg0_3._barVct2

	local var1_3 = var0_3 * 100
	local var2_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB)

	if not arg0_3._series:GetDefeated(var2_3) and arg0_3._series:IsPass() then
		setText(arg0_3._hpRate, "HOLD")
	else
		setText(arg0_3._hpRate, var1_3 .. "%")
	end

	setText(arg0_3._stageName, arg1_3:GetSeriesName())

	local var3_3, var4_3 = arg1_3:GetCurrentProfile()

	for iter0_3, iter1_3 in ipairs(arg0_3._labelList) do
		if not var3_3[iter0_3] then
			setActive(iter1_3, false)
		else
			setActive(iter1_3, true)
			setText(iter1_3:Find("desc"), var3_3[iter0_3])
		end
	end

	for iter2_3, iter3_3 in ipairs(var4_3) do
		setText(arg0_3._labelList[iter2_3]:Find("state"), iter3_3)
	end

	setText(arg0_3._goBtnNormal:Find("text"), arg1_3:GetName(arg1_3.DIFF.NORMAL))
	setText(arg0_3._goBtnHard:Find("text"), arg1_3:GetName(arg1_3.DIFF.HARD))

	if arg0_3._series:GetBossTimeStamp() == 0 then
		local var5_3 = arg1_3:GetDamagePerH() * 100

		setText(arg0_3._delta, "-" .. var5_3 .. "%")
		setActive(arg0_3._delta, true)
		setActive(arg0_3._timeStamp, false)
	else
		local var6_3 = arg1_3:GetBossTimeStamp()
		local var7_3 = os.date("*t", var6_3)

		setText(arg0_3._timeStamp:Find("date"), string.format("%02d/%02d %02d:%02d", var7_3.month, var7_3.day, var7_3.hour, var7_3.min))
		setActive(arg0_3._delta, false)
		setActive(arg0_3._timeStamp, true)
	end

	local var8_3 = arg0_3._series:GetRewardDisplay()

	UIItemList.StaticAlign(arg0_3._arwardList, arg0_3._arwardList:GetChild(0), #var8_3, function(arg0_4, arg1_4, arg2_4)
		if arg0_4 ~= UIItemList.EventUpdate then
			return
		end

		local var0_4 = var8_3[arg1_4 + 1]
		local var1_4 = Drop.Create(var0_4)

		updateDrop(arg2_4, var1_4)

		local var2_4 = arg0_3._series:GetReplaceTaskIDList()[1]
		local var3_4 = getProxy(TaskProxy):getTaskById(var2_4)

		if arg0_3._series:IsPass() then
			if var3_4 then
				setActive(arg0_3._rewardRemind, true)
				setActive(arg2_4:Find("got"), false)
			else
				setActive(arg0_3._rewardRemind, false)
				setActive(arg2_4:Find("got"), true)
			end
		else
			setActive(arg0_3._rewardRemind, false)
			setActive(arg2_4:Find("got"), false)
		end
	end)
end

function var0_0.Show(arg0_5)
	var0_0.super.Show(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.Hide(arg0_6)
	var0_0.super.Hide(arg0_6)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf, arg0_6._parentTf)
end

function var0_0.OnLoaded(arg0_7)
	arg0_7.parentTr = arg0_7._tf.parent
	arg0_7._bg = arg0_7._tf:Find("BG")
	arg0_7._stageName = arg0_7._tf:Find("Panel/Progress/name")
	arg0_7._delta = arg0_7._tf:Find("Panel/Progress/delta")
	arg0_7._hpRate = arg0_7._tf:Find("Panel/Progress/value")
	arg0_7._timeStamp = arg0_7._tf:Find("Panel/Progress/timestamp")
	arg0_7._progressBar = arg0_7._tf:Find("Panel/Progress/progress_bar")
	arg0_7._barL = arg0_7._progressBar.rect.width
	arg0_7._barVct2 = Vector2(arg0_7._progressBar.rect.width, arg0_7._progressBar.rect.height)

	setText(arg0_7._timeStamp:Find("label"), i18n("DAL_stage_finish_at"))

	arg0_7._labelList = {}

	table.insert(arg0_7._labelList, arg0_7._tf:Find("Panel/StageInfo/label_1"))
	table.insert(arg0_7._labelList, arg0_7._tf:Find("Panel/StageInfo/label"))
	table.insert(arg0_7._labelList, arg0_7._tf:Find("Panel/StageInfo/commander_label"))
	table.insert(arg0_7._labelList, arg0_7._tf:Find("Panel/StageInfo/label_2"))
	setText(arg0_7._tf:Find("Panel/StageInfo/label_1/label/text"), i18n("DAL_stage_label_data"))
	setText(arg0_7._tf:Find("Panel/StageInfo/label/label/text"), i18n("DAL_stage_label_data"))
	setText(arg0_7._tf:Find("Panel/StageInfo/commander_label/label/text"), i18n("DAL_stage_label_commander"))
	setText(arg0_7._tf:Find("Panel/StageInfo/label_2/label/text"), i18n("DAL_stage_label_support"))

	arg0_7._rewardRemind = arg0_7._tf:Find("Panel/Reward/remind")

	setText(arg0_7._rewardRemind:Find("text"), i18n("dal_chapter_tip2"))
	setText(arg0_7._tf:Find("Panel/Reward/label"), i18n("item_type17_tip1"))

	arg0_7._arwardList = arg0_7._tf:Find("Panel/Reward/Items")
	arg0_7._goBtnNormal = arg0_7._tf:Find("Panel/Battle/normal")
	arg0_7._goBtnHard = arg0_7._tf:Find("Panel/Battle/hard")
	arg0_7._closeBtn = arg0_7._tf:Find("Panel/close_btn")

	arg0_7:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_8)
	onButton(arg0_8, arg0_8._closeBtn, function()
		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._goBtnNormal, function()
		arg0_8._series:SetDifficulty(CollabrateBossRushSeriesData.DIFF.NORMAL)
		arg0_8.event:emit(BossRushDALCollabMediator.ON_FLEET_SELECT, arg0_8._series)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._goBtnHard, function()
		arg0_8._series:SetDifficulty(CollabrateBossRushSeriesData.DIFF.HARD)
		arg0_8.event:emit(BossRushDALCollabMediator.ON_FLEET_SELECT, arg0_8._series)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._bg, function()
		arg0_8:Hide()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13.exited = true

	if arg0_13:isShowing() then
		arg0_13:Hide()
	end
end

return var0_0
