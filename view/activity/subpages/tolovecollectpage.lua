local var0_0 = class("ToloveCollectPage", import(".TemplatePage.LinkCollectTemplatePage"))

var0_0.SKIP_TYPE_MINIGAME = 7

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	arg0_1:findUI()
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:rewriteEquipSkinBtn()
end

function var0_0.findUI(arg0_3)
	setImageRaycastTarget(arg0_3:findTF("tpl/Frame", arg0_3.content), false)

	arg0_3.boxTF = arg0_3:findTF("Box")
	arg0_3.boxBG = arg0_3:findTF("BG", arg0_3.boxTF)
	arg0_3.panel = arg0_3:findTF("Panel", arg0_3.boxTF)
	arg0_3.infoTF = arg0_3:findTF("Info", arg0_3.panel)
	arg0_3.boxCloseBtn = arg0_3:findTF("CloseBtn", arg0_3.infoTF)
	arg0_3.boxIconTF = arg0_3:findTF("Icon/Mask/IconTpl", arg0_3.infoTF)
	arg0_3.boxNameText = arg0_3:findTF("NameText", arg0_3.infoTF)
	arg0_3.boxNumTF = arg0_3:findTF("Num", arg0_3.infoTF)
	arg0_3.boxNumTip = arg0_3:findTF("Text", arg0_3.boxNumTF)
	arg0_3.boxNumText = arg0_3:findTF("NumText", arg0_3.boxNumTF)
	arg0_3.boxDescText = arg0_3:findTF("DescText", arg0_3.infoTF)
	arg0_3.boxSrcText = arg0_3:findTF("SrcText", arg0_3.infoTF)

	onButton(arg0_3, arg0_3.boxBG, function()
		arg0_3:showBoxPanel(false)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.boxCloseBtn, function()
		arg0_3:showBoxPanel(false)
	end, SFX_PANEL)

	arg0_3.boxSrcContent = arg0_3:findTF("Content", arg0_3.panel)
	arg0_3.boxSrcTpl = arg0_3:findTF("SrcTpl", arg0_3.boxSrcContent)

	GetComponent(arg0_3:findTF("furniture_theme/Title", arg0_3.btnList), "Image"):SetNativeSize()
	GetComponent(arg0_3:findTF("equip_skin_box/Title", arg0_3.btnList), "Image"):SetNativeSize()
	GetComponent(arg0_3:findTF("medal/Title", arg0_3.btnList), "Image"):SetNativeSize()
end

function var0_0.rewriteEquipSkinBtn(arg0_6)
	onButton(arg0_6, arg0_6.equipSkinBoxBtn, function()
		local var0_7 = arg0_6.activity:getConfig("config_client")
		local var1_7 = Drop.New({
			type = var0_7.equipskin_box_link.drop_type,
			id = var0_7.equipskin_box_link.drop_id
		}):getOwnedCount()
		local var2_7 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL,
			drop_type = var0_7.equipskin_box_link.drop_type,
			drop_id = var0_7.equipskin_box_link.drop_id,
			count = var1_7,
			skipable_list = var0_7.equipskin_box_link.list
		}

		arg0_6:updateBoxPanel(var2_7)
		arg0_6:showBoxPanel(true)
	end, SFX_PANEL)
end

function var0_0.updateBoxPanel(arg0_8, arg1_8)
	local var0_8 = Drop.New({
		type = arg1_8.drop_type,
		id = arg1_8.drop_id
	})

	updateDrop(arg0_8.boxIconTF, var0_8)

	local var1_8 = var0_8.cfg

	changeToScrollText(arg0_8.boxNameText, var1_8.name)
	setText(arg0_8.boxDescText, SwitchSpecialChar(var0_8.desc))
	setText(arg0_8.boxNumTip, i18n("word_own1"))

	if arg1_8.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_NORMAL then
		setText(arg0_8.boxNumText, arg1_8.count)
	elseif arg1_8.show_type == Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT then
		setText(arg0_8.boxNumText, arg1_8.count .. "/" .. (arg1_8.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0_8.boxSrcContent, arg0_8.boxSrcTpl, #arg1_8.skipable_list, function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8.skipable_list[arg1_9 + 1]
			local var1_9 = var0_9[1]
			local var2_9 = var0_9[2]
			local var3_9 = var0_9[3]

			changeToScrollText(arg0_8:findTF("SrcText", arg2_9), var3_9)

			local var4_9 = arg0_8:findTF("GoBtn", arg2_9)

			onButton(arg0_8, var4_9, function()
				if var1_9 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2_9[1], var2_9[2] or {})
				elseif var1_9 == Msgbox4LinkCollectGuide.SKIP_TYPE_ACTIVITY then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = var2_9
					})
				elseif var1_9 == var0_0.SKIP_TYPE_MINIGAME then
					pg.m02:sendNotification(GAME.GO_MINI_GAME, var2_9[1])
				end

				arg0_8:showBoxPanel(false)
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
		end
	end)
end

function var0_0.showBoxPanel(arg0_11, arg1_11)
	setActive(arg0_11.boxTF, arg1_11)
end

function var0_0.OnUpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.showDataList[arg1_12 + 1]
	local var1_12 = arg0_12:findTF("icon_mask/icon", arg2_12)
	local var2_12 = {
		type = var0_12.config.type,
		id = var0_12.config.drop_id
	}

	updateDrop(var1_12, var2_12)
	onButton(arg0_12, var1_12, function()
		local var0_13 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_12.config.type,
			drop_id = var0_12.config.drop_id,
			count = var0_12.count,
			count_limit = var0_12.config.count,
			skipable_list = var0_12.config.link_params
		}

		arg0_12:updateBoxPanel(var0_13)
		arg0_12:showBoxPanel(true)
	end, SFX_PANEL)
	changeToScrollText(arg0_12:findTF("name_mask/name", arg2_12), Drop.New({
		type = var0_12.config.type,
		id = var0_12.config.drop_id
	}):getName())
	setText(arg0_12:findTF("owner/number", arg2_12), var0_12.count .. "/" .. var0_12.config.count)

	GetOrAddComponent(arg0_12:findTF("owner", arg2_12), typeof(CanvasGroup)).alpha = var0_12.count == var0_12.config.count and 0.5 or 1

	setActive(arg0_12:findTF("got", arg2_12), var0_12.count == var0_12.config.count)
	setActive(arg0_12:findTF("new", arg2_12), var0_12.config.is_new == "1")
end

return var0_0
