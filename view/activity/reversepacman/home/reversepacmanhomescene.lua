local var0_0 = class("ReversePacmanHomeScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanHomeUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.PlayBGM(arg0_3)
	pg.CriMgr.GetInstance():StopBGM()
end

function var0_0.init(arg0_4)
	onButton(arg0_4, arg0_4.uiHomeBtn, function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.uiBackBtn, function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["20260908gameplay_main_window"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.uiTechnologyBtn, function()
		if not ReversePacmanTools.HasHireRole() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_no_char"))

			return
		end

		arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTechnologyScene,
			mediator = ReversePacmanTechnologyMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.uiBattleBtn, function()
		if not ReversePacmanTools.HasHireRole() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_no_char"))

			return
		end

		arg0_4:emit(ReversePacmanHomeMediator.GO_GAME_SCENE)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.uiTaskBtn, function()
		arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTaskScene,
			mediator = ReversePacmanTaskMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.uiInterviewBtn, function()
		arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanInterviewScene,
			mediator = ReversePacmanInterviewMediator
		}))
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_12)
	arg0_12:BlockEvents()
	arg0_12:SetUpCourtYard()
	arg0_12:RefreshTips()
	arg0_12:RefreshBtns()

	if arg0_12.contextData.technologyType then
		if not ReversePacmanTools.HasHireRole() then
			return
		end

		arg0_12:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTechnologyScene,
			mediator = ReversePacmanTechnologyMediator,
			data = {
				toggleType = arg0_12.contextData.technologyType
			}
		}))
	end

	local var0_12 = ReversePacmanTools.GetActivity()

	pg.NewStoryMgr.GetInstance():Play(var0_12:getConfig("config_client").story[1])
end

function var0_0.OnCourtYardLoaded(arg0_13)
	arg0_13:UnBlockEvents()

	if arg0_13.contextData.openTaskID then
		local var0_13 = arg0_13.contextData.openTaskID

		arg0_13.contextData.openTaskID = nil

		arg0_13:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTaskScene,
			mediator = ReversePacmanTaskMediator,
			data = {
				taskID = var0_13
			}
		}))

		return
	end

	if arg0_13.contextData.openInterview then
		arg0_13.contextData.openInterview = nil

		arg0_13:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanInterviewScene,
			mediator = ReversePacmanInterviewMediator
		}))

		return
	end

	if #ReversePacmanTools.GetUnreadyHireStory() > 0 then
		arg0_13:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanInterviewScene,
			mediator = ReversePacmanInterviewMediator
		}))
	end
end

function var0_0.SetUpCourtYard(arg0_14)
	arg0_14.contextData.mode = CourtYardConst.SYSTEM_REVERSE_PACMAN

	arg0_14:emit(ReversePacmanHomeMediator.SET_UP, 1)
end

function var0_0.BlockEvents(arg0_15)
	arg0_15.uiMainCanvasGrop.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_16)
	arg0_16.uiMainCanvasGrop.blocksRaycasts = true
end

function var0_0.RefreshBtns(arg0_17)
	local var0_17 = ReversePacmanTools.HasHireRole()

	setGray(arg0_17.uiTechnologyBtn, not var0_17)
	setGray(arg0_17.uiBattleBtn, not var0_17)
end

function var0_0.RefreshTips(arg0_18)
	local var0_18 = ReversePacmanTools.GetActivity()

	setActive(arg0_18.uiTechnologyTipGo, var0_18:GetTechnologyTip())
	setActive(arg0_18.uiBattleTipGo, var0_18:GetGameTip())
	setActive(arg0_18.uiTaskTipGo, var0_18:GetTaskTip())
	setActive(arg0_18.uiInterviewTipGo, var0_18:GetHireTip())
end

function var0_0.willExit(arg0_19)
	return
end

return var0_0
