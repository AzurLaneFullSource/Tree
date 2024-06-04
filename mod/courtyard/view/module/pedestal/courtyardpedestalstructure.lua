local var0 = class("CourtYardPedestalStructure")
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3
local var5 = 4

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.parent = arg1
	arg0.asset = nil
	arg0.level = 0
	arg0.isDirty = false
	arg0.state = var1
end

function var0.GetRect(arg0)
	return arg0.parent:GetView():GetRect()
end

function var0.IsEditModeOrIsVisit(arg0)
	return arg0.parent:GetController():IsEditModeOrIsVisit()
end

function var0.IsEmpty(arg0)
	return arg0.state == var1
end

function var0.IsLoading(arg0)
	return arg0.state == var2
end

function var0.IsLoaded(arg0)
	return arg0.state == var4
end

function var0.IsExit(arg0)
	return arg0.state == var5
end

function var0.IsDirty(arg0)
	return arg0.state == var3
end

function var0.Update(arg0, arg1)
	arg0:UpdateLevel(arg1)

	if arg0:IsEmpty() then
		arg0:Load()
	elseif arg0:IsLoading() then
		arg0:SetDirty()
	elseif arg0:IsLoaded() then
		arg0:ReLoad()
	end
end

function var0.UpdateLevel(arg0, arg1)
	if arg0.level ~= arg1 then
		arg0.isDirty = true
	end

	arg0.level = arg1
end

function var0.Load(arg0, arg1)
	arg0.state = var2

	ResourceMgr.Inst:getAssetAsync(arg0:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0:IsExit() or IsNil(arg0) then
			return
		end

		if arg0:IsDirty() then
			arg0:ReLoad()

			return
		end

		if arg1 then
			arg1()
		end

		arg0.state = var4

		local var0 = Object.Instantiate(arg0, arg0.parent._tf)

		arg0:OnLoaded(var0)

		arg0.asset = var0
	end), true, true)
end

function var0.SetDirty(arg0)
	if arg0.isDirty then
		arg0.state = var3
	end
end

function var0.ReLoad(arg0)
	arg0:Load(function()
		arg0:Unload()
	end)
end

function var0.Unload(arg0)
	if not IsNil(arg0.asset) then
		Object.Destroy(arg0.asset)
	end

	arg0.asset = nil
	arg0.state = var1
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Unload()

	arg0.state = var5
end

function var0.OnLoaded(arg0)
	return
end

function var0.GetAssetPath(arg0)
	assert(false, "overwrite me !!!")
end

return var0
