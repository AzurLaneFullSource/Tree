local var0_0 = class("ChapterAutoDetailPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ChapterAutoDetailPanel"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTitleText, i18n("auto_battle_headline"))
	setText(arg0_2.uiCommonHeaderText, i18n("auto_battle_ing_base_loot"))
	setText(arg0_2.uiExtraHeaderText, i18n("auto_battle_extra_loot"))
	setText(arg0_2.uiProficiencyHeaderText, i18n("auto_battle_class_exp_head"))
	setText(arg0_2.uiStopBtnText, i18n("auto_battle_ing_stop"))
	setText(arg0_2.uiGetBtnText, i18n("auto_battle_ing_finish"))

	arg0_2.awardUIList = UIItemList.New(arg0_2.uiAwardTF, arg0_2.uiAwardTF:Find("item"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.awardUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateAwardTpl(arg1_4, arg2_4)
		end
	end)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiStopBtn, function()
		arg0_3:OnClickBtn()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiGetBtn, function()
		arg0_3:OnClickBtn()
	end, SFX_PANEL)
end

function var0_0.OnClickBtn(arg0_9)
	local var0_9 = getProxy(ChapterAutoProxy):GetFinishedCnt()

	pg.m02:sendNotification(GAME.END_CHAPTER_AUTO, {
		num = var0_9
	})
	arg0_9:Hide()
end

function var0_0.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
	var0_0.super.Show(arg0_10)
end

function var0_0.Enter(arg0_11, arg1_11)
	arg0_11.chapter = arg1_11

	local var0_11 = arg0_11.chapter:getConfig("icon")

	if var0_11 and var0_11[1] then
		setActive(arg0_11.uiHeadTF, true)
		setImageSprite(arg0_11.uiHeadTF:Find("Image"), LoadSprite("qicon/" .. var0_11[1]))
	else
		setActive(arg0_11.uiHeadTF, false)
	end

	setText(arg0_11.uiNameText, arg0_11.chapter:getConfig("name"))

	local var1_11 = getProxy(ChapterAutoProxy)

	arg0_11.finishTime = var1_11:GetFinishAllCommissionTime()

	local var2_11 = var1_11:GetCommissionList()

	arg0_11.proficiencyOnce = var2_11[1]:GetClassExpAward()

	setText(arg0_11.uiProficiencyText, arg0_11.proficiencyOnce)

	arg0_11.awards = var0_0.GetAwards(arg0_11.chapter)

	arg0_11.awardUIList:align(#arg0_11.awards)

	local var3_11 = underscore.any(var2_11, function(arg0_12)
		return arg0_12:UsedTicket()
	end)

	setActive(arg0_11.uiDropFrameTF:Find("scroll"), var3_11)
	setActive(arg0_11.uiDropFrameTF:Find("empty"), not var3_11)

	if pg.TimeMgr.GetInstance():GetServerTime() < arg0_11.finishTime then
		arg0_11:StartTimer()
	else
		arg0_11:UpdateContent()
	end

	arg0_11:Show()
end

function var0_0.StartTimer(arg0_13)
	arg0_13:StopTimer()

	arg0_13.timer = Timer.New(function()
		arg0_13:UpdateContent()
	end, 1, -1)

	arg0_13.timer:Start()
	arg0_13.timer.func()
end

function var0_0.UpdateContent(arg0_15)
	local var0_15 = pg.TimeMgr.GetInstance()
	local var1_15 = arg0_15.finishTime - var0_15:GetServerTime()

	setText(arg0_15.uiTimeText, i18n("auto_battle_ing_time", var1_15 > 0 and var0_15:DescCDTime(var1_15) or "00:00:00"))

	local var2_15, var3_15 = getProxy(ChapterAutoProxy):GetCntInfo()

	setText(arg0_15.uiCountText, i18n("auto_battle_ing_cnt", var2_15, var3_15))
	setActive(arg0_15.uiStopBtn, var2_15 < var3_15)
	setActive(arg0_15.uiGetBtn, var2_15 == var3_15)
end

function var0_0.StopTimer(arg0_16)
	if arg0_16.timer then
		arg0_16.timer:Stop()

		arg0_16.timer = nil
	end
end

function var0_0.UpdateAwardTpl(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.awards[arg1_17 + 1]
	local var1_17 = Drop.Create(var0_17)

	updateDrop(arg2_17, var1_17)
	onButton(arg0_17, arg2_17, function()
		if ({
			[99] = true
		})[var1_17:getConfig("type")] then
			local function var0_18(arg0_19)
				local var0_19 = var1_17:getConfig("display_icon")
				local var1_19 = {}

				for iter0_19, iter1_19 in ipairs(var0_19) do
					local var2_19 = iter1_19[1]
					local var3_19 = iter1_19[2]
					local var4_19 = var2_19 == DROP_TYPE_SHIP and not table.contains(arg0_19, var3_19)

					var1_19[#var1_19 + 1] = {
						type = var2_19,
						id = var3_19,
						anonymous = var4_19
					}
				end

				arg0_17:emit(BaseUI.ON_DROP_LIST, {
					item2Row = true,
					itemList = var1_19,
					content = var1_17:getConfig("display")
				})
			end

			arg0_17:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_17.chapter.id, var0_18)
		else
			arg0_17:emit(BaseUI.ON_DROP, var1_17)
		end
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_20)
	arg0_20:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20._tf, arg0_20._parentTf)
	var0_0.super.Hide(arg0_20)
end

function var0_0.OnDestroy(arg0_21)
	arg0_21:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._tf, arg0_21._parentTf)
end

function var0_0.GetAwards(arg0_22)
	local var0_22 = LevelInfoView.getChapterAwards(arg0_22)
	local var1_22 = pg.chapter_auto_statistics[arg0_22.id].drop_display_extra

	if type(var1_22) == "table" then
		for iter0_22, iter1_22 in ipairs(var1_22) do
			table.insert(var0_22, {
				iter1_22[1],
				iter1_22[2]
			})
		end
	end

	return var0_22
end

return var0_0
