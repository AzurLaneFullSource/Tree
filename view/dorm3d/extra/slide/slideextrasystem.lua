local var0_0 = class("SlideExtraSystem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg1_1
	arg0_1.scene = arg2_1
end

function var0_0.InitScene(arg0_2)
	arg0_2.sceneSlideConfigs = GameObject.Find("SlideConfigs").transform
	arg0_2.movePointsTf = arg0_2.sceneSlideConfigs:Find("MovePoints")
	arg0_2.ladyMovePointsDic = {}

	eachChild(arg0_2.movePointsTf, function(arg0_3)
		local var0_3 = tonumber(arg0_3.name)

		arg0_2.ladyMovePointsDic[var0_3] = {}

		eachChild(arg0_3, function(arg0_4)
			arg0_2.ladyMovePointsDic[var0_3][arg0_4.name] = {}

			for iter0_4 = 1, arg0_4.childCount do
				table.insert(arg0_2.ladyMovePointsDic[var0_3][arg0_4.name], arg0_4:GetChild(iter0_4 - 1))
			end
		end)
	end)
end

function var0_0.InitSlide(arg0_5)
	if not arg0_5.scene.doneFirstSlotFresh or arg0_5.slideInited then
		return
	end

	arg0_5.slideInited = true
	arg0_5.slideGo = arg0_5.scene:GetSceneItem("FurnitureSlots/140101/Slide(Clone)")

	assert(arg0_5.slideGo, "Furniture Slide not found in scene")

	local var0_5 = GetOrAddComponent(arg0_5.slideGo, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	var0_5.graph.blackboard:AddVariable("_player", go(arg0_5.scene.player))

	var0_5.enabled = true

	local var1_5 = GetOrAddComponent(arg0_5.slideGo:Find("performance_interact_point"), typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	var1_5.graph.blackboard:AddVariable("_player", go(arg0_5.scene.player))

	var1_5.enabled = true
end

function var0_0.Init(arg0_6)
	arg0_6:InitData()
	arg0_6:InitScene()
	arg0_6:InitSlide()

	arg0_6.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_6:OnUpdate()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_6.updateHandler)

	arg0_6.pickTimer = Timer.New(function()
		return
	end, SlideConst.TIMER_INTERVAL)

	arg0_6.pickTimer:Start()
end

function var0_0.InitData(arg0_11)
	arg0_11.inviteList = getProxy(ApartmentProxy):GetSlideInviteList()
	arg0_11.randomList = Clone(arg0_11.inviteList)
	arg0_11.ladyDic = {}

	_.each(arg0_11.inviteList, function(arg0_12)
		local var0_12 = arg0_11.scene.ladyDict[arg0_12]

		arg0_11.ladyDic[arg0_12] = LadySlide.New(var0_12)
	end)
end

function var0_0.RamdomPick(arg0_13)
	if not arg0_13.randomList or #arg0_13.randomList == 0 then
		arg0_13.randomList = Clone(arg0_13.inviteList)
	end

	local var0_13 = math.random(1, #arg0_13.randomList)
	local var1_13 = arg0_13.randomList[var0_13]

	table.remove(arg0_13.randomList, var0_13)

	return var1_13
end

function var0_0.UpdateSlideInviteList(arg0_14, arg1_14, arg2_14)
	if table.contains(arg2_14, arg0_14.currentGroupId) then
		-- block empty
	end

	_.each(arg2_14, function(arg0_15)
		table.removebyvalue(arg0_14.inviteList, arg0_15)
		table.removebyvalue(arg0_14.randomList, arg0_15)
	end)
	_.each(arg1_14, function(arg0_16)
		if not table.contains(arg0_14.inviteList, arg0_16) then
			table.insert(arg0_14.inviteList, arg0_16)

			local var0_16 = arg0_14.scene.ladyDict[arg0_16]

			arg0_14.ladyDic[arg0_16] = LadySlide.New(var0_16)
		end

		if not table.contains(arg0_14.randomList, arg0_16) then
			table.insert(arg0_14.randomList, arg0_16)
		end
	end)
end

function var0_0.OnUpdate(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.ladyDic) do
		iter1_17:OnUpdate()
	end
end

function var0_0.Dispose(arg0_18)
	UpdateBeat:RemoveListener(arg0_18.updateHandler)
	arg0_18.pickTimer:Stop()
end

function var0_0.IsOpen(arg0_19)
	return false
end

return var0_0
