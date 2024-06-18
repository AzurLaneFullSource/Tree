local var0_0 = class("DecodeGameController")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.model = DecodeGameModel.New(arg0_1)
	arg0_1.view = DecodeGameView.New(arg0_1)
end

function var0_0.SetCallback(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.exitCallBack = arg1_2
	arg0_2.saveDataCallback = arg2_2
	arg0_2.successCallback = arg3_2
end

function var0_0.SetUp(arg0_3, arg1_3)
	seriesAsync({
		function(arg0_4)
			arg0_3.isIniting = true

			arg0_3.model:SetData(arg1_3)
			arg0_3:UpdateProgress()
			arg0_3.view:UpdateCanUseCnt(arg0_3.model.canUseCnt)
			arg0_3:SwitchMap(arg0_3.model.map.id, arg0_4())
		end,
		function(arg0_5)
			arg0_3:PlayVoice(DecodeGameConst.OPEN_DOOR_VOICE)
			arg0_3.view:DoEnterAnim(arg0_5)
		end,
		function(arg0_6)
			pg.NewStoryMgr.GetInstance():Play(DecodeGameConst.STORYID, arg0_6)
		end,
		function(arg0_7)
			arg0_3.view:ShowHelper(1, arg0_7)
		end,
		function(arg0_8)
			arg0_3.isIniting = nil

			arg0_3:ShowTip()
			arg0_3.view:Inited(arg0_3.model.isFinished)
		end
	})
end

function var0_0.ShowTip(arg0_9)
	local var0_9 = arg0_9.model:GetUnlockMapCnt()
	local var1_9

	if arg0_9.model.isFinished then
		var1_9 = 0
	elseif var0_9 < DecodeGameConst.MAX_MAP_COUNT and arg0_9.model.canUseCnt <= 0 then
		var1_9 = 1
	elseif var0_9 < DecodeGameConst.MAX_MAP_COUNT and arg0_9.model.canUseCnt > 0 then
		var1_9 = 2
	elseif not arg0_9.isInDecodeMap and not arg0_9.isInComparison and var0_9 == DecodeGameConst.MAX_MAP_COUNT then
		var1_9 = 3
	elseif arg0_9.isInDecodeMap and not arg0_9.isInComparison and var0_9 == DecodeGameConst.MAX_MAP_COUNT then
		var1_9 = 4
	elseif arg0_9.isInDecodeMap and arg0_9.isInComparison and var0_9 == DecodeGameConst.MAX_MAP_COUNT then
		var1_9 = 5
	end

	arg0_9.view:ShowTip(var1_9)
end

function var0_0.UpdateProgress(arg0_10, arg1_10)
	local var0_10 = arg0_10.model:GetUnlockedCnt()
	local var1_10 = arg0_10.model:GetUnlockMapCnt()
	local var2_10, var3_10 = arg0_10.model:GetPassWordProgress()

	arg1_10 = arg1_10 or function()
		return
	end

	if var3_10 > (arg0_10.finishCnt or 0) and var3_10 ~= #var2_10 then
		arg0_10.finishCnt = var3_10

		arg0_10:PlayVoice(DecodeGameConst.INCREASE_PASSWORD_PROGRESS_VOICE)
	end

	arg0_10.view:UpdateProgress(var0_10, var1_10, var2_10, arg1_10)
end

function var0_0.SwitchMap(arg0_12, arg1_12, arg2_12)
	if arg0_12.inSwitching then
		return
	end

	if arg0_12.mapId ~= arg1_12 then
		local function var0_12(arg0_13)
			parallelAsync({
				function(arg0_14)
					if not arg0_12.isInDecodeMap then
						arg0_12.view:OnSwitchMap(arg0_14)
					else
						arg0_14()
					end
				end,
				function(arg0_15)
					if not arg0_12.mapId then
						arg0_15()

						return
					end

					arg0_12.model:ExitMap()
					arg0_12.view:OnExitMap(arg0_12.mapId, arg0_12.isInDecodeMap, arg0_15)
				end,
				function(arg0_16)
					arg0_12.mapId = nil

					arg0_12.model:SwitchMap(arg1_12)
					arg0_12.view:UpdateMap(arg0_12.model.map)
					arg0_12.view:OnEnterMap(arg1_12, arg0_12.isInDecodeMap, arg0_16)
				end
			}, arg0_13)
		end

		seriesAsync({
			function(arg0_17)
				if not arg0_12.isIniting then
					arg0_12:PlayVoice(DecodeGameConst.SWITCH_MAP_VOCIE)
				end

				arg0_12.inSwitching = true

				var0_12(arg0_17)
			end,
			function(arg0_18)
				arg0_12.mapId = arg1_12

				if not arg0_12.isInDecodeMap then
					arg0_18()

					return
				end

				arg0_12.isInComparison = true

				arg0_12:PlayVoice(DecodeGameConst.SCAN_MAP_VOICE)
				arg0_12.view:OnDecodeMap(arg0_12.model.map, arg0_18)
			end,
			function(arg0_19)
				arg0_12.inSwitching = nil

				if arg0_12.isInDecodeMap then
					arg0_12:ShowTip()
					arg0_12.view:ShowHelper(3, arg0_19)
				else
					arg0_19()
				end
			end
		}, arg2_12)
	end
end

function var0_0.Unlock(arg0_20, arg1_20)
	if arg0_20.inSwitching then
		return
	end

	if arg0_20.isInDecodeMap then
		arg0_20:EnterPassWord(arg1_20)
	else
		arg0_20:UnlockMapItem(arg1_20)
	end
end

function var0_0.EnterPassWord(arg0_21, arg1_21)
	if not arg0_21.model:IsMapKey(arg1_21) then
		return
	end

	if arg0_21.model:IsUsedMapKey(arg1_21) then
		return
	end

	if arg0_21.model:CheckIndex(arg1_21) then
		arg0_21.model:InsertMapKey(arg1_21)

		local var0_21 = arg0_21.model:GetCurrMapKeyIndex(arg1_21)
		local var1_21 = arg0_21.model:GetMapKeyStr(arg1_21)

		arg0_21.view:OnRightCode(arg1_21, var1_21, var0_21)

		if arg0_21.model:IsSuccess() then
			arg0_21.model:Finish()
			arg0_21:PlayVoice(DecodeGameConst.GET_AWARD_DONE_VOICE)
			arg0_21.view:OnSuccess(function()
				pg.NewStoryMgr.GetInstance():Play(DecodeGameConst.LAST_STORYID)

				if arg0_21.successCallback then
					arg0_21.successCallback()
				end
			end)
		else
			arg0_21:PlayVoice(DecodeGameConst.PASSWORD_IS_RIGHT_VOICE)
		end

		arg0_21:UpdateProgress()
	else
		arg0_21:PlayVoice(DecodeGameConst.PASSWORD_IS_FALSE_VOICE)
		arg0_21.view:OnFalseCode(arg1_21)
	end
end

function var0_0.UnlockMapItem(arg0_23, arg1_23)
	if arg0_23.model.canUseCnt > 0 and not arg0_23.model:IsUnlock(arg1_23) then
		seriesAsync({
			function(arg0_24)
				arg0_23.inSwitching = true

				arg0_23.model:UnlockMapItem(arg1_23)
				arg0_23.view:UnlockMapItem(arg1_23, arg0_24)
			end,
			function(arg0_25)
				arg0_23:PlayStory(arg0_25)
			end,
			function(arg0_26)
				arg0_23.view:UpdateCanUseCnt(arg0_23.model.canUseCnt)

				if arg0_23.model:IsUnlockMap(arg0_23.model.map.id) then
					arg0_23:RepairMap()
				else
					arg0_23:PlayVoice(DecodeGameConst.INCREASE_PROGRESS_VOICE)
					arg0_23:UpdateProgress()

					if arg0_23.saveDataCallback then
						arg0_23.saveDataCallback()
					end

					arg0_23.inSwitching = nil
				end

				arg0_23:ShowTip()
				arg0_26()
			end
		})
	end
end

function var0_0.PlayStory(arg0_27, arg1_27)
	local var0_27 = arg0_27.model:GetUnlockedCnt()
	local var1_27 = DecodeGameConst.UNLOCK_STORYID[var0_27]

	if var1_27 then
		pg.NewStoryMgr.GetInstance():Play(var1_27, arg1_27)
	else
		arg1_27()
	end
end

function var0_0.RepairMap(arg0_28)
	seriesAsync({
		function(arg0_29)
			arg0_28.model:OnRepairMap()
			arg0_28.view:OnMapRepairing(arg0_29)
		end,
		function(arg0_30)
			if arg0_28.saveDataCallback then
				arg0_28.saveDataCallback(arg0_30)
			else
				arg0_30()
			end
		end,
		function(arg0_31)
			arg0_28:PlayVoice(DecodeGameConst.INCREASE_PROGRESS_VOICE)
			arg0_28.view:UpdateMap(arg0_28.model.map)
			arg0_28:UpdateProgress(arg0_31)
		end,
		function(arg0_32)
			if arg0_28.model:GetUnlockMapCnt() == DecodeGameConst.MAX_MAP_COUNT then
				arg0_28.view:ShowHelper(2, arg0_32)
			end

			arg0_28.inSwitching = nil
		end
	})
end

function var0_0.CanSwitch(arg0_33)
	return not arg0_33.inSwitching
end

function var0_0.SwitchToDecodeMap(arg0_34, arg1_34)
	if arg0_34.inSwitching then
		return
	end

	if arg1_34 then
		arg0_34:EnterDecodeMap()
	else
		arg0_34:ExitDeCodeMap()
	end
end

function var0_0.ExitDeCodeMap(arg0_35)
	arg0_35.isFirstSwitch = false

	seriesAsync({
		function(arg0_36)
			arg0_35:PlayVoice(DecodeGameConst.PRESS_UP_PASSWORDBTN)

			arg0_35.finishCnt = 0
			arg0_35.isInComparison = nil
			arg0_35.inSwitching = true

			arg0_35.view:OnEnterNormalMapBefore(arg0_36)
		end,
		function(arg0_37)
			parallelAsync({
				function(arg0_38)
					arg0_35.view:OnEnterNormalMap(arg0_35.model.map, arg0_38)
				end,
				function(arg0_39)
					arg0_35.mapId = arg0_35.model.map.id

					arg0_35.view:OnEnterMap(arg0_35.mapId, false, arg0_39)
				end
			}, arg0_37)
		end,
		function()
			arg0_35.model:ClearMapKeys()
			arg0_35:UpdateProgress()

			arg0_35.isInDecodeMap = nil
			arg0_35.inSwitching = nil

			arg0_35:ShowTip()
		end
	})
end

function var0_0.EnterDecodeMap(arg0_41)
	arg0_41.isInDecodeMap = true
	arg0_41.isFirstSwitch = true

	seriesAsync({
		function(arg0_42)
			arg0_41:PlayVoice(DecodeGameConst.PRESS_DOWN_PASSWORDBTN)

			arg0_41.inSwitching = true

			parallelAsync({
				function(arg0_43)
					arg0_41.view:OnEnterDecodeMapBefore(arg0_43)
				end,
				function(arg0_44)
					arg0_41.view:OnExitMap(arg0_41.mapId, true, arg0_44)
				end
			}, arg0_42)
		end,
		function(arg0_45)
			arg0_41.mapId = nil

			local var0_45 = arg0_41.model:GetMapKeyStrs()

			arg0_41.view:OnEnterDecodeMap(var0_45, arg0_45)
		end,
		function(arg0_46)
			arg0_41:ShowTip()

			arg0_41.inSwitching = nil
		end
	})
end

function var0_0.ExitGame(arg0_47)
	if arg0_47.inSwitching then
		return
	end

	if arg0_47.exitCallBack then
		arg0_47.exitCallBack()
	end
end

function var0_0.PlayVoice(arg0_48, arg1_48)
	if arg1_48 and arg1_48 ~= "" then
		arg0_48.view:PlayVoice(arg1_48)
	end
end

function var0_0.GetSaveData(arg0_49)
	return arg0_49.model.unlocks
end

function var0_0.Dispose(arg0_50)
	arg0_50.model:Dispose()
	arg0_50.view:Dispose()
end

return var0_0
