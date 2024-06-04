local var0 = class("CryptolaliaDownloadMgr")

var0.PROGRESS_FINISH = -99
var0.PROGRESS_ERROR = -100

function var0.Ctor(arg0)
	arg0.callbacks = {}
	arg0.mgr = pg.CipherGroupMgr:GetInstance()

	local var0 = {
		progressCB = function(arg0, arg1)
			if arg0.callbacks[arg0] then
				arg0.callbacks[arg0](arg0, arg1)
			end
		end,
		allFinishCB = function(arg0, arg1)
			warning("全部完成")
		end,
		singleFinshCB = function(arg0, arg1, arg2)
			if arg0.callbacks[arg0] then
				arg0.callbacks[arg0](arg0, var0.PROGRESS_FINISH)

				arg0.callbacks[arg0] = nil
			end
		end,
		errorCB = function(arg0)
			local var0 = string.format("出错文件:%s", arg0)

			warning(var0)

			if arg0.callbacks[arg0] then
				arg0.callbacks[arg0](arg0, var0.PROGRESS_ERROR)

				arg0.callbacks[arg0] = nil
			end
		end
	}

	arg0.mgr:SetCallBack(var0)
end

function var0.Request(arg0, arg1, arg2)
	local var0 = string.lower(arg1[#arg1])

	arg0.callbacks[var0] = arg2

	local var1 = GroupHelper.GetGroupMgrByName("CIPHER")
	local var2 = arg0.mgr:IsAnyFileInProgress()
	local var3 = table.concat(arg1, ",")

	if var2 then
		arg0.mgr:AddFileList(arg1)
	else
		arg0.mgr:StartWithFileList(arg1)
	end
end

function var0.ReConnection(arg0, arg1, arg2)
	local var0 = arg1[#arg1]

	if arg0:IsDownloadState(var0) then
		local var1 = string.lower(var0)

		arg0.callbacks[var1] = arg2
	end
end

function var0.IsDownloadState(arg0, arg1)
	arg1 = string.lower(arg1)

	local var0 = arg0.mgr.downloadList

	for iter0 = arg0.mgr.curIndex, #var0 do
		if var0[iter0] == arg1 then
			return true
		end
	end

	return false
end

function var0.Dispose(arg0)
	arg0.callbacks = {}

	local var0 = {}

	arg0.mgr:SetCallBack(var0)
end

return var0
