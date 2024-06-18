local var0_0 = class("EducateBottomPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateBottomPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.contentTF = arg0_2:findTF("content")
	arg0_2.planBtn = arg0_2:findTF("btns/schedule", arg0_2.contentTF)
	arg0_2.mapBtn = arg0_2:findTF("btns/map", arg0_2.contentTF)

	setText(arg0_2:findTF("tips/limit/Text", arg0_2.mapBtn), i18n("child_option_limit"))

	arg0_2.schoolBtn = arg0_2:findTF("btns/enter_school", arg0_2.contentTF)
	arg0_2.upgradeBtn = arg0_2:findTF("btns/system_upgrade", arg0_2.contentTF)
	arg0_2.targetSetBtn = arg0_2:findTF("btns/target_set", arg0_2.contentTF)
	arg0_2.endingBtn = arg0_2:findTF("btns/ending", arg0_2.contentTF)
	arg0_2.resetBtn = arg0_2:findTF("btns/reset", arg0_2.contentTF)

	arg0_2:addListener()

	arg0_2.targetSetDays = getProxy(EducateProxy):GetTaskProxy():GetTargetSetDays()

	arg0_2:Flush()
end

function var0_0.addListener(arg0_3)
	onButton(arg0_3, arg0_3.planBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_GO_SCENE, SCENE.EDUCATE_SCHEDULE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.mapBtn, function()
		if isActive(arg0_3:findTF("lock", arg0_3.mapBtn)) then
			return
		end

		arg0_3:emit(EducateBaseUI.EDUCATE_GO_SCENE, SCENE.EDUCATE_MAP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.schoolBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_school_sure_tip"),
			onYes = function()
				setActive(arg0_3.schoolBtn, false)
				arg0_3:updateTargetSetBtn()

				local var0_7 = EducateConst.ENTER_NEW_STAGE_PERFORMS[2]

				if var0_7 then
					pg.PerformMgr.GetInstance():PlayOne(var0_7, function()
						arg0_3:playGuide("tb_9_1")
						arg0_3:onEnterVirtualStage()
					end)
				else
					arg0_3:playGuide("tb_9_1")
					arg0_3:onEnterVirtualStage()
				end

				getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_upgrade_sure_tip"),
			onYes = function()
				setActive(arg0_3.upgradeBtn, false)
				arg0_3:updateTargetSetBtn()

				local var0_10 = getProxy(EducateProxy):GetCharData():GetStage()
				local var1_10 = EducateConst.ENTER_NEW_STAGE_PERFORMS[var0_10 + 1]

				if var1_10 then
					pg.PerformMgr.GetInstance():PlayOne(var1_10, function()
						arg0_3:onEnterVirtualStage()
					end)
				else
					arg0_3:onEnterVirtualStage()
				end

				getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.targetSetBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateTargetSetMediator,
			viewComponent = EducateTargetSetLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.endingBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_end_sure_tip"),
			onYes = function()
				pg.PerformMgr.GetInstance():PlayOne(EducateConst.FIRST_ENTER_END_PERFORM, function()
					arg0_3:emit(EducateMediator.ON_ENDING_TRIGGER)
				end)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.resetBtn, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_reset_sure_tip"),
			onYes = function()
				arg0_3:emit(EducateMediator.ON_GAME_RESET)
			end
		})
	end, SFX_PANEL)

	local var0_3 = "anim_educate_bottom_show"

	if arg0_3.contextData and arg0_3.contextData.isMainEnter then
		var0_3 = "anim_educate_bottom_in"
	end

	arg0_3._tf:GetComponent(typeof(Animation)):Play(var0_3)
end

function var0_0.playGuide(arg0_18, arg1_18)
	if not pg.NewStoryMgr.GetInstance():IsPlayed(arg1_18) then
		pg.NewGuideMgr.GetInstance():Play(arg1_18)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_18
		})
	end
end

function var0_0.onEnterVirtualStage(arg0_19)
	getProxy(EducateProxy):SetVirtualStage(true)
	arg0_19:emit(EducateMediator.ENTER_VIRTUAL_STAGE)
end

function var0_0.Flush(arg0_20)
	if not arg0_20:GetLoaded() then
		return
	end

	arg0_20.curTime = getProxy(EducateProxy):GetCurTime()
	arg0_20.status = getProxy(EducateProxy):GetGameStatus()

	local var0_20 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_GO_OUT)
	local var1_20 = getProxy(EducateProxy):InVirtualStage()

	setActive(arg0_20:findTF("lock", arg0_20.mapBtn), not var0_20 or var1_20)
	setActive(arg0_20.planBtn, arg0_20.status ~= EducateConst.STATUES_ENDING and arg0_20.status ~= EducateConst.STATUES_RESET)
	setActive(arg0_20.mapBtn, arg0_20.status ~= EducateConst.STATUES_ENDING and arg0_20.status ~= EducateConst.STATUES_RESET)
	arg0_20:updateMapBtnTips()
	setActive(arg0_20.schoolBtn, arg0_20:isSchoolBtnShow() and not var1_20)
	setActive(arg0_20.upgradeBtn, arg0_20:isUpgradeBtnShow() and not var1_20)
	arg0_20:updateTargetSetBtn()
	setActive(arg0_20.endingBtn, arg0_20.status == EducateConst.STATUES_ENDING)
	setActive(arg0_20.resetBtn, arg0_20.status == EducateConst.STATUES_RESET)

	if isActive(arg0_20.schoolBtn) or isActive(arg0_20.upgradeBtn) or isActive(arg0_20.targetSetBtn) then
		setActive(arg0_20.planBtn, false)
	end
end

function var0_0.isSchoolBtnShow(arg0_21)
	return arg0_21.status == EducateConst.STATUES_PREPARE and EducateHelper.IsSameDay(arg0_21.curTime, arg0_21.targetSetDays[2])
end

function var0_0.isUpgradeBtnShow(arg0_22)
	return arg0_22.status == EducateConst.STATUES_PREPARE and (EducateHelper.IsSameDay(arg0_22.curTime, arg0_22.targetSetDays[3]) or EducateHelper.IsSameDay(arg0_22.curTime, arg0_22.targetSetDays[4]))
end

function var0_0.isTargetSetBtnShow(arg0_23)
	return arg0_23.status == EducateConst.STATUES_PREPARE and not isActive(arg0_23.schoolBtn) and not isActive(arg0_23.upgradeBtn)
end

function var0_0.updateTargetSetBtn(arg0_24)
	local var0_24 = arg0_24:isTargetSetBtnShow()

	setActive(arg0_24.targetSetBtn, var0_24)

	if var0_24 then
		setActive(arg0_24:findTF("lock", arg0_24.mapBtn), true)
	end
end

function var0_0.updateMapBtnTips(arg0_25)
	EducateTipHelper.GetSiteUnlockTipIds()

	local var0_25 = getProxy(EducateProxy):GetShowSiteIds()
	local var1_25 = underscore.any(var0_25, function(arg0_26)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_SITE, arg0_26)
	end)
	local var2_25 = underscore.any(var0_25, function(arg0_27)
		local var0_27 = getProxy(EducateProxy):GetOptionsBySiteId(arg0_27)

		return underscore.any(var0_27, function(arg0_28)
			return arg0_28:IsShowLimit()
		end)
	end)

	setActive(arg0_25:findTF("tips/new", arg0_25.mapBtn), var1_25)
	setActive(arg0_25:findTF("tips/limit", arg0_25.mapBtn), var2_25)
end

function var0_0.OnDestroy(arg0_29)
	return
end

return var0_0
