local var0_0 = class("IslandCheaterTavernPlayerUnit", import(".IslandSceneUnit"))
local var1_0 = {
	Question = 1
}

function var0_0.OnAttach(arg0_1, arg1_1)
	var0_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1.characterHandleController = arg0_1._go:GetComponent(typeof(CharacterHandleController))

	arg0_1.characterHandleController:AddStateEnterFunc(function(arg0_2, arg1_2)
		arg0_1:StateEnterHandle(arg0_2, arg1_2)
	end)
	arg0_1.characterHandleController:AddStateExitFunc(function(arg0_3, arg1_3)
		arg0_1:StateExitHandle(arg0_3, arg1_3)
	end)
	arg0_1.characterHandleController:AddStateUpdateFunc(function(arg0_4, arg1_4)
		arg0_1:StateUpdateHandle(arg0_4, arg1_4)
	end)

	arg0_1.objTfList = {}
	arg0_1._tf = arg0_1._go.transform
	arg0_1.animator = arg0_1._tf:GetChild(0):GetComponent(typeof(Animator))
	arg0_1.shipDressHelper = IslandShipDressHelperMiniGameNew.New()

	local var0_1 = getProxy(IslandProxy):GetIsland():GetCheaterTavernAgency():GetPlayerData(arg0_1.id)
	local var1_1 = PlayRoomTools.GetGameViewID(var0_1.player_info.user_view)

	arg0_1.shipDressHelper:SetShipId(0, var1_1.dress_list)

	local var2_1 = arg0_1.id == getProxy(PlayerProxy):getRawData().id

	if var2_1 then
		pg.ViewUtils.SetLayer(arg0_1._tf, Layer.UIHidden)
	else
		pg.ViewUtils.SetLayer(arg0_1._tf, Layer.Default)
	end

	arg0_1.shipDressHelper:OnRoleLoaded(arg0_1._tf, nil, function(arg0_5)
		if var2_1 then
			pg.ViewUtils.SetLayer(arg0_5.transform, Layer.UIHidden)
		end
	end)

	arg0_1.playInAnimationTimer = Timer.New(function()
		local var0_6 = (math.random() - 0.5) * 0.5

		for iter0_6 = 1, arg0_1.animator.layerCount do
			arg0_1.animator:Play("sit_idle", iter0_6 - 1, var0_6)
		end
	end, 2, 1)

	arg0_1.playInAnimationTimer:Start()
end

function var0_0.StateEnterHandle(arg0_7, arg1_7, arg2_7)
	if arg1_7 == var1_0.Question then
		arg0_7.effectLoaded = false
		arg0_7.effectUnloaded = false
		arg0_7.showEffectTime = IslandCheaterTavernConst.quesAnimionshowEffectFrame / IslandCheaterTavernConst.quesAnimionTotalFrame
		arg0_7.unShowEffectTime = IslandCheaterTavernConst.quesAnimionUnshowEffectFrame / IslandCheaterTavernConst.quesAnimionTotalFrame
	end
end

function var0_0.StateUpdateHandle(arg0_8, arg1_8, arg2_8)
	if arg1_8 == var1_0.Question then
		local var0_8 = arg0_8.animator:GetCurrentAnimatorStateInfo(0).normalizedTime % 1

		if not arg0_8.effectLoaded and var0_8 >= arg0_8.showEffectTime then
			arg0_8.effectLoaded = true

			arg0_8:LoadEffect(arg2_8)
		end

		if not arg0_8.effectUnloaded and var0_8 >= arg0_8.unShowEffectTime then
			arg0_8.effectUnloaded = true

			arg0_8:UnLoadEffect(arg2_8)
		end
	end
end

function var0_0.StateExitHandle(arg0_9, arg1_9, arg2_9)
	if arg1_9 == var1_0.Question then
		arg0_9.effectUnloaded = true

		arg0_9:UnLoadEffect(arg2_9)
	end
end

function var0_0.LoadEffect(arg0_10, arg1_10)
	local var0_10 = arg0_10.objTfList[arg1_10]

	if var0_10 then
		setActive(var0_10, true)
		setParent(var0_10, arg0_10._tf)

		return
	end

	local var1_10 = pg.island_unit_item[arg1_10].model
	local var2_10 = LoadAny(var1_10, nil)
	local var3_10 = Object.Instantiate(var2_10)

	arg0_10.objTfList[arg1_10] = var3_10.transform

	setParent(arg0_10.objTfList[arg1_10], arg0_10._tf)
end

function var0_0.UnLoadEffect(arg0_11, arg1_11)
	if arg0_11.objTfList[arg1_11] then
		setActive(arg0_11.objTfList[arg1_11], false)
	end
end

function var0_0.DestroyInteractiveTools(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.objTfList) do
		Object.Destroy(iter1_12.gameObject)
	end

	arg0_12.objTfList = {}
end

function var0_0.OnPlayerQuestion(arg0_13, arg1_13)
	if arg1_13 then
		pg.ViewUtils.SetLayer(arg0_13._tf, Layer.Default)

		if arg0_13.questTimer then
			arg0_13.questTimer:Stop()
		end

		arg0_13.questTimer = Timer.New(function()
			pg.ViewUtils.SetLayer(arg0_13._tf, Layer.UIHidden)
		end, IslandCheaterTavernConst.qusanimationTime, 1)

		arg0_13.questTimer:Start()
	end

	for iter0_13 = 1, arg0_13.animator.layerCount do
		arg0_13.animator:CrossFadeInFixedTime("question", 0, iter0_13 - 1)
	end
end

function var0_0.OnPlayWinAnimation(arg0_15, arg1_15, arg2_15)
	if arg1_15 then
		pg.ViewUtils.SetLayer(arg0_15._tf, Layer.Default)

		local var0_15 = "winseat0" .. arg2_15

		CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_15)

		if arg0_15.winTimer then
			arg0_15.winTimer:Stop()
		end

		arg0_15.winTimer = Timer.New(function()
			pg.ViewUtils.SetLayer(arg0_15._tf, Layer.UIHidden)

			local var0_16 = "lookSeet0" .. arg2_15

			CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_16)
		end, IslandCheaterTavernConst.winAnimationTime, 1)

		arg0_15.winTimer:Start()
	end

	for iter0_15 = 1, arg0_15.animator.layerCount do
		arg0_15.animator:CrossFadeInFixedTime("win01", 0, iter0_15 - 1)
	end
end

function var0_0.OnPlayerOut(arg0_17, arg1_17, arg2_17)
	if arg1_17 == getProxy(PlayerProxy):getRawData().id then
		local var0_17 = "failoutSeet0" .. arg2_17

		pg.ViewUtils.SetLayer(arg0_17._tf, Layer.Default)
		CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_17)

		if arg0_17.outTimer then
			arg0_17.outTimer:Stop()
		end

		arg0_17.outTimer = Timer.New(function()
			local var0_18 = "lookSeet0" .. arg2_17

			CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_18)
		end, 3, 1)

		arg0_17.outTimer:Start()
	end

	for iter0_17 = 1, arg0_17.animator.layerCount do
		arg0_17.animator:CrossFadeInFixedTime("fallout", 0, iter0_17 - 1)
	end
end

function var0_0.OnDetach(arg0_19)
	arg0_19.shipDressHelper:Destroy()

	if arg0_19.outTimer then
		arg0_19.outTimer:Stop()
	end

	if arg0_19.questTimer then
		arg0_19.questTimer:Stop()
	end

	if arg0_19.playInAnimationTimer then
		arg0_19.playInAnimationTimer:Stop()
	end

	if arg0_19.winTimer then
		arg0_19.winTimer:Stop()
	end

	arg0_19:DestroyInteractiveTools()
end

return var0_0
