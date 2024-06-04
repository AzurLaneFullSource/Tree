local var0 = class("LoadBundleRequesetPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn()

			local var0 = arg0.path

			xpcall(function()
				buildTempAB(var0, function(arg0)
					pg.UIMgr.GetInstance():LoadingOff()

					if arg0.stopped then
						ResourceMgr.Inst:ClearBundleRef(var0, false, false)

						return
					end

					arg0(arg0)
				end)
			end, function(...)
				debug.traceback(...)
				pg.UIMgr.GetInstance():LoadingOff()
			end)
		end,
		function(arg0, arg1)
			existCall(arg0.onLoaded, arg1)
		end
	})

	return arg0
end

function var0.Ctor(arg0, arg1, arg2)
	arg0.path = arg1
	arg0.onLoaded = arg2
end

return var0
