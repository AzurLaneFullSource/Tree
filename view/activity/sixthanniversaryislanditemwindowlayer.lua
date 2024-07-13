local var0_0 = class("SixthAnniversaryIslandItemWindowLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryIslandItemWindow"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	setText(arg0_2._tf:Find("content/bottom/Text"), arg0_2.contextData.text)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
end

function var0_0.didEnter(arg0_4)
	local var0_4 = arg0_4.contextData.drop
	local var1_4 = arg0_4._tf:Find("content/main")
	local var2_4 = var0_4.count and {
		var0_4.count,
		true
	} or {
		var0_4:getOwnedCount()
	}
	local var3_4, var4_4 = unpack(var2_4)

	setActive(var1_4:Find("owner"), var4_4)

	if var4_4 then
		setText(var1_4:Find("owner"), i18n("word_own1") .. var3_4)
	end

	var0_4.count = nil

	updateDrop(var1_4:Find("icon/IconTpl"), var0_4)
	setText(var1_4:Find("line/name"), var0_4:getConfig("name"))
	setText(var1_4:Find("line/content/Text"), var0_4.desc or var0_4:getConfig("desc"))
end

function var0_0.willExit(arg0_5)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_5._tf)
end

return var0_0
