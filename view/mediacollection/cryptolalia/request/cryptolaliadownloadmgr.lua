local var0_0 = class("CryptolaliaDownloadMgr")

var0_0.PROGRESS_FINISH = -99
var0_0.PROGRESS_ERROR = -100

function var0_0.Ctor(arg0_1)
	arg0_1.callbacks = {}
	arg0_1.mgr = pg.CipherGroupMgr:GetInstance()

	local var0_1 = {
		progressCB = function(arg0_2, arg1_2)
			if arg0_1.callbacks[arg0_2] then
				arg0_1.callbacks[arg0_2](arg0_2, arg1_2)
			end
		end,
		allFinishCB = function(arg0_3, arg1_3)
			warning("全部完成")
		end,
		singleFinshCB = function(arg0_4, arg1_4, arg2_4)
			if arg0_1.callbacks[arg0_4] then
				arg0_1.callbacks[arg0_4](arg0_4, var0_0.PROGRESS_FINISH)

				arg0_1.callbacks[arg0_4] = nil
			end
		end,
		errorCB = function(arg0_5)
			local var0_5 = string.format("出错文件:%s", arg0_5)

			warning(var0_5)

			if arg0_1.callbacks[arg0_5] then
				arg0_1.callbacks[arg0_5](arg0_5, var0_0.PROGRESS_ERROR)

				arg0_1.callbacks[arg0_5] = nil
			end
		end
	}

	arg0_1.mgr:SetCallBack(var0_1)
end

function var0_0.Request(arg0_6, arg1_6, arg2_6)
	local var0_6 = string.lower(arg1_6[#arg1_6])

	arg0_6.callbacks[var0_6] = arg2_6

	local var1_6 = GroupHelper.GetGroupMgrByName("CIPHER")
	local var2_6 = arg0_6.mgr:IsAnyFileInProgress()
	local var3_6 = table.concat(arg1_6, ",")

	if var2_6 then
		arg0_6.mgr:AddFileList(arg1_6)
	else
		arg0_6.mgr:StartWithFileList(arg1_6)
	end
end

function var0_0.ReConnection(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7[#arg1_7]

	if arg0_7:IsDownloadState(var0_7) then
		local var1_7 = string.lower(var0_7)

		arg0_7.callbacks[var1_7] = arg2_7
	end
end

function var0_0.IsDownloadState(arg0_8, arg1_8)
	arg1_8 = string.lower(arg1_8)

	local var0_8 = arg0_8.mgr.downloadList

	for iter0_8 = arg0_8.mgr.curIndex, #var0_8 do
		if var0_8[iter0_8] == arg1_8 then
			return true
		end
	end

	return false
end

function var0_0.Dispose(arg0_9)
	arg0_9.callbacks = {}

	local var0_9 = {}

	arg0_9.mgr:SetCallBack(var0_9)
end

return var0_0
