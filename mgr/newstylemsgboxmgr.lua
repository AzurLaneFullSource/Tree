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
	table.insert(arg0_5.showList, 1, packEx(...))

	if #arg0_5.showList > 0 then
		arg0_5:DoShow(unpackEx(arg0_5.showList[1]))
	end
end

function var1_0.DoShow(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}

	if not arg0_6.rtDic[arg1_6] then
		table.insert(var0_6, function(arg0_7)
			var0_0.UIMgr.GetInstance():LoadingOn()
			PoolMgr.GetInstance():GetUI(var1_0.UI_NAME_DIC[arg1_6], true, function(arg0_8)
				setParent(arg0_8, var0_0.UIMgr.GetInstance().OverlayMain, false)

				arg0_6.rtDic[arg1_6] = arg0_8.transform

				var0_0.UIMgr.GetInstance():LoadingOff()
				arg0_7()
			end)
		end)
	end

	seriesAsync(var0_6, function()
		arg0_6._tf = arg0_6.rtDic[arg1_6]

		if arg1_6 == var1_0.TYPE_SHIP_PREVIEW then
			var0_0.DelegateInfo.New(arg0_6)
		else
			arg0_6:CommonSetting(arg2_6)
		end

		arg0_6:DisplaySetting(arg1_6, arg2_6)
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_6._tf, false, arg2_6.blurParams or {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setActive(arg0_6._tf, true)
	end)
end

function var1_0.Hide(arg0_10)
	if not arg0_10._tf then
		return
	end

	setActive(arg0_10._tf, false)
	arg0_10:Clear()
	var0_0.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, var0_0.UIMgr.GetInstance().OverlayMain)

	arg0_10._tf = nil

	table.remove(arg0_10.showList, 1)

	if #arg0_10.showList > 0 then
		arg0_10:DoShow(unpackEx(arg0_10.showList[1]))
	end
end

function var1_0.CommonSetting(arg0_11, arg1_11)
	var0_0.DelegateInfo.New(arg0_11)
	setText(arg0_11._tf:Find("window/top/title"), arg1_11.title or i18n("words_information"))

	function arg0_11.hideCall()
		arg0_11.hideCall = nil

		existCall(arg1_11.onClose)
	end

	onButton(arg0_11, arg0_11._tf:Find("bg"), function()
		existCall(arg0_11.hideCall)
		arg0_11:Hide()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11._tf:Find("window/top/btn_close"), function()
		existCall(arg0_11.hideCall)
		arg0_11:Hide()
	end, SFX_CANCEL)

	function arg0_11.confirmCall()
		arg0_11.confirmCall = nil

		existCall(arg1_11.onConfirm)
	end

	local var0_11 = arg1_11.btnList or {
		{
			type = var1_0.BUTTON_TYPE.cancel,
			name = i18n("msgbox_text_cancel"),
			func = function()
				existCall(arg0_11.hideCall)
			end,
			sound = SFX_CANCEL
		},
		{
			type = var1_0.BUTTON_TYPE.confirm,
			name = i18n("msgbox_text_confirm"),
			func = function()
				existCall(arg0_11.confirmCall)
			end,
			sound = SFX_CONFIRM
		}
	}
	local var1_11 = arg0_11._tf:Find("window/bottom/button_container")

	eachChild(var1_11, function(arg0_18)
		setActive(arg0_18, false)
	end)

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var2_11 = var1_11:Find(iter1_11.type)

		if var2_11:GetSiblingIndex() < var1_11.childCount - iter0_11 + 1 then
			var2_11:SetAsLastSibling()
			setActive(var2_11, true)
		else
			var2_11 = cloneTplTo(var2_11, var1_11, var2_11.name)
		end

		setText(var2_11:Find("Text"), iter1_11.name)
		onButton(arg0_11, var2_11, function()
			existCall(iter1_11.func)
			arg0_11:Hide()
		end, iter1_11.sound or SFX_CONFIRM)
	end
end

function var1_0.Clear(arg0_20)
	var0_0.DelegateInfo.Dispose(arg0_20)

	arg0_20.hideCall = nil
	arg0_20.confirmCall = nil
end

function var1_0.DisplaySetting(arg0_21, arg1_21, arg2_21)
	switch(arg1_21, {
		[var1_0.TYPE_MSGBOX] = function(arg0_22)
			setText(arg0_21._tf:Find("window/middle/content"), arg0_22.contentText)
		end,
		[var1_0.TYPE_DROP] = function(arg0_23)
			local var0_23 = arg0_23.drop
			local var1_23 = arg0_21._tf:Find("window/middle")

			updateDorm3dIcon(var1_23:Find("Dorm3dIconTpl"), arg0_23.drop)
			setText(var1_23:Find("info/name"), var0_23:getName())
			setText(var1_23:Find("info/desc"), cancelColorRich(var0_23.desc))

			local var2_23, var3_23 = var0_23:getOwnedCount()

			setActive(var1_23:Find("info/count"), var3_23)

			if var3_23 then
				setText(var1_23:Find("info/count"), i18n("dorm3d_item_num") .. string.format("<color=#39bfff>%d</color>", var2_23))
			end
		end,
		[var1_0.TYPE_DROP_CLIENT] = function(arg0_24)
			local var0_24 = arg0_21._tf:Find("window/middle")

			Dorm3dIconHelper.UpdateDorm3dIcon(var0_24:Find("Dorm3dIconTpl"), arg0_24.data)
			setActive(var0_24:Find("info/count"), false)
			setActive(var0_24:Find("Dorm3dIconTpl/count"), false)

			local var1_24 = Dorm3dIconHelper.Data2Config(arg0_24.data)

			setText(var0_24:Find("info/name"), var1_24.name)
			setText(var0_24:Find("info/desc"), var1_24.desc)
		end,
		[var1_0.TYPE_COMMON_MSGBOX] = function(arg0_25)
			local var0_25 = arg0_21._tf:Find("window/middle/content")

			arg0_21:InitRichText(var0_25)
			setTextInNewStyleBox(var0_25, arg0_25.contentText)
		end,
		[var1_0.TYPE_COMMON_HELP] = function(arg0_26)
			setActive(arg0_21._tf:Find("window/bottom"), false)

			local var0_26 = arg0_21._tf:Find("window/middle/content")
			local var1_26 = UIItemList.New(var0_26, var0_26:Find("tpl"))

			var1_26:make(function(arg0_27, arg1_27, arg2_27)
				arg1_27 = arg1_27 + 1

				if arg0_27 == UIItemList.EventUpdate then
					local var0_27 = arg0_26.helps[arg1_27]

					setActive(arg2_27:Find("line"), var0_27.line)
					setTextInNewStyleBox(arg2_27:Find("Text"), HXSet.hxLan(var0_27.info and SwitchSpecialChar(var0_27.info, true) or ""))
				end
			end)
			var1_26:align(#arg0_26.helps)
		end,
		[var1_0.TYPE_COMMON_DROP] = function(arg0_28)
			local var0_28 = arg0_28.drop
			local var1_28 = arg0_21._tf:Find("window/middle")

			updateDrop(var1_28:Find("left/IconTpl"), var0_28)
			setText(var1_28:Find("info/name_container/name/Text"), var0_28:getConfig("name"))

			local var2_28 = var1_28:Find("info/desc/Text")

			arg0_21:InitRichText(var2_28)
			var0_28:MsgboxIntroSet(arg0_28, var2_28)
			setTextInNewStyleBox(var2_28, var2_28:GetComponent(typeof(Text)).text)
			UpdateOwnDisplay(var1_28:Find("left/own"), var0_28)
			setText(var1_28:Find("left/detail/Text"), i18n("technology_detail"))
			RegisterNewStyleDetailButton(arg0_21, var1_28:Find("left/detail"), var0_28)

			local var3_28 = var0_28.type == DROP_TYPE_SHIP
			local var4_28 = var1_28:Find("info/name_container/shiptype")
			local var5_28 = var1_28:Find("extra_info/ship")

			setActive(var4_28, var3_28)
			setActive(var5_28, var3_28)

			if var3_28 then
				GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var0_28:getConfig("type")), var4_28)

				local var6_28 = tobool(getProxy(CollectionProxy):getShipGroup(var0_0.ship_data_template[var0_28.id].group_type))

				setActive(var5_28:Find("unlock"), var6_28)
				setText(var5_28:Find("unlock/Text"), i18n("tag_ship_unlocked"))
				setActive(var5_28:Find("lock"), not var6_28)
				setText(var5_28:Find("lock/Text"), i18n("tag_ship_locked"))
			end

			local var7_28 = var0_28.type == DROP_TYPE_EQUIPMENT_SKIN
			local var8_28 = var1_28:Find("extra_info/equip_skin")

			setActive(var8_28, var7_28)
			setActive(var1_28:Find("left/placeholder"), var7_28)

			if var7_28 then
				setTextInNewStyleBox(var1_28:Find("info/desc/Text"), var0_28:getConfig("desc"))

				local var9_28 = var0_0.equip_skin_template[var0_28.id]
				local var10_28 = underscore.map(var9_28.equip_type, function(arg0_29)
					return EquipType.Type2Name2(arg0_29)
				end)
				local var11_28 = table.concat(var10_28, ",")

				setScrollText(var8_28:Find("tag/mask/Text"), i18n("word_fit") .. ":" .. var11_28)
				onButton(arg0_21, var8_28:Find("play"), function()
					local var0_30 = Ship.New({
						id = var9_28.ship_config_id,
						configId = var9_28.ship_config_id,
						skin_id = var9_28.ship_skin_id
					})

					arg0_21:Show(var0_0.NewStyleMsgboxMgr.TYPE_SHIP_PREVIEW, {
						blurParams = {
							weight = LayerWeightConst.TOP_LAYER
						},
						shipVO = var0_30,
						weaponIds = var9_28.ship_skin_id == 0 and Clone(var9_28.weapon_ids) or {},
						equipSkinId = var9_28.ship_skin_id == 0 and var0_28.id or 0
					})
				end, SFX_PANEL)
			end
		end,
		[var1_0.TYPE_COMMON_ITEMS] = function(arg0_31)
			local var0_31 = arg0_21._tf:Find("window/middle")

			setActive(var0_31:Find("info/Text"), arg0_31.content)
			setTextInNewStyleBox(var0_31:Find("info/Text"), arg0_31.content or "")

			local var1_31 = arg0_31.items
			local var2_31 = arg0_31.itemFunc
			local var3_31 = var0_31:Find("scrollview/content")

			UIItemList.StaticAlign(var3_31, var3_31:Find("item"), #var1_31, function(arg0_32, arg1_32, arg2_32)
				arg1_32 = arg1_32 + 1

				if arg0_32 == UIItemList.EventUpdate then
					local var0_32 = var1_31[arg1_32]

					updateDrop(arg2_32:Find("IconTpl"), var0_32, {
						anonymous = var0_32.anonymous,
						hideName = var0_32.hideName
					})

					local var1_32 = arg2_32:Find("IconTpl/name")

					setText(var1_32, shortenString(getText(var1_32), 6))
					setActive(arg2_32:Find("own"), arg0_31.showOwn)

					if arg0_31.showOwn then
						setText(arg2_32:Find("own/Text"), i18n("equip_skin_detail_count") .. var0_32:getOwnedCount())
					end

					onButton(arg0_21, arg2_32, function()
						if var0_32.anonymous then
							return
						elseif var2_31 then
							var2_31(var0_32)
						end
					end, SFX_UI_CLICK)
				end
			end)
		end,
		[var1_0.TYPE_SHIP_PREVIEW] = function(arg0_34)
			local var0_34 = arg0_21._tf:Find("left_panel")
			local var1_34 = var0_34:Find("sea"):GetComponent("RawImage")

			setActive(var1_34, false)

			local var2_34 = GameObject.Find("BarrageCamera"):GetComponent("Camera")

			var2_34.enabled = true
			var2_34.targetTexture = var1_34.texture

			local var3_34 = arg0_21._tf:Find("resources/heal")

			var3_34.transform.localPosition = Vector3(-360, 50, 40)

			setActive(var3_34, false)
			var3_34:GetComponent("DftAniEvent"):SetEndEvent(function()
				setActive(var3_34, false)
				setText(var3_34:Find("text"), "")
			end)

			local var4_34 = var0_34:Find("bg/loading")
			local var5_34

			onButton(arg0_21, var4_34, function()
				if not var5_34 then
					var5_34 = WeaponPreviewer.New(var1_34)

					var5_34:configUI(var3_34)
					var5_34:setDisplayWeapon(arg0_34.weaponIds, arg0_34.equipSkinId, true)
					var5_34:load(40000, arg0_34.shipVO, arg0_34.weaponIds, function()
						setActive(var4_34, false)
					end)
				end
			end)
			setActive(var4_34, true)
			onButton(arg0_21, arg0_21._tf, function()
				setActive(var4_34, false)

				if var5_34 then
					var5_34:clear()

					var5_34 = nil
				end

				arg0_21:Hide()
			end, SFX_PANEL)
		end,
		[var1_0.TYPE_COMMON_SHOPPING] = function(arg0_39)
			local var0_39 = arg0_21._tf:Find("window/middle")
			local var1_39 = arg0_39.drop

			updateDrop(var0_39:Find("IconTpl"), var1_39)
			setText(var0_39:Find("info/name/Text"), var1_39:getConfig("name"))
			setText(var0_39:Find("IconTpl/own"), i18n("equip_skin_detail_count") .. var1_39:getOwnedCount())

			local var2_39 = var0_39:Find("info/desc/Text")

			arg0_21:InitRichText(var2_39)

			local var3_39 = arg0_21._tf:Find("window/bottom/button_container/btn_shopping/price/Text")
			local var4_39 = arg0_21._tf:Find("window/bottom/count")
			local var5_39 = PageUtil.New(var4_39:Find("reduce"), var4_39:Find("increase"), var4_39:Find("max"), var4_39:Find("Text"))
			local var6_39 = arg0_39.price
			local var7_39 = arg0_39.numUpdate
			local var8_39 = arg0_39.addNum or 1
			local var9_39 = arg0_39.maxNum or -1
			local var10_39 = arg0_39.defaultNum or 1

			var5_39:setNumUpdate(function(arg0_40)
				if var7_39 ~= nil then
					var7_39(var2_39, arg0_40)
				end

				setText(var3_39, "x" .. arg0_40 * var6_39)
			end)
			var5_39:setAddNum(var8_39)
			var5_39:setMaxNum(var9_39)
			var5_39:setDefaultNum(var10_39)
		end
	}, nil, arg2_21)
end

function var1_0.InitRichText(arg0_41, arg1_41)
	local var0_41 = arg1_41:GetComponent("RichText")

	for iter0_41, iter1_41 in pairs(arg0_41.richTextSprites) do
		var0_41:AddSprite(iter0_41, iter1_41)
	end
end

function var1_0.emit(arg0_42, arg1_42, ...)
	if not arg0_42.analogyMediator then
		arg0_42.analogyMediator = {
			addSubLayers = function(arg0_43, arg1_43)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_43
				})
			end,
			sendNotification = function(arg0_44, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_42
		}
	end

	return ContextMediator.CommonBindDic[arg1_42](arg0_42.analogyMediator, arg1_42, ...)
end

function var1_0.closeView(arg0_45)
	arg0_45:hide()
end
