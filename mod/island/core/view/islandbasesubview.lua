local var0_0 = class("IslandBaseSubView", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Init(arg0_1, ...)
	local var0_1 = packEx(...)

	PoolMgr.GetInstance():GetUI(arg0_1:GetUIName(), true, function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = arg0_2.transform

		var0_0.super.Init(arg0_1, arg0_2)
		setParent(arg0_2, pg.UIMgr.GetInstance().UIMain)
		arg0_2.transform:SetAsFirstSibling()
		arg0_1:FirstFlush()
		arg0_1:Flush(unpackEx(var0_1))
	end)
end

function var0_0.OnDispose(arg0_3)
	PoolMgr.GetInstance():ReturnUI(arg0_3:GetUIName(), arg0_3._go)
end

function var0_0.Show(arg0_4, ...)
	if arg0_4:IsEmpty() then
		arg0_4:Init(...)
	else
		setActive(arg0_4._go, true)
		arg0_4:Flush(...)
	end
end

function var0_0.Hide(arg0_5)
	setActive(arg0_5._go, false)
end

function var0_0.Disable(arg0_6)
	setActive(arg0_6._go, false)
end

function var0_0.Enable(arg0_7)
	setActive(arg0_7._go, true)
end

function var0_0.GetUIName(arg0_8)
	assert(false, "overwrite me")
end

function var0_0.Flush(arg0_9, ...)
	return
end

function var0_0.FirstFlush(arg0_10)
	return
end

return var0_0
