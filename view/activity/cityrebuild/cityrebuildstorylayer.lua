local var0_0 = class("CityRebuildStoryLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CityRebuildStoryUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.closeBtn = arg0_2._tf:Find("panel/closeBtn")
	arg0_2.storyList = UIItemList.New(arg0_2._tf:Find("panel/storyScroll/Viewport/Content"), arg0_2._tf:Find("panel/storyScroll/Viewport/Content/story"))

	setText(arg0_2._tf:Find("panel/desc"), i18n("ninja_game_storydialog"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3:Refresh()
end

function var0_0.InitData(arg0_6)
	arg0_6.activityId = ActivityConst.NINJA_CITY_ACT_ID
	arg0_6.cityRebuildProxy = getProxy(CityRebuildProxy)
	arg0_6.cityRebuildData = arg0_6.cityRebuildProxy:GetData(arg0_6.activityId)
	arg0_6.ids = {}
	arg0_6.storyCfgs = {}

	for iter0_6, iter1_6 in ipairs(pg.activity_ninja_building.all) do
		local var0_6 = pg.activity_ninja_building[iter1_6]

		if var0_6.story ~= "" then
			table.insert(arg0_6.ids, iter1_6)
			table.insert(arg0_6.storyCfgs, var0_6.story)
		end
	end
end

function var0_0.Refresh(arg0_7)
	arg0_7.storyList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_7.ids[arg1_8 + 1]
			local var1_8 = arg0_7.storyCfgs[arg1_8 + 1]
			local var2_8 = arg0_7.cityRebuildData:IsRepairedOrRecruited(var0_8)

			setActive(arg2_8:Find("normal"), var2_8)
			setActive(arg2_8:Find("lock"), not var2_8)

			if var2_8 then
				GetImageSpriteFromAtlasAsync(var1_8[6], "", arg2_8:Find("normal/mask/pic"))
				setScrollText(arg2_8:Find("normal/nameBg/name"), var1_8[5])
				onButton(arg0_7, arg2_8, function()
					pg.NewStoryMgr.GetInstance():Play(var1_8[1], nil, true)
				end, SFX_PANEL)
			else
				setScrollText(arg2_8:Find("lock/mask/Text"), var1_8[4])
			end
		end
	end)
	arg0_7.storyList:align(#arg0_7.storyCfgs)
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf)
end

return var0_0
