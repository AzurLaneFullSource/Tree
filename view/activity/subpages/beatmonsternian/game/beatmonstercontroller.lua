local var0 = class("BeatMonsterController")

function var0.Ctor(arg0)
	arg0.mediator = BeatMonsterMeidator.New(arg0)
	arg0.model = BeatMonsterModel.New(arg0)
end

function var0.SetUp(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			arg0.OnDisenabelUIEvent = arg2

			arg0:InitStage(arg1)

			local var0 = arg0.model:GetPlayableStory()

			if not var0 then
				arg0()

				return
			end

			arg0.mediator:PlayStory(var0, arg0)
		end,
		function(arg0)
			if arg1.hp > 0 then
				arg0.mediator:DoCurtainUp(arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			arg0.mediator:OnInited()
		end
	})
end

function var0.NetData(arg0, arg1)
	arg0.model:UpdateData(arg1)
	arg0.mediator:OnMonsterHpUpdate(arg0.model.mosterNian.hp)
	arg0.mediator:OnAttackCntUpdate(arg0.model.attackCnt, arg0.isFake or arg0.model.mosterNian.hp <= 0)
end

function var0.InitStage(arg0, arg1)
	arg0.model:AddMonsterNian(arg1.hp, arg1.maxHp)
	arg0.model:AddFuShun()

	local var0 = arg0.model.mosterNian.hp
	local var1 = arg0.model.mosterNian.maxHp

	arg0.mediator:OnAddMonsterNian(var0, var1)
	arg0.mediator:OnAddFuShun(var0)
	arg0.model:SetAttackCnt(arg1.leftCount)
	arg0.mediator:OnAttackCntUpdate(arg0.model.attackCnt, arg0.isFake or arg0.model.mosterNian.hp <= 0)
	arg0.model:SetStorys(arg1.storys)
end

function var0.Input(arg0, arg1)
	if arg0.isOnAction then
		return
	end

	arg0:RemoveInputTimer()
	arg0:UpdateActionStr(arg1)

	local var0 = arg0.model:IsMatchAction()
	local var1 = var0 and 0.5 or BeatMonsterNianConst.INPUT_TIME

	if var0 then
		arg0.OnDisenabelUIEvent(true)

		arg0.isOnAction = true
	end

	arg0.inputTimer = Timer.New(function()
		local var0 = arg0.model:GetMatchAction()
		local var1 = arg0.model:GetMonsterAction()

		arg0:UpdateActionStr("")

		if var0 then
			arg0:StartAction(var0, var1)
		end
	end, var1, 1)

	arg0.inputTimer:Start()
end

function var0.StartAction(arg0, arg1, arg2)
	arg0:RemoveAnimationTimer()

	local var0

	seriesAsync({
		function(arg0)
			arg0:SendRequestToServer(function(arg0)
				var0 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0.mediator:OnChangeFuShunAction(arg1)
			arg0.mediator:OnChangeNianAction(arg2)

			arg0.animationTimer = Timer.New(arg0, 2, 1)

			arg0.animationTimer:Start()
		end,
		function(arg0)
			local var0 = arg0.model.mosterNian.hp
			local var1 = arg0.model.mosterNian.maxHp

			arg0.mediator:OnUIHpUpdate(var0, var1, arg0)
		end,
		function(arg0)
			local var0 = arg0.model:GetPlayableStory()

			if not var0 then
				arg0()

				return
			end

			arg0.mediator:PlayStory(var0, arg0)
		end,
		function(arg0)
			if not var0 or #var0 == 0 then
				arg0()

				return
			end

			arg0.mediator:DisplayAwards(var0, arg0)
		end,
		function(arg0)
			arg0.isOnAction = false

			arg0.OnDisenabelUIEvent(false)
		end
	})
end

function var0.SendRequestToServer(arg0, arg1)
	if arg0.isFake then
		arg0:NetData({
			hp = arg0.model:RandomDamage(),
			maxHp = arg0.model:GetMonsterMaxHp(),
			leftCount = arg0.model:GetAttackCount() - 1,
			storys = {}
		})
		arg1()
	else
		pg.m02:sendNotification(GAME.ACT_BEAT_MONSTER_NIAN, {
			cmd = 1,
			activity_id = ActivityConst.BEAT_MONSTER_NIAN_2020,
			callback = arg1
		})
	end
end

function var0.UpdateActionStr(arg0, arg1)
	arg0.model:UpdateActionStr(arg1)

	local var0 = arg0.model:GetActionStr()

	arg0.mediator:OnInputChange(var0)
end

function var0.RemoveInputTimer(arg0)
	if arg0.inputTimer then
		arg0.inputTimer:Stop()

		arg0.inputTimer = nil
	end
end

function var0.RemoveAnimationTimer(arg0)
	if arg0.animationTimer then
		arg0.animationTimer:Stop()

		arg0.animationTimer = nil
	end
end

function var0.ReStartGame(arg0)
	arg0.isFake = true

	arg0:NetData({
		hp = 10,
		leftCount = 10,
		maxHp = 10,
		storys = {}
	})
	arg0.mediator:OnUIHpUpdate(10, 10)
end

function var0.Dispose(arg0)
	arg0:RemoveAnimationTimer()
	arg0:RemoveInputTimer()
	arg0.mediator:Dispose()
	arg0.model:Dispose()

	arg0.OnDisenabelUIEvent = nil
end

return var0
