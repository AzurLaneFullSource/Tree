local var0_0 = {}

var0_0.DormGroupName = "DORM"
var0_0.DormMgr = nil

function var0_0.GetDormMgr()
	if not var0_0.DormMgr then
		var0_0.DormMgr = BundleWizard.Inst:GetGroupMgr(var0_0.DormGroupName)
	end

	return var0_0.DormMgr
end

var0_0.NotifyDormDownloadStart = "DormGroupConst.NotifyDormDownloadStart"
var0_0.NotifyDormDownloadProgress = "DormGroupConst.NotifyDormDownloadProgress"
var0_0.NotifyDormDownloadFinish = "DormGroupConst.NotifyDormDownloadFinish"

function var0_0.VerifyDormFileName(arg0_2)
	return GroupHelper.VerifyFile(var0_0.DormGroupName, arg0_2)
end

function var0_0.CalcDormListSize(arg0_3)
	local var0_3 = GroupHelper.CreateArrByLuaFileList(var0_0.DormGroupName, arg0_3)
	local var1_3 = GroupHelper.CalcSizeWithFileArr(var0_0.DormGroupName, var0_3)
	local var2_3 = HashUtil.BytesToString(var1_3)

	return var1_3, var2_3
end

function var0_0.IsDormNeedCheck()
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0_0.DormGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0_0.DormGroupName) then
		return false
	end

	return true
end

function var0_0.DormDownload(arg0_5)
	local var0_5 = {}

	if var0_0.IsDormNeedCheck() then
		local var1_5 = arg0_5.isShowBox
		local var2_5 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3_5 = IsUsingWifi()
		local var4_5 = var1_5 and var2_5
		local var5_5 = arg0_5.fileList

		if #var5_5 > 0 then
			if var4_5 then
				local var6_5, var7_5 = var0_0.CalcDormListSize(var5_5)

				if var6_5 > 0 then
					table.insert(var0_5, function(arg0_6)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							hideToggle = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7_5)),
							onYes = arg0_6,
							onNo = arg0_5.onNo,
							onClose = arg0_5.onClose
						})
					end)
				end
			end

			table.insert(var0_5, function(arg0_7)
				var0_0.DormDownloadLock = {
					curSize = 0,
					totalSize = 1,
					roomId = arg0_5.roomId
				}

				local var0_7 = {
					groupName = var0_0.DormGroupName,
					fileNameList = var5_5
				}
				local var1_7 = {
					dataList = {
						var0_7
					},
					onFinish = arg0_7
				}

				var0_0.ExtraDownload(var1_7.dataList[1], var1_7.onFinish)
			end)
			table.insert(var0_5, function(arg0_8, arg1_8)
				local var0_8 = var0_0.DormDownloadLock.roomId

				var0_0.DormDownloadLock = nil

				pg.m02:sendNotification(var0_0.NotifyDormDownloadFinish, var0_8)
				arg0_8(arg1_8)
			end)
		end
	end

	seriesAsync(var0_5, arg0_5.finishFunc)
end

function var0_0.ExtraDownload(arg0_9, arg1_9)
	local var0_9 = arg0_9.groupName
	local var1_9 = #arg0_9.fileNameList > 0 and GroupHelper.CreateArrByLuaFileList(var0_9, arg0_9.fileNameList) or nil

	if not var1_9 or var1_9.Length == 0 then
		arg1_9()

		return
	end

	local var2_9 = GroupHelper.GetGroupMgrByName(var0_9)

	local function var3_9(arg0_10, arg1_10, arg2_10, arg3_10)
		if var0_0.DormDownloadLock.curSize ~= arg2_10 then
			var0_0.DormDownloadLock.curSize = arg2_10
			var0_0.DormDownloadLock.totalSize = arg3_10

			pg.m02:sendNotification(var0_0.NotifyDormDownloadProgress)
		end
	end

	local function var4_9(arg0_11, arg1_11)
		return
	end

	local function var5_9(arg0_12, arg1_12)
		warning("----------------------Tag 单组下载完成,恢复UpdateD----------------------")

		var2_9.isPauseUpdateD = false

		warning("----------------------Tag 单组下载完成,调用groupComplete----------------------")
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_0.DormDownloadLock.roomId, 1))
		arg1_9(true)
	end

	local var6_9

	local function var7_9(arg0_13, arg1_13)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_0.DormDownloadLock.roomId, 2))

		local function var0_13()
			var0_0.ExtraDownload(arg0_9, arg1_9)
		end

		local function var1_13()
			var2_9.isPauseUpdateD = false

			arg1_9()
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			locked = true,
			content = i18n("file_down_mgr_error", arg0_13, arg1_13),
			onYes = var0_13,
			onNo = var1_13,
			onClose = var1_13,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	pg.m02:sendNotification(var0_0.NotifyDormDownloadStart)
	warning("----------------------Tag 停止UpdateD----------------------")

	var2_9.isPauseUpdateD = true

	warning("----------------------Tag 开始UpdateFileArray----------------------")
	var2_9:UpdateFileArray(var1_9, var3_9, var4_9, var5_9, var7_9)
end

function var0_0.IsDownloading()
	local var0_16 = GroupHelper.GetGroupMgrByName(var0_0.DormGroupName)

	return var0_0.DormDownloadLock or GroupHelper.GetGroupMgrByName(var0_0.DormGroupName).state == DownloadState.Updating
end

function var0_0.GetDownloadList()
	local var0_17 = {}
	local var1_17 = GroupHelper.GetGroupMgrByName(var0_0.DormGroupName)

	if var1_17.toUpdate then
		local var2_17 = var1_17.toUpdate.Count

		for iter0_17 = 0, var2_17 - 1 do
			local var3_17 = var1_17.toUpdate[iter0_17]
			local var4_17 = var3_17[0]
			local var5_17 = var3_17[1]
			local var6_17 = var3_17[2]

			table.insert(var0_17, var4_17)
		end
	end

	return var0_17
end

local var1_0 = {
	room = "dorm3d/scenesres/scenes/",
	apartment = "dorm3d/character/"
}
local var2_0

function var0_0.GetDownloadResourceDic()
	if not var2_0 then
		var2_0 = {}

		for iter0_18, iter1_18 in ipairs(pg.dorm3d_rooms.all) do
			local var0_18 = string.lower(pg.dorm3d_rooms[iter1_18].resource_name)

			var2_0[var0_18] = true
		end
	end

	local var1_18 = {}

	for iter2_18, iter3_18 in ipairs(DormGroupConst.GetDownloadList()) do
		local var2_18 = "common"

		for iter4_18, iter5_18 in pairs(var1_0) do
			local var3_18, var4_18 = string.find(iter3_18, iter5_18)

			if var4_18 then
				local var5_18 = string.split(string.sub(iter3_18, var4_18 + 1), "/")[1]

				if var2_0[var5_18] then
					var2_18 = iter4_18 .. "_" .. var5_18
				end

				break
			end
		end

		var1_18[var2_18] = var1_18[var2_18] or {}

		table.insert(var1_18[var2_18], iter3_18)
	end

	return var1_18
end

function var0_0.DelDir(arg0_19)
	local var0_19 = Application.persistentDataPath .. "/AssetBundles/"
	local var1_19 = var0_19 .. arg0_19

	if not var0_19:match("/$") then
		var0_19 = var0_19 .. "/"
	end

	originalPrint("fullCacheDirPath", tostring(var0_19))
	originalPrint("shortDirPath:", tostring(arg0_19))
	originalPrint("fullDirPath", tostring(var1_19))

	local var2_19 = {}
	local var3_19 = System.IO.Directory
	local var4_19 = ReflectionHelp.RefGetField(typeof("System.IO.SearchOption"), "AllDirectories", nil)

	originalPrint("fullDirPath Exist:", tostring(var3_19.Exists(var1_19)))

	if var3_19.Exists(var1_19) then
		local var5_19 = var3_19.GetFiles(var1_19, "*", var4_19)

		for iter0_19 = 0, var5_19.Length - 1 do
			local var6_19 = var5_19[iter0_19]:gsub("\\", "/")
			local var7_19 = string.sub(var6_19, #var0_19 + 1)

			table.insert(var2_19, var7_19)
		end
	end

	originalPrint("filePathList first:", tostring(var2_19[1]))
	originalPrint("filePathList last:", tostring(var2_19[#var2_19]))

	local var8_19 = #var2_19

	if var8_19 > 0 then
		local var9_19 = System.Array.CreateInstance(typeof(System.String), var8_19)

		for iter1_19 = 0, var8_19 - 1 do
			var9_19[iter1_19] = var2_19[iter1_19 + 1]
		end

		var0_0.GetDormMgr():DelFile(var9_19)
	end
end

function var0_0.DelRoom(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg1_20) do
		var0_0.DelDir(var1_0[iter1_20] .. arg0_20)
	end
end

return var0_0
