local var0 = class("SettingsAccountTwPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAccountTW"
end

function var0.InitTitle(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.googleBtn = arg0._tf:Find("page1/bind_google")
	arg0.gamecenterBtn = arg0._tf:Find("page1/bind_gamecenter")
	arg0.faceBookBtn = arg0._tf:Find("page1/bind_facebook")
	arg0.phoneBtn = arg0._tf:Find("page1/bind_phone")
	arg0.appleBtn = arg0._tf:Find("page1/bind_apple")

	setActive(arg0.appleBtn, true)

	local var0 = {
		arg0.faceBookBtn,
		arg0.googleBtn,
		arg0.phoneBtn,
		arg0.gamecenterBtn,
		arg0.appleBtn
	}
	local var1 = pg.SdkMgr.GetInstance()
	local var2 = var1:IsBindFaceBook()
	local var3 = var1:IsBindGoogle()
	local var4 = var1:IsBindPhone()
	local var5 = var1:IsBindGameCenter()
	local var6 = var1:IsBindApple()
	local var7 = {
		var2,
		var3,
		var4,
		var5,
		var6
	}

	for iter0, iter1 in ipairs(var0) do
		local var8 = var7[iter0]

		setActive(iter1:Find("unbind"), not var8)
		setActive(iter1:Find("bind"), var8)
		onButton(arg0, iter1, function()
			if not var8 then
				var1:BindSocial(iter0)
			end
		end, SFX_PANEL)
	end
end

function var0.OnUpdate(arg0)
	if PLATFORM == PLATFORM_ANDROID then
		setActive(arg0.googleBtn, true)
		setActive(arg0.gamecenterBtn, false)
	else
		setActive(arg0.googleBtn, true)
		setActive(arg0.gamecenterBtn, false)
	end
end

return var0
