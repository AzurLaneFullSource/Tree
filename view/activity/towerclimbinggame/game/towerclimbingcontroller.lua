local var0_0 = class("TowerClimbingController")

function var0_0.Ctor(arg0_1)
	arg0_1.view = TowerClimbingView.New(arg0_1)
end

function var0_0.SetCallBack(arg0_2, arg1_2, arg2_2)
	arg0_2.OnGameEndCallBack = arg1_2
	arg0_2.OnOverMapScore = arg2_2
end

function var0_0.setGameStateCallback(arg0_3, arg1_3, arg2_3)
	arg0_3.startGameCalback = arg1_3
	arg0_3.endGameCallback = arg2_3
end

function var0_0.setRoomTip(arg0_4, arg1_4)
	arg0_4.view:setRoomTip(arg1_4)
end

function var0_0.SetUp(arg0_5, arg1_5)
	arg0_5:NetUpdateData(arg1_5)
	arg0_5.view:OnEnter()
end

function var0_0.NetUpdateData(arg0_6, arg1_6)
	arg0_6.data = arg1_6
end

function var0_0.StartGame(arg0_7, arg1_7)
	if arg0_7.enterGame then
		return
	end

	arg0_7.enterGame = true

	seriesAsync({
		function(arg0_8)
			arg0_7.map = TowerClimbingMapVO.New(arg1_7, arg0_7.view)

			arg0_7.view:OnCreateMap(arg0_7.map, arg0_8)
		end,
		function(arg0_9)
			arg0_7.map:Init(arg0_7.data, arg0_9)

			if arg0_7.startGameCalback then
				arg0_7.startGameCalback()
			end
		end,
		function(arg0_10)
			arg0_7.view:DoEnter(arg0_10)
		end
	}, function()
		arg0_7.IsStarting = true

		arg0_7:MainLoop()
		arg0_7.view:OnStartGame()
	end)
end

function var0_0.EnterBlock(arg0_12, arg1_12, arg2_12)
	if arg0_12.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_12.map:GetPlayer():IsDeath() then
		return
	end

	if arg1_12.normal == Vector2.up then
		arg0_12.map:GetPlayer():UpdateStand(true)

		arg0_12.level = arg2_12

		arg0_12.map:SetCurrentLevel(arg2_12)
	end
end

function var0_0.StayBlock(arg0_13, arg1_13, arg2_13)
	if arg0_13.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_13.map:GetPlayer():IsDeath() then
		return
	end

	if _.any(arg1_13, function(arg0_14)
		return arg0_14.normal == Vector2.up
	end) and not arg0_13.map:GetPlayer():IsIdle() and arg2_13 == Vector2(0, 0) then
		arg0_13.map:GetPlayer():Idle()
	end
end

function var0_0.ExitBlock(arg0_15, arg1_15)
	if arg0_15.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_15.map:GetPlayer():IsDeath() then
		return
	end

	if arg0_15.level == arg1_15 then
		arg0_15.map:GetPlayer():UpdateStand(false)
	end
end

function var0_0.EnterAttacker(arg0_16)
	if arg0_16.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_16.map:GetPlayer():IsDeath() then
		return
	end

	arg0_16.map:GetPlayer():BeInjured()
	arg0_16.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
end

function var0_0.EnterGround(arg0_17)
	if arg0_17.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_17.map:GetPlayer():IsDeath() then
		return
	end

	arg0_17.map:GetPlayer():BeFatalInjured(function()
		if not arg0_17.map:GetPlayer():IsDeath() then
			arg0_17.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
			arg0_17.map:GetPlayer():UpdateStand(true)
			arg0_17.map:ReBornPlayer()
			arg0_17.map:GetPlayer():Idle()
		end
	end)

	if not arg0_17.map:GetPlayer():IsDeath() then
		arg0_17.map:SetGroundSleep(TowerClimbingGameSettings.GROUND_SLEEP_TIME)
	end
end

function var0_0.OnStickChange(arg0_19, arg1_19)
	if arg0_19.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg1_19 > 0.05 then
		arg0_19.map:GetPlayer():MoveRight()
	elseif arg1_19 < -0.05 then
		arg0_19.map:GetPlayer():MoveLeft()
	end
end

function var0_0.MainLoop(arg0_20)
	if not arg0_20.handle then
		arg0_20.handle = UpdateBeat:CreateListener(arg0_20.Update, arg0_20)
	end

	UpdateBeat:AddListener(arg0_20.handle)
end

function var0_0.Update(arg0_21)
	arg0_21.view:Update()
	arg0_21.map:Update()

	if arg0_21.IsStarting and arg0_21.map:GetPlayer():IsDeath() then
		arg0_21:EndGame()
	end
end

function var0_0.PlayerJump(arg0_22)
	arg0_22.map:GetPlayer():Jump()
end

function var0_0.PlayerIdle(arg0_23)
	arg0_23.map:GetPlayer():Idle()
end

local function var1_0(arg0_24)
	arg0_24.IsStarting = false

	if arg0_24.handle then
		UpdateBeat:RemoveListener(arg0_24.handle)
	end
end

function var0_0.EndGame(arg0_25)
	var1_0(arg0_25)

	local var0_25 = arg0_25.map:GetPlayer()

	arg0_25.view:OnEndGame(var0_25.score, var0_25.mapScore, arg0_25.map.id)

	if arg0_25.OnGameEndCallBack then
		arg0_25.OnGameEndCallBack(var0_25.score, var0_25.higestscore, var0_25.pageIndex, arg0_25.map.id)
	end

	if arg0_25.OnOverMapScore and var0_25:IsOverMapScore() then
		arg0_25.OnOverMapScore(arg0_25.map.id, var0_25.score)
	end
end

function var0_0.updateHighScore(arg0_26, arg1_26)
	arg0_26.highScores = arg1_26

	arg0_26.view:SetHighScore(arg1_26)
end

function var0_0.ExitGame(arg0_27)
	var1_0(arg0_27)
	arg0_27.view:OnExitGame()

	if arg0_27.map then
		arg0_27.map:Dispose()

		arg0_27.map = nil
	end

	arg0_27.enterGame = nil

	if arg0_27.endGameCallback then
		arg0_27.endGameCallback()
	end
end

function var0_0.onBackPressed(arg0_28)
	return arg0_28.view:onBackPressed()
end

function var0_0.Dispose(arg0_29)
	arg0_29:ExitGame()
	arg0_29.view:Dispose()
end

return var0_0
