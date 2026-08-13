local var0_0 = class("CrossRoadRunningData")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tpl = arg1_1
	arg0_1._sceneMaskTF = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._joyData = nil

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.frontContentDis = -265
	arg0_2.playerTF = nil
	arg0_2._trackCarGOList = {}
	arg0_2._roleList = {}
	arg0_2.selectRoleId = -1
	arg0_2.playerPosition = nil
	arg0_2.playRound = -1
	arg0_2.roleCrashCnt = #CrossRoadGameConst.SHIP_TPL
	arg0_2.itemGoList = {}

	arg0_2:InitAllRoads()
	arg0_2:InitAllTpl()
	arg0_2:InitItemTF()
end

function var0_0.InitAllRoads(arg0_3)
	local function var0_3(arg0_4, arg1_4, arg2_4)
		local var0_4 = arg1_4:Find(tostring(arg2_4))

		if var0_4 == nil then
			var0_4 = arg1_4:Find("content")

			if var0_4 == nil then
				return
			end
		end

		local var1_4 = var0_4:Find("startPoint")
		local var2_4 = var0_4:Find("midPoint")
		local var3_4 = var0_4:Find("endPoint")

		arg0_4[arg2_4] = {
			startTF = var1_4,
			midTF = var2_4,
			endTF = var3_4
		}
	end

	arg0_3.sceneContainer = arg0_3._sceneMaskTF:Find("sceneContainer")
	arg0_3.backRoadTF = arg0_3.sceneContainer:Find("scene_background/content/road")
	arg0_3.sceneRoadTF = arg0_3.sceneContainer:Find("scene/content/road")
	arg0_3.frontRoadTF = arg0_3.sceneContainer:Find("scene_front")
	arg0_3.backRoadList = {}
	arg0_3.sceneRoadList = {}
	arg0_3.frontRoadList = {}

	for iter0_3 = 1, arg0_3.backRoadTF.childCount do
		var0_3(arg0_3.backRoadList, arg0_3.backRoadTF, iter0_3)
	end

	for iter1_3 = 1, arg0_3.sceneRoadTF.childCount do
		var0_3(arg0_3.sceneRoadList, arg0_3.sceneRoadTF, iter1_3)
	end

	var0_3(arg0_3.frontRoadList, arg0_3.frontRoadTF, 1)

	arg0_3.frontRoadList[1].lightTF = arg0_3.frontRoadTF:Find("content/lightPoint")
	arg0_3.walkLineEnd = arg0_3.frontRoadTF:Find("content").anchoredPosition.y - CrossRoadGameConst.WALKER_LINE_UNNDER
	arg0_3.frontContentDis = arg0_3.frontRoadTF:Find("content").anchoredPosition.y
end

function var0_0.InitAllTpl(arg0_5)
	arg0_5.allShipTpl = {}
	arg0_5.allItemTpl = {}
	arg0_5.allCarTpl = {}

	for iter0_5, iter1_5 in ipairs(CrossRoadGameConst.SHIP_TPL) do
		table.insert(arg0_5.allShipTpl, arg0_5._tpl:Find(iter1_5))
	end

	for iter2_5, iter3_5 in ipairs(CrossRoadGameConst.CAR_TPL) do
		table.insert(arg0_5.allCarTpl, arg0_5._tpl:Find(iter3_5))
	end

	for iter4_5, iter5_5 in ipairs(CrossRoadGameConst.ITEM_TPL) do
		table.insert(arg0_5.allItemTpl, arg0_5._tpl:Find(iter5_5))
	end

	arg0_5.playerTF = arg0_5._tpl:Find("zhihui_tpl")
end

function var0_0.InitItemTF(arg0_6)
	arg0_6.ItemSceneList = {}
	arg0_6.ItemSceneTF = arg0_6.sceneContainer:Find("scene_Item/content")

	for iter0_6 = 1, 6 do
		table.insert(arg0_6.ItemSceneList, arg0_6.ItemSceneTF:Find(tostring(iter0_6)))
	end

	arg0_6.hongChaItemTF = arg0_6.ItemSceneTF:Find("lightPoint")
end

function var0_0.SetJoyData(arg0_7, arg1_7)
	arg0_7._joyData = arg1_7
end

function var0_0.SetTrackCarGoList(arg0_8, arg1_8)
	arg0_8._trackCarGOList = arg1_8
end

function var0_0.SetRoleList(arg0_9, arg1_9)
	arg0_9._roleList = arg1_9
end

function var0_0.GetRoadList(arg0_10, arg1_10)
	if arg1_10 == CrossRoadGameConst.BACK_ROAD_NAME then
		return arg0_10.backRoadList
	elseif arg1_10 == CrossRoadGameConst.SCENE_ROAD_NAME then
		return arg0_10.sceneRoadList
	elseif arg1_10 == CrossRoadGameConst.FRONT_ROAD_NAME then
		return arg0_10.frontRoadList[1]
	end
end

function var0_0.GetRoadTF(arg0_11, arg1_11)
	if arg1_11 == CrossRoadGameConst.BACK_ROAD_NAME then
		return arg0_11.backRoadTF
	elseif arg1_11 == CrossRoadGameConst.SCENE_ROAD_NAME then
		return arg0_11.sceneRoadTF
	elseif arg1_11 == CrossRoadGameConst.FRONT_ROAD_NAME then
		return arg0_11.frontRoadTF
	end
end

function var0_0.GetAllShipTpl(arg0_12)
	return arg0_12.allShipTpl
end

function var0_0.GetAllCarTpl(arg0_13)
	return arg0_13.allCarTpl
end

function var0_0.GetAllItemTpl(arg0_14)
	return arg0_14.allItemTpl
end

function var0_0.GetZhiHuiTpl(arg0_15)
	return arg0_15.zhihuiTpl
end

function var0_0.GetItemListTF(arg0_16)
	return arg0_16.ItemSceneList
end

function var0_0.GetHongChaTpl(arg0_17)
	return arg0_17.allItemTpl[1]
end

function var0_0.GetHongChaTF(arg0_18)
	return arg0_18.hongChaItemTF
end

function var0_0.GetItemScene(arg0_19)
	return arg0_19.ItemSceneTF
end

function var0_0.GetJoyData(arg0_20)
	return arg0_20._joyData
end

function var0_0.GetSceneWidth(arg0_21)
	return arg0_21.sceneContainer.rect.width
end

function var0_0.GetTrackCarGoList(arg0_22)
	return arg0_22._trackCarGOList
end

function var0_0.GetFrontRoadUnderLine(arg0_23)
	return arg0_23.walkLineEnd
end

function var0_0.GetFrontRoadDistance(arg0_24)
	return arg0_24.frontContentDis
end

function var0_0.GetRoleList(arg0_25)
	return arg0_25._roleList
end

function var0_0.SetSelectID(arg0_26, arg1_26)
	arg0_26.selectRoleId = arg1_26
end

function var0_0.GetSelectID(arg0_27)
	return arg0_27.selectRoleId
end

function var0_0.SetPlayerPosition(arg0_28, arg1_28)
	arg0_28.playerPosition = arg1_28
end

function var0_0.GetPlayerPosition(arg0_29)
	return arg0_29.playerPosition
end

function var0_0.SetPlayerCrashDir(arg0_30, arg1_30)
	arg0_30.playerCrashDir = arg1_30
end

function var0_0.GetPlayerCrashDir(arg0_31)
	return arg0_31.playerCrashDir
end

function var0_0.SetPlayerCarshSize(arg0_32, arg1_32)
	arg0_32.playerCrashSize = arg1_32
end

function var0_0.GetPlayerCarshSize(arg0_33)
	return arg0_33.playerCrashSize
end

function var0_0.SetItemGoList(arg0_34, arg1_34)
	arg0_34.itemGoList = arg1_34
end

function var0_0.GetItemGoList(arg0_35)
	return arg0_35.itemGoList
end

function var0_0.RefreshRound(arg0_36)
	arg0_36.playRound = arg0_36.playRound + 1
	arg0_36.roleCrashCnt = #CrossRoadGameConst.SHIP_TPL
end

function var0_0.GetRoundCnt(arg0_37)
	return arg0_37.playRound
end

function var0_0.CrashDeadRole(arg0_38)
	arg0_38.roleCrashCnt = arg0_38.roleCrashCnt - 1
end

function var0_0.CanRefreshRound(arg0_39)
	return arg0_39.roleCrashCnt == 0
end

function var0_0.FindRoleFa(arg0_40, arg1_40)
	local var0_40 = arg1_40:GetFatherID()
	local var1_40 = arg1_40:GetID()

	if var0_40 == var1_40 then
		return var1_40
	else
		local var2_40 = arg0_40:FindRoleFa(arg0_40._roleList[var0_40])

		arg1_40:SetFatherID(var2_40)

		return var2_40
	end
end

function var0_0.upDateRoleFather(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41._roleList) do
		arg0_41:FindRoleFa(iter1_41)
	end
end

function var0_0.OutRoleUnion(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42:GetID()
	local var1_42 = arg0_42:FindRoleFa(arg1_42)
	local var2_42 = arg2_42:GetID()
	local var3_42 = arg0_42:FindRoleFa(arg2_42)

	if var0_42 == var1_42 then
		arg1_42:SetFatherID(var2_42)
		arg2_42:SetFatherID(var2_42)
		arg0_42:upDateRoleFather()
		arg1_42:SetFatherID(var0_42)
	else
		arg2_42:SetFatherID(var2_42)
		arg1_42:SetFatherID(var0_42)

		for iter0_42 = var2_42 + 1, #arg0_42._roleList do
			local var4_42 = arg0_42._roleList[iter0_42]

			if var4_42:GetRunState() == CrossRoadGameConst.SHIP_STATE.crash then
				-- block empty
			elseif arg0_42:FindRoleFa(var4_42) == var0_42 then
				var4_42:SetFatherID(var2_42)
			else
				break
			end
		end
	end
end

function var0_0.InRoleUnion(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg1_43:GetID()
	local var1_43 = arg0_43:FindRoleFa(arg1_43)
	local var2_43 = arg0_43:FindRoleFa(arg2_43)

	if var1_43 == var2_43 then
		return
	end

	arg1_43:SetFatherID(var2_43)
end

function var0_0.TryUpdateUnion(arg0_44, arg1_44)
	local var0_44 = -1

	for iter0_44 = arg1_44:GetID() + 1, #arg0_44._roleList do
		if arg0_44._roleList[iter0_44]:GetRunState() == CrossRoadGameConst.SHIP_STATE.crash then
			-- block empty
		elseif CrossRoadGameHelper:CheckTwoRoleIsCrash(arg1_44, arg0_44._roleList[iter0_44]) then
			var0_44 = iter0_44
		else
			break
		end
	end

	if var0_44 == -1 then
		return
	end

	arg0_44:OutRoleUnion(arg1_44, arg0_44._roleList[var0_44])
end

function var0_0.CheckCarCarshRole(arg0_45, arg1_45, arg2_45)
	local var0_45, var1_45, var2_45, var3_45 = arg1_45:GetCarRectPoint()
	local var4_45 = var1_45 - arg0_45.frontContentDis
	local var5_45 = var3_45 - arg0_45.frontContentDis
	local var6_45, var7_45, var8_45, var9_45 = arg2_45:GetRoleRectPoint()

	return CrossRoadGameHelper:IsRectCross(var0_45, var4_45, var2_45, var5_45, var6_45, var7_45, var8_45, var9_45)
end

function var0_0.CheckCarCarshPlayer(arg0_46, arg1_46)
	local var0_46, var1_46, var2_46, var3_46 = arg1_46:GetCarRectPoint()
	local var4_46 = var1_46 - arg0_46.frontContentDis
	local var5_46 = var3_46 - arg0_46.frontContentDis
	local var6_46 = arg0_46.playerTF.rect
	local var7_46 = arg0_46.playerPosition.x - var6_46.width / 2
	local var8_46 = arg0_46.playerPosition.y - var6_46.height / 2
	local var9_46 = arg0_46.playerPosition.x + var6_46.width / 2
	local var10_46 = arg0_46.playerPosition.y + var6_46.height / 2

	return CrossRoadGameHelper:IsRectCross(var0_46, var4_46, var2_46, var5_46, var7_46, var8_46, var9_46, var10_46)
end

function var0_0.Clear(arg0_47)
	arg0_47._joyData = nil
	arg0_47._roleList = {}
	arg0_47.selectRoleId = -1
	arg0_47.playerPosition = nil
	arg0_47.playerCrashDir = nil
	arg0_47.playerCrashSize = nil
	arg0_47.playRound = -1
	arg0_47.roleCrashCnt = #CrossRoadGameConst.SHIP_TPL
	arg0_47.itemGoList = {}
end

return var0_0
