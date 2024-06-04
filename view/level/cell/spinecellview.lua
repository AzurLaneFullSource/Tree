local var0 = class("SpineCellView")

function var0.Ctor(arg0)
	return
end

function var0.InitCellTransform(arg0)
	arg0.tfShip = arg0.tf:Find("ship")
	arg0.tfShadow = arg0.tf:Find("shadow")
end

function var0.GetRotatePivot(arg0)
	return arg0.tfShip
end

function var0.GetAction(arg0)
	return arg0.action
end

function var0.SetAction(arg0, arg1)
	arg0.action = arg1

	if arg0.spineRole then
		arg0.spineRole:SetAction(arg1)
	end
end

function var0.GetSpineRole(arg0)
	return arg0.spineRole
end

function var0.LoadSpine(arg0, arg1, arg2, arg3, arg4)
	if arg0.lastPrefab == arg1 then
		if arg0.spineRole:CheckInited() then
			existCall(arg4)
		end

		return
	end

	arg0.UnloadSpine(arg0)

	arg0.lastPrefab = arg1
	arg0.spineRole = SpineRole.New()

	arg0.spineRole:SetData(arg1, arg3)
	arg0.spineRole:Load(function()
		arg0.spineRole:SetParent(arg0.tfShip)
		arg0.spineRole:SetRaycastTarget(false)
		arg0.spineRole:SetLocalPos(Vector3.zero)

		arg2 = arg2 and arg2 * 0.01 or 1

		arg0.spineRole:SetLocalScale(Vector3(0.4 * arg2, 0.4 * arg2, 1))
		arg0:SetAction(arg0:GetAction())
		existCall(arg4)
	end, nil, arg0.spineRole.ORBIT_KEY_SLG)
end

function var0.UnloadSpine(arg0)
	arg0.lastPrefab = nil

	if arg0.spineRole then
		arg0.spineRole:Dispose()

		arg0.spineRole = nil
	end
end

function var0.SetSpineVisible(arg0, arg1)
	if arg0.spineRole then
		arg0.spineRole:SetVisible(arg1)
	end
end

function var0.ClearSpine(arg0)
	arg0.UnloadSpine(arg0)
end

return var0
