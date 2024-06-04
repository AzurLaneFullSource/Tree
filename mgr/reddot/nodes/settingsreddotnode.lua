local var0 = class("SettingsRedDotNode", import(".RedDotNode"))

var0.CVChecked = false
var0.CanUpdateCV = false

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	arg0:CheckCV()
end

function var0.CheckCV(arg0)
	if var0.CVChecked then
		return
	end

	var0.CVChecked = true

	local var0 = BundleWizard.Inst:GetGroupMgr("CV")

	var0:CheckD()

	local var1

	var1 = Timer.New(function()
		if var0.state == DownloadState.CheckToUpdate then
			var0.CanUpdateCV = true

			arg0:SetData(false)
		end

		if var0.state ~= DownloadState.None then
			var1:Stop()
		end
	end, 0.5, -1)

	var1:Start()
end

function var0.SetData(arg0, arg1)
	if IsNil(arg0.gameObject) then
		return
	end

	setActive(arg0.gameObject, arg1 or var0.CanUpdateCV)
end

return var0
