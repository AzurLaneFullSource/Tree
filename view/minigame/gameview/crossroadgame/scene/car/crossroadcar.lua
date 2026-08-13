local var0_0 = class("CrossRoadCar")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._tf = arg1_1
	arg0_1._runningData = arg4_1
	arg0_1.id = arg2_1.id
	arg0_1.trackId = arg3_1
	arg0_1.carMsg = arg2_1
	arg0_1.speed = arg2_1.speed
	arg0_1.width = arg2_1.width
	arg0_1.length = arg2_1.length
	arg0_1.spineTF = arg0_1._tf:Find("spine")
	arg0_1.spineAnimUI = GetComponent(arg0_1.spineTF, "SpineAnimUI")
	arg0_1.playingStatus = CrossRoadGameConst.CAR_STATE.showBack
	arg0_1.playingTrack = CrossRoadGameConst.BACK_ROAD_NAME
	arg0_1.playingAction = "normal"
	arg0_1.target = nil
	arg0_1.pos = nil
	arg0_1.needDispose = false
	arg0_1.carCarshList = {}
	arg0_1.direct = {
		0,
		1
	}

	arg0_1:setActionNormal()
end

function var0_0.GetCarRectPoint(arg0_2)
	local var0_2 = arg0_2:GetPosition()
	local var1_2 = arg0_2._tf.rect

	return var0_2.x - var1_2.width / 2, var0_2.y, var0_2.x + var1_2.width / 2, var0_2.y + var1_2.height
end

function var0_0.SetParent(arg0_3, arg1_3)
	setParent(arg0_3._tf, arg1_3, false)
end

function var0_0.SetPosition(arg0_4, arg1_4)
	arg0_4._tf.anchoredPosition = arg1_4
end

function var0_0.SetDispose(arg0_5, arg1_5)
	arg0_5.needDispose = arg1_5
end

function var0_0.GetNeedDispose(arg0_6)
	return arg0_6.needDispose
end

function var0_0.GetId(arg0_7)
	return arg0_7.id
end

function var0_0.SetCarCrashList(arg0_8, arg1_8)
	arg1_8:SetParent(arg0_8._tf)

	local var0_8 = arg0_8._tf.localScale.x

	arg1_8:SetScale(Vector3(-1 / var0_8, 1 / var0_8, 1))

	local var1_8 = arg1_8:GetPosition()
	local var2_8 = arg0_8._tf.anchoredPosition

	arg1_8:SetPosition(Vector2(var1_8.x - var2_8.x, 0))
	table.insert(arg0_8.carCarshList, arg1_8)
end

function var0_0.GetPosition(arg0_9)
	return arg0_9._tf.anchoredPosition
end

function var0_0.SetDirect(arg0_10, arg1_10)
	arg0_10.direct = arg1_10
end

function var0_0.GetDirect(arg0_11)
	return arg0_11.direct
end

function var0_0.SetTarget(arg0_12, arg1_12)
	arg0_12.target = arg1_12
end

function var0_0.GetTarget(arg0_13)
	return arg0_13.target
end

function var0_0.SetScale(arg0_14, arg1_14)
	arg0_14._tf.localScale = arg1_14
end

function var0_0.SetActive(arg0_15, arg1_15)
	setActive(arg0_15._tf, arg1_15)
end

function var0_0.SetState(arg0_16, arg1_16)
	arg0_16.playingStatus = arg1_16
end

function var0_0.GetSpeed(arg0_17)
	local var0_17 = arg0_17._runningData:GetRoundCnt()
	local var1_17 = math.min(var0_17, #CrossRoadGameConst.CAR_SPEED_SCALE)
	local var2_17 = var1_17 < 1 and 0 or CrossRoadGameConst.CAR_SPEED_SCALE[var1_17]

	return arg0_17.speed * (1 + var2_17)
end

function var0_0.GetState(arg0_18)
	return arg0_18.playingStatus
end

function var0_0.GetTrack(arg0_19)
	return arg0_19.playingTrack
end

function var0_0.SetTrack(arg0_20, arg1_20)
	arg0_20.playingTrack = arg1_20
end

function var0_0.GetTrackID(arg0_21)
	return arg0_21.trackId
end

function var0_0.SetAction(arg0_22, arg1_22, arg2_22)
	if arg0_22.playingAction == arg1_22 then
		return
	end

	arg0_22.playingAction = arg1_22

	arg0_22.spineAnimUI:SetAction(arg1_22, arg2_22)
end

function var0_0.SetActionCallBack(arg0_23, arg1_23)
	arg0_23._spineAnimUI:SetActionCallBack(arg1_23)
end

function var0_0.setActionNormal(arg0_24)
	arg0_24:SetAction("normal", 0)
end

function var0_0.SetSpCarAction(arg0_25, arg1_25)
	arg0_25.spineAnimUI:SetActionCallBack(function(arg0_26)
		if arg0_26 == "finish" then
			arg0_25.spineAnimUI:SetActionCallBack(nil)
			arg0_25:setActionNormal()

			if arg1_25 then
				arg1_25()
			end
		end
	end)
	arg0_25:SetAction("action", 0)
end

function var0_0.SetSpTrackId(arg0_27, arg1_27)
	arg0_27.spTrackId = arg1_27
end

function var0_0.GetSpTrackId(arg0_28)
	return arg0_28.spTrackId
end

function var0_0.SetSpCarState(arg0_29, arg1_29)
	arg0_29.spCarState = arg1_29
end

function var0_0.GetSpCarState(arg0_30)
	return arg0_30.spCarState
end

function var0_0.Clear(arg0_31)
	return
end

function var0_0.Dispose(arg0_32)
	if arg0_32.carCarshList then
		for iter0_32, iter1_32 in pairs(arg0_32.carCarshList) do
			if iter1_32 ~= nil then
				iter1_32:Clear()
			end
		end
	end

	arg0_32.carCarshList = {}

	if arg0_32._tf then
		destroy(arg0_32._tf)

		arg0_32._tf = nil
	end

	arg0_32.playingAction = nil

	if arg0_32.spineAnimUI then
		arg0_32.spineAnimUI:SetActionCallBack(nil)

		arg0_32.spineAnimUi = nil
	end

	arg0_32.target = nil
end

return var0_0
