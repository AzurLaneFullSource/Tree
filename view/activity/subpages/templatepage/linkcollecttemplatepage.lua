local var0_0 = class("LinkCollectTemplatePage", import("view.base.BaseActivityPage"))

var0_0.DropType2Name = {
	[DROP_TYPE_EQUIP] = "equip",
	[DROP_TYPE_FURNITURE] = "furniture",
	[DROP_TYPE_EQUIPMENT_SKIN] = "equip_skin",
	[DROP_TYPE_SPWEAPON] = "special_weapon"
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
	arg0_1.itemPanel = arg0_1:findTF("item_panel", arg0_1.bg)
	arg0_1.togglesTF = arg0_1:findTF("toggles", arg0_1.itemPanel)
	arg0_1.content = arg0_1:findTF("item_list/content", arg0_1.itemPanel)
	arg0_1.itemList = UIItemList.New(arg0_1.content, arg0_1:findTF("tpl", arg0_1.content))

	setText(arg0_1:findTF("tpl/owner/title", arg0_1.content), i18n("collect_page_got"))
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.guideConfig = pg.activity_limit_item_guide

	arg0_2:BuildDatas()
end

function var0_0.BuildDatas(arg0_3)
	local var0_3 = pg.activity_limit_item_guide.get_id_list_by_activity[arg0_3.activity.id]

	assert(var0_3, "activity_limit_item_guide not exist activity id: " .. arg0_3.activity.id)

	arg0_3.dataList = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = {
			id = iter1_3
		}

		var1_3.config = arg0_3.guideConfig[var1_3.id]
		var1_3.count = arg0_3.activity:getKVPList(1, var1_3.id)

		if var1_3.config.count_storage == 1 then
			var1_3.count = Drop.New({
				type = var1_3.config.type,
				id = var1_3.config.drop_id
			}):getOwnedCount()
		end

		table.insert(arg0_3.dataList, var1_3)
	end
end

function var0_0.GetTogglesDropTypes(arg0_4)
	return {
		DROP_TYPE_EQUIP,
		DROP_TYPE_FURNITURE,
		DROP_TYPE_EQUIPMENT_SKIN,
		DROP_TYPE_SPWEAPON
	}
end

function var0_0.OnFirstFlush(arg0_5)
	arg0_5.itemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_5:OnUpdateItem(arg1_6, arg2_6)
		end
	end)
	arg0_5:AddTogglesListener()
	arg0_5:AddSpecialBtnListener()

	arg0_5.curPage = arg0_5.curPage or arg0_5:GetTogglesDropTypes()[1]

	triggerToggle(arg0_5.toggles[arg0_5.curPage], true)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7:BuildDatas()
	arg0_7:UpdatePage(arg0_7.curPage)
end

function var0_0.AddTogglesListener(arg0_8)
	arg0_8.toggles = {}

	local var0_8 = arg0_8:GetTogglesDropTypes()

	assert(#var0_8 == arg0_8.togglesTF.childCount, "dropType数量与togglesTF子节点数不匹配")

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var1_8 = arg0_8:findTF(var0_0.DropType2Name[iter1_8], arg0_8.togglesTF)

		onToggle(arg0_8, var1_8, function(arg0_9)
			if arg0_9 then
				arg0_8:UpdatePage(iter1_8)
			end
		end, SFX_PANEL)

		arg0_8.toggles[iter1_8] = var1_8
	end
end

function var0_0.AddSpecialBtnListener(arg0_10)
	local var0_10 = arg0_10.activity:getConfig("config_client")

	arg0_10.furnitureThemeBtn = arg0_10:findTF("furniture_theme", arg0_10.btnList)

	if arg0_10.furnitureThemeBtn and var0_10.furniture_theme_link then
		onButton(arg0_10, arg0_10.furnitureThemeBtn, function()
			arg0_10:DoSkip(var0_10.furniture_theme_link[1], var0_10.furniture_theme_link[2])
		end, SFX_PANEL)
	end

	arg0_10.medalBtn = arg0_10:findTF("medal", arg0_10.btnList)

	if arg0_10.medalBtn and var0_10.medal_link then
		onButton(arg0_10, arg0_10.medalBtn, function()
			arg0_10:DoSkip(var0_10.medal_link[1], var0_10.medal_link[2])
		end, SFX_PANEL)
	end

	arg0_10.equipSkinBoxBtn = arg0_10:findTF("equip_skin_box", arg0_10.btnList)

	if arg0_10.equipSkinBoxBtn and var0_10.equipskin_box_link then
		local var1_10 = Drop.New({
			type = var0_10.equipskin_box_link.drop_type,
			id = var0_10.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0_10, arg0_10.equipSkinBoxBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
				show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
				drop_type = var0_10.equipskin_box_link.drop_type,
				drop_id = var0_10.equipskin_box_link.drop_id,
				count = var1_10,
				skipable_list = var0_10.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.showDataList[arg1_14 + 1]
	local var1_14 = arg0_14:findTF("icon_mask/icon", arg2_14)
	local var2_14 = {
		type = var0_14.config.type,
		id = var0_14.config.drop_id
	}

	updateDrop(var1_14, var2_14)
	onButton(arg0_14, var1_14, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_14.config.type,
			drop_id = var0_14.config.drop_id,
			count = var0_14.count,
			count_limit = var0_14.config.count,
			skipable_list = var0_14.config.link_params
		})
	end, SFX_PANEL)
	changeToScrollText(arg0_14:findTF("name_mask/name", arg2_14), Drop.New({
		type = var0_14.config.type,
		id = var0_14.config.drop_id
	}):getName())
	setText(arg0_14:findTF("owner/number", arg2_14), var0_14.count .. "/" .. var0_14.config.count)

	GetOrAddComponent(arg0_14:findTF("owner", arg2_14), typeof(CanvasGroup)).alpha = var0_14.count == var0_14.config.count and 0.5 or 1

	setActive(arg0_14:findTF("got", arg2_14), var0_14.count == var0_14.config.count)
	setActive(arg0_14:findTF("new", arg2_14), var0_14.config.is_new == "1")
end

function var0_0.UpdatePage(arg0_16, arg1_16)
	arg0_16.curPage = arg1_16
	arg0_16.showDataList = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.dataList) do
		if arg0_16.guideConfig[iter1_16.id].type == arg1_16 then
			table.insert(arg0_16.showDataList, iter1_16)
		end
	end

	table.sort(arg0_16.showDataList, CompareFuncs({
		function(arg0_17)
			return arg0_17.count < arg0_17.config.count and 0 or 1
		end,
		function(arg0_18)
			return arg0_18.config.order
		end,
		function(arg0_19)
			return arg0_19.id
		end
	}))
	arg0_16.itemList:align(#arg0_16.showDataList)
end

function var0_0.DoSkip(arg0_20, arg1_20, arg2_20)
	if arg1_20 == 2 then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2_20[1], arg2_20[2] or {})
	elseif arg1_20 == 3 then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2_20
		})
	end
end

return var0_0
