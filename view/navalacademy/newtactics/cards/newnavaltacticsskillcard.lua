local var0_0 = class("NewNavalTacticsSkillCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.icon = findTF(arg0_1._tf, "icon"):GetComponent(typeof(Image))
	arg0_1.descTxt = findTF(arg0_1._tf, "descView/desc"):GetComponent(typeof(Text))
	arg0_1.nextTxt = findTF(arg0_1._tf, "next"):GetComponent(typeof(Text))
end

function var0_0.Enable(arg0_2)
	setActive(arg0_2._tf, true)
end

function var0_0.Disable(arg0_3)
	setActive(arg0_3._tf, false)
end

function var0_0.Update(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:GetName()

	changeToScrollText(arg0_4._tf:Find("name/Text"), var0_4)

	arg0_4.descTxt.text = arg1_4:GetTacticsDesc()

	local var1_4 = "Lv." .. arg1_4.level .. (arg2_4 and arg2_4 > 0 and "  <color=#A9F548FF>+" .. arg2_4 .. "</color>" or "")

	setText(arg0_4._tf:Find("name/level"), var1_4)

	if arg1_4:IsMaxLevel() then
		arg0_4.nextTxt.text = "MAX"
	else
		arg0_4.nextTxt.text = "<color=#A9F548FF>" .. arg1_4.exp .. "</color>/" .. arg1_4:GetNextLevelExp()
	end

	LoadSpriteAsync("skillicon/" .. arg1_4:GetIcon(), function(arg0_5)
		arg0_4.icon.sprite = arg0_5
	end)
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
