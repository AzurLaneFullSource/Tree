local var0_0 = class("EquipmentDesignObtainWayPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = {
	[var1_0] = i18n("equipment_design_chapter"),
	[var2_0] = i18n("equipment_design_tech"),
	[var3_0] = i18n("equipment_design_shop")
}

function var0_0.getUIName(arg0_1)
	return "EquipmentDesignObtainWayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dropTF = arg0_2._tf:Find("main_page/item/left/IconTpl")
	arg0_2.nameTxt = arg0_2._tf:Find("main_page/item/name_container/name/Text")
	arg0_2.descTxt = arg0_2._tf:Find("main_page/item/Text")
	arg0_2.closeBtn = arg0_2._tf:Find("main_page/top/btnBack")
	arg0_2.uiWayList = UIItemList.New(arg0_2._tf:Find("main_page/obtainWay/list/content"), arg0_2._tf:Find("main_page/obtainWay/list/content/tpl"))
	arg0_2.uiChapterWayList = UIItemList.New(arg0_2._tf:Find("sub_page/list/content"), arg0_2._tf:Find("sub_page/list/content/tpl"))

	setText(arg0_2._tf:Find("main_page/obtainWay/list/content/tpl/expand/Text"), i18n("equipment_design_btn_expand"))
	setText(arg0_2._tf:Find("main_page/obtainWay/list/content/tpl/fold/Text"), i18n("equipment_design_btn_fold"))
	setText(arg0_2._tf:Find("main_page/obtainWay/list/content/tpl/skip/Text"), i18n("equipment_design_btn_skip"))
	setText(arg0_2._tf:Find("sub_page/list/content/tpl/skip_btn/Text"), i18n("equipment_design_btn_skip"))
	setText(arg0_2._tf:Find("main_page/obtainWay/title"), i18n("equipment_design_sub_title"))
	setText(arg0_2._tf:Find("main_page/top/bg/infomation/title"), i18n("words_information"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.isOpenSubPage = false
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.designId = arg1_6

	local var0_6 = arg0_6:GetObtainWayData(arg1_6)

	arg0_6:UpdateObtainWay(var0_6)
	arg0_6:UpdateEquipmentDesignInfo(arg1_6)
	arg0_6:ResetSubPage()
	arg0_6:BlurPanel(arg0_6._tf)
end

function var0_0.UpdateEquipmentDesignInfo(arg0_7, arg1_7)
	local var0_7 = pg.compose_data_template[arg1_7]
	local var1_7 = Item.New({
		count = 0,
		id = var0_7.material_id
	})

	setText(arg0_7.nameTxt, HXSet.hxLan(shortenString(var1_7:getConfig("name"), 12)))
	setText(arg0_7.descTxt, HXSet.hxLan(var1_7:getConfig("display")))
	updateItem(arg0_7.dropTF, var1_7)
	setActive(arg0_7.dropTF:Find("icon_bg/count"), false)
end

function var0_0.ResetSubPage(arg0_8)
	arg0_8.animationPlayer:Stop()
	arg0_8.animationPlayer:Play("reset_sub_page")

	arg0_8.isOpenSubPage = false
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)
	arg0_9:ResetSubPage()
	arg0_9:UnOverlayPanel(arg0_9._tf, arg0_9._parentTf)
end

function var0_0.GetObtainWayData(arg0_10, arg1_10)
	local var0_10 = getProxy(EquipmentProxy):GetObtainWay4EquipmentDesign(arg1_10)
	local var1_10 = var0_10[1]
	local var2_10 = var0_10[2]
	local var3_10 = var0_10[3]
	local var4_10 = {}

	if var2_10 then
		table.insert(var4_10, var2_0)
	end

	if var3_10 then
		table.insert(var4_10, var3_0)
	end

	if #var1_10 > 0 then
		table.insert(var4_10, 1, var1_0)
	end

	return var4_10
end

function var0_0.UpdateObtainWay(arg0_11, arg1_11)
	arg0_11.uiWayList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg1_11[arg1_12 + 1]

			arg0_11:UpdateWayTpl(arg2_12, var0_12)
		end
	end)
	arg0_11.uiWayList:align(#arg1_11)
end

function var0_0.UpdateWayTpl(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13:Find("expand")
	local var1_13 = arg1_13:Find("fold")
	local var2_13 = arg1_13:Find("skip")
	local var3_13 = arg1_13:Find("title")

	local function var4_13()
		setActive(var0_13, arg2_13 == var1_0 and not arg0_13.isOpenSubPage)
		setActive(var1_13, arg2_13 == var1_0 and arg0_13.isOpenSubPage)
		setActive(var2_13, arg2_13 == var2_0 or arg2_13 == var3_0)
	end

	onButton(arg0_13, var0_13, function()
		arg0_13.animationPlayer:Stop()
		arg0_13.animationPlayer:Play("open_sub_page")
		arg0_13:UpdateChapterWays()

		arg0_13.isOpenSubPage = true

		var4_13()
	end, SFX_PANEL)
	onButton(arg0_13, var1_13, function()
		arg0_13.animationPlayer:Stop()
		arg0_13.animationPlayer:Play("close_sub_page")

		arg0_13.isOpenSubPage = false

		var4_13()
	end, SFX_PANEL)
	var4_13()
	onButton(arg0_13, var2_13, function()
		if arg2_13 == var2_0 then
			arg0_13:GoTechScene()
		elseif arg2_13 == var3_0 then
			arg0_13:GoShopScene()
		end
	end, SFX_PANEL)
	setText(var3_13, var4_0[arg2_13])
end

function var0_0.UpdateChapterWays(arg0_18)
	local var0_18 = getProxy(EquipmentProxy):GetObtainWay4EquipmentDesign(arg0_18.designId)[1]

	arg0_18.uiChapterWayList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]
			local var1_19 = pg.chapter_template[var0_19]

			setScrollText(arg2_19:Find("mask/Text"), i18n("equipment_design_chapter") .. ":" .. var1_19.name)
			onButton(arg0_18, arg2_19:Find("skip_btn"), function()
				arg0_18:GoChapterScene(var0_19)
			end, SFX_PANEL)
		end
	end)
	arg0_18.uiChapterWayList:align(#var0_18)
end

function var0_0.GoChapterScene(arg0_21, arg1_21)
	local var0_21 = pg.chapter_template[arg1_21]

	if var0_21.act_id ~= 0 and var0_21.act_id ~= 100001 then
		local var1_21 = getProxy(ActivityProxy):RawGetActivityById(var0_21.act_id)

		if not var1_21 or var1_21:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		local var2_21, var3_21 = chapterProxy:getLastMapForActivity()

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var3_21,
			mapIdx = var2_21
		})

		return
	end

	local var4_21 = getProxy(ChapterProxy):getChapterById(arg1_21)

	if not var4_21 or not var4_21:isUnlock() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))

		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
		chapterId = arg1_21,
		mapIdx = var0_21.map
	})
end

function var0_0.GoTechScene(arg0_22)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
end

function var0_0.GoShopScene(arg0_23)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
		warp = ShopConst.TYPE_FRAGMENT,
		type = ShopConst.SHOP_TYPE.SUPPLY
	})
end

function var0_0.OnDestroy(arg0_24)
	if arg0_24:isShowing() then
		arg0_24:Hide()
	end
end

return var0_0
