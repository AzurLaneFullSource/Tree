local var0_0 = class("CrossRoadCarMoveController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._runningData = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneRoadTF = arg1_1:GetRoadTF(CrossRoadGameConst.SCENE_ROAD_NAME)
	arg0_1.sceneRoadList = arg1_1:GetRoadList(CrossRoadGameConst.SCENE_ROAD_NAME)
	arg0_1.addScale = CrossRoadGameConst.ADD_CAR_SCALE
	arg0_1.startScale = CrossRoadGameConst.START_CAR_SCALE
	arg0_1.walkLineEnd = arg1_1:GetFrontRoadUnderLine()
	arg0_1.itemLine = arg1_1:GetFrontRoadDistance()
	arg0_1.spCarState = CrossRoadGameConst.SP_CAR_MOVE
end

function var0_0.Step(arg0_2, arg1_2)
	arg0_2.carMapList = arg0_2._runningData:GetTrackCarGoList()

	for iter0_2 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		for iter1_2, iter2_2 in ipairs(arg0_2.carMapList[iter0_2]) do
			arg0_2:UpdateCarMove(iter2_2, arg1_2)
		end
	end
end

function var0_0.UpdateCarRunningState(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetTrack()

	if var0_3 == CrossRoadGameConst.BACK_ROAD_NAME then
		arg0_3:SetCarInSceneTrack(arg1_3)
	elseif var0_3 == CrossRoadGameConst.SCENE_ROAD_NAME then
		arg0_3:SetCarInFrontTrack(arg1_3)
	elseif var0_3 == CrossRoadGameConst.FRONT_ROAD_NAME then
		arg1_3:SetDispose(true)
	elseif var0_3 == CrossRoadGameConst.SP_ROAD_NAME then
		arg0_3:SetSpCarState(arg1_3)
	end
end

function var0_0.SetSpCarState(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetState()

	if var0_4 == arg0_4.spCarState.start then
		if arg1_4:GetId() == CrossRoadGameConst.XINZEXI then
			local var1_4 = arg1_4:GetSpTrackId()
			local var2_4 = arg0_4:GetNearTrackId(var1_4)
			local var3_4 = arg0_4:GetDownerthirdPosByTrackId(var2_4)

			arg1_4:SetSpTrackId(var2_4)
			arg1_4:SetTarget(var3_4)
			arg1_4:SetState(arg0_4.spCarState.mid)
		else
			arg0_4:SetSpCarInMoveEnd(arg1_4)
		end
	elseif var0_4 == arg0_4.spCarState.mid then
		local var4_4 = arg1_4:GetSpTrackId()
		local var5_4 = arg0_4:GetNearTrackId(var4_4)

		arg1_4:SetSpTrackId(var5_4)
		arg0_4:SetSpCarInMoveEnd(arg1_4)
	elseif var0_4 == arg0_4.spCarState.moveEnd then
		arg0_4:SetCarInFrontTrack(arg1_4)
	end
end

function var0_0.SetSpCarInMoveEnd(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetSpTrackId()
	local var1_5 = arg0_5.sceneRoadList[var0_5].midTF.anchoredPosition

	arg1_5:SetTarget(var1_5)
	arg1_5:SetState(arg0_5.spCarState.moveEnd)
end

function var0_0.SetCarInSceneTrack(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetTrackID()
	local var1_6 = arg0_6.sceneRoadTF:Find(tostring(var0_6))
	local var2_6 = arg0_6.sceneRoadList[var0_6].startTF.anchoredPosition
	local var3_6 = arg0_6.sceneRoadList[var0_6].midTF.anchoredPosition

	arg1_6:SetParent(var1_6)
	arg1_6:SetPosition(var2_6)

	if CrossRoadGameHelper:CheckIsSPCar(arg1_6:GetId()) then
		arg1_6:SetSpTrackId(arg0_6:GetNearTrackId(var0_6))

		var3_6 = arg0_6:GetUperQuarterPosByTrackId(var0_6)

		arg1_6:SetTarget(var3_6)
		arg1_6:SetTrack(CrossRoadGameConst.SP_ROAD_NAME)
		arg1_6:SetState(arg0_6.spCarState.start)
	else
		arg1_6:SetTarget(var3_6)
		arg1_6:SetTrack(CrossRoadGameConst.SCENE_ROAD_NAME)
	end
end

function var0_0.SetCarInFrontTrack(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetTrackID()

	if CrossRoadGameHelper:CheckIsSPCar(arg1_7:GetId()) then
		var0_7 = arg1_7:GetSpTrackId()
	end

	local var1_7 = arg0_7.sceneRoadList[var0_7].midTF.anchoredPosition
	local var2_7 = arg0_7.sceneRoadList[var0_7].endTF.anchoredPosition

	arg1_7:SetPosition(var1_7)
	arg1_7:SetTarget(var2_7)
	arg1_7:SetDirect({
		0,
		-1
	})
	arg1_7:SetTrack(CrossRoadGameConst.FRONT_ROAD_NAME)
end

function var0_0.UpdateCarMove(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:GetPosition()
	local var1_8 = arg1_8:GetSpeed()
	local var2_8 = arg1_8:GetDirect()
	local var3_8 = arg1_8:GetTarget()
	local var4_8 = arg1_8:GetTrackID()
	local var5_8 = arg1_8:GetTrack()
	local var6_8 = arg1_8:GetId()
	local var7_8 = 1

	if var5_8 == CrossRoadGameConst.SCENE_ROAD_NAME then
		var7_8 = arg0_8:GetCarNowAddScale(var0_8, var4_8)

		arg1_8:SetScale(Vector3(var7_8, var7_8, 1))

		var2_8 = arg0_8:GetNorCarDirct(var0_8, var4_8)
	elseif var5_8 == CrossRoadGameConst.FRONT_ROAD_NAME then
		var7_8 = arg0_8.addScale + arg0_8.startScale

		if var0_8.y < arg0_8.walkLineEnd then
			var7_8 = 3
		end

		if CrossRoadGameHelper:CheckIsSPCar(arg1_8:GetId()) then
			var4_8 = arg1_8:GetSpTrackId()
		end

		var2_8 = arg0_8:GetEndCarDirct(var0_8, var4_8)
	elseif var5_8 == CrossRoadGameConst.SP_ROAD_NAME then
		var7_8 = arg0_8:GetCarNowAddScale(var0_8, var4_8)

		arg1_8:SetScale(Vector3(var7_8, var7_8, 1))

		var2_8 = arg0_8:GetSpCarDirct(arg1_8)
	end

	local var8_8 = var7_8 * arg0_8:GetCarSpeed(arg1_8, var2_8)
	local var9_8 = {
		var8_8 * var2_8[1] * arg2_8,
		var8_8 * var2_8[2] * arg2_8
	}
	local var10_8 = Vector2(var0_8.x + var9_8[1], var0_8.y + var9_8[2])

	if var5_8 == CrossRoadGameConst.FRONT_ROAD_NAME then
		arg0_8:SpCarCheckAndMakeItem(arg1_8, var10_8, var0_8)

		if arg0_8:CheckCarNeedEndDispose(arg1_8) then
			return
		end
	end

	if CrossRoadGameHelper:OnSeg(var10_8, var3_8, var0_8) then
		arg0_8:UpdateCarRunningState(arg1_8)
	else
		arg1_8:SetPosition(var10_8)
	end
end

function var0_0.SpCarCheckAndMakeItem(arg0_9, arg1_9, arg2_9, arg3_9)
	if CrossRoadGameHelper:CheckIsSPCar(arg1_9:GetId()) ~= true then
		return
	end

	if CrossRoadGameHelper:isMiddle(arg3_9.y, arg0_9.itemLine, arg2_9.y) and arg0_9:CanSpCarMakeItem(arg1_9) then
		local var0_9 = arg1_9:GetSpTrackId()

		if arg1_9:GetId() == CrossRoadGameConst.XINZEXI then
			arg1_9:SetSpCarAction(function()
				arg0_9._event(CrossRoadGameConst.MAKE_BING_MIAN, var0_9)
			end)
		else
			arg0_9._event(CrossRoadGameConst.MAKE_XUAN_WO, var0_9)
		end
	end
end

function var0_0.CheckCarNeedEndDispose(arg0_11, arg1_11)
	local var0_11 = arg1_11:GetTrackID()

	if arg1_11:GetPosition().y < arg0_11.sceneRoadList[var0_11].endTF.anchoredPosition.y then
		arg0_11:UpdateCarRunningState(arg1_11)

		return true
	end

	return false
end

function var0_0.CanSpCarMakeItem(arg0_12, arg1_12)
	local var0_12 = math.random(1, 100)
	local var1_12 = 0

	if arg1_12:GetId() == CrossRoadGameConst.XINZEXI then
		var1_12 = CrossRoadGameConst.BINGMIAN_MAKE_PROBABILITY
	else
		var1_12 = CrossRoadGameConst.XUANWO_MAKE_PROBABILITY
	end

	return var1_12 < var0_12
end

function var0_0.GetCarNowAddScale(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:GetCarNowScale(arg1_13, arg2_13)

	return arg0_13.addScale * var0_13 + arg0_13.startScale
end

function var0_0.GetCarNowScale(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.sceneRoadList[arg2_14].startTF.anchoredPosition.y
	local var1_14 = arg0_14.sceneRoadList[arg2_14].midTF.anchoredPosition.y

	return (var0_14 - arg1_14.y) / (var0_14 - var1_14)
end

function var0_0.GetNorCarDirct(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.sceneRoadList[arg2_15].midTF.anchoredPosition
	local var1_15 = CrossRoadGameHelper:GetPosDis(arg1_15, var0_15)

	return {
		(var0_15.x - arg1_15.x) / var1_15,
		(var0_15.y - arg1_15.y) / var1_15
	}
end

function var0_0.GetEndCarDirct(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.sceneRoadList[arg2_16].endTF.anchoredPosition
	local var1_16 = CrossRoadGameHelper:GetPosDis(arg1_16, var0_16)

	return {
		(var0_16.x - arg1_16.x) / var1_16,
		(var0_16.y - arg1_16.y) / var1_16
	}
end

function var0_0.GetNearTrackId(arg0_17, arg1_17)
	if arg1_17 >= 4 then
		return math.random(4, 6)
	end

	if arg1_17 <= 3 then
		return math.random(1, 3)
	end

	return arg1_17
end

function var0_0.GetUperQuarterPosByTrackId(arg0_18, arg1_18)
	local var0_18 = arg0_18.sceneRoadList[arg1_18].startTF.anchoredPosition
	local var1_18 = arg0_18.sceneRoadList[arg1_18].midTF.anchoredPosition
	local var2_18 = CrossRoadGameHelper:GetHalfPos(var0_18, var1_18)

	return (CrossRoadGameHelper:GetHalfPos(var0_18, var2_18))
end

function var0_0.GetDownerthirdPosByTrackId(arg0_19, arg1_19)
	local var0_19 = arg0_19.sceneRoadList[arg1_19].startTF.anchoredPosition
	local var1_19 = arg0_19.sceneRoadList[arg1_19].midTF.anchoredPosition

	return (CrossRoadGameHelper:GetThirdPos(var1_19, var0_19))
end

function var0_0.GetCarSpeed(arg0_20, arg1_20, arg2_20)
	return arg1_20:GetSpeed() / math.abs(arg2_20[2])
end

function var0_0.GetSpCarDirct(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetTarget()
	local var1_21 = arg1_21:GetPosition()
	local var2_21 = CrossRoadGameHelper:GetPosDis(var0_21, var1_21)

	return {
		(var0_21.x - var1_21.x) / var2_21,
		(var0_21.y - var1_21.y) / var2_21
	}
end

function var0_0.Clear(arg0_22)
	return
end

return var0_0
