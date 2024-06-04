local var0 = class("WSInventoryItem")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.bg = findTF(arg1, "bg")
	arg0.countTF = findTF(arg1, "bg/icon_bg/count")
	arg0.nameTF = findTF(arg1, "bg/name")
end

function var0.update(arg0, arg1)
	arg0.itemVO = arg1

	updateWorldItem(rtf(arg0.bg), arg1)

	arg0.go.name = tostring(arg1.id)

	setText(arg0.countTF, arg1.count > 0 and arg1.count or "")
	setText(arg0.nameTF, shortenString(getText(findTF(arg0.bg, "name")), 7))
end

function var0.clear(arg0)
	return
end

function var0.dispose(arg0)
	return
end

return var0
