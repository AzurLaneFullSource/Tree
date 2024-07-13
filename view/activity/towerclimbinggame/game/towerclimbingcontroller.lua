local var0_0 = class("TowerClimbingController")

function var0_0.Ctor(arg0_1)
	arg0_1.view = TowerClimbingView.New(arg0_1)
end

function var0_0.SetCallBack(arg0_2, arg1_2, arg2_2)
	arg0_2.OnGameEndCallBack = arg1_2
	arg0_2.OnOverMapScore = arg2_2
end

function var0_0.SetUp(arg0_3, arg1_3)
	arg0_3:NetUpdateData(arg1_3)
	arg0_3.view:OnEnter()
end

function var0_0.NetUpdateData(arg0_4, arg1_4)
	arg0_4.data = arg1_4
end

function var0_0.StartGame(arg0_5, arg1_5)
	if arg0_5.enterGame then
		return
	end

	arg0_5.enterGame = true

	seriesAsync({
		function(arg0_6)
			arg0_5.map = TowerClimbingMapVO.New(arg1_5, arg0_5.view)

			arg0_5.view:OnCreateMap(arg0_5.map, arg0_6)
		end,
		function(arg0_7)
			arg0_5.map:Init(arg0_5.data, arg0_7)
		end,
		function(arg0_8)
			arg0_5.view:DoEnter(arg0_8)
		end
	}, function()
		arg0_5.IsStarting = true

		arg0_5:MainLoop()
		arg0_5.view:OnStartGame()
	end)
end

function var0_0.EnterBlock(arg0_10, arg1_10, arg2_10)
	if arg0_10.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_10.map:GetPlayer():IsDeath() then
		return
	end

	if arg1_10.normal == Vector2.up then
		arg0_10.map:GetPlayer():UpdateStand(true)

		arg0_10.level = arg2_10

		arg0_10.map:SetCurrentLevel(arg2_10)
	end
end

function var0_0.StayBlock(arg0_11, arg1_11, arg2_11)
	if arg0_11.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_11.map:GetPlayer():IsDeath() then
		return
	end

	if _.any(arg1_11, function(arg0_12)
		return arg0_12.normal == Vector2.up
	end) and not arg0_11.map:GetPlayer():IsIdle() and arg2_11 == Vector2(0, 0) then
		arg0_11.map:GetPlayer():Idle()
	end
end

function var0_0.ExitBlock(arg0_13, arg1_13)
	if arg0_13.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_13.map:GetPlayer():IsDeath() then
		return
	end

	if arg0_13.level == arg1_13 then
		arg0_13.map:GetPlayer():UpdateStand(false)
	end
end

function var0_0.EnterAttacker(arg0_14)
	if arg0_14.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_14.map:GetPlayer():IsDeath() then
		return
	end

	arg0_14.map:GetPlayer():BeInjured()
	arg0_14.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
end

function var0_0.EnterGround(arg0_15)
	if arg0_15.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0_15.map:GetPlayer():IsDeath() then
		return
	end

	arg0_15.map:GetPlayer():BeFatalInjured(function()
		if not arg0_15.map:GetPlayer():IsDeath() then
			arg0_15.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
			arg0_15.map:GetPlayer():UpdateStand(true)
			arg0_15.map:ReBornPlayer()
			arg0_15.map:GetPlayer():Idle()
		end
	end)

	if not arg0_15.map:GetPlayer():IsDeath() then
		arg0_15.map:SetGroundSleep(TowerClimbingGameSettings.GROUND_SLEEP_TIME)
	end
end

function var0_0.OnStickChange(arg0_17, arg1_17)
	if arg0_17.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg1_17 > 0.05 then
		arg0_17.map:GetPlayer():MoveRight()
	elseif arg1_17 < -0.05 then
		arg0_17.map:GetPlayer():MoveLeft()
	end
end

function var0_0.MainLoop(arg0_18)
	if not arg0_18.handle then
		arg0_18.handle = UpdateBeat:CreateListener(arg0_18.Update, arg0_18)
	end

	UpdateBeat:AddListener(arg0_18.handle)
end

function var0_0.Update(arg0_19)
	arg0_19.view:Update()
	arg0_19.map:Update()

	if arg0_19.IsStarting and arg0_19.map:GetPlayer():IsDeath() then
		arg0_19:EndGame()
	end
end

function var0_0.PlayerJump(arg0_20)
	arg0_20.map:GetPlayer():Jump()
end

function var0_0.PlayerIdle(arg0_21)
	arg0_21.map:GetPlayer():Idle()
end

local function var1_0(arg0_22)
	arg0_22.IsStarting = false

	if arg0_22.handle then
		UpdateBeat:RemoveListener(arg0_22.handle)
	end
end

function var0_0.EndGame(arg0_23)
	var1_0(arg0_23)

	local var0_23 = arg0_23.map:GetPlayer()

	arg0_23.view:OnEndGame(var0_23.score, var0_23.mapScore, arg0_23.map.id)

	if arg0_23.OnGameEndCallBack then
		arg0_23.OnGameEndCallBack(var0_23.score, var0_23.higestscore, var0_23.pageIndex, arg0_23.map.id)
	end

	if arg0_23.OnOverMapScore and var0_23:IsOverMapScore() then
		arg0_23.OnOverMapScore(arg0_23.map.id, var0_23.score)
	end
end

function var0_0.updateHighScore(arg0_24, arg1_24)
	arg0_24.highScores = arg1_24

	arg0_24.view:SetHighScore(arg1_24)
end

function var0_0.ExitGame(arg0_25)
	var1_0(arg0_25)
	arg0_25.view:OnExitGame()

	if arg0_25.map then
		arg0_25.map:Dispose()

		arg0_25.map = nil
	end

	arg0_25.enterGame = nil
end

function var0_0.onBackPressed(arg0_26)
	return arg0_26.view:onBackPressed()
end

function var0_0.Dispose(arg0_27)
	arg0_27:ExitGame()
	arg0_27.view:Dispose()
end

return var0_0
