local var0_0 = class("NewEducateTarotCard")

var0_0.TYPE = {
	CURRENT = 1,
	CHOICE = 2,
	REPLACE = 3
}
var0_0.TYPE2TAG = {
	[var0_0.TYPE.CURRENT] = i18n("child2_tarot_tag_current"),
	[var0_0.TYPE.CHOICE] = "",
	[var0_0.TYPE.REPLACE] = i18n("child2_tarot_tag_replace")
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.whiteBgTF = arg0_1._tf:Find("bg_white")
	arg0_1.blueBgTF = arg0_1._tf:Find("bg_blue")
	arg0_1.iconTF = arg0_1._tf:Find("icon")
	arg0_1.simpleTF = arg0_1._tf:Find("simple")
	arg0_1.tagTF = arg0_1.simpleTF:Find("tag")
	arg0_1.tagText = arg0_1.tagTF:Find("Text"):GetComponent(typeof(Text))
	arg0_1.simpleNameText = arg0_1.simpleTF:Find("name/Text"):GetComponent(typeof(Text))
	arg0_1.simpleDescText = arg0_1.simpleTF:Find("desc/Text"):GetComponent(typeof(Text))
	arg0_1.detailTF = arg0_1._tf:Find("detail")
	arg0_1.detailNameText = arg0_1.detailTF:Find("name"):GetComponent(typeof(Text))
	arg0_1.detailDescText = arg0_1.detailTF:Find("desc/Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.type = arg2_2 or var0_0.TYPE.CHOICE
	arg0_2.id = arg1_2
	arg0_2.config = pg.child2_benefit_list[arg1_2]
	arg0_2.simpleNameText.text = arg0_2.config.name
	arg0_2.detailNameText.text = arg0_2.config.name
	arg0_2.simpleDescText.text = arg0_2.config.simple_desc
	arg0_2.detailDescText.text = arg0_2.config.desc

	LoadImageSpriteAsync("neweducateicon/" .. arg0_2.config.item_icon, arg0_2.iconTF)
	setActive(arg0_2.blueBgTF, arg0_2.type == var0_0.TYPE.CURRENT)
	setActive(arg0_2.whiteBgTF, arg0_2.type == var0_0.TYPE.CHOICE or arg0_2.type == var0_0.TYPE.REPLACE)
	setActive(arg0_2.tagTF, arg0_2.type ~= var0_0.TYPE.CHOICE)

	arg0_2.tagText.text = var0_0.TYPE2TAG[arg0_2.type]
end

function var0_0.UpdateDescMode(arg0_3, arg1_3)
	setActive(arg0_3.simpleTF, not arg1_3)
	setActive(arg0_3.detailTF, arg1_3)
end

function var0_0.Dispose(arg0_4)
	return
end

function var0_0.StaticShow(arg0_5, arg1_5)
	local var0_5 = pg.child2_benefit_list[arg1_5]

	setText(arg0_5:Find("simple/name/Text"), var0_5.name)
	setText(arg0_5:Find("detail/name"), var0_5.name)
	setText(arg0_5:Find("simple/desc/Text"), var0_5.simple_desc)
	setText(arg0_5:Find("detail/desc/Text"), var0_5.desc)
	LoadImageSpriteAsync("neweducateicon/" .. var0_5.item_icon, arg0_5:Find("icon"))
end

return var0_0
