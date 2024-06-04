pg = pg or {}
pg.CipherGroupMgr = singletonClass("CipherGroupMgr")

local var0 = pg.CipherGroupMgr

var0.GroupName = "CIPHER"

function var0.Ctor(arg0)
	arg0.group = GroupHelper.GetGroupMgrByName(var0.GroupName)
	arg0.downloadList = {}
	arg0.finishCount = 0
	arg0.curIndex = 0
end

function var0.GetCurFilePath(arg0)
	return arg0.downloadList[arg0.curIndex]
end

function var0.GetCurFileState(arg0)
	local var0 = arg0:GetCurFilePath()

	return arg0.group:CheckF(var0)
end

function var0.GetValidFileList(arg0, arg1)
	local var0 = {}

	if GroupHelper.IsGroupWaitToUpdate(var0.GroupName) then
		for iter0, iter1 in ipairs(arg1) do
			iter1 = string.lower(iter1)

			local var1 = GroupHelper.VerifyFile(var0.GroupName, iter1)

			warning(iter1 .. " " .. tostring(var1))

			if var1 then
				table.insert(var0, iter1)
			end
		end
	end

	return var0
end

function var0.StartWithFileList(arg0, arg1)
	local var0 = arg0:GetValidFileList(arg1)

	if #var0 > 0 then
		arg0:Clear()

		arg0.downloadList = var0
		arg0.curIndex = 1

		arg0:updateWithIndex(1)
		arg0:createUpdateTimer()
	end
end

function var0.AddFileList(arg0, arg1)
	local var0 = arg0:GetValidFileList(arg1)

	if #var0 > 0 then
		for iter0, iter1 in ipairs(var0) do
			table.insert(arg0.downloadList, iter1)
		end
	end
end

function var0.SetCallBack(arg0, arg1)
	arg0.progressCB = arg1.progressCB
	arg0.allFinishCB = arg1.allFinishCB
	arg0.singleFinshCB = arg1.singleFinshCB
	arg0.errorCB = arg1.errorCB
end

function var0.IsAnyFileInProgress(arg0)
	return arg0.curIndex > 0 and arg0.curIndex <= #arg0.downloadList
end

function var0.DelFile(arg0, arg1)
	local var0 = #arg1
	local var1 = System.Array.CreateInstance(typeof(System.String), var0)

	for iter0 = 0, var0 - 1 do
		var1[iter0] = arg1[iter0 + 1]
	end

	arg0.group:DelFile(var1)
end

function var0.DelFile_Old(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = PathMgr.getAssetBundle(iter1)

		warning("full file path:" .. var0)

		if PathMgr.FileExists(var0) then
			System.IO.File.Delete(var0)
			warning("del file path:" .. var0)
		end
	end

	arg0.group:ClearStreamWriter()

	local function var1(arg0)
		local var0 = false

		for iter0, iter1 in ipairs(arg1) do
			if string.sub(arg0, 1, #iter1) == iter1 then
				var0 = true

				break
			end
		end

		return var0
	end

	local var2 = {}
	local var3 = arg0.group.cachedHashPath

	warning("hash path:" .. var3)

	if PathMgr.FileExists(var3) then
		local var4 = PathMgr.ReadAllLines(var3)
		local var5 = var4.Length
		local var6 = {}

		for iter2 = 0, var5 - 1 do
			local var7 = var4[iter2]

			if not var1(var7) then
				warning("add origin hash:" .. var7)
				table.insert(var6, var7)
			else
				warning("find del hash:" .. var7)

				local var8 = var7
				local var9 = System.Array.CreateInstance(typeof(System.String), 3)
				local var10 = string.split(var8, ",")

				for iter3 = 0, 2 do
					local var11 = var10[iter3 + 1]

					warning("add info:" .. var11)

					var9[iter3] = var11
				end

				table.insert(var2, var9)
			end
		end

		local var12 = #var6

		warning("new hash count:" .. var12)

		if var12 < var5 then
			if GroupHelper.IsGroupVerLastest(var0.GroupName) then
				local var13 = Application.persistentDataPath .. "/" .. arg0.group.localVersionFile

				System.IO.File.WriteAllText(var13, "0.0.1")
				warning("ver write:" .. var13)
			end

			local var14 = System.Array.CreateInstance(typeof(System.String), var12)

			for iter4, iter5 in ipairs(var6) do
				var14[iter4 - 1] = iter5
			end

			System.IO.File.WriteAllLines(var3, var14)
			warning("hash write:" .. var3)
		end
	end

	if arg0.group.toUpdate then
		for iter6, iter7 in ipairs(var2) do
			local var15 = iter7[0]

			warning("re add info:" .. var15)
			arg0.group.toUpdate:Add(iter7)
			arg0.group:UpdateFileDownloadStates(var15, DownloadState.CheckToUpdate)
		end

		if arg0.group.state == DownloadState.UpdateSuccess then
			arg0.group.state = DownloadState.CheckToUpdate
		end
	else
		arg0.group.state = DownloadState.None

		arg0.group:CheckD()
	end
end

function var0.Clear(arg0)
	arg0:clearTimer()

	arg0.downloadList = {}
	arg0.finishCount = 0
	arg0.curIndex = 0
end

function var0.isCipherExist(arg0, arg1)
	local var0 = arg0.group:CheckF(arg1)
	local var1 = var0 == DownloadState.None or var0 == DownloadState.UpdateSuccess
	local var2 = PathMgr.getAssetBundle(arg1)
	local var3 = PathMgr.FileExists(var2)

	return var1 and var3
end

function var0.Repair(arg0)
	local var0 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cipher.csv") then
				arg0.group:StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		content = i18n("resource_verify_warn"),
		custom = {
			var0
		}
	})
end

function var0.clearTimer(arg0)
	if arg0.frameTimer then
		arg0.frameTimer:Stop()

		arg0.frameTimer = nil
	end
end

function var0.updateWithIndex(arg0, arg1)
	if arg1 > #arg0.downloadList then
		if arg0.allFinishCB then
			arg0.allFinishCB()
		end

		arg0:Clear()

		return
	end

	local var0 = arg0:GetCurFilePath()

	arg0.group:UpdateF(var0)
end

function var0.onUpdateD(arg0)
	local var0 = arg0:GetCurFilePath()
	local var1 = arg0.group:CheckF(var0)

	if var1 == DownloadState.UpdateSuccess then
		arg0.finishCount = arg0.finishCount + 1

		if arg0.singleFinshCB then
			arg0.singleFinshCB(var0, arg0.finishCount, #arg0.downloadList)
		end

		arg0.curIndex = arg0.curIndex + 1

		arg0:updateWithIndex(arg0.curIndex)
	elseif var1 == DownloadState.UpdateFailure then
		if arg0.errorCB then
			arg0.errorCB(var0)
		end

		arg0:clearTimer()
	elseif var1 == DownloadState.Updating and arg0.progressCB then
		arg0.progressCB(var0, arg0.group:GetWebReqProgress())
	end
end

function var0.createUpdateTimer(arg0)
	arg0.frameTimer = FrameTimer.New(function()
		arg0:onUpdateD()
	end, 1, -1)

	arg0.frameTimer:Start()
end
