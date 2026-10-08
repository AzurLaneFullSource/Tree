local var0_0 = class("PtAwardWindow")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.binder = arg2_1
	arg0_1.scrollPanel = arg0_1._tf:Find("window/panel")
	arg0_1.UIlist = UIItemList.New(arg0_1._tf:Find("window/panel/list"), arg0_1._tf:Find("window/panel/list/item"))
	arg0_1.ptTF = arg0_1._tf:Find("window/pt")
	arg0_1.totalTxt = arg0_1._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	arg0_1.totalTitleTxt = arg0_1._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	arg0_1.totalTitleIcon = arg0_1._tf:Find("window/pt/icon/image"):GetComponent(typeof(Image))
	arg0_1.closeBtn = arg0_1._tf:Find("window/top/btnBack")
	arg0_1.ptIcon = arg0_1._tf:Find("window/pt/icon")

	onButton(arg0_1.binder, arg0_1._tf, function()
		arg0_1:Hide()
	end, SFX_PANEL)
	onButton(arg0_1.binder, arg0_1.closeBtn, function()
		arg0_1:Hide()
	end, SFX_PANEL)
end

function var0_0.UpdateList(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	assert(#arg1_4 == #arg2_4)
	arg0_4.UIlist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_4[arg1_5 + 1]
			local var1_5 = arg2_4[arg1_5 + 1]
			local var2_5 = GetPerceptualSize(arg0_4.resTitle)

			setText(arg2_5:Find("title/Text"), "PHASE " .. arg1_5 + 1)
			setText(arg2_5:Find("target/Text"), var1_5)

			if arg2_5:Find("target/icon") then
				if arg0_4.resIcon == "" then
					arg0_4.resIcon = nil
				end

				if arg0_4.resIcon then
					LoadImageSpriteAsync(arg0_4.resIcon, arg2_5:Find("target/icon"), false)
				end

				setActive(arg2_5:Find("target/icon"), arg0_4.resIcon)
				setActive(arg2_5:Find("target/mark"), arg0_4.resIcon)
			end

			setText(arg2_5:Find("target/title"), arg0_4.resTitle)

			local var3_5 = Drop.Create(var0_5)

			updateDrop(arg2_5:Find("award"), var3_5, {
				hideName = true
			})
			onButton(arg0_4.binder, arg2_5:Find("award"), function()
				arg0_4.binder:emit(BaseUI.ON_DROP, var3_5)
			end, SFX_PANEL)
			setActive(arg2_5:Find("award/mask"), arg1_5 + 1 <= arg3_4)

			if not IsNil(arg2_5:Find("mask")) then
				if arg4_4 then
					local var4_5 = pg.TimeMgr.GetInstance()
					local var5_5 = arg4_4[arg1_5 + 1]

					setActive(arg2_5:Find("mask"), var5_5 > var4_5:GetServerTime())

					local var6_5 = var4_5:STimeDescS(var5_5, "%m")
					local var7_5 = var4_5:STimeDescS(var5_5, "%d")

					setText(arg2_5:Find("mask/Text"), i18n("unlock_date_tip", var6_5, var7_5))
				else
					setActive(arg2_5:Find("mask"), false)
				end
			end
		end
	end)
	arg0_4.UIlist:align(#arg1_4)
	scrollTo(arg0_4.scrollPanel, 0, 1 - arg3_4 * 166 / (#arg2_4 * 166 + 20 - 570))
end

function var0_0.Show(arg0_7, arg1_7)
	local var0_7 = arg1_7.dropList
	local var1_7 = arg1_7.targets
	local var2_7 = arg1_7.level
	local var3_7 = arg1_7.count
	local var4_7 = arg1_7.resDrop
	local var5_7 = arg1_7.type

	arg0_7.blur = arg1_7.blur

	local var6_7 = arg1_7.unlockStamps

	arg0_7.resIcon = nil

	arg0_7:UpdateTitle(var5_7)
	arg0_7:updateResIcon(arg1_7.resDrop, arg1_7.type)
	arg0_7:UpdateList(var0_7, var1_7, var2_7, var6_7)

	arg0_7.totalTxt.text = var3_7
	arg0_7.totalTitleTxt.text = arg0_7.cntTitle

	Canvas.ForceUpdateCanvases()
	setActive(arg0_7._tf, true)

	if arg0_7.blur then
		pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	end
end

function var0_0.UpdateTitle(arg0_8, arg1_8)
	local var0_8 = ""

	switch(arg1_8, {
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("target_get_tip"), i18n("pt_total_count", var0_8)
			arg0_8.cntTitle = string.gsub(arg0_8.cntTitle, "：", "")
		end,
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("pt_cosume", var0_8), i18n("pt_total_count", i18n("pt_cosume", var0_8))
			arg0_8.cntTitle = string.gsub(arg0_8.cntTitle, "：", "")
		end,
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("pt_ship_goal"), i18n("pt_ship_now")
		end,
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("cumulative_victory_target_tip"), i18n("cumulative_victory_now_tip")
		end,
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("npcfriendly_count"), i18n("npcfriendly_total_count")
		end,
		function()
			arg0_8.resTitle, arg0_8.cntTitle = i18n("activity_yanhua_tip2"), i18n("activity_yanhua_tip3")
		end,
		[9] = 2,
		[8] = 1
	}, function()
		arg0_8.resTitle, arg0_8.cntTitle = i18n("target_get_tip"), i18n("pt_total_count", var0_8)
		arg0_8.cntTitle = string.gsub(arg0_8.cntTitle, "：", "")
	end)
end

local var1_0 = {
	nil,
	true,
	false,
	false,
	false,
	false
}

function var0_0.updateResIcon(arg0_16, arg1_16, arg2_16)
	if defaultValue(var1_0[arg2_16], true) then
		arg0_16.resIcon = arg1_16:getIcon()
	end

	setActive(arg0_16.ptIcon, arg0_16.resIcon)

	if arg0_16.resIcon then
		LoadImageSpriteAsync(arg0_16.resIcon, arg0_16.totalTitleIcon, false)
	end
end

function var0_0.Hide(arg0_17)
	if arg0_17.blur then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf)
	end

	setActive(arg0_17._tf, false)
end

function var0_0.Dispose(arg0_18)
	arg0_18:Hide()
	removeOnButton(arg0_18._tf)
	removeOnButton(arg0_18.closeBtn)
end

return var0_0
