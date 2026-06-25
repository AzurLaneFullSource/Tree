local var0_0 = class("CarWashGamePage", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.GUN_COUNT = 3

function var0_0.Init(arg0_1)
	arg0_1:InitConfig()
	arg0_1:InitUI()
	arg0_1:BindEvent()
end

function var0_0.InitConfig(arg0_2)
	arg0_2.posConfig = _.map(arg0_2.contextData.gameConfig.pos, function(arg0_3)
		return pg.dorm3d_carwash_pos[arg0_3]
	end)
	arg0_2.selectPosIndex = 1
	arg0_2.posUnlock = _.map(arg0_2.posConfig, function(arg0_4)
		return arg0_4.mood_value <= arg0_2.contextData.gameStatus.heartBeatValue
	end)
	arg0_2.heartBeatDotVals = _.map(arg0_2.posConfig, function(arg0_5)
		return arg0_5.mood_value
	end)

	table.insert(arg0_2.heartBeatDotVals, 100)
end

function var0_0.InitUI(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("bottom/btn_shoot"), function()
		arg0_6:emit(CarWashGameFlowSystem.SWITCH_SHOOTING)
		setActive(arg0_6._tf:Find("bottom/btn_shoot/on"), arg0_6.contextData.gameStatus.isShooting)
		setActive(arg0_6._tf:Find("bottom/btn_shoot/off"), not arg0_6.contextData.gameStatus.isShooting)
	end)

	arg0_6.gunList = UIItemList.New(arg0_6._tf:Find("bottom/guns"), arg0_6._tf:Find("bottom/guns/gun1"))

	arg0_6.gunList:make(function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventInit then
			onButton(arg0_6, arg2_8, function()
				if arg0_6.contextData.gameStatus.isShooting then
					return
				end

				if arg0_6.contextData.gameStatus.currentGunType == arg1_8 then
					return
				end

				arg0_6:emit(CarWashGameFlowSystem.SWITCH_GUN_TYPE, arg1_8)
			end)
		elseif arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_6.contextData.gameStatus.currentGunType == arg1_8

			setActive(arg2_8:Find("select"), var0_8)
			setActive(arg2_8:Find("unselect"), not var0_8)
		end
	end)
	arg0_6.gunList:align(var0_0.GUN_COUNT)

	arg0_6.camsList = UIItemList.New(arg0_6._tf:Find("left/cams"), arg0_6._tf:Find("left/cams/camTpl"))

	arg0_6.camsList:make(function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventInit then
			onButton(arg0_6, arg2_10, function()
				if arg0_6.posUnlock[arg1_10] and arg0_6.selectPosIndex ~= arg1_10 then
					arg0_6.selectPosIndex = arg1_10

					arg0_6:Flush()
					arg0_6:emit(CarWashTimelineSystem.PLAY_TRANSITION, {
						waitHold = true,
						type = CarWashTimelineSystem.TRANSITION.BLACK,
						onHold = function(arg0_12, arg1_12)
							arg0_6:emit(CarWashGameFlowSystem.SWITCH_LADY_POS, arg0_6.posConfig[arg0_6.selectPosIndex].id)
							arg0_12()
						end
					})
				end
			end)
		elseif arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_6.posUnlock[arg1_10]
			local var1_10 = arg0_6.selectPosIndex == arg1_10

			setActive(arg2_10:Find("lock"), not var0_10)
			setActive(arg2_10:Find("normal"), var0_10 and not var1_10)
			setActive(arg2_10:Find("select"), var1_10)
		end
	end)
	arg0_6.camsList:align(#arg0_6.posConfig)

	arg0_6.favorList = UIItemList.New(arg0_6._tf:Find("left/favor/bar_root"), arg0_6._tf:Find("left/favor/bar_root/bar"))

	arg0_6.favorList:make(function(arg0_13, arg1_13, arg2_13)
		arg1_13 = arg1_13 + 2

		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg0_6.heartBeatDotVals[arg1_13]
			local var1_13 = arg0_6.heartBeatDotVals[arg1_13 - 1]
			local var2_13 = var0_13 - var1_13
			local var3_13 = math.max(0, math.min(arg0_6.contextData.gameStatus.heartBeatValue - var1_13, var2_13))
			local var4_13 = var3_13 / var2_13

			arg2_13:GetComponent(typeof(Slider)).value = var4_13

			setActive(arg2_13:Find("dot/fill"), var3_13 == var2_13)
			setActive(arg2_13:Find("mask/Vx_bar"), var4_13 > 0 and var4_13 < 1)
		end
	end)
	arg0_6.favorList:align(#arg0_6.heartBeatDotVals - 1)

	arg0_6.cleanPersentText = arg0_6._tf:Find("top/clean/clean_rate")
	arg0_6.cleanRank = arg0_6._tf:Find("top/clean/rank")
	arg0_6.timeText = arg0_6._tf:Find("top/clean/time")

	arg0_6:UpdateTimeText(CarWashConst.GAME_DURATION)
	setText(arg0_6._tf:Find("left/favor/text"), i18n("dorm3d_carwash_mood"))
	setText(arg0_6._tf:Find("top/clean/clean_text"), i18n("dorm3d_carwash_clean"))
end

function var0_0.BindEvent(arg0_14)
	arg0_14:bind(CarWashGameFlowSystem.UPDATE_COUNTDOWN, function(arg0_15, arg1_15)
		arg0_14:UpdateTimeText(arg1_15.remainingSeconds)
	end)
	arg0_14:bind(CarWashGameFlowSystem.UPDATE_HEART_BEAT_VALUE, function(arg0_16, arg1_16)
		for iter0_16, iter1_16 in ipairs(arg0_14.posConfig) do
			if not arg0_14.posUnlock[iter0_16] and iter1_16.mood_value <= arg1_16.newValue then
				arg0_14.posUnlock[iter0_16] = true

				local var0_16 = arg0_14._tf:Find("left/cams"):GetChild(iter0_16 - 1)

				triggerButton(var0_16)
				var0_16:GetComponent(typeof(Animation)):Play("anim_Dorm3dCarWashUI_lock_out")
			end
		end

		arg0_14:Flush()
	end)
	arg0_14:bind(CarWashGameFlowSystem.UPDATE_STAINS_COUNT, function(arg0_17, arg1_17)
		arg0_14:FlushCleanPersent()
	end)
	arg0_14:bind(CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE, function(arg0_18, arg1_18)
		arg0_14:Flush()
	end)
	arg0_14:bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_19, arg1_19)
		if arg1_19.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			arg0_14:Show()
		elseif arg1_19.newValue == CarWashConst.GAME_STATE.PHASE_2 or arg1_19.newValue == CarWashConst.GAME_STATE.END then
			arg0_14:Hide()
		end
	end)
end

function var0_0.UpdateTimeText(arg0_20, arg1_20)
	setText(arg0_20.timeText, arg0_20:FormatTime(arg1_20))
end

function var0_0.FormatTime(arg0_21, arg1_21)
	arg1_21 = math.max(arg1_21 or 0, 0)

	local var0_21 = math.floor(arg1_21 / 60)
	local var1_21 = arg1_21 % 60

	return string.format("%02d:%02d", var0_21, var1_21)
end

function var0_0.Flush(arg0_22)
	arg0_22.gunList:align(var0_0.GUN_COUNT)
	arg0_22.camsList:align(#arg0_22.posConfig)
	arg0_22.favorList:align(#arg0_22.heartBeatDotVals - 1)
	arg0_22:FlushCleanPersent()
end

function var0_0.FlushCleanPersent(arg0_23)
	local var0_23 = arg0_23:GetCleanPersent()
	local var1_23 = arg0_23:GetRank(var0_23)

	setText(arg0_23.cleanPersentText, var0_23 .. "%")
	eachChild(arg0_23.cleanRank, function(arg0_24)
		setActive(arg0_24, arg0_24.name == var1_23)
	end)
end

function var0_0.GetCleanPersent(arg0_25)
	if arg0_25.contextData.gameStatus.stainsCountMax == 0 then
		return 0
	end

	local var0_25 = 1 - arg0_25.contextData.gameStatus.stainsCount / arg0_25.contextData.gameStatus.stainsCountMax

	return (math.floor(var0_25 * 100))
end

function var0_0.GetRank(arg0_26, arg1_26)
	return CarWashConst.GetScoreRank(arg1_26)
end

return var0_0
