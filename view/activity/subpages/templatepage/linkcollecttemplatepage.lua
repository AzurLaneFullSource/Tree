local var0 = class("LinkCollectTemplatePage", import("view.base.BaseActivityPage"))

var0.DropType2Name = {
	[DROP_TYPE_EQUIP] = "equip",
	[DROP_TYPE_FURNITURE] = "furniture",
	[DROP_TYPE_EQUIPMENT_SKIN] = "equip_skin",
	[DROP_TYPE_SPWEAPON] = "special_weapon"
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.btnList = arg0:findTF("btn_list", arg0.bg)
	arg0.itemPanel = arg0:findTF("item_panel", arg0.bg)
	arg0.togglesTF = arg0:findTF("toggles", arg0.itemPanel)
	arg0.content = arg0:findTF("item_list/content", arg0.itemPanel)
	arg0.itemList = UIItemList.New(arg0.content, arg0:findTF("tpl", arg0.content))

	setText(arg0:findTF("tpl/owner/title", arg0.content), i18n("collect_page_got"))
end

function var0.OnDataSetting(arg0)
	arg0.guideConfig = pg.activity_limit_item_guide

	arg0:BuildDatas()
end

function var0.BuildDatas(arg0)
	local var0 = pg.activity_limit_item_guide.get_id_list_by_activity[arg0.activity.id]

	assert(var0, "activity_limit_item_guide not exist activity id: " .. arg0.activity.id)

	arg0.dataList = {}

	for iter0, iter1 in ipairs(var0) do
		local var1 = {
			id = iter1
		}

		var1.config = arg0.guideConfig[var1.id]
		var1.count = arg0.activity:getKVPList(1, var1.id)

		if var1.config.count_storage == 1 then
			var1.count = Drop.New({
				type = var1.config.type,
				id = var1.config.drop_id
			}):getOwnedCount()
		end

		table.insert(arg0.dataList, var1)
	end
end

function var0.GetTogglesDropTypes(arg0)
	return {
		DROP_TYPE_EQUIP,
		DROP_TYPE_FURNITURE,
		DROP_TYPE_EQUIPMENT_SKIN,
		DROP_TYPE_SPWEAPON
	}
end

function var0.OnFirstFlush(arg0)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:OnUpdateItem(arg1, arg2)
		end
	end)
	arg0:AddTogglesListener()
	arg0:AddSpecialBtnListener()

	arg0.curPage = arg0.curPage or arg0:GetTogglesDropTypes()[1]

	triggerToggle(arg0.toggles[arg0.curPage], true)
end

function var0.OnUpdateFlush(arg0)
	arg0:BuildDatas()
	arg0:UpdatePage(arg0.curPage)
end

function var0.AddTogglesListener(arg0)
	arg0.toggles = {}

	local var0 = arg0:GetTogglesDropTypes()

	assert(#var0 == arg0.togglesTF.childCount, "dropType数量与togglesTF子节点数不匹配")

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0:findTF(var0.DropType2Name[iter1], arg0.togglesTF)

		onToggle(arg0, var1, function(arg0)
			if arg0 then
				arg0:UpdatePage(iter1)
			end
		end, SFX_PANEL)

		arg0.toggles[iter1] = var1
	end
end

function var0.AddSpecialBtnListener(arg0)
	local var0 = arg0.activity:getConfig("config_client")

	arg0.furnitureThemeBtn = arg0:findTF("furniture_theme", arg0.btnList)

	if arg0.furnitureThemeBtn and var0.furniture_theme_link then
		onButton(arg0, arg0.furnitureThemeBtn, function()
			arg0:DoSkip(var0.furniture_theme_link[1], var0.furniture_theme_link[2])
		end, SFX_PANEL)
	end

	arg0.medalBtn = arg0:findTF("medal", arg0.btnList)

	if arg0.medalBtn and var0.medal_link then
		onButton(arg0, arg0.medalBtn, function()
			arg0:DoSkip(var0.medal_link[1], var0.medal_link[2])
		end, SFX_PANEL)
	end

	arg0.equipSkinBoxBtn = arg0:findTF("equip_skin_box", arg0.btnList)

	if arg0.equipSkinBoxBtn and var0.equipskin_box_link then
		local var1 = Drop.New({
			type = var0.equipskin_box_link.drop_type,
			id = var0.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0, arg0.equipSkinBoxBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
				show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
				drop_type = var0.equipskin_box_link.drop_type,
				drop_id = var0.equipskin_box_link.drop_id,
				count = var1,
				skipable_list = var0.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.showDataList[arg1 + 1]
	local var1 = arg0:findTF("icon_mask/icon", arg2)
	local var2 = {
		type = var0.config.type,
		id = var0.config.drop_id
	}

	updateDrop(var1, var2)
	onButton(arg0, var1, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0.config.type,
			drop_id = var0.config.drop_id,
			count = var0.count,
			count_limit = var0.config.count,
			skipable_list = var0.config.link_params
		})
	end, SFX_PANEL)
	changeToScrollText(arg0:findTF("name_mask/name", arg2), Drop.New({
		type = var0.config.type,
		id = var0.config.drop_id
	}):getName())
	setText(arg0:findTF("owner/number", arg2), var0.count .. "/" .. var0.config.count)

	GetOrAddComponent(arg0:findTF("owner", arg2), typeof(CanvasGroup)).alpha = var0.count == var0.config.count and 0.5 or 1

	setActive(arg0:findTF("got", arg2), var0.count == var0.config.count)
	setActive(arg0:findTF("new", arg2), var0.config.is_new == "1")
end

function var0.UpdatePage(arg0, arg1)
	arg0.curPage = arg1
	arg0.showDataList = {}

	for iter0, iter1 in ipairs(arg0.dataList) do
		if arg0.guideConfig[iter1.id].type == arg1 then
			table.insert(arg0.showDataList, iter1)
		end
	end

	table.sort(arg0.showDataList, CompareFuncs({
		function(arg0)
			return arg0.count < arg0.config.count and 0 or 1
		end,
		function(arg0)
			return arg0.config.order
		end,
		function(arg0)
			return arg0.id
		end
	}))
	arg0.itemList:align(#arg0.showDataList)
end

function var0.DoSkip(arg0, arg1, arg2)
	if arg1 == 2 then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2[1], arg2[2] or {})
	elseif arg1 == 3 then
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2
		})
	end
end

return var0
