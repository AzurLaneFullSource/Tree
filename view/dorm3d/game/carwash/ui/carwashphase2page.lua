local var0_0 = class("CarWashPhase2Page", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1:InitConfig()
	arg0_1:InitUI()
	arg0_1:BindEvent()
	arg0_1:Hide()
end

function var0_0.InitConfig(arg0_2)
	arg0_2.posConfig = pg.dorm3d_carwash_pos[arg0_2.contextData.gameConfig.pos_phase2]

	assert(arg0_2.posConfig, "CarWash phase2 pos config not found: " .. tostring(arg0_2.contextData.gameConfig.pos_phase2))

	arg0_2.tipInfos = {}
	arg0_2.displayTipInfos = {}
	arg0_2.carTipInfo = nil
	arg0_2.clickedTips = {}
end

function var0_0.InitUI(arg0_3)
	arg0_3.tipContainer = arg0_3._tf:Find("tips")
	arg0_3.tipList = UIItemList.New(arg0_3.tipContainer, arg0_3._tf:Find("tips/tpl"))

	arg0_3.tipList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventInit then
			onButton(arg0_3, arg2_4, function()
				local var0_5 = arg0_3.displayTipInfos[arg1_4]

				if not var0_5 then
					return
				end

				if var0_5.isCar then
					arg0_3:emit(CarWashCarSystem.PLAY_PHASE2_REACTION)

					return
				end

				if arg0_3.clickedTips[var0_5.animId] then
					return
				end

				arg0_3:emit(CarWashGameFlowSystem.PLAY_PHASE2_REACTION, {
					animId = var0_5.animId
				})
			end)
		elseif arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateTipItem(arg1_4, arg2_4)
		end
	end)
end

function var0_0.BindEvent(arg0_6)
	arg0_6:bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_7, arg1_7)
		if arg1_7.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			arg0_6:Show()
			arg0_6:ResetTips()
			arg0_6:Flush()
		elseif arg1_7.newValue == CarWashConst.GAME_STATE.PHASE_1 or arg1_7.newValue == CarWashConst.GAME_STATE.END then
			arg0_6:Hide()
		end
	end)
	arg0_6:bind(CarWashLadySystem.UPDATE_PHASE2_TIPS, function(arg0_8, arg1_8)
		if arg0_6.contextData.gameStatus.currentState ~= CarWashConst.GAME_STATE.PHASE_2 then
			return
		end

		arg0_6.tipInfos = arg1_8 or {}

		arg0_6:Flush()
	end)
	arg0_6:bind(CarWashCarSystem.UPDATE_PHASE2_TIP, function(arg0_9, arg1_9)
		if arg0_6.contextData.gameStatus.currentState ~= CarWashConst.GAME_STATE.PHASE_2 then
			return
		end

		arg0_6.carTipInfo = arg1_9

		arg0_6:Flush()
	end)
	arg0_6:bind(CarWashGameFlowSystem.UPDATE_PHASE2_REACTION_PROGRESS, function(arg0_10, arg1_10)
		arg0_6.clickedTips[arg1_10.animId] = true

		arg0_6:Flush()
	end)
end

function var0_0.Flush(arg0_11)
	arg0_11.displayTipInfos = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.tipInfos) do
		table.insert(arg0_11.displayTipInfos, iter1_11)
	end

	if arg0_11.carTipInfo then
		table.insert(arg0_11.displayTipInfos, arg0_11.carTipInfo)
	end

	arg0_11.tipList:align(#arg0_11.displayTipInfos)
end

function var0_0.UpdateTipItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.displayTipInfos[arg1_12]

	assert(var0_12, "CarWash phase2 tip info not found: " .. tostring(arg1_12))
	setActive(arg2_12, var0_12.visible)

	if var0_12.visible then
		setLocalPosition(arg2_12, LuaHelper.ScreenToLocal(arg0_12.tipContainer, var0_12.screenPosition, pg.UIMgr.GetInstance().uiCameraComp))
	end
end

function var0_0.ResetTips(arg0_13)
	arg0_13.tipInfos = {}
	arg0_13.displayTipInfos = {}
	arg0_13.carTipInfo = nil
	arg0_13.clickedTips = {}
end

return var0_0
