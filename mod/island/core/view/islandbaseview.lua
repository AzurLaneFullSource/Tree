local var0_0 = class("IslandBaseView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.core = arg1_1
	arg0_1.callbacks = {}
	arg0_1.unitRegister = {}
	arg0_1.registerIndex = 0
end

function var0_0.SetUp(arg0_2)
	arg0_2.poolMgr = arg0_2.core:GetPoolMgr()
	arg0_2.topContainer = pg.UIMgr.GetInstance().UICanvas:Find("UIIsland/top")
	arg0_2.opContainer = pg.UIMgr.GetInstance().UICanvas:Find("UIIsland/op")
	arg0_2.pageContianer = pg.UIMgr.GetInstance().UICanvas:Find("UIIsland/page")
	arg0_2.root = arg0_2:CreateRoot()

	arg0_2:Init()
	arg0_2:AddListeners()
end

function var0_0.SetBgm(arg0_3, arg1_3)
	arg0_3.bgm = arg1_3
end

function var0_0.ShowOrHideContainer(arg0_4, arg1_4)
	setActive(arg0_4.opContainer, arg1_4)
	setActive(arg0_4.pageContianer, arg1_4)
end

function var0_0.RegisterUnitList(arg0_5, arg1_5)
	local var0_5 = arg1_5 or arg0_5.registerIndex + 1

	if not arg1_5 then
		arg0_5.registerIndex = var0_5
	end

	assert(arg0_5.unitRegister[var0_5] == nil, "UnitList already exist")

	arg0_5.unitRegister[var0_5] = {}

	return arg0_5.unitRegister[var0_5]
end

function var0_0.GetUnitListRegitser(arg0_6)
	return arg0_6.unitRegister
end

function var0_0.GetUnitListByKey(arg0_7, arg1_7)
	assert(arg1_7 and arg0_7.unitRegister[arg1_7], "key should be exist>>>." .. arg1_7)

	return arg0_7.unitRegister[arg1_7] or {}
end

function var0_0.AddUnit(arg0_8, arg1_8)
	assert(isa(arg1_8, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_8 = arg0_8:GetUnitListByKey(arg1_8:GetUnitType())

	table.insert(var0_8, arg1_8)
end

function var0_0.RemoveUnit(arg0_9, arg1_9)
	assert(isa(arg1_9, IslandSceneUnit), "unit should be IslandSceneUnit")

	local var0_9 = arg0_9:GetUnitListByKey(arg1_9:GetUnitType())

	table.removebyvalue(var0_9, arg1_9)
end

function var0_0.GetPoolMgr(arg0_10)
	return arg0_10.poolMgr
end

function var0_0.CreateRoot(arg0_11)
	return GameObject.New("Root")
end

function var0_0.OnCoreStateChanged(arg0_12, arg1_12)
	if arg1_12 == IslandCore.STATE_INIT_FINISH then
		pg.BgmMgr.GetInstance():Push("IslandScene", arg0_12.bgm)
	end
end

function var0_0.Emit(arg0_13, arg1_13, ...)
	arg0_13:Op("NotifiyCore", arg1_13, unpack({
		...
	}))
end

function var0_0.NotifiyIsland(arg0_14, ...)
	arg0_14:Op("NotifiyIsland", ...)
end

function var0_0.NotifiyMeditor(arg0_15, arg1_15, ...)
	arg0_15:Op("NotifiyMeditor", arg1_15, ...)
end

function var0_0.Op(arg0_16, arg1_16, ...)
	arg0_16:GetCore():GetController():Receive(arg1_16, ...)
end

function var0_0.IsSelfIsland(arg0_17)
	return arg0_17:GetCore():GetController():IsSelfIsland()
end

function var0_0.GetIsland(arg0_18)
	return arg0_18:GetCore():GetController():GetIsland()
end

function var0_0.GetController(arg0_19)
	return arg0_19.core:GetController()
end

function var0_0.ShowMsgbox(arg0_20, arg1_20)
	arg0_20:NotifiyIsland(ISLAND_EX_EVT.SHOW_MSG, arg1_20)
end

function var0_0.GetCore(arg0_21)
	return arg0_21.core
end

function var0_0.InMap(arg0_22, arg1_22)
	return arg0_22:GetCore():GetMapId() == arg1_22
end

function var0_0.AddListener(arg0_23, arg1_23, arg2_23)
	local function var0_23(arg0_24, ...)
		arg2_23(arg0_23, ...)
	end

	assert(arg0_23.callbacks[arg2_23] == nil, "This method has been monitored. Please use another one" .. arg1_23)

	arg0_23.callbacks[arg2_23] = var0_23

	arg0_23.core:AddListener(arg1_23, var0_23)
end

function var0_0.RemoveListener(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.callbacks[arg2_25]

	if var0_25 then
		arg0_25.core:RemoveListener(arg1_25, var0_25)

		arg0_25.callbacks[var0_25] = nil
	end
end

function var0_0.Dispose(arg0_26)
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_26:RemoveListeners()
	arg0_26:OnDispose()

	arg0_26.callbacks = nil
	arg0_26.unitRegister = nil
	arg0_26.registerIndex = 0
end

function var0_0.Init(arg0_27)
	return
end

function var0_0.Update(arg0_28)
	return
end

function var0_0.LateUpdate(arg0_29)
	return
end

function var0_0.AddListeners(arg0_30)
	return
end

function var0_0.RemoveListeners(arg0_31)
	return
end

function var0_0.OnDispose(arg0_32)
	return
end

return var0_0
