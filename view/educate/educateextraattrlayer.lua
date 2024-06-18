local var0_0 = class("EducateExtraAttrLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateExtraAttrUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.char = getProxy(EducateProxy):GetCharData()
	arg0_3.attrList = arg0_3.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0_3.selectedIndex = 0
end

function var0_0.findUI(arg0_4)
	arg0_4.windowTF = arg0_4:findTF("window")
	arg0_4.attrUIList = UIItemList.New(arg0_4:findTF("content", arg0_4.windowTF), arg0_4:findTF("content/tpl", arg0_4.windowTF))
	arg0_4.avatarTF = arg0_4:findTF("avatar", arg0_4.windowTF)
	arg0_4.curPersonalText = arg0_4:findTF("Text", arg0_4.avatarTF)
	arg0_4.sureBtn = arg0_4:findTF("sure_btn", arg0_4.windowTF)
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.sureBtn, function()
		if arg0_5.selectedIndex == 0 then
			return
		end

		arg0_5:emit(var0_0.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_extraAttr_sure_tip"),
			onYes = function()
				arg0_5:emit(EducateExtraAttrMediator.ON_ATTR_ADD, {
					id = arg0_5.attrList[arg0_5.selectedIndex]
				})
				arg0_5:emit(var0_0.ON_CLOSE)
			end
		})
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_8)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf, {
		groupName = arg0_8:getGroupNameFromData(),
		weight = arg0_8:getWeightFromData() + 1
	})
	arg0_8.attrUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventInit then
			local var0_9 = pg.child_attr[arg0_8.attrList[arg1_9 + 1]]

			LoadImageSpriteAsync("educateprops/" .. var0_9.icon, arg0_8:findTF("icon", arg2_9), true)
			setText(arg0_8:findTF("name", arg2_9), var0_9.name)
			onButton(arg0_8, arg2_9, function()
				if arg0_8.selectedIndex == arg1_9 + 1 then
					return
				end

				arg0_8.selectedIndex = arg1_9 + 1

				arg0_8:updateView()
			end, SFX_PANEL)
		elseif arg0_9 == UIItemList.EventUpdate then
			setActive(arg0_8:findTF("selected", arg2_9), arg0_8.selectedIndex == arg1_9 + 1)
		end
	end)
	arg0_8:updateView()
end

function var0_0.updateView(arg0_11)
	arg0_11.attrUIList:align(#arg0_11.attrList)

	local var0_11 = arg0_11.char:GetPaintingName()
	local var1_11 = arg0_11.char:GetPersonalityId()

	setText(arg0_11.curPersonalText, "当前主导个性：" .. pg.child_attr[var1_11].name)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
