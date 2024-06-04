local var0 = class("WSPortTaskDetail", import("...BaseEntity"))

var0.Fields = {
	task = "table",
	onCancel = "function",
	transform = "userdata"
}

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	onButton(arg0, var0, function()
		arg0.onCancel()
	end, SFX_CANCEL)
	onButton(arg0, var0:Find("top/btnBack"), function()
		arg0.onCancel()
	end, SFX_CANCEL)
end

function var0.UpdateTask(arg0, arg1)
	arg0.task = arg1

	local var0 = arg0.transform

	setText(var0:Find("window/desc"), arg1.config.description)

	local var1 = arg1:GetDisplayDrops()
	local var2 = var0:Find("window/scrollview/list")
	local var3 = var0:Find("window/scrollview/item")
	local var4 = UIItemList.New(var2, var3)

	var4:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			updateDrop(arg2, var0)
			setScrollText(arg2:Find("name_mask/name"), var0:getConfig("name"))
		end
	end)
	var4:align(#var1)
end

return var0
