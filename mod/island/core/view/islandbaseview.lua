local var0_0 = class("IslandBaseView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.core = arg1_1
	arg0_1.callbacks = {}
	arg0_1.unitRegister = {}
	arg0_1.registerIndex = 0
	arg0_1.opCount = arg2_1 or 1
end

function var0_0.GetCacheOpCount(arg0_2)
	return arg0_2.opCount
end

function var0_0.SetUp(arg0_3)
	local var0_3 = pg.UIMgr.GetInstance().UIMain:Find("UIIsland")

	arg0_3.poolMgr = arg0_3.core:GetPoolMgr()
	arg0_3.layer1Container = var0_3:Find("layer1")
	arg0_3.layer1ContainerCg = GetOrAddComponent(arg0_3.layer1Container, typeof(CanvasGroup))
	arg0_3.topContainer = var0_3:Find("layer1/top")
	arg0_3.opContainer = var0_3:Find("layer1/op")
	arg0_3.interactionContainer = var0_3:Find("layer1/interaction")
	arg0_3.hudContainer = var0_3:Find("layer1/hud")
	arg0_3.pageContianer = var0_3:Find("layer1/page")
	arg0_3.layer2UIContianer = var0_3:Find("layer2/ui")
	arg0_3.layer2OpContianer = var0_3:Find("layer2/op")
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

function var0_0.GetSelfIsland(arg0_21)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.GetController(arg0_22)
	return arg0_22.core:GetController()
end

function var0_0.ShowMsgbox(arg0_23, arg1_23)
	arg0_23:NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, arg1_23)
end

function var0_0.GetCore(arg0_24)
	return arg0_24.core
end

function var0_0.InMap(arg0_25, arg1_25)
	return arg0_25:GetCore():GetMapId() == arg1_25
end

function var0_0.GetMapId(arg0_26)
	return arg0_26:GetCore():GetMapId()
end

function var0_0.AddListener(arg0_27, arg1_27, arg2_27)
	local function var0_27(arg0_28, ...)
		arg2_27(arg0_27, ...)
	end

	assert(arg0_27.callbacks[arg2_27] == nil, "This method has been monitored. Please use another one" .. arg1_27)

	arg0_27.callbacks[arg2_27] = var0_27

	arg0_27.core:AddListener(arg1_27, var0_27)
end

function var0_0.RemoveListener(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.callbacks[arg2_29]

	if var0_29 then
		arg0_29.core:RemoveListener(arg1_29, var0_29)

		arg0_29.callbacks[var0_29] = nil
	end
end

function var0_0.Dispose(arg0_30)
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_30:RemoveListeners()
	arg0_30:OnDispose()

	arg0_30.callbacks = nil
	arg0_30.unitRegister = nil
	arg0_30.registerIndex = 0
end

function var0_0.Init(arg0_31)
	return
end

function var0_0.Update(arg0_32)
	return
end

function var0_0.LateUpdate(arg0_33)
	return
end

function var0_0.AddListeners(arg0_34)
	return
end

function var0_0.RemoveListeners(arg0_35)
	return
end

function var0_0.OnDispose(arg0_36)
	return
end

return var0_0
