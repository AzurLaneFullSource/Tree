local var0_0 = class("CrossRoadScene")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._TF = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._sceneMask = arg0_1._TF:Find("sceneMask")
	arg0_1._tpl = arg0_1._TF:Find("tpl")

	function arg0_1._eventCallback(arg0_2, arg1_2, arg2_2)
		arg0_1:onEventHandle(arg0_2, arg1_2, arg2_2)
	end

	arg0_1._gameRunningData = CrossRoadRunningData.New(arg0_1._tpl, arg0_1._sceneMask, arg0_1._gameVo)
	arg0_1._carMgr = CrossRoadCarMgr.New(arg0_1._sceneMask, arg0_1._gameRunningData, arg0_1._eventCallback)
	arg0_1._playerMgr = CrossRoadPlayerMgr.New(arg0_1._tpl, arg0_1._gameRunningData, arg0_1._eventCallback)
	arg0_1._roleMgr = CrossRoadRoleMgr.New(arg0_1._tpl, arg0_1._gameRunningData, arg0_1._eventCallback)
	arg0_1._itemMgr = CrossRoadItemMgr.New(arg0_1._tpl, arg0_1._gameRunningData, arg0_1._eventCallback)
	arg0_1._colliderMgr = CrossRoadColliderMgr.New(arg0_1._gameRunningData, arg0_1._eventCallback, arg0_1._playerMgr)

	arg0_1:ShowContainer(false)
end

function var0_0.onEventHandle(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg1_3 == CrossRoadGameConst.GET_SCORE then
		arg0_3._event:emit(SimpleMGEvent.ADD_SCORE, {
			score = arg2_3[1]
		})
	elseif arg1_3 == CrossRoadGameConst.HIT_ROLER then
		arg0_3._event:emit(CrossRoadGameView.SUB_LIFE)
	elseif arg1_3 == CrossRoadGameConst.NEW_ROUND then
		if arg2_3 > 0 then
			arg0_3._itemMgr:MakeHongcha()
		end
	elseif arg1_3 == CrossRoadGameConst.MAKE_BING_MIAN then
		arg0_3._itemMgr:MakeBingMain(arg2_3)
	elseif arg1_3 == CrossRoadGameConst.MAKE_XUAN_WO then
		arg0_3._itemMgr:MakeXuanWo(arg2_3)
	elseif arg1_3 == CrossRoadGameConst.GET_HONGCHA then
		arg0_3._event:emit(CrossRoadGameView.ADD_LIFE)
		arg0_3._itemMgr:ClearHongcha()
	elseif arg1_3 == CrossRoadGameConst.ADD_ROLE then
		arg0_3._gameVo:AddRoleCnt()
	elseif arg1_3 == CrossRoadGameConst.DISPOSE_BIN then
		arg0_3._itemMgr:DisposeItemByIndex(arg2_3)
	end
end

function var0_0.Prepare(arg0_4)
	arg0_4._carMgr:Prepare()
	arg0_4._playerMgr:Prepare()
	arg0_4._roleMgr:Prepare()
	setActive(arg0_4._gameRunningData:GetHongChaTpl(), false)
end

function var0_0.Start(arg0_5)
	arg0_5:ShowContainer(true)
end

function var0_0.Step(arg0_6)
	local var0_6 = arg0_6._gameVo:GetDeltaTime()
	local var1_6 = arg0_6._gameVo:GetJoyStickData()

	arg0_6._gameRunningData:SetJoyData(var1_6)
	arg0_6._itemMgr:Step(var0_6)
	arg0_6._carMgr:Step(var0_6)
	arg0_6._playerMgr:Step(var0_6)
	arg0_6._roleMgr:Step(var0_6)
	arg0_6._colliderMgr:Step(var0_6)
end

function var0_0.Clear(arg0_7)
	arg0_7._gameRunningData:Clear()
	arg0_7._carMgr:Clear()
	arg0_7._playerMgr:Clear()
	arg0_7._roleMgr:Clear()
	arg0_7._colliderMgr:Clear()
	arg0_7._itemMgr:Clear()
end

function var0_0.Dispose(arg0_8)
	arg0_8._gameRunningData:Dispose()

	arg0_8._gameRunningData = nil
end

function var0_0.Stop(arg0_9)
	return
end

function var0_0.ShowContainer(arg0_10, arg1_10)
	SetActive(arg0_10._sceneMask, arg1_10)
end

return var0_0
