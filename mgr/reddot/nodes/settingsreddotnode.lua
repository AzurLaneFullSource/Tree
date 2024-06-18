local var0_0 = class("SettingsRedDotNode", import(".RedDotNode"))

var0_0.CVChecked = false
var0_0.CanUpdateCV = false

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:CheckCV()
end

function var0_0.CheckCV(arg0_2)
	if var0_0.CVChecked then
		return
	end

	var0_0.CVChecked = true

	local var0_2 = BundleWizard.Inst:GetGroupMgr("CV")

	var0_2:CheckD()

	local var1_2

	var1_2 = Timer.New(function()
		if var0_2.state == DownloadState.CheckToUpdate then
			var0_0.CanUpdateCV = true

			arg0_2:SetData(false)
		end

		if var0_2.state ~= DownloadState.None then
			var1_2:Stop()
		end
	end, 0.5, -1)

	var1_2:Start()
end

function var0_0.SetData(arg0_4, arg1_4)
	if IsNil(arg0_4.gameObject) then
		return
	end

	setActive(arg0_4.gameObject, arg1_4 or var0_0.CanUpdateCV)
end

return var0_0
