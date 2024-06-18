local var0_0 = class("WSMapResource", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	rtDarkFog = "userdata",
	rtSairenFog = "userdata"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.map = arg1_1
end

function var0_0.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Load(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = arg0_3.map

	table.insert(var0_3, function(arg0_4)
		PoolMgr.GetInstance():GetUI("darkfog", true, function(arg0_5)
			setParent(arg0_5, GameObject.Find("__Pool__").transform)

			arg0_3.rtDarkFog = arg0_5.transform

			setActive(arg0_3.rtDarkFog, false)
			arg0_4()
		end)
	end)
	table.insert(var0_3, function(arg0_6)
		PoolMgr.GetInstance():GetUI("sairenfog", true, function(arg0_7)
			setParent(arg0_7, GameObject.Find("__Pool__").transform)

			arg0_3.rtSairenFog = arg0_7.transform

			setActive(arg0_3.rtSairenFog, false)
			arg0_6()
		end)
	end)
	seriesAsync(var0_3, arg1_3)
end

function var0_0.Unload(arg0_8)
	if arg0_8.rtDarkFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", arg0_8.rtDarkFog.gameObject)

		arg0_8.rtDarkFog = nil
	end

	if arg0_8.rtSairenFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", arg0_8.rtSairenFog.gameObject)

		arg0_8.rtSairenFog = nil
	end
end

return var0_0
