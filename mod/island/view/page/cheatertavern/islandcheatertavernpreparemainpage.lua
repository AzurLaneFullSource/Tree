local var0_0 = class("IslandCheaterTavernPrepareMainPage", import("...base.IslandBasePage"))

var0_0.OPEN_SELECT_SHIP = "IslandCheaterTavernPrepareMainPage:OPEN_SELECT_SHIP"

local var1_0 = {
	"UICamera/Canvas/UIMain/IslandCheatBarEntranceUI(Clone)",
	"OverlayCamera/Overlay/UIMain/IslandPlayRoomMainUI(Clone)",
	"UICamera/Canvas/UIOrigin/IslandPlayRoomMainUI(Clone)"
}

function var0_0.AddListeners(arg0_1)
	arg0_1:AddListener(CheaterTavernEvent.OPEN_SELECT_SHIP, arg0_1.OpenShipSelectPage)
	arg0_1:AddListener(ISLAND_EVT.SUB_PAGE_OPEN, arg0_1.OnOpenSubPage)
	arg0_1:AddListener(ISLAND_EVT.SUB_PAGE_CLOSE, arg0_1.OnCloseSubPage)
	arg0_1:AddListener(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, arg0_1.OnLoadSceneRoom)
end

function var0_0.RemoveListeners(arg0_2)
	arg0_2:RemoveListener(CheaterTavernEvent.OPEN_SELECT_SHIP, arg0_2.OpenShipSelectPage)
	arg0_2:RemoveListener(ISLAND_EVT.SUB_PAGE_OPEN, arg0_2.OnOpenSubPage)
	arg0_2:RemoveListener(ISLAND_EVT.SUB_PAGE_CLOSE, arg0_2.OnCloseSubPage)
	arg0_2:RemoveListener(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, arg0_2.OnLoadSceneRoom)
end

function var0_0.getUIName(arg0_3)
	return "IslandEmptyUI"
end

function var0_0.NeedCache(arg0_4)
	return false
end

function var0_0.OnEnable(arg0_5)
	arg0_5:LoadChildSubPage(IslandCheaterTavernDisplayPage)
end

function var0_0.OnDisable(arg0_6)
	arg0_6.subPageStack = {}
end

function var0_0.HandleUIDisplay(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(var1_0) do
		local var0_7 = GameObject.Find(iter1_7)

		if not IsNil(var0_7) then
			setActive(var0_7, arg1_7)
		end
	end
end

function var0_0.OnOpenSubPage(arg0_8, arg1_8)
	if arg1_8 == "IslandCheaterShipSelectMainPage" or arg1_8 == "IslandCheaterTavernPlayRoomInfoPage" then
		arg0_8:HandleUIDisplay(false)
	end
end

function var0_0.OnCloseSubPage(arg0_9, arg1_9)
	local var0_9 = {
		"IslandCheaterShipSelectMainPage",
		"IslandCheaterTavernPlayRoomInfoPage",
		"IslandCheaterTavernDisplayPage"
	}

	if not table.contains(var0_9, arg1_9) then
		return
	end

	local var1_9 = 0

	for iter0_9, iter1_9 in ipairs(arg0_9.subPageStack) do
		if iter1_9.__cname == arg1_9 then
			var1_9 = iter0_9
		end
	end

	if var1_9 ~= 0 then
		table.remove(arg0_9.subPageStack, var1_9)
	end

	if var1_9 > 1 then
		local var2_9 = var1_9 - 1
		local var3_9 = arg0_9.subPageStack[var2_9]

		if var3_9.__cname == "IslandCheaterTavernPlayRoomInfoPage" then
			arg0_9:OpenPage(var3_9, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
		else
			arg0_9:OpenPage(var3_9)
		end

		arg0_9.pageClass = var3_9

		arg0_9:HandleUIDisplay(true)
	else
		arg0_9:Hide()
	end
end

function var0_0.LoadChildSubPage(arg0_10, arg1_10, arg2_10)
	if arg0_10.pageClass then
		pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_11)
			arg0_10:DestorySubPage(arg0_10.pageClass)

			arg0_10.pageClass = nil
			arg0_10.pageClass = arg1_10

			arg0_10:OpenPage(arg0_10.pageClass, arg2_10)
			table.insert(arg0_10.subPageStack, arg1_10)
			arg0_11()
		end)

		return
	end

	arg0_10.pageClass = arg1_10

	arg0_10:OpenPage(arg0_10.pageClass, arg2_10)
	table.insert(arg0_10.subPageStack, arg1_10)
end

function var0_0.OnLoadSceneRoom(arg0_12, arg1_12)
	arg0_12:emit(CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE)
	arg0_12:LoadChildSubPage(IslandCheaterTavernPlayRoomInfoPage, arg1_12)
end

function var0_0.OpenShipSelectPage(arg0_13, arg1_13)
	arg0_13.changeDressType = arg1_13

	arg0_13:LoadChildSubPage(IslandCheaterShipSelectMainPage, arg1_13)
end

function var0_0.OnShow(arg0_14, arg1_14, arg2_14, arg3_14)
	arg0_14.subPageStack = {}

	if arg1_14 then
		arg0_14:LoadChildSubPage(IslandCheaterTavernPlayRoomInfoPage, arg2_14)
	else
		arg0_14:LoadChildSubPage(IslandCheaterTavernDisplayPage)
	end

	if arg3_14 then
		arg3_14()
	end
end

function var0_0.OnExit(arg0_15)
	if not arg0_15.exit then
		arg0_15:emitCore(CheaterTavernEvent.CLOSE_PREPARE_MAIN_PAGE)
	end

	arg0_15.exit = true
end

return var0_0
