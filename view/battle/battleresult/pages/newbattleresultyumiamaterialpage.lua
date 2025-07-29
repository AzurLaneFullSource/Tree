local var0_0 = class("NewBattleResultYumiaMaterialPage", import("view.base.BaseSubView"))

var0_0.YUMIA_MATERIAL_DROP_TYPE_LIST = {
	DROP_TYPE_RYZA_DROP
}

function var0_0.NeedShowYumiaMaterailDrop(arg0_1)
	for iter0_1, iter1_1 in ipairs(arg0_1) do
		if table.contains(var0_0.YUMIA_MATERIAL_DROP_TYPE_LIST, iter1_1.type) then
			return true
		end
	end

	return false
end

function var0_0.getUIName(arg0_2)
	return "NewBattleResultYumiaRewardPages"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.parentTr = arg0_3._tf.parent
	arg0_3.itemContainer = arg0_3:findTF("item/container")
	arg0_3.itemTpl = arg0_3:findTF("item/tpl")
	arg0_3.confirmBtn = arg0_3:findTF("confirm_btn")
	arg0_3.lineTxt = arg0_3:findTF("words/text")

	setText(arg0_3.confirmBtn:Find("text"), i18n("word_ok"))
end

function var0_0.SetUp(arg0_4, arg1_4)
	arg0_4:Show()
	seriesAsync({
		function(arg0_5)
			arg0_4:playAnima("Anim_NewBattleResultYumiaRewardPages_In")
			arg0_4:UpdateItem()
			arg0_4:UpdateLine()
			arg0_4:RegisterEvent(arg0_5)
		end
	}, function()
		arg0_4:Clear()
		arg0_4:Destroy()
		arg1_4()
	end)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)

	arg0_7.parentTr:GetComponent(typeof(Image)).enabled = false

	SetActive(arg0_7.parentTr:Find("Effect"), false)
end

function var0_0.dropFilter(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8) do
		if table.contains(var0_0.YUMIA_MATERIAL_DROP_TYPE_LIST, iter1_8.type) then
			table.insert(var0_8, iter1_8)
		end
	end

	return var0_8
end

function var0_0.playAnima(arg0_9, arg1_9, arg2_9)
	arg0_9._tf:GetComponent(typeof(Animation)):Play(arg1_9)
	arg0_9._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg2_9()
	end)
end

function var0_0.UpdateItem(arg0_11, arg1_11)
	local var0_11 = var0_0.dropFilter(arg0_11.contextData.drops or {})
	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		for iter2_11 = 1, iter1_11.count do
			local var2_11 = Drop.New({
				count = 1,
				type = iter1_11.type,
				id = iter1_11.id
			})
			local var3_11 = cloneTplTo(arg0_11.itemTpl, arg0_11.itemContainer)

			setActive(var3_11, false)
			table.insert(var1_11, var3_11)
			updateDrop(var3_11:Find("IconTpl"), var2_11)
		end
	end

	local var4_11 = 1

	arg0_11.timer = Timer.New(function()
		local var0_12 = var1_11[var4_11]

		setActive(var0_12, true)
		var0_12:GetComponent(typeof(Animation)):Play("Anim_NewBattleResultYumiaRewardPages_Tpl_In")

		var4_11 = var4_11 + 1
	end, 0.08, #var1_11)

	arg0_11.timer:Start()
end

function var0_0.UpdateLine(arg0_13)
	local var0_13 = var0_0.dropFilter(arg0_13.contextData.drops or {})
	local var1_13 = math.random(#var0_13)
	local var2_13 = AtelierMaterial.New({
		configId = var0_13[var1_13].id
	}):GetVoices()

	if var2_13 and #var2_13 > 0 then
		local var3_13 = var2_13[math.random(#var2_13)]
		local var4_13, var5_13, var6_13 = ShipWordHelper.GetWordAndCV(var3_13[1], var3_13[2], nil, PLATFORM_CODE ~= PLATFORM_US)

		if var5_13 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_13)
		end

		setText(arg0_13.lineTxt, var6_13)
	end
end

function var0_0.RegisterEvent(arg0_14, arg1_14)
	if arg0_14.exited then
		return
	end

	local function var0_14()
		arg0_14:playAnima("Anim_NewBattleResultYumiaRewardPages_Out", arg1_14)
	end

	onButton(arg0_14, arg0_14._tf, var0_14, SFX_PANEL)
	onButton(arg0_14, arg0_14.confirmBtn, var0_14, SFX_PANEL)

	if arg0_14.contextData.autoSkipFlag then
		triggerButton(arg0_14._tf)
	end
end

function var0_0.Clear(arg0_16)
	removeOnButton(arg0_16._tf)
	removeOnButton(arg0_16.confirmBtn)
end

function var0_0.OnDestroy(arg0_17)
	arg0_17.exited = true

	if arg0_17:isShowing() then
		arg0_17:Hide()
	end

	if arg0_17.timer then
		arg0_17.timer:Stop()
	end

	arg0_17.parentTr:GetComponent(typeof(Image)).enabled = true

	SetActive(arg0_17.parentTr:Find("Effect"), true)
end

return var0_0
