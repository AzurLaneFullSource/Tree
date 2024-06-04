pg = pg or {}
pg.ToastMgr = singletonClass("ToastMgr")

local var0 = pg.ToastMgr
local var1 = require("Mgr/Pool/PoolPlural")

var0.TYPE_ATTIRE = "Attire"
var0.TYPE_TECPOINT = "Tecpoint"
var0.TYPE_TROPHY = "Trophy"
var0.TYPE_META = "Meta"
var0.TYPE_CRUSING = "Crusing"
var0.TYPE_VOTE = "Vote"
var0.TYPE_EMOJI = "Emoji"
var0.ToastInfo = {
	[var0.TYPE_ATTIRE] = {
		Attire = "attire_tpl"
	},
	[var0.TYPE_TECPOINT] = {
		Buff = "buff_tpl",
		Point = "point_tpl"
	},
	[var0.TYPE_TROPHY] = {
		Trophy = "trophy_tpl"
	},
	[var0.TYPE_META] = {
		MetaLevel = "meta_level_tpl",
		MetaExp = "meta_exp_tpl"
	},
	[var0.TYPE_CRUSING] = {
		Crusing = "crusing_pt_tpl"
	},
	[var0.TYPE_VOTE] = {
		Vote = "vote_tpl"
	},
	[var0.TYPE_EMOJI] = {
		Emoji = "emoji_tpl"
	}
}

function var0.Init(arg0, arg1)
	PoolMgr.GetInstance():GetUI("ToastUI", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform
		arg0.container = arg0._tf:Find("container")

		arg0._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0.pools = {}

		local var0 = {}

		for iter0, iter1 in pairs(var0.ToastInfo) do
			for iter2, iter3 in pairs(iter1) do
				var0[iter2 .. "Tpl"] = iter3
			end
		end

		for iter4, iter5 in pairs(var0) do
			local var1 = arg0._tf:Find("resources/" .. iter5)

			if iter5 == "meta_exp_tpl" then
				local var2 = var1:Find("ExpFull/Tip")

				setText(var2, i18n("meta_toast_fullexp"))

				local var3 = var1:Find("ExpAdd/Tip")

				setText(var3, i18n("meta_toast_tactics"))
			end

			setActive(var1, false)

			local var4 = var1.gameObject

			arg0.pools[iter4] = var1.New(var4, 5)
		end

		arg0:ResetUIDandHistory()

		if arg1 then
			arg1()
		end
	end)
end

function var0.ResetUIDandHistory(arg0)
	arg0.completedJob = 0
	arg0.actionJob = 0
	arg0.buffer = {}
end

function var0.ShowToast(arg0, arg1, arg2)
	local var0 = #arg0.buffer

	table.insert(arg0.buffer, {
		state = 0,
		type = arg1,
		info = arg2
	})
	setActive(arg0._tf, true)

	if #arg0.buffer == 1 or arg0.buffer[var0].state >= 2 then
		arg0:Toast()
	end
end

function var0.Toast(arg0)
	if arg0.actionJob >= #arg0.buffer then
		return
	end

	if arg0.buffer[arg0.actionJob] and arg0.buffer[arg0.actionJob].state < 2 then
		return
	elseif arg0.buffer[arg0.actionJob] and arg0.buffer[arg0.actionJob].type ~= arg0.buffer[arg0.actionJob + 1].type and arg0.buffer[arg0.actionJob].state < 3 then
		return
	end

	arg0.actionJob = arg0.actionJob + 1

	local var0 = arg0.buffer[arg0.actionJob]
	local var1 = arg0.actionJob

	var0.state = 1

	arg0["Update" .. var0.type](arg0, var0, function()
		var0.state = 2

		arg0:Toast()
	end, function()
		var0.state = 3

		if arg0.buffer[var1 + 1] and arg0.buffer[var1 + 1].state < 1 then
			arg0:Toast()
		end

		arg0.completedJob = arg0.completedJob + 1

		if arg0.completedJob >= #arg0.buffer then
			arg0:ResetUIDandHistory()
			setActive(arg0._tf, false)

			for iter0, iter1 in pairs(arg0.pools) do
				iter1:ClearItems(false)
			end
		end
	end)
end

function var0.GetAndSet(arg0, arg1, arg2)
	local var0 = arg0.pools[arg1 .. "Tpl"]:Dequeue()

	setActive(var0, true)
	setParent(var0, arg2)
	var0.transform:SetAsLastSibling()

	return var0
end

function var0.UpdateAttire(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetAndSet(arg1.type, arg0.container)
	local var1 = var0:GetComponent(typeof(DftAniEvent))

	var1:SetTriggerEvent(function(arg0)
		if arg2 then
			arg2()
		end

		var1:SetTriggerEvent(nil)
	end)
	var1:SetEndEvent(function(arg0)
		setActive(var0, false)
		arg0.pools[arg1.type .. "Tpl"]:Enqueue(var0)
		var1:SetEndEvent(nil)

		if arg3 then
			arg3()
		end
	end)
	var0:GetComponent(typeof(Animation)):Play("attire")

	local var2 = arg1.info

	assert(isa(var2, AttireFrame))

	local var3 = var2:getType()

	setActive(var0.transform:Find("bg/icon_frame"), var3 == AttireConst.TYPE_ICON_FRAME)
	setActive(var0.transform:Find("bg/chat_frame"), var3 == AttireConst.TYPE_CHAT_FRAME)
	setText(var0.transform:Find("bg/Text"), HXSet.hxLan(var2:getConfig("name")))
end

function var0.UpdateEmoji(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetAndSet(arg1.type, arg0.container)
	local var1 = var0:GetComponent(typeof(DftAniEvent))

	var1:SetTriggerEvent(function(arg0)
		if arg2 then
			arg2()
		end

		var1:SetTriggerEvent(nil)
	end)
	var1:SetEndEvent(function(arg0)
		setActive(var0, false)
		arg0.pools[arg1.type .. "Tpl"]:Enqueue(var0)
		var1:SetEndEvent(nil)

		if arg3 then
			arg3()
		end
	end)
	var0:GetComponent(typeof(Animation)):Play("attire")

	local var2 = arg1.info

	setText(var0.transform:Find("bg/label"), i18n("word_emoji_unlock"))
	setText(var0.transform:Find("bg/Text"), i18n("word_get_emoji", var2.item_name))
end

var0.FADE_TIME = 0.4
var0.FADE_OUT_TIME = 1
var0.SHOW_TIME = 1.5
var0.DELAY_TIME = 0.3

function var0.UpdateTecpoint(arg0, arg1, arg2, arg3)
	local var0 = arg1.info
	local var1 = var0.point
	local var2 = var0.typeList
	local var3 = var0.attr
	local var4 = var0.value
	local var5 = arg0:GetAndSet("Point", arg0.container)

	GetComponent(var5.transform, "CanvasGroup").alpha = 0

	setText(findTF(var5, "PointText"), "+" .. var1)

	local var6 = {}

	if var2 then
		for iter0 = 1, #var2 do
			local var7 = arg0:GetAndSet("Buff", arg0.container)

			GetComponent(var7.transform, "CanvasGroup").alpha = 0

			local var8 = var7.transform:Find("TypeImg")
			local var9 = var7.transform:Find("AttrText")
			local var10 = var7.transform:Find("ValueText")
			local var11 = var2[iter0]
			local var12 = GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var11)

			setImageSprite(var8.transform, var12)
			setText(var9.transform, AttributeType.Type2Name(pg.attribute_info_by_type[var3].name))
			setText(var10.transform, "+" .. var4)

			var6[iter0] = go(var7)
		end
	end

	local function var13()
		if arg2 then
			arg2()
		end

		if arg3 then
			arg3()
		end
	end

	local var14 = go(var5)
	local var15 = GetComponent(var5, "CanvasGroup")

	local function var16(arg0)
		var15.alpha = arg0
	end

	local function var17()
		LeanTween.moveX(rtf(var14), 0, var0.FADE_OUT_TIME)
		LeanTween.value(var14, 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var16)):setOnComplete(System.Action(function()
			setActive(var5, false)
			arg0.pools.PointTpl:Enqueue(var5)

			if not var2 then
				var13()
			end
		end))
	end

	LeanTween.value(var14, 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var16)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(var14, var0.SHOW_TIME, System.Action(var17))
	end))

	local function var18(arg0, arg1, arg2)
		local var0 = GetComponent(arg0.transform, "CanvasGroup")

		local function var1(arg0)
			var0.alpha = arg0
		end

		local function var2()
			LeanTween.moveX(rtf(arg0), 0, var0.FADE_OUT_TIME)
			LeanTween.value(arg0, 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
				setActive(arg0, false)
				arg0.pools.BuffTpl:Enqueue(arg0)

				if arg2 then
					var13()
				end
			end))
		end

		LeanTween.value(arg0, 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
			LeanTween.delayedCall(arg0, var0.SHOW_TIME + (var0.FADE_OUT_TIME - var0.DELAY_TIME) * arg1, System.Action(var2))
		end))
	end

	for iter1, iter2 in ipairs(var6) do
		LeanTween.delayedCall(var14, iter1 * var0.DELAY_TIME, System.Action(function()
			var18(iter2, iter1, iter1 == #var6)
		end))
	end
end

function var0.UpdateTrophy(arg0, arg1, arg2, arg3)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1.info.sound or SFX_UI_TIP)

	local var0 = arg0:GetAndSet(arg1.type, arg0.container)
	local var1 = pg.medal_template[arg1.info.id]

	LoadImageSpriteAsync("medal/s_" .. var1.icon, var0.transform:Find("content/icon"), true)
	setText(var0.transform:Find("content/name"), var1.name)
	setText(var0.transform:Find("content/label"), i18n("trophy_achieved"))

	local var2 = var0.transform:Find("content")

	var2.anchoredPosition = Vector2(-550, 0)

	LeanTween.moveX(rtf(var2), 0, 0.5)
	LeanTween.moveX(rtf(var2), -550, 0.5):setDelay(5):setOnComplete(System.Action(function()
		setActive(var0, false)
		arg0.pools[arg1.type .. "Tpl"]:Enqueue(var0)

		if arg3 then
			arg3()
		end
	end))

	if arg2 then
		arg2()
	end
end

function var0.UpdateMeta(arg0, arg1, arg2, arg3)
	local var0 = arg1.info
	local var1 = var0.metaShipVO
	local var2 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(var1.configId)
	local var3 = arg0:GetAndSet("MetaExp", arg0.container)
	local var4 = arg0:GetAndSet("MetaLevel", arg0.container)
	local var5 = var3.transform:Find("ShipImg")
	local var6, var7 = MetaCharacterConst.GetMetaCharacterToastPath(var2)

	setImageSprite(var5, LoadSprite(var6, var7))

	local var8 = var3.transform:Find("Progress")
	local var9 = pg.gameset.meta_skill_exp_max.key_value
	local var10 = var0.newDayExp
	local var11 = var0.addDayExp
	local var12 = var9 <= var10

	setSlider(var8, 0, var9, var10)

	local var13 = var0.curSkillID
	local var14 = var0.oldSkillLevel
	local var15 = var0.newSkillLevel
	local var16 = var14 < var15
	local var17 = var3.transform:Find("ExpFull")
	local var18 = var3.transform:Find("ExpAdd")

	if var12 then
		setActive(var17, true)
		setActive(var18, false)
	else
		local var19 = var3.transform:Find("ExpAdd/Value")

		setText(var19, string.format("+%d", var11))
		setActive(var17, false)
		setActive(var18, var16)
	end

	if var16 then
		local var20 = var4.transform:Find("Skill/Icon")
		local var21 = getSkillConfig(var13)

		setImageSprite(var20, LoadSprite("skillicon/" .. var21.icon))

		local var22 = var4.transform:Find("LevelUp")
		local var23 = var4.transform:Find("LevelMax")

		if var15 >= pg.skill_data_template[var13].max_level then
			setActive(var22, false)
			setActive(var23, true)
		else
			local var24 = var4.transform:Find("LevelUp/Value")

			setText(var24, string.format("+%d", var15 - var14))
			setActive(var22, true)
			setActive(var23, false)
		end
	end

	local function var25()
		if arg2 then
			arg2()
		end

		if arg3 then
			arg3()
		end
	end

	local var26 = GetComponent(var3, "CanvasGroup")
	local var27 = GetComponent(var4, "CanvasGroup")

	var26.alpha = 0
	var27.alpha = 0

	if var12 or var16 then
		local function var28(arg0)
			var26.alpha = arg0
		end

		local function var29()
			LeanTween.moveX(rtf(var3.transform), 0, var0.FADE_OUT_TIME)
			LeanTween.value(var3, 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var28)):setOnComplete(System.Action(function()
				arg0.pools.MetaExpTpl:Enqueue(var3)

				if not var16 then
					arg0.pools.MetaLevelTpl:Enqueue(var4)
					var25()
				end
			end))
		end

		local function var30()
			LeanTween.delayedCall(var3, var0.SHOW_TIME, System.Action(var29))
		end

		LeanTween.value(var3, 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var28)):setOnComplete(System.Action(var30))
	end

	if var16 then
		local function var31(arg0)
			var27.alpha = arg0
		end

		local function var32()
			LeanTween.moveX(rtf(var4.transform), 0, var0.FADE_OUT_TIME)
			LeanTween.value(var4, 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var31)):setOnComplete(System.Action(function()
				arg0.pools.MetaLevelTpl:Enqueue(var4)
				var25()
			end))
		end

		local function var33()
			LeanTween.delayedCall(var4, var0.SHOW_TIME, System.Action(var32))
		end

		LeanTween.delayedCall(var4, var0.DELAY_TIME, System.Action(function()
			LeanTween.value(var4, 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var31)):setOnComplete(System.Action(var33))
		end))
	end
end

function var0.UpdateCrusing(arg0, arg1, arg2, arg3)
	local var0 = arg1.info
	local var1 = var0.ptId
	local var2 = var0.ptCount

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1.info.sound or SFX_UI_TIP)

	local var3 = tf(arg0:GetAndSet(arg1.type, arg0.container))
	local var4 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var1
	})

	LoadImageSpriteAtlasAsync(var4:getIcon(), "", var3:Find("PointIcon"), true)
	setText(var3:Find("info/name"), var4:getName())
	setText(var3:Find("info/pt"), "+" .. var2)
	setAnchoredPosition(var3, {
		x = var3.rect.width
	})

	local var5 = GetComponent(var3, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var3, false)
			arg0.pools[arg1.type .. "Tpl"]:Enqueue(go(var3))

			if arg3 then
				arg3()
			end
		end))

		if arg2 then
			arg2()
		end
	end))
end

function var0.UpdateVote(arg0, arg1, arg2, arg3)
	local var0 = arg1.info
	local var1 = var0.ptId
	local var2 = var0.ptCount
	local var3 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var1
	})
	local var4 = tf(arg0:GetAndSet(arg1.type, arg0.container))

	LoadImageSpriteAtlasAsync(var3:getIcon(), "", var4:Find("PointIcon"), true)
	setText(var4:Find("info/name"), var3:getName())
	setText(var4:Find("info/pt"), "+" .. var2)
	setAnchoredPosition(var4, {
		x = var4.rect.width
	})

	local var5 = GetComponent(var4, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var5, 1, 0.5):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.alphaCanvas(var5, 0, 0.5):setDelay(5):setOnComplete(System.Action(function()
			setActive(var4, false)
			arg0.pools[arg1.type .. "Tpl"]:Enqueue(go(var4))

			if arg3 then
				arg3()
			end
		end))

		if arg2 then
			arg2()
		end
	end))
end

function var0.Dispose(arg0)
	setActive(arg0._tf, false)
	arg0:ResetUIDandHistory()

	for iter0, iter1 in pairs(arg0.pools) do
		iter1:Clear(false)
	end
end
