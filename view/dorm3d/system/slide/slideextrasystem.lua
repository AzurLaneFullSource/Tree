local var0_0 = class("SlideExtraSystem", import("view.dorm3d.Core.BaseSystem"))

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

function var0_0.RegisterEvents(arg0_3)
	arg0_3:Bind(FurnitureSystem.REFRESH_DONE, function()
		arg0_3:InitSlide()
	end)
end

function var0_0.OnUpdate(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5.ladyDic) do
		iter1_5:OnUpdate()
	end
end

function var0_0.OnDispose(arg0_6)
	if arg0_6.pickTimer then
		arg0_6.pickTimer:Stop()

		arg0_6.pickTimer = nil
	end

	for iter0_6, iter1_6 in pairs(arg0_6.ladyDic) do
		arg0_6:RemoveLadySlide(iter0_6)
	end

	arg0_6:Emit(Dorm3dRoomTemplateScene.EXTRA_CHANGE_PLAYER_POSITION)

	if arg0_6.slideTreeOwner then
		arg0_6.slideTreeOwner.enabled = false
	end

	if arg0_6.performanceTreeOwner then
		arg0_6.performanceTreeOwner.enabled = false
	end

	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HideInteraction")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.ShowPerformance")
	pg.NodeCanvasMgr.GetInstance():UnregisterFunc("Slide.HidePerformance")
	arg0_6:Emit(Dorm3dRoomMediator.REMOVE_EXTRA_SYSTEM, FurnitureSlideExtraMediator)
end

function var0_0.OnHandleNotification(arg0_7, arg1_7, arg2_7)
	if arg1_7 == ApartmentProxy.UPDATE_SLIDE_INVITE_LIST then
		arg0_7:UpdateSlideInviteList(arg2_7.addIds, arg2_7.removeIds)
	end
end

function var0_0.GetInterests()
	return {
		ApartmentProxy.UPDATE_SLIDE_INVITE_LIST
	}
end

function var0_0.IsOpen(arg0_9)
	return arg0_9:GetConfigID() == SlideConst.ROOM_ID and arg0_9:IsFurnitureSetIn(SlideConst.FURNITURE_ID)
end

function var0_0.RegisterNodeCanvas(arg0_10)
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

function var0_0.InitScene(arg0_15)
	arg0_15.sceneSlideConfigs = GameObject.Find("SlideConfigs").transform
	arg0_15.movePointsRoot = arg0_15.sceneSlideConfigs:Find("MovePoints")
	arg0_15.defaultPointsRoot = arg0_15.sceneSlideConfigs:Find("DefaultPoints")
end

function var0_0.InitSlide(arg0_16)
	warning("SystemInitSlide")

	if arg0_16.slideInited then
		return
	end

	arg0_16.slideInited = true
	arg0_16.slideGo = arg0_16:GetSceneItem("FurnitureSlots/140101/Slide(Clone)")

	if not arg0_16.slideGo then
		arg0_16.slideInited = nil

		return
	end

	warning("InitSlide Done")

	arg0_16.slideTreeOwner = GetOrAddComponent(arg0_16.slideGo, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_16.slideTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_16:GetPlayer()))

	arg0_16.slideTreeOwner.enabled = true
	arg0_16.performanceTreeOwner = GetOrAddComponent(arg0_16.slideGo:Find("performance_interact_point"), typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_16.performanceTreeOwner.graph.blackboard:AddVariable("_player", go(arg0_16:GetPlayer()))

	arg0_16.performanceTreeOwner.enabled = true
end

function var0_0.InitData(arg0_17)
	arg0_17.commandConfigDic = {}
	arg0_17.defaultPoints = {}

	_.each(pg.dorm3d_minigame_slide.all, function(arg0_18)
		arg0_17.commandConfigDic[arg0_18] = {}

		_.each(pg.dorm3d_minigame_slide[arg0_18].slide_command, function(arg0_19)
			table.insert(arg0_17.commandConfigDic[arg0_18], SlideCommand.New(arg0_19, arg0_17.movePointsRoot))
		end)

		local var0_18 = arg0_17.defaultPointsRoot:Find(pg.dorm3d_minigame_slide[arg0_18].slide_zone)

		arg0_17.defaultPoints[arg0_18] = var0_18
	end)

	arg0_17.inviteList = getProxy(ApartmentProxy):GetSlideInviteList()
	arg0_17.randomList = Clone(arg0_17.inviteList)
	arg0_17.ladyDic = {}

	_.each(arg0_17.inviteList, function(arg0_20)
		arg0_17:AddLadySlide(arg0_20)
	end)
end

function var0_0.AddLadySlide(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetLadyDict()[arg1_21]

	arg0_21.ladyDic[arg1_21] = LadySlide.New(arg1_21, var0_21, arg0_21.commandConfigDic[arg1_21], arg0_21.defaultPoints[arg1_21], function(arg0_22)
		arg0_21:PlayVFX(arg0_22)
	end)

	arg0_21.ladyDic[arg1_21]:Reset()
end

function var0_0.RemoveLadySlide(arg0_23, arg1_23)
	if arg0_23.ladyDic[arg1_23] then
		arg0_23:Emit(Dorm3dRoomTemplateScene.EXTRA_CHANGE_CHARACTER_POSITION, arg0_23.ladyDic[arg1_23].ladyEnv)
		arg0_23.ladyDic[arg1_23].ladyEnv:PlaySingleAction(SlideConst.IDLE_ANIM)
		arg0_23.ladyDic[arg1_23]:Dispose()

		arg0_23.ladyDic[arg1_23] = nil
	end
end

function var0_0.OnPick(arg0_24)
	if #arg0_24.inviteList == 0 then
		return
	end

	arg0_24.currentGroupId = arg0_24:RandomPick()

	if arg0_24.ladyDic[arg0_24.currentGroupId].ladyEnv:GetBlackboardValue("inWatchMode") then
		if #arg0_24.inviteList > 1 then
			arg0_24:OnPick()
		end

		return
	end

	arg0_24.ladyDic[arg0_24.currentGroupId]:StartMove()
end

function var0_0.RandomPick(arg0_25)
	if not arg0_25.randomList or #arg0_25.randomList == 0 then
		arg0_25.randomList = Clone(arg0_25.inviteList)
	end

	local var0_25 = math.random(1, #arg0_25.randomList)
	local var1_25 = arg0_25.randomList[var0_25]

	table.remove(arg0_25.randomList, var0_25)

	return var1_25
end

function var0_0.TestMove(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.ladyDic) do
		iter1_26:EndMove()
		iter1_26:StartMove()

		arg0_26.currentGroupId = iter1_26.id

		return
	end
end

function var0_0.UpdateSlideInviteList(arg0_27, arg1_27, arg2_27)
	if table.contains(arg2_27, arg0_27.currentGroupId) then
		arg0_27.ladyDic[arg0_27.currentGroupId]:EndMove()
	end

	_.each(arg2_27, function(arg0_28)
		arg0_27:RemoveLadySlide(arg0_28)
		table.removebyvalue(arg0_27.inviteList, arg0_28)
		table.removebyvalue(arg0_27.randomList, arg0_28)
	end)
	_.each(arg1_27, function(arg0_29)
		if not table.contains(arg0_27.inviteList, arg0_29) then
			table.insert(arg0_27.inviteList, arg0_29)
			arg0_27:AddLadySlide(arg0_29)
		end

		if not table.contains(arg0_27.randomList, arg0_29) then
			table.insert(arg0_27.randomList, arg0_29)
		end
	end)
end

function var0_0.PlayVFX(arg0_30, arg1_30)
	local var0_30 = arg0_30.sceneSlideConfigs:Find("vfx/" .. arg1_30)

	setActive(var0_30, false)
	onNextTick(function()
		setActive(var0_30, true)
	end)
end

return var0_0
