local var0_0 = class("IslandCheaterShipSelectMainPage", import("..ship.IslandShipMainPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
end

function var0_0.AddListeners(arg0_2)
	var0_0.super.AddListeners(arg0_2)
	arg0_2:AddListener(CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE, arg0_2.SetNeedNotLoadUI)
end

function var0_0.RemoveListeners(arg0_3)
	var0_0.super.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE, arg0_3.SetNeedNotLoadUI)
end

function var0_0.Show(arg0_4, arg1_4)
	arg0_4.changeDressType = arg1_4

	var0_0.super.Show(arg0_4)
	setActive(arg0_4.togglePanel, false)

	arg0_4.needLoadUI = true
end

function var0_0.FlushShips(arg0_5, arg1_5)
	arg0_5.displays = {}
	arg0_5.displays = arg1_5:GetUnlockOrCanUnlockShipConfigIds()

	local var0_5

	if #arg0_5.displays > 0 then
		var0_5 = arg1_5:GetShipById(arg0_5.displays[1])
	end

	arg0_5.contextData.selectedId = arg0_5.contextData.selectedId or var0_5 and var0_5.configId

	for iter0_5 = #arg0_5.displays, 1, -1 do
		local var1_5 = arg0_5.displays[iter0_5]

		if var1_5 and getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_5) == nil then
			table.remove(arg0_5.displays, iter0_5)
		end
	end

	arg0_5.shipRect:SetTotalCount(#arg0_5.displays)
end

function var0_0.UpdateMainView(arg0_6, arg1_6)
	if arg0_6.contextData.selectedId == arg1_6.configId then
		return
	end

	if not arg0_6.shipDressHelper then
		arg0_6.shipDressHelper = IslandShipDressHelperNew.New()
	end

	arg0_6.shipDressHelper:SetShipId(arg1_6.configId)
	arg0_6:LoadCharacter(arg1_6:GetModel())

	arg0_6.contextData.selectedId = arg1_6.configId

	arg0_6:TriggerPage(IslandShipMainPage.PAGE_DRESS)
end

function var0_0.SwitchPage(arg0_7, arg1_7)
	if not arg0_7.contextData.selectedId then
		return
	end

	if arg0_7.page then
		arg0_7:ClosePage(arg0_7.page)

		arg0_7.page = nil
	end

	local var0_7 = arg0_7.pages[arg1_7]

	if arg1_7 == 1 then
		arg0_7.childPage = arg0_7:OpenPage(var0_7, arg0_7.contextData.selectedId, false, arg0_7.shipDressHelper, function(arg0_8)
			arg0_7:SetObjInitRotaion(arg0_8)
		end, arg0_7.changeDressType)
	else
		arg0_7:OpenPage(var0_7, arg0_7.contextData.selectedId)

		arg0_7.childPage = nil
	end

	arg0_7.page = var0_7
end

function var0_0.OnHide(arg0_9)
	var0_0.super.OnHide(arg0_9)
end

function var0_0.ClearCharacterScene(arg0_10, arg1_10)
	if arg0_10.isLoadCharacterScene then
		if arg0_10.needLoadUI then
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_11)
				arg0_10:ClearCharacterContainer()
				arg0_10:UnLoadCharacterScene(function()
					arg0_10:ActivityPlayerCamera()
					existCall(arg1_10)
					arg0_11()
				end)
			end)
		else
			arg0_10:ClearCharacterContainer()
			arg0_10:UnLoadCharacterScene(function()
				arg0_10:ActivityPlayerCamera()
				existCall(arg1_10)
			end)
		end

		arg0_10:ResetCameraMask()
		arg0_10:emitCore(ISLAND_EVT.REFRESH_WEATHER_SYSTEM)
	end

	arg0_10.isLoadCharacterScene = false
end

function var0_0.SetNeedNotLoadUI(arg0_14)
	arg0_14.needLoadUI = false
end

function var0_0.GetNeedHideUnlockShipFlag(arg0_15)
	return true
end

return var0_0
