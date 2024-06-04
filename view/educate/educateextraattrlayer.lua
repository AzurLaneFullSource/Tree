local var0 = class("EducateExtraAttrLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateExtraAttrUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.attrList = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0.selectedIndex = 0
end

function var0.findUI(arg0)
	arg0.windowTF = arg0:findTF("window")
	arg0.attrUIList = UIItemList.New(arg0:findTF("content", arg0.windowTF), arg0:findTF("content/tpl", arg0.windowTF))
	arg0.avatarTF = arg0:findTF("avatar", arg0.windowTF)
	arg0.curPersonalText = arg0:findTF("Text", arg0.avatarTF)
	arg0.sureBtn = arg0:findTF("sure_btn", arg0.windowTF)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.sureBtn, function()
		if arg0.selectedIndex == 0 then
			return
		end

		arg0:emit(var0.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_extraAttr_sure_tip"),
			onYes = function()
				arg0:emit(EducateExtraAttrMediator.ON_ATTR_ADD, {
					id = arg0.attrList[arg0.selectedIndex]
				})
				arg0:emit(var0.ON_CLOSE)
			end
		})
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	arg0.attrUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = pg.child_attr[arg0.attrList[arg1 + 1]]

			LoadImageSpriteAsync("educateprops/" .. var0.icon, arg0:findTF("icon", arg2), true)
			setText(arg0:findTF("name", arg2), var0.name)
			onButton(arg0, arg2, function()
				if arg0.selectedIndex == arg1 + 1 then
					return
				end

				arg0.selectedIndex = arg1 + 1

				arg0:updateView()
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			setActive(arg0:findTF("selected", arg2), arg0.selectedIndex == arg1 + 1)
		end
	end)
	arg0:updateView()
end

function var0.updateView(arg0)
	arg0.attrUIList:align(#arg0.attrList)

	local var0 = arg0.char:GetPaintingName()
	local var1 = arg0.char:GetPersonalityId()

	setText(arg0.curPersonalText, "当前主导个性：" .. pg.child_attr[var1].name)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
