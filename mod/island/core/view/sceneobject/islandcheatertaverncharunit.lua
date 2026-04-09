local var0_0 = class("IslandCheaterTavernCharUnit", import(".IslandSceneUnit"))

function var0_0.OnAttach(arg0_1, arg1_1)
	var0_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1.tf = tf(arg1_1)
	arg0_1.seatId = arg0_1.data.index
	arg0_1.animator = arg0_1.tf:GetChild(0):GetComponent(typeof(UnityEngine.Animator))

	arg0_1:InitDisplayState()
end

function var0_0.OnPlayerOut(arg0_2, arg1_2)
	if arg1_2 then
		pg.ViewUtils.SetLayer(arg0_2.tf, Layer.Default)
	end

	arg0_2.animator:CrossFadeInFixedTime("fallout", 0, 0)
	setActive(arg0_2.effectGo, true)
end

function var0_0.OnPlayerQuestion(arg0_3)
	if arg0_3.questTimer then
		arg0_3.questTimer:Stop()
	end

	pg.ViewUtils.SetLayer(arg0_3.tf, Layer.Default)

	arg0_3.questTimer = Timer.New(function()
		pg.ViewUtils.SetLayer(arg0_3.tf, Layer.UIHidden)
	end, IslandCheaterTavernConst.qusanimationTime, 1)

	arg0_3.questTimer:Start()
end

function var0_0.OnPlayWinAnimation(arg0_5)
	if arg0_5.winTimer then
		arg0_5.winTimer:Stop()
	end

	pg.ViewUtils.SetLayer(arg0_5.tf, Layer.Default)

	arg0_5.winTimer = Timer.New(function()
		pg.ViewUtils.SetLayer(arg0_5.tf, Layer.UIHidden)
	end, IslandCheaterTavernConst.winAnimationTime, 1)

	arg0_5.winTimer:Start()
end

function var0_0.InitDisplayState(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland():GetCheaterTavernAgency()

	if not var0_7:IsConnecting() then
		return
	end

	if IsNil(arg0_7.tf) then
		return
	end

	local var1_7 = var0_7:GetMainPlayer()

	if var1_7 then
		if arg0_7.seatId == var1_7.seat then
			pg.ViewUtils.SetLayer(arg0_7.tf, Layer.UIHidden)
		else
			pg.ViewUtils.SetLayer(arg0_7.tf, Layer.Default)
		end
	end
end

function var0_0.OnDetach(arg0_8)
	if arg0_8.questTimer then
		arg0_8.questTimer:Stop()
	end

	if arg0_8.winTimer then
		arg0_8.winTimer:Stop()
	end

	if arg0_8.effectGo then
		setActive(arg0_8.effectGo, false)
	end
end

function var0_0.SetEffect(arg0_9, arg1_9)
	arg0_9.effectGo = arg1_9
end

return var0_0
