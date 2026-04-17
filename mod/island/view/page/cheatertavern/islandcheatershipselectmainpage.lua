local var0_0 = class("IslandCheaterShipSelectMainPage", import("..ship.IslandShipMainPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	onButton(arg0_1, arg0_1.backBtn, function()
		if arg0_1.childPage then
			arg0_1.childPage:CheckInReturn(function()
				if arg0_1.needLoadingUI then
					pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_4)
						arg0_1:Hide()

						arg0_1.childPage = nil

						arg0_4()
					end)
				else
					arg0_1:Hide()
				end
			end)
		elseif arg0_1.needLoadingUI then
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_5)
				arg0_1:Hide()
				print("3333eeee")
				arg0_5()
			end)
		else
			arg0_1:Hide()
		end
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_6)
	var0_0.super.AddListeners(arg0_6)
	arg0_6:AddListener(CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE, arg0_6.SetNeedNotLoadingUI)
end

function var0_0.RemoveListeners(arg0_7)
	var0_0.super.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE, arg0_7.SetNeedNotLoadingUI)
end

function var0_0.Show(arg0_8, arg1_8)
	arg0_8.changeDressType = arg1_8

	var0_0.super.Show(arg0_8)
	setActive(arg0_8.togglePanel, false)

	arg0_8.needLoadingUI = true
end

function var0_0.FlushShips(arg0_9, arg1_9)
	arg0_9.displays = {}
	arg0_9.displays = arg1_9:GetUnlockOrCanUnlockShipConfigIds()

	local var0_9

	if #arg0_9.displays > 0 then
		var0_9 = arg1_9:GetShipById(arg0_9.displays[1])
	end

	arg0_9.contextData.selectedId = arg0_9.contextData.selectedId or var0_9 and var0_9.configId

	for iter0_9 = #arg0_9.displays, 1, -1 do
		local var1_9 = arg0_9.displays[iter0_9]

		if var1_9 and getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_9) == nil then
			table.remove(arg0_9.displays, iter0_9)
		end
	end

	arg0_9.shipRect:SetTotalCount(#arg0_9.displays)
end

function var0_0.UpdateMainView(arg0_10, arg1_10)
	if arg0_10.contextData.selectedId == arg1_10.configId then
		return
	end

	if not arg0_10.shipDressHelper then
		arg0_10.shipDressHelper = IslandShipDressHelperNew.New()
	end

	arg0_10.shipDressHelper:SetShipId(arg1_10.configId)
	arg0_10:LoadCharacter(arg1_10:GetModel())

	arg0_10.contextData.selectedId = arg1_10.configId

	arg0_10:TriggerPage(IslandShipMainPage.PAGE_DRESS)
end

function var0_0.SwitchPage(arg0_11, arg1_11)
	if not arg0_11.contextData.selectedId then
		return
	end

	if arg0_11.page then
		arg0_11:ClosePage(arg0_11.page)

		arg0_11.page = nil
	end

	local var0_11 = arg0_11.pages[arg1_11]

	if arg1_11 == 1 then
		arg0_11.childPage = arg0_11:OpenPage(var0_11, arg0_11.contextData.selectedId, false, arg0_11.shipDressHelper, function(arg0_12)
			arg0_11:SetObjInitRotaion(arg0_12)
		end, arg0_11.changeDressType)
	else
		arg0_11:OpenPage(var0_11, arg0_11.contextData.selectedId)

		arg0_11.childPage = nil
	end

	arg0_11.page = var0_11
end

function var0_0.OnHide(arg0_13)
	var0_0.super.OnHide(arg0_13)
end

function var0_0.ClearCharacterScene(arg0_14, arg1_14)
	if arg0_14.isLoadCharacterScene then
		if arg0_14.needLoadUI then
			arg0_14:ClearCharacterContainer()
			arg0_14:UnLoadCharacterScene(function()
				arg0_14:ActivityPlayerCamera()
				existCall(arg1_14)
			end)
		else
			arg0_14:ClearCharacterContainer()
			arg0_14:UnLoadCharacterScene(function()
				arg0_14:ActivityPlayerCamera()
				existCall(arg1_14)
			end)
		end

		arg0_14:ResetCameraMask()
		arg0_14:emitCore(ISLAND_EVT.REFRESH_WEATHER_SYSTEM)
	end

	arg0_14.isLoadCharacterScene = false
end

function var0_0.SetNeedNotLoadingUI(arg0_17)
	arg0_17.needLoadingUI = false
end

function var0_0.GetNeedHideUnlockShipFlag(arg0_18)
	return true
end

return var0_0
