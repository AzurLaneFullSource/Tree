local var0 = class("AtelierBuffLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AtelierBuffUI"
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1

	local var0 = arg1:GetItems()

	arg0.buffItems = _.map(_.filter(AtelierMaterial.bindConfigTable().all, function(arg0)
		return AtelierMaterial.bindConfigTable()[arg0].type == AtelierMaterial.TYPE.STRENGTHEN
	end), function(arg0)
		return var0[arg0] or AtelierMaterial.New({
			configId = arg0
		})
	end)
end

function var0.init(arg0)
	arg0.slotTfs = _.map({
		1,
		2,
		3,
		4,
		5
	}, function(arg0)
		return arg0._tf:Find("Panel"):GetChild(arg0)
	end)
	arg0.effectList = arg0._tf:Find("Effects/ScrollView/Viewport/Content")

	setText(arg0._tf:Find("Items/List"):GetChild(0):Find("Max/Text"), i18n("ryza_tip_control_buff_limit"))
	setText(arg0._tf:Find("Items/List"):GetChild(0):Find("Min/Text"), i18n("ryza_tip_control_buff_not_obtain"))

	arg0.buffItemTFs = CustomIndexLayer.Clone2Full(arg0._tf:Find("Items/List"), 8)

	setText(arg0._tf:Find("Top/Tips"), i18n("ryza_tip_control"))
	setText(arg0._tf:Find("Effects/Total"), i18n("ryza_tip_control_buff"))

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ryza_control_help_tip.tip
		})
	end, SFX_PANEL)
	table.Foreach(arg0.slotTfs, function(arg0, arg1)
		onButton(arg0, arg1, function()
			arg0.contextData.selectIndex = arg0

			arg0:UpdateView()
		end, SFX_PANEL)
	end)
	table.Foreach(arg0.buffItemTFs, function(arg0, arg1)
		onButton(arg0, arg1, function()
			local var0 = arg0.buffItems[arg0]

			if not arg0.contextData.selectIndex then
				arg0:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, var0)

				return
			end

			local var1 = arg0.activity:GetSlots()
			local var2 = var1[arg0.contextData.selectIndex]

			local function var3(arg0, arg1)
				if arg1 > var0.count then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_control_buff_not_obtain_tip"))

					return
				end

				local var0 = Clone(var1)
				local var1 = var0[arg0.contextData.selectIndex]

				var1[1] = arg0
				var1[2] = arg1

				arg0:emit(GAME.UPDATE_ATELIER_BUFF, var0)
			end

			if var2[1] == var0:GetConfigID() then
				if var2[2] < #var0:GetBuffs() then
					var3(var2[1], var2[2] + 1)
				end

				return
			end

			if _.detect(var1, function(arg0)
				return arg0[1] == var0:GetConfigID()
			end) then
				return
			end

			var3(var0:GetConfigID(), 1)
		end, SFX_PANEL)
	end)
	arg0:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	if PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
		triggerButton(arg0._tf:Find("Top/Help"))
		PlayerPrefs.SetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 1)
	end
end

function var0.UpdateView(arg0)
	local var0 = arg0.activity:GetSlots()
	local var1 = _.all(var0, function(arg0)
		return arg0[1] > 0
	end)

	setActive(arg0._tf:Find("Panel/Full"), var1)

	arg0.slotFull = var1

	table.Foreach(arg0.slotTfs, function(arg0, arg1)
		arg0:UpdateSlot(arg1, arg0)
	end)

	local var2 = arg0.contextData.selectIndex and var0[arg0.contextData.selectIndex]

	table.Foreach(arg0.buffItems, function(arg0, arg1)
		local var0 = arg0.buffItemTFs[arg0]
		local var1 = arg1:GetBuffs()
		local var2 = _.detect(var0, function(arg0)
			return arg0[1] == arg1:GetConfigID()
		end)
		local var3 = #var1
		local var4 = var2 and var3 <= var2[2]
		local var5 = arg1.count == 0 or var2 and var3 > var2[2] and var2[2] == arg1.count
		local var6 = var2 and table.indexof(var0, var2) == arg0.contextData.selectIndex
		local var7 = var2 and not var4 and var2 and not var6
		local var8 = var2 and not var2 and not var5
		local var9 = not var5 and var2 and (var8 and var2[1] == 0 or var6 and var3 > var2[2])
		local var10 = var8 or var9

		setActive(var0:Find("Min"), false)

		if var5 then
			setActive(var0:Find("Min"), true)
			setText(var0:Find("Min/Text"), i18n("ryza_tip_control_buff_not_obtain"))
		elseif var7 then
			setActive(var0:Find("Min"), true)
			setText(var0:Find("Min/Text"), i18n("ryza_tip_control_buff_already_active_tip"))
		end

		setActive(var0:Find("Avaliable"), var10)

		if var9 then
			setText(var0:Find("Avaliable/Text"), i18n("ryza_tip_control_buff_upgrade"))
		elseif var8 then
			setText(var0:Find("Avaliable/Text"), i18n("ryza_tip_control_buff_replace"))
		end

		setActive(var0:Find("Max"), var4)
		setScrollText(var0:Find("Name/Text"), arg1:GetName())

		local var11 = arg1.count

		if var2 then
			var11 = var11 - var2[2]
		end

		updateDrop(var0:Find("Icon"), {
			type = DROP_TYPE_RYZA_DROP,
			id = arg1:GetConfigID(),
			count = var11
		})
	end)

	local var3 = _.map(var0, function(arg0)
		if arg0[1] == 0 or arg0[2] == 0 then
			return
		end

		local var0 = arg0.activity:GetItems()[arg0[1]]

		assert(var0)

		var0 = var0 or AtelierMaterial.New({
			configId = arg0[1]
		})

		local var1 = var0:GetBuffs()

		if not var1 then
			return
		end

		local var2 = var1[math.min(#var1, arg0[2])]
		local var3 = CommonBuff.New({
			id = var2
		})

		return "【" .. var3:getConfig("name") .. "】:" .. var3:getConfig("desc")
	end)
	local var4 = CustomIndexLayer.Clone2Full(arg0.effectList, #var3)

	for iter0, iter1 in ipairs(var4) do
		setText(iter1, var3[iter0])
	end
end

function var0.PlayFullEffect(arg0)
	arg0:LoadingOn()
end

function var0.UpdateSlot(arg0, arg1, arg2)
	local var0 = arg0.activity:GetSlots()[arg2]
	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = arg0.contextData.selectIndex == arg2
	local var4 = var1 > 0 or var3

	setActive(arg1:Find("Avaliable"), var4)
	setActive(arg1:Find("Link"), var4)
	setActive(arg1:Find("LinkActive"), var3)
	setActive(arg1:Find("Diamond"), var1 > 0)

	local var5 = false

	if var4 then
		setActive(arg1:Find("Avaliable/Selecting"), var3)
		setActive(arg1:Find("Avaliable/Item"), var1 > 0)
		setActive(arg1:Find("Avaliable/Item"):GetChild(2), arg0.slotFull)
		setActive(arg1:Find("Avaliable/Image"), var1 == 0)

		if var1 > 0 then
			local var6 = AtelierMaterial.New({
				configId = var1
			})

			var5 = #var6:GetBuffs() == var2

			local var7 = var6:GetBuffs()[math.min(#var6:GetBuffs(), var2)]
			local var8 = CommonBuff.New({
				id = var7
			})

			arg0.loader:GetSpriteQuiet(var8:getConfig("icon"), "", arg1:Find("Avaliable/Item/Image"))
			setText(arg1:Find("Avaliable/Item/Name/Text"), var8:getConfig("name"))
		end
	end

	setActive(arg1:Find("Link/3"), var5)
	setActive(arg1:Find("Link/1"), not var5 and var2 > 0)
end

function var0.OnUpdateAtelierBuff(arg0)
	arg0:UpdateView()
	arg0:PlayLevelUpAnim()
end

function var0.PlayLevelUpAnim(arg0)
	arg0:CleanTween()

	local var0 = arg0.slotTfs[arg0.contextData.selectIndex]
	local var1 = var0:Find("Avaliable/LevelUp/Image")

	setActive(var1.parent, true)

	local var2 = var1.anchoredPosition.y

	setImageAlpha(var1, 0)

	arg0.tweenId = LeanTween.value(go(var0), 0, 2, 2):setOnUpdate(System.Action_float(function(arg0)
		arg0 = math.clamp(arg0, 0, 1)

		setImageAlpha(var1, arg0)
		setAnchoredPosition(var1, {
			y = var2 + 20 * (arg0 - 1)
		})
	end)):setOnComplete(System.Action(function()
		setAnchoredPosition(var1, {
			y = var2
		})
		setActive(var1.parent, false)
	end)).id
end

function var0.CleanTween(arg0)
	if not arg0.tweenId then
		return
	end

	LeanTween.cancel(arg0.tweenId, true)
end

function var0.LoadingOn(arg0)
	if arg0.animating then
		return
	end

	arg0.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0.LoadingOff(arg0)
	if not arg0.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0.animating = false
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	arg0:CleanTween()
	arg0:LoadingOff()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
