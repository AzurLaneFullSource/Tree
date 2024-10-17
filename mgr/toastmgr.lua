pg = pg or {}
pg.ToastMgr = singletonClass("ToastMgr")

local var0_0 = pg.ToastMgr
local var1_0 = require("Mgr/Pool/PoolPlural")

var0_0.TYPE_ATTIRE = "Attire"
var0_0.TYPE_TECPOINT = "Tecpoint"
var0_0.TYPE_TROPHY = "Trophy"
var0_0.TYPE_META = "Meta"
var0_0.TYPE_CRUSING = "Crusing"
var0_0.TYPE_VOTE = "Vote"
var0_0.TYPE_EMOJI = "Emoji"
var0_0.TYPE_COVER = "Cover"
var0_0.TYPE_COMBAT_UI = "CombatUI"
var0_0.ToastInfo = {
	[var0_0.TYPE_ATTIRE] = {
		Attire = "attire_tpl"
	},
	[var0_0.TYPE_TECPOINT] = {
		Buff = "buff_tpl",
		Point = "point_tpl"
	},
	[var0_0.TYPE_TROPHY] = {
		Trophy = "trophy_tpl"
	},
	[var0_0.TYPE_META] = {
		MetaLevel = "meta_level_tpl",
		MetaExp = "meta_exp_tpl"
	},
	[var0_0.TYPE_CRUSING] = {
		Crusing = "crusing_pt_tpl"
	},
	[var0_0.TYPE_VOTE] = {
		Vote = "vote_tpl"
	},
	[var0_0.TYPE_EMOJI] = {
		Emoji = "emoji_tpl"
	},
	[var0_0.TYPE_COVER] = {
		Cover = "cover_tpl"
	},
	[var0_0.TYPE_COMBAT_UI] = {
		CombatUI = "combatui_tpl"
	}
}

function var0_0.Init(arg0_1, arg1_1)
	LoadAndInstantiateAsync("ui", "ToastUI", function(arg0_2)
		arg0_1._go = arg0_2

		arg0_1._go:SetActive(false)

		arg0_1._tf = arg0_1._go.transform
		arg0_1.container = arg0_1._tf:Find("container")

		arg0_1._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0_1.pools = {}

		local var0_2 = {}

		for iter0_2, iter1_2 in pairs(var0_0.ToastInfo) do
			for iter2_2, iter3_2 in pairs(iter1_2) do
				var0_2[iter2_2 .. "Tpl"] = iter3_2
			end
		end

		for iter4_2, iter5_2 in pairs(var0_2) do
			local var1_2 = arg0_1._tf:Find("resources/" .. iter5_2)

			if iter5_2 == "meta_exp_tpl" then
				local var2_2 = var1_2:Find("ExpFull/Tip")

				setText(var2_2, i18n("meta_toast_fullexp"))

				local var3_2 = var1_2:Find("ExpAdd/Tip")

				setText(var3_2, i18n("meta_toast_tactics"))
			end

			setActive(var1_2, false)

			local var4_2 = var1_2.gameObject

			arg0_1.pools[iter4_2] = var1_0.New(var4_2, 5)
		end

		arg0_1:ResetUIDandHistory()

		if arg1_1 then
			arg1_1()
		end
	end, true, true)
end

function var0_0.ResetUIDandHistory(arg0_3)
	arg0_3.completedJob = 0
	arg0_3.actionJob = 0
	arg0_3.buffer = {}
end

function var0_0.ShowToast(arg0_4, arg1_4, arg2_4)
	local var0_4 = #arg0_4.buffer

	table.insert(arg0_4.buffer, {
		state = 0,
		type = arg1_4,
		info = arg2_4
	})
	setActive(arg0_4._tf, true)

	if #arg0_4.buffer == 1 or arg0_4.buffer[var0_4].state >= 2 then
		arg0_4:Toast()
	end
end

function var0_0.Toast(arg0_5)
	if arg0_5.actionJob >= #arg0_5.buffer then
		return
	end

	if arg0_5.buffer[arg0_5.actionJob] and arg0_5.buffer[arg0_5.actionJob].state < 2 then
		return
	elseif arg0_5.buffer[arg0_5.actionJob] and arg0_5.buffer[arg0_5.actionJob].type ~= arg0_5.buffer[arg0_5.actionJob + 1].type and arg0_5.buffer[arg0_5.actionJob].state < 3 then
		return
	end

	arg0_5.actionJob = arg0_5.actionJob + 1

	local var0_5 = arg0_5.buffer[arg0_5.actionJob]
	local var1_5 = arg0_5.actionJob

	var0_5.state = 1

	arg0_5["Update" .. var0_5.type](arg0_5, var0_5, function()
		var0_5.state = 2

		arg0_5:Toast()
	end, function()
		var0_5.state = 3

		if arg0_5.buffer[var1_5 + 1] and arg0_5.buffer[var1_5 + 1].state < 1 then
			arg0_5:Toast()
		end

		arg0_5.completedJob = arg0_5.completedJob + 1

		if arg0_5.completedJob >= #arg0_5.buffer then
			arg0_5:ResetUIDandHistory()
			setActive(arg0_5._tf, false)

			for iter0_7, iter1_7 in pairs(arg0_5.pools) do
				iter1_7:ClearItems(false)
			end
		end
	end)
end

function var0_0.GetAndSet(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.pools[arg1_8 .. "Tpl"]:Dequeue()

	setActive(var0_8, true)
	setParent(var0_8, arg2_8)
	var0_8.transform:SetAsLastSibling()

	return var0_8
end

function var0_0.UpdateAttire(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg0_9:GetAndSet(arg1_9.type, arg0_9.container)
	local var1_9 = var0_9:GetComponent(typeof(DftAniEvent))

	var1_9:SetTriggerEvent(function(arg0_10)
		if arg2_9 then
			arg2_9()
		end

		var1_9:SetTriggerEvent(nil)
	end)
	var1_9:SetEndEvent(function(arg0_11)
		setActive(var0_9, false)
		arg0_9.pools[arg1_9.type .. "Tpl"]:Enqueue(var0_9)
		var1_9:SetEndEvent(nil)

		if arg3_9 then
			arg3_9()
		end
	end)
	var0_9:GetComponent(typeof(Animation)):Play("attire")

	local var2_9 = arg1_9.info

	assert(isa(var2_9, AttireFrame))

	local var3_9 = var2_9:getType()

	setActive(var0_9.transform:Find("bg/icon_frame"), var3_9 == AttireConst.TYPE_ICON_FRAME)
	setActive(var0_9.transform:Find("bg/chat_frame"), var3_9 == AttireConst.TYPE_CHAT_FRAME)
	setText(var0_9.transform:Find("bg/Text"), HXSet.hxLan(var2_9:getConfig("name")))
end

function var0_0.UpdateCombatUI(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12:GetAndSet(arg1_12.type, arg0_12.container)
	local var1_12 = pg.item_data_battleui[arg1_12.info.id]

	LoadImageSpriteAsync("Props/" .. var1_12.display_icon, var0_12.transform:Find("content/icon"), true)
	setText(var0_12.transform:Find("content/name"), var1_12.name)
	setText(var0_12.transform:Find("content/label"), i18n("battle_ui_unlock"))

	local var2_12 = var0_12.transform:Find("content")

	var2_12.anchoredPosition = Vector2(-550, 0)

	LeanTween.moveX(rtf(var2_12), 0, 0.5)
	LeanTween.moveX(rtf(var2_12), -550, 0.5):setDelay(5):setOnComplete(System.Action(function()
		setActive(var0_12, false)
		arg0_12.pools[arg1_12.type .. "Tpl"]:Enqueue(var0_12)

		if arg3_12 then
			arg3_12()
		end
	end))

	if arg2_12 then
		arg2_12()
	end
end

function var0_0.UpdateEmoji(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg0_14:GetAndSet(arg1_14.type, arg0_14.container)
	local var1_14 = var0_14:GetComponent(typeof(DftAniEvent))

	var1_14:SetTriggerEvent(function(arg0_15)
		if arg2_14 then
			arg2_14()
		end

		var1_14:SetTriggerEvent(nil)
	end)
	var1_14:SetEndEvent(function(arg0_16)
		setActive(var0_14, false)
		arg0_14.pools[arg1_14.type .. "Tpl"]:Enqueue(var0_14)
		var1_14:SetEndEvent(nil)

		if arg3_14 then
			arg3_14()
		end
	end)
	var0_14:GetComponent(typeof(Animation)):Play("attire")

	local var2_14 = arg1_14.info

	setText(var0_14.transform:Find("bg/label"), i18n("word_emoji_unlock"))
	setText(var0_14.transform:Find("bg/Text"), i18n("word_get_emoji", var2_14.item_name))
end

var0_0.FADE_TIME = 0.4
var0_0.FADE_OUT_TIME = 1
var0_0.SHOW_TIME = 1.5
var0_0.DELAY_TIME = 0.3

function var0_0.UpdateTecpoint(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg1_17.info
	local var1_17 = var0_17.point
	local var2_17 = var0_17.typeList
	local var3_17 = var0_17.attr
	local var4_17 = var0_17.value
	local var5_17 = arg0_17:GetAndSet("Point", arg0_17.container)

	GetComponent(var5_17.transform, "CanvasGroup").alpha = 0

	setText(findTF(var5_17, "PointText"), "+" .. var1_17)

	local var6_17 = {}

	if var2_17 then
		for iter0_17 = 1, #var2_17 do
			local var7_17 = arg0_17:GetAndSet("Buff", arg0_17.container)

			GetComponent(var7_17.transform, "CanvasGroup").alpha = 0

			local var8_17 = var7_17.transform:Find("TypeImg")
			local var9_17 = var7_17.transform:Find("AttrText")
			local var10_17 = var7_17.transform:Find("ValueText")
			local var11_17 = var2_17[iter0_17]
			local var12_17 = GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var11_17)

			setImageSprite(var8_17.transform, var12_17)
			setText(var9_17.transform, AttributeType.Type2Name(pg.attribute_info_by_type[var3_17].name))
			setText(var10_17.transform, "+" .. var4_17)

			var6_17[iter0_17] = go(var7_17)
		end
	end

	local function var13_17()
		if arg2_17 then
			arg2_17()
		end

		if arg3_17 then
			arg3_17()
		end
	end

	local var14_17 = go(var5_17)
	local var15_17 = GetComponent(var5_17, "CanvasGroup")

	local function var16_17(arg0_19)
		var15_17.alpha = arg0_19
	end

	local function var17_17()
		LeanTween.moveX(rtf(var14_17), 0, var0_0.FADE_OUT_TIME)
		LeanTween.value(var14_17, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var16_17)):setOnComplete(System.Action(function()
			setActive(var5_17, false)
			arg0_17.pools.PointTpl:Enqueue(var5_17)

			if not var2_17 then
				var13_17()
			end
		end))
	end

	LeanTween.value(var14_17, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var16_17)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(var14_17, var0_0.SHOW_TIME, System.Action(var17_17))
	end))

	local function var18_17(arg0_23, arg1_23, arg2_23)
		local var0_23 = GetComponent(arg0_23.transform, "CanvasGroup")

		local function var1_23(arg0_24)
			var0_23.alpha = arg0_24
		end

		local function var2_23()
			LeanTween.moveX(rtf(arg0_23), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(arg0_23, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1_23)):setOnComplete(System.Action(function()
				setActive(arg0_23, false)
				arg0_17.pools.BuffTpl:Enqueue(arg0_23)

				if arg2_23 then
					var13_17()
				end
			end))
		end

		LeanTween.value(arg0_23, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var1_23)):setOnComplete(System.Action(function()
			LeanTween.delayedCall(arg0_23, var0_0.SHOW_TIME + (var0_0.FADE_OUT_TIME - var0_0.DELAY_TIME) * arg1_23, System.Action(var2_23))
		end))
	end

	for iter1_17, iter2_17 in ipairs(var6_17) do
		LeanTween.delayedCall(var14_17, iter1_17 * var0_0.DELAY_TIME, System.Action(function()
			var18_17(iter2_17, iter1_17, iter1_17 == #var6_17)
		end))
	end
end

function var0_0.UpdateTrophy(arg0_29, arg1_29, arg2_29, arg3_29)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_29.info.sound or SFX_UI_TIP)

	local var0_29 = arg0_29:GetAndSet(arg1_29.type, arg0_29.container)
	local var1_29 = pg.medal_template[arg1_29.info.id]

	LoadImageSpriteAsync("medal/s_" .. var1_29.icon, var0_29.transform:Find("content/icon"), true)
	setText(var0_29.transform:Find("content/name"), var1_29.name)
	setText(var0_29.transform:Find("content/label"), i18n("trophy_achieved"))

	local var2_29 = var0_29.transform:Find("content")

	var2_29.anchoredPosition = Vector2(-550, 0)

	LeanTween.moveX(rtf(var2_29), 0, 0.5)
	LeanTween.moveX(rtf(var2_29), -550, 0.5):setDelay(5):setOnComplete(System.Action(function()
		setActive(var0_29, false)
		arg0_29.pools[arg1_29.type .. "Tpl"]:Enqueue(var0_29)

		if arg3_29 then
			arg3_29()
		end
	end))

	if arg2_29 then
		arg2_29()
	end
end

function var0_0.UpdateMeta(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg1_31.info
	local var1_31 = var0_31.metaShipVO
	local var2_31 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(var1_31.configId)
	local var3_31 = arg0_31:GetAndSet("MetaExp", arg0_31.container)
	local var4_31 = arg0_31:GetAndSet("MetaLevel", arg0_31.container)
	local var5_31 = var3_31.transform:Find("ShipImg")
	local var6_31, var7_31 = MetaCharacterConst.GetMetaCharacterToastPath(var2_31)

	setImageSprite(var5_31, LoadSprite(var6_31, var7_31))

	local var8_31 = var3_31.transform:Find("Progress")
	local var9_31 = pg.gameset.meta_skill_exp_max.key_value
	local var10_31 = var0_31.newDayExp
	local var11_31 = var0_31.addDayExp
	local var12_31 = var9_31 <= var10_31

	setSlider(var8_31, 0, var9_31, var10_31)

	local var13_31 = var0_31.curSkillID
	local var14_31 = var0_31.oldSkillLevel
	local var15_31 = var0_31.newSkillLevel
	local var16_31 = var14_31 < var15_31
	local var17_31 = var3_31.transform:Find("ExpFull")
	local var18_31 = var3_31.transform:Find("ExpAdd")

	if var12_31 then
		setActive(var17_31, true)
		setActive(var18_31, false)
	else
		local var19_31 = var3_31.transform:Find("ExpAdd/Value")

		setText(var19_31, string.format("+%d", var11_31))
		setActive(var17_31, false)
		setActive(var18_31, var16_31)
	end

	if var16_31 then
		local var20_31 = var4_31.transform:Find("Skill/Icon")
		local var21_31 = getSkillConfig(var13_31)

		setImageSprite(var20_31, LoadSprite("skillicon/" .. var21_31.icon))

		local var22_31 = var4_31.transform:Find("LevelUp")
		local var23_31 = var4_31.transform:Find("LevelMax")

		if var15_31 >= pg.skill_data_template[var13_31].max_level then
			setActive(var22_31, false)
			setActive(var23_31, true)
		else
			local var24_31 = var4_31.transform:Find("LevelUp/Value")

			setText(var24_31, string.format("+%d", var15_31 - var14_31))
			setActive(var22_31, true)
			setActive(var23_31, false)
		end
	end

	local function var25_31()
		if arg2_31 then
			arg2_31()
		end

		if arg3_31 then
			arg3_31()
		end
	end

	local var26_31 = GetComponent(var3_31, "CanvasGroup")
	local var27_31 = GetComponent(var4_31, "CanvasGroup")

	var26_31.alpha = 0
	var27_31.alpha = 0

	if var12_31 or var16_31 then
		local function var28_31(arg0_33)
			var26_31.alpha = arg0_33
		end

		local function var29_31()
			LeanTween.moveX(rtf(var3_31.transform), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(var3_31, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var28_31)):setOnComplete(System.Action(function()
				arg0_31.pools.MetaExpTpl:Enqueue(var3_31)

				if not var16_31 then
					arg0_31.pools.MetaLevelTpl:Enqueue(var4_31)
					var25_31()
				end
			end))
		end

		local function var30_31()
			LeanTween.delayedCall(var3_31, var0_0.SHOW_TIME, System.Action(var29_31))
		end

		LeanTween.value(var3_31, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var28_31)):setOnComplete(System.Action(var30_31))
	end

	if var16_31 then
		local function var31_31(arg0_37)
			var27_31.alpha = arg0_37
		end

		local function var32_31()
			LeanTween.moveX(rtf(var4_31.transform), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(var4_31, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var31_31)):setOnComplete(System.Action(function()
				arg0_31.pools.MetaLevelTpl:Enqueue(var4_31)
				var25_31()
			end))
		end

		local function var33_31()
			LeanTween.delayedCall(var4_31, var0_0.SHOW_TIME, System.Action(var32_31))
		end

		LeanTween.delayedCall(var4_31, var0_0.DELAY_TIME, System.Action(function()
			LeanTween.value(var4_31, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var31_31)):setOnComplete(System.Action(var33_31))
		end))
	end
end

function var0_0.UpdateCrusing(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = arg1_42.info
	local var1_42 = var0_42.ptId
	local var2_42 = var0_42.ptCount

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_42.info.sound or SFX_UI_TIP)

	local var3_42 = tf(arg0_42:GetAndSet(arg1_42.type, arg0_42.container))
	local var4_42 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = var1_42
	})

	LoadImageSpriteAtlasAsync(var4_42:getIcon(), "", var3_42:Find("PointIcon"), true)
	setText(var3_42:Find("info/name"), var4_42:getName())
	setText(var3_42:Find("info/pt"), "+" .. var2_42)
	setAnchoredPosition(var3_42, {
		x = var3_42.rect.width
	})

	local var5_42 = GetComponent(var3_42, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5_42, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5_42, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var3_42, false)
			arg0_42.pools[arg1_42.type .. "Tpl"]:Enqueue(go(var3_42))

			if arg3_42 then
				arg3_42()
			end
		end))

		if arg2_42 then
			arg2_42()
		end
	end))
end

function var0_0.UpdateVote(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = arg1_45.info
	local var1_45 = var0_45.ptId
	local var2_45 = var0_45.ptCount
	local var3_45 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1_45
	})
	local var4_45 = tf(arg0_45:GetAndSet(arg1_45.type, arg0_45.container))

	LoadImageSpriteAtlasAsync(var3_45:getIcon(), "", var4_45:Find("PointIcon"), true)
	setText(var4_45:Find("info/name"), var3_45:getName())
	setText(var4_45:Find("info/pt"), "+" .. var2_45)
	setAnchoredPosition(var4_45, {
		x = var4_45.rect.width
	})

	local var5_45 = GetComponent(var4_45, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5_45, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5_45, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var4_45, false)
			arg0_45.pools[arg1_45.type .. "Tpl"]:Enqueue(go(var4_45))

			if arg3_45 then
				arg3_45()
			end
		end))

		if arg2_45 then
			arg2_45()
		end
	end))
end

function var0_0.UpdateCover(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = arg0_48:GetAndSet(arg1_48.type, arg0_48.container)
	local var1_48 = var0_48:GetComponent(typeof(DftAniEvent))

	var1_48:SetTriggerEvent(function(arg0_49)
		if arg2_48 then
			arg2_48()
		end

		var1_48:SetTriggerEvent(nil)
	end)
	var1_48:SetEndEvent(function(arg0_50)
		setActive(var0_48, false)
		arg0_48.pools[arg1_48.type .. "Tpl"]:Enqueue(var0_48)
		var1_48:SetEndEvent(nil)

		if arg3_48 then
			arg3_48()
		end
	end)
	var0_48:GetComponent(typeof(Animation)):Play("attire")

	local var2_48 = arg1_48.info

	setText(var0_48.transform:Find("bg/Text"), HXSet.hxLan(var2_48:getConfig("get_tips")))
end

function var0_0.Dispose(arg0_51)
	setActive(arg0_51._tf, false)
	arg0_51:ResetUIDandHistory()

	for iter0_51, iter1_51 in pairs(arg0_51.pools) do
		iter1_51:Clear(false)
	end
end
