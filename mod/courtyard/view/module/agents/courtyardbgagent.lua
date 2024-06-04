local var0 = class("CourtYardBGAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.prefab = nil
end

function var0.Switch(arg0, arg1, arg2)
	if not arg2 then
		return
	end

	local var0 = arg0.prefab and arg0.prefab.name or ""

	if arg1 and var0 ~= arg2 then
		arg0:LoadBG(arg2)
	elseif arg1 and var0 == arg2 then
		-- block empty
	elseif not arg1 and var0 == arg2 then
		arg0:Clear()
	else
		assert(false)
	end
end

function var0.LoadBG(arg0, arg1)
	PoolMgr.GetInstance():GetPrefab("BackyardBG/" .. arg1, arg1, true, function(arg0)
		if arg0.exited then
			PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. arg1, arg1, arg0)
		end

		arg0.name = arg1

		setParent(arg0, arg0._tf)
		arg0.transform:SetAsFirstSibling()
		setActive(arg0, true)

		arg0.prefab = arg0
	end)
end

function var0.Clear(arg0)
	if arg0.prefab then
		local var0 = arg0.prefab.name

		PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. var0, var0, arg0.prefab)

		arg0.prefab = nil
	end
end

function var0.ClearByName(arg0, arg1)
	if arg0.prefab and arg0.prefab.name == arg1 then
		arg0:Clear()
	end
end

function var0.Dispose(arg0)
	arg0:Clear(true)

	arg0.exited = true
end

return var0
