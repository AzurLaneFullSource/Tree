local var0_0 = class("IslandBaseView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.core = arg1_1
	arg0_1.callbacks = {}
	arg0_1.unitRegister = {}
	arg0_1.registerIndex = 0
	arg0_1.baseContainer = arg2_1
end

function var0_0.SetUp(arg0_2)
	arg0_2.poolMgr = arg0_2.core:GetPoolMgr()
	arg0_2.layer1Container = arg0_2.baseContainer:Find("layer1")
	arg0_2.layer1ContainerCg = GetOrAddComponent(arg0_2.layer1Container, typeof(CanvasGroup))
	arg0_2.topContainer = arg0_2.baseContainer:Find("layer1/top")
	arg0_2.opContainer = arg0_2.baseContainer:Find("layer1/op")
	arg0_2.interactionContainer = arg0_2.baseContainer:Find("layer1/interaction")
	arg0_2.hudContainer = arg0_2.baseContainer:Find("layer1/hud")
	arg0_2.pageContianer = arg0_2.baseContainer:Find("layer1/page")
	arg0_2.layer2UIContianer = arg0_2.baseContainer:Find("layer2/ui")
	arg0_2.root = arg0_2:CreateRoot()

	arg0_2:Init()
	arg0_2:AddListeners()
end

function var0_0.UnBlockLayer1Event(arg0_3, arg1_3)
	arg0_3.layer1ContainerCg.blocksRaycasts = arg1_3
end

function var0_0.SetBgm(arg0_4, arg1_4)
	arg0_4.bgm = arg1_4
end

function var0_0.ShowOrHideContainer(arg0_5, arg1_5)
	setActive(arg0_5.opContainer, arg1_5)
	setActive(arg0_5.pageContianer, arg1_5)
end

function var0_0.RegisterUnitList(arg0_6, arg1_6)
	local var0_6 = arg1_6 or arg0_6.registerIndex + 1

	if not arg1_6 then
		arg0_6.registerIndex = var0_6
	end

	assert(arg0_6.unitRegister[var0_6] == nil, "UnitList already exist")

	arg0_6.unitRegister[var0_6] = {}

	return arg0_6.unitRegister[var0_6]
end

function var0_0.GetUnitListRegitser(arg0_7)
	return arg0_7.unitRegister
end

function var0_0.GetUnitListByKey(arg0_8, arg1_8)
	assert(arg1_8 and arg0_8.unitRegister[arg1_8], "key should be exist>>>." .. arg1_8)

	return arg0_8.unitRegister[arg1_8] or {}
end

function var0_0.AddUnit(arg0_9, arg1_9)
	assert(isa(arg1_9, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_9 = arg0_9:GetUnitListByKey(arg1_9:GetUnitType())

	table.insert(var0_9, arg1_9)
end

function var0_0.RemoveUnit(arg0_10, arg1_10)
	assert(isa(arg1_10, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_10 = arg0_10:GetUnitListByKey(arg1_10:GetUnitType())

	table.removebyvalue(var0_10, arg1_10)
end

function var0_0.GetPoolMgr(arg0_11)
	return arg0_11.poolMgr
end

function var0_0.CreateRoot(arg0_12)
	return GameObject.New("Root")
end

function var0_0.OnCoreStateChanged(arg0_13, arg1_13)
	if arg1_13 == IslandCore.STATE_INIT_FINISH then
		pg.BgmMgr.GetInstance():Push("IslandScene", arg0_13.bgm)
	end
end

function var0_0.NotifiyCore(arg0_14, arg1_14, ...)
	arg0_14:Op("NotifiyCore", arg1_14, unpack({
		...
	}))
end

function var0_0.NotifiyIsland(arg0_15, ...)
	arg0_15:Op("NotifiyIsland", ...)
end

function var0_0.NotifiyMeditor(arg0_16, arg1_16, ...)
	arg0_16:Op("NotifiyMeditor", arg1_16, ...)
end

function var0_0.Op(arg0_17, arg1_17, ...)
	arg0_17:GetCore():GetController():Receive(arg1_17, ...)
end

function var0_0.IsSelfIsland(arg0_18)
	return arg0_18:GetCore():GetController():IsSelfIsland()
end

function var0_0.GetIsland(arg0_19)
	return arg0_19:GetCore():GetController():GetIsland()
end

function var0_0.GetController(arg0_20)
	return arg0_20.core:GetController()
end

function var0_0.ShowMsgbox(arg0_21, arg1_21)
	arg0_21:NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, arg1_21)
end

function var0_0.GetCore(arg0_22)
	return arg0_22.core
end

function var0_0.InMap(arg0_23, arg1_23)
	return arg0_23:GetCore():GetMapId() == arg1_23
end

function var0_0.AddListener(arg0_24, arg1_24, arg2_24)
	local function var0_24(arg0_25, ...)
		arg2_24(arg0_24, ...)
	end

	assert(arg0_24.callbacks[arg2_24] == nil, "This method has been monitored. Please use another one" .. arg1_24)

	arg0_24.callbacks[arg2_24] = var0_24

	arg0_24.core:AddListener(arg1_24, var0_24)
end

function var0_0.RemoveListener(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.callbacks[arg2_26]

	if var0_26 then
		arg0_26.core:RemoveListener(arg1_26, var0_26)

		arg0_26.callbacks[var0_26] = nil
	end
end

function var0_0.Dispose(arg0_27)
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_27:RemoveListeners()
	arg0_27:OnDispose()

	arg0_27.callbacks = nil
	arg0_27.unitRegister = nil
	arg0_27.registerIndex = 0
end

function var0_0.Init(arg0_28)
	return
end

function var0_0.Update(arg0_29)
	return
end

function var0_0.LateUpdate(arg0_30)
	return
end

function var0_0.AddListeners(arg0_31)
	return
end

function var0_0.RemoveListeners(arg0_32)
	return
end

function var0_0.OnDispose(arg0_33)
	return
end

return var0_0
