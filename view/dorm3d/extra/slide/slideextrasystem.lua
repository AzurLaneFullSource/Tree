local var0_0 = class("SlideExtraSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.SHOW_INTERACTION = "SlideExtraSystem.SHOW_INTERACTION"
var0_0.HIDE_INTERACTION = "SlideExtraSystem.HIDE_INTERACTION"
var0_0.SHOW_PERFORMANCE = "SlideExtraSystem.SHOW_PERFORMANCE"
var0_0.HIDE_PERFORMANCE = "SlideExtraSystem.HIDE_PERFORMANCE"

function var0_0.RegisterNodeCanvas(arg0_1)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.ShowInteraction", function()
		pg.m02:sendNotification(var0_0.SHOW_INTERACTION)
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.HideInteraction", function()
		pg.m02:sendNotification(var0_0.HIDE_INTERACTION)
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.ShowPerformance", function()
		pg.m02:sendNotification(var0_0.SHOW_PERFORMANCE)
	end)
	pg.NodeCanvasMgr.GetInstance():RegisterFunc("Slide.HidePerformance", function()
		pg.m02:sendNotification(var0_0.HIDE_PERFORMANCE)
	end)
end

function var0_0.Init(arg0_6)
	arg0_6:RegisterNodeCanvas()
	arg0_6:InitScene()
	arg0_6:InitData()
	arg0_6:InitSlide()
	arg0_6:Emit(Dorm3dRoomMediator.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE)

	arg0_6.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_6:OnUpdate()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_6.updateHandler)

	arg0_6.pickTimer = Timer.New(function()
		arg0_6:OnPick()
	end, SlideConst.TIMER_INTERVAL, -1)

	arg0_6.pickTimer:Start()
	arg0_6:OnPick()
end

function var0_0.InitScene(arg0_11)
	arg0_11.sceneSlideConfigs = GameObject.Find("SlideConfigs").transform
	arg0_11.movePointsRoot = arg0_11.sceneSlideConfigs:Find("MovePoints")
	arg0_11.defaultPointsRoot = arg0_11.sceneSlideConfigs:Find("DefaultPoints")
end

function var0_0.InitSlide(arg0_12)
	warning("SystemInitSlide")

	if not arg0_12:Get("doneFirstSlotFresh") or arg0_12.slideInited then
		return
	end

	arg0_12.slideInited = true
	arg0_12.slideGo = arg0_12:Func("GetSceneItem", "FurnitureSlots/140101/Slide(Clone)")

	assert(arg0_12.slideGo, "Furniture Slide not found in scene")
	warning("InitSlide Done")

	arg0_12.slideTreeOwner = GetOrAddComponent(arg0_12.slideGo, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_12.slideTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_12:Get("player")))

	arg0_12.slideTreeOwner.enabled = true
	arg0_12.performanceTreeOwner = GetOrAddComponent(arg0_12.slideGo:Find("performance_interact_point"), typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_12.performanceTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_12:Get("player")))

	arg0_12.performanceTreeOwner.enabled = true
end

function var0_0.InitData(arg0_13)
	arg0_13.commandConfigDic = {}
	arg0_13.defaultPoints = {}

	_.each(pg.dorm3d_minigame_slide.all, function(arg0_14)
		arg0_13.commandConfigDic[arg0_14] = {}

		_.each(pg.dorm3d_minigame_slide[arg0_14].slide_command, function(arg0_15)
			table.insert(arg0_13.commandConfigDic[arg0_14], SlideCommand.New(arg0_15, arg0_13.movePointsRoot))
		end)

		local var0_14 = arg0_13.defaultPointsRoot:Find(pg.dorm3d_minigame_slide[arg0_14].slide_zone)

		arg0_13.defaultPoints[arg0_14] = var0_14
	end)

	arg0_13.inviteList = getProxy(ApartmentProxy):GetSlideInviteList()
	arg0_13.randomList = Clone(arg0_13.inviteList)
	arg0_13.ladyDic = {}

	_.each(arg0_13.inviteList, function(arg0_16)
		arg0_13:AddLadySlide(arg0_16)
	end)
end

function var0_0.AddLadySlide(arg0_17, arg1_17)
	local var0_17 = arg0_17:Get("ladyDict")[arg1_17]

	arg0_17.ladyDic[arg1_17] = LadySlide.New(arg1_17, var0_17, arg0_17.commandConfigDic[arg1_17], arg0_17.defaultPoints[arg1_17], function(arg0_18)
		arg0_17:PlayVFX(arg0_18)
	end)

	arg0_17.ladyDic[arg1_17]:Reset()
end

function var0_0.RemoveLadySlide(arg0_19, arg1_19)
	if arg0_19.ladyDic[arg1_19] then
		arg0_19:Func("ChangeCharacterPosition", arg0_19.ladyDic[arg1_19].ladyEnv)
		arg0_19.ladyDic[arg1_19]:Dispose()

		arg0_19.ladyDic[arg1_19] = nil
	end
end

function var0_0.OnPick(arg0_20)
	if #arg0_20.inviteList == 0 then
		return
	end

	arg0_20.currentGroupId = arg0_20:RandomPick()

	if arg0_20.ladyDic[arg0_20.currentGroupId].ladyEnv:GetBlackboardValue("inWatchMode") then
		if #arg0_20.inviteList > 1 then
			arg0_20:OnPick()
		end

		return
	end

	arg0_20.ladyDic[arg0_20.currentGroupId]:StartMove()
end

function var0_0.RandomPick(arg0_21)
	if not arg0_21.randomList or #arg0_21.randomList == 0 then
		arg0_21.randomList = Clone(arg0_21.inviteList)
	end

	local var0_21 = math.random(1, #arg0_21.randomList)
	local var1_21 = arg0_21.randomList[var0_21]

	table.remove(arg0_21.randomList, var0_21)

	return var1_21
end

function var0_0.TestMove(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.ladyDic) do
		iter1_22:EndMove()
		iter1_22:StartMove()

		arg0_22.currentGroupId = iter1_22.id

		return
	end
end

function var0_0.UpdateSlideInviteList(arg0_23, arg1_23, arg2_23)
	if table.contains(arg2_23, arg0_23.currentGroupId) then
		arg0_23.ladyDic[arg0_23.currentGroupId]:EndMove()
	end

	_.each(arg2_23, function(arg0_24)
		arg0_23:RemoveLadySlide(arg0_24)
		table.removebyvalue(arg0_23.inviteList, arg0_24)
		table.removebyvalue(arg0_23.randomList, arg0_24)
	end)
	_.each(arg1_23, function(arg0_25)
		if not table.contains(arg0_23.inviteList, arg0_25) then
			table.insert(arg0_23.inviteList, arg0_25)
			arg0_23:AddLadySlide(arg0_25)
		end

		if not table.contains(arg0_23.randomList, arg0_25) then
			table.insert(arg0_23.randomList, arg0_25)
		end
	end)
end

function var0_0.OnUpdate(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.ladyDic) do
		iter1_26:OnUpdate()
	end
end

function var0_0.PlayVFX(arg0_27, arg1_27)
	local var0_27 = arg0_27.sceneSlideConfigs:Find("vfx/" .. arg1_27)

	setActive(var0_27, false)
	onNextTick(function()
		setActive(var0_27, true)
	end)
end

function var0_0.Dispose(arg0_29)
	UpdateBeat:RemoveListener(arg0_29.updateHandler)
	arg0_29.pickTimer:Stop()

	for iter0_29, iter1_29 in pairs(arg0_29.ladyDic) do
		iter1_29:Dispose()
	end

	arg0_29.slideTreeOwner.enabled = false
	arg0_29.performanceTreeOwner.enabled = false

	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HideInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowPerformance")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HidePerformance")
	arg0_29:Emit(Dorm3dRoomMediator.REMOVE_EXTRA_SYSTEM, FurnitureSlideExtraMediator)
end

function var0_0.HandleNotification(arg0_30, arg1_30, arg2_30)
	if arg1_30 == ApartmentProxy.UPDATE_SLIDE_INVITE_LIST then
		arg0_30:UpdateSlideInviteList(arg2_30.addIds, arg2_30.removeIds)
	elseif arg1_30 == Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE then
		arg0_30:InitSlide()
	end
end

function var0_0.GetInterests()
	return {
		ApartmentProxy.UPDATE_SLIDE_INVITE_LIST,
		Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE
	}
end

function var0_0.IsOpen(arg0_32)
	return arg0_32:GetConfigID() == SlideConst.ROOM_ID and arg0_32:IsFurnitureSetIn(SlideConst.FURNITURE_ID)
end

return var0_0
