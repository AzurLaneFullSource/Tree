local var0 = class("EducateBottomPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateBottomPanel"
end

function var0.OnInit(arg0)
	arg0.contentTF = arg0:findTF("content")
	arg0.planBtn = arg0:findTF("btns/schedule", arg0.contentTF)
	arg0.mapBtn = arg0:findTF("btns/map", arg0.contentTF)

	setText(arg0:findTF("tips/limit/Text", arg0.mapBtn), i18n("child_option_limit"))

	arg0.schoolBtn = arg0:findTF("btns/enter_school", arg0.contentTF)
	arg0.upgradeBtn = arg0:findTF("btns/system_upgrade", arg0.contentTF)
	arg0.targetSetBtn = arg0:findTF("btns/target_set", arg0.contentTF)
	arg0.endingBtn = arg0:findTF("btns/ending", arg0.contentTF)
	arg0.resetBtn = arg0:findTF("btns/reset", arg0.contentTF)

	arg0:addListener()

	arg0.targetSetDays = getProxy(EducateProxy):GetTaskProxy():GetTargetSetDays()

	arg0:Flush()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.planBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_GO_SCENE, SCENE.EDUCATE_SCHEDULE)
	end, SFX_PANEL)
	onButton(arg0, arg0.mapBtn, function()
		if isActive(arg0:findTF("lock", arg0.mapBtn)) then
			return
		end

		arg0:emit(EducateBaseUI.EDUCATE_GO_SCENE, SCENE.EDUCATE_MAP)
	end, SFX_PANEL)
	onButton(arg0, arg0.schoolBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_school_sure_tip"),
			onYes = function()
				setActive(arg0.schoolBtn, false)
				arg0:updateTargetSetBtn()

				local var0 = EducateConst.ENTER_NEW_STAGE_PERFORMS[2]

				if var0 then
					pg.PerformMgr.GetInstance():PlayOne(var0, function()
						arg0:playGuide("tb_9_1")
						arg0:onEnterVirtualStage()
					end)
				else
					arg0:playGuide("tb_9_1")
					arg0:onEnterVirtualStage()
				end

				getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.upgradeBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_upgrade_sure_tip"),
			onYes = function()
				setActive(arg0.upgradeBtn, false)
				arg0:updateTargetSetBtn()

				local var0 = getProxy(EducateProxy):GetCharData():GetStage()
				local var1 = EducateConst.ENTER_NEW_STAGE_PERFORMS[var0 + 1]

				if var1 then
					pg.PerformMgr.GetInstance():PlayOne(var1, function()
						arg0:onEnterVirtualStage()
					end)
				else
					arg0:onEnterVirtualStage()
				end

				getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.targetSetBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateTargetSetMediator,
			viewComponent = EducateTargetSetLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.endingBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_end_sure_tip"),
			onYes = function()
				pg.PerformMgr.GetInstance():PlayOne(EducateConst.FIRST_ENTER_END_PERFORM, function()
					arg0:emit(EducateMediator.ON_ENDING_TRIGGER)
				end)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.resetBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_reset_sure_tip"),
			onYes = function()
				arg0:emit(EducateMediator.ON_GAME_RESET)
			end
		})
	end, SFX_PANEL)

	local var0 = "anim_educate_bottom_show"

	if arg0.contextData and arg0.contextData.isMainEnter then
		var0 = "anim_educate_bottom_in"
	end

	arg0._tf:GetComponent(typeof(Animation)):Play(var0)
end

function var0.playGuide(arg0, arg1)
	if not pg.NewStoryMgr.GetInstance():IsPlayed(arg1) then
		pg.NewGuideMgr.GetInstance():Play(arg1)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1
		})
	end
end

function var0.onEnterVirtualStage(arg0)
	getProxy(EducateProxy):SetVirtualStage(true)
	arg0:emit(EducateMediator.ENTER_VIRTUAL_STAGE)
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0.curTime = getProxy(EducateProxy):GetCurTime()
	arg0.status = getProxy(EducateProxy):GetGameStatus()

	local var0 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_GO_OUT)
	local var1 = getProxy(EducateProxy):InVirtualStage()

	setActive(arg0:findTF("lock", arg0.mapBtn), not var0 or var1)
	setActive(arg0.planBtn, arg0.status ~= EducateConst.STATUES_ENDING and arg0.status ~= EducateConst.STATUES_RESET)
	setActive(arg0.mapBtn, arg0.status ~= EducateConst.STATUES_ENDING and arg0.status ~= EducateConst.STATUES_RESET)
	arg0:updateMapBtnTips()
	setActive(arg0.schoolBtn, arg0:isSchoolBtnShow() and not var1)
	setActive(arg0.upgradeBtn, arg0:isUpgradeBtnShow() and not var1)
	arg0:updateTargetSetBtn()
	setActive(arg0.endingBtn, arg0.status == EducateConst.STATUES_ENDING)
	setActive(arg0.resetBtn, arg0.status == EducateConst.STATUES_RESET)

	if isActive(arg0.schoolBtn) or isActive(arg0.upgradeBtn) or isActive(arg0.targetSetBtn) then
		setActive(arg0.planBtn, false)
	end
end

function var0.isSchoolBtnShow(arg0)
	return arg0.status == EducateConst.STATUES_PREPARE and EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[2])
end

function var0.isUpgradeBtnShow(arg0)
	return arg0.status == EducateConst.STATUES_PREPARE and (EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[3]) or EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[4]))
end

function var0.isTargetSetBtnShow(arg0)
	return arg0.status == EducateConst.STATUES_PREPARE and not isActive(arg0.schoolBtn) and not isActive(arg0.upgradeBtn)
end

function var0.updateTargetSetBtn(arg0)
	local var0 = arg0:isTargetSetBtnShow()

	setActive(arg0.targetSetBtn, var0)

	if var0 then
		setActive(arg0:findTF("lock", arg0.mapBtn), true)
	end
end

function var0.updateMapBtnTips(arg0)
	EducateTipHelper.GetSiteUnlockTipIds()

	local var0 = getProxy(EducateProxy):GetShowSiteIds()
	local var1 = underscore.any(var0, function(arg0)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_SITE, arg0)
	end)
	local var2 = underscore.any(var0, function(arg0)
		local var0 = getProxy(EducateProxy):GetOptionsBySiteId(arg0)

		return underscore.any(var0, function(arg0)
			return arg0:IsShowLimit()
		end)
	end)

	setActive(arg0:findTF("tips/new", arg0.mapBtn), var1)
	setActive(arg0:findTF("tips/limit", arg0.mapBtn), var2)
end

function var0.OnDestroy(arg0)
	return
end

return var0
