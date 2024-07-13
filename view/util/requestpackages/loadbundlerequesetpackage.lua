local var0_0 = class("LoadBundleRequesetPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	seriesAsync({
		function(arg0_2)
			pg.UIMgr.GetInstance():LoadingOn()

			local var0_2 = arg0_1.path

			xpcall(function()
				buildTempAB(var0_2, function(arg0_4)
					pg.UIMgr.GetInstance():LoadingOff()

					if arg0_1.stopped then
						ResourceMgr.Inst:ClearBundleRef(var0_2, false, false)

						return
					end

					arg0_2(arg0_4)
				end)
			end, function(...)
				debug.traceback(...)
				pg.UIMgr.GetInstance():LoadingOff()
			end)
		end,
		function(arg0_6, arg1_6)
			existCall(arg0_1.onLoaded, arg1_6)
		end
	})

	return arg0_1
end

function var0_0.Ctor(arg0_7, arg1_7, arg2_7)
	arg0_7.path = arg1_7
	arg0_7.onLoaded = arg2_7
end

return var0_0
