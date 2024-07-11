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
	}
}

function var0_0.Init(arg0_1, arg1_1)
	PoolMgr.GetInstance():GetUI("ToastUI", true, function(arg0_2)
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
	end)
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

function var0_0.UpdateEmoji(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12:GetAndSet(arg1_12.type, arg0_12.container)
	local var1_12 = var0_12:GetComponent(typeof(DftAniEvent))

	var1_12:SetTriggerEvent(function(arg0_13)
		if arg2_12 then
			arg2_12()
		end

		var1_12:SetTriggerEvent(nil)
	end)
	var1_12:SetEndEvent(function(arg0_14)
		setActive(var0_12, false)
		arg0_12.pools[arg1_12.type .. "Tpl"]:Enqueue(var0_12)
		var1_12:SetEndEvent(nil)

		if arg3_12 then
			arg3_12()
		end
	end)
	var0_12:GetComponent(typeof(Animation)):Play("attire")

	local var2_12 = arg1_12.info

	setText(var0_12.transform:Find("bg/label"), i18n("word_emoji_unlock"))
	setText(var0_12.transform:Find("bg/Text"), i18n("word_get_emoji", var2_12.item_name))
end

var0_0.FADE_TIME = 0.4
var0_0.FADE_OUT_TIME = 1
var0_0.SHOW_TIME = 1.5
var0_0.DELAY_TIME = 0.3

function var0_0.UpdateTecpoint(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg1_15.info
	local var1_15 = var0_15.point
	local var2_15 = var0_15.typeList
	local var3_15 = var0_15.attr
	local var4_15 = var0_15.value
	local var5_15 = arg0_15:GetAndSet("Point", arg0_15.container)

	GetComponent(var5_15.transform, "CanvasGroup").alpha = 0

	setText(findTF(var5_15, "PointText"), "+" .. var1_15)

	local var6_15 = {}

	if var2_15 then
		for iter0_15 = 1, #var2_15 do
			local var7_15 = arg0_15:GetAndSet("Buff", arg0_15.container)

			GetComponent(var7_15.transform, "CanvasGroup").alpha = 0

			local var8_15 = var7_15.transform:Find("TypeImg")
			local var9_15 = var7_15.transform:Find("AttrText")
			local var10_15 = var7_15.transform:Find("ValueText")
			local var11_15 = var2_15[iter0_15]
			local var12_15 = GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var11_15)

			setImageSprite(var8_15.transform, var12_15)
			setText(var9_15.transform, AttributeType.Type2Name(pg.attribute_info_by_type[var3_15].name))
			setText(var10_15.transform, "+" .. var4_15)

			var6_15[iter0_15] = go(var7_15)
		end
	end

	local function var13_15()
		if arg2_15 then
			arg2_15()
		end

		if arg3_15 then
			arg3_15()
		end
	end

	local var14_15 = go(var5_15)
	local var15_15 = GetComponent(var5_15, "CanvasGroup")

	local function var16_15(arg0_17)
		var15_15.alpha = arg0_17
	end

	local function var17_15()
		LeanTween.moveX(rtf(var14_15), 0, var0_0.FADE_OUT_TIME)
		LeanTween.value(var14_15, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var16_15)):setOnComplete(System.Action(function()
			setActive(var5_15, false)
			arg0_15.pools.PointTpl:Enqueue(var5_15)

			if not var2_15 then
				var13_15()
			end
		end))
	end

	LeanTween.value(var14_15, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var16_15)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(var14_15, var0_0.SHOW_TIME, System.Action(var17_15))
	end))

	local function var18_15(arg0_21, arg1_21, arg2_21)
		local var0_21 = GetComponent(arg0_21.transform, "CanvasGroup")

		local function var1_21(arg0_22)
			var0_21.alpha = arg0_22
		end

		local function var2_21()
			LeanTween.moveX(rtf(arg0_21), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(arg0_21, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1_21)):setOnComplete(System.Action(function()
				setActive(arg0_21, false)
				arg0_15.pools.BuffTpl:Enqueue(arg0_21)

				if arg2_21 then
					var13_15()
				end
			end))
		end

		LeanTween.value(arg0_21, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var1_21)):setOnComplete(System.Action(function()
			LeanTween.delayedCall(arg0_21, var0_0.SHOW_TIME + (var0_0.FADE_OUT_TIME - var0_0.DELAY_TIME) * arg1_21, System.Action(var2_21))
		end))
	end

	for iter1_15, iter2_15 in ipairs(var6_15) do
		LeanTween.delayedCall(var14_15, iter1_15 * var0_0.DELAY_TIME, System.Action(function()
			var18_15(iter2_15, iter1_15, iter1_15 == #var6_15)
		end))
	end
end

function var0_0.UpdateTrophy(arg0_27, arg1_27, arg2_27, arg3_27)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_27.info.sound or SFX_UI_TIP)

	local var0_27 = arg0_27:GetAndSet(arg1_27.type, arg0_27.container)
	local var1_27 = pg.medal_template[arg1_27.info.id]

	LoadImageSpriteAsync("medal/s_" .. var1_27.icon, var0_27.transform:Find("content/icon"), true)
	setText(var0_27.transform:Find("content/name"), var1_27.name)
	setText(var0_27.transform:Find("content/label"), i18n("trophy_achieved"))

	local var2_27 = var0_27.transform:Find("content")

	var2_27.anchoredPosition = Vector2(-550, 0)

	LeanTween.moveX(rtf(var2_27), 0, 0.5)
	LeanTween.moveX(rtf(var2_27), -550, 0.5):setDelay(5):setOnComplete(System.Action(function()
		setActive(var0_27, false)
		arg0_27.pools[arg1_27.type .. "Tpl"]:Enqueue(var0_27)

		if arg3_27 then
			arg3_27()
		end
	end))

	if arg2_27 then
		arg2_27()
	end
end

function var0_0.UpdateMeta(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg1_29.info
	local var1_29 = var0_29.metaShipVO
	local var2_29 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(var1_29.configId)
	local var3_29 = arg0_29:GetAndSet("MetaExp", arg0_29.container)
	local var4_29 = arg0_29:GetAndSet("MetaLevel", arg0_29.container)
	local var5_29 = var3_29.transform:Find("ShipImg")
	local var6_29, var7_29 = MetaCharacterConst.GetMetaCharacterToastPath(var2_29)

	setImageSprite(var5_29, LoadSprite(var6_29, var7_29))

	local var8_29 = var3_29.transform:Find("Progress")
	local var9_29 = pg.gameset.meta_skill_exp_max.key_value
	local var10_29 = var0_29.newDayExp
	local var11_29 = var0_29.addDayExp
	local var12_29 = var9_29 <= var10_29

	setSlider(var8_29, 0, var9_29, var10_29)

	local var13_29 = var0_29.curSkillID
	local var14_29 = var0_29.oldSkillLevel
	local var15_29 = var0_29.newSkillLevel
	local var16_29 = var14_29 < var15_29
	local var17_29 = var3_29.transform:Find("ExpFull")
	local var18_29 = var3_29.transform:Find("ExpAdd")

	if var12_29 then
		setActive(var17_29, true)
		setActive(var18_29, false)
	else
		local var19_29 = var3_29.transform:Find("ExpAdd/Value")

		setText(var19_29, string.format("+%d", var11_29))
		setActive(var17_29, false)
		setActive(var18_29, var16_29)
	end

	if var16_29 then
		local var20_29 = var4_29.transform:Find("Skill/Icon")
		local var21_29 = getSkillConfig(var13_29)

		setImageSprite(var20_29, LoadSprite("skillicon/" .. var21_29.icon))

		local var22_29 = var4_29.transform:Find("LevelUp")
		local var23_29 = var4_29.transform:Find("LevelMax")

		if var15_29 >= pg.skill_data_template[var13_29].max_level then
			setActive(var22_29, false)
			setActive(var23_29, true)
		else
			local var24_29 = var4_29.transform:Find("LevelUp/Value")

			setText(var24_29, string.format("+%d", var15_29 - var14_29))
			setActive(var22_29, true)
			setActive(var23_29, false)
		end
	end

	local function var25_29()
		if arg2_29 then
			arg2_29()
		end

		if arg3_29 then
			arg3_29()
		end
	end

	local var26_29 = GetComponent(var3_29, "CanvasGroup")
	local var27_29 = GetComponent(var4_29, "CanvasGroup")

	var26_29.alpha = 0
	var27_29.alpha = 0

	if var12_29 or var16_29 then
		local function var28_29(arg0_31)
			var26_29.alpha = arg0_31
		end

		local function var29_29()
			LeanTween.moveX(rtf(var3_29.transform), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(var3_29, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var28_29)):setOnComplete(System.Action(function()
				arg0_29.pools.MetaExpTpl:Enqueue(var3_29)

				if not var16_29 then
					arg0_29.pools.MetaLevelTpl:Enqueue(var4_29)
					var25_29()
				end
			end))
		end

		local function var30_29()
			LeanTween.delayedCall(var3_29, var0_0.SHOW_TIME, System.Action(var29_29))
		end

		LeanTween.value(var3_29, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var28_29)):setOnComplete(System.Action(var30_29))
	end

	if var16_29 then
		local function var31_29(arg0_35)
			var27_29.alpha = arg0_35
		end

		local function var32_29()
			LeanTween.moveX(rtf(var4_29.transform), 0, var0_0.FADE_OUT_TIME)
			LeanTween.value(var4_29, 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var31_29)):setOnComplete(System.Action(function()
				arg0_29.pools.MetaLevelTpl:Enqueue(var4_29)
				var25_29()
			end))
		end

		local function var33_29()
			LeanTween.delayedCall(var4_29, var0_0.SHOW_TIME, System.Action(var32_29))
		end

		LeanTween.delayedCall(var4_29, var0_0.DELAY_TIME, System.Action(function()
			LeanTween.value(var4_29, 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var31_29)):setOnComplete(System.Action(var33_29))
		end))
	end
end

function var0_0.UpdateCrusing(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg1_40.info
	local var1_40 = var0_40.ptId
	local var2_40 = var0_40.ptCount

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_40.info.sound or SFX_UI_TIP)

	local var3_40 = tf(arg0_40:GetAndSet(arg1_40.type, arg0_40.container))
	local var4_40 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = var1_40
	})

	LoadImageSpriteAtlasAsync(var4_40:getIcon(), "", var3_40:Find("PointIcon"), true)
	setText(var3_40:Find("info/name"), var4_40:getName())
	setText(var3_40:Find("info/pt"), "+" .. var2_40)
	setAnchoredPosition(var3_40, {
		x = var3_40.rect.width
	})

	local var5_40 = GetComponent(var3_40, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5_40, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5_40, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var3_40, false)
			arg0_40.pools[arg1_40.type .. "Tpl"]:Enqueue(go(var3_40))

			if arg3_40 then
				arg3_40()
			end
		end))

		if arg2_40 then
			arg2_40()
		end
	end))
end

function var0_0.UpdateVote(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg1_43.info
	local var1_43 = var0_43.ptId
	local var2_43 = var0_43.ptCount
	local var3_43 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1_43
	})
	local var4_43 = tf(arg0_43:GetAndSet(arg1_43.type, arg0_43.container))

	LoadImageSpriteAtlasAsync(var3_43:getIcon(), "", var4_43:Find("PointIcon"), true)
	setText(var4_43:Find("info/name"), var3_43:getName())
	setText(var4_43:Find("info/pt"), "+" .. var2_43)
	setAnchoredPosition(var4_43, {
		x = var4_43.rect.width
	})

	local var5_43 = GetComponent(var4_43, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5_43, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5_43, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var4_43, false)
			arg0_43.pools[arg1_43.type .. "Tpl"]:Enqueue(go(var4_43))

			if arg3_43 then
				arg3_43()
			end
		end))

		if arg2_43 then
			arg2_43()
		end
	end))
end

function var0_0.Dispose(arg0_46)
	setActive(arg0_46._tf, false)
	arg0_46:ResetUIDandHistory()

	for iter0_46, iter1_46 in pairs(arg0_46.pools) do
		iter1_46:Clear(false)
	end
end
