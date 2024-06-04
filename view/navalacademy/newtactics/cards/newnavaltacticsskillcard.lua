local var0 = class("NewNavalTacticsSkillCard")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.icon = findTF(arg0._tf, "icon"):GetComponent(typeof(Image))
	arg0.descTxt = findTF(arg0._tf, "descView/desc"):GetComponent(typeof(Text))
	arg0.nextTxt = findTF(arg0._tf, "next"):GetComponent(typeof(Text))
end

function var0.Enable(arg0)
	setActive(arg0._tf, true)
end

function var0.Disable(arg0)
	setActive(arg0._tf, false)
end

function var0.Update(arg0, arg1, arg2)
	local var0 = arg1:GetName()

	changeToScrollText(arg0._tf:Find("name/Text"), var0)

	arg0.descTxt.text = arg1:GetTacticsDesc()

	local var1 = "Lv." .. arg1.level .. (arg2 and arg2 > 0 and "  <color=#A9F548FF>+" .. arg2 .. "</color>" or "")

	setText(arg0._tf:Find("name/level"), var1)

	if arg1:IsMaxLevel() then
		arg0.nextTxt.text = "MAX"
	else
		arg0.nextTxt.text = "<color=#A9F548FF>" .. arg1.exp .. "</color>/" .. arg1:GetNextLevelExp()
	end

	LoadSpriteAsync("skillicon/" .. arg1:GetIcon(), function(arg0)
		arg0.icon.sprite = arg0
	end)
end

function var0.Dispose(arg0)
	return
end

return var0
