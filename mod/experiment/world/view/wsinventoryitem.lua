local var0_0 = class("WSInventoryItem")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.bg = findTF(arg1_1, "bg")
	arg0_1.countTF = findTF(arg1_1, "bg/icon_bg/count")
	arg0_1.nameTF = findTF(arg1_1, "bg/name")
end

function var0_0.update(arg0_2, arg1_2)
	arg0_2.itemVO = arg1_2

	updateWorldItem(rtf(arg0_2.bg), arg1_2)

	arg0_2.go.name = tostring(arg1_2.id)

	setText(arg0_2.countTF, arg1_2.count > 0 and arg1_2.count or "")
	setText(arg0_2.nameTF, shortenString(getText(findTF(arg0_2.bg, "name")), 7))
end

function var0_0.clear(arg0_3)
	return
end

function var0_0.dispose(arg0_4)
	return
end

return var0_0
