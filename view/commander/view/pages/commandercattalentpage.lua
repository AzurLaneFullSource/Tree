local var0_0 = class("CommanderCatTalentPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderCatTalentui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.resetFrame = arg0_2:findTF("frame/point/reset_frame")
	arg0_2.resetTimeTF = arg0_2:findTF("frame/point/reset_frame/reset_time")
	arg0_2.resetTimeTxt = arg0_2:findTF("frame/point/reset_frame/reset_time/Text"):GetComponent(typeof(Text))
	arg0_2.resetTimeBtn = arg0_2:findTF("frame/point/reset_frame/reset_btn")
	arg0_2.pointTxt = arg0_2:findTF("frame/point/usage_frame/point/Text"):GetComponent(typeof(Text))
	arg0_2.useBtn = arg0_2:findTF("frame/point/usage_frame/use_btn")
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("frame/talents/content"), arg0_2:findTF("frame/talents/content/talent_tpl"))
	arg0_2.resetPanel = CommanderResetTalentPage.New(arg0_2._parentTf, arg0_2.event, arg0_2.contextData)
	arg0_2.usagePanel = CommanderUsageTalentPage.New(arg0_2._parentTf, arg0_2.event, arg0_2.contextData)

	setText(arg0_2:findTF("frame/point/Text"), i18n("commander_level_up_tip"))
end

function var0_0.OnInit(arg0_3)
	arg0_3:RegisterEvent()
	onButton(arg0_3, arg0_3.resetTimeBtn, function()
		if arg0_3.commanderVO:IsSameTalent() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_is_not_need"))

			return
		end

		if arg0_3.inChapter then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

			return
		end

		if arg0_3.commanderVO:CanReset() then
			arg0_3.resetPanel:ExecuteAction("Show", arg0_3.commanderVO)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_time_no_rearch"))
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.useBtn, function()
		if arg0_3.inChapter then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

			return
		end

		if arg0_3.commanderVO:getTalentPoint() > 0 then
			arg0_3.usagePanel:ExecuteAction("Show", arg0_3.commanderVO)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_skill_point_noengough"))
		end
	end, SFX_PANEL)
end

function var0_0.RegisterEvent(arg0_6)
	arg0_6:bind(CommanderCatScene.EVENT_FOLD, function(arg0_7, arg1_7)
		if arg1_7 then
			LeanTween.moveX(rtf(arg0_6._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0_6._tf), -410, 0.5)
		end
	end)
	arg0_6:bind(CommanderCatScene.EVENT_SELECTED, function(arg0_8, arg1_8)
		arg0_6:Flush(arg1_8)
	end)
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)
	arg0_9:Flush(arg1_9)
end

function var0_0.Flush(arg0_10, arg1_10)
	arg0_10.commanderVO = arg1_10
	arg0_10.inChapter = CommanderCatUtil.CommanderInChapter(arg0_10.commanderVO)

	arg0_10:RemoveTimer()
	arg0_10:UpdatePoint()
	arg0_10:UpdateStyle()
	arg0_10:UpdateTimer()
	arg0_10:UpdateTalents()
end

function var0_0.UpdateTalents(arg0_11)
	local var0_11 = arg0_11.commanderVO
	local var1_11 = var0_11:GetDisplayTalents()

	arg0_11.uilist:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var1_11[arg1_12 + 1]

			arg0_11:UpdateTalentCard(arg2_12, var0_12)

			if var0_12 then
				setActive(arg2_12:Find("unlock/lock"), not var0_11:IsLearnedTalent(var0_12.id))
			end
		end
	end)
	arg0_11.uilist:align(CommanderConst.MAX_TELENT_COUNT)
end

function var0_0.UpdateTalentCard(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13:Find("unlock")
	local var1_13 = arg1_13:Find("lock")

	if arg2_13 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_13:getConfig("icon"), "", var0_13:Find("icon"))

		local var2_13 = var0_13:Find("tree_btn")

		if var2_13 then
			onButton(arg0_13, var2_13, function()
				arg0_13.contextData.treePanel:ExecuteAction("Show", arg2_13)
			end, SFX_PANEL)
		end

		setText(var0_13:Find("name_bg/Text"), arg2_13:getConfig("name"))
		setScrollText(var0_13:Find("desc/Text"), arg2_13:getConfig("desc"))
	end

	setActive(var0_13, arg2_13)

	if var1_13 then
		setActive(var1_13, not arg2_13)
	end
end

function var0_0.UpdateTimer(arg0_15)
	local var0_15 = arg0_15.commanderVO
	local var1_15 = var0_15:GetNextResetAbilityTime()
	local var2_15 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_15 = var0_15:getPt() > 0 or var2_15 < var1_15

	setActive(arg0_15.resetTimeBtn, var3_15)
	setActive(arg0_15.resetTimeTF, var3_15)
	arg0_15:AddTimer()
end

function var0_0.AddTimer(arg0_16)
	local var0_16 = arg0_16.commanderVO:GetNextResetAbilityTime()
	local var1_16 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_16 <= var1_16 then
		arg0_16.resetTimeTxt.text = i18n("commander_reset_talent")

		setActive(arg0_16.resetTimeTF, false)

		return
	end

	arg0_16.timer = Timer.New(function()
		var1_16 = pg.TimeMgr.GetInstance():GetServerTime()

		local var0_17 = var0_16 - var1_16

		if var0_17 > 0 then
			arg0_16.resetTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_17)
		else
			arg0_16.resetTimeTxt.text = i18n("commander_reset_talent")

			setActive(arg0_16.resetTimeTF, false)
		end
	end, 1, -1)

	arg0_16.timer:Start()
	arg0_16.timer.func()
end

function var0_0.UpdatePoint(arg0_18)
	local var0_18 = arg0_18.commanderVO

	arg0_18.pointTxt.text = var0_18:getTalentPoint()
end

function var0_0.UpdateStyle(arg0_19)
	local var0_19 = arg0_19.commanderVO

	setActive(arg0_19.resetFrame, not var0_19:IsRegularTalent())
end

function var0_0.RemoveTimer(arg0_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.CanBack(arg0_21)
	if arg0_21.usagePanel and arg0_21.usagePanel:GetLoaded() and arg0_21.usagePanel.CanBack and not arg0_21.usagePanel:CanBack() then
		return false
	end

	if arg0_21.usagePanel and arg0_21.usagePanel:GetLoaded() and arg0_21.usagePanel:isShowing() then
		arg0_21.usagePanel:Hide()

		return false
	end

	if arg0_21.resetPanel and arg0_21.resetPanel:GetLoaded() and arg0_21.resetPanel:isShowing() then
		arg0_21.resetPanel:Hide()

		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_22)
	arg0_22:RemoveTimer()

	if arg0_22.usagePanel then
		arg0_22.usagePanel:Destroy()

		arg0_22.usagePanel = nil
	end

	if arg0_22.resetPanel then
		arg0_22.resetPanel:Destroy()

		arg0_22.resetPanel = nil
	end
end

return var0_0
