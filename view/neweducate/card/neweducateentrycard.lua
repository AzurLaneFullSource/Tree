local var0_0 = class("NewEducateEntryCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.iconTF = arg0_1._tf:Find("icon/Image")
	arg0_1.levelText = arg0_1._tf:Find("level/Text"):GetComponent(typeof(Text))
	arg0_1.nameText = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.descText = arg0_1._tf:Find("desc/content/Text"):GetComponent(typeof(Text))
	arg0_1.countText = arg0_1._tf:Find("desc/content/effect"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.id = arg1_2
	arg0_2.config = pg.child2_benefit_list[arg1_2]
	arg0_2.levelText.text = GetRomanDigitPlus(arg0_2.config.rare)
	arg0_2.nameText.text = arg0_2.config.name
	arg0_2.descText.text = arg0_2.config.simple_desc
	arg0_2.countText.text = ""

	LoadImageSpriteAsync("neweducateicon/" .. arg0_2.config.item_icon, arg0_2.iconTF, true)

	local var0_2 = arg0_2.config.benefit_level > 1 and "bg_entry_2" or "bg_entry"

	LoadImageSpriteAtlasAsync("ui/neweducateentrycard_atlas", var0_2, arg0_2._tf:Find("icon"))
end

function var0_0.UpdateDescMode(arg0_3, arg1_3)
	arg0_3.descText.text = arg1_3 and arg0_3.config.desc or arg0_3.config.simple_desc
end

function var0_0.UpdateCountDesc(arg0_4)
	local var0_4 = getProxy(NewEducateProxy):GetCurChar():GetBenefitData()
	local var1_4 = Clone(arg0_4.config.count_desc)
	local var2_4 = string.gsub(var1_4, "{(%d+),%$val}", function(arg0_5)
		return var0_4:GetBuff(arg0_4.id):GetDisplayNum(arg0_5)
	end)
	local var3_4 = var0_4:GetDisplayCounterData(arg0_4.config.debuff_tag)

	if var3_4 then
		var2_4 = string.gsub(var2_4, "{(%d+),(%d+),(%d+)}", function(arg0_6, arg1_6, arg2_6)
			return var3_4:GetValue(arg0_6, arg1_6, arg2_6)
		end)
	end

	arg0_4.countText.text = var2_4
end

function var0_0.Dispose(arg0_7)
	return
end

function var0_0.StaticShow(arg0_8, arg1_8)
	local var0_8 = pg.child2_benefit_list[arg1_8]

	setText(arg0_8:Find("level/Text"), GetRomanDigitPlus(var0_8.rare))
	setText(arg0_8:Find("name"), var0_8.name)
	setText(arg0_8:Find("desc/content/Text"), var0_8.desc)
	setText(arg0_8:Find("desc/content/effect"), "")
	LoadImageSpriteAsync("neweducateicon/" .. var0_8.item_icon, arg0_8:Find("icon/Image"), true)

	local var1_8 = var0_8.benefit_level > 1 and "bg_entry_2" or "bg_entry"

	LoadImageSpriteAtlasAsync("ui/neweducateentrycard_atlas", var1_8, arg0_8:Find("icon"))
end

return var0_0
