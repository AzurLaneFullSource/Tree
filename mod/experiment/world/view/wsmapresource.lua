local var0 = class("WSMapResource", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	rtDarkFog = "userdata",
	rtSairenFog = "userdata"
}

function var0.Setup(arg0, arg1)
	arg0.map = arg1
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.Load(arg0, arg1)
	local var0 = {}
	local var1 = arg0.map

	table.insert(var0, function(arg0)
		PoolMgr.GetInstance():GetUI("darkfog", true, function(arg0)
			setParent(arg0, GameObject.Find("__Pool__").transform)

			arg0.rtDarkFog = arg0.transform

			setActive(arg0.rtDarkFog, false)
			arg0()
		end)
	end)
	table.insert(var0, function(arg0)
		PoolMgr.GetInstance():GetUI("sairenfog", true, function(arg0)
			setParent(arg0, GameObject.Find("__Pool__").transform)

			arg0.rtSairenFog = arg0.transform

			setActive(arg0.rtSairenFog, false)
			arg0()
		end)
	end)
	seriesAsync(var0, arg1)
end

function var0.Unload(arg0)
	if arg0.rtDarkFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", arg0.rtDarkFog.gameObject)

		arg0.rtDarkFog = nil
	end

	if arg0.rtSairenFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", arg0.rtSairenFog.gameObject)

		arg0.rtSairenFog = nil
	end
end

return var0
