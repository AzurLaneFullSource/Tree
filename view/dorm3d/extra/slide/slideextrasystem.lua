local var0_0 = class("SlideExtraSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.SHOW_INTERACTION = "SlideExtraSystem.SHOW_INTERACTION"
var0_0.HIDE_INTERACTION = "SlideExtraSystem.HIDE_INTERACTION"
var0_0.SHOW_PERFORMANCE = "SlideExtraSystem.SHOW_PERFORMANCE"
var0_0.HIDE_PERFORMANCE = "SlideExtraSystem.HIDE_PERFORMANCE"

function var0_0.OnInit(arg0_1)
	arg0_1:RegisterNodeCanvas()
	arg0_1:InitScene()
	arg0_1:InitData()
	arg0_1:InitSlide()
	arg0_1:Emit(Dorm3dRoomMediator.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE)

	arg0_1.pickTimer = Timer.New(function()
		arg0_1:OnPick()
	end, SlideConst.TIMER_INTERVAL, -1)

	arg0_1.pickTimer:Start()
	arg0_1:OnPick()
end

function var0_0.OnUpdate(arg0_3, arg1_3)
	for iter0_3, iter1_3 in pairs(arg0_3.ladyDic) do
		iter1_3:OnUpdate()
	end
end

function var0_0.OnDispose(arg0_4)
	if arg0_4.pickTimer then
		arg0_4.pickTimer:Stop()

		arg0_4.pickTimer = nil
	end

	for iter0_4, iter1_4 in pairs(arg0_4.ladyDic) do
		arg0_4:RemoveLadySlide(iter0_4)
	end

	arg0_4:Func("ChangePlayerPosition")

	if arg0_4.slideTreeOwner then
		arg0_4.slideTreeOwner.enabled = false
	end

	if arg0_4.performanceTreeOwner then
		arg0_4.performanceTreeOwner.enabled = false
	end

	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HideInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowPerformance")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HidePerformance")
	arg0_4:Emit(Dorm3dRoomMediator.REMOVE_EXTRA_SYSTEM, FurnitureSlideExtraMediator)
end

function var0_0.OnHandleNotification(arg0_5, arg1_5, arg2_5)
	if arg1_5 == ApartmentProxy.UPDATE_SLIDE_INVITE_LIST then
		arg0_5:UpdateSlideInviteList(arg2_5.addIds, arg2_5.removeIds)
	elseif arg1_5 == Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE then
		arg0_5:InitSlide()
	end
end

function var0_0.GetInterests()
	return {
		ApartmentProxy.UPDATE_SLIDE_INVITE_LIST,
		Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE
	}
end

function var0_0.IsOpen(arg0_7)
	return arg0_7:GetConfigID() == SlideConst.ROOM_ID and arg0_7:IsFurnitureSetIn(SlideConst.FURNITURE_ID)
end

function var0_0.RegisterNodeCanvas(arg0_8)
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

function var0_0.InitScene(arg0_13)
	arg0_13.sceneSlideConfigs = GameObject.Find("SlideConfigs").transform
	arg0_13.movePointsRoot = arg0_13.sceneSlideConfigs:Find("MovePoints")
	arg0_13.defaultPointsRoot = arg0_13.sceneSlideConfigs:Find("DefaultPoints")
end

function var0_0.InitSlide(arg0_14)
	warning("SystemInitSlide")

	if not arg0_14:Get("doneFirstSlotFresh") or arg0_14.slideInited then
		return
	end

	arg0_14.slideInited = true
	arg0_14.slideGo = arg0_14:GetSceneItem("FurnitureSlots/140101/Slide(Clone)")

	assert(arg0_14.slideGo, "Furniture Slide not found in scene")
	warning("InitSlide Done")

	arg0_14.slideTreeOwner = GetOrAddComponent(arg0_14.slideGo, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_14.slideTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_14:Get("player")))

	arg0_14.slideTreeOwner.enabled = true
	arg0_14.performanceTreeOwner = GetOrAddComponent(arg0_14.slideGo:Find("performance_interact_point"), typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_14.performanceTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_14:Get("player")))

	arg0_14.performanceTreeOwner.enabled = true
end

function var0_0.InitData(arg0_15)
	arg0_15.commandConfigDic = {}
	arg0_15.defaultPoints = {}

	_.each(pg.dorm3d_minigame_slide.all, function(arg0_16)
		arg0_15.commandConfigDic[arg0_16] = {}

		_.each(pg.dorm3d_minigame_slide[arg0_16].slide_command, function(arg0_17)
			table.insert(arg0_15.commandConfigDic[arg0_16], SlideCommand.New(arg0_17, arg0_15.movePointsRoot))
		end)

		local var0_16 = arg0_15.defaultPointsRoot:Find(pg.dorm3d_minigame_slide[arg0_16].slide_zone)

		arg0_15.defaultPoints[arg0_16] = var0_16
	end)

	arg0_15.inviteList = getProxy(ApartmentProxy):GetSlideInviteList()
	arg0_15.randomList = Clone(arg0_15.inviteList)
	arg0_15.ladyDic = {}

	_.each(arg0_15.inviteList, function(arg0_18)
		arg0_15:AddLadySlide(arg0_18)
	end)
end

function var0_0.AddLadySlide(arg0_19, arg1_19)
	local var0_19 = arg0_19:Get("ladyDict")[arg1_19]

	arg0_19.ladyDic[arg1_19] = LadySlide.New(arg1_19, var0_19, arg0_19.commandConfigDic[arg1_19], arg0_19.defaultPoints[arg1_19], function(arg0_20)
		arg0_19:PlayVFX(arg0_20)
	end)

	arg0_19.ladyDic[arg1_19]:Reset()
end

function var0_0.RemoveLadySlide(arg0_21, arg1_21)
	if arg0_21.ladyDic[arg1_21] then
		arg0_21:Func("ChangeCharacterPosition", arg0_21.ladyDic[arg1_21].ladyEnv)
		arg0_21.ladyDic[arg1_21].ladyEnv:PlaySingleAction(SlideConst.IDLE_ANIM)
		arg0_21.ladyDic[arg1_21]:Dispose()

		arg0_21.ladyDic[arg1_21] = nil
	end
end

function var0_0.OnPick(arg0_22)
	if #arg0_22.inviteList == 0 then
		return
	end

	arg0_22.currentGroupId = arg0_22:RandomPick()

	if arg0_22.ladyDic[arg0_22.currentGroupId].ladyEnv:GetBlackboardValue("inWatchMode") then
		if #arg0_22.inviteList > 1 then
			arg0_22:OnPick()
		end

		return
	end

	arg0_22.ladyDic[arg0_22.currentGroupId]:StartMove()
end

function var0_0.RandomPick(arg0_23)
	if not arg0_23.randomList or #arg0_23.randomList == 0 then
		arg0_23.randomList = Clone(arg0_23.inviteList)
	end

	local var0_23 = math.random(1, #arg0_23.randomList)
	local var1_23 = arg0_23.randomList[var0_23]

	table.remove(arg0_23.randomList, var0_23)

	return var1_23
end

function var0_0.TestMove(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.ladyDic) do
		iter1_24:EndMove()
		iter1_24:StartMove()

		arg0_24.currentGroupId = iter1_24.id

		return
	end
end

function var0_0.UpdateSlideInviteList(arg0_25, arg1_25, arg2_25)
	if table.contains(arg2_25, arg0_25.currentGroupId) then
		arg0_25.ladyDic[arg0_25.currentGroupId]:EndMove()
	end

	_.each(arg2_25, function(arg0_26)
		arg0_25:RemoveLadySlide(arg0_26)
		table.removebyvalue(arg0_25.inviteList, arg0_26)
		table.removebyvalue(arg0_25.randomList, arg0_26)
	end)
	_.each(arg1_25, function(arg0_27)
		if not table.contains(arg0_25.inviteList, arg0_27) then
			table.insert(arg0_25.inviteList, arg0_27)
			arg0_25:AddLadySlide(arg0_27)
		end

		if not table.contains(arg0_25.randomList, arg0_27) then
			table.insert(arg0_25.randomList, arg0_27)
		end
	end)
end

function var0_0.PlayVFX(arg0_28, arg1_28)
	local var0_28 = arg0_28.sceneSlideConfigs:Find("vfx/" .. arg1_28)

	setActive(var0_28, false)
	onNextTick(function()
		setActive(var0_28, true)
	end)
end

return var0_0
