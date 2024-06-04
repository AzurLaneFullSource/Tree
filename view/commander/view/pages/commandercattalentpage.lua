local var0 = class("CommanderCatTalentPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderCatTalentui"
end

function var0.OnLoaded(arg0)
	arg0.resetFrame = arg0:findTF("frame/point/reset_frame")
	arg0.resetTimeTF = arg0:findTF("frame/point/reset_frame/reset_time")
	arg0.resetTimeTxt = arg0:findTF("frame/point/reset_frame/reset_time/Text"):GetComponent(typeof(Text))
	arg0.resetTimeBtn = arg0:findTF("frame/point/reset_frame/reset_btn")
	arg0.pointTxt = arg0:findTF("frame/point/usage_frame/point/Text"):GetComponent(typeof(Text))
	arg0.useBtn = arg0:findTF("frame/point/usage_frame/use_btn")
	arg0.uilist = UIItemList.New(arg0:findTF("frame/talents/content"), arg0:findTF("frame/talents/content/talent_tpl"))
	arg0.resetPanel = CommanderResetTalentPage.New(arg0._parentTf, arg0.event, arg0.contextData)
	arg0.usagePanel = CommanderUsageTalentPage.New(arg0._parentTf, arg0.event, arg0.contextData)

	setText(arg0:findTF("frame/point/Text"), i18n("commander_level_up_tip"))
end

function var0.OnInit(arg0)
	arg0:RegisterEvent()
	onButton(arg0, arg0.resetTimeBtn, function()
		if arg0.commanderVO:IsSameTalent() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_is_not_need"))

			return
		end

		if arg0.inChapter then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

			return
		end

		if arg0.commanderVO:CanReset() then
			arg0.resetPanel:ExecuteAction("Show", arg0.commanderVO)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_time_no_rearch"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.useBtn, function()
		if arg0.inChapter then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

			return
		end

		if arg0.commanderVO:getTalentPoint() > 0 then
			arg0.usagePanel:ExecuteAction("Show", arg0.commanderVO)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_skill_point_noengough"))
		end
	end, SFX_PANEL)
end

function var0.RegisterEvent(arg0)
	arg0:bind(CommanderCatScene.EVENT_FOLD, function(arg0, arg1)
		if arg1 then
			LeanTween.moveX(rtf(arg0._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0._tf), -410, 0.5)
		end
	end)
	arg0:bind(CommanderCatScene.EVENT_SELECTED, function(arg0, arg1)
		arg0:Flush(arg1)
	end)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:Flush(arg1)
end

function var0.Flush(arg0, arg1)
	arg0.commanderVO = arg1
	arg0.inChapter = CommanderCatUtil.CommanderInChapter(arg0.commanderVO)

	arg0:RemoveTimer()
	arg0:UpdatePoint()
	arg0:UpdateStyle()
	arg0:UpdateTimer()
	arg0:UpdateTalents()
end

function var0.UpdateTalents(arg0)
	local var0 = arg0.commanderVO
	local var1 = var0:GetDisplayTalents()

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			arg0:UpdateTalentCard(arg2, var0)

			if var0 then
				setActive(arg2:Find("unlock/lock"), not var0:IsLearnedTalent(var0.id))
			end
		end
	end)
	arg0.uilist:align(CommanderConst.MAX_TELENT_COUNT)
end

function var0.UpdateTalentCard(arg0, arg1, arg2)
	local var0 = arg1:Find("unlock")
	local var1 = arg1:Find("lock")

	if arg2 then
		GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2:getConfig("icon"), "", var0:Find("icon"))

		local var2 = var0:Find("tree_btn")

		if var2 then
			onButton(arg0, var2, function()
				arg0.contextData.treePanel:ExecuteAction("Show", arg2)
			end, SFX_PANEL)
		end

		setText(var0:Find("name_bg/Text"), arg2:getConfig("name"))
		setScrollText(var0:Find("desc/Text"), arg2:getConfig("desc"))
	end

	setActive(var0, arg2)

	if var1 then
		setActive(var1, not arg2)
	end
end

function var0.UpdateTimer(arg0)
	local var0 = arg0.commanderVO
	local var1 = var0:GetNextResetAbilityTime()
	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = var0:getPt() > 0 or var2 < var1

	setActive(arg0.resetTimeBtn, var3)
	setActive(arg0.resetTimeTF, var3)
	arg0:AddTimer()
end

function var0.AddTimer(arg0)
	local var0 = arg0.commanderVO:GetNextResetAbilityTime()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0 <= var1 then
		arg0.resetTimeTxt.text = i18n("commander_reset_talent")

		setActive(arg0.resetTimeTF, false)

		return
	end

	arg0.timer = Timer.New(function()
		var1 = pg.TimeMgr.GetInstance():GetServerTime()

		local var0 = var0 - var1

		if var0 > 0 then
			arg0.resetTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		else
			arg0.resetTimeTxt.text = i18n("commander_reset_talent")

			setActive(arg0.resetTimeTF, false)
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.UpdatePoint(arg0)
	local var0 = arg0.commanderVO

	arg0.pointTxt.text = var0:getTalentPoint()
end

function var0.UpdateStyle(arg0)
	local var0 = arg0.commanderVO

	setActive(arg0.resetFrame, not var0:IsRegularTalent())
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.CanBack(arg0)
	if arg0.usagePanel and arg0.usagePanel:GetLoaded() and arg0.usagePanel.CanBack and not arg0.usagePanel:CanBack() then
		return false
	end

	if arg0.usagePanel and arg0.usagePanel:GetLoaded() and arg0.usagePanel:isShowing() then
		arg0.usagePanel:Hide()

		return false
	end

	if arg0.resetPanel and arg0.resetPanel:GetLoaded() and arg0.resetPanel:isShowing() then
		arg0.resetPanel:Hide()

		return false
	end

	return true
end

function var0.OnDestroy(arg0)
	arg0:RemoveTimer()

	if arg0.usagePanel then
		arg0.usagePanel:Destroy()

		arg0.usagePanel = nil
	end

	if arg0.resetPanel then
		arg0.resetPanel:Destroy()

		arg0.resetPanel = nil
	end
end

return var0
