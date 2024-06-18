local var0_0 = class("CourtYardBGAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.prefab = nil
end

function var0_0.Switch(arg0_2, arg1_2, arg2_2)
	if not arg2_2 then
		return
	end

	local var0_2 = arg0_2.prefab and arg0_2.prefab.name or ""

	if arg1_2 and var0_2 ~= arg2_2 then
		arg0_2:LoadBG(arg2_2)
	elseif arg1_2 and var0_2 == arg2_2 then
		-- block empty
	elseif not arg1_2 and var0_2 == arg2_2 then
		arg0_2:Clear()
	else
		assert(false)
	end
end

function var0_0.LoadBG(arg0_3, arg1_3)
	PoolMgr.GetInstance():GetPrefab("BackyardBG/" .. arg1_3, arg1_3, true, function(arg0_4)
		if arg0_3.exited then
			PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. arg1_3, arg1_3, arg0_4)
		end

		arg0_4.name = arg1_3

		setParent(arg0_4, arg0_3._tf)
		arg0_4.transform:SetAsFirstSibling()
		setActive(arg0_4, true)

		arg0_3.prefab = arg0_4
	end)
end

function var0_0.Clear(arg0_5)
	if arg0_5.prefab then
		local var0_5 = arg0_5.prefab.name

		PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. var0_5, var0_5, arg0_5.prefab)

		arg0_5.prefab = nil
	end
end

function var0_0.ClearByName(arg0_6, arg1_6)
	if arg0_6.prefab and arg0_6.prefab.name == arg1_6 then
		arg0_6:Clear()
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:Clear(true)

	arg0_7.exited = true
end

return var0_0
