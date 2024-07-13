local var0_0 = class("VoteEntranceScene", import("view.base.BaseUI"))

var0_0.MAIN_STAGE_CLOSE = 0
var0_0.MAIN_STAGE_OPEN = 1
var0_0.MAIN_STAGE_FINAL = 2
var0_0.MAIN_STAGE_END = 3
var0_0.SUB_STAGE_CLOSE = 0
var0_0.SUB_STAGE_META = 1
var0_0.SUB_STAGE_KID = 2
var0_0.SUB_STAGE_SIREN = 3
var0_0.EXCHANGE_STAGE_CLOSE = 0
var0_0.EXCHANGE_STAGE_OPEN = 1
var0_0.BILLBOARD_STAGE_NORMAL = 0
var0_0.BILLBOARD_STAGE_FINAL = 1

function var0_0.getUIName(arg0_1)
	return "VoteEntranceUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("frame/back")
	arg0_2.homeBtn = arg0_2:findTF("frame/home")
	arg0_2.helpBtn = arg0_2:findTF("frame/help")
	arg0_2.votesTr = arg0_2:findTF("frame/votes")
	arg0_2.votesTxt = arg0_2:findTF("frame/votes/Text"):GetComponent(typeof(Text))
	arg0_2.scheduleTr = arg0_2:findTF("frame/schedule")
	arg0_2.scheduleTxt = arg0_2.scheduleTr:Find("Text"):GetComponent(typeof(Text))
	arg0_2.scheduleImg = arg0_2.scheduleTr:GetComponent(typeof(Image))
	arg0_2.awardBtn = arg0_2:findTF("frame/award")
	arg0_2.mainTr = arg0_2:findTF("bg/main"):GetComponent(typeof(Image))
	arg0_2.mainTip = arg0_2.mainTr.gameObject.transform:Find("tip")
	arg0_2.mainTitle = arg0_2.mainTr.gameObject.transform:Find("title")
	arg0_2.awardItem = arg0_2:findTF("bg/main/item")
	arg0_2.dropTr = arg0_2.awardItem:Find("Award")
	arg0_2.dropGetTr = arg0_2.awardItem:Find("get")
	arg0_2.dropGotTr = arg0_2.awardItem:Find("got")
	arg0_2.subTr = arg0_2:findTF("bg/sub"):GetComponent(typeof(Image))
	arg0_2.subTip = arg0_2.subTr.gameObject.transform:Find("tip")
	arg0_2.subTitle = arg0_2.subTr.gameObject.transform:Find("title")
	arg0_2.exchangeTr = arg0_2:findTF("bg/exchange"):GetComponent(typeof(Image))
	arg0_2.exchangeTip = arg0_2.exchangeTr.gameObject.transform:Find("tip")
	arg0_2.exchangeTitle = arg0_2.exchangeTr.gameObject.transform:Find("title")
	arg0_2.billboardTr = arg0_2:findTF("bg/billboard"):GetComponent(typeof(Image))
	arg0_2.billboardTip = arg0_2.billboardTr.gameObject.transform:Find("tip")
	arg0_2.honorTr = arg0_2:findTF("bg/honor"):GetComponent(typeof(Image))
	arg0_2.honorTip = arg0_2.honorTr.gameObject.transform:Find("tip")
	arg0_2.awardWindowPage = VoteAwardWindowPage.New(arg0_2._tf, arg0_2.event)

	VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SCENE)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.vote_help_2023.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.awardBtn, function()
		arg0_3.awardWindowPage:ExecuteAction("Show")
	end, SFX_PANEL)

	arg0_3.voteActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	arg0_3:FlushAll()
end

function var0_0.FlushAll(arg0_8)
	arg0_8.allPreheatStoriesPlayed = VoteStoryUtil.AllPreheatStoriesPlayed()

	arg0_8:UpdateSchedule()
	arg0_8:UpdateVotes()
	arg0_8:UpdateMainEntrance()
	arg0_8:UpdateSubEntrance()
	arg0_8:UpdateExchangeEntrance()
	arg0_8:UpdateBillboardEntrance()
	arg0_8:UpdateHonorEntrance()
end

function var0_0.UpdateSchedule(arg0_9)
	if not arg0_9.allPreheatStoriesPlayed then
		setActive(arg0_9.scheduleTr, false)

		return
	end

	local var0_9 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

	setActive(arg0_9.scheduleTr, var0_9 ~= nil)

	if var0_9 then
		arg0_9.scheduleTxt.text = var0_9:getConfig("name")
	end

	local var1_9 = "schedule_bg"

	if var0_9 and var0_9:isFinalsRace() then
		var1_9 = "schedule_bg_finals"
	elseif var0_9 and var0_9:isResurrectionRace() then
		var1_9 = "schedule_bg_resurrection"
	elseif var0_9 and var0_9:IsFunMetaRace() then
		var1_9 = "schedule_bg_meta"
	elseif var0_9 and var0_9:IsFunSireRace() then
		var1_9 = "schedule_bg_sire"
	elseif var0_9 and var0_9:IsFunKidRace() then
		var1_9 = "schedule_bg_kid"
	end

	arg0_9.scheduleImg.sprite = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", var1_9)
end

function var0_0.UpdateVotes(arg0_10)
	if not arg0_10.allPreheatStoriesPlayed then
		setActive(arg0_10.votesTr, false)
		setActive(arg0_10.awardBtn, false)

		return
	end

	setActive(arg0_10.awardBtn, not getProxy(VoteProxy):IsAllRaceEnd())

	local var0_10 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

	setActive(arg0_10.votesTr, var0_10 ~= nil)

	if var0_10 and var0_10:IsFunRace() then
		arg0_10.votesTxt.text = arg0_10:GetSubVotes()
	else
		arg0_10.votesTxt.text = arg0_10:GetVotes()
	end
end

function var0_0.UpdateMainEntrance(arg0_11)
	local var0_11 = arg0_11:GetMainStageState()
	local var1_11 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_main_" .. var0_11)

	arg0_11.mainTr.sprite = var1_11

	onButton(arg0_11, arg0_11.mainTr.gameObject, function()
		local var0_12 = arg0_11:ShouldPlayMainStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_MAIN_STAGE)

		if var0_12 then
			return
		end

		if not arg0_11:CheckPreheatStories() then
			return
		end

		arg0_11:MarkMainRaceNonNew()

		if arg0_11:ExistMainStageAward() then
			arg0_11:emit(VoteEntranceMediator.SUBMIT_TASK)

			return
		end

		arg0_11:emit(VoteEntranceMediator.ON_VOTE)
	end, SFX_PANEL)
	arg0_11:UpdateMainAward()

	local var2_11 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var3_11 = var2_11 and var2_11:IsOpening() or arg0_11:ExistMainStageAward() or arg0_11:ShouldPlayMainStory()

	setGray(arg0_11.mainTitle, not var3_11, true)
	arg0_11:UpdateMainStageTip()
end

function var0_0.UpdateMainAward(arg0_13)
	local var0_13 = arg0_13:GetMainStageState() == var0_0.MAIN_STAGE_END
	local var1_13 = false

	if var0_13 then
		local var2_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID):getConfig("config_client")[2] or -1
		local var3_13 = pg.task_data_template[var2_13].award_display

		updateDrop(arg0_13.dropTr, {
			type = var3_13[1][1],
			id = var3_13[1][2],
			count = var3_13[1][3]
		})

		local var4_13 = getProxy(TaskProxy):getTaskById(var2_13) or getProxy(TaskProxy):getFinishTaskById(var2_13)

		var1_13 = var4_13 and var4_13:isFinish()

		setActive(arg0_13.dropGetTr, var4_13 and var4_13:isFinish() and not var4_13:isReceive())
		setActive(arg0_13.dropGotTr, var4_13 and var4_13:isFinish() and var4_13:isReceive())
	end

	setActive(arg0_13.awardItem, var0_13 and var1_13)
end

function var0_0.UpdateMainStageTip(arg0_14)
	setActive(arg0_14.mainTip, arg0_14:ShouldTipMainStage())
end

function var0_0.UpdateSubEntrance(arg0_15)
	local var0_15 = arg0_15:GetSubStageState()
	local var1_15 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_sub_" .. var0_15)

	arg0_15.subTr.sprite = var1_15

	arg0_15:UpdateSubStageTip()
	onButton(arg0_15, arg0_15.subTr.gameObject, function()
		local var0_16 = arg0_15:ShouldPlaySubStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SUB_STAGE)

		if var0_16 then
			return
		end

		if not arg0_15:CheckPreheatStories() then
			return
		end

		arg0_15:MarkSubRaceNonNew()
		arg0_15:emit(VoteEntranceMediator.ON_FUN_VOTE)
	end, SFX_PANEL)

	local var2_15 = getProxy(VoteProxy):GetOpeningFunVoteGroup()
	local var3_15 = var2_15 and var2_15:IsOpening() or arg0_15:ShouldPlaySubStory()

	setGray(arg0_15.subTitle, not var3_15, true)
end

function var0_0.UpdateSubStageTip(arg0_17)
	setActive(arg0_17.subTip, arg0_17:ShouldTipSubStage())
end

function var0_0.UpdateExchangeEntrance(arg0_18)
	local var0_18 = arg0_18:GetExchangeState()
	local var1_18 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_exchange_" .. var0_18)

	arg0_18.exchangeTr.sprite = var1_18

	arg0_18:UpdateExchangeTip()
	onButton(arg0_18, arg0_18.exchangeTr.gameObject, function()
		local var0_19 = arg0_18:ShouldPlayExchangeStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_EXCHANGE)

		if var0_19 then
			return
		end

		if not arg0_18:CheckPreheatStories() then
			return
		end

		if getProxy(PlayerProxy):getRawData().level < 25 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_level_limit"))

			return
		end

		arg0_18:emit(VoteEntranceMediator.ON_EXCHANGE)
	end, SFX_PANEL)

	local var2_18 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var3_18 = var2_18 and var2_18:IsOpening() or arg0_18:ShouldPlayExchangeStory()

	setGray(arg0_18.exchangeTitle, not var3_18, true)
end

function var0_0.UpdateExchangeTip(arg0_20)
	setActive(arg0_20.exchangeTip, arg0_20:ShouldTipExchange())
end

function var0_0.UpdateBillboardEntrance(arg0_21)
	local var0_21 = arg0_21:GetBillboardState()
	local var1_21 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_billboard_" .. var0_21)

	arg0_21.billboardTr.sprite = var1_21

	arg0_21:UpdateBillboardTip()
	onButton(arg0_21, arg0_21.billboardTr.gameObject, function()
		local var0_22 = arg0_21:ShouldPlayBillboardStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SCHEDULE)

		if var0_22 then
			return
		end

		if not arg0_21:CheckPreheatStories() then
			return
		end

		arg0_21:emit(VoteEntranceMediator.ON_SCHEDULE)
	end, SFX_PANEL)
end

function var0_0.UpdateBillboardTip(arg0_23)
	setActive(arg0_23.billboardTip, arg0_23:ShouldTipBillboard())
end

function var0_0.UpdateHonorEntrance(arg0_24)
	arg0_24:UpdateHonorTip()
	onButton(arg0_24, arg0_24.honorTr.gameObject, function()
		local var0_25 = arg0_24:ShouldPlayHonorStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_HALL)

		if var0_25 then
			return
		end

		if not arg0_24:CheckPreheatStories() then
			return
		end

		arg0_24:emit(VoteEntranceMediator.GO_HALL)
	end, SFX_PANEL)
end

function var0_0.UpdateHonorTip(arg0_26)
	setActive(arg0_26.honorTip, arg0_26:ShouldTipHonor())
end

function var0_0.onBackPressed(arg0_27)
	if arg0_27.awardWindowPage and arg0_27.awardWindowPage:GetLoaded() and arg0_27.awardWindowPage:isShowing() then
		arg0_27.awardWindowPage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_27)
end

function var0_0.willExit(arg0_28)
	if arg0_28.awardWindowPage then
		arg0_28.awardWindowPage:Destroy()

		arg0_28.awardWindowPage = nil
	end
end

function var0_0.ExistMainStageAward(arg0_29)
	local var0_29 = getProxy(TaskProxy)
	local var1_29 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var1_29 or var1_29:isEnd() then
		return false
	end

	local var2_29 = var1_29:getConfig("config_client")[2] or -1
	local var3_29 = var0_29:getTaskById(var2_29) or var0_29:getFinishTaskById(var2_29)

	return var3_29 and var3_29:isFinish() and not var3_29:isReceive()
end

function var0_0.GetMainStageState(arg0_30)
	if not arg0_30.allPreheatStoriesPlayed then
		return var0_0.MAIN_STAGE_CLOSE
	end

	local var0_30 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var1_30 = not var0_30

	if getProxy(VoteProxy):IsAllRaceEnd() then
		return var0_0.MAIN_STAGE_END
	elseif var0_30 then
		if var0_30:isFinalsRace() then
			return var0_0.MAIN_STAGE_FINAL
		else
			return var0_0.MAIN_STAGE_OPEN
		end
	else
		return var0_0.MAIN_STAGE_CLOSE
	end
end

function var0_0.ShouldTipMainStage(arg0_31)
	if not arg0_31.allPreheatStoriesPlayed then
		return arg0_31:ShouldPlayMainStory()
	else
		return arg0_31:GetVotes() > 0 or arg0_31:IsNewMainRace() or arg0_31:ShouldPlayMainStory() or isActive(arg0_31.dropGetTr)
	end
end

function var0_0.ShouldPlayMainStory(arg0_32)
	local var0_32 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_MAIN_STAGE)

	return arg0_32.voteActivity and not arg0_32.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_32)
end

function var0_0.IsNewMainRace(arg0_33)
	local var0_33 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	return getProxy(VoteProxy):IsNewRace(var0_33)
end

function var0_0.MarkMainRaceNonNew(arg0_34)
	local var0_34 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	getProxy(VoteProxy):MarkRaceNonNew(var0_34)
end

function var0_0.GetSubStageState(arg0_35)
	if not arg0_35.allPreheatStoriesPlayed then
		return var0_0.SUB_STAGE_CLOSE
	end

	local var0_35 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	if var0_35 then
		if var0_35:IsFunSireRace() then
			return var0_0.SUB_STAGE_SIREN
		elseif var0_35:IsFunMetaRace() then
			return var0_0.SUB_STAGE_META
		elseif var0_35:IsFunKidRace() then
			return var0_0.SUB_STAGE_KID
		else
			assert(false)
		end
	else
		return var0_0.SUB_STAGE_CLOSE
	end
end

function var0_0.ShouldTipSubStage(arg0_36)
	if not arg0_36.allPreheatStoriesPlayed then
		return arg0_36:ShouldPlaySubStory()
	else
		return arg0_36:GetSubVotes() > 0 or arg0_36:IsNewSubRace() or arg0_36:ShouldPlaySubStory()
	end
end

function var0_0.ShouldPlaySubStory(arg0_37)
	local var0_37 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_SUB_STAGE)

	return arg0_37.voteActivity and not arg0_37.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_37)
end

function var0_0.IsNewSubRace(arg0_38)
	local var0_38 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	return getProxy(VoteProxy):IsNewRace(var0_38)
end

function var0_0.MarkSubRaceNonNew(arg0_39)
	local var0_39 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	getProxy(VoteProxy):MarkRaceNonNew(var0_39)
end

function var0_0.GetExchangeState(arg0_40)
	if not arg0_40.allPreheatStoriesPlayed then
		return var0_0.EXCHANGE_STAGE_CLOSE
	end

	if getProxy(VoteProxy):GetOpeningNonFunVoteGroup() then
		return var0_0.EXCHANGE_STAGE_OPEN
	else
		return var0_0.EXCHANGE_STAGE_CLOSE
	end
end

function var0_0.ShouldTipExchange(arg0_41)
	return arg0_41:ShouldPlayExchangeStory()
end

function var0_0.ShouldPlayExchangeStory(arg0_42)
	local var0_42 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_EXCHANGE)

	return arg0_42.voteActivity and not arg0_42.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_42)
end

function var0_0.GetBillboardState(arg0_43)
	if not arg0_43.allPreheatStoriesPlayed then
		return var0_0.BILLBOARD_STAGE_NORMAL
	end

	local var0_43 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	if var0_43 and var0_43:isFinalsRace() then
		return var0_0.BILLBOARD_STAGE_FINAL
	else
		return var0_0.BILLBOARD_STAGE_NORMAL
	end
end

function var0_0.ShouldTipBillboard(arg0_44)
	return arg0_44:ShouldPlayBillboardStory()
end

function var0_0.ShouldPlayBillboardStory(arg0_45)
	local var0_45 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_SCHEDULE)

	return arg0_45.voteActivity and not arg0_45.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_45)
end

function var0_0.ShouldTipHonor(arg0_46)
	if not arg0_46.allPreheatStoriesPlayed then
		return arg0_46:ShouldPlayHonorStory()
	else
		return getProxy(VoteProxy):ExistPastVoteAward() or arg0_46:ShouldPlayHonorStory()
	end
end

function var0_0.ShouldPlayHonorStory(arg0_47)
	local var0_47 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_HALL)

	return arg0_47.voteActivity and not arg0_47.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_47)
end

function var0_0.GetVotes(arg0_48)
	local var0_48 = arg0_48:GetMainStageState()

	if var0_48 == var0_0.MAIN_STAGE_OPEN or var0_48 == var0_0.MAIN_STAGE_FINAL then
		local var1_48 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		return var1_48 and getProxy(VoteProxy):GetVotesByConfigId(var1_48.configId) or 0
	end

	return 0
end

function var0_0.GetSubVotes(arg0_49)
	if var0_0.SUB_STAGE_CLOSE ~= arg0_49:GetSubStageState() then
		local var0_49 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

		return var0_49 and getProxy(VoteProxy):GetVotesByConfigId(var0_49.configId) or 0
	else
		return 0
	end
end

function var0_0.CheckPreheatStories(arg0_50)
	if not arg0_50.allPreheatStoriesPlayed then
		pg.NewGuideMgr.GetInstance():Play("NG0043")

		return false
	end

	return true
end

return var0_0
