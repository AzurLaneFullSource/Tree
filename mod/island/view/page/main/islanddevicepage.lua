local var0_0 = class("IslandDevicePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandDeviceUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.systemTimeUtil = LocalSystemTimeUtil.New()
	arg0_2.timeTxt = arg0_2._tf:Find("panel/time"):GetComponent(typeof(Text))
	arg0_2.timeEnTxt = arg0_2._tf:Find("panel/time/time_en"):GetComponent(typeof(Text))
	arg0_2.batteryTxt = arg0_2._tf:Find("panel/battery/Text"):GetComponent(typeof(Text))
	arg0_2.electric = {
		arg0_2._tf:Find("panel/battery/kwh/1"),
		arg0_2._tf:Find("panel/battery/kwh/2"),
		arg0_2._tf:Find("panel/battery/kwh/3")
	}
	arg0_2.btnContainer = arg0_2._tf:Find("panel/content")
	arg0_2.btnUIList = UIItemList.New(arg0_2.btnContainer, arg0_2.btnContainer:Find("tpl"))

	local var0_2 = arg0_2._tf:Find("panel/banner")

	arg0_2.scrollSnap = BannerScrollRect4Mellow.New(var0_2:Find("mask/content"), var0_2:Find("dots"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("panel/exit"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_3:InitBtns()
	arg0_3:InitBanner()
end

function var0_0.InitBtns(arg0_6)
	arg0_6.btnUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			local var0_7 = arg0_6.btnList[arg1_7 + 1]
			local var1_7 = pg.island_main_btns[var0_7]

			arg2_7.name = var1_7.btn_name

			setText(arg2_7:Find("Text"), var1_7.name)
			LoadImageSpriteAsync("islandbtnicon/" .. var1_7.icon, arg2_7:Find("icon"), true)
		elseif arg0_7 == UIItemList.EventUpdate then
			local var2_7 = arg0_6.btnList[arg1_7 + 1]
			local var3_7 = pg.island_main_btns[var2_7]
			local var4_7 = var3_7.ability_id ~= 0 and getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var3_7.ability_id)

			setActive(arg2_7:Find("lock"), var4_7)
			onButton(arg0_6, arg2_7:Find("lock"), function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_lock"))
			end, SFX_PANEL)

			if var3_7.open_page ~= "" then
				onButton(arg0_6, arg2_7:Find("icon"), function()
					arg0_6:OpenPage(_G[var3_7.open_page], unpack(var3_7.page_param))
				end, SFX_PANEL)
			end
		end
	end)

	arg0_6.btnList = pg.island_main_btns.get_id_list_by_main_type[2]
end

function var0_0.InitBanner(arg0_10)
	local var0_10 = arg0_10:GetBannerDisplays()

	arg0_10.banners = var0_10

	for iter0_10 = 0, #var0_10 - 1 do
		local var1_10 = var0_10[iter0_10 + 1]
		local var2_10 = arg0_10.scrollSnap:AddChild()

		LoadImageSpriteAsync("islandbanner/" .. var1_10.pic, var2_10)
		onButton(arg0_10, var2_10, function()
			arg0_10:BannerSkip(var1_10)
		end, SFX_MAIN)
	end

	arg0_10.scrollSnap:SetUp()
end

function var0_0.OnShow(arg0_12)
	arg0_12:AddTimer()
	arg0_12:Flush()
	arg0_12:FlushTime()
end

function var0_0.Flush(arg0_13)
	arg0_13.btnUIList:align(#arg0_13.btnList)

	local var0_13 = arg0_13:GetBannerDisplays()

	if #arg0_13.banners ~= #var0_13 then
		arg0_13.scrollSnap:Reset()
		arg0_13:InitBanner()
	else
		arg0_13.scrollSnap:Resume()
	end
end

function var0_0.FlushBattery(arg0_14)
	local var0_14 = SystemInfo.batteryLevel

	if var0_14 < 0 then
		var0_14 = 1
	end

	local var1_14 = math.floor(var0_14 * 100)

	arg0_14.batteryTxt.text = var1_14 .. "%"

	local var2_14 = 1 / #arg0_14.electric

	for iter0_14, iter1_14 in ipairs(arg0_14.electric) do
		local var3_14 = var1_14 < (iter0_14 - 1) * var2_14

		setActive(iter1_14, not var3_14)
	end
end

function var0_0.FlushTime(arg0_15)
	arg0_15.systemTimeUtil:SetUp(function(arg0_16, arg1_16, arg2_16)
		if SettingsMainScenePanel.IsEnable24HourSystem() then
			arg0_15.timeEnTxt.color = Color.New(1, 1, 1, 0)
		else
			arg0_15.timeEnTxt.color = Color.New(1, 1, 1, 1)
			arg0_16 = arg0_16 > 12 and arg0_16 - 12 or arg0_16
		end

		if arg0_16 < 10 then
			arg0_16 = "0" .. arg0_16
		end

		arg0_15.timeTxt.text = arg0_16 .. ":" .. arg1_16
		arg0_15.timeEnTxt.text = arg2_16
	end)
end

function var0_0.AddTimer(arg0_17)
	arg0_17:RemoveTimer()

	arg0_17.timer = Timer.New(function()
		arg0_17:FlushBattery()
	end, 60, -1)

	arg0_17.timer:Start()
end

function var0_0.RemoveTimer(arg0_19)
	if arg0_19.timer then
		arg0_19.timer:Stop()

		arg0_19.timer = nil
	end
end

function var0_0.OnHide(arg0_20)
	arg0_20:RemoveTimer()
end

function var0_0.OnDestroy(arg0_21)
	arg0_21.systemTimeUtil:Dispose()

	arg0_21.systemTimeUtil = nil

	arg0_21.scrollSnap:Dispose()

	arg0_21.scrollSnap = nil
end

function var0_0.GetBannerDisplays(arg0_22)
	return underscore(pg.island_banner.all):chain():map(function(arg0_23)
		return pg.island_banner[arg0_23]
	end):select(function(arg0_24)
		return pg.TimeMgr.GetInstance():inTime(arg0_24.time)
	end):value()
end

function var0_0.BannerSkip(arg0_25, arg1_25)
	if arg1_25.type == IslandConst.BANNER_TYPE_OPEN_URL then
		Application.OpenURL(arg1_25.param)
	elseif arg1_25.type == IslandConst.BANNER_TYPE_SWITCH_MAP then
		arg0_25:Hide()
		arg0_25:emit(IslandMediator.SWITCH_MAP, unpack(arg1_25.param))
	elseif arg1_25.type == IslandConst.BANNER_TYPE_OPEN_PAGE then
		arg0_25:OpenPage(_G[arg1_25.param[1]], arg1_25.param[2] and unpack(arg1_25.param[2]))
	end
end

return var0_0
