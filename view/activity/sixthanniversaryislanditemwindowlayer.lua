local var0 = class("SixthAnniversaryIslandItemWindowLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SixthAnniversaryIslandItemWindow"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setText(arg0._tf:Find("content/bottom/Text"), arg0.contextData.text)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.drop
	local var1 = arg0._tf:Find("content/main")
	local var2 = var0.count and {
		var0.count,
		true
	} or {
		var0:getOwnedCount()
	}
	local var3, var4 = unpack(var2)

	setActive(var1:Find("owner"), var4)

	if var4 then
		setText(var1:Find("owner"), i18n("word_own1") .. var3)
	end

	var0.count = nil

	updateDrop(var1:Find("icon/IconTpl"), var0)
	setText(var1:Find("line/name"), var0:getConfig("name"))
	setText(var1:Find("line/content/Text"), var0.desc or var0:getConfig("desc"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
