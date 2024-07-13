local var0_0 = class("SettingsAccountTwPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountTW"
end

function var0_0.InitTitle(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.googleBtn = arg0_3._tf:Find("page1/bind_google")
	arg0_3.gamecenterBtn = arg0_3._tf:Find("page1/bind_gamecenter")
	arg0_3.faceBookBtn = arg0_3._tf:Find("page1/bind_facebook")
	arg0_3.phoneBtn = arg0_3._tf:Find("page1/bind_phone")
	arg0_3.appleBtn = arg0_3._tf:Find("page1/bind_apple")

	setActive(arg0_3.appleBtn, true)

	local var0_3 = {
		arg0_3.faceBookBtn,
		arg0_3.googleBtn,
		arg0_3.phoneBtn,
		arg0_3.gamecenterBtn,
		arg0_3.appleBtn
	}
	local var1_3 = pg.SdkMgr.GetInstance()
	local var2_3 = var1_3:IsBindFaceBook()
	local var3_3 = var1_3:IsBindGoogle()
	local var4_3 = var1_3:IsBindPhone()
	local var5_3 = var1_3:IsBindGameCenter()
	local var6_3 = var1_3:IsBindApple()
	local var7_3 = {
		var2_3,
		var3_3,
		var4_3,
		var5_3,
		var6_3
	}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var8_3 = var7_3[iter0_3]

		setActive(iter1_3:Find("unbind"), not var8_3)
		setActive(iter1_3:Find("bind"), var8_3)
		onButton(arg0_3, iter1_3, function()
			if not var8_3 then
				var1_3:BindSocial(iter0_3)
			end
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdate(arg0_5)
	if PLATFORM == PLATFORM_ANDROID then
		setActive(arg0_5.googleBtn, true)
		setActive(arg0_5.gamecenterBtn, false)
	else
		setActive(arg0_5.googleBtn, true)
		setActive(arg0_5.gamecenterBtn, false)
	end
end

return var0_0
