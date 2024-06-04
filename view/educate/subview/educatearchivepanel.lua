local var0 = class("EducateArchivePanel", import("...base.BaseSubView"))
local var1 = 0.005

function var0.getUIName(arg0)
	return "EducateArchivePanel"
end

function var0.OnInit(arg0)
	arg0.config = pg.child_attr
	arg0.foldPanelTF = arg0:findTF("fold_panel")
	arg0.showBtn = arg0:findTF("show_btn", arg0.foldPanelTF)
	arg0.showPanelTF = arg0:findTF("show_panel")
	arg0.showAnim = arg0.showPanelTF:GetComponent(typeof(Animation))
	arg0.showAnimEvent = arg0.showPanelTF:GetComponent(typeof(DftAniEvent))

	arg0.showAnimEvent:SetEndEvent(function()
		setActive(arg0.showPanelTF, false)
	end)

	arg0.blurBg = arg0:findTF("panel", arg0.showPanelTF)
	arg0.foldBtn = arg0:findTF("fold_btn", arg0.showPanelTF)
	arg0.pageSnap = arg0:findTF("panel/event", arg0.showPanelTF):GetComponent("HScrollSnap")

	arg0.pageSnap:Init()

	arg0.page1 = arg0:findTF("panel/event/content/page1", arg0.showPanelTF)

	setText(arg0:findTF("title/name_title/name", arg0.page1), i18n("child_archive_name"))
	setText(arg0:findTF("attr_title/Text", arg0.page1), i18n("child_attr_name1"))
	setText(arg0:findTF("buff_title/Text", arg0.page1), i18n("child_buff_name"))

	arg0.avatarImageTF = arg0:findTF("title/avatar", arg0.page1)
	arg0.attrsList1 = UIItemList.New(arg0:findTF("attrs/content", arg0.page1), arg0:findTF("attrs/tpl", arg0.page1))
	arg0.gradientBgTF = arg0:findTF("attrs/bg_gradient", arg0.page1)
	arg0.buffContentTF = arg0:findTF("buff/content", arg0.page1)
	arg0.buffItemList = UIItemList.New(arg0:findTF("buff/content/content", arg0.page1), arg0:findTF("buff/tpl", arg0.page1))
	arg0.buffLockTF = arg0:findTF("buff/lock", arg0.page1)
	arg0.page2 = arg0:findTF("panel/event/content/page2", arg0.showPanelTF)

	setText(arg0:findTF("attr_title/Text", arg0.page2), i18n("child_attr_name2"))

	arg0.attr3UnlockTF = arg0:findTF("attrs/unlock", arg0.page2)
	arg0.attr3LockTF = arg0:findTF("attrs/lock", arg0.page2)
	arg0.attrsList2 = UIItemList.New(arg0:findTF("content", arg0.attr3UnlockTF), arg0:findTF("tpl", arg0.attr3UnlockTF))
	arg0.attr2UnlockTF = arg0:findTF("nature/unlock", arg0.page2)
	arg0.attr2LockTF = arg0:findTF("nature/lock", arg0.page2)
	arg0.natureContent = arg0:findTF("content", arg0.attr2UnlockTF)
	arg0.avatarTF = arg0:findTF("avatar", arg0.page2)

	arg0:addListener()
	arg0:initAttrsPanel()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
		pbList = {
			arg0.blurBg
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER - 1
	})
	setActive(arg0.foldPanelTF, true)
	setActive(arg0.showPanelTF, false)

	if arg0.contextData and arg0.contextData.isShow then
		if arg0.contextData.isMainEnter then
			onDelayTick(function()
				arg0:showPanel()
			end, 0.396)
		else
			arg0:showPanel()
		end
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0.showBtn, function()
		arg0:showPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.foldBtn, function()
		arg0:hidePanel()
	end, SFX_PANEL)
end

function var0.showPanel(arg0)
	setActive(arg0.foldPanelTF, false)
	setActive(arg0.showPanelTF, true)
end

function var0.hidePanel(arg0)
	setActive(arg0.foldPanelTF, true)
	arg0.showAnim:Play("anim_educate_archive_show_out")
end

function var0.initAttrsPanel(arg0)
	arg0.attrsList1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateAttr1Item(arg1, arg2)
		end
	end)
	arg0.buffItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateBuffItem(arg1, arg2)
		end
	end)
	arg0.attrsList2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateAttr2Item(arg1, arg2)
		end
	end)
	arg0:Flush()
end

function var0.updateAttr1Item(arg0, arg1, arg2)
	local var0 = arg0.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MAJOR)[arg1 + 1][1]
	local var1 = arg0.config[var0]

	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0, arg0:findTF("icon_bg/icon", arg2), true)
	setScrollText(arg0:findTF("name_mask/name", arg2), var1.name)

	local var2, var3 = arg0.char:GetAttrInfo(var0)

	setText(arg0:findTF("grade/Text", arg2), var2)
	setText(arg0:findTF("value", arg2), var3)

	local var4 = EducateConst.GRADE_2_COLOR[var2][1]
	local var5 = EducateConst.GRADE_2_COLOR[var2][2]
	local var6 = arg0.gradientBgTF:GetChild(arg1)

	setImageColor(var6, Color.NewHex(var4))
	setImageColor(arg0:findTF("grade", arg2), Color.NewHex(var5))
end

function var0.updateBuffItem(arg0, arg1, arg2)
	local var0 = arg0.buffList[arg1 + 1]

	LoadImageSpriteAsync("educateprops/" .. var0:getConfig("icon"), arg0:findTF("icon", arg2))
	setText(arg0:findTF("time/Text", arg2), var0:GetReaminWeek() .. i18n("word_week"))
	onButton(arg0, arg2, function()
		arg0:showBuffBox(var0.id)
	end, SFX_PANEL)
end

function var0.showBuffBox(arg0, arg1)
	arg0:emit(EducateBaseUI.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_BUFF,
			id = arg1
		}
	})
end

function var0.updateAttr2Item(arg0, arg1, arg2)
	local var0 = arg0.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MINOR)[arg1 + 1][1]
	local var1 = arg0.config[var0]

	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0, arg0:findTF("icon", arg2), true)
	setText(arg0:findTF("name", arg2), var1.name)
	setText(arg0:findTF("value", arg2), arg0.char:GetAttrById(var0))
end

function var0.updateNature(arg0)
	for iter0, iter1 in ipairs(arg0.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_PERSONALITY)) do
		local var0 = arg0.natureContent:GetChild(iter0 - 1)

		var0.name = iter1[1]

		setScrollText(arg0:findTF("Text", var0), arg0.config[iter1[1]].name .. " " .. iter1[2])
	end
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0.educateProxy = getProxy(EducateProxy)
	arg0.char = arg0.educateProxy:GetCharData()

	arg0.attrsList1:align(#arg0.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MAJOR))

	arg0.buffList = arg0.educateProxy:GetBuffList()

	arg0.buffItemList:align(#arg0.buffList)
	arg0.attrsList2:align(#arg0.char:GetAttrGroupByType(EducateChar.ATTR_TYPE_MINOR))

	local var0 = arg0.char:GetPaintingName()

	setImageSprite(arg0.avatarImageTF, LoadSprite("educateavatar/" .. var0), true)
	arg0:updateNature()
	setImageSprite(arg0:findTF("mask/Image", arg0.avatarTF), LoadSprite("squareicon/" .. var0), true)
	setText(arg0:findTF("title/name/Text", arg0.page1), arg0.char:GetName())

	local var1 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_BUFF)

	setActive(arg0.buffContentTF, var1)
	setActive(arg0.buffLockTF, not var1)

	local var2 = EducateHelper.IsShowNature()

	setActive(arg0.attr2UnlockTF, var2)
	setActive(arg0.attr2LockTF, not var2)

	local var3 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_ATTR_3)

	setActive(arg0.attr3UnlockTF, var3)
	setActive(arg0.attr3LockTF, not var3)

	local var4 = var3

	setActive(arg0:findTF("pagination", arg0.showPanelTF), var4)
	setActive(arg0.page2, var4)

	arg0.pageSnap.enabled = var4
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
