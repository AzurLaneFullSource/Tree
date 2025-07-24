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
			arg0_4:playAnima("Anim_NewBattleResultYumiaRewardPages_In", arg0_5)
		end,
		function(arg0_6)
			arg0_4:UpdateItem()
			arg0_4:UpdateLine()
			arg0_4:RegisterEvent(arg0_6)
		end
	}, function()
		arg0_4:Clear()
		arg0_4:Destroy()
		arg1_4()
	end)
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)

	arg0_8.parentTr:GetComponent(typeof(Image)).enabled = false

	SetActive(arg0_8.parentTr:Find("Effect"), false)
end

function var0_0.dropFilter(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9) do
		if table.contains(var0_0.YUMIA_MATERIAL_DROP_TYPE_LIST, iter1_9.type) then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.playAnima(arg0_10, arg1_10, arg2_10)
	arg0_10._tf:GetComponent(typeof(Animation)):Play(arg1_10)
	arg0_10._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg2_10()
	end)
end

function var0_0.UpdateItem(arg0_12, arg1_12)
	local var0_12 = var0_0.dropFilter(arg0_12.contextData.drops or {})
	local var1_12 = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		for iter2_12 = 1, iter1_12.count do
			local var2_12 = Drop.New({
				count = 1,
				type = iter1_12.type,
				id = iter1_12.id
			})
			local var3_12 = cloneTplTo(arg0_12.itemTpl, arg0_12.itemContainer)

			setActive(var3_12, false)
			table.insert(var1_12, var3_12)
			updateDrop(var3_12:Find("IconTpl"), var2_12)
		end
	end

	local var4_12 = 1

	arg0_12.timer = Timer.New(function()
		local var0_13 = var1_12[var4_12]

		setActive(var0_13, true)
		var0_13:GetComponent(typeof(Animation)):Play("Anim_NewBattleResultYumiaRewardPages_Tpl_In")

		var4_12 = var4_12 + 1
	end, 0.08, #var1_12)

	arg0_12.timer:Start()
end

function var0_0.UpdateLine(arg0_14)
	local var0_14 = var0_0.dropFilter(arg0_14.contextData.drops or {})
	local var1_14 = math.random(#var0_14)
	local var2_14 = AtelierMaterial.New({
		configId = var0_14[var1_14].id
	}):GetVoices()

	if var2_14 and #var2_14 > 0 then
		local var3_14 = var2_14[math.random(#var2_14)]
		local var4_14, var5_14, var6_14 = ShipWordHelper.GetWordAndCV(var3_14[1], var3_14[2], nil, PLATFORM_CODE ~= PLATFORM_US)

		if var5_14 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_14)
		end

		setText(arg0_14.lineTxt, var6_14)
	end
end

function var0_0.RegisterEvent(arg0_15, arg1_15)
	if arg0_15.exited then
		return
	end

	local function var0_15()
		arg0_15:playAnima("Anim_NewBattleResultYumiaRewardPages_Out", arg1_15)
	end

	onButton(arg0_15, arg0_15._tf, var0_15, SFX_PANEL)
	onButton(arg0_15, arg0_15.confirmBtn, var0_15, SFX_PANEL)

	if arg0_15.contextData.autoSkipFlag then
		triggerButton(arg0_15._tf)
	end
end

function var0_0.Clear(arg0_17)
	removeOnButton(arg0_17._tf)
	removeOnButton(arg0_17.confirmBtn)
end

function var0_0.OnDestroy(arg0_18)
	arg0_18.exited = true

	if arg0_18:isShowing() then
		arg0_18:Hide()
	end

	if arg0_18.timer then
		arg0_18.timer:Stop()
	end

	arg0_18.parentTr:GetComponent(typeof(Image)).enabled = true

	SetActive(arg0_18.parentTr:Find("Effect"), true)
end

return var0_0
