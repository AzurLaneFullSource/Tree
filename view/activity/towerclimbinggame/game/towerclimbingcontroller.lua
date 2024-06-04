local var0 = class("TowerClimbingController")

function var0.Ctor(arg0)
	arg0.view = TowerClimbingView.New(arg0)
end

function var0.SetCallBack(arg0, arg1, arg2)
	arg0.OnGameEndCallBack = arg1
	arg0.OnOverMapScore = arg2
end

function var0.SetUp(arg0, arg1)
	arg0:NetUpdateData(arg1)
	arg0.view:OnEnter()
end

function var0.NetUpdateData(arg0, arg1)
	arg0.data = arg1
end

function var0.StartGame(arg0, arg1)
	if arg0.enterGame then
		return
	end

	arg0.enterGame = true

	seriesAsync({
		function(arg0)
			arg0.map = TowerClimbingMapVO.New(arg1, arg0.view)

			arg0.view:OnCreateMap(arg0.map, arg0)
		end,
		function(arg0)
			arg0.map:Init(arg0.data, arg0)
		end,
		function(arg0)
			arg0.view:DoEnter(arg0)
		end
	}, function()
		arg0.IsStarting = true

		arg0:MainLoop()
		arg0.view:OnStartGame()
	end)
end

function var0.EnterBlock(arg0, arg1, arg2)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0.map:GetPlayer():IsDeath() then
		return
	end

	if arg1.normal == Vector2.up then
		arg0.map:GetPlayer():UpdateStand(true)

		arg0.level = arg2

		arg0.map:SetCurrentLevel(arg2)
	end
end

function var0.StayBlock(arg0, arg1, arg2)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0.map:GetPlayer():IsDeath() then
		return
	end

	if _.any(arg1, function(arg0)
		return arg0.normal == Vector2.up
	end) and not arg0.map:GetPlayer():IsIdle() and arg2 == Vector2(0, 0) then
		arg0.map:GetPlayer():Idle()
	end
end

function var0.ExitBlock(arg0, arg1)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0.map:GetPlayer():IsDeath() then
		return
	end

	if arg0.level == arg1 then
		arg0.map:GetPlayer():UpdateStand(false)
	end
end

function var0.EnterAttacker(arg0)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0.map:GetPlayer():IsDeath() then
		return
	end

	arg0.map:GetPlayer():BeInjured()
	arg0.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
end

function var0.EnterGround(arg0)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg0.map:GetPlayer():IsDeath() then
		return
	end

	arg0.map:GetPlayer():BeFatalInjured(function()
		if not arg0.map:GetPlayer():IsDeath() then
			arg0.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
			arg0.map:GetPlayer():UpdateStand(true)
			arg0.map:ReBornPlayer()
			arg0.map:GetPlayer():Idle()
		end
	end)

	if not arg0.map:GetPlayer():IsDeath() then
		arg0.map:SetGroundSleep(TowerClimbingGameSettings.GROUND_SLEEP_TIME)
	end
end

function var0.OnStickChange(arg0, arg1)
	if arg0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if arg1 > 0.05 then
		arg0.map:GetPlayer():MoveRight()
	elseif arg1 < -0.05 then
		arg0.map:GetPlayer():MoveLeft()
	end
end

function var0.MainLoop(arg0)
	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Update(arg0)
	arg0.view:Update()
	arg0.map:Update()

	if arg0.IsStarting and arg0.map:GetPlayer():IsDeath() then
		arg0:EndGame()
	end
end

function var0.PlayerJump(arg0)
	arg0.map:GetPlayer():Jump()
end

function var0.PlayerIdle(arg0)
	arg0.map:GetPlayer():Idle()
end

local function var1(arg0)
	arg0.IsStarting = false

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

function var0.EndGame(arg0)
	var1(arg0)

	local var0 = arg0.map:GetPlayer()

	arg0.view:OnEndGame(var0.score, var0.mapScore, arg0.map.id)

	if arg0.OnGameEndCallBack then
		arg0.OnGameEndCallBack(var0.score, var0.higestscore, var0.pageIndex, arg0.map.id)
	end

	if arg0.OnOverMapScore and var0:IsOverMapScore() then
		arg0.OnOverMapScore(arg0.map.id, var0.score)
	end
end

function var0.updateHighScore(arg0, arg1)
	arg0.highScores = arg1

	arg0.view:SetHighScore(arg1)
end

function var0.ExitGame(arg0)
	var1(arg0)
	arg0.view:OnExitGame()

	if arg0.map then
		arg0.map:Dispose()

		arg0.map = nil
	end

	arg0.enterGame = nil
end

function var0.onBackPressed(arg0)
	return arg0.view:onBackPressed()
end

function var0.Dispose(arg0)
	arg0:ExitGame()
	arg0.view:Dispose()
end

return var0
