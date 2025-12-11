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

function var0_0.Enter(arg0_4)
	arg0_4:DoEnter()
end

function var0_0.UnBlockLayer1Event(arg0_5, arg1_5)
	arg0_5.layer1ContainerCg.blocksRaycasts = arg1_5
end

function var0_0.SetBgm(arg0_6, arg1_6)
	arg0_6.bgm = arg1_6
end

function var0_0.ShowOrHideContainer(arg0_7, arg1_7)
	setActive(arg0_7.opContainer, arg1_7)
	setActive(arg0_7.pageContianer, arg1_7)
end

function var0_0.RegisterUnitList(arg0_8, arg1_8)
	local var0_8 = arg1_8 or arg0_8.registerIndex + 1

	if not arg1_8 then
		arg0_8.registerIndex = var0_8
	end

	assert(arg0_8.unitRegister[var0_8] == nil, "UnitList already exist")

	arg0_8.unitRegister[var0_8] = {}

	return arg0_8.unitRegister[var0_8]
end

function var0_0.GetUnitListRegitser(arg0_9)
	return arg0_9.unitRegister
end

function var0_0.GetUnitListByKey(arg0_10, arg1_10)
	assert(arg1_10 and arg0_10.unitRegister[arg1_10], "key should be exist>>>." .. arg1_10)

	return arg0_10.unitRegister[arg1_10] or {}
end

function var0_0.AddUnit(arg0_11, arg1_11)
	assert(isa(arg1_11, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_11 = arg0_11:GetUnitListByKey(arg1_11:GetUnitType())

	table.insert(var0_11, arg1_11)
end

function var0_0.RemoveUnit(arg0_12, arg1_12)
	assert(isa(arg1_12, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_12 = arg0_12:GetUnitListByKey(arg1_12:GetUnitType())

	table.removebyvalue(var0_12, arg1_12)
end

function var0_0.GetPoolMgr(arg0_13)
	return arg0_13.poolMgr
end

function var0_0.CreateRoot(arg0_14)
	return GameObject.New("Root")
end

function var0_0.OnCoreStateChanged(arg0_15, arg1_15)
	if arg1_15 == IslandCore.STATE_INIT_FINISH then
		pg.BgmMgr.GetInstance():Push("IslandScene", arg0_15.bgm)
	end
end

function var0_0.NotifiyCore(arg0_16, arg1_16, ...)
	arg0_16:Op("NotifiyCore", arg1_16, unpack({
		...
	}))
end

function var0_0.NotifiyIsland(arg0_17, ...)
	arg0_17:Op("NotifiyIsland", ...)
end

function var0_0.NotifiyMeditor(arg0_18, arg1_18, ...)
	arg0_18:Op("NotifiyMeditor", arg1_18, ...)
end

function var0_0.Op(arg0_19, arg1_19, ...)
	arg0_19:GetCore():GetController():Receive(arg1_19, ...)
end

function var0_0.IsSelfIsland(arg0_20)
	return arg0_20:GetCore():GetController():IsSelfIsland()
end

function var0_0.GetIsland(arg0_21)
	return arg0_21:GetCore():GetController():GetIsland()
end

function var0_0.GetSelfIsland(arg0_22)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.GetController(arg0_23)
	return arg0_23.core:GetController()
end

function var0_0.ShowMsgbox(arg0_24, arg1_24)
	arg0_24:NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, arg1_24)
end

function var0_0.GetCore(arg0_25)
	return arg0_25.core
end

function var0_0.InMap(arg0_26, arg1_26)
	return arg0_26:GetCore():GetMapId() == arg1_26
end

function var0_0.GetMapId(arg0_27)
	return arg0_27:GetCore():GetMapId()
end

function var0_0.AddListener(arg0_28, arg1_28, arg2_28)
	local function var0_28(arg0_29, ...)
		arg2_28(arg0_28, ...)
	end

	assert(arg0_28.callbacks[arg2_28] == nil, "This method has been monitored. Please use another one" .. arg1_28)

	arg0_28.callbacks[arg2_28] = var0_28

	arg0_28.core:AddListener(arg1_28, var0_28)
end

function var0_0.RemoveListener(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.callbacks[arg2_30]

	if var0_30 then
		arg0_30.core:RemoveListener(arg1_30, var0_30)

		arg0_30.callbacks[var0_30] = nil
	end
end

function var0_0.Dispose(arg0_31)
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_31:RemoveListeners()
	arg0_31:OnDispose()

	arg0_31.callbacks = nil
	arg0_31.unitRegister = nil
	arg0_31.registerIndex = 0
end

function var0_0.Init(arg0_32)
	return
end

function var0_0.DoEnter(arg0_33)
	return
end

function var0_0.Update(arg0_34)
	return
end

function var0_0.LateUpdate(arg0_35)
	return
end

function var0_0.AddListeners(arg0_36)
	return
end

function var0_0.RemoveListeners(arg0_37)
	return
end

function var0_0.OnDispose(arg0_38)
	return
end

return var0_0
