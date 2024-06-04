local var0 = {}

var0.DormGroupName = "DORM"
var0.DormMgr = nil

function var0.GetDormMgr()
	if not var0.DormMgr then
		var0.DormMgr = BundleWizard.Inst:GetGroupMgr(var0.DormGroupName)
	end

	return var0.DormMgr
end

var0.NotifyDormDownloadFinish = "DormGroupConst.NotifyDormDownloadFinish"

function var0.VerifyDormFileName(arg0)
	return GroupHelper.VerifyFile(var0.DormGroupName, arg0)
end

function var0.CalcDormListSize(arg0)
	local var0 = GroupHelper.CreateArrByLuaFileList(var0.DormGroupName, arg0)
	local var1 = GroupHelper.CalcSizeWithFileArr(var0.DormGroupName, var0)
	local var2 = HashUtil.BytesToString(var1)

	return var1, var2
end

function var0.IsDormNeedCheck()
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0.DormGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0.DormGroupName) then
		return false
	end

	return true
end

function var0.DormDownload(arg0)
	local var0 = {}

	if var0.IsDormNeedCheck() then
		local var1 = arg0.isShowBox
		local var2 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3 = IsUsingWifi()
		local var4 = var1 and var2
		local var5 = arg0.fileList

		if #var5 > 0 then
			if not var3 and var4 then
				local var6, var7 = var0.CalcDormListSize(var5)

				if var6 > 0 then
					table.insert(var0, function(arg0)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7)),
							onYes = arg0,
							onNo = arg0.onNo,
							onClose = arg0.onClose
						})
					end)
				end
			end

			table.insert(var0, function(arg0)
				local var0 = {
					groupName = var0.DormGroupName,
					fileNameList = var5
				}
				local var1 = {
					dataList = {
						var0
					},
					onFinish = arg0
				}

				pg.FileDownloadMgr.GetInstance():Main(var1)
			end)
			table.insert(var0, function(arg0)
				pg.m02:sendNotification(var0.NotifyDormDownloadFinish)
				arg0()
			end)
		end
	end

	seriesAsync(var0, arg0.finishFunc)
end

return var0
