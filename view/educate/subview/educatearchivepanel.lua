local var0_0 = class("EducateArchivePanel", import("...base.BaseSubView"))
local var1_0 = 0.005

function var0_0.getUIName(arg0_1)
	return "EducateArchivePanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.config = pg.child_attr
	arg0_2.foldPanelTF = arg0_2:findTF("fold_panel")
	arg0_2.showBtn = arg0_2:findTF("show_btn", arg0_2.foldPanelTF)
	arg0_2.showPanelTF = arg0_2:findTF("show_panel")
	arg0_2.showAnim = arg0_2.showPanelTF:GetComponent(typeof(Animation))
	arg0_2.showAnimEvent = arg0_2.showPanelTF:GetComponent(typeof(DftAniEvent))

	arg0_2.showAnimEvent:SetEndEvent(function()
		setActive(arg0_2.showPanelTF, false)
	end)

	arg0_2.blurBg = arg0_2:findTF("panel", arg0_2.showPanelTF)
	arg0_2.foldBtn = arg0_2:findTF("fold_btn", arg0_2.showPanelTF)
	arg0_2.pageSnap = arg0_2:findTF("panel/event", arg0_2.showPanelTF):GetComponent("HScrollSnap")

	arg0_2.pageSnap:Init()

	arg0_2.page1 = arg0_2:findTF("panel/event/content/page1", arg0_2.showPanelTF)

	setText(arg0_2:findTF("title/name_title/name", arg0_2.page1), i18n("child_archive_name"))
	setText(arg0_2:findTF("attr_title/Text", arg0_2.page1), i18n("child_attr_name1"))
	setText(arg0_2:findTF("buff_title/Text", arg0_2.page1), i18n("child_buff_name"))

	arg0_2.avatarImageTF = arg0_2:findTF("title/avatar", arg0_2.page1)
	arg0_2.attrsList1 = UIItemList.New(arg0_2:findTF("attrs/content", arg0_2.page1), arg0_2:findTF("attrs/tpl", arg0_2.page1))
	arg0_2.gradientBgTF = arg0_2:findTF("attrs/bg_gradient", arg0_2.page1)
	arg0_2.buffContentTF = arg0_2:findTF("buff/content", arg0_2.page1)
	arg0_2.buffItemList = UIItemList.New(arg0_2:findTF("buff/content/content", arg0_2.page1), arg0_2:findTF("buff/tpl", arg0_2.page1))
	arg0_2.buffLockTF = arg0_2:findTF("buff/lock", arg0_2.page1)
	arg0_2.page2 = arg0_2:findTF("panel/event/content/page2", arg0_2.showPanelTF)

	setText(arg0_2:findTF("attr_title/Text", arg0_2.page2), i18n("child_attr_name2"))

	arg0_2.attr3UnlockTF = arg0_2:findTF("attrs/unlock", arg0_2.page2)
	arg0_2.attr3LockTF = arg0_2:findTF("attrs/lock", arg0_2.page2)
	arg0_2.attrsList2 = UIItemList.New(arg0_2:findTF("content", arg0_2.attr3UnlockTF), arg0_2:findTF("tpl", arg0_2.attr3UnlockTF))
	arg0_2.attr2UnlockTF = arg0_2:findTF("nature/unlock", arg0_2.page2)
	arg0_2.attr2LockTF = arg0_2:findTF("nature/lock", arg0_2.page2)
	arg0_2.natureContent = arg0_2:findTF("content", arg0_2.attr2UnlockTF)
	arg0_2.avatarTF = arg0_2:findTF("avatar", arg0_2.page2)

	arg0_2:addListener()
	arg0_2:initAttrsPanel()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
		pbList = {
			arg0_2.blurBg
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER - 1
	})
	setActive(arg0_2.foldPanelTF, true)
	setActive(arg0_2.showPanelTF, false)

	if arg0_2.contextData and arg0_2.contextData.isShow then
		if arg0_2.contextData.isMainEnter then
			onDelayTick(function()
				arg0_2:showPanel()
			end, 0.396)
		else
			arg0_2:showPanel()
		end
	end
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.showBtn, function()
		arg0_5:showPanel()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.foldBtn, function()
		arg0_5:hidePanel()
	end, SFX_PANEL)
end

function var0_0.showPanel(arg0_8)
	setActive(arg0_8.foldPanelTF, false)
	setActive(arg0_8.showPanelTF, true)
end

function var0_0.hidePanel(arg0_9)
	setActive(arg0_9.foldPanelTF, true)
	arg0_9.showAnim:Play("anim_educate_archive_show_out")
end

function var0_0.initAttrsPanel(arg0_10)
	arg0_10.attrsList1:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:updateAttr1Item(arg1_11, arg2_11)
		end
	end)
	arg0_10.buffItemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_10:updateBuffItem(arg1_12, arg2_12)
		end
	end)
	arg0_10.attrsList2:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_10:updateAttr2Item(arg1_13, arg2_13)
		end
	end)
	arg0_10:Flush()
end

function var0_0.updateAttr1Item(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MAJOR)[arg1_14 + 1][1]
	local var1_14 = arg0_14.config[var0_14]

	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_14, arg0_14:findTF("icon_bg/icon", arg2_14), true)
	setScrollText(arg0_14:findTF("name_mask/name", arg2_14), var1_14.name)

	local var2_14, var3_14 = arg0_14.char:GetAttrInfo(var0_14)

	setText(arg0_14:findTF("grade/Text", arg2_14), var2_14)
	setText(arg0_14:findTF("value", arg2_14), var3_14)

	local var4_14 = EducateConst.GRADE_2_COLOR[var2_14][1]
	local var5_14 = EducateConst.GRADE_2_COLOR[var2_14][2]
	local var6_14 = arg0_14.gradientBgTF:GetChild(arg1_14)

	setImageColor(var6_14, Color.NewHex(var4_14))
	setImageColor(arg0_14:findTF("grade", arg2_14), Color.NewHex(var5_14))
end

function var0_0.updateBuffItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.buffList[arg1_15 + 1]

	LoadImageSpriteAsync("educateprops/" .. var0_15:getConfig("icon"), arg0_15:findTF("icon", arg2_15))
	setText(arg0_15:findTF("time/Text", arg2_15), var0_15:GetReaminWeek() .. i18n("word_week"))
	onButton(arg0_15, arg2_15, function()
		arg0_15:showBuffBox(var0_15.id)
	end, SFX_PANEL)
end

function var0_0.showBuffBox(arg0_17, arg1_17)
	arg0_17:emit(EducateBaseUI.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_BUFF,
			id = arg1_17
		}
	})
end

function var0_0.updateAttr2Item(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MINOR)[arg1_18 + 1][1]
	local var1_18 = arg0_18.config[var0_18]

	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_18, arg0_18:findTF("icon", arg2_18), true)
	setText(arg0_18:findTF("name", arg2_18), var1_18.name)
	setText(arg0_18:findTF("value", arg2_18), arg0_18.char:GetAttrById(var0_18))
end

function var0_0.updateNature(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_PERSONALITY)) do
		local var0_19 = arg0_19.natureContent:GetChild(iter0_19 - 1)

		var0_19.name = iter1_19[1]

		setScrollText(arg0_19:findTF("Text", var0_19), arg0_19.config[iter1_19[1]].name .. " " .. iter1_19[2])
	end
end

function var0_0.Flush(arg0_20)
	if not arg0_20:GetLoaded() then
		return
	end

	arg0_20.educateProxy = getProxy(EducateProxy)
	arg0_20.char = arg0_20.educateProxy:GetCharData()

	arg0_20.attrsList1:align(#arg0_20.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MAJOR))

	arg0_20.buffList = arg0_20.educateProxy:GetBuffList()

	arg0_20.buffItemList:align(#arg0_20.buffList)
	arg0_20.attrsList2:align(#arg0_20.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MINOR))

	local var0_20 = arg0_20.char:GetPaintingName()

	setImageSprite(arg0_20.avatarImageTF, LoadSprite("educateavatar/" .. var0_20), true)
	arg0_20:updateNature()
	setImageSprite(arg0_20:findTF("mask/Image", arg0_20.avatarTF), LoadSprite("squareicon/" .. var0_20), true)
	setText(arg0_20:findTF("title/name/Text", arg0_20.page1), arg0_20.char:GetName())

	local var1_20 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_BUFF)

	setActive(arg0_20.buffContentTF, var1_20)
	setActive(arg0_20.buffLockTF, not var1_20)

	local var2_20 = EducateHelper.IsShowNature()

	setActive(arg0_20.attr2UnlockTF, var2_20)
	setActive(arg0_20.attr2LockTF, not var2_20)

	local var3_20 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ATTR_3)

	setActive(arg0_20.attr3UnlockTF, var3_20)
	setActive(arg0_20.attr3LockTF, not var3_20)

	local var4_20 = var3_20

	setActive(arg0_20:findTF("pagination", arg0_20.showPanelTF), var4_20)
	setActive(arg0_20.page2, var4_20)

	arg0_20.pageSnap.enabled = var4_20
end

function var0_0.OnDestroy(arg0_21)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._tf)
end

return var0_0
