pg = pg or {}
pg.CipherGroupMgr = singletonClass("CipherGroupMgr")

local var0_0 = pg.CipherGroupMgr

var0_0.GroupName = "CIPHER"

function var0_0.Ctor(arg0_1)
	arg0_1.group = GroupHelper.GetGroupMgrByName(var0_0.GroupName)
	arg0_1.downloadList = {}
	arg0_1.finishCount = 0
	arg0_1.curIndex = 0
end

function var0_0.GetCurFilePath(arg0_2)
	return arg0_2.downloadList[arg0_2.curIndex]
end

function var0_0.GetCurFileState(arg0_3)
	local var0_3 = arg0_3:GetCurFilePath()

	return arg0_3.group:CheckF(var0_3)
end

function var0_0.GetValidFileList(arg0_4, arg1_4)
	local var0_4 = {}

	if GroupHelper.IsGroupWaitToUpdate(var0_0.GroupName) then
		for iter0_4, iter1_4 in ipairs(arg1_4) do
			iter1_4 = string.lower(iter1_4)

			local var1_4 = GroupHelper.VerifyFile(var0_0.GroupName, iter1_4)

			warning(iter1_4 .. " " .. tostring(var1_4))

			if var1_4 then
				table.insert(var0_4, iter1_4)
			end
		end
	end

	return var0_4
end

function var0_0.StartWithFileList(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetValidFileList(arg1_5)

	if #var0_5 > 0 then
		arg0_5:Clear()

		arg0_5.downloadList = var0_5
		arg0_5.curIndex = 1

		arg0_5:updateWithIndex(1)
		arg0_5:createUpdateTimer()
	end
end

function var0_0.AddFileList(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetValidFileList(arg1_6)

	if #var0_6 > 0 then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			table.insert(arg0_6.downloadList, iter1_6)
		end
	end
end

function var0_0.SetCallBack(arg0_7, arg1_7)
	arg0_7.progressCB = arg1_7.progressCB
	arg0_7.allFinishCB = arg1_7.allFinishCB
	arg0_7.singleFinshCB = arg1_7.singleFinshCB
	arg0_7.errorCB = arg1_7.errorCB
end

function var0_0.IsAnyFileInProgress(arg0_8)
	return arg0_8.curIndex > 0 and arg0_8.curIndex <= #arg0_8.downloadList
end

function var0_0.DelFile(arg0_9, arg1_9)
	local var0_9 = #arg1_9
	local var1_9 = System.Array.CreateInstance(typeof(System.String), var0_9)

	for iter0_9 = 0, var0_9 - 1 do
		var1_9[iter0_9] = arg1_9[iter0_9 + 1]
	end

	arg0_9.group:DelFile(var1_9)
end

function var0_0.DelFile_Old(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg1_10) do
		local var0_10 = PathMgr.getAssetBundle(iter1_10)

		warning("full file path:" .. var0_10)

		if PathMgr.FileExists(var0_10) then
			System.IO.File.Delete(var0_10)
			warning("del file path:" .. var0_10)
		end
	end

	arg0_10.group:ClearStreamWriter()

	local function var1_10(arg0_11)
		local var0_11 = false

		for iter0_11, iter1_11 in ipairs(arg1_10) do
			if string.sub(arg0_11, 1, #iter1_11) == iter1_11 then
				var0_11 = true

				break
			end
		end

		return var0_11
	end

	local var2_10 = {}
	local var3_10 = arg0_10.group.cachedHashPath

	warning("hash path:" .. var3_10)

	if PathMgr.FileExists(var3_10) then
		local var4_10 = PathMgr.ReadAllLines(var3_10)
		local var5_10 = var4_10.Length
		local var6_10 = {}

		for iter2_10 = 0, var5_10 - 1 do
			local var7_10 = var4_10[iter2_10]

			if not var1_10(var7_10) then
				warning("add origin hash:" .. var7_10)
				table.insert(var6_10, var7_10)
			else
				warning("find del hash:" .. var7_10)

				local var8_10 = var7_10
				local var9_10 = System.Array.CreateInstance(typeof(System.String), 3)
				local var10_10 = string.split(var8_10, ",")

				for iter3_10 = 0, 2 do
					local var11_10 = var10_10[iter3_10 + 1]

					warning("add info:" .. var11_10)

					var9_10[iter3_10] = var11_10
				end

				table.insert(var2_10, var9_10)
			end
		end

		local var12_10 = #var6_10

		warning("new hash count:" .. var12_10)

		if var12_10 < var5_10 then
			if GroupHelper.IsGroupVerLastest(var0_0.GroupName) then
				local var13_10 = Application.persistentDataPath .. "/" .. arg0_10.group.localVersionFile

				System.IO.File.WriteAllText(var13_10, "0.0.1")
				warning("ver write:" .. var13_10)
			end

			local var14_10 = System.Array.CreateInstance(typeof(System.String), var12_10)

			for iter4_10, iter5_10 in ipairs(var6_10) do
				var14_10[iter4_10 - 1] = iter5_10
			end

			System.IO.File.WriteAllLines(var3_10, var14_10)
			warning("hash write:" .. var3_10)
		end
	end

	if arg0_10.group.toUpdate then
		for iter6_10, iter7_10 in ipairs(var2_10) do
			local var15_10 = iter7_10[0]

			warning("re add info:" .. var15_10)
			arg0_10.group.toUpdate:Add(iter7_10)
			arg0_10.group:UpdateFileDownloadStates(var15_10, DownloadState.CheckToUpdate)
		end

		if arg0_10.group.state == DownloadState.UpdateSuccess then
			arg0_10.group.state = DownloadState.CheckToUpdate
		end
	else
		arg0_10.group.state = DownloadState.None

		arg0_10.group:CheckD()
	end
end

function var0_0.Clear(arg0_12)
	arg0_12:clearTimer()

	arg0_12.downloadList = {}
	arg0_12.finishCount = 0
	arg0_12.curIndex = 0
end

function var0_0.isCipherExist(arg0_13, arg1_13)
	local var0_13 = arg0_13.group:CheckF(arg1_13)
	local var1_13 = var0_13 == DownloadState.None or var0_13 == DownloadState.UpdateSuccess
	local var2_13 = PathMgr.getAssetBundle(arg1_13)
	local var3_13 = PathMgr.FileExists(var2_13)

	return var1_13 and var3_13
end

function var0_0.Repair(arg0_14)
	local var0_14 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cipher.csv") then
				arg0_14.group:StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		content = i18n("resource_verify_warn"),
		custom = {
			var0_14
		}
	})
end

function var0_0.clearTimer(arg0_16)
	if arg0_16.frameTimer then
		arg0_16.frameTimer:Stop()

		arg0_16.frameTimer = nil
	end
end

function var0_0.updateWithIndex(arg0_17, arg1_17)
	if arg1_17 > #arg0_17.downloadList then
		if arg0_17.allFinishCB then
			arg0_17.allFinishCB()
		end

		arg0_17:Clear()

		return
	end

	local var0_17 = arg0_17:GetCurFilePath()

	arg0_17.group:UpdateF(var0_17)
end

function var0_0.onUpdateD(arg0_18)
	local var0_18 = arg0_18:GetCurFilePath()
	local var1_18 = arg0_18.group:CheckF(var0_18)

	if var1_18 == DownloadState.UpdateSuccess then
		arg0_18.finishCount = arg0_18.finishCount + 1

		if arg0_18.singleFinshCB then
			arg0_18.singleFinshCB(var0_18, arg0_18.finishCount, #arg0_18.downloadList)
		end

		arg0_18.curIndex = arg0_18.curIndex + 1

		arg0_18:updateWithIndex(arg0_18.curIndex)
	elseif var1_18 == DownloadState.UpdateFailure then
		if arg0_18.errorCB then
			arg0_18.errorCB(var0_18)
		end

		arg0_18:clearTimer()
	elseif var1_18 == DownloadState.Updating and arg0_18.progressCB then
		arg0_18.progressCB(var0_18, arg0_18.group:GetWebReqProgress())
	end
end

function var0_0.createUpdateTimer(arg0_19)
	arg0_19.frameTimer = FrameTimer.New(function()
		arg0_19:onUpdateD()
	end, 1, -1)

	arg0_19.frameTimer:Start()
end
