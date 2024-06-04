local var0 = class("DecodeGameController")

function var0.Ctor(arg0, arg1)
	arg0.model = DecodeGameModel.New(arg0)
	arg0.view = DecodeGameView.New(arg0)
end

function var0.SetCallback(arg0, arg1, arg2, arg3)
	arg0.exitCallBack = arg1
	arg0.saveDataCallback = arg2
	arg0.successCallback = arg3
end

function var0.SetUp(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0.isIniting = true

			arg0.model:SetData(arg1)
			arg0:UpdateProgress()
			arg0.view:UpdateCanUseCnt(arg0.model.canUseCnt)
			arg0:SwitchMap(arg0.model.map.id, arg0())
		end,
		function(arg0)
			arg0:PlayVoice(DecodeGameConst.OPEN_DOOR_VOICE)
			arg0.view:DoEnterAnim(arg0)
		end,
		function(arg0)
			pg.NewStoryMgr.GetInstance():Play(DecodeGameConst.STORYID, arg0)
		end,
		function(arg0)
			arg0.view:ShowHelper(1, arg0)
		end,
		function(arg0)
			arg0.isIniting = nil

			arg0:ShowTip()
			arg0.view:Inited(arg0.model.isFinished)
		end
	})
end

function var0.ShowTip(arg0)
	local var0 = arg0.model:GetUnlockMapCnt()
	local var1

	if arg0.model.isFinished then
		var1 = 0
	elseif var0 < DecodeGameConst.MAX_MAP_COUNT and arg0.model.canUseCnt <= 0 then
		var1 = 1
	elseif var0 < DecodeGameConst.MAX_MAP_COUNT and arg0.model.canUseCnt > 0 then
		var1 = 2
	elseif not arg0.isInDecodeMap and not arg0.isInComparison and var0 == DecodeGameConst.MAX_MAP_COUNT then
		var1 = 3
	elseif arg0.isInDecodeMap and not arg0.isInComparison and var0 == DecodeGameConst.MAX_MAP_COUNT then
		var1 = 4
	elseif arg0.isInDecodeMap and arg0.isInComparison and var0 == DecodeGameConst.MAX_MAP_COUNT then
		var1 = 5
	end

	arg0.view:ShowTip(var1)
end

function var0.UpdateProgress(arg0, arg1)
	local var0 = arg0.model:GetUnlockedCnt()
	local var1 = arg0.model:GetUnlockMapCnt()
	local var2, var3 = arg0.model:GetPassWordProgress()

	arg1 = arg1 or function()
		return
	end

	if var3 > (arg0.finishCnt or 0) and var3 ~= #var2 then
		arg0.finishCnt = var3

		arg0:PlayVoice(DecodeGameConst.INCREASE_PASSWORD_PROGRESS_VOICE)
	end

	arg0.view:UpdateProgress(var0, var1, var2, arg1)
end

function var0.SwitchMap(arg0, arg1, arg2)
	if arg0.inSwitching then
		return
	end

	if arg0.mapId ~= arg1 then
		local function var0(arg0)
			parallelAsync({
				function(arg0)
					if not arg0.isInDecodeMap then
						arg0.view:OnSwitchMap(arg0)
					else
						arg0()
					end
				end,
				function(arg0)
					if not arg0.mapId then
						arg0()

						return
					end

					arg0.model:ExitMap()
					arg0.view:OnExitMap(arg0.mapId, arg0.isInDecodeMap, arg0)
				end,
				function(arg0)
					arg0.mapId = nil

					arg0.model:SwitchMap(arg1)
					arg0.view:UpdateMap(arg0.model.map)
					arg0.view:OnEnterMap(arg1, arg0.isInDecodeMap, arg0)
				end
			}, arg0)
		end

		seriesAsync({
			function(arg0)
				if not arg0.isIniting then
					arg0:PlayVoice(DecodeGameConst.SWITCH_MAP_VOCIE)
				end

				arg0.inSwitching = true

				var0(arg0)
			end,
			function(arg0)
				arg0.mapId = arg1

				if not arg0.isInDecodeMap then
					arg0()

					return
				end

				arg0.isInComparison = true

				arg0:PlayVoice(DecodeGameConst.SCAN_MAP_VOICE)
				arg0.view:OnDecodeMap(arg0.model.map, arg0)
			end,
			function(arg0)
				arg0.inSwitching = nil

				if arg0.isInDecodeMap then
					arg0:ShowTip()
					arg0.view:ShowHelper(3, arg0)
				else
					arg0()
				end
			end
		}, arg2)
	end
end

function var0.Unlock(arg0, arg1)
	if arg0.inSwitching then
		return
	end

	if arg0.isInDecodeMap then
		arg0:EnterPassWord(arg1)
	else
		arg0:UnlockMapItem(arg1)
	end
end

function var0.EnterPassWord(arg0, arg1)
	if not arg0.model:IsMapKey(arg1) then
		return
	end

	if arg0.model:IsUsedMapKey(arg1) then
		return
	end

	if arg0.model:CheckIndex(arg1) then
		arg0.model:InsertMapKey(arg1)

		local var0 = arg0.model:GetCurrMapKeyIndex(arg1)
		local var1 = arg0.model:GetMapKeyStr(arg1)

		arg0.view:OnRightCode(arg1, var1, var0)

		if arg0.model:IsSuccess() then
			arg0.model:Finish()
			arg0:PlayVoice(DecodeGameConst.GET_AWARD_DONE_VOICE)
			arg0.view:OnSuccess(function()
				pg.NewStoryMgr.GetInstance():Play(DecodeGameConst.LAST_STORYID)

				if arg0.successCallback then
					arg0.successCallback()
				end
			end)
		else
			arg0:PlayVoice(DecodeGameConst.PASSWORD_IS_RIGHT_VOICE)
		end

		arg0:UpdateProgress()
	else
		arg0:PlayVoice(DecodeGameConst.PASSWORD_IS_FALSE_VOICE)
		arg0.view:OnFalseCode(arg1)
	end
end

function var0.UnlockMapItem(arg0, arg1)
	if arg0.model.canUseCnt > 0 and not arg0.model:IsUnlock(arg1) then
		seriesAsync({
			function(arg0)
				arg0.inSwitching = true

				arg0.model:UnlockMapItem(arg1)
				arg0.view:UnlockMapItem(arg1, arg0)
			end,
			function(arg0)
				arg0:PlayStory(arg0)
			end,
			function(arg0)
				arg0.view:UpdateCanUseCnt(arg0.model.canUseCnt)

				if arg0.model:IsUnlockMap(arg0.model.map.id) then
					arg0:RepairMap()
				else
					arg0:PlayVoice(DecodeGameConst.INCREASE_PROGRESS_VOICE)
					arg0:UpdateProgress()

					if arg0.saveDataCallback then
						arg0.saveDataCallback()
					end

					arg0.inSwitching = nil
				end

				arg0:ShowTip()
				arg0()
			end
		})
	end
end

function var0.PlayStory(arg0, arg1)
	local var0 = arg0.model:GetUnlockedCnt()
	local var1 = DecodeGameConst.UNLOCK_STORYID[var0]

	if var1 then
		pg.NewStoryMgr.GetInstance():Play(var1, arg1)
	else
		arg1()
	end
end

function var0.RepairMap(arg0)
	seriesAsync({
		function(arg0)
			arg0.model:OnRepairMap()
			arg0.view:OnMapRepairing(arg0)
		end,
		function(arg0)
			if arg0.saveDataCallback then
				arg0.saveDataCallback(arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			arg0:PlayVoice(DecodeGameConst.INCREASE_PROGRESS_VOICE)
			arg0.view:UpdateMap(arg0.model.map)
			arg0:UpdateProgress(arg0)
		end,
		function(arg0)
			if arg0.model:GetUnlockMapCnt() == DecodeGameConst.MAX_MAP_COUNT then
				arg0.view:ShowHelper(2, arg0)
			end

			arg0.inSwitching = nil
		end
	})
end

function var0.CanSwitch(arg0)
	return not arg0.inSwitching
end

function var0.SwitchToDecodeMap(arg0, arg1)
	if arg0.inSwitching then
		return
	end

	if arg1 then
		arg0:EnterDecodeMap()
	else
		arg0:ExitDeCodeMap()
	end
end

function var0.ExitDeCodeMap(arg0)
	arg0.isFirstSwitch = false

	seriesAsync({
		function(arg0)
			arg0:PlayVoice(DecodeGameConst.PRESS_UP_PASSWORDBTN)

			arg0.finishCnt = 0
			arg0.isInComparison = nil
			arg0.inSwitching = true

			arg0.view:OnEnterNormalMapBefore(arg0)
		end,
		function(arg0)
			parallelAsync({
				function(arg0)
					arg0.view:OnEnterNormalMap(arg0.model.map, arg0)
				end,
				function(arg0)
					arg0.mapId = arg0.model.map.id

					arg0.view:OnEnterMap(arg0.mapId, false, arg0)
				end
			}, arg0)
		end,
		function()
			arg0.model:ClearMapKeys()
			arg0:UpdateProgress()

			arg0.isInDecodeMap = nil
			arg0.inSwitching = nil

			arg0:ShowTip()
		end
	})
end

function var0.EnterDecodeMap(arg0)
	arg0.isInDecodeMap = true
	arg0.isFirstSwitch = true

	seriesAsync({
		function(arg0)
			arg0:PlayVoice(DecodeGameConst.PRESS_DOWN_PASSWORDBTN)

			arg0.inSwitching = true

			parallelAsync({
				function(arg0)
					arg0.view:OnEnterDecodeMapBefore(arg0)
				end,
				function(arg0)
					arg0.view:OnExitMap(arg0.mapId, true, arg0)
				end
			}, arg0)
		end,
		function(arg0)
			arg0.mapId = nil

			local var0 = arg0.model:GetMapKeyStrs()

			arg0.view:OnEnterDecodeMap(var0, arg0)
		end,
		function(arg0)
			arg0:ShowTip()

			arg0.inSwitching = nil
		end
	})
end

function var0.ExitGame(arg0)
	if arg0.inSwitching then
		return
	end

	if arg0.exitCallBack then
		arg0.exitCallBack()
	end
end

function var0.PlayVoice(arg0, arg1)
	if arg1 and arg1 ~= "" then
		arg0.view:PlayVoice(arg1)
	end
end

function var0.GetSaveData(arg0)
	return arg0.model.unlocks
end

function var0.Dispose(arg0)
	arg0.model:Dispose()
	arg0.view:Dispose()
end

return var0
