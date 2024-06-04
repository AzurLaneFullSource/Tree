local var0 = class("PtAwardWindow")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0.binder = arg2
	arg0.scrollPanel = arg0._tf:Find("window/panel")
	arg0.UIlist = UIItemList.New(arg0._tf:Find("window/panel/list"), arg0._tf:Find("window/panel/list/item"))
	arg0.ptTF = arg0._tf:Find("window/pt")
	arg0.totalTxt = arg0._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	arg0.totalTitleTxt = arg0._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	arg0.totalTitleIcon = arg0._tf:Find("window/pt/icon/image"):GetComponent(typeof(Image))
	arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
	arg0.ptIcon = arg0._tf:Find("window/pt/icon")

	onButton(arg0.binder, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0.binder, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.UpdateList(arg0, arg1, arg2, arg3, arg4)
	assert(#arg1 == #arg2)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = arg2[arg1 + 1]
			local var2 = GetPerceptualSize(arg0.resTitle)

			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
			setText(arg2:Find("target/Text"), var1)

			if arg2:Find("target/icon") then
				if arg0.resIcon == "" then
					arg0.resIcon = nil
				end

				if arg0.resIcon then
					LoadImageSpriteAsync(arg0.resIcon, arg2:Find("target/icon"), false)
				end

				setActive(arg2:Find("target/icon"), arg0.resIcon)
				setActive(arg2:Find("target/mark"), arg0.resIcon)
			end

			setText(arg2:Find("target/title"), arg0.resTitle)

			local var3 = Drop.Create(var0)

			updateDrop(arg2:Find("award"), var3, {
				hideName = true
			})
			onButton(arg0.binder, arg2:Find("award"), function()
				arg0.binder:emit(BaseUI.ON_DROP, var3)
			end, SFX_PANEL)
			setActive(arg2:Find("award/mask"), arg1 + 1 <= arg3)

			if not IsNil(arg2:Find("mask")) then
				if arg4 then
					local var4 = pg.TimeMgr.GetInstance()
					local var5 = arg4[arg1 + 1]

					setActive(arg2:Find("mask"), var5 > var4:GetServerTime())

					local var6 = var4:STimeDescS(var5, "%m")
					local var7 = var4:STimeDescS(var5, "%d")

					setText(arg2:Find("mask/Text"), i18n("unlock_date_tip", var6, var7))
				else
					setActive(arg2:Find("mask"), false)
				end
			end
		end
	end)
	arg0.UIlist:align(#arg1)
	scrollTo(arg0.scrollPanel, 0, 1 - arg3 * 166 / (#arg2 * 166 + 20 - 570))
end

function var0.Show(arg0, arg1)
	local var0 = arg1.dropList
	local var1 = arg1.targets
	local var2 = arg1.level
	local var3 = arg1.count
	local var4 = arg1.resId
	local var5 = arg1.type
	local var6 = arg1.unlockStamps

	arg0.resIcon = nil

	arg0:UpdateTitle(var5)
	arg0:updateResIcon(arg1.resId, arg1.resIcon, arg1.type)
	arg0:UpdateList(var0, var1, var2, var6)

	arg0.totalTxt.text = var3
	arg0.totalTitleTxt.text = arg0.cntTitle

	Canvas.ForceUpdateCanvases()
	setActive(arg0._tf, true)
end

function var0.UpdateTitle(arg0, arg1)
	local var0 = ""

	if arg1 == 2 then
		arg0.resTitle, arg0.cntTitle = i18n("pt_cosume", var0), i18n("pt_total_count", i18n("pt_cosume", var0))
		arg0.cntTitle = string.gsub(arg0.cntTitle, "：", "")
	elseif arg1 == 3 then
		arg0.resTitle, arg0.cntTitle = i18n("pt_ship_goal"), i18n("pt_ship_now")
	elseif arg1 == 4 then
		arg0.resTitle, arg0.cntTitle = i18n("cumulative_victory_target_tip"), i18n("cumulative_victory_now_tip")
	elseif arg1 == 5 then
		arg0.resTitle, arg0.cntTitle = i18n("npcfriendly_count"), i18n("npcfriendly_total_count")
	elseif arg1 == 6 then
		arg0.resTitle, arg0.cntTitle = i18n("activity_yanhua_tip2"), i18n("activity_yanhua_tip3")
	else
		arg0.resTitle, arg0.cntTitle = i18n("target_get_tip"), i18n("pt_total_count", var0)
		arg0.cntTitle = string.gsub(arg0.cntTitle, "：", "")
	end
end

function var0.updateResIcon(arg0, arg1, arg2, arg3)
	if arg3 == 2 or arg3 ~= 3 and arg3 ~= 4 and arg3 ~= 5 and arg3 ~= 6 then
		if arg1 then
			arg0.resIcon = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg1
			}):getIcon()
		elseif arg2 then
			arg0.resIcon = arg2
		end

		if arg0.ptIcon and arg0.resIcon and arg0.resIcon ~= "" then
			setActive(arg0.ptIcon, true)
			LoadImageSpriteAsync(arg0.resIcon, arg0.totalTitleIcon, false)
		else
			setActive(arg0.ptIcon, false)
		end
	end
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)
end

function var0.Dispose(arg0)
	arg0:Hide()
	removeOnButton(arg0._tf)
	removeOnButton(arg0.closeBtn)
end

return var0
