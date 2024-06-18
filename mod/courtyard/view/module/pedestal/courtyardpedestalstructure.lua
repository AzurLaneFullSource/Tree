local var0_0 = class("CourtYardPedestalStructure")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.parent = arg1_1
	arg0_1.asset = nil
	arg0_1.level = 0
	arg0_1.isDirty = false
	arg0_1.state = var1_0
end

function var0_0.GetRect(arg0_2)
	return arg0_2.parent:GetView():GetRect()
end

function var0_0.IsEditModeOrIsVisit(arg0_3)
	return arg0_3.parent:GetController():IsEditModeOrIsVisit()
end

function var0_0.IsEmpty(arg0_4)
	return arg0_4.state == var1_0
end

function var0_0.IsLoading(arg0_5)
	return arg0_5.state == var2_0
end

function var0_0.IsLoaded(arg0_6)
	return arg0_6.state == var4_0
end

function var0_0.IsExit(arg0_7)
	return arg0_7.state == var5_0
end

function var0_0.IsDirty(arg0_8)
	return arg0_8.state == var3_0
end

function var0_0.Update(arg0_9, arg1_9)
	arg0_9:UpdateLevel(arg1_9)

	if arg0_9:IsEmpty() then
		arg0_9:Load()
	elseif arg0_9:IsLoading() then
		arg0_9:SetDirty()
	elseif arg0_9:IsLoaded() then
		arg0_9:ReLoad()
	end
end

function var0_0.UpdateLevel(arg0_10, arg1_10)
	if arg0_10.level ~= arg1_10 then
		arg0_10.isDirty = true
	end

	arg0_10.level = arg1_10
end

function var0_0.Load(arg0_11, arg1_11)
	arg0_11.state = var2_0

	ResourceMgr.Inst:getAssetAsync(arg0_11:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
		if arg0_11:IsExit() or IsNil(arg0_12) then
			return
		end

		if arg0_11:IsDirty() then
			arg0_11:ReLoad()

			return
		end

		if arg1_11 then
			arg1_11()
		end

		arg0_11.state = var4_0

		local var0_12 = Object.Instantiate(arg0_12, arg0_11.parent._tf)

		arg0_11:OnLoaded(var0_12)

		arg0_11.asset = var0_12
	end), true, true)
end

function var0_0.SetDirty(arg0_13)
	if arg0_13.isDirty then
		arg0_13.state = var3_0
	end
end

function var0_0.ReLoad(arg0_14)
	arg0_14:Load(function()
		arg0_14:Unload()
	end)
end

function var0_0.Unload(arg0_16)
	if not IsNil(arg0_16.asset) then
		Object.Destroy(arg0_16.asset)
	end

	arg0_16.asset = nil
	arg0_16.state = var1_0
end

function var0_0.Dispose(arg0_17)
	pg.DelegateInfo.Dispose(arg0_17)
	arg0_17:Unload()

	arg0_17.state = var5_0
end

function var0_0.OnLoaded(arg0_18)
	return
end

function var0_0.GetAssetPath(arg0_19)
	assert(false, "overwrite me !!!")
end

return var0_0
