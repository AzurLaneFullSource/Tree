local var0_0 = class("CheaterTavernController", import("Mod.Island.Core.controller.IslandController"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)
end

function var0_0.SystemCtor(arg0_2)
	arg0_2.strollAllocator = IslandStrollAllocator.New(arg0_2)
	arg0_2.visibilityAllocator = IslandVisibilityAllocator.New(arg0_2)
	arg0_2.giftAllocator = IslandGiftAllocator.New(arg0_2)
	arg0_2.activityNpcAllocator = IslandActivityNpcAllocator.New(arg0_2)
	arg0_2.timeDelayCreate = IslandDelayCreationSystem.New(arg0_2)
end

function var0_0.OnCoreInitFinish(arg0_3)
	arg0_3:NotifiyCore(ISLAND_EVT.INIT_FINISH, arg0_3.sceneData.camreaZoomData)
	arg0_3:NotifiyIsland(ISLAND_EX_EVT.INIT_FINISH)
end

function var0_0.Update(arg0_4)
	return
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddIslandListener(IslandCheaterTavernMonitor.ADD_CHEATERTAVERN_PLAYER, arg0_5.OnAddCheaterPlayer)
	arg0_5:AddIslandListener(IslandCheaterTavernMonitor.INIT_PLAYER_DATA_DONE, arg0_5.OnInitPlayerDone)
	arg0_5:AddIslandListener(PlayRoomExitRoomCommand.PLAY_ROOM_EXIT_ROOM_DONE, arg0_5.OnRoomExitRoom)
	arg0_5:AddIslandListener(IslandProxy.LINK_CORE, arg0_5.OnLinkCore)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveIslandListener(IslandCheaterTavernMonitor.ADD_CHEATERTAVERN_PLAYER, arg0_6.OnAddCheaterPlayer)
	arg0_6:RemoveIslandListener(IslandCheaterTavernMonitor.INIT_PLAYER_DATA_DONE, arg0_6.OnInitPlayerDone)
	arg0_6:RemoveIslandListener(PlayRoomExitRoomCommand.PLAY_ROOM_EXIT_ROOM_DONE, arg0_6.OnRoomExitRoom)
	arg0_6:RemoveIslandListener(IslandProxy.LINK_CORE, arg0_6.OnLinkCore)
end

function var0_0.OnAddCheaterPlayer(arg0_7, arg1_7)
	local var0_7 = IslandDataConvertor.IslandCheaterTavernPlayerDataToUnit(arg1_7)

	if arg1_7.id == getProxy(PlayerProxy):getRawData().id then
		arg0_7:NotifiyCore(ISLAND_EVT.INIT_CHEATERTAVERN_CAMERA, arg1_7.seat)
	end

	arg0_7:NotifiyCore(ISLAND_EVT.GEN_UNIT, var0_7)
end

function var0_0.OnInitPlayerDone(arg0_8)
	arg0_8:NotifiyCore(CheaterTavernEvent.INITPLAYER_DATA_DONE)
end

function var0_0.OnRoomExitRoom(arg0_9)
	arg0_9:NotifiyCore(CheaterTavernEvent.PLAY_ROOM_EXIT_ROOM_DONE)
end

function var0_0.OnLinkCore(arg0_10, arg1_10, ...)
	arg0_10:NotifiyCore(arg1_10, ...)
end

return var0_0
