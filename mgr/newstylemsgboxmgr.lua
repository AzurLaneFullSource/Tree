pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("NewStyleMsgboxMgr")

var0_0.NewStyleMsgboxMgr = var1_0
var1_0.TYPE_MSGBOX = 1
var1_0.TYPE_DROP = 2
var1_0.TYPE_DROP_CLIENT = 3
var1_0.TYPE_COMMON_MSGBOX = 4
var1_0.TYPE_COMMON_HELP = 5
var1_0.TYPE_COMMON_DROP = 6
var1_0.TYPE_COMMON_ITEMS = 7
var1_0.TYPE_SHIP_PREVIEW = 8
var1_0.TYPE_COMMON_SHOPPING = 9
var1_0.UI_NAME_DIC = {
	[var1_0.TYPE_MSGBOX] = "DormStyleMsgboxUI",
	[var1_0.TYPE_DROP] = "DormStyleDropMsgboxUI",
	[var1_0.TYPE_DROP_CLIENT] = "DormStyleDropMsgboxUI",
	[var1_0.TYPE_COMMON_MSGBOX] = "NewStyleMsgboxUI",
	[var1_0.TYPE_COMMON_HELP] = "NewStyleHelpMsgboxUI",
	[var1_0.TYPE_COMMON_DROP] = "NewStyleDropMsgboxUI",
	[var1_0.TYPE_COMMON_ITEMS] = "NewStyleItemsMsgboxUI",
	[var1_0.TYPE_SHIP_PREVIEW] = "ShipPreviewUI",
	[var1_0.TYPE_COMMON_SHOPPING] = "NewStyleShoppingMsgboxUI"
}
var1_0.BUTTON_TYPE = {
	blue = "btn_confirm",
	gray = "btn_cancel",
	shopping = "btn_shopping",
	confirm = "btn_confirm",
	cancel = "btn_cancel"
}
var1_0.RES_LIST = {
	diamond = {
		"ui/commonui_atlas",
		"res_diamond"
	},
	gold = {
		"ui/commonui_atlas",
		"res_gold"
	},
	res_oil = {
		"ui/commonui_atlas",
		"res_oil"
	},
	guildicon = {
		"ui/share/msgbox_atlas",
		"res_guildicon"
	},
	world_money = {
		"ui/share/world_common_atlas",
		"res_Whuobi"
	},
	port_money = {
		"ui/share/world_common_atlas",
		"res_Wzhaungbeibi"
	},
	world_boss = {
		"props/100000",
		""
	}
}
var1_0.COLOR_MAP = {
	["#[Ff][Ff][Dd][Ee]38"] = "#ffa944",
	["#6[Dd][Dd]329"] = "#238c40",
	["#92[Ff][Cc]63"] = "#238c40"
}

function var1_0.Init(arg0_1, arg1_1)
	print("initializing new style msgbox manager...")

	arg0_1.showList = {}
	arg0_1.rtDic = {}
	arg0_1.richTextSprites = {}

	local var0_1 = {}

	for iter0_1, iter1_1 in pairs(var1_0.RES_LIST) do
		table.insert(var0_1, function(arg0_2)
			LoadSpriteAtlasAsync(iter1_1[1], iter1_1[2], function(arg0_3)
				arg0_1.richTextSprites[iter0_1] = arg0_3

				arg0_2()
			end)
		end)
	end

	seriesAsync(var0_1, function()
		existCall(arg1_1)
	end)
end

function var1_0.Show(arg0_5, ...)
	table.insert(arg0_5.showList, packEx(...))

	if #arg0_5.showList == 1 then
		arg0_5:DoShow(unpackEx(arg0_5.showList[1]))
	end
end

function var1_0.DeepShow(arg0_6, ...)
	if #arg0_6.showList == 0 then
		arg0_6:Show(...)
	else
		table.insert(arg0_6.showList, 1, packEx(...))
		arg0_6:Hide(true)
	end
end

function var1_0.DoShow(arg0_7, arg1_7, arg2_7)
	local var0_7 = {}

	if not arg0_7.rtDic[arg1_7] then
		table.insert(var0_7, function(arg0_8)
			var0_0.UIMgr.GetInstance():LoadingOn()
			PoolMgr.GetInstance():GetUI(var1_0.UI_NAME_DIC[arg1_7], true, function(arg0_9)
				setParent(arg0_9, var0_0.UIMgr.GetInstance().OverlayMain, false)

				arg0_7.rtDic[arg1_7] = arg0_9.transform

				var0_0.UIMgr.GetInstance():LoadingOff()
				arg0_8()
			end)
		end)
	end

	seriesAsync(var0_7, function()
		arg0_7._tf = arg0_7.rtDic[arg1_7]

		if arg1_7 == var1_0.TYPE_SHIP_PREVIEW then
			var0_0.DelegateInfo.New(arg0_7)
		else
			arg0_7:CommonSetting(arg2_7)
		end

		arg0_7:DisplaySetting(arg1_7, arg2_7)
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, arg2_7.blurParams or {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setActive(arg0_7._tf, true)
	end)
end

function var1_0.Hide(arg0_11, arg1_11)
	if arg0_11.previewer then
		arg0_11.previewer:Destroy()

		arg0_11.previewer = nil

		return
	end

	if not arg0_11._tf then
		return
	end

	setActive(arg0_11._tf, false)
	arg0_11:Clear()
	var0_0.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, var0_0.UIMgr.GetInstance().OverlayMain)

	arg0_11._tf = nil

	if not arg1_11 then
		table.remove(arg0_11.showList, 1)
	end

	if #arg0_11.showList > 0 then
		arg0_11:DoShow(unpackEx(arg0_11.showList[1]))
	end
end

function var1_0.CommonSetting(arg0_12, arg1_12)
	var0_0.DelegateInfo.New(arg0_12)
	setText(arg0_12._tf:Find("window/top/title"), arg1_12.title or i18n("words_information"))

	function arg0_12.hideCall()
		arg0_12.hideCall = nil

		existCall(arg1_12.onClose)
	end

	onButton(arg0_12, arg0_12._tf:Find("bg"), function()
		existCall(arg0_12.hideCall)
		arg0_12:Hide()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("window/top/btn_close"), function()
		existCall(arg0_12.hideCall)
		arg0_12:Hide()
	end, SFX_CANCEL)

	function arg0_12.confirmCall()
		arg0_12.confirmCall = nil

		existCall(arg1_12.onConfirm)
	end

	local var0_12 = arg1_12.btnList or {
		{
			type = var1_0.BUTTON_TYPE.cancel,
			name = i18n("msgbox_text_cancel"),
			func = function()
				existCall(arg0_12.hideCall)
			end,
			sound = SFX_CANCEL
		},
		{
			type = var1_0.BUTTON_TYPE.confirm,
			name = i18n("msgbox_text_confirm"),
			func = function()
				existCall(arg0_12.confirmCall)
			end,
			sound = SFX_CONFIRM
		}
	}
	local var1_12 = arg0_12._tf:Find("window/bottom/button_container")

	eachChild(var1_12, function(arg0_19)
		setActive(arg0_19, false)
	end)

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var2_12 = var1_12:Find(iter1_12.type)

		if var2_12:GetSiblingIndex() < var1_12.childCount - iter0_12 + 1 then
			var2_12:SetAsLastSibling()
			setActive(var2_12, true)
		else
			var2_12 = cloneTplTo(var2_12, var1_12, var2_12.name)
		end

		setText(var2_12:Find("Text"), iter1_12.name)
		onButton(arg0_12, var2_12, function()
			existCall(iter1_12.func)
			arg0_12:Hide()
		end, iter1_12.sound or SFX_CONFIRM)
	end
end

function var1_0.Clear(arg0_21)
	var0_0.DelegateInfo.Dispose(arg0_21)

	arg0_21.hideCall = nil
	arg0_21.confirmCall = nil
end

function var1_0.DisplaySetting(arg0_22, arg1_22, arg2_22)
	switch(arg1_22, {
		[var1_0.TYPE_MSGBOX] = function(arg0_23)
			setText(arg0_22._tf:Find("window/middle/content"), arg0_23.contentText)
		end,
		[var1_0.TYPE_DROP] = function(arg0_24)
			local var0_24 = arg0_24.drop
			local var1_24 = arg0_22._tf:Find("window/middle")

			updateCustomDrop(var1_24:Find("Dorm3dIconTpl"), arg0_24.drop, {
				style = arg0_24.style
			})
			setText(var1_24:Find("info/name"), var0_24:getName())
			setText(var1_24:Find("info/scroll/desc"), cancelColorRich(var0_24.desc))

			local var2_24, var3_24 = var0_24:getOwnedCount()

			setActive(var1_24:Find("info/count"), var3_24)

			if var3_24 then
				setText(var1_24:Find("info/count"), i18n("dorm3d_item_num") .. string.format("<color=#39bfff>%d</color>", var2_24))
			end
		end,
		[var1_0.TYPE_DROP_CLIENT] = function(arg0_25)
			local var0_25 = arg0_22._tf:Find("window/middle")

			Dorm3dIconHelper.UpdateDorm3dIcon(var0_25:Find("Dorm3dIconTpl"), arg0_25.data)
			setActive(var0_25:Find("info/count"), false)
			setActive(var0_25:Find("Dorm3dIconTpl/count"), false)

			local var1_25 = Dorm3dIconHelper.Data2Config(arg0_25.data)

			setText(var0_25:Find("info/name"), var1_25.name)
			setText(var0_25:Find("info/scroll/desc"), var1_25.desc)
		end,
		[var1_0.TYPE_COMMON_MSGBOX] = function(arg0_26)
			local var0_26 = arg0_22._tf:Find("window/middle/content")

			arg0_22:InitRichText(var0_26)
			setTextInNewStyleBox(var0_26, arg0_26.contentText)
		end,
		[var1_0.TYPE_COMMON_HELP] = function(arg0_27)
			setActive(arg0_22._tf:Find("window/bottom"), false)

			local var0_27 = arg0_22._tf:Find("window/middle/content")
			local var1_27 = UIItemList.New(var0_27, var0_27:Find("tpl"))

			var1_27:make(function(arg0_28, arg1_28, arg2_28)
				arg1_28 = arg1_28 + 1

				if arg0_28 == UIItemList.EventUpdate then
					local var0_28 = arg0_27.helps[arg1_28]

					setActive(arg2_28:Find("line"), var0_28.line)
					setTextInNewStyleBox(arg2_28:Find("Text"), HXSet.hxLan(var0_28.info and SwitchSpecialChar(var0_28.info, true) or ""))
				end
			end)
			var1_27:align(#arg0_27.helps)
		end,
		[var1_0.TYPE_COMMON_DROP] = function(arg0_29)
			local var0_29 = arg0_29.drop
			local var1_29 = arg0_22._tf:Find("window/middle")

			updateDrop(var1_29:Find("left/IconTpl"), var0_29)
			setText(var1_29:Find("info/name_container/name/Text"), var0_29:getConfig("name"))

			local var2_29 = var1_29:Find("info/desc/Text")

			arg0_22:InitRichText(var2_29)
			var0_29:MsgboxIntroSet(arg0_29, var2_29)
			setTextInNewStyleBox(var2_29, var2_29:GetComponent(typeof(Text)).text)
			UpdateOwnDisplay(var1_29:Find("left/own"), var0_29)
			setText(var1_29:Find("left/detail/Text"), i18n("technology_detail"))
			RegisterNewStyleDetailButton(arg0_22, var1_29:Find("left/detail"), var0_29)

			local var3_29 = var0_29.type == DROP_TYPE_SHIP
			local var4_29 = var1_29:Find("info/name_container/shiptype")
			local var5_29 = var1_29:Find("extra_info/ship")

			setActive(var4_29, var3_29)
			setActive(var5_29, var3_29)

			if var3_29 then
				GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var0_29:getConfig("type")), var4_29)

				local var6_29 = tobool(getProxy(CollectionProxy):getShipGroup(var0_0.ship_data_template[var0_29.id].group_type))

				setActive(var5_29:Find("unlock"), var6_29)
				setText(var5_29:Find("unlock/Text"), i18n("tag_ship_unlocked"))
				setActive(var5_29:Find("lock"), not var6_29)
				setText(var5_29:Find("lock/Text"), i18n("tag_ship_locked"))
			end

			local var7_29 = var0_29.type == DROP_TYPE_EQUIPMENT_SKIN
			local var8_29 = var1_29:Find("extra_info/equip_skin")

			setActive(var8_29, var7_29)
			setActive(var1_29:Find("left/placeholder"), var7_29)

			if var7_29 then
				setTextInNewStyleBox(var1_29:Find("info/desc/Text"), var0_29:getConfig("desc"))

				local var9_29 = var0_0.equip_skin_template[var0_29.id]
				local var10_29 = underscore.map(var9_29.equip_type, function(arg0_30)
					return EquipType.Type2Name2(arg0_30)
				end)
				local var11_29 = table.concat(var10_29, ",")

				setScrollText(var8_29:Find("tag/mask/Text"), i18n("word_fit") .. ":" .. var11_29)
				onButton(arg0_22, var8_29:Find("play"), function()
					local var0_31 = Ship.New({
						id = var9_29.ship_config_id,
						configId = var9_29.ship_config_id,
						skin_id = var9_29.ship_skin_id
					})

					arg0_22:DeepShow(var0_0.NewStyleMsgboxMgr.TYPE_SHIP_PREVIEW, {
						blurParams = {
							weight = LayerWeightConst.TOP_LAYER
						},
						shipVO = var0_31,
						weaponIds = var9_29.ship_skin_id == 0 and Clone(var9_29.weapon_ids) or {},
						equipSkinId = var9_29.ship_skin_id == 0 and var0_29.id or 0
					})
				end, SFX_PANEL)
			end

			local var12_29 = var0_29.type == DROP_TYPE_COMBAT_UI_STYLE
			local var13_29 = var1_29:Find("extra_info/combat_skin")

			setActive(var13_29, var12_29)
			setActive(var1_29:Find("left/placeholder"), var12_29)

			if var12_29 then
				local var14_29 = var0_0.item_data_battleui[var0_29.id].rare_display
				local var15_29 = UIItemList.New(var1_29:Find("extra_info/combat_skin/elementList"), var1_29:Find("extra_info/combat_skin/elementList/main"))

				var15_29:make(function(arg0_32, arg1_32, arg2_32)
					if arg0_32 == UIItemList.EventUpdate then
						GetImageSpriteFromAtlasAsync("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var14_29[arg1_32 + 1]], arg2_32:Find("icon"), true)
						setScrollText(arg2_32:Find("TextMask/Text"), i18n("battleui_display" .. var14_29[arg1_32 + 1]))
					end
				end)
				var15_29:align(#var14_29)
				onButton(arg0_22, var13_29:Find("play"), function()
					arg0_22.previewer = CombatPreviewLayer.New(var0_0.UIMgr.GetInstance().OverlayMain)

					arg0_22.previewer:ExecuteAction("Show", var0_29.id, function()
						arg0_22.previewer:Destroy()

						arg0_22.previewer = nil
					end)
				end, SFX_PANEL)
			end
		end,
		[var1_0.TYPE_COMMON_ITEMS] = function(arg0_35)
			local var0_35 = arg0_22._tf:Find("window/middle")

			setActive(var0_35:Find("info/Text"), arg0_35.content)
			setTextInNewStyleBox(var0_35:Find("info/Text"), arg0_35.content or "")

			local var1_35 = arg0_35.items
			local var2_35 = arg0_35.itemFunc
			local var3_35 = var0_35:Find("scrollview/content")

			UIItemList.StaticAlign(var3_35, var3_35:Find("item"), #var1_35, function(arg0_36, arg1_36, arg2_36)
				arg1_36 = arg1_36 + 1

				if arg0_36 == UIItemList.EventUpdate then
					local var0_36 = var1_35[arg1_36]

					updateDrop(arg2_36:Find("IconTpl"), var0_36, {
						anonymous = var0_36.anonymous,
						hideName = var0_36.hideName
					})

					local var1_36 = arg2_36:Find("IconTpl/name")

					setText(var1_36, shortenString(getText(var1_36), 6))
					setActive(arg2_36:Find("own"), arg0_35.showOwn)

					if arg0_35.showOwn then
						setText(arg2_36:Find("own/Text"), i18n("equip_skin_detail_count") .. var0_36:getOwnedCount())
					end

					onButton(arg0_22, arg2_36, function()
						if var0_36.anonymous then
							return
						elseif var2_35 then
							var2_35(var0_36)
						end
					end, SFX_UI_CLICK)
				end
			end)
		end,
		[var1_0.TYPE_SHIP_PREVIEW] = function(arg0_38)
			local var0_38 = arg0_22._tf:Find("left_panel")
			local var1_38 = var0_38:Find("sea"):GetComponent("RawImage")

			setActive(var1_38, false)

			local var2_38 = GameObject.Find("BarrageCamera"):GetComponent("Camera")

			var2_38.enabled = true
			var2_38.targetTexture = var1_38.texture

			local var3_38 = arg0_22._tf:Find("resources/heal")

			var3_38.transform.localPosition = Vector3(-360, 50, 40)

			setActive(var3_38, false)
			var3_38:GetComponent("DftAniEvent"):SetEndEvent(function()
				setActive(var3_38, false)
				setText(var3_38:Find("text"), "")
			end)

			local var4_38 = var0_38:Find("bg/loading")
			local var5_38

			onButton(arg0_22, var4_38, function()
				if not var5_38 then
					var5_38 = WeaponPreviewer.New(var1_38)

					var5_38:configUI(var3_38)
					var5_38:setDisplayWeapon(arg0_38.weaponIds, arg0_38.equipSkinId, true)
					var5_38:load(40000, arg0_38.shipVO, arg0_38.weaponIds, function()
						setActive(var4_38, false)
					end)
				end
			end)
			setActive(var4_38, true)
			onButton(arg0_22, arg0_22._tf, function()
				setActive(var4_38, false)

				if var5_38 then
					var5_38:clear()

					var5_38 = nil
				end

				arg0_22:Hide()
			end, SFX_PANEL)
		end,
		[var1_0.TYPE_COMMON_SHOPPING] = function(arg0_43)
			local var0_43 = arg0_22._tf:Find("window/middle")
			local var1_43 = arg0_43.drop

			updateDrop(var0_43:Find("IconTpl"), var1_43)
			setText(var0_43:Find("info/name/Text"), var1_43:getConfig("name"))
			setText(var0_43:Find("IconTpl/own"), i18n("equip_skin_detail_count") .. var1_43:getOwnedCount())

			local var2_43 = var0_43:Find("info/desc/Text")

			arg0_22:InitRichText(var2_43)

			local var3_43 = arg0_22._tf:Find("window/bottom/button_container/btn_shopping/price/Text")
			local var4_43 = arg0_22._tf:Find("window/bottom/count")
			local var5_43 = PageUtil.New(var4_43:Find("reduce"), var4_43:Find("increase"), var4_43:Find("max"), var4_43:Find("Text"))
			local var6_43 = arg0_43.price
			local var7_43 = arg0_43.numUpdate
			local var8_43 = arg0_43.addNum or 1
			local var9_43 = arg0_43.maxNum or -1
			local var10_43 = arg0_43.defaultNum or 1

			var5_43:setNumUpdate(function(arg0_44)
				if var7_43 ~= nil then
					var7_43(var2_43, arg0_44)
				end

				setText(var3_43, "x" .. arg0_44 * var6_43)
			end)
			var5_43:setAddNum(var8_43)
			var5_43:setMaxNum(var9_43)
			var5_43:setDefaultNum(var10_43)
		end
	}, nil, arg2_22)
end

function var1_0.InitRichText(arg0_45, arg1_45)
	local var0_45 = arg1_45:GetComponent("RichText")

	for iter0_45, iter1_45 in pairs(arg0_45.richTextSprites) do
		var0_45:AddSprite(iter0_45, iter1_45)
	end
end

function var1_0.emit(arg0_46, arg1_46, ...)
	if not arg0_46.analogyMediator then
		arg0_46.analogyMediator = {
			addSubLayers = function(arg0_47, arg1_47)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_47
				})
			end,
			sendNotification = function(arg0_48, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_46
		}
	end

	return ContextMediator.CommonBindDic[arg1_46](arg0_46.analogyMediator, arg1_46, ...)
end

function var1_0.closeView(arg0_49)
	arg0_49:hide()
end

return var1_0
