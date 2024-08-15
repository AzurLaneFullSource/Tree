local var0_0 = class("TownUnlockLayer", import("view.base.BaseUI"))

var0_0.TYPE = {
	NEW = 1,
	LEVEL = 2
}

function var0_0.getUIName(arg0_1)
	return "TownUnlockUI"
end

function var0_0.init(arg0_2)
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("frame/content"), arg0_2:findTF("frame/content/tpl"))

	arg0_2.uiList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.unlockInfos[arg1_3 + 1].type
			local var1_3 = arg0_2.unlockInfos[arg1_3 + 1].id
			local var2_3 = pg.activity_town_work_level[var1_3].pic

			setImageSprite(arg0_2:findTF("icon", arg2_3), GetSpriteFromAtlas("ui/townui_atlas", var2_3), true)
			setActive(arg0_2:findTF("new", arg2_3), var0_3 == var0_0.TYPE.NEW)

			local var3_3 = var0_3 == var0_0.TYPE.NEW and i18n("town_unlcok_new") or i18n("town_unlcok_level")

			setText(arg0_2:findTF("tip/Text", arg2_3), var3_3)
		end
	end)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)

	arg0_4.unlockInfos = {}

	underscore.each(arg0_4.contextData.newIds, function(arg0_6)
		table.insert(arg0_4.unlockInfos, {
			type = var0_0.TYPE.NEW,
			id = arg0_6
		})
	end)
	underscore.each(arg0_4.contextData.limitIds, function(arg0_7)
		table.insert(arg0_4.unlockInfos, {
			type = var0_0.TYPE.LEVEL,
			id = arg0_7
		})
	end)
	arg0_4.uiList:align(#arg0_4.unlockInfos)
end

function var0_0.willExit(arg0_8)
	if arg0_8.contextData.removeFunc then
		arg0_8.contextData.removeFunc()

		arg0_8.contextData.removeFunc = nil
	end
end

return var0_0
