local var0 = class("SnapshotItem")

var0.NAME_COLOR = {
	"#FFFFFFFF",
	"#5A9BFFFF"
}

function var0.Ctor(arg0, arg1, arg2)
	arg0.go = arg1
	arg0.selected = arg2
	arg0.tr = arg1.transform
	arg0.btn = arg1:GetComponent("Button")
	arg0.nameTF = findTF(arg0.tr, "Text")
	arg0.nameTxt = arg0.nameTF:GetComponent("Text")
	arg0.unselectGo = findTF(arg0.tr, "unselect").gameObject
	arg0.selectedGo = findTF(arg0.tr, "selected").gameObject
	arg0.info = nil
	arg0.id = -1

	arg0.selectedGo:SetActive(false)
end

function var0.Update(arg0, arg1)
	arg0.info = arg1
	arg0.id = arg1.id

	arg0:flush()
end

function var0.UpdateSelected(arg0, arg1)
	arg0.selected = arg1

	arg0.unselectGo:SetActive(not arg0.selected)
	arg0.selectedGo:SetActive(arg0.selected)

	if arg0.selected then
		arg0.nameTxt.text = setColorStr(arg0.info.name, arg0.NAME_COLOR[2])
	else
		arg0.nameTxt.text = setColorStr(arg0.info.name, arg0.NAME_COLOR[1])
	end
end

function var0.HasInfo(arg0)
	return arg0.info ~= nil
end

function var0.GetID(arg0)
	return arg0.id
end

function var0.flush(arg0)
	arg0.nameTxt.text = arg0.info.name
end

function var0.SetEulerAngle(arg0, arg1)
	local var0 = rtf(arg0.nameTF).eulerAngles

	rtf(arg0.nameTF).eulerAngles = Vector3(0, 0, arg1)
end

function var0.RotateUI(arg0, arg1, arg2)
	LeanTween.rotateZ(go(arg0.nameTF), arg1, arg2)
end

return var0
