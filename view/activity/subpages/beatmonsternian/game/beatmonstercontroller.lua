local var0_0 = class("BeatMonsterController")

function var0_0.Ctor(arg0_1)
	arg0_1.mediator = BeatMonsterMeidator.New(arg0_1)
	arg0_1.model = BeatMonsterModel.New(arg0_1)
end

function var0_0.SetUp(arg0_2, arg1_2, arg2_2)
	seriesAsync({
		function(arg0_3)
			arg0_2.OnDisenabelUIEvent = arg2_2

			arg0_2:InitStage(arg1_2)

			local var0_3 = arg0_2.model:GetPlayableStory()

			if not var0_3 then
				arg0_3()

				return
			end

			arg0_2.mediator:PlayStory(var0_3, arg0_3)
		end,
		function(arg0_4)
			if arg1_2.hp > 0 then
				arg0_2.mediator:DoCurtainUp(arg0_4)
			else
				arg0_4()
			end
		end,
		function(arg0_5)
			arg0_2.mediator:OnInited()
		end
	})
end

function var0_0.NetData(arg0_6, arg1_6)
	arg0_6.model:UpdateData(arg1_6)
	arg0_6.mediator:OnMonsterHpUpdate(arg0_6.model.mosterNian.hp)
	arg0_6.mediator:OnAttackCntUpdate(arg0_6.model.attackCnt, arg0_6.isFake or arg0_6.model.mosterNian.hp <= 0)
end

function var0_0.InitStage(arg0_7, arg1_7)
	arg0_7.model:AddMonsterNian(arg1_7.hp, arg1_7.maxHp)
	arg0_7.model:AddFuShun()

	local var0_7 = arg0_7.model.mosterNian.hp
	local var1_7 = arg0_7.model.mosterNian.maxHp

	arg0_7.mediator:OnAddMonsterNian(var0_7, var1_7)
	arg0_7.mediator:OnAddFuShun(var0_7)
	arg0_7.model:SetAttackCnt(arg1_7.leftCount)
	arg0_7.mediator:OnAttackCntUpdate(arg0_7.model.attackCnt, arg0_7.isFake or arg0_7.model.mosterNian.hp <= 0)
	arg0_7.model:SetStorys(arg1_7.storys)
end

function var0_0.Input(arg0_8, arg1_8)
	if arg0_8.isOnAction then
		return
	end

	arg0_8:RemoveInputTimer()
	arg0_8:UpdateActionStr(arg1_8)

	local var0_8 = arg0_8.model:IsMatchAction()
	local var1_8 = var0_8 and 0.5 or BeatMonsterNianConst.INPUT_TIME

	if var0_8 then
		arg0_8.OnDisenabelUIEvent(true)

		arg0_8.isOnAction = true
	end

	arg0_8.inputTimer = Timer.New(function()
		local var0_9 = arg0_8.model:GetMatchAction()
		local var1_9 = arg0_8.model:GetMonsterAction()

		arg0_8:UpdateActionStr("")

		if var0_8 then
			arg0_8:StartAction(var0_9, var1_9)
		end
	end, var1_8, 1)

	arg0_8.inputTimer:Start()
end

function var0_0.StartAction(arg0_10, arg1_10, arg2_10)
	arg0_10:RemoveAnimationTimer()

	local var0_10

	seriesAsync({
		function(arg0_11)
			arg0_10:SendRequestToServer(function(arg0_12)
				var0_10 = arg0_12

				arg0_11()
			end)
		end,
		function(arg0_13)
			arg0_10.mediator:OnChangeFuShunAction(arg1_10)
			arg0_10.mediator:OnChangeNianAction(arg2_10)

			arg0_10.animationTimer = Timer.New(arg0_13, 2, 1)

			arg0_10.animationTimer:Start()
		end,
		function(arg0_14)
			local var0_14 = arg0_10.model.mosterNian.hp
			local var1_14 = arg0_10.model.mosterNian.maxHp

			arg0_10.mediator:OnUIHpUpdate(var0_14, var1_14, arg0_14)
		end,
		function(arg0_15)
			local var0_15 = arg0_10.model:GetPlayableStory()

			if not var0_15 then
				arg0_15()

				return
			end

			arg0_10.mediator:PlayStory(var0_15, arg0_15)
		end,
		function(arg0_16)
			if not var0_10 or #var0_10 == 0 then
				arg0_16()

				return
			end

			arg0_10.mediator:DisplayAwards(var0_10, arg0_16)
		end,
		function(arg0_17)
			arg0_10.isOnAction = false

			arg0_10.OnDisenabelUIEvent(false)
		end
	})
end

function var0_0.SendRequestToServer(arg0_18, arg1_18)
	if arg0_18.isFake then
		arg0_18:NetData({
			hp = arg0_18.model:RandomDamage(),
			maxHp = arg0_18.model:GetMonsterMaxHp(),
			leftCount = arg0_18.model:GetAttackCount() - 1,
			storys = {}
		})
		arg1_18()
	else
		pg.m02:sendNotification(GAME.ACT_BEAT_MONSTER_NIAN, {
			cmd = 1,
			activity_id = ActivityConst.BEAT_MONSTER_NIAN_2020,
			callback = arg1_18
		})
	end
end

function var0_0.UpdateActionStr(arg0_19, arg1_19)
	arg0_19.model:UpdateActionStr(arg1_19)

	local var0_19 = arg0_19.model:GetActionStr()

	arg0_19.mediator:OnInputChange(var0_19)
end

function var0_0.RemoveInputTimer(arg0_20)
	if arg0_20.inputTimer then
		arg0_20.inputTimer:Stop()

		arg0_20.inputTimer = nil
	end
end

function var0_0.RemoveAnimationTimer(arg0_21)
	if arg0_21.animationTimer then
		arg0_21.animationTimer:Stop()

		arg0_21.animationTimer = nil
	end
end

function var0_0.ReStartGame(arg0_22)
	arg0_22.isFake = true

	arg0_22:NetData({
		hp = 10,
		leftCount = 10,
		maxHp = 10,
		storys = {}
	})
	arg0_22.mediator:OnUIHpUpdate(10, 10)
end

function var0_0.Dispose(arg0_23)
	arg0_23:RemoveAnimationTimer()
	arg0_23:RemoveInputTimer()
	arg0_23.mediator:Dispose()
	arg0_23.model:Dispose()

	arg0_23.OnDisenabelUIEvent = nil
end

return var0_0
