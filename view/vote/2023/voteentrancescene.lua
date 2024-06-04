local var0 = class("VoteEntranceScene", import("view.base.BaseUI"))

var0.MAIN_STAGE_CLOSE = 0
var0.MAIN_STAGE_OPEN = 1
var0.MAIN_STAGE_FINAL = 2
var0.MAIN_STAGE_END = 3
var0.SUB_STAGE_CLOSE = 0
var0.SUB_STAGE_META = 1
var0.SUB_STAGE_KID = 2
var0.SUB_STAGE_SIREN = 3
var0.EXCHANGE_STAGE_CLOSE = 0
var0.EXCHANGE_STAGE_OPEN = 1
var0.BILLBOARD_STAGE_NORMAL = 0
var0.BILLBOARD_STAGE_FINAL = 1

function var0.getUIName(arg0)
	return "VoteEntranceUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("frame/back")
	arg0.homeBtn = arg0:findTF("frame/home")
	arg0.helpBtn = arg0:findTF("frame/help")
	arg0.votesTr = arg0:findTF("frame/votes")
	arg0.votesTxt = arg0:findTF("frame/votes/Text"):GetComponent(typeof(Text))
	arg0.scheduleTr = arg0:findTF("frame/schedule")
	arg0.scheduleTxt = arg0.scheduleTr:Find("Text"):GetComponent(typeof(Text))
	arg0.scheduleImg = arg0.scheduleTr:GetComponent(typeof(Image))
	arg0.awardBtn = arg0:findTF("frame/award")
	arg0.mainTr = arg0:findTF("bg/main"):GetComponent(typeof(Image))
	arg0.mainTip = arg0.mainTr.gameObject.transform:Find("tip")
	arg0.mainTitle = arg0.mainTr.gameObject.transform:Find("title")
	arg0.awardItem = arg0:findTF("bg/main/item")
	arg0.dropTr = arg0.awardItem:Find("Award")
	arg0.dropGetTr = arg0.awardItem:Find("get")
	arg0.dropGotTr = arg0.awardItem:Find("got")
	arg0.subTr = arg0:findTF("bg/sub"):GetComponent(typeof(Image))
	arg0.subTip = arg0.subTr.gameObject.transform:Find("tip")
	arg0.subTitle = arg0.subTr.gameObject.transform:Find("title")
	arg0.exchangeTr = arg0:findTF("bg/exchange"):GetComponent(typeof(Image))
	arg0.exchangeTip = arg0.exchangeTr.gameObject.transform:Find("tip")
	arg0.exchangeTitle = arg0.exchangeTr.gameObject.transform:Find("title")
	arg0.billboardTr = arg0:findTF("bg/billboard"):GetComponent(typeof(Image))
	arg0.billboardTip = arg0.billboardTr.gameObject.transform:Find("tip")
	arg0.honorTr = arg0:findTF("bg/honor"):GetComponent(typeof(Image))
	arg0.honorTip = arg0.honorTr.gameObject.transform:Find("tip")
	arg0.awardWindowPage = VoteAwardWindowPage.New(arg0._tf, arg0.event)

	VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SCENE)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.vote_help_2023.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.awardBtn, function()
		arg0.awardWindowPage:ExecuteAction("Show")
	end, SFX_PANEL)

	arg0.voteActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	arg0:FlushAll()
end

function var0.FlushAll(arg0)
	arg0.allPreheatStoriesPlayed = VoteStoryUtil.AllPreheatStoriesPlayed()

	arg0:UpdateSchedule()
	arg0:UpdateVotes()
	arg0:UpdateMainEntrance()
	arg0:UpdateSubEntrance()
	arg0:UpdateExchangeEntrance()
	arg0:UpdateBillboardEntrance()
	arg0:UpdateHonorEntrance()
end

function var0.UpdateSchedule(arg0)
	if not arg0.allPreheatStoriesPlayed then
		setActive(arg0.scheduleTr, false)

		return
	end

	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

	setActive(arg0.scheduleTr, var0 ~= nil)

	if var0 then
		arg0.scheduleTxt.text = var0:getConfig("name")
	end

	local var1 = "schedule_bg"

	if var0 and var0:isFinalsRace() then
		var1 = "schedule_bg_finals"
	elseif var0 and var0:isResurrectionRace() then
		var1 = "schedule_bg_resurrection"
	elseif var0 and var0:IsFunMetaRace() then
		var1 = "schedule_bg_meta"
	elseif var0 and var0:IsFunSireRace() then
		var1 = "schedule_bg_sire"
	elseif var0 and var0:IsFunKidRace() then
		var1 = "schedule_bg_kid"
	end

	arg0.scheduleImg.sprite = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", var1)
end

function var0.UpdateVotes(arg0)
	if not arg0.allPreheatStoriesPlayed then
		setActive(arg0.votesTr, false)
		setActive(arg0.awardBtn, false)

		return
	end

	setActive(arg0.awardBtn, not getProxy(VoteProxy):IsAllRaceEnd())

	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

	setActive(arg0.votesTr, var0 ~= nil)

	if var0 and var0:IsFunRace() then
		arg0.votesTxt.text = arg0:GetSubVotes()
	else
		arg0.votesTxt.text = arg0:GetVotes()
	end
end

function var0.UpdateMainEntrance(arg0)
	local var0 = arg0:GetMainStageState()
	local var1 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_main_" .. var0)

	arg0.mainTr.sprite = var1

	onButton(arg0, arg0.mainTr.gameObject, function()
		local var0 = arg0:ShouldPlayMainStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_MAIN_STAGE)

		if var0 then
			return
		end

		if not arg0:CheckPreheatStories() then
			return
		end

		arg0:MarkMainRaceNonNew()

		if arg0:ExistMainStageAward() then
			arg0:emit(VoteEntranceMediator.SUBMIT_TASK)

			return
		end

		arg0:emit(VoteEntranceMediator.ON_VOTE)
	end, SFX_PANEL)
	arg0:UpdateMainAward()

	local var2 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var3 = var2 and var2:IsOpening() or arg0:ExistMainStageAward() or arg0:ShouldPlayMainStory()

	setGray(arg0.mainTitle, not var3, true)
	arg0:UpdateMainStageTip()
end

function var0.UpdateMainAward(arg0)
	local var0 = arg0:GetMainStageState() == var0.MAIN_STAGE_END
	local var1 = false

	if var0 then
		local var2 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID):getConfig("config_client")[2] or -1
		local var3 = pg.task_data_template[var2].award_display

		updateDrop(arg0.dropTr, {
			type = var3[1][1],
			id = var3[1][2],
			count = var3[1][3]
		})

		local var4 = getProxy(TaskProxy):getTaskById(var2) or getProxy(TaskProxy):getFinishTaskById(var2)

		var1 = var4 and var4:isFinish()

		setActive(arg0.dropGetTr, var4 and var4:isFinish() and not var4:isReceive())
		setActive(arg0.dropGotTr, var4 and var4:isFinish() and var4:isReceive())
	end

	setActive(arg0.awardItem, var0 and var1)
end

function var0.UpdateMainStageTip(arg0)
	setActive(arg0.mainTip, arg0:ShouldTipMainStage())
end

function var0.UpdateSubEntrance(arg0)
	local var0 = arg0:GetSubStageState()
	local var1 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_sub_" .. var0)

	arg0.subTr.sprite = var1

	arg0:UpdateSubStageTip()
	onButton(arg0, arg0.subTr.gameObject, function()
		local var0 = arg0:ShouldPlaySubStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SUB_STAGE)

		if var0 then
			return
		end

		if not arg0:CheckPreheatStories() then
			return
		end

		arg0:MarkSubRaceNonNew()
		arg0:emit(VoteEntranceMediator.ON_FUN_VOTE)
	end, SFX_PANEL)

	local var2 = getProxy(VoteProxy):GetOpeningFunVoteGroup()
	local var3 = var2 and var2:IsOpening() or arg0:ShouldPlaySubStory()

	setGray(arg0.subTitle, not var3, true)
end

function var0.UpdateSubStageTip(arg0)
	setActive(arg0.subTip, arg0:ShouldTipSubStage())
end

function var0.UpdateExchangeEntrance(arg0)
	local var0 = arg0:GetExchangeState()
	local var1 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_exchange_" .. var0)

	arg0.exchangeTr.sprite = var1

	arg0:UpdateExchangeTip()
	onButton(arg0, arg0.exchangeTr.gameObject, function()
		local var0 = arg0:ShouldPlayExchangeStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_EXCHANGE)

		if var0 then
			return
		end

		if not arg0:CheckPreheatStories() then
			return
		end

		if getProxy(PlayerProxy):getRawData().level < 25 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_level_limit"))

			return
		end

		arg0:emit(VoteEntranceMediator.ON_EXCHANGE)
	end, SFX_PANEL)

	local var2 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var3 = var2 and var2:IsOpening() or arg0:ShouldPlayExchangeStory()

	setGray(arg0.exchangeTitle, not var3, true)
end

function var0.UpdateExchangeTip(arg0)
	setActive(arg0.exchangeTip, arg0:ShouldTipExchange())
end

function var0.UpdateBillboardEntrance(arg0)
	local var0 = arg0:GetBillboardState()
	local var1 = GetSpriteFromAtlas("ui/Vote2023MainUI_atlas", "icon_billboard_" .. var0)

	arg0.billboardTr.sprite = var1

	arg0:UpdateBillboardTip()
	onButton(arg0, arg0.billboardTr.gameObject, function()
		local var0 = arg0:ShouldPlayBillboardStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_SCHEDULE)

		if var0 then
			return
		end

		if not arg0:CheckPreheatStories() then
			return
		end

		arg0:emit(VoteEntranceMediator.ON_SCHEDULE)
	end, SFX_PANEL)
end

function var0.UpdateBillboardTip(arg0)
	setActive(arg0.billboardTip, arg0:ShouldTipBillboard())
end

function var0.UpdateHonorEntrance(arg0)
	arg0:UpdateHonorTip()
	onButton(arg0, arg0.honorTr.gameObject, function()
		local var0 = arg0:ShouldPlayHonorStory()

		VoteStoryUtil.Notify(VoteStoryUtil.ENTER_HALL)

		if var0 then
			return
		end

		if not arg0:CheckPreheatStories() then
			return
		end

		arg0:emit(VoteEntranceMediator.GO_HALL)
	end, SFX_PANEL)
end

function var0.UpdateHonorTip(arg0)
	setActive(arg0.honorTip, arg0:ShouldTipHonor())
end

function var0.onBackPressed(arg0)
	if arg0.awardWindowPage and arg0.awardWindowPage:GetLoaded() and arg0.awardWindowPage:isShowing() then
		arg0.awardWindowPage:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.awardWindowPage then
		arg0.awardWindowPage:Destroy()

		arg0.awardWindowPage = nil
	end
end

function var0.ExistMainStageAward(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var1 or var1:isEnd() then
		return false
	end

	local var2 = var1:getConfig("config_client")[2] or -1
	local var3 = var0:getTaskById(var2) or var0:getFinishTaskById(var2)

	return var3 and var3:isFinish() and not var3:isReceive()
end

function var0.GetMainStageState(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return var0.MAIN_STAGE_CLOSE
	end

	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()
	local var1 = not var0

	if getProxy(VoteProxy):IsAllRaceEnd() then
		return var0.MAIN_STAGE_END
	elseif var0 then
		if var0:isFinalsRace() then
			return var0.MAIN_STAGE_FINAL
		else
			return var0.MAIN_STAGE_OPEN
		end
	else
		return var0.MAIN_STAGE_CLOSE
	end
end

function var0.ShouldTipMainStage(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return arg0:ShouldPlayMainStory()
	else
		return arg0:GetVotes() > 0 or arg0:IsNewMainRace() or arg0:ShouldPlayMainStory() or isActive(arg0.dropGetTr)
	end
end

function var0.ShouldPlayMainStory(arg0)
	local var0 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_MAIN_STAGE)

	return arg0.voteActivity and not arg0.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0)
end

function var0.IsNewMainRace(arg0)
	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	return getProxy(VoteProxy):IsNewRace(var0)
end

function var0.MarkMainRaceNonNew(arg0)
	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	getProxy(VoteProxy):MarkRaceNonNew(var0)
end

function var0.GetSubStageState(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return var0.SUB_STAGE_CLOSE
	end

	local var0 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	if var0 then
		if var0:IsFunSireRace() then
			return var0.SUB_STAGE_SIREN
		elseif var0:IsFunMetaRace() then
			return var0.SUB_STAGE_META
		elseif var0:IsFunKidRace() then
			return var0.SUB_STAGE_KID
		else
			assert(false)
		end
	else
		return var0.SUB_STAGE_CLOSE
	end
end

function var0.ShouldTipSubStage(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return arg0:ShouldPlaySubStory()
	else
		return arg0:GetSubVotes() > 0 or arg0:IsNewSubRace() or arg0:ShouldPlaySubStory()
	end
end

function var0.ShouldPlaySubStory(arg0)
	local var0 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_SUB_STAGE)

	return arg0.voteActivity and not arg0.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0)
end

function var0.IsNewSubRace(arg0)
	local var0 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	return getProxy(VoteProxy):IsNewRace(var0)
end

function var0.MarkSubRaceNonNew(arg0)
	local var0 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

	getProxy(VoteProxy):MarkRaceNonNew(var0)
end

function var0.GetExchangeState(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return var0.EXCHANGE_STAGE_CLOSE
	end

	if getProxy(VoteProxy):GetOpeningNonFunVoteGroup() then
		return var0.EXCHANGE_STAGE_OPEN
	else
		return var0.EXCHANGE_STAGE_CLOSE
	end
end

function var0.ShouldTipExchange(arg0)
	return arg0:ShouldPlayExchangeStory()
end

function var0.ShouldPlayExchangeStory(arg0)
	local var0 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_EXCHANGE)

	return arg0.voteActivity and not arg0.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0)
end

function var0.GetBillboardState(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return var0.BILLBOARD_STAGE_NORMAL
	end

	local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

	if var0 and var0:isFinalsRace() then
		return var0.BILLBOARD_STAGE_FINAL
	else
		return var0.BILLBOARD_STAGE_NORMAL
	end
end

function var0.ShouldTipBillboard(arg0)
	return arg0:ShouldPlayBillboardStory()
end

function var0.ShouldPlayBillboardStory(arg0)
	local var0 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_SCHEDULE)

	return arg0.voteActivity and not arg0.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0)
end

function var0.ShouldTipHonor(arg0)
	if not arg0.allPreheatStoriesPlayed then
		return arg0:ShouldPlayHonorStory()
	else
		return getProxy(VoteProxy):ExistPastVoteAward() or arg0:ShouldPlayHonorStory()
	end
end

function var0.ShouldPlayHonorStory(arg0)
	local var0 = VoteStoryUtil.GetStoryNameByType(VoteStoryUtil.ENTER_HALL)

	return arg0.voteActivity and not arg0.voteActivity:isEnd() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0)
end

function var0.GetVotes(arg0)
	local var0 = arg0:GetMainStageState()

	if var0 == var0.MAIN_STAGE_OPEN or var0 == var0.MAIN_STAGE_FINAL then
		local var1 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		return var1 and getProxy(VoteProxy):GetVotesByConfigId(var1.configId) or 0
	end

	return 0
end

function var0.GetSubVotes(arg0)
	if var0.SUB_STAGE_CLOSE ~= arg0:GetSubStageState() then
		local var0 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

		return var0 and getProxy(VoteProxy):GetVotesByConfigId(var0.configId) or 0
	else
		return 0
	end
end

function var0.CheckPreheatStories(arg0)
	if not arg0.allPreheatStoriesPlayed then
		pg.NewGuideMgr.GetInstance():Play("NG0043")

		return false
	end

	return true
end

return var0
