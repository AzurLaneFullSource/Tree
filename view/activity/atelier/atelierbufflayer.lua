local var0_0 = class("AtelierBuffLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierBuffUI"
end

function var0_0.SetActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2

	local var0_2 = arg1_2:GetItems()

	arg0_2.buffItems = _.map(_.filter(AtelierMaterial.bindConfigTable().all, function(arg0_3)
		return AtelierMaterial.bindConfigTable()[arg0_3].type == AtelierMaterial.TYPE.STRENGTHEN
	end), function(arg0_4)
		return var0_2[arg0_4] or AtelierMaterial.New({
			configId = arg0_4
		})
	end)
end

function var0_0.init(arg0_5)
	arg0_5.slotTfs = _.map({
		1,
		2,
		3,
		4,
		5
	}, function(arg0_6)
		return arg0_5._tf:Find("Panel"):GetChild(arg0_6)
	end)
	arg0_5.effectList = arg0_5._tf:Find("Effects/ScrollView/Viewport/Content")

	setText(arg0_5._tf:Find("Items/List"):GetChild(0):Find("Max/Text"), i18n("ryza_tip_control_buff_limit"))
	setText(arg0_5._tf:Find("Items/List"):GetChild(0):Find("Min/Text"), i18n("ryza_tip_control_buff_not_obtain"))

	arg0_5.buffItemTFs = CustomIndexLayer.Clone2Full(arg0_5._tf:Find("Items/List"), 8)

	setText(arg0_5._tf:Find("Top/Tips"), i18n("ryza_tip_control"))
	setText(arg0_5._tf:Find("Effects/Total"), i18n("ryza_tip_control_buff"))

	arg0_5.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("Top/Back"), function()
		arg0_7:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7._tf:Find("Top/Home"), function()
		arg0_7:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ryza_control_help_tip.tip
		})
	end, SFX_PANEL)
	table.Foreach(arg0_7.slotTfs, function(arg0_11, arg1_11)
		onButton(arg0_7, arg1_11, function()
			arg0_7.contextData.selectIndex = arg0_11

			arg0_7:UpdateView()
		end, SFX_PANEL)
	end)
	table.Foreach(arg0_7.buffItemTFs, function(arg0_13, arg1_13)
		onButton(arg0_7, arg1_13, function()
			local var0_14 = arg0_7.buffItems[arg0_13]

			if not arg0_7.contextData.selectIndex then
				arg0_7:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, var0_14)

				return
			end

			local var1_14 = arg0_7.activity:GetSlots()
			local var2_14 = var1_14[arg0_7.contextData.selectIndex]

			local function var3_14(arg0_15, arg1_15)
				if arg1_15 > var0_14.count then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_control_buff_not_obtain_tip"))

					return
				end

				local var0_15 = Clone(var1_14)
				local var1_15 = var0_15[arg0_7.contextData.selectIndex]

				var1_15[1] = arg0_15
				var1_15[2] = arg1_15

				arg0_7:emit(GAME.UPDATE_ATELIER_BUFF, var0_15)
			end

			if var2_14[1] == var0_14:GetConfigID() then
				if var2_14[2] < #var0_14:GetBuffs() then
					var3_14(var2_14[1], var2_14[2] + 1)
				end

				return
			end

			if _.detect(var1_14, function(arg0_16)
				return arg0_16[1] == var0_14:GetConfigID()
			end) then
				return
			end

			var3_14(var0_14:GetConfigID(), 1)
		end, SFX_PANEL)
	end)
	arg0_7:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	if PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
		triggerButton(arg0_7._tf:Find("Top/Help"))
		PlayerPrefs.SetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 1)
	end
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = arg0_17.activity:GetSlots()
	local var1_17 = _.all(var0_17, function(arg0_18)
		return arg0_18[1] > 0
	end)

	setActive(arg0_17._tf:Find("Panel/Full"), var1_17)

	arg0_17.slotFull = var1_17

	table.Foreach(arg0_17.slotTfs, function(arg0_19, arg1_19)
		arg0_17:UpdateSlot(arg1_19, arg0_19)
	end)

	local var2_17 = arg0_17.contextData.selectIndex and var0_17[arg0_17.contextData.selectIndex]

	table.Foreach(arg0_17.buffItems, function(arg0_20, arg1_20)
		local var0_20 = arg0_17.buffItemTFs[arg0_20]
		local var1_20 = arg1_20:GetBuffs()
		local var2_20 = _.detect(var0_17, function(arg0_21)
			return arg0_21[1] == arg1_20:GetConfigID()
		end)
		local var3_20 = #var1_20
		local var4_20 = var2_20 and var3_20 <= var2_20[2]
		local var5_20 = arg1_20.count == 0 or var2_20 and var3_20 > var2_20[2] and var2_20[2] == arg1_20.count
		local var6_20 = var2_20 and table.indexof(var0_17, var2_20) == arg0_17.contextData.selectIndex
		local var7_20 = var2_17 and not var4_20 and var2_20 and not var6_20
		local var8_20 = var2_17 and not var2_20 and not var5_20
		local var9_20 = not var5_20 and var2_17 and (var8_20 and var2_17[1] == 0 or var6_20 and var3_20 > var2_20[2])
		local var10_20 = var8_20 or var9_20

		setActive(var0_20:Find("Min"), false)

		if var5_20 then
			setActive(var0_20:Find("Min"), true)
			setText(var0_20:Find("Min/Text"), i18n("ryza_tip_control_buff_not_obtain"))
		elseif var7_20 then
			setActive(var0_20:Find("Min"), true)
			setText(var0_20:Find("Min/Text"), i18n("ryza_tip_control_buff_already_active_tip"))
		end

		setActive(var0_20:Find("Avaliable"), var10_20)

		if var9_20 then
			setText(var0_20:Find("Avaliable/Text"), i18n("ryza_tip_control_buff_upgrade"))
		elseif var8_20 then
			setText(var0_20:Find("Avaliable/Text"), i18n("ryza_tip_control_buff_replace"))
		end

		setActive(var0_20:Find("Max"), var4_20)
		setScrollText(var0_20:Find("Name/Text"), arg1_20:GetName())

		local var11_20 = arg1_20.count

		if var2_20 then
			var11_20 = var11_20 - var2_20[2]
		end

		updateDrop(var0_20:Find("Icon"), {
			type = DROP_TYPE_RYZA_DROP,
			id = arg1_20:GetConfigID(),
			count = var11_20
		})
	end)

	local var3_17 = _.map(var0_17, function(arg0_22)
		if arg0_22[1] == 0 or arg0_22[2] == 0 then
			return
		end

		local var0_22 = arg0_17.activity:GetItems()[arg0_22[1]]

		assert(var0_22)

		var0_22 = var0_22 or AtelierMaterial.New({
			configId = arg0_22[1]
		})

		local var1_22 = var0_22:GetBuffs()

		if not var1_22 then
			return
		end

		local var2_22 = var1_22[math.min(#var1_22, arg0_22[2])]
		local var3_22 = CommonBuff.New({
			id = var2_22
		})

		return "【" .. var3_22:getConfig("name") .. "】:" .. var3_22:getConfig("desc")
	end)
	local var4_17 = CustomIndexLayer.Clone2Full(arg0_17.effectList, #var3_17)

	for iter0_17, iter1_17 in ipairs(var4_17) do
		setText(iter1_17, var3_17[iter0_17])
	end
end

function var0_0.PlayFullEffect(arg0_23)
	arg0_23:LoadingOn()
end

function var0_0.UpdateSlot(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.activity:GetSlots()[arg2_24]
	local var1_24 = var0_24[1]
	local var2_24 = var0_24[2]
	local var3_24 = arg0_24.contextData.selectIndex == arg2_24
	local var4_24 = var1_24 > 0 or var3_24

	setActive(arg1_24:Find("Avaliable"), var4_24)
	setActive(arg1_24:Find("Link"), var4_24)
	setActive(arg1_24:Find("LinkActive"), var3_24)
	setActive(arg1_24:Find("Diamond"), var1_24 > 0)

	local var5_24 = false

	if var4_24 then
		setActive(arg1_24:Find("Avaliable/Selecting"), var3_24)
		setActive(arg1_24:Find("Avaliable/Item"), var1_24 > 0)
		setActive(arg1_24:Find("Avaliable/Item"):GetChild(2), arg0_24.slotFull)
		setActive(arg1_24:Find("Avaliable/Image"), var1_24 == 0)

		if var1_24 > 0 then
			local var6_24 = AtelierMaterial.New({
				configId = var1_24
			})

			var5_24 = #var6_24:GetBuffs() == var2_24

			local var7_24 = var6_24:GetBuffs()[math.min(#var6_24:GetBuffs(), var2_24)]
			local var8_24 = CommonBuff.New({
				id = var7_24
			})

			arg0_24.loader:GetSpriteQuiet(var8_24:getConfig("icon"), "", arg1_24:Find("Avaliable/Item/Image"))
			setText(arg1_24:Find("Avaliable/Item/Name/Text"), var8_24:getConfig("name"))
		end
	end

	setActive(arg1_24:Find("Link/3"), var5_24)
	setActive(arg1_24:Find("Link/1"), not var5_24 and var2_24 > 0)
end

function var0_0.OnUpdateAtelierBuff(arg0_25)
	arg0_25:UpdateView()
	arg0_25:PlayLevelUpAnim()
end

function var0_0.PlayLevelUpAnim(arg0_26)
	arg0_26:CleanTween()

	local var0_26 = arg0_26.slotTfs[arg0_26.contextData.selectIndex]
	local var1_26 = var0_26:Find("Avaliable/LevelUp/Image")

	setActive(var1_26.parent, true)

	local var2_26 = var1_26.anchoredPosition.y

	setImageAlpha(var1_26, 0)

	arg0_26.tweenId = LeanTween.value(go(var0_26), 0, 2, 2):setOnUpdate(System.Action_float(function(arg0_27)
		arg0_27 = math.clamp(arg0_27, 0, 1)

		setImageAlpha(var1_26, arg0_27)
		setAnchoredPosition(var1_26, {
			y = var2_26 + 20 * (arg0_27 - 1)
		})
	end)):setOnComplete(System.Action(function()
		setAnchoredPosition(var1_26, {
			y = var2_26
		})
		setActive(var1_26.parent, false)
	end)).id
end

function var0_0.CleanTween(arg0_29)
	if not arg0_29.tweenId then
		return
	end

	LeanTween.cancel(arg0_29.tweenId, true)
end

function var0_0.LoadingOn(arg0_30)
	if arg0_30.animating then
		return
	end

	arg0_30.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_31)
	if not arg0_31.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_31.animating = false
end

function var0_0.willExit(arg0_32)
	arg0_32.loader:Clear()
	arg0_32:CleanTween()
	arg0_32:LoadingOff()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32._tf)
end

return var0_0
