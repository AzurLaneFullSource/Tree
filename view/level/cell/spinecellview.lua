local var0_0 = class("SpineCellView")

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.InitCellTransform(arg0_2)
	arg0_2.tfShip = arg0_2.tf:Find("ship")
	arg0_2.tfShadow = arg0_2.tf:Find("shadow")
end

function var0_0.GetRotatePivot(arg0_3)
	return arg0_3.tfShip
end

function var0_0.GetAction(arg0_4)
	return arg0_4.action
end

function var0_0.SetAction(arg0_5, arg1_5)
	arg0_5.action = arg1_5

	if arg0_5.spineRole then
		arg0_5.spineRole:SetAction(arg1_5)
	end
end

function var0_0.GetSpineRole(arg0_6)
	return arg0_6.spineRole
end

function var0_0.LoadSpine(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg0_7.lastPrefab == arg1_7 then
		if arg0_7.spineRole:CheckInited() then
			existCall(arg4_7)
		end

		return
	end

	arg0_7.UnloadSpine(arg0_7)

	arg0_7.lastPrefab = arg1_7
	arg0_7.spineRole = SpineRole.New()

	arg0_7.spineRole:SetData(arg1_7, arg3_7)
	arg0_7.spineRole:Load(function()
		arg0_7.spineRole:SetParent(arg0_7.tfShip)
		arg0_7.spineRole:SetRaycastTarget(false)
		arg0_7.spineRole:SetLocalPos(Vector3.zero)

		arg2_7 = arg2_7 and arg2_7 * 0.01 or 1

		arg0_7.spineRole:SetLocalScale(Vector3(0.4 * arg2_7, 0.4 * arg2_7, 1))
		arg0_7:SetAction(arg0_7:GetAction())
		existCall(arg4_7)
	end, nil, arg0_7.spineRole.ORBIT_KEY_SLG)
end

function var0_0.UnloadSpine(arg0_9)
	arg0_9.lastPrefab = nil

	if arg0_9.spineRole then
		arg0_9.spineRole:Dispose()

		arg0_9.spineRole = nil
	end
end

function var0_0.SetSpineVisible(arg0_10, arg1_10)
	if arg0_10.spineRole then
		arg0_10.spineRole:SetVisible(arg1_10)
	end
end

function var0_0.ClearSpine(arg0_11)
	arg0_11.UnloadSpine(arg0_11)
end

return var0_0
