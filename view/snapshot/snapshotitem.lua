local var0_0 = class("SnapshotItem")

var0_0.NAME_COLOR = {
	"#FFFFFFFF",
	"#5A9BFFFF"
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.go = arg1_1
	arg0_1.selected = arg2_1
	arg0_1.tr = arg1_1.transform
	arg0_1.btn = arg1_1:GetComponent("Button")
	arg0_1.nameTF = findTF(arg0_1.tr, "Text")
	arg0_1.nameTxt = arg0_1.nameTF:GetComponent("Text")
	arg0_1.unselectGo = findTF(arg0_1.tr, "unselect").gameObject
	arg0_1.selectedGo = findTF(arg0_1.tr, "selected").gameObject
	arg0_1.info = nil
	arg0_1.id = -1

	arg0_1.selectedGo:SetActive(false)
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.info = arg1_2
	arg0_2.id = arg1_2.id

	arg0_2:flush()
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	arg0_3.selected = arg1_3

	arg0_3.unselectGo:SetActive(not arg0_3.selected)
	arg0_3.selectedGo:SetActive(arg0_3.selected)

	if arg0_3.selected then
		arg0_3.nameTxt.text = setColorStr(arg0_3.info.name, arg0_3.NAME_COLOR[2])
	else
		arg0_3.nameTxt.text = setColorStr(arg0_3.info.name, arg0_3.NAME_COLOR[1])
	end
end

function var0_0.HasInfo(arg0_4)
	return arg0_4.info ~= nil
end

function var0_0.GetID(arg0_5)
	return arg0_5.id
end

function var0_0.flush(arg0_6)
	arg0_6.nameTxt.text = arg0_6.info.name
end

function var0_0.SetEulerAngle(arg0_7, arg1_7)
	local var0_7 = rtf(arg0_7.nameTF).eulerAngles

	rtf(arg0_7.nameTF).eulerAngles = Vector3(0, 0, arg1_7)
end

function var0_0.RotateUI(arg0_8, arg1_8, arg2_8)
	LeanTween.rotateZ(go(arg0_8.nameTF), arg1_8, arg2_8)
end

return var0_0
