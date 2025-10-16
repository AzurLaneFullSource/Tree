local var0_0 = class("IslandBaseView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.core = arg1_1
	arg0_1.callbacks = {}
	arg0_1.unitRegister = {}
	arg0_1.registerIndex = 0
	arg0_1.opCount = arg3_1 or 1
	arg0_1.baseContainer = arg2_1
end

function var0_0.GetCacheOpCount(arg0_2)
	return arg0_2.opCount
end

function var0_0.SetUp(arg0_3)
	arg0_3.poolMgr = arg0_3.core:GetPoolMgr()
	arg0_3.layer1Container = arg0_3.baseContainer:Find("layer1")
	arg0_3.layer1ContainerCg = GetOrAddComponent(arg0_3.layer1Container, typeof(CanvasGroup))
	arg0_3.topContainer = arg0_3.baseContainer:Find("layer1/top")
	arg0_3.opContainer = arg0_3.baseContainer:Find("layer1/op")
	arg0_3.interactionContainer = arg0_3.baseContainer:Find("layer1/interaction")
	arg0_3.hudContainer = arg0_3.baseContainer:Find("layer1/hud")
	arg0_3.pageContianer = arg0_3.baseContainer:Find("layer1/page")
	arg0_3.layer2UIContianer = arg0_3.baseContainer:Find("layer2/ui")
	arg0_3.layer2OpContianer = arg0_3.baseContainer:Find("layer2/op")
	arg0_3.root = arg0_3:CreateRoot()

	arg0_3:Init()
	arg0_3:AddListeners()
end

function var0_0.UnBlockLayer1Event(arg0_4, arg1_4)
	arg0_4.layer1ContainerCg.blocksRaycasts = arg1_4
end

function var0_0.SetBgm(arg0_5, arg1_5)
	arg0_5.bgm = arg1_5
end

function var0_0.ShowOrHideContainer(arg0_6, arg1_6)
	setActive(arg0_6.opContainer, arg1_6)
	setActive(arg0_6.pageContianer, arg1_6)
end

function var0_0.RegisterUnitList(arg0_7, arg1_7)
	local var0_7 = arg1_7 or arg0_7.registerIndex + 1

	if not arg1_7 then
		arg0_7.registerIndex = var0_7
	end

	assert(arg0_7.unitRegister[var0_7] == nil, "UnitList already exist")

	arg0_7.unitRegister[var0_7] = {}

	return arg0_7.unitRegister[var0_7]
end

function var0_0.GetUnitListRegitser(arg0_8)
	return arg0_8.unitRegister
end

function var0_0.GetUnitListByKey(arg0_9, arg1_9)
	assert(arg1_9 and arg0_9.unitRegister[arg1_9], "key should be exist>>>." .. arg1_9)

	return arg0_9.unitRegister[arg1_9] or {}
end

function var0_0.AddUnit(arg0_10, arg1_10)
	assert(isa(arg1_10, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_10 = arg0_10:GetUnitListByKey(arg1_10:GetUnitType())

	table.insert(var0_10, arg1_10)
end

function var0_0.RemoveUnit(arg0_11, arg1_11)
	assert(isa(arg1_11, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_11 = arg0_11:GetUnitListByKey(arg1_11:GetUnitType())

	table.removebyvalue(var0_11, arg1_11)
end

function var0_0.GetPoolMgr(arg0_12)
	return arg0_12.poolMgr
end

function var0_0.CreateRoot(arg0_13)
	return GameObject.New("Root")
end

function var0_0.OnCoreStateChanged(arg0_14, arg1_14)
	if arg1_14 == IslandCore.STATE_INIT_FINISH then
		pg.BgmMgr.GetInstance():Push("IslandScene", arg0_14.bgm)
	end
end

function var0_0.NotifiyCore(arg0_15, arg1_15, ...)
	arg0_15:Op("NotifiyCore", arg1_15, unpack({
		...
	}))
end

function var0_0.NotifiyIsland(arg0_16, ...)
	arg0_16:Op("NotifiyIsland", ...)
end

function var0_0.NotifiyMeditor(arg0_17, arg1_17, ...)
	arg0_17:Op("NotifiyMeditor", arg1_17, ...)
end

function var0_0.Op(arg0_18, arg1_18, ...)
	arg0_18:GetCore():GetController():Receive(arg1_18, ...)
end

function var0_0.IsSelfIsland(arg0_19)
	return arg0_19:GetCore():GetController():IsSelfIsland()
end

function var0_0.GetIsland(arg0_20)
	return arg0_20:GetCore():GetController():GetIsland()
end

function var0_0.GetController(arg0_21)
	return arg0_21.core:GetController()
end

function var0_0.ShowMsgbox(arg0_22, arg1_22)
	arg0_22:NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, arg1_22)
end

function var0_0.GetCore(arg0_23)
	return arg0_23.core
end

function var0_0.InMap(arg0_24, arg1_24)
	return arg0_24:GetCore():GetMapId() == arg1_24
end

function var0_0.GetMapId(arg0_25)
	return arg0_25:GetCore():GetMapId()
end

function var0_0.AddListener(arg0_26, arg1_26, arg2_26)
	local function var0_26(arg0_27, ...)
		arg2_26(arg0_26, ...)
	end

	assert(arg0_26.callbacks[arg2_26] == nil, "This method has been monitored. Please use another one" .. arg1_26)

	arg0_26.callbacks[arg2_26] = var0_26

	arg0_26.core:AddListener(arg1_26, var0_26)
end

function var0_0.RemoveListener(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.callbacks[arg2_28]

	if var0_28 then
		arg0_28.core:RemoveListener(arg1_28, var0_28)

		arg0_28.callbacks[var0_28] = nil
	end
end

function var0_0.Dispose(arg0_29)
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_29:RemoveListeners()
	arg0_29:OnDispose()

	arg0_29.callbacks = nil
	arg0_29.unitRegister = nil
	arg0_29.registerIndex = 0
end

function var0_0.Init(arg0_30)
	return
end

function var0_0.Update(arg0_31)
	return
end

function var0_0.LateUpdate(arg0_32)
	return
end

function var0_0.AddListeners(arg0_33)
	return
end

function var0_0.RemoveListeners(arg0_34)
	return
end

function var0_0.OnDispose(arg0_35)
	return
end

return var0_0
